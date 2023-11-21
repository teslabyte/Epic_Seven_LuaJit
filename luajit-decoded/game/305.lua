GachaUnit = GachaUnit or {}

function GachaUnit.updateGachaElementNoti(arg_1_0)
	local function var_1_0()
		if not arg_1_0.vars then
			return 0
		end
		
		if not arg_1_0.vars.ei_colors then
			return 0
		end
		
		local var_2_0 = 0
		
		for iter_2_0 = 1, 5 do
			local var_2_1 = "ticket" .. arg_1_0.vars.ei_colors[iter_2_0] .. "35"
			local var_2_2 = "ticket" .. arg_1_0.vars.ei_colors[iter_2_0] .. "45"
			local var_2_3 = Account:getCurrency(var_2_1)
			local var_2_4 = Account:getCurrency(var_2_2)
			
			var_2_0 = var_2_0 + var_2_3 + var_2_4
		end
		
		return var_2_0
	end
	
	local function var_1_1()
		if not arg_1_0.vars then
			return false
		end
		
		if not arg_1_0.vars.ei_colors then
			return false
		end
		
		for iter_3_0 = 1, 5 do
			local var_3_0 = "ticket" .. arg_1_0.vars.ei_colors[iter_3_0] .. "35"
			
			if Account:getCurrency(var_3_0) > 4 then
				return true
			end
			
			local var_3_1 = "ticket" .. arg_1_0.vars.ei_colors[iter_3_0] .. "45"
			
			if Account:getCurrency(var_3_1) > 4 then
				return true
			end
		end
		
		return false
	end
	
	if not arg_1_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_1_0.vars.ui_right_menu_wnd) then
		return 
	end
	
	local var_1_2 = arg_1_0.vars.ui_right_menu_wnd:getChildByName("n_gacha_element")
	
	if not var_1_2 then
		return 
	end
	
	local var_1_3 = SAVE:get("gacha_element_token_num", 0)
	local var_1_4 = var_1_0()
	local var_1_5 = arg_1_0.vars.gacha_mode == "gacha_element"
	
	if var_1_5 then
		SAVE:set("gacha_element_token_num", var_1_4)
	end
	
	local var_1_6 = var_1_3 ~= var_1_4
	
	var_1_6 = var_1_6 and var_1_1()
	var_1_6 = var_1_6 and not var_1_5
	
	if_set_visible(var_1_2, "icon_noti", var_1_6)
end

function GachaUnit.enterGachaElement(arg_4_0)
	arg_4_0:setTitle(nil, nil)
	
	arg_4_0.vars.gacha_mode = "gacha_element"
	
	GachaIntroduceBG:closeWithSound()
	arg_4_0:saveSceneState(arg_4_0.vars.gacha_mode)
	
	arg_4_0.vars.element_mode = nil
	arg_4_0.vars.gsp_id = nil
	
	local var_4_0 = Account:getGachaShopInfo()
	local var_4_1 = arg_4_0.vars.ui_wnd:getChildByName("n_before")
	local var_4_2 = var_4_1:getChildByName("n_pickup_pos")
	
	var_4_2:removeAllChildren()
	var_4_1:getChildByName("n_pickup_pos2"):removeAllChildren()
	arg_4_0:prepareEnterGachaVisibleOff(var_4_1)
	arg_4_0:updateGachaTempInventoryCount()
	if_set_visible(var_4_1, "n_btn_book", true)
	
	if get_cocos_refid(arg_4_0.vars.intro.m_biblika_node) then
		arg_4_0.vars.intro.m_biblika_node:setVisible(false)
	end
	
	if get_cocos_refid(arg_4_0.vars.intro.m_biblio_node) then
		arg_4_0.vars.intro.m_biblio_node:setVisible(false)
	end
	
	local var_4_3 = load_control("wnd/gacha_element_item.csb", true)
	
	var_4_2:addChild(var_4_3)
	if_set_visible(var_4_3, "n_element_info", true)
	
	local var_4_4 = var_4_3:getChildByName("n_element_menu")
	
	var_4_4:setScale(0.6)
	var_4_4:setPosition(200, 150)
	UIAction:Add(LOG(MOVE_TO(1200, 0, 0)), var_4_4, "block")
	UIAction:Add(LOG(SCALE_TO(1200, 1)), var_4_4, "block")
	EffectManager:Play({
		z = 2,
		fn = "zodiac_stars_front.cfx",
		y = 350,
		x = 450,
		layer = var_4_4
	})
	EffectManager:Play({
		z = -1,
		fn = "zodiac_stars_back.cfx",
		y = 350,
		x = 450,
		layer = var_4_4
	})
	
	local var_4_5 = Account:getGachaShopInfo()
	
	for iter_4_0 = 1, 5 do
		local var_4_6 = "ticket" .. arg_4_0.vars.ei_colors[iter_4_0] .. "35"
		local var_4_7 = "ticket" .. arg_4_0.vars.ei_colors[iter_4_0] .. "45"
		local var_4_8 = Account:getCurrency(var_4_6)
		local var_4_9 = Account:getCurrency(var_4_7)
		local var_4_10 = "gacha_tk_" .. arg_4_0.vars.ei_colors[iter_4_0] .. "35"
		local var_4_11 = "gacha_tk_" .. arg_4_0.vars.ei_colors[iter_4_0] .. "45"
		local var_4_12 = var_4_4:getChildByName("n_element" .. iter_4_0)
		
		if_set(var_4_12, "txt_element", T("color_" .. arg_4_0.vars.ei_colors[iter_4_0]))
		if_set_visible(var_4_12, "n_info", true)
		
		local var_4_13 = math.floor(var_4_8 / var_4_5.gacha[var_4_10].price) + math.floor(var_4_9 / var_4_5.gacha[var_4_11].price)
		
		if var_4_13 > 0 then
			if_set_sprite(var_4_12, "element_bg", "img/gacha_circle_on.png")
			if_set_visible(var_4_12, "element_bg_eff", true)
			if_set_opacity(var_4_12, "element_icon", 255)
			UIAction:Add(LOOP(ROTATE(8000, 0, -360), 0), var_4_12:getChildByName("element_bg_eff"), var_4_12)
		else
			if_set_sprite(var_4_12, "element_bg", "img/gacha_circle_off.png")
			if_set_visible(var_4_12, "element_bg_eff", false)
			if_set_opacity(var_4_12, "element_icon", 76.5)
		end
		
		local var_4_14 = var_4_12:getChildByName("n_icon_token1")
		local var_4_15 = var_4_12:getChildByName("n_icon_token2")
		
		UIUtil:getRewardIcon(nil, "to_" .. var_4_6, {
			no_bg = true,
			parent = var_4_14
		})
		UIUtil:getRewardIcon(nil, "to_" .. var_4_7, {
			no_bg = true,
			parent = var_4_15
		})
		if_set(var_4_14, "t_token1", var_4_8)
		if_set(var_4_15, "t_token2", var_4_9)
		
		local var_4_16 = var_4_14:getChildByName("t_token1"):getContentSize()
		local var_4_17 = var_4_15:getChildByName("t_token2"):getContentSize()
		
		if iter_4_0 == 1 or iter_4_0 == 5 then
			var_4_15:setPositionX(var_4_15:getPositionX() - var_4_17.width * 0.4 - 10)
			var_4_14:setPositionX(var_4_15:getPositionX() - var_4_16.width * 0.9 - 40)
		else
			var_4_15:setPositionX(var_4_14:getPositionX() + var_4_16.width + 40)
		end
		
		if var_4_13 > 99 then
			if_set(var_4_12:getChildByName("n_num"), "txt_count", "99+")
			if_set_visible(var_4_12, "n_num", true)
		elseif var_4_13 > 0 then
			if_set(var_4_12:getChildByName("n_num"), "txt_count", var_4_13)
			if_set_visible(var_4_12, "n_num", true)
		else
			if_set_visible(var_4_12, "n_num", false)
		end
	end
	
	if_set_visible(arg_4_0.vars.ui_wnd, "n_special_notice", false)
	arg_4_0:showRightMenu(true)
	TopBarNew:checkhelpbuttonID("infogach_5")
	Analytics:toggleTab(arg_4_0.vars.gacha_mode)
end

function GachaUnit.toggleElement(arg_5_0, arg_5_1)
	local var_5_0 = arg_5_0.vars.ui_wnd:getChildByName("n_before")
	
	if not get_cocos_refid(var_5_0) then
		return 
	end
	
	local var_5_1 = var_5_0:getChildByName("n_element_menu")
	
	if not get_cocos_refid(var_5_1) then
		return 
	end
	
	if arg_5_1 == nil then
		for iter_5_0 = 1, 5 do
			local var_5_2 = var_5_1:getChildByName("n_element" .. iter_5_0)
			
			if var_5_2 then
				if_set_visible(var_5_2, "n_info", true)
			end
		end
		
		arg_5_0.vars.element_mode = nil
		
		if_set_visible(var_5_0, "n_element_info", true)
		if_set_visible(var_5_0, "n_btn_gacha_inven2", true)
		if_set_visible(var_5_0, "n_btn_book", true)
		UIAction:Add(LOG(MOVE_TO(200, 0, 0)), var_5_1, "block")
		UIAction:Add(LOG(SCALE_TO(200, 1)), var_5_1, "block")
		
		local var_5_3 = var_5_0:getChildByName("n_pickup_pos2"):getChildByName("n_gacha_element")
		
		if get_cocos_refid(var_5_3) then
			UIAction:Add(LOG(FADE_OUT(200)), var_5_3, "block")
		end
		
		if_set_visible(var_5_0, "n_pickup_pos2", false)
	else
		arg_5_0.vars.element_mode = arg_5_1
		
		for iter_5_1 = 1, 5 do
			local var_5_4 = var_5_1:getChildByName("n_element" .. iter_5_1)
			
			if var_5_4 then
				if_set_visible(var_5_4, "n_info", false)
			end
		end
		
		if_set_visible(var_5_0, "n_element_info", false)
		if_set_visible(var_5_0, "n_btn_gacha_inven2", false)
		if_set_visible(var_5_0, "n_btn_book", false)
		
		local var_5_5 = var_5_0:getChildByName("n_pickup_pos2")
		
		var_5_5:removeAllChildren()
		
		local var_5_6 = load_control("wnd/gacha_element.csb", true)
		
		var_5_5:addChild(var_5_6)
		if_set_visible(var_5_0, "n_pickup_pos2", true)
		
		local var_5_7 = var_5_5:getChildByName("n_gacha_element")
		
		var_5_7:setVisible(false)
		var_5_7:setOpacity(0)
		
		local var_5_8 = var_5_7:getChildByName("n_element")
		
		if_set(var_5_8, "t_desc", T("ui_gacha_sidebar_dec_1"))
		if_set(var_5_8, "txt_element", T("color_" .. arg_5_0.vars.ei_colors[arg_5_1]))
		if_set_sprite(var_5_8, "element_icon", "img/" .. arg_5_0.vars.ei_icons[arg_5_1])
		
		local var_5_9 = var_5_7:getChildByName("n_token_info")
		local var_5_10 = var_5_9:getChildByName("n_icon_token1")
		local var_5_11 = var_5_9:getChildByName("n_icon_token2")
		local var_5_12 = "ticket" .. arg_5_0.vars.ei_colors[arg_5_1] .. "35"
		local var_5_13 = "ticket" .. arg_5_0.vars.ei_colors[arg_5_1] .. "45"
		
		UIUtil:getRewardIcon(nil, "to_" .. var_5_12, {
			no_bg = true,
			parent = var_5_10
		})
		UIUtil:getRewardIcon(nil, "to_" .. var_5_13, {
			no_bg = true,
			parent = var_5_11
		})
		
		local var_5_14 = Account:getCurrency(var_5_12)
		local var_5_15 = Account:getCurrency(var_5_13)
		local var_5_16 = "gacha_tk_" .. arg_5_0.vars.ei_colors[arg_5_0.vars.element_mode] .. "35"
		local var_5_17 = "gacha_tk_" .. arg_5_0.vars.ei_colors[arg_5_0.vars.element_mode] .. "45"
		local var_5_18 = Account:getGachaShopInfo()
		
		if_set(var_5_10, "t_token1", var_5_14)
		if_set(var_5_11, "t_token2", var_5_15)
		
		local var_5_19 = var_5_18.gacha[var_5_16]
		local var_5_20 = var_5_7:getChildByName("n_btn")
		local var_5_21 = var_5_20:getChildByName("btn_summon_3_5")
		
		if_set(var_5_21, "txt_summon", T("btn_gacha_ticket_normal35"))
		if_set(var_5_21, "cost", var_5_19.price)
		if_set_sprite(var_5_21, "icon_res", "item/" .. DB("item_token", "to_" .. var_5_12, {
			"icon"
		}) .. ".png")
		
		if var_5_14 >= var_5_19.price then
			if_set_opacity(var_5_20, "btn_summon_3_5", 255)
		else
			if_set_opacity(var_5_20, "btn_summon_3_5", 76.5)
		end
		
		local var_5_22 = var_5_18.gacha[var_5_17]
		local var_5_23 = var_5_20:getChildByName("btn_summon_4_5")
		
		if_set(var_5_23, "txt_summon", T("btn_gacha_ticket_special45"))
		if_set(var_5_23, "cost", var_5_22.price)
		if_set_sprite(var_5_23, "icon_res", "item/" .. DB("item_token", "to_" .. var_5_13, {
			"icon"
		}) .. ".png")
		
		if var_5_15 >= var_5_22.price then
			if_set_opacity(var_5_20, "btn_summon_4_5", 255)
		else
			if_set_opacity(var_5_20, "btn_summon_4_5", 76.5)
		end
		
		local var_5_24 = var_5_1:getChildByName("n_element" .. arg_5_1)
		local var_5_25 = var_5_7:getChildByName("n_focus")
		local var_5_26 = var_5_25:getPositionX() - var_5_24:getPositionX() * 1.2
		local var_5_27 = var_5_25:getPositionY() - var_5_24:getPositionY() * 1.2
		
		UIAction:Add(LOG(MOVE_TO(200, var_5_26, var_5_27)), var_5_1, "block")
		UIAction:Add(LOG(SCALE_TO(200, 1.2)), var_5_1, "block")
		UIAction:Add(LOG(FADE_IN(200)), var_5_7, "block")
	end
end
