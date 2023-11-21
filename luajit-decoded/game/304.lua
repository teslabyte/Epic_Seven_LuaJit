GachaUnit = GachaUnit or {}

function GachaUnit.enterGachaNormal(arg_1_0)
	arg_1_0:setTitle(nil, nil)
	
	arg_1_0.vars.gacha_mode = "gacha_normal"
	
	GachaIntroduceBG:closeWithSound()
	arg_1_0:saveSceneState(arg_1_0.vars.gacha_mode)
	
	arg_1_0.vars.element_mode = nil
	arg_1_0.vars.gsp_id = nil
	
	local var_1_0 = Account:getGachaShopInfo().gacha.gacha_normal
	local var_1_1 = arg_1_0.vars.ui_wnd:getChildByName("n_before")
	
	var_1_1:getChildByName("n_pickup_pos"):removeAllChildren()
	var_1_1:getChildByName("n_pickup_pos2"):removeAllChildren()
	arg_1_0:prepareEnterGachaVisibleOff(var_1_1, true)
	if_set_visible(var_1_1, "btn_summon", true)
	if_set_visible(var_1_1, "n_btn_rate", true)
	if_set_visible(var_1_1, "n_btn_book", true)
	
	if get_cocos_refid(arg_1_0.vars.intro.m_biblika_node) then
		arg_1_0.vars.intro.m_biblika_node:setVisible(true)
	end
	
	if get_cocos_refid(arg_1_0.vars.intro.m_biblio_node) then
		arg_1_0.vars.intro.m_biblio_node:setVisible(true)
	end
	
	local var_1_2 = var_1_1:getChildByName("btn_summon")
	local var_1_3 = Account:getCurrency("ticketnormal")
	local var_1_4 = var_1_0.price
	local var_1_5 = 1
	
	for iter_1_0 = 1, 10 do
		if var_1_3 < var_1_0.price * iter_1_0 then
			break
		end
		
		var_1_4 = var_1_0.price * iter_1_0
		var_1_5 = iter_1_0
	end
	
	if_set_visible(var_1_2, "cm_icon_gacha", false)
	if_set(var_1_2, "txt_summon", T(var_1_0.name, {
		count = var_1_5
	}))
	if_set(var_1_2, "cost", var_1_4)
	if_set_sprite(var_1_2, "icon_res", "item/" .. DB("item_token", var_1_0.token, {
		"icon"
	}) .. ".png")
	arg_1_0:showRightMenu(true)
	TopBarNew:checkhelpbuttonID("infogach_6")
	Analytics:toggleTab(arg_1_0.vars.gacha_mode)
end

function GachaUnit.enterGachaRare(arg_2_0)
	arg_2_0:setTitle(nil, nil)
	
	arg_2_0.vars.gacha_mode = "gacha_rare"
	
	arg_2_0:saveSceneState(arg_2_0.vars.gacha_mode)
	
	arg_2_0.vars.element_mode = nil
	arg_2_0.vars.gsp_id = nil
	
	local var_2_0 = Account:getGachaShopInfo()
	local var_2_1 = var_2_0.gacha.gacha_rare_1
	local var_2_2 = var_2_0.gacha.gacha_rare_10
	local var_2_3 = arg_2_0.vars.ui_wnd:getChildByName("n_before")
	local var_2_4 = var_2_3:getChildByName("n_pickup_pos")
	
	var_2_4:removeAllChildren()
	var_2_3:getChildByName("n_pickup_pos2"):removeAllChildren()
	
	local var_2_5
	local var_2_6 = Account:getGachaRandList()
	
	if var_2_6 and var_2_6[arg_2_0.vars.gacha_mode] then
		local var_2_7 = var_2_6[arg_2_0.vars.gacha_mode]
		
		var_2_5 = string.split(var_2_7, ",")
	end
	
	GachaIntroduceBG:setup("normal", var_2_4, {
		gacha_id = "gacha_rare",
		detail_mode = "rare",
		pickup_char_list = var_2_5
	})
	arg_2_0:prepareEnterGachaVisibleOff(var_2_3)
	arg_2_0:updateGachaTempInventoryCount()
	if_set_visible(var_2_3, "n_btn_summon_2", true)
	if_set_visible(var_2_3, "n_btn_rate", true)
	if_set_visible(var_2_3, "n_btn_book", true)
	
	if get_cocos_refid(arg_2_0.vars.intro.m_biblika_node) then
		arg_2_0.vars.intro.m_biblika_node:setVisible(true)
	end
	
	if get_cocos_refid(arg_2_0.vars.intro.m_biblio_node) then
		arg_2_0.vars.intro.m_biblio_node:setVisible(true)
	end
	
	local var_2_8 = var_2_3:getChildByName("n_btn_summon_2")
	
	if get_cocos_refid(var_2_8) and var_2_8:isVisible() then
		if_set_visible(var_2_8, "cm_free_tooltip", false)
		if_set_visible(var_2_8, "cm_free_tooltip2", false)
		
		local var_2_9 = var_2_8:getChildByName("btn_summon_1")
		
		if_set_visible(var_2_9, "cm_icon_gacha", false)
		if_set(var_2_9, "txt_summon", T("ui_gacha_summon_1_btn"))
		if_set(var_2_9, "cost", var_2_1.price)
		if_set_sprite(var_2_9, "icon_res", "item/" .. DB("item_token", var_2_1.token, {
			"icon"
		}) .. ".png")
		
		local var_2_10 = var_2_8:getChildByName("btn_summon_10")
		
		if_set(var_2_10, "txt_summon", T("ui_gacha_summon_10_btn"))
		if_set(var_2_10, "cost", var_2_1.price * 10)
		if_set_sprite(var_2_10, "icon_res", "item/" .. DB("item_token", var_2_1.token, {
			"icon"
		}) .. ".png")
	else
		local var_2_11 = var_2_3:getChildByName("btn_summon")
		
		if get_cocos_refid(var_2_11) then
			var_2_11:setVisible(true)
		end
		
		if_set_visible(var_2_11, "cm_free_tooltip", false)
		if_set_visible(var_2_11, "cm_icon_gacha", false)
		if_set(var_2_11, "txt_summon", T(var_2_1.name))
		if_set(var_2_11, "cost", var_2_1.price)
		if_set_sprite(var_2_11, "icon_res", "item/" .. DB("item_token", var_2_1.token, {
			"icon"
		}) .. ".png")
	end
	
	arg_2_0:showRightMenu(true)
	arg_2_0:updateFreeGachaButton()
	TopBarNew:checkhelpbuttonID("infogach")
	Analytics:toggleTab(arg_2_0.vars.gacha_mode)
end

function GachaUnit.enterGachaMoonlight(arg_3_0)
	arg_3_0:setTitle(nil, nil)
	
	arg_3_0.vars.gacha_mode = "gacha_moonlight"
	
	arg_3_0:saveSceneState(arg_3_0.vars.gacha_mode)
	
	arg_3_0.vars.element_mode = nil
	arg_3_0.vars.gsp_id = nil
	
	local var_3_0 = Account:getGachaShopInfo().gacha.gacha_moonlight
	local var_3_1 = arg_3_0.vars.ui_wnd:getChildByName("n_before")
	local var_3_2 = var_3_1:getChildByName("n_pickup_pos")
	
	var_3_2:removeAllChildren()
	var_3_1:getChildByName("n_pickup_pos2"):removeAllChildren()
	arg_3_0:prepareEnterGachaVisibleOff(var_3_1)
	arg_3_0:updateGachaTempInventoryCount()
	if_set_visible(var_3_1, "n_btn_rate", true)
	if_set_visible(var_3_1, "n_btn_book", true)
	
	if get_cocos_refid(arg_3_0.vars.intro.m_biblika_node) then
		arg_3_0.vars.intro.m_biblika_node:setVisible(true)
	end
	
	if get_cocos_refid(arg_3_0.vars.intro.m_biblio_node) then
		arg_3_0.vars.intro.m_biblio_node:setVisible(true)
	end
	
	local var_3_3
	local var_3_4 = Account:getGachaRandList()
	
	if var_3_4 and var_3_4[arg_3_0.vars.gacha_mode] then
		local var_3_5 = var_3_4[arg_3_0.vars.gacha_mode]
		
		var_3_3 = string.split(var_3_5, ",")
	end
	
	GachaIntroduceBG:setup("normal", var_3_2, {
		gacha_id = "gacha_moonlight",
		detail_mode = "moonlight",
		pickup_char_list = var_3_3
	})
	
	if arg_3_0:isMoonlightBonus() then
		if_set_visible(var_3_1, "btn_summon_up", true)
		
		local var_3_6 = var_3_1:getChildByName("btn_summon_up")
		
		if_set_visible(var_3_6, "cm_free_tooltip", false)
		if_set_visible(var_3_6, "cm_icon_gacha", false)
		
		if not get_cocos_refid(arg_3_0.vars.eff_gacha_moonlight_ceiling) then
			arg_3_0.vars.eff_gacha_moonlight_ceiling = EffectManager:Play({
				loop = true,
				scale = 1,
				fn = "gacha_moonlight_ceiling_main.cfx",
				layer = var_3_6
			})
		end
	else
		if_set_visible(var_3_1, "btn_summon", true)
		
		local var_3_7 = var_3_1:getChildByName("btn_summon")
		
		if_set_visible(var_3_7, "cm_icon_gacha", false)
		if_set(var_3_7, "txt_summon", T(var_3_0.name))
		if_set(var_3_7, "cost", var_3_0.price)
		if_set_sprite(var_3_7, "icon_res", "item/" .. DB("item_token", var_3_0.token, {
			"icon"
		}) .. ".png")
		
		if get_cocos_refid(arg_3_0.vars.eff_gacha_moonlight_ceiling) then
			arg_3_0.vars.eff_gacha_moonlight_ceiling:removeFromParent()
			
			arg_3_0.vars.eff_gacha_moonlight_ceiling = nil
		end
	end
	
	local var_3_8 = var_3_1:getChildByName("n_pickup_ceiling_info")
	
	if var_3_8 and AccountData.gacha_moonlight_ceiling then
		local var_3_9 = arg_3_0:getMoonlightBonusCountText()
		
		if var_3_9 and AccountData.gacha_moonlight_ceiling then
			if tolua:type(var_3_8:getChildByName("txt_count")) ~= "ccui.RichText" then
				upgradeLabelToRichLabel(var_3_8, "txt_count"):ignoreContentAdaptWithSize(true)
			end
			
			if_set(var_3_8, "txt_count", var_3_9)
			if_set_width_from(var_3_8, "tooltip_info", "txt_count", {
				add = 60,
				ratio = 1
			})
			var_3_8:setVisible(true)
		else
			var_3_8:setVisible(false)
		end
	end
	
	arg_3_0:showRightMenu(true)
	arg_3_0:updateFreeGachaButton()
	TopBarNew:checkhelpbuttonID("infogach_4")
	Analytics:toggleTab(arg_3_0.vars.gacha_mode)
end

function GachaUnit.getMoonlightBonusCountText(arg_4_0, arg_4_1)
	local var_4_0
	
	if AccountData.gacha_moonlight_ceiling then
		local var_4_1 = to_n(GAME_CONTENT_VARIABLE.gacha_moonlight_upgrade_count or 30)
		local var_4_2 = var_4_1 - to_n(AccountData.gacha_moonlight_ceiling)
		
		if var_4_2 == 0 then
			var_4_2 = var_4_1
		end
		
		local var_4_3, var_4_4 = arg_4_0:getFreeGachaEventCount("gacha_ml_free_1", "gl:gachafree_daily_ml")
		
		if arg_4_0:isMoonlightBonus() then
			if arg_4_1 and var_4_3 and var_4_4 and var_4_3 < var_4_4 then
				var_4_0 = T("ui_gacha_moonlight_ceiling_complete_free", {
					curr = var_4_4 - var_4_3,
					max = var_4_4
				})
			else
				var_4_0 = T("ui_gacha_moonlight_ceiling_complete")
			end
		elseif arg_4_1 and var_4_3 and var_4_4 and var_4_3 < var_4_4 then
			var_4_0 = T("ui_gacha_moonlight_ceiling_remain_free", {
				count = var_4_2,
				curr = var_4_4 - var_4_3,
				max = var_4_4
			})
		else
			var_4_0 = T("ui_gacha_moonlight_ceiling_remain", {
				count = var_4_2
			})
		end
	end
	
	return var_4_0
end

function GachaUnit.isMoonlightBonus(arg_5_0)
	local var_5_0 = false
	
	if arg_5_0.vars and arg_5_0.vars.gacha_mode == "gacha_moonlight" and AccountData.gacha_moonlight_ceiling then
		local var_5_1 = Account:getTicketedLimit("gl:gacha_moonlight_bonus")
		
		if var_5_1 and var_5_1.count > 0 then
			return true
		end
	end
	
	return var_5_0
end

function GachaUnit.enterGachaSelect(arg_6_0, arg_6_1)
	arg_6_1 = arg_6_1 or "gacha_select"
	
	arg_6_0:setTitle(nil, nil)
	
	arg_6_0.vars.gacha_mode = "gacha_select:" .. arg_6_1
	
	arg_6_0:saveSceneState(arg_6_0.vars.gacha_mode)
	
	arg_6_0.vars.element_mode = nil
	arg_6_0.vars.gsp_id = nil
	
	local var_6_0 = Account:getGachaShopInfo().select_list[arg_6_1]
	
	if not var_6_0 or var_6_0.used == true then
		arg_6_0:enterGachaRare()
		
		return 
	end
	
	local var_6_1 = json.decode(Account:getConfigData("gs_unlock_reddot") or "{}")
	
	if not var_6_1[arg_6_1] then
		var_6_1[arg_6_1] = 1
		
		SAVE:setTempConfigData("gs_unlock_reddot", json.encode(var_6_1))
	end
	
	local var_6_2 = arg_6_0.vars.ui_wnd:getChildByName("n_before")
	local var_6_3 = var_6_2:getChildByName("n_pickup_pos")
	
	var_6_3:removeAllChildren()
	var_6_2:getChildByName("n_pickup_pos2"):removeAllChildren()
	arg_6_0:prepareEnterGachaVisibleOff(var_6_2)
	if_set_visible(var_6_2, "n_btn_rate", true)
	if_set_visible(var_6_2, "n_select", true)
	if_set_visible(var_6_2, "n_btn_book", true)
	
	if get_cocos_refid(arg_6_0.vars.intro.m_biblika_node) then
		arg_6_0.vars.intro.m_biblika_node:setVisible(true)
	end
	
	if get_cocos_refid(arg_6_0.vars.intro.m_biblio_node) then
		arg_6_0.vars.intro.m_biblio_node:setVisible(true)
	end
	
	local var_6_4 = var_6_2:getChildByName("n_select")
	local var_6_5 = var_6_4:getChildByName("talk_small_bg")
	
	for iter_6_0 = 1, 6 do
		if_set_visible(var_6_5, "disc" .. iter_6_0, false)
	end
	
	if_set(var_6_5, "t_select_info", T("gacha_select_warning_btn"))
	var_6_4:getChildByName("btn_select_summon"):setVisible(var_6_0.previous == nil)
	
	local var_6_6
	local var_6_7 = Account:getGachaRandList()
	
	if var_6_7 and var_6_7[arg_6_1] then
		local var_6_8 = var_6_7[arg_6_1]
		
		var_6_6 = string.split(var_6_8, ",")
	end
	
	GachaIntroduceBG:setup("normal", var_6_3, {
		gacha_id = arg_6_1,
		pickup_char_list = var_6_6,
		detail_mode = arg_6_1
	})
	var_6_4:getChildByName("btn_select_previous"):setVisible(var_6_0.previous ~= nil)
	
	local var_6_9 = arg_6_0.vars.gacha_select_condition[arg_6_1]
	
	if_set_visible(var_6_4, "icon_locked_select_summon", false)
	
	if var_6_9 then
		local var_6_10 = UnlockSystem:isUnlockSystem(var_6_9.system_unlock)
		
		if_set_visible(var_6_4, "icon_locked_select_summon", not var_6_10)
	end
	
	arg_6_0.vars.current_select_condition = var_6_9
	
	local var_6_11 = var_6_4:getChildByName("n_info")
	
	if var_6_9 and var_6_9.img then
		if_set_sprite(var_6_11, "img", "img/" .. var_6_9.img .. ".png")
	end
	
	if var_6_9 and var_6_9.img_eff then
		if_set_sprite(var_6_11, "img_eff", "img/" .. var_6_9.img_eff .. ".png")
	end
	
	TopBarNew:checkhelpbuttonID("infogach")
	arg_6_0:showRightMenu(false)
	Analytics:toggleTab(arg_6_0.vars.gacha_mode)
end

function GachaUnit.getCurrentSelectCondition(arg_7_0)
	return arg_7_0.vars.current_select_condition
end

function GachaUnit.popupSelectSubstoryHero(arg_8_0)
	GachaSubstorySelector:show()
end

function GachaUnit.enterGachaSubstory(arg_9_0, arg_9_1)
	local var_9_0 = os.time()
	local var_9_1 = Account:getGachaShopInfo()
	local var_9_2 = var_9_1.gacha_substory
	
	arg_9_0.vars.gacha_mode = "gacha_substory"
	
	arg_9_0:saveSceneState(arg_9_0.vars.gacha_mode)
	
	arg_9_0.vars.element_mode = nil
	arg_9_0.vars.gsp_id = nil
	arg_9_1 = arg_9_1 or var_9_2
	
	if not arg_9_1 then
		arg_9_0:enterGachaRare()
		
		return 
	end
	
	local var_9_3 = arg_9_0.vars.ui_wnd:getChildByName("n_before")
	local var_9_4 = var_9_3:getChildByName("n_pickup_pos")
	
	var_9_4:removeAllChildren()
	var_9_3:getChildByName("n_pickup_pos2"):removeAllChildren()
	arg_9_0:prepareEnterGachaVisibleOff(var_9_3)
	
	local var_9_5 = var_9_1.gacha.gacha_substory
	local var_9_6
	local var_9_7 = true
	
	if var_9_0 >= to_n(var_9_2.start_time) and var_9_0 <= to_n(var_9_2.end_time) and var_9_2.pickup_gacha_list then
		var_9_7 = false
	end
	
	GachaIntroduceBG:setup("substory", var_9_4, {
		nb = var_9_3,
		gacha_shop_info = var_9_1,
		gacha_substory = var_9_2,
		gacha_data = var_9_5,
		pickup_data = arg_9_1,
		select_mode = var_9_7
	})
	
	local var_9_8 = arg_9_0.vars.ui_right_menu_wnd:getChildByName("scrollview"):getChildByName("n_banner:gacha_substory"):getParent():getChildByName("n_time")
	
	if get_cocos_refid(var_9_8) then
		if var_9_7 then
			var_9_8.end_time_info = nil
			var_9_8.banner_opts = {
				id = "gacha_substory",
				gacha_substory = true
			}
		else
			var_9_8.end_time_info = to_n(var_9_2.end_time)
			var_9_8.banner_opts = {
				id = "gacha_substory",
				gacha_substory = true,
				end_time = var_9_8.end_time_info
			}
		end
	end
	
	Analytics:toggleTab("gacha_substory")
end
