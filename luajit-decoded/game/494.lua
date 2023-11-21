SanctuaryArchemist = {}
SanctuaryMain.MODE_LIST.Archemist = SanctuaryArchemist
SanctuaryArchemistCategories = {}

copy_functions(ScrollView, SanctuaryArchemist)
copy_functions(ScrollView, SanctuaryArchemistCategories)

function HANDLER.sanctuary_alchemy(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_extract" then
		if SanctuaryArchemist.vars then
			if SanctuaryArchemist.vars.menu_index == "alchemy_equip" then
				TutorialGuide:procGuide("system_126")
				Inventory:forceOpenEquipMode()
			elseif SanctuaryArchemist.vars.menu_index == "alchemy_change" then
				Inventory:forceOpenEquipMaterialMode()
			end
		end
	else
		SanctuaryArchemist:select_detailTab(arg_1_1)
	end
end

function HANDLER.sanctuary_alchemy_bar(arg_2_0, arg_2_1)
	local var_2_0 = getParentWindow(arg_2_0)
	
	if arg_2_1 == "btn_go" then
		SanctuaryArchemist:checkItemCreatable(var_2_0.item)
	end
end

function HANDLER.sanctuary_alchemy_bar_p(arg_3_0, arg_3_1)
	local var_3_0 = getParentWindow(arg_3_0)
	
	if arg_3_1 == "btn_go" then
		SanctuaryArchemist:checkItemCreatable(var_3_0.item)
	end
end

function SanctuaryArchemistCategories.init(arg_4_0, arg_4_1)
	arg_4_0.vars = {}
	arg_4_0.vars.scrollview = arg_4_1
	
	arg_4_0:initScrollView(arg_4_1, 260, 92, {
		fit_height = true
	})
	
	arg_4_0.categories = {}
	arg_4_0.vars.reddots = {}
	
	for iter_4_0 = 1, 99 do
		local var_4_0, var_4_1, var_4_2, var_4_3, var_4_4, var_4_5, var_4_6, var_4_7, var_4_8, var_4_9 = DBN("recipe_category", tostring(iter_4_0), {
			"id",
			"sort",
			"category_name",
			"icon",
			"detail_group_1",
			"detail_group_1_name",
			"detail_group_2",
			"detail_group_2_name",
			"detail_group_3",
			"detail_group_3_name"
		})
		local var_4_10
		local var_4_11 = {
			id = var_4_0,
			sort = var_4_1 or 0,
			category_name = var_4_2,
			icon = var_4_3,
			detail_group_1 = var_4_4,
			detail_group_1_name = var_4_5,
			detail_group_2 = var_4_6,
			detail_group_2_name = var_4_7,
			detail_group_3 = var_4_8,
			detail_group_3_name = var_4_9
		}
		
		if not var_4_11.id then
			break
		end
		
		table.push(arg_4_0.categories, var_4_11)
		
		if var_4_5 ~= nil then
			local var_4_12 = SanctuaryArchemist.vars.wnd:getChildByName("tab")
			
			if_set(var_4_12:getChildByName("n_tab1"), "txt", T(var_4_5))
		end
		
		if var_4_7 ~= nil then
			local var_4_13 = SanctuaryArchemist.vars.wnd:getChildByName("tab")
			
			if_set(var_4_13:getChildByName("n_tab2"), "txt", T(var_4_7))
		end
	end
	
	table.sort(arg_4_0.categories, function(arg_5_0, arg_5_1)
		return arg_5_0.sort < arg_5_1.sort
	end)
	arg_4_0:updateScrollViewItems(arg_4_0.categories)
	arg_4_0:checkUnlock_categories()
end

function SanctuaryArchemistCategories.isActive(arg_6_0)
	return arg_6_0.vars ~= nil and get_cocos_refid(arg_6_0.vars.scrollview)
end

function SanctuaryArchemistCategories.select(arg_7_0, arg_7_1)
	if arg_7_1 and arg_7_1 == "alchemy_stone" then
		SanctuaryArchemist:saveNotiWeekID()
		SanctuaryArchemist:_updateCategoryNotis()
	end
	
	for iter_7_0, iter_7_1 in pairs(arg_7_0.ScrollViewItems) do
		if_set_visible(iter_7_1.control, "bg", arg_7_1 == iter_7_1.item.id)
	end
end

function SanctuaryArchemistCategories.onSelectScrollViewItemById(arg_8_0, arg_8_1)
	for iter_8_0, iter_8_1 in pairs(arg_8_0.ScrollViewItems or {}) do
		if iter_8_1.item.id == arg_8_1 then
			arg_8_0:onSelectScrollViewItem(iter_8_0, iter_8_1)
			
			return 
		end
	end
end

function SanctuaryArchemistCategories.onSelectScrollViewItem(arg_9_0, arg_9_1, arg_9_2)
	if arg_9_2.item.locked == false then
		arg_9_0.vars.category_name = arg_9_2.item.category_name
		
		SanctuaryArchemist:select_Tab(arg_9_2.item.id, arg_9_2.item.category_name)
	elseif arg_9_2.item.locked == true then
		local var_9_0 = "system_alchemy_category_desc"
		
		if arg_9_2.item.category_name == "set_equip_nm" then
			var_9_0 = "system_alchemy_category_equip_desc"
		end
		
		Dialog:msgBox(T(var_9_0), {
			fade_in = 250,
			title = T("system_alchemy_title")
		})
	end
end

function SanctuaryArchemistCategories.updateScrollViewItem(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = false
	
	if_set_sprite(arg_10_1, "icon", "img./" .. arg_10_2.icon .. "png")
	if_set_scale_fit_width_long_word(arg_10_1, "name", T(arg_10_2.category_name), 198)
	if_set(arg_10_1, "name", T(arg_10_2.category_name))
end

function SanctuaryArchemistCategories.getScrollViewItem(arg_11_0, arg_11_1)
	local var_11_0 = load_control("wnd/sanctuary_alchemy_menu.csb")
	
	if_set(var_11_0, "name", T(arg_11_1.id))
	if_set_sprite(var_11_0, "icon", "img/" .. arg_11_1.icon .. ".png")
	arg_11_0:updateScrollViewItem(var_11_0, arg_11_1)
	
	var_11_0.guide_tag = arg_11_1.id
	
	return var_11_0
end

function SanctuaryArchemistCategories.onLeave(arg_12_0)
	arg_12_0.categories = {}
	arg_12_0.vars = {}
end

function SanctuaryArchemistCategories.checkUnlock_categories(arg_13_0)
	if not arg_13_0.vars then
		return 
	end
	
	local var_13_0 = SanctuaryMain:GetLevels("Archemist")[2]
	
	for iter_13_0, iter_13_1 in pairs(arg_13_0.ScrollViewItems) do
		iter_13_1.item.locked = false
		
		if_set_visible(iter_13_1.control, "locked", true)
		if_set_opacity(iter_13_1.control, "n_condition_unlocked", 76.5)
		if_set_visible(iter_13_1.control, "_notification", false)
		
		if var_13_0 == 0 then
			if_set_visible(iter_13_1.control, "locked", true)
			if_set_visible(iter_13_1.control, "_notification", false)
			if_set_opacity(iter_13_1.control, "n_condition_unlocked", 76.5)
			
			iter_13_1.item.locked = true
		elseif var_13_0 == 1 then
			if iter_13_1.item.category_name == "set_stone_nm" then
				if_set_visible(iter_13_1.control, "locked", false)
				if_set_opacity(iter_13_1.control, "n_condition_unlocked", 255)
				
				iter_13_1.item.locked = false
			else
				if_set_visible(iter_13_1.control, "locked", true)
				if_set_visible(iter_13_1.control, "_notification", false)
				if_set_opacity(iter_13_1.control, "n_condition_unlocked", 76.5)
				
				iter_13_1.item.locked = true
			end
		elseif var_13_0 == 2 then
			if iter_13_1.item.category_name == "set_stone_nm" or iter_13_1.item.category_name == "set_material_nm" or iter_13_1.item.category_name == "set_equip_nm" then
				if_set_visible(iter_13_1.control, "locked", false)
				if_set_opacity(iter_13_1.control, "n_condition_unlocked", 255)
				
				iter_13_1.item.locked = false
			else
				if_set_visible(iter_13_1.control, "locked", true)
				if_set_visible(iter_13_1.control, "_notification", false)
				if_set_opacity(iter_13_1.control, "n_condition_unlocked", 76.5)
				
				iter_13_1.item.locked = true
			end
		else
			if_set_visible(iter_13_1.control, "locked", false)
			if_set_opacity(iter_13_1.control, "n_condition_unlocked", 255)
			
			iter_13_1.item.locked = false
		end
		
		if SanctuaryArchemistCategories.vars.reddots[iter_13_1.item.id] and SanctuaryArchemistCategories.vars.reddots[iter_13_1.item.id] == true and iter_13_1.item.locked == false then
			if_set_visible(iter_13_1.control, "_notification", true)
		end
		
		if iter_13_1.item.category_name == "set_equip_nm" and not Account:isUnlockExtract() then
			if_set_visible(iter_13_1.control, "locked", true)
			if_set_visible(iter_13_1.control, "_notification", false)
			if_set_opacity(iter_13_1.control, "n_condition_unlocked", 76.5)
			
			iter_13_1.item.locked = true
		end
	end
end

function HANDLER.sanctuary_alchemy_landing(arg_14_0, arg_14_1)
	SanctuaryArchemistMain:clickEvent(arg_14_0, arg_14_1)
end

SanctuaryArchemistMain = {}

function SanctuaryArchemistMain.onEnter(arg_15_0, arg_15_1)
	arg_15_0.vars = {}
	arg_15_0.vars.wnd = load_dlg("sanctuary_alchemy_landing", true, "wnd")
	
	arg_15_1:addChild(arg_15_0.vars.wnd)
	arg_15_0:updateUI()
	arg_15_0:setUIAnimation()
	TutorialGuide:procGuide("system_126")
	GrowthGuideNavigator:proc()
end

function SanctuaryArchemistMain.setUIAnimation(arg_16_0)
	local var_16_0 = arg_16_0.vars.wnd
	local var_16_1 = 300
	local var_16_2 = var_16_0:getChildByName("t_disc")
	local var_16_3 = var_16_2:getPositionX()
	local var_16_4 = var_16_2:getPositionY()
	
	var_16_2:setPositionY(-700)
	UIAction:Add(LOG(MOVE_TO(var_16_1, var_16_3, var_16_4)), var_16_2, "block")
	
	local var_16_5 = var_16_0:getChildByName("portrait")
	local var_16_6 = var_16_5:getPositionX()
	local var_16_7 = var_16_5:getPositionY()
	
	var_16_5:setPositionY(-700)
	UIAction:Add(LOG(MOVE_TO(var_16_1 - 80, var_16_6, var_16_7)), var_16_5, "block")
	
	local var_16_8 = var_16_0:getChildByName("bar_r")
	local var_16_9 = var_16_8:getPositionX()
	local var_16_10 = var_16_8:getPositionY()
	
	var_16_8:setPositionX(var_16_9 - 300)
	UIAction:Add(LOG(MOVE_TO(var_16_1, var_16_9, var_16_10)), var_16_8, "block")
	
	local var_16_11 = var_16_0:getChildByName("bar_l")
	local var_16_12 = var_16_11:getPositionX()
	local var_16_13 = var_16_11:getPositionY()
	
	var_16_11:setPositionX(var_16_12 + 300)
	UIAction:Add(LOG(MOVE_TO(var_16_1, var_16_12, var_16_13)), var_16_11, "block")
	
	local var_16_14 = arg_16_0.vars.wnd:getChildByName("n_normal")
	local var_16_15 = var_16_14:getChildByName("n_stone")
	local var_16_16 = var_16_14:getChildByName("n_material")
	local var_16_17 = var_16_14:getChildByName("n_equip")
	local var_16_18 = var_16_14:getChildByName("n_essence")
	local var_16_19 = var_16_14:getChildByName("n_exclusive")
	local var_16_20 = var_16_14:getChildByName("n_change")
	local var_16_21, var_16_22 = var_16_17:getPosition()
	local var_16_23 = var_16_15:getPositionX()
	local var_16_24 = var_16_16:getPositionX()
	local var_16_25 = var_16_18:getPositionX()
	local var_16_26 = var_16_19:getPositionX()
	local var_16_27 = var_16_20:getPositionX()
	
	var_16_15:setPositionX(var_16_21)
	var_16_16:setPositionX(var_16_21)
	var_16_18:setPositionX(var_16_21)
	var_16_19:setPositionX(var_16_21)
	var_16_20:setPositionX(var_16_21)
	UIAction:Add(LOG(MOVE_TO(var_16_1, var_16_23, var_16_22)), var_16_15, "block")
	UIAction:Add(LOG(MOVE_TO(var_16_1, var_16_24, var_16_22)), var_16_16, "block")
	UIAction:Add(LOG(MOVE_TO(var_16_1, var_16_25, var_16_22)), var_16_18, "block")
	UIAction:Add(LOG(MOVE_TO(var_16_1, var_16_26, var_16_22)), var_16_19, "block")
	UIAction:Add(LOG(MOVE_TO(var_16_1, var_16_27, var_16_22)), var_16_20, "block")
end

function SanctuaryArchemistMain.updateUI(arg_17_0)
	if not arg_17_0.vars or not get_cocos_refid(arg_17_0.vars.wnd) then
		return 
	end
	
	local var_17_0 = SanctuaryMain:GetLevels("Archemist")[2]
	local var_17_1 = arg_17_0.vars.wnd:getChildByName("n_normal")
	
	for iter_17_0 = 1, 99 do
		local var_17_2, var_17_3, var_17_4 = DBN("recipe_category", iter_17_0, {
			"id",
			"category_name",
			"unlock_condition"
		})
		
		if not var_17_2 then
			break
		end
		
		local var_17_5 = "n_" .. string.split(var_17_2, "_")[2]
		local var_17_6 = "btn_" .. string.split(var_17_2, "_")[2]
		local var_17_7 = var_17_1:getChildByName(var_17_5)
		
		if not get_cocos_refid(var_17_7) then
			break
		end
		
		local var_17_8 = true
		
		if not var_17_4 and var_17_0 > 0 then
			var_17_8 = false
		else
			local var_17_9 = string.split(var_17_4, "_")[3] or 999
			
			if var_17_0 >= tonumber(var_17_9) then
				var_17_8 = false
			end
		end
		
		if var_17_2 == "alchemy_equip" and not Account:isUnlockExtract() then
			var_17_8 = true
		end
		
		local var_17_10 = 255
		
		if var_17_8 then
			var_17_10 = 76.5
		end
		
		if_set(var_17_7, "t_name", T(var_17_3))
		if_set_visible(var_17_7, "icon_locked", var_17_8)
		if_set_opacity(var_17_7, var_17_6, var_17_10)
		
		var_17_7.id = var_17_2
		var_17_7.is_unlocked = var_17_8
		var_17_7.category_name = var_17_3
		
		if var_17_8 == false and var_17_2 == "alchemy_stone" then
			if_set_visible(var_17_7, "_notification", SanctuaryArchemist:_CheckNotification())
		else
			if_set_visible(var_17_7, "_notification", false)
		end
	end
	
	local var_17_11 = UIUtil:getPortraitAni("npc1089", {})
	
	if var_17_11 and not arg_17_0.vars.wnd:getChildByName("@portrait") then
		arg_17_0.vars.wnd:getChildByName("portrait"):addChild(var_17_11)
		var_17_11:setName("@portrait")
	end
end

function SanctuaryArchemistMain.onLeave(arg_18_0)
	if not arg_18_0.vars or not get_cocos_refid(arg_18_0.vars.wnd) then
		return 
	end
	
	arg_18_0.vars.wnd:removeFromParent()
	
	arg_18_0.vars = {}
	
	return true
end

function SanctuaryArchemistMain.clickEventById(arg_19_0, arg_19_1)
	if not DB("recipe_category", arg_19_1, "id") then
		return 
	end
	
	local var_19_0 = "n_" .. string.split(arg_19_1, "_")[2]
	local var_19_1 = arg_19_0.vars.wnd:findChildByName(var_19_0)
	local var_19_2 = "btn_" .. string.split(arg_19_1, "_")[2]
	
	arg_19_0:clickEvent(var_19_1:findChildByName(var_19_2), var_19_2)
end

function SanctuaryArchemistMain.clickEvent(arg_20_0, arg_20_1, arg_20_2)
	if not arg_20_1 or not arg_20_1:getParent() or not arg_20_2 then
		return 
	end
	
	local var_20_0 = arg_20_1:getParent()
	local var_20_1 = var_20_0.id or "alchemy_stone"
	local var_20_2 = var_20_0.category_name or "set_stone_nm"
	
	TutorialGuide:procGuide()
	
	if arg_20_2 == "btn_stone" and not var_20_0.is_unlocked then
		SanctuaryArchemist:show(nil, var_20_1, var_20_2)
	elseif arg_20_2 == "btn_material" and not var_20_0.is_unlocked then
		SanctuaryArchemist:show(nil, var_20_1, var_20_2)
	elseif arg_20_2 == "btn_equip" and not var_20_0.is_unlocked then
		SanctuaryArchemist:show(nil, var_20_1, var_20_2)
	elseif arg_20_2 == "btn_essence" and not var_20_0.is_unlocked then
		SanctuaryArchemist:show(nil, var_20_1, var_20_2)
	elseif arg_20_2 == "btn_exclusive" and not var_20_0.is_unlocked then
		SanctuaryArchemist:show(nil, var_20_1, var_20_2)
	elseif arg_20_2 == "btn_change" and not var_20_0.is_unlocked then
		SanctuaryArchemist:show(nil, var_20_1, var_20_2)
	else
		if var_20_0.is_unlocked then
			local var_20_3 = "system_alchemy_category_desc"
			
			if var_20_2 == "set_equip_nm" then
				var_20_3 = "system_alchemy_category_equip_desc"
			end
			
			Dialog:msgBox(T(var_20_3), {
				fade_in = 250,
				title = T("system_alchemy_title")
			})
		end
		
		return 
	end
	
	arg_20_0:onLeave()
end

function SanctuaryArchemist.onEnter(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	arg_21_0.vars = {}
	arg_21_0.vars.base_layer = arg_21_1
	
	SanctuaryArchemistMain:onEnter(arg_21_1)
	SoundEngine:play("event:/ui/sanctuary/enter_archemist")
end

function SanctuaryArchemist.procArgs(arg_22_0, arg_22_1)
	if not TutorialGuide:isPlayingTutorial() and arg_22_1.start_archemist_mode then
		SanctuaryArchemistMain:clickEventById(arg_22_1.start_archemist_mode)
	end
end

function SanctuaryArchemist.onLeave(arg_23_0, arg_23_1)
	TopBarNew:setCurrencies({
		"crystal",
		"gold",
		"stone"
	})
	TopBarNew:setEnableTopRight()
	
	if SanctuaryArchemistMain:onLeave() then
		return 
	end
	
	arg_23_0:close()
	
	arg_23_0.vars = {}
	
	SanctuaryArchemistCategories:onLeave()
end

function SanctuaryArchemist.close(arg_24_0)
	if not arg_24_0.vars or not get_cocos_refid(arg_24_0.vars.wnd) then
		return 
	end
	
	local var_24_0 = arg_24_0.vars.wnd
	local var_24_1 = var_24_0:getChildByName("LEFT")
	local var_24_2 = var_24_0:getChildByName("RIGHT")
	local var_24_3 = var_24_0:getChildByName("CENTER")
	
	UIAction:Add(RLOG(MOVE_TO(200, VIEW_BASE_LEFT + -500, 0)), var_24_1, "block")
	UIAction:Add(RLOG(MOVE_TO(200, 500, 0)), var_24_2, "block")
	UIAction:Add(RLOG(MOVE_TO(200, 0, -700)), var_24_3, "block")
	UIAction:Add(SEQ(DELAY(260), REMOVE()), var_24_0, "block")
end

function SanctuaryArchemist.onPushBackButton(arg_25_0)
	if AlchemistSelect.vars ~= nil and get_cocos_refid(AlchemistSelect.vars.wnd) then
		AlchemistSelect:onLeave()
	else
		SanctuaryMain:setMode("Main")
	end
end

function SanctuaryArchemist.show(arg_26_0, arg_26_1, arg_26_2, arg_26_3)
	local var_26_0 = load_dlg("sanctuary_alchemy", true, "wnd")
	local var_26_1 = arg_26_1 or arg_26_0.vars.base_layer
	local var_26_2 = arg_26_2 or "alchemy_stone"
	local var_26_3 = arg_26_3 or "set_stone_nm"
	
	arg_26_0.vars.wnd = var_26_0
	arg_26_0.vars.base_layer = var_26_1
	
	if var_26_1 then
		var_26_1:addChild(var_26_0)
	end
	
	TopBarNew:topbarUpdate(true)
	TopBarNew:setDisableTopRight()
	arg_26_0:initScrollView(arg_26_0.vars.wnd:findChildByName("scrollview"), 700, 120)
	SanctuaryArchemistCategories:init(arg_26_0.vars.wnd:getChildByName("scrollview_menu"))
	
	if SanctuaryArchemistCategories.vars then
		SanctuaryArchemistCategories.vars.category_name = var_26_3
	end
	
	arg_26_0:loadDB()
	arg_26_0:select_Tab(var_26_2, var_26_3)
	
	local var_26_4 = UIUtil:getPortraitAni("npc1089", {})
	
	if var_26_4 then
		arg_26_0.vars.wnd:getChildByName("n_portrait"):addChild(var_26_4)
		var_26_4:setName("@portrait")
		var_26_4:setScale(0.7)
	end
	
	local var_26_5 = var_26_0:getChildByName("LEFT")
	local var_26_6 = var_26_0:getChildByName("RIGHT")
	local var_26_7 = var_26_0:getChildByName("CENTER")
	
	if_set_visible(var_26_7, "btn_info", false)
	var_26_5:setPositionX(-300 + VIEW_BASE_LEFT)
	var_26_6:setPositionX(300 - VIEW_BASE_LEFT)
	var_26_7:setPositionY(-700)
	
	local var_26_8 = NOTCH_LEFT_WIDTH > 0 and NOTCH_LEFT_WIDTH or NOTCH_WIDTH
	local var_26_9 = DEBUG.ORIENTAION_TEST or getenv("device.orientation") == "landscape_left"
	local var_26_10 = var_26_9 and 0 or  / 2
	local var_26_11 = not var_26_9 and 0 or  / 2
	
	UIAction:Add(LOG(MOVE_TO(250, VIEW_BASE_LEFT + var_26_10, 0)), var_26_5, "block")
	UIAction:Add(LOG(MOVE_TO(250, 0 - VIEW_BASE_LEFT - var_26_11, 0)), var_26_6, "block")
	UIAction:Add(LOG(MOVE_TO(250, 0, 0)), var_26_7, "block")
	GrowthGuideNavigator:proc()
	
	return var_26_0
end

function SanctuaryArchemist.selectChangeStoneTab(arg_27_0)
	local var_27_0 = arg_27_0.vars.wnd:getChildByName("scrollview")
	
	if get_cocos_refid(var_27_0) then
		var_27_0:setContentSize({
			height = 514,
			width = var_27_0:getContentSize().width
		})
	end
	
	if_set_visible(arg_27_0.vars.wnd, "n_tab1", false)
	if_set_visible(arg_27_0.vars.wnd, "n_tab2", false)
	if_set_visible(arg_27_0.vars.wnd, "n_tab_job", false)
	
	local var_27_1 = arg_27_0.vars.wnd:getChildByName("n_equip_extract")
	
	if get_cocos_refid(var_27_1) then
		if_set_visible(var_27_1, nil, true)
		if_set(var_27_1, "disc_equip", T("ui_alchemist_change_desc"))
		if_set(var_27_1, "label", T("ui_alchemist_change_btn"))
		if_set_sprite(var_27_1, "icon_ee", "img/icon_menu_resstone.png")
	end
	
	arg_27_0:updateItems()
end

function SanctuaryArchemist.getCurrentMode(arg_28_0)
	if not arg_28_0.vars then
		return 
	end
	
	return arg_28_0.vars.current_mode
end

function SanctuaryArchemist.select_Tab(arg_29_0, arg_29_1, arg_29_2)
	if arg_29_0.vars.menu_index == arg_29_1 then
		return 
	end
	
	SanctuaryArchemistCategories:select(arg_29_1)
	
	arg_29_0.vars.current_mode = arg_29_1
	arg_29_0.vars.menu_index = arg_29_1
	
	if_set(arg_29_0.vars.wnd, "txt_menu_title", T(arg_29_2))
	
	local var_29_0 = arg_29_0.vars.wnd:getChildByName("CENTER")
	
	if_set_visible(var_29_0, "btn_info", false)
	
	if arg_29_1 == "alchemy_change" then
		arg_29_0:selectChangeStoneTab()
	else
		local var_29_1 = 578
		
		if arg_29_1 == "alchemy_exclusive" then
			var_29_1 = 520
		elseif arg_29_1 == "alchemy_equip" then
			var_29_1 = 514
		end
		
		arg_29_0.vars.wnd:getChildByName("scrollview"):setContentSize({
			width = arg_29_0.vars.wnd:getChildByName("scrollview"):getContentSize().width,
			height = var_29_1
		})
		
		if arg_29_1 == "alchemy_essence" then
			if_set_visible(arg_29_0.vars.wnd, "n_tab1", true)
			if_set_visible(arg_29_0.vars.wnd, "n_tab2", true)
			arg_29_0:select_detailTab("btn_main_tab2")
			
			local var_29_2, var_29_3 = DB("recipe_category", arg_29_1, {
				"detail_group_1_name",
				"detail_group_2_name"
			})
			
			if var_29_2 ~= nil then
				local var_29_4 = arg_29_0.vars.wnd:getChildByName("tab")
				
				if_set(var_29_4:getChildByName("n_tab1"), "txt", T(var_29_2))
			end
			
			if var_29_3 ~= nil then
				local var_29_5 = arg_29_0.vars.wnd:getChildByName("tab")
				
				if_set(var_29_5:getChildByName("n_tab2"), "txt", T(var_29_3))
			end
		elseif arg_29_1 == "alchemy_exclusive" then
			if_set_visible(arg_29_0.vars.wnd, "n_tab1", false)
			if_set_visible(arg_29_0.vars.wnd, "n_tab2", false)
			arg_29_0:select_detailTab("btn_job_tab1")
		else
			if_set_visible(arg_29_0.vars.wnd, "n_tab1", false)
			if_set_visible(arg_29_0.vars.wnd, "n_tab2", false)
			if_set_visible(arg_29_0.vars.wnd, "n_tab_job", false)
		end
		
		if_set_visible(arg_29_0.vars.wnd, "n_equip_extract", false)
		
		if arg_29_1 == "alchemy_equip" then
			local var_29_6 = arg_29_0.vars.wnd:getChildByName("n_equip_extract")
			
			if get_cocos_refid(var_29_6) then
				if_set_visible(var_29_6, nil, true)
				if_set(var_29_6, "disc_equip", T("ui_alchemist_extraction_desc"))
				if_set(var_29_6, "label", T("ui_extraction_btn_main"))
				if_set_sprite(var_29_6, "icon_ee", "img/icon_menu_extract.png")
			end
		end
		
		SanctuaryArchemist:updateItems()
		
		if arg_29_1 == "alchemy_equip" and not TutorialGuide:isClearedTutorial("system_126") and Account:isUnlockExtract() then
			TutorialGuide:startGuide("system_126")
		end
	end
end

function SanctuaryArchemist.select_detailTab(arg_30_0, arg_30_1)
	local var_30_0 = string.split(arg_30_1, "_")
	
	if not var_30_0[2] or not var_30_0[3] then
		return 
	end
	
	local var_30_1 = var_30_0[3]
	local var_30_2 = tonumber(string.sub(var_30_1, 4)) or 0
	
	if var_30_0[2] == "main" then
		if_set_visible(arg_30_0.vars.wnd, "n_tab1", true)
		if_set_visible(arg_30_0.vars.wnd, "n_tab2", true)
		if_set_visible(arg_30_0.vars.wnd, "n_tab_job", false)
		
		if var_30_2 == 1 then
			arg_30_0.vars.menu_index = "essence_grade_3"
			
			local var_30_3 = arg_30_0.vars.wnd:getChildByName("n_tab1")
			local var_30_4 = arg_30_0.vars.wnd:getChildByName("n_tab2")
			
			if_set_visible(var_30_3, "n_selected", true)
			if_set_visible(var_30_4, "n_selected", false)
		elseif var_30_2 == 2 then
			arg_30_0.vars.menu_index = "essence_grade_5"
			
			local var_30_5 = arg_30_0.vars.wnd:getChildByName("n_tab1")
			local var_30_6 = arg_30_0.vars.wnd:getChildByName("n_tab2")
			
			if_set_visible(var_30_5, "n_selected", false)
			if_set_visible(var_30_6, "n_selected", true)
		end
	elseif var_30_0[2] == "job" then
		if_set_visible(arg_30_0.vars.wnd, "n_tab1", false)
		if_set_visible(arg_30_0.vars.wnd, "n_tab2", false)
		if_set_visible(arg_30_0.vars.wnd, "n_tab_job", true)
		
		if var_30_2 == 1 then
			arg_30_0.vars.menu_index = "knight"
		elseif var_30_2 == 2 then
			arg_30_0.vars.menu_index = "warrior"
		elseif var_30_2 == 3 then
			arg_30_0.vars.menu_index = "ranger"
		elseif var_30_2 == 4 then
			arg_30_0.vars.menu_index = "assassin"
		elseif var_30_2 == 5 then
			arg_30_0.vars.menu_index = "manauser"
		elseif var_30_2 == 6 then
			arg_30_0.vars.menu_index = "mage"
		end
		
		for iter_30_0 = 1, 6 do
			local var_30_7 = arg_30_0.vars.wnd:getChildByName("btn_job_tab" .. iter_30_0)
			
			if not var_30_7 then
				break
			end
			
			if_set_visible(var_30_7, "bg_tab", var_30_2 == iter_30_0)
		end
	else
		if_set_visible(arg_30_0.vars.wnd, "n_tab1", false)
		if_set_visible(arg_30_0.vars.wnd, "n_tab2", false)
		if_set_visible(arg_30_0.vars.wnd, "n_tab_job", false)
		
		return 
	end
	
	arg_30_0:updateItems()
end

function SanctuaryArchemist.loadDB(arg_31_0)
	if not arg_31_0.vars.items then
		arg_31_0.vars.items = {}
		
		local var_31_0 = {}
		
		for iter_31_0 = 1, 9999 do
			local var_31_1, var_31_2, var_31_3, var_31_4, var_31_5, var_31_6, var_31_7, var_31_8, var_31_9, var_31_10, var_31_11, var_31_12, var_31_13, var_31_14, var_31_15, var_31_16, var_31_17, var_31_18, var_31_19, var_31_20, var_31_21, var_31_22, var_31_23, var_31_24, var_31_25, var_31_26 = DBN("alchemy_recipe", tostring(iter_31_0), {
				"id",
				"export_id",
				"category",
				"detail_group",
				"sort",
				"icon",
				"recipe_name",
				"recip_desc",
				"req_res_desc",
				"unlock_condition",
				"unlock_desc",
				"set_id",
				"quality_standard",
				"limit_period",
				"limit_count",
				"req_gold",
				"result_category",
				"result_0",
				"count_0",
				"result_1",
				"count_1",
				"result_2",
				"count_2",
				"res_category",
				"res_condition",
				"res_exclude"
			})
			local var_31_27 = {
				id = var_31_1,
				export_id = var_31_2,
				category = var_31_3,
				detail_group = var_31_4,
				sort = var_31_5 or 0,
				icon = var_31_6,
				recipe_name = var_31_7,
				recip_desc = var_31_8,
				req_res_desc = var_31_9,
				unlock_condition = var_31_10,
				unlock_desc = var_31_11,
				set_id = var_31_12,
				quality_standard = var_31_13,
				limit_period = var_31_14,
				limit_count = var_31_15,
				req_gold = var_31_16,
				o_req_gold = var_31_16,
				result_category = var_31_17,
				result_0 = var_31_18,
				count_0 = var_31_19,
				result_1 = var_31_20,
				count_1 = var_31_21,
				result_2 = var_31_22,
				count_2 = var_31_23,
				res_category = var_31_24,
				res_condition = var_31_25,
				res_exclude = var_31_26
			}
			
			if var_31_27 == nil or not var_31_27.id then
				break
			end
			
			if var_31_27.category == "alchemy_essence" then
				if (var_31_27.detail_group == "essence_grade_3" or var_31_27.detail_group == "essence_grade_5") and arg_31_0.vars.items[var_31_27.detail_group] == nil then
					arg_31_0.vars.items[var_31_27.detail_group] = {}
				end
				
				table.push(arg_31_0.vars.items[var_31_27.detail_group], var_31_27)
			elseif var_31_27.category == "alchemy_exclusive" then
				local var_31_28 = var_31_18
				
				if var_31_28 then
					local var_31_29, var_31_30, var_31_31, var_31_32 = DB("equip_item", var_31_28, {
						"name",
						"exclusive_skill",
						"exclusive_unit",
						"role"
					})
					
					if not arg_31_0.vars.items[var_31_32] then
						arg_31_0.vars.items[var_31_32] = {}
					end
					
					var_31_27.exclusive_unit = var_31_31
					var_31_27.name = var_31_29
					var_31_27.exclusive_skill = var_31_30
					var_31_27.id = var_31_28
					var_31_27.db_id = var_31_1
					
					table.push(arg_31_0.vars.items[var_31_32], var_31_27)
				end
			else
				if arg_31_0.vars.items[var_31_27.category] == nil then
					arg_31_0.vars.items[var_31_27.category] = {}
				end
				
				table.push(arg_31_0.vars.items[var_31_27.category], var_31_27)
			end
			
			if Account:getItemCount(var_31_27.unlock_condition) > 0 and arg_31_0:checkNewItem(var_31_27.unlock_condition) == true then
				var_31_27.newItem = true
				SanctuaryArchemistCategories.vars.reddots[var_31_27.category] = true
			end
			
			if var_31_27.category == "alchemy_stone" and arg_31_0:_CheckNotification() then
				var_31_27.newItem = true
				SanctuaryArchemistCategories.vars.reddots[var_31_27.category] = true
			end
		end
		
		for iter_31_1, iter_31_2 in pairs(arg_31_0.vars.items) do
			table.sort(iter_31_2, function(arg_32_0, arg_32_1)
				return arg_32_0.sort < arg_32_1.sort
			end)
		end
	end
end

function SanctuaryArchemist._updateCategoryNotis(arg_33_0)
	if not arg_33_0.vars then
		return 
	end
	
	local var_33_0 = {}
	
	for iter_33_0 = 1, 99 do
		local var_33_1, var_33_2 = DBN("alchemy_recipe", tostring(iter_33_0), {
			"id",
			"category"
		})
		
		if not var_33_1 then
			break
		end
		
		local var_33_3 = {
			id = var_33_1,
			category = var_33_2
		}
		
		if var_33_3.category == "alchemy_stone" then
			if arg_33_0:_CheckNotification() then
				SanctuaryArchemistCategories.vars.reddots[var_33_3.category] = true
			else
				SanctuaryArchemistCategories.vars.reddots[var_33_3.category] = false
			end
		end
	end
	
	SanctuaryArchemistCategories:checkUnlock_categories()
end

function SanctuaryArchemist.updateItems(arg_34_0)
	local var_34_0 = arg_34_0.vars.items[arg_34_0.vars.menu_index] or {}
	
	arg_34_0:updateScrollViewItems(var_34_0)
	arg_34_0:jumpToPercent(0)
end

function SanctuaryArchemist.getScrollViewItem(arg_35_0, arg_35_1)
	local var_35_0 = arg_35_1.category == "alchemy_exclusive" and "sanctuary_alchemy_bar_p" or "sanctuary_alchemy_bar"
	
	arg_35_1.control = load_dlg(var_35_0, true, "wnd")
	
	arg_35_0:updateScrollViewItem(arg_35_1.control, arg_35_1)
	
	return arg_35_1.control
end

function SanctuaryArchemist.getRestTime(arg_36_0, arg_36_1, arg_36_2)
	arg_36_2 = arg_36_2 or os.time()
	
	local var_36_0 = "al:" .. arg_36_1
	
	if string.find(arg_36_1, "exc") then
		var_36_0 = "al:alc_eq_" .. arg_36_1
	end
	
	local var_36_1 = AccountData.limits[var_36_0]
	
	if not var_36_1 or not var_36_1.expire_tm or arg_36_2 > var_36_1.expire_tm then
		return nil
	end
	
	return var_36_1.expire_tm - arg_36_2
end

function SanctuaryArchemist.getRestCount(arg_37_0, arg_37_1)
	local var_37_0 = arg_37_1.limit_count
	local var_37_1 = var_37_0
	local var_37_2 = "al:" .. arg_37_1.id
	
	if arg_37_1.category == "alchemy_exclusive" then
		var_37_2 = "al:" .. arg_37_1.db_id
	end
	
	if AccountData.limits[var_37_2] and var_37_0 then
		var_37_1 = var_37_0 - Account:getLimitCount(var_37_2)
	end
	
	return var_37_1, var_37_0
end

local function var_0_0(arg_38_0, arg_38_1)
	if not get_cocos_refid(arg_38_0) then
		return 
	end
	
	if arg_38_1.limit_period == "day" then
		if_set(arg_38_0, nil, T("alchemy_period_day", {
			count = arg_38_1.limit_count
		}))
		
		return 
	end
	
	if arg_38_1.limit_period == "week" then
		if_set(arg_38_0, nil, T("alchemy_period_week", {
			count = arg_38_1.limit_count
		}))
		
		return 
	end
	
	if arg_38_1.limit_period == "month" then
		if_set(arg_38_0, nil, T("alchemy_period_month", {
			count = arg_38_1.limit_count
		}))
		
		return 
	end
	
	if arg_38_1.limit_period == "account" then
		if_set(arg_38_0, nil, T("alchemy_period_only_once", {
			count = arg_38_1.limit_count
		}))
		
		return 
	end
end

local function var_0_1(arg_39_0)
	for iter_39_0, iter_39_1 in pairs(SanctuaryArchemistCategories.ScrollViewItems) do
		if arg_39_0 == iter_39_1.item.id then
			return iter_39_1.item.locked
		end
	end
	
	return true
end

local function var_0_2(arg_40_0, arg_40_1, arg_40_2)
	if not get_cocos_refid(arg_40_0) then
		return 
	end
	
	local var_40_0 = getChildByPath(arg_40_0, "txt_name")
	
	if not get_cocos_refid(var_40_0) then
		return 
	end
	
	local var_40_1 = arg_40_0:getChildByName("txt_count_info")
	
	if not get_cocos_refid(var_40_1) then
		return 
	end
	
	local var_40_2 = arg_40_0:getChildByName("n_item")
	
	if not get_cocos_refid(var_40_2) then
		return 
	end
	
	if_set_opacity(arg_40_0, nil, arg_40_1.creatable and 255 or 76.5)
	if_set_visible(arg_40_0, nil, true)
	if_set_visible(arg_40_0, "_new", false)
	if_set_visible(var_40_0, nil, not arg_40_2)
	if_set(arg_40_0, "txt_kind", T("set_change_nm"))
	if_set(var_40_0, nil, T(arg_40_1.recipe_name))
	var_0_0(var_40_1, arg_40_1)
	UIUtil:getRewardIcon(nil, arg_40_1.icon, {
		no_tooltip = false,
		parent = var_40_2,
		set_fx = arg_40_1.set_id
	})
end

local function var_0_3(arg_41_0, arg_41_1, arg_41_2, arg_41_3)
	if not get_cocos_refid(arg_41_0) then
		return 
	end
	
	if_set_opacity(arg_41_0, nil, arg_41_1.creatable and 255 or 76.5)
	if_set(arg_41_0, "txt_material", T("material_change_res_desc"))
	if_set(arg_41_0, "txt_go", T("ui_alchemist_manufacture_btn"))
	
	if arg_41_1.limit_count then
		if_set(arg_41_0, "label_0", arg_41_2 .. "/" .. arg_41_3)
	else
		if_set_visible(arg_41_0, "Image_21", false)
		
		local var_41_0 = arg_41_0:getChildByName("txt_go")
		
		if get_cocos_refid(var_41_0) then
			local var_41_1 = var_41_0:getPositionX() or 0
			
			var_41_0:setPositionX(var_41_1 - 35)
		end
	end
end

local function var_0_4(arg_42_0, arg_42_1, arg_42_2)
	if_set_visible(arg_42_0, nil, arg_42_2)
	
	if not arg_42_1.creatable then
		if_set(arg_42_0, "label", T(arg_42_1.unlock_desc))
		if_set_visible(arg_42_0, "cm_icon_etcinfor_11", false)
	end
end

function SanctuaryArchemist.updateAlchemyChangeScrollViewItem(arg_43_0, arg_43_1, arg_43_2)
	local var_43_0 = 1
	local var_43_1 = 1
	
	if arg_43_2.limit_count then
		var_43_0, var_43_1 = arg_43_0:getRestCount(arg_43_2)
	end
	
	local var_43_2 = var_0_1(arg_43_2.category)
	
	arg_43_2.creatable = not var_43_2 and var_43_0 > 0
	arg_43_2.control.item = arg_43_2
	
	var_0_2(arg_43_1:getChildByName("_LEFT"), arg_43_2, var_43_2)
	var_0_3(arg_43_1:getChildByName("_RIGHT"), arg_43_2, var_43_0, var_43_1)
	var_0_4(arg_43_1:getChildByName("n_locked"), arg_43_2, var_43_2)
	SanctuaryArchemistCategories:checkUnlock_categories()
	
	return arg_43_2.control
end

function SanctuaryArchemist.updateScrollViewItem(arg_44_0, arg_44_1, arg_44_2)
	if arg_44_2.category == "alchemy_change" then
		return arg_44_0:updateAlchemyChangeScrollViewItem(arg_44_1, arg_44_2)
	end
	
	local var_44_0 = arg_44_1:getChildByName("_LEFT")
	local var_44_1 = arg_44_1:getChildByName("n_locked")
	
	if arg_44_2.category == "alchemy_essence" then
		var_44_0 = arg_44_1:getChildByName("_LEFT_catalyst")
		
		if_set_visible(arg_44_1, "_LEFT", false)
		if_set_visible(arg_44_1, "_LEFT_catalyst", true)
		if_set_visible(arg_44_1, "n_locked", false)
		if_set_visible(arg_44_1, "n_locked_catalyst", true)
		
		var_44_1 = arg_44_1:getChildByName("n_locked_catalyst")
		
		local var_44_2 = string.gsub(arg_44_2.id, "alc_", "") or " "
		local var_44_3 = Account:getItemCount(var_44_2) or 0
		
		if_set(var_44_0, "t_count", var_44_3)
		
		if var_44_3 <= 0 then
			var_44_0:getChildByName("t_have"):setTextColor(tocolor("#666666"))
			var_44_0:getChildByName("t_count"):setTextColor(tocolor("#666666"))
			var_44_0:getChildByName("t_count"):enableOutline(tocolor("#666666"), 1)
		else
			var_44_0:getChildByName("t_have"):setTextColor(tocolor("#6BC11B"))
			var_44_0:getChildByName("t_count"):setTextColor(tocolor("#6BC11B"))
			var_44_0:getChildByName("t_count"):enableOutline(tocolor("##6BC11B"), 1)
		end
	else
		if_set_visible(arg_44_1, "_LEFT", true)
		if_set_visible(arg_44_1, "_LEFT_catalyst", false)
		if_set_visible(arg_44_1, "n_locked", true)
		if_set_visible(arg_44_1, "n_locked_catalyst", false)
	end
	
	local var_44_4 = var_44_0:findChildByName("n_item")
	local var_44_5 = getChildByPath(var_44_0, "txt_name")
	local var_44_6 = "set_stone_nm"
	local var_44_7 = arg_44_2.category == "alchemy_exclusive"
	local var_44_8 = arg_44_2.category == "alchemy_equip"
	
	if SanctuaryArchemistCategories.vars and SanctuaryArchemistCategories.vars.category_name then
		var_44_6 = SanctuaryArchemistCategories.vars.category_name
	end
	
	local var_44_9, var_44_10 = arg_44_0:getRestCount(arg_44_2)
	local var_44_11 = true
	local var_44_12 = false
	local var_44_13 = true
	
	if not var_44_9 or not var_44_10 then
		var_44_9 = 1
		var_44_10 = 1
		var_44_13 = false
	end
	
	if arg_44_2.unlock_condition ~= nil then
		if Account:getItemCount(arg_44_2.unlock_condition) > 0 then
			var_44_11 = false
			
			if arg_44_0:checkNewItem(arg_44_2.unlock_condition) == true or arg_44_2.newItem and arg_44_2.newItem == true then
				arg_44_2.newItem = false
				var_44_12 = true
				SanctuaryArchemistCategories.vars.reddots[arg_44_2.category] = true
			else
				SanctuaryArchemistCategories.vars.reddots[arg_44_2.category] = false
			end
		end
		
		if_set_visible(var_44_0, "_new", var_44_12)
	else
		for iter_44_0, iter_44_1 in pairs(SanctuaryArchemistCategories.ScrollViewItems) do
			if arg_44_2.category == iter_44_1.item.id then
				var_44_11 = iter_44_1.item.locked
			end
		end
		
		if_set_visible(var_44_0, "_new", false)
	end
	
	if_set(var_44_5, nil, T(arg_44_2.recipe_name))
	if_set_visible(var_44_1, nil, var_44_11)
	if_set_visible(var_44_5, nil, not var_44_11)
	if_set_visible(var_44_0, "txt_count_info", not var_44_11)
	if_set(var_44_0, "txt_kind", T(var_44_6))
	var_0_0(var_44_0:getChildByName("txt_count_info"), arg_44_2)
	
	local var_44_14 = "ui_alchemist_req_resources_" .. arg_44_2.res_category
	
	if var_44_6 == "set_exclusive_nm" then
		if_set(arg_44_1, "txt_material", T("ui_alchemist_req_resources_exclusive"))
	else
		if_set(arg_44_1, "txt_material", T(var_44_14))
	end
	
	if var_44_11 == false and var_44_9 > 0 then
		if_set_visible(var_44_0, "txt_kind", true)
		if_set_visible(var_44_0, "txt_count_info", true)
		if_set_opacity(var_44_0, nil, 255)
		if_set_opacity(arg_44_1, "_RIGHT", 255)
		
		arg_44_2.creatable = true
	else
		if_set_opacity(var_44_0, nil, 76.5)
		if_set_opacity(arg_44_1, "_RIGHT", 76.5)
		if_set(var_44_1, "label", T(arg_44_2.unlock_desc))
		
		if var_44_11 == true then
			if_set_visible(var_44_0, "txt_kind", false)
			if_set_visible(var_44_0, "txt_count_info", false)
		end
		
		if arg_44_2.unlock_desc == nil then
			if_set_visible(var_44_0, "txt_kind", true)
			if_set_visible(var_44_0, "txt_count_info", true)
			if_set_visible(var_44_5, nil, true)
			if_set_visible(var_44_1, "cm_icon_etcinfor_11", false)
		end
		
		arg_44_2.creatable = false
	end
	
	if_set(arg_44_1, "txt_go", T("ui_alchemist_manufacture_btn"))
	
	if var_44_13 then
		if_set(arg_44_1, "label_0", var_44_9 .. "/" .. var_44_10)
	else
		if_set_visible(arg_44_1, "Image_21", false)
		
		local var_44_15 = arg_44_1:getChildByName("txt_go"):getPositionX() or 0
		
		arg_44_1:getChildByName("txt_go"):setPositionX(var_44_15 - 35)
	end
	
	if not var_44_7 then
		local var_44_16 = UIUtil:getRewardIcon(nil, arg_44_2.icon, {
			no_tooltip = false,
			parent = var_44_4
		})
		
		if var_44_8 then
			if_set_visible(arg_44_1, "txt_count_info", false)
			
			local var_44_17 = arg_44_1:getChildByName("txt_kind")
			
			if var_44_17 and var_44_5 then
				var_44_5:setPositionY(var_44_5:getPositionY() - 17)
				var_44_17:setPositionY(var_44_17:getPositionY() - 17)
			end
		end
	elseif var_44_7 then
		local var_44_18 = {
			no_popup = true,
			name = false,
			no_lv = true,
			no_role = true,
			no_grade = true,
			parent = arg_44_1:getChildByName("mob_icon")
		}
		
		UIUtil:getUserIcon(arg_44_2.exclusive_unit, var_44_18)
		
		local var_44_19 = arg_44_0.scrollview.STRETCH_INFO.stretch_ratio
		
		if var_44_19 then
			local var_44_20 = arg_44_1:getContentSize()
			local var_44_21 = var_44_20.width * var_44_19
			
			resetControlPosAndSize(arg_44_1, var_44_21, var_44_20.width, true)
		end
		
		if_set(var_44_5, nil, T(arg_44_2.name))
		
		if var_44_5:getStringNumLines() >= 2 then
			local var_44_22 = arg_44_1:getChildByName("txt_count_info")
			local var_44_23 = arg_44_1:getChildByName("txt_kind")
			local var_44_24 = arg_44_1:getChildByName("n_count_move")
			local var_44_25 = arg_44_1:getChildByName("n_name_move")
			local var_44_26 = arg_44_1:getChildByName("n_kind_move")
			
			if var_44_22 and var_44_23 and var_44_24 and var_44_25 and var_44_26 then
				var_44_22:setPosition(var_44_24:getPosition())
				var_44_5:setPosition(var_44_25:getPosition())
				var_44_23:setPosition(var_44_26:getPosition())
			end
		end
		
		UIUtil:getRewardIcon("equip", arg_44_2.id, {
			grade = 5,
			no_lv = true,
			no_tooltip = false,
			parent = var_44_4
		})
	end
	
	arg_44_2.control.item = arg_44_2
	
	SanctuaryArchemistCategories:checkUnlock_categories()
	
	return arg_44_2.control
end

function SanctuaryArchemist.checkItemCreatable(arg_45_0, arg_45_1)
	if arg_45_1.creatable then
		AlchemistSelect:onEnter(arg_45_1)
	elseif arg_45_0:getRestCount(arg_45_1) == 0 then
		balloon_message_with_sound("msg_alchemist_count_limit")
	else
		local var_45_0 = false
		
		for iter_45_0, iter_45_1 in pairs(SanctuaryArchemistCategories.ScrollViewItems) do
			if arg_45_1.category == iter_45_1.item.id then
				var_45_0 = iter_45_1.item.locked
				
				break
			end
		end
		
		if var_45_0 == true then
			balloon_message_with_sound("system_alchemy_category_desc")
		else
			balloon_message_with_sound("msg_alchemist_unlock_recipe")
		end
	end
end

function SanctuaryArchemist.updateAll(arg_46_0)
	if not arg_46_0.vars or not arg_46_0.vars.items or not arg_46_0.vars.menu_index then
		return 
	end
	
	SanctuaryArchemistCategories:checkUnlock_categories()
	arg_46_0:select_Tab("alchemy_stone", "set_stone_nm")
end

function SanctuaryArchemist.getFirstScrollView(arg_47_0)
	return arg_47_0.ScrollViewItems[1].control:getChildByName("btn_go")
end

function SanctuaryArchemist.updateCurScrollview(arg_48_0)
	if not arg_48_0.vars or not arg_48_0.vars.items or not arg_48_0.vars.menu_index then
		return 
	end
	
	for iter_48_0, iter_48_1 in pairs(arg_48_0.vars.items) do
		local var_48_0 = iter_48_1
		
		if iter_48_0 == arg_48_0.vars.menu_index then
			arg_48_0:createScrollViewItems(var_48_0)
		end
	end
end

function SanctuaryArchemist.checkNewItem(arg_49_0, arg_49_1)
	if arg_49_1 == nil then
		return false
	end
	
	local var_49_0 = "archemist." .. arg_49_1
	
	if Account:getConfigData(var_49_0) == nil then
		SAVE:setTempConfigData(var_49_0, true)
		
		return true
	end
	
	return false
end

function SanctuaryArchemist.CheckNotification(arg_50_0)
	if TutorialCondition:isEnable("system_071") then
		return true
	end
	
	if not UnlockSystem:isUnlockSystem(UNLOCK_ID.SANC_ALCHEMIST) then
		return false
	end
	
	if arg_50_0:_CheckNotification() then
		return true
	end
	
	return SanctuaryMain:GetTotalLevel("Archemist") < 9 and Account:getCurrency("stone") > 0
end

function SanctuaryArchemist._CheckNotification(arg_51_0)
	local var_51_0 = false
	
	if (Account:getConfigData("SanctuaryArchemist.noti_week_id") or 0) == Account:serverTimeWeekLocalDetail() then
		return false
	end
	
	for iter_51_0 = 1, 999 do
		local var_51_1, var_51_2, var_51_3 = DBN("alchemy_recipe", iter_51_0, {
			"id",
			"category",
			"limit_count"
		})
		
		if not var_51_1 then
			break
		end
		
		if var_51_2 == "alchemy_stone" then
			local var_51_4, var_51_5 = arg_51_0:getRestCount({
				id = var_51_1,
				cateogory = var_51_2,
				limit_count = var_51_3
			})
			
			if var_51_4 and var_51_4 >= 1 then
				return true
			end
		end
	end
	
	return false
end

function SanctuaryArchemist.saveNotiWeekID(arg_52_0)
	local var_52_0 = Account:getConfigData("SanctuaryArchemist.noti_week_id") or 0
	local var_52_1 = Account:serverTimeWeekLocalDetail()
	
	if var_52_0 == var_52_1 then
		return 
	end
	
	SAVE:setTempConfigData("SanctuaryArchemist.noti_week_id", var_52_1)
end

function SanctuaryArchemist.rateInfoItem(arg_53_0, arg_53_1, arg_53_2, arg_53_3, arg_53_4, arg_53_5)
	local var_53_0 = 0
	
	for iter_53_0, iter_53_1 in pairs(arg_53_2) do
		local var_53_1
		
		if iter_53_1.type == "alc_grade_1" then
			var_53_1 = T("alc_ma_eq_rate_grade_1")
		elseif iter_53_1.type == "alc_grade_2" then
			var_53_1 = T("alc_ma_eq_rate_grade_2")
		elseif iter_53_1.type == "alc_grade_3" then
			var_53_1 = T("alc_ma_eq_rate_grade_3")
		end
		
		if var_53_1 then
			var_53_0 = var_53_0 + 1
			
			local var_53_2 = load_control("wnd/gacha_info_pet_item_bar.csb")
			
			if_set_visible(var_53_2, "n_grade", true)
			if_set_visible(var_53_2, "txt_grade_ratio", true)
			if_set_visible(var_53_2, "n_item", false)
			if_set(var_53_2, "txt_grade_name", var_53_1)
			if_set(var_53_2, "txt_grade_ratio", (iter_53_1.rate or "-") .. "%")
			var_53_2:setPosition(arg_53_5, arg_53_4 - 25 * var_53_0)
			arg_53_1:addChild(var_53_2)
		end
		
		for iter_53_2, iter_53_3 in pairs(arg_53_3[iter_53_1.type]) do
			var_53_0 = var_53_0 + 1
			
			local var_53_3 = load_control("wnd/gacha_info_pet_item_bar.csb")
			
			if_set_visible(var_53_3, "n_grade", false)
			if_set_visible(var_53_3, "n_item", true)
			if_set(var_53_3, "txt_item_name", T(iter_53_3.text))
			if_set(var_53_3, "txt_item_ratio", (iter_53_3.rate or "-") .. "%")
			var_53_3:setPosition(arg_53_5, arg_53_4 - 25 * var_53_0)
			arg_53_1:addChild(var_53_3)
		end
	end
	
	if var_53_0 < 25 then
		var_53_0 = 25
	end
	
	return 25 * var_53_0
end

function SanctuaryArchemist.popupEquipRate(arg_54_0)
	if get_cocos_refid(arg_54_0.vars.wnd_rate_info) then
		Dialog:msgBox(nil, {
			dlg = arg_54_0.vars.wnd_rate_info
		})
		
		return 
	end
	
	local var_54_0 = {}
	local var_54_1 = {}
	
	for iter_54_0 = 1, 9999 do
		local var_54_2 = {}
		
		var_54_2.id, var_54_2.category, var_54_2.text, var_54_2.rate = DBN("alc_ma_eq_rate", iter_54_0, {
			"id",
			"category",
			"text",
			"rate"
		})
		
		if not var_54_2.id then
			break
		end
		
		var_54_2.rate = var_54_2.rate * 100
		
		if not var_54_0[var_54_2.category] then
			var_54_0[var_54_2.category] = {}
			
			table.push(var_54_1, {
				rate = 0,
				type = var_54_2.category
			})
		end
		
		table.push(var_54_0[var_54_2.category], var_54_2)
		
		for iter_54_1, iter_54_2 in pairs(var_54_1) do
			if iter_54_2.type == var_54_2.category then
				iter_54_2.rate = iter_54_2.rate + var_54_2.rate
				
				break
			end
		end
	end
	
	arg_54_0.vars.wnd_rate_info = load_dlg("gacha_info_wide", true, "wnd")
	
	if_set(arg_54_0.vars.wnd_rate_info, "txt_title", T("alc_ma_eq_rate_title"))
	
	local var_54_3 = arg_54_0.vars.wnd_rate_info:getChildByName("scrollview")
	
	var_54_3:setContentSize(465, 565)
	var_54_3:setInnerContainerSize({
		width = 465,
		height = 300
	})
	
	local var_54_4 = load_control("wnd/gacha_info_pet_header_bar.csb")
	
	var_54_4:setPosition(0, 20)
	
	for iter_54_3 = 1, 6 do
		if_set_visible(var_54_4, "n_item" .. iter_54_3, false)
	end
	
	if_set_visible(var_54_4, "txt_title", false)
	if_set_visible(var_54_4, "bg", false)
	if_set_visible(var_54_4, "t_h1", false)
	if_set_visible(var_54_4, "t_h2", false)
	if_set_visible(var_54_4, "txt_random_shop", true)
	
	local var_54_5 = var_54_4:getChildByName("txt_random_shop")
	
	if_set(var_54_4, "txt_random_shop", T("alc_ma_eq_rate_info"))
	
	local var_54_6 = UIUtil:setTextAndReturnHeight(var_54_5, var_54_5:getString()) - 60
	
	var_54_5:setPositionY(var_54_5:getPositionY() - var_54_6 / 2)
	var_54_3:addChild(var_54_4)
	
	local var_54_7 = var_54_4:getChildByName("bar")
	local var_54_8 = var_54_4:getChildByName("n_item1"):getPositionY() + (40 - var_54_6)
	
	var_54_7:setPositionY(var_54_8)
	
	local var_54_9 = var_54_3:getInnerContainerSize()
	local var_54_10 = table.count(var_54_1)
	
	for iter_54_4, iter_54_5 in pairs(var_54_0) do
		var_54_10 = var_54_10 + table.count(iter_54_5)
	end
	
	local var_54_11 = 25 * var_54_10 + 110 + var_54_6
	local var_54_12 = var_54_11 - 380
	
	arg_54_0:rateInfoItem(var_54_3, var_54_1, var_54_0, var_54_11 - 100 - var_54_6, 15)
	var_54_4:setPosition(0, var_54_12)
	var_54_3:setInnerContainerSize({
		width = var_54_9.width,
		height = var_54_11
	})
	
	if get_cocos_refid(arg_54_0.vars.wnd_rate_info) then
		Dialog:msgBox(nil, {
			dlg = arg_54_0.vars.wnd_rate_info
		})
	end
end
