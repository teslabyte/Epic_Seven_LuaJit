PromotionBanner = {}

local function var_0_0()
	if IS_ANDROID_BASED_PLATFORM and ContentDisable:byAlias("amazon_prime_aos_btn") then
		return true
	end
	
	if PLATFORM == "iphoneos" and ContentDisable:byAlias("amazon_prime_ios_btn") then
		return true
	end
	
	return false
end

local function var_0_1(arg_2_0)
	for iter_2_0, iter_2_1 in pairs(arg_2_0) do
		if string.find(iter_2_1.link, "btn=btn_promotion") then
			return iter_2_0
		end
	end
end

local function var_0_2(arg_3_0)
	local var_3_0 = var_0_1(arg_3_0)
	
	if not var_3_0 then
		return arg_3_0
	end
	
	table.remove(arg_3_0, var_3_0)
	
	return arg_3_0
end

local function var_0_3(arg_4_0)
	if not get_cocos_refid(arg_4_0) then
		return false
	end
	
	if not arg_4_0:isVisible() then
		return false
	end
	
	if get_cocos_refid(arg_4_0:getParent()) then
		return var_0_3(arg_4_0:getParent())
	end
	
	return true
end

function PromotionBanner.onScrollViewTouchDown(arg_5_0, arg_5_1, arg_5_2)
	if not get_cocos_refid(arg_5_0.wnd) or not var_0_3(arg_5_0.wnd) then
		arg_5_0:clearTouchInfo()
		
		return 
	end
	
	arg_5_0.begin_tm = systick()
	arg_5_0.touch_anchor = arg_5_1:getLocation()
	arg_5_0.cur_touch = arg_5_0.touch_anchor
	
	arg_5_2:stopPropagation()
end

function PromotionBanner.clearTouchInfo(arg_6_0)
	arg_6_0.begin_tm = nil
	arg_6_0.cur_touch = nil
	arg_6_0.touch_anchor = nil
end

function PromotionBanner.onScrollViewTouchMoveEvent(arg_7_0, arg_7_1, arg_7_2)
	if not var_0_3(arg_7_0.wnd) then
		arg_7_0:clearTouchInfo()
		
		return 
	end
	
	arg_7_0.cur_touch = arg_7_1:getLocation()
	
	arg_7_2:stopPropagation()
	
	if arg_7_0.begin_tm and arg_7_0.cur_touch and arg_7_0.touch_anchor then
		local var_7_0 = arg_7_0.cur_touch.x - arg_7_0.touch_anchor.x
		
		if math.abs(var_7_0) > 10 then
			arg_7_0:clearTouchInfo()
		end
	end
end

function PromotionBanner.checkPushTime(arg_8_0)
	if TutorialGuide:isPlayingTutorial() then
		return 
	end
	
	if not arg_8_0.touch_anchor then
		return 
	end
	
	if not arg_8_0.begin_tm then
		return 
	end
	
	if not var_0_3(arg_8_0.wnd) then
		arg_8_0:clearTouchInfo()
		
		return 
	end
	
	if systick() - arg_8_0.begin_tm > 1000 then
		arg_8_0:clearTouchInfo()
		
		arg_8_0.on_block = true
		
		Dialog:msgBox(T("ui_lobby_banner_hide"), {
			yesno = true,
			handler = function()
				arg_8_0.on_block = false
				
				Account:setPromotionBannerHideTime()
				if_set_visible(arg_8_0.wnd, nil, false)
			end,
			cancel_handler = function()
				arg_8_0.on_block = false
			end
		})
		
		return 
	end
end

function PromotionBanner.set(arg_11_0, arg_11_1, arg_11_2)
	copy_functions(ScrollView, PromotionBanner)
	
	arg_11_0.wnd = arg_11_1
	arg_11_0.on_block = false
	arg_11_0.scrollview = arg_11_1:getChildByName("banner_scrollview")
	arg_11_0.scroll_sz = arg_11_0.scrollview:getContentSize()
	
	arg_11_0:initScrollView(arg_11_0.scrollview, arg_11_0.scroll_sz.width, arg_11_0.scroll_sz.height, {
		force_horizontal = true,
		onScroll = function(arg_12_0, arg_12_1, arg_12_2)
			arg_11_0:onScroll(arg_12_0, arg_12_1, arg_12_2)
		end
	})
	
	if var_0_0() then
		arg_11_2 = var_0_2(arg_11_2)
	end
	
	arg_11_0.items = table.clone(arg_11_2)
	
	table.delete_i(arg_11_0.items, function(arg_13_0, arg_13_1)
		return arg_13_1.rolling_invisible == 1
	end)
	arg_11_0:applyItemsByLang()
	
	arg_11_0.last_scroll_tick = systick()
	
	arg_11_0:createScrollViewItems(arg_11_0.items)
	arg_11_0.scrollview:setScrollStep(arg_11_0.scroll_sz.width)
	arg_11_0.scrollview:setScrollSpeed(8)
	arg_11_0.scrollview:setMovementFactor(0.1)
	
	if #arg_11_2 > 1 then
		Scheduler:addSlow(arg_11_0.scrollview, arg_11_0.onChangeBanner, arg_11_0)
		Scheduler:add(arg_11_0.scrollview, arg_11_0.checkPushTime, arg_11_0):setName("checkPushTime")
	end
	
	arg_11_0.index = 1
	
	arg_11_0:createPageMarker()
	arg_11_0:updateRemainTime()
	arg_11_1:setVisible(#arg_11_0.items > 0)
	
	if Account:isDiffCurrentBannerInfo() then
		Account:resetPromotionBannerHideTime()
	end
	
	local var_11_0 = Account:getPromotionBannerHideTime()
	
	if var_11_0 and var_11_0 > 0 and var_11_0 > os.time() then
		arg_11_1:setVisible(false)
	end
end

function PromotionBanner.removeAllSellPackage(arg_14_0, arg_14_1)
	local function var_14_0(arg_15_0)
		if not AccountData.package_limits then
			return 
		end
		
		if arg_15_0[1] ~= "epic7" then
			return 
		end
		
		local var_15_0 = string.split(arg_15_0[2], "?")
		
		if var_15_0[1] ~= "promotion" or not var_15_0[2] then
			return 
		end
		
		local var_15_1 = "sh:" .. var_15_0[2]
		local var_15_2 = AccountData.package_limits[var_15_1]
		
		if not var_15_2 then
			return 
		end
		
		return var_15_2.limit_count <= var_15_2.count
	end
	
	for iter_14_0, iter_14_1 in pairs(arg_14_1) do
		local var_14_1 = string.split(iter_14_1.link, "://")
		
		if var_14_0(var_14_1) then
			iter_14_1.del_flag = true
		end
	end
	
	for iter_14_2 = #arg_14_1, 1, -1 do
		if arg_14_1[iter_14_2].del_flag then
			table.remove(arg_14_1, iter_14_2)
		end
	end
end

function PromotionBanner.applyItemsByLang(arg_16_0)
	for iter_16_0, iter_16_1 in pairs(arg_16_0.items or {}) do
		for iter_16_2, iter_16_3 in pairs(iter_16_1) do
			if table.isInclude({
				"img"
			}, iter_16_2) then
				arg_16_0.items[iter_16_0][iter_16_2] = UIUtil:translateByLang(iter_16_3)
			end
		end
	end
end

function PromotionBanner.createPageMarker(arg_17_0)
	if not get_cocos_refid(arg_17_0.wnd) then
		return 
	end
	
	local var_17_0 = arg_17_0.wnd:getChildByName("n_banner_num")
	
	if_set_visible(var_17_0, "web_num", true)
	
	for iter_17_0 = 1, 10 do
		local var_17_1 = arg_17_0.items[iter_17_0] ~= nil
		
		if_set_visible(var_17_0, "page" .. iter_17_0, var_17_1)
		if_set_visible(var_17_0, "page" .. iter_17_0 .. "_off", var_17_1)
		
		local var_17_2 = arg_17_0:isVisibleIndicator(iter_17_0)
		
		if_set_visible(var_17_0, "web" .. iter_17_0, var_17_2)
		if_set_visible(var_17_0, "web" .. iter_17_0 .. "_off", var_17_2)
		if_set_visible(var_17_0, "mark" .. iter_17_0, var_17_2)
	end
	
	arg_17_0:updatePageMarker()
end

function PromotionBanner.updatePageMarker(arg_18_0)
	local var_18_0 = math.max(0, math.floor(0 - arg_18_0.scrollview:getInnerContainerPosition().x))
	local var_18_1 = math.round(var_18_0 / arg_18_0.scroll_sz.width)
	local var_18_2 = #arg_18_0.items - var_18_1
	
	for iter_18_0 = 1, 10 do
		local var_18_3 = iter_18_0 == var_18_2
		
		if_set_visible(arg_18_0.wnd, "page" .. iter_18_0, var_18_3)
		
		local var_18_4 = var_18_3 and arg_18_0:isVisibleIndicator(iter_18_0)
		
		if_set_visible(arg_18_0.wnd, "web" .. iter_18_0, var_18_4)
	end
end

function PromotionBanner.updateRemainTime(arg_19_0)
	if not get_cocos_refid(arg_19_0.wnd) then
		return 
	end
	
	local var_19_0 = math.max(0, math.floor(0 - arg_19_0.scrollview:getInnerContainerPosition().x))
	local var_19_1 = math.round(var_19_0 / arg_19_0.scroll_sz.width)
	local var_19_2 = #arg_19_0.items - var_19_1
	local var_19_3 = arg_19_0:getRemainTime(var_19_2)
	local var_19_4 = arg_19_0.wnd:getChildByName("n_time")
	
	if var_19_3 then
		if_set(var_19_4, "t_time", sec_to_full_string(var_19_3, nil, {
			count = 1
		}))
	end
	
	if_set_visible(var_19_4, nil, var_19_3)
end

function PromotionBanner.onScroll(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	if arg_20_3 == 10 or arg_20_3 == 9 then
		arg_20_0:updatePageMarker()
		arg_20_0:updateRemainTime()
	end
	
	arg_20_0.last_scroll_tick = systick()
end

function PromotionBanner.onChangeBanner(arg_21_0)
	local var_21_0 = systick()
	
	if var_21_0 - arg_21_0.last_scroll_tick < 4000 then
		return 
	end
	
	arg_21_0.last_scroll_tick = var_21_0
	arg_21_0.index = arg_21_0.index + 1
	
	if arg_21_0.index > #arg_21_0.items then
		arg_21_0.index = 1
	end
	
	arg_21_0:scrollToIndex(arg_21_0.index)
end

function PromotionBanner.getScrollViewItem(arg_22_0, arg_22_1)
	if arg_22_1.node ~= nil then
		return arg_22_1.node
	end
	
	local var_22_0 = totable(arg_22_1.img)
	local var_22_1
	
	if var_22_0.id then
		local var_22_2 = var_22_0.id
		local var_22_3 = (SubStoryUtil:getScheduleInfo(var_22_0.id) or {}).append
		
		if var_22_3 then
			var_22_2 = var_22_2 .. "_ent_" .. var_22_3
		else
			var_22_2 = var_22_2 .. "_ent"
		end
		
		local var_22_4 = DBT("substory_bg", var_22_2, {
			"logo_position",
			"logo",
			"icon_enter"
		})
		
		if not var_22_4.icon_enter then
			Log.e("banner", "wrong sub-story id", var_22_0.id)
			
			return 
		end
		
		if var_22_4.logo_position then
			var_22_4.logo_position = totable(var_22_4.logo_position)
		end
		
		if var_22_4.logo then
			var_22_4.logo = totable(var_22_4.logo)
		end
		
		var_22_1 = SubstoryUIUtil:createBanner("banner/" .. var_22_4.icon_enter, var_22_4.logo.img, var_22_4.logo_position)
		
		var_22_1:getChildByName("panel_clipping"):setTouchEnabled(false)
	elseif var_22_0.bi then
		local var_22_5 = string.sub(var_22_0.bi, 11, 16)
		local var_22_6 = (SubStoryUtil:getScheduleInfo(var_22_5) or {}).append
		
		if var_22_6 then
			var_22_5 = var_22_5 .. "_hom_" .. var_22_6
		else
			var_22_5 = var_22_5 .. "_hom"
		end
		
		local var_22_7 = DB("substory_bg", var_22_5, {
			"logo_position"
		})
		
		if var_22_7 then
			var_22_7 = totable(var_22_7)
		else
			Log.e("banner", "wrong sub-story id", var_22_7)
			
			return 
		end
		
		var_22_1 = SubstoryUIUtil:createBanner(var_22_0.banner, var_22_0.bi, var_22_7)
		
		var_22_1:getChildByName("panel_clipping"):setTouchEnabled(false)
	elseif var_22_0.banner then
		var_22_1 = cc.Sprite:create(var_22_0.banner)
		
		if not var_22_1 or not get_cocos_refid(var_22_1) then
			print("err image can't found!! ", var_22_0.banner)
			table.print(var_22_0)
			
			return 
		end
	end
	
	return var_22_1
end

function PromotionBanner.scrollToIndex(arg_23_0, arg_23_1)
	arg_23_0.index = arg_23_1
	arg_23_1 = #arg_23_0.items + 1 - arg_23_1
	
	local var_23_0 = 100 * (arg_23_1 - 1 / #arg_23_0.items - 1)
	
	arg_23_0.scrollview:scrollToPercentHorizontal(var_23_0, 1, true)
end

function PromotionBanner.onSelectScrollViewItem(arg_24_0, arg_24_1, arg_24_2)
	arg_24_0:clearTouchInfo()
	
	if arg_24_0.on_block then
		arg_24_0.on_block = false
		
		return 
	end
	
	arg_24_0:saveShowedIndicator(#arg_24_0.items + 1 - arg_24_1)
	arg_24_0:createPageMarker()
	UIAction:Add(SEQ(DELAY(500)), arg_24_0.wnd, "block")
	movetoPath(arg_24_2.item.link)
end

function PromotionBanner.isVisibleIndicator(arg_25_0, arg_25_1)
	arg_25_1 = #arg_25_0.items + 1 - arg_25_1
	
	local var_25_0 = arg_25_0.items[arg_25_1]
	
	if not var_25_0 then
		return false
	end
	
	if not var_25_0.id then
		return false
	end
	
	local var_25_1 = not (SAVE:get("web_indicator" .. var_25_0.id, 0) == AccountData.server_time.today_day_id) and var_25_0.indicator
	
	if var_25_0.link == "epic7://lobby?ui_event=lobby&btn=btn_promotion" then
		var_25_1 = var_25_1 and EventPlatform:isVisibleAmazonIndicator()
	end
	
	return var_25_1
end

function PromotionBanner.saveShowedIndicator(arg_26_0, arg_26_1)
	arg_26_1 = #arg_26_0.items + 1 - arg_26_1
	
	local var_26_0 = arg_26_0.items[arg_26_1] and arg_26_0.items[arg_26_1].id
	
	if not var_26_0 then
		return 
	end
	
	SAVE:set("web_indicator" .. var_26_0, AccountData.server_time.today_day_id)
end

function PromotionBanner.getRemainTime(arg_27_0, arg_27_1)
	arg_27_1 = #arg_27_0.items + 1 - arg_27_1
	
	local var_27_0 = arg_27_0.items[arg_27_1]
	
	if not var_27_0 then
		return false
	end
	
	if not var_27_0.event_mission then
		return false
	end
	
	return EventMissionUtil:getRemainTime(var_27_0.event_mission)
end
