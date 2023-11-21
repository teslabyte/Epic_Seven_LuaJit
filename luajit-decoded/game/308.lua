function GachaUnit.gachaStartBuy(arg_1_0)
	arg_1_0:confirmBuy(1)
end

function GachaUnit.enterGachaStart(arg_2_0)
	if not arg_2_0.vars or not get_cocos_refid(arg_2_0.vars.ui_wnd) then
		return 
	end
	
	if not Shop.ready or not AccountData.shop or not AccountData.shop.promotion then
		if Stove:checkStandbyAndBalloonMessage() then
			query("market", {
				caller = "package_gacha"
			})
		end
		
		arg_2_0:enterGachaRare()
		
		return 
	end
	
	local var_2_0 = Account:getGachaShopInfo()
	
	if not var_2_0.gacha_start then
		arg_2_0:enterGachaRare()
		
		return 
	end
	
	arg_2_0.vars.gacha_mode = "gacha_start"
	
	arg_2_0:saveSceneState(arg_2_0.vars.gacha_mode)
	
	local var_2_1 = arg_2_0.vars.ui_wnd:getChildByName("n_before")
	local var_2_2 = var_2_1:getChildByName("n_pickup_pos")
	
	var_2_2:removeAllChildren()
	var_2_1:getChildByName("n_pickup_pos2"):removeAllChildren()
	arg_2_0:prepareEnterGachaVisibleOff(var_2_1)
	arg_2_0:updateGachaTempInventoryCount()
	if_set_visible(var_2_1, "n_btn_rate", true)
	
	if get_cocos_refid(arg_2_0.vars.intro.m_biblika_node) then
		arg_2_0.vars.intro.m_biblika_node:setVisible(false)
	end
	
	if get_cocos_refid(arg_2_0.vars.intro.m_biblio_node) then
		arg_2_0.vars.intro.m_biblio_node:setVisible(false)
	end
	
	GachaIntroduceBG:setup("start", var_2_2, {
		nb = var_2_1,
		gacha_shop_info = var_2_0
	})
	arg_2_0:showRightMenu(false)
	Analytics:toggleTab(arg_2_0.vars.gacha_mode)
end

function GachaUnit.updateGachaStoryTime(arg_3_0)
	if not arg_3_0.vars or not arg_3_0.vars.gacha_mode or string.starts(arg_3_0.vars.gacha_mode, "gacha_story:") ~= true then
		return 
	end
	
	if not get_cocos_refid(arg_3_0.vars.ui_wnd) then
		return 
	end
	
	local var_3_0 = string.split(arg_3_0.vars.gacha_mode, ":")[2]
	local var_3_1 = Account:getGachaShopInfo()
	
	if not var_3_1.gacha_story then
		return 
	end
	
	local var_3_2 = var_3_1.gacha_story[var_3_0]
	
	if not var_3_2 then
		return 
	end
	
	local var_3_3 = os.time()
	local var_3_4 = arg_3_0.vars.ui_wnd:getChildByName("n_before"):getChildByName("n_pickup_pos"):getChildByName("n_btn")
	
	if not get_cocos_refid(var_3_4) then
		return 
	end
	
	local var_3_5 = Account:getTicketedLimit("gl:" .. var_3_2.gacha_id)
	
	if var_3_5 then
		if to_n(var_3_5.count) >= to_n(var_3_5.max_c) or var_3_3 > to_n(var_3_5.buyable_tm) then
			return 
		end
		
		local var_3_6 = var_3_4:getChildByName("n_btn_summon")
		
		if var_3_0 == "gacha_story_ep999" or var_3_0 == "gacha_spdash" then
			local var_3_7 = to_n(var_3_5.buyable_tm) - var_3_3
			
			if var_3_7 > (GAME_STATIC_VARIABLE.summon_expire_info_time or 172800) then
				if_set_color(var_3_6, "t_period", tocolor("#c89b60"))
			else
				if_set_color(var_3_6, "t_period", tocolor("#6bc11b"))
			end
			
			if_set(var_3_6, "t_period", T("ui_gacha_festival_left_time", {
				time = sec_to_string(var_3_7)
			}))
		end
	elseif var_3_2 then
		local var_3_8 = Account:getTicketedLimit("ip:" .. var_3_2.shop_id)
		
		if var_3_0 ~= "gacha_story_ep999" and var_3_0 ~= "gacha_spdash" and (not var_3_8 or not AccountData.shop or not AccountData.shop.promotion or var_3_3 < to_n(var_3_2.start_time) or var_3_3 > to_n(var_3_2.end_time)) then
			return 
		end
		
		local var_3_9
		
		for iter_3_0, iter_3_1 in pairs(AccountData.shop.promotion) do
			if iter_3_1.id == var_3_2.shop_id then
				var_3_9 = iter_3_1
				
				break
			end
		end
		
		if not var_3_9 then
			return 
		end
		
		local var_3_10 = var_3_4:getChildByName("n_btn_buy")
		
		if var_3_0 == "gacha_story_ep999" or var_3_0 == "gacha_spdash" then
			local var_3_11 = AccountData.package_limits["sh:" .. var_3_2.shop_id]
			
			if var_3_11 then
				if_set(var_3_10, "t_period", T("sell_period_v2", timeToStringDef({
					preceding_with_zeros = true,
					start_time = var_3_11.start_time,
					end_time = var_3_11.end_time
				})))
			else
				if_set_visible(var_3_10, "t_period", false)
			end
			
			local var_3_12 = to_n(var_3_2.end_time) - os.time()
			
			if var_3_12 > (GAME_STATIC_VARIABLE.summon_expire_info_time or 172800) then
				if_set_color(var_3_10, "t_period", tocolor("#c89b60"))
			else
				if_set_color(var_3_10, "t_period", tocolor("#6bc11b"))
			end
			
			if var_3_12 and to_n(var_3_12) < 1 then
				local var_3_13 = var_3_4:getChildByName("n_purchased")
				
				if_set(var_3_13, "complet_label", T("expired"))
				if_set_visible(var_3_4, "n_purchased", true)
				if_set_visible(var_3_4, "n_btn_buy", false)
			else
				if_set_visible(var_3_4, "n_purchased", false)
				if_set_visible(var_3_4, "n_btn_buy", true)
			end
		elseif var_3_8 then
			if_set(var_3_10, "t_period", T("sell_period_v2", timeToStringDef({
				preceding_with_zeros = true,
				start_time = var_3_8.usable_tm,
				end_time = var_3_8.buyable_tm
			})))
			
			local var_3_14 = to_n(var_3_8.buyable_tm) - os.time()
			
			if var_3_14 > (GAME_STATIC_VARIABLE.summon_expire_info_time or 172800) then
				if_set_color(var_3_10, "t_period", tocolor("#c89b60"))
			else
				if_set_color(var_3_10, "t_period", tocolor("#6bc11b"))
			end
			
			if var_3_14 and to_n(var_3_14) < 1 then
				local var_3_15 = var_3_4:getChildByName("n_purchased")
				
				if_set(var_3_15, "complet_label", T("expired"))
				if_set_visible(var_3_4, "n_purchased", true)
				if_set_visible(var_3_4, "n_btn_buy", false)
			else
				if_set_visible(var_3_4, "n_purchased", false)
				if_set_visible(var_3_4, "n_btn_buy", true)
			end
		end
	end
end

function GachaUnit.enterGachaStory(arg_4_0, arg_4_1)
	if not arg_4_0.vars or not get_cocos_refid(arg_4_0.vars.ui_wnd) then
		return 
	end
	
	if not Shop.ready or not AccountData.shop or not AccountData.shop.promotion then
		if Stove:checkStandbyAndBalloonMessage() then
			query("market", {
				caller = "package_gacha"
			})
		end
		
		arg_4_0:enterGachaRare()
		
		return 
	end
	
	arg_4_1 = arg_4_1 or "gacha_story_ep2"
	
	local var_4_0 = Account:getGachaShopInfo()
	
	if not var_4_0.gacha_story then
		arg_4_0:showRightMenu(false, true)
		arg_4_0:enterGachaRare()
		
		return 
	end
	
	local var_4_1 = var_4_0.gacha_story[arg_4_1]
	
	if not var_4_1 then
		arg_4_0:showRightMenu(false, true)
		arg_4_0:enterGachaRare()
		
		return 
	end
	
	local var_4_2 = arg_4_0.vars.gacha_story_ui[arg_4_1]
	
	if not var_4_2 then
		arg_4_0:showRightMenu(false, true)
		arg_4_0:enterGachaRare()
		
		return 
	end
	
	local var_4_3 = os.time()
	
	arg_4_0.vars.gacha_mode = "gacha_story:" .. arg_4_1
	
	arg_4_0:saveSceneState(arg_4_0.vars.gacha_mode)
	
	local var_4_4 = arg_4_0.vars.ui_wnd:getChildByName("n_before")
	local var_4_5 = var_4_4:getChildByName("n_pickup_pos")
	
	var_4_5:removeAllChildren()
	var_4_4:getChildByName("n_pickup_pos2"):removeAllChildren()
	arg_4_0:prepareEnterGachaVisibleOff(var_4_4)
	arg_4_0:updateGachaTempInventoryCount()
	if_set_visible(var_4_4, "n_btn_rate", true)
	
	local var_4_6 = Account:getTicketedLimit("gl:" .. var_4_1.gacha_id)
	
	if var_4_6 then
		if to_n(var_4_6.count) >= to_n(var_4_6.max_c) or var_4_3 > to_n(var_4_6.buyable_tm) then
			GachaUnit:showRightMenu(false, true)
			GachaUnit:enterGachaRare()
			
			return 
		end
	elseif var_4_1 then
		local var_4_7 = Account:getTicketedLimit("ip:" .. var_4_1.shop_id)
		
		if arg_4_1 ~= "gacha_story_ep999" and arg_4_1 ~= "gacha_spdash" and (not var_4_7 or not AccountData.shop or not AccountData.shop.promotion or var_4_3 < to_n(var_4_1.start_time) or var_4_3 > to_n(var_4_1.end_time)) then
			arg_4_0:showRightMenu(false, true)
			arg_4_0:enterGachaRare()
			
			return 
		end
		
		local var_4_8
		
		for iter_4_0, iter_4_1 in pairs(AccountData.shop.promotion) do
			if iter_4_1.id == var_4_1.shop_id then
				var_4_8 = iter_4_1
				
				break
			end
		end
		
		if not var_4_8 then
			arg_4_0:showRightMenu(false, true)
			arg_4_0:enterGachaRare()
			
			return 
		end
	else
		arg_4_0:showRightMenu(false, true)
		arg_4_0:enterGachaRare()
		
		return 
	end
	
	GachaIntroduceBG:setup("story", var_4_5, {
		story_id = arg_4_1,
		gacha_shop_info = var_4_0,
		gacha_story = var_4_1,
		db_gs_ui = var_4_2
	})
	arg_4_0:updateGachaStoryTime()
	arg_4_0:showRightMenu(false)
	Analytics:toggleTab(arg_4_0.vars.gacha_mode)
end
