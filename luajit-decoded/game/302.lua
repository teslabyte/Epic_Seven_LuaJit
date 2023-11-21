function MsgHandler.gacha_rate_info(arg_1_0)
	if arg_1_0.item == "gacha_pet" then
	else
		GachaUnit:setGachaRateInfo(arg_1_0)
	end
end

function MsgHandler.select_gacha_special(arg_2_0)
	if arg_2_0.select_id then
		GachaUnit:updateSpecialGachaSelected(nil, arg_2_0.select_id)
	end
end

function MsgHandler.select_gacha_customspecial(arg_3_0)
	if arg_3_0.select_list then
		GachaUnit:updateGachaCusomSpecialSelected(arg_3_0.select_list)
	end
end

function MsgHandler.change_gacha_customspecial(arg_4_0)
	if arg_4_0.select_list then
		GachaUnit:updateGachaCusomSpecialSelected(arg_4_0.select_list)
	end
end

function MsgHandler.pull_gacha_select(arg_5_0)
	GachaUnit:showSelectGachaInfo(arg_5_0)
end

function MsgHandler.save_gacha_select(arg_6_0)
	GachaUnit:savedSelectGacha(arg_6_0)
end

function MsgHandler.decide_gacha_select(arg_7_0)
	if arg_7_0.gacha_shop_info then
		AccountData.gacha_shop_info = arg_7_0.gacha_shop_info
	end
	
	Singular:event("selective_summon_complete")
	Account:updateCurrencies(arg_7_0.info)
	
	local var_7_0 = {}
	
	if arg_7_0.info.gacha_results and #arg_7_0.info.gacha_results > 0 then
		local var_7_1 = arg_7_0.info.gacha_results
		local var_7_2 = {}
		
		for iter_7_0, iter_7_1 in pairs(var_7_1) do
			if iter_7_1.gacha_type == "character" then
				if iter_7_1.dupl_token then
					table.push(var_7_0, iter_7_1.dupl_token)
				end
				
				local var_7_3, var_7_4 = Account:addUnit(iter_7_1.id, iter_7_1.code, iter_7_1.exp, iter_7_1.g)
				
				if var_7_4 then
					var_7_2[iter_7_1.code] = true
				end
				
				iter_7_1.new = var_7_4 ~= nil
			elseif iter_7_1.gacha_type == "equip" then
				local var_7_5, var_7_6 = Account:addEquip(iter_7_1)
				
				iter_7_1.new = var_7_6 ~= nil
				
				if var_7_6 then
					var_7_2[iter_7_1.code] = true
				end
			end
		end
	else
		balloon_message_with_sound("gacha_err")
	end
	
	if arg_7_0.updated_collections then
		Account:updateCollectionData(arg_7_0.updated_collections)
	end
	
	ConditionContentsManager:dispatch("gacha.select")
	GachaUnit:gachaSelectGetPopup(var_7_0)
end

function MsgHandler.exchange_gacha_mileage(arg_8_0)
	if arg_8_0.gacha_mileage then
		AccountData.gacha_mileage = arg_8_0.gacha_mileage
	end
	
	Account:addReward(arg_8_0.rewards, {
		single = true
	})
	GachaUnit:updateMileage(true)
end

function err_gacha_list_update(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0
	
	if arg_9_1 == "invalid_gsp_id" then
		var_9_0 = T("msg_gacha_list_update")
	elseif arg_9_1 == "content_disable" then
		var_9_0 = T("content_disable")
	else
		var_9_0 = T("buy_gacha." .. arg_9_1)
	end
	
	Dialog:msgBox(var_9_0, {
		handler = function()
			if SceneManager:getCurrentSceneName() ~= "lobby" then
				SceneManager:nextScene("lobby")
			end
		end
	})
end

ErrHandler.buy_gacha = err_gacha_list_update
ErrHandler.select_gacha_special_grade = err_gacha_list_update

function MsgHandler.select_gacha_special_grade(arg_11_0)
	if arg_11_0 and arg_11_0.grade then
		GachaUnit:updateSpecialGachaSelected(arg_11_0.grade)
	end
end

function MsgHandler.buy_gacha(arg_12_0)
	if arg_12_0.shop_value then
		if arg_12_0.shop_value == "gacha_special" then
			Singular:event("mystic_summon")
		elseif arg_12_0.shop_value == "gacha_moonlight" then
			Singular:event("moonlight_summon")
		end
	end
	
	if arg_12_0.free_db then
		Account:updateGachaShopFreeInfo(arg_12_0.free_db)
	end
	
	Account:updateCurrencies(arg_12_0.info)
	Account:updateLimits(arg_12_0.limits)
	
	if arg_12_0.shop_value and string.starts(arg_12_0.shop_value, "gacha_tk") then
		GachaUnit:updateGachaElementNoti()
	end
	
	if arg_12_0.ticketed_limits then
		AccountData.ticketed_limits = arg_12_0.ticketed_limits
	end
	
	TopBarNew:topbarUpdate(true)
	GachaUnit:setTutorialMode(arg_12_0.shop_value == "gacha_tutorial")
	
	if arg_12_0.gacha_mileage then
		AccountData.gacha_mileage = arg_12_0.gacha_mileage
	end
	
	if arg_12_0.gacha_customgroup_data then
		GachaUnit:updateGachaCustomData(arg_12_0.gacha_customgroup_data)
	end
	
	if arg_12_0.gacha_customspecial_data then
		GachaUnit:updateGachaCustomSpecialData(arg_12_0.gacha_customspecial_data)
	end
	
	if arg_12_0.gacha_moonlight_ceiling then
		AccountData.gacha_moonlight_ceiling = arg_12_0.gacha_moonlight_ceiling
	end
	
	if arg_12_0.info.gacha_results and #arg_12_0.info.gacha_results > 0 then
		local var_12_0 = arg_12_0.info.gacha_results
		local var_12_1 = {}
		
		for iter_12_0, iter_12_1 in pairs(var_12_0) do
			if iter_12_1.gacha_type == "character" then
				if iter_12_1.ti == 1 then
					iter_12_1.new = Account:getCollectionUnit(iter_12_1.code) == nil and Account:isIncludeGachaTempInventory(iter_12_1.code) == false
					iter_12_1.add_temp_inventory = true
					
					if iter_12_1.new == true then
						var_12_1[iter_12_1.code] = true
					end
				else
					local var_12_2, var_12_3 = Account:addUnit(iter_12_1.id, iter_12_1.code, iter_12_1.exp, iter_12_1.g)
					
					if var_12_3 or GachaUnit:isTutorialMode() then
						var_12_1[iter_12_1.code] = true
					end
					
					iter_12_1.new = var_12_3 ~= nil
				end
			elseif iter_12_1.gacha_type == "equip" then
				if iter_12_1.ti == 1 then
					iter_12_1.new = Account:getCollectionEquip(iter_12_1.code) == nil and Account:isIncludeGachaTempInventory(iter_12_1.code) == false
					iter_12_1.add_temp_inventory = true
					
					if iter_12_1.new == true then
						var_12_1[iter_12_1.code] = true
					end
				else
					local var_12_4, var_12_5 = Account:addEquip(iter_12_1)
					
					if var_12_5 then
						var_12_1[iter_12_1.code] = true
					end
					
					iter_12_1.new = var_12_5 ~= nil
				end
			end
		end
		
		if arg_12_0.updated_collections then
			Account:updateCollectionData(arg_12_0.updated_collections)
		end
		
		if arg_12_0.update_temp_inventories then
			Account:updateGachaTempInventories(arg_12_0.update_temp_inventories)
			GachaUnit:updateGachaTempInventoryCount()
		end
		
		if arg_12_0.pickup_ceiling then
			Account:updatePickupCeilingData(arg_12_0.pickup_ceiling)
		end
		
		GachaUnit:seqIntroBookTouchWait(var_12_0, var_12_1)
	else
		balloon_message_with_sound("gacha_err")
	end
	
	local var_12_6 = #(arg_12_0.info.gacha_results or {})
	
	if arg_12_0.shop_value then
		ConditionContentsManager:dispatch("gacha.buy", {
			gacha_id = arg_12_0.shop_value,
			count = var_12_6
		})
	end
end

function HANDLER.gacha(arg_13_0, arg_13_1)
	if arg_13_1 == "btn_back" then
		GachaUnit:front()
	elseif arg_13_1 == "btn_summon_up" then
		GachaUnit:confirmBuy(1, false, 1)
	elseif arg_13_1 == "btn_summon" then
		GachaUnit:confirmBuy(1, false, 1)
	elseif arg_13_1 == "btn_summon_1" then
		GachaUnit:confirmBuy(1, false, 1)
	elseif arg_13_1 == "btn_summon_10" then
		GachaUnit:confirmBuy(1, false, 10)
	elseif arg_13_1 == "btn_close_block" then
		GachaUnit:touched()
	elseif arg_13_1 == "btn_rating" then
		GachaUnit:openReview()
	elseif arg_13_1 == "btn_close" then
		GachaUnit:close()
	elseif arg_13_1 == "btn_next" then
		GachaUnit:gachaNext()
	elseif arg_13_1 == "btn_rate" then
		GachaUnit:gachaRate()
	elseif arg_13_1 == "btn_book" then
		GachaUnit:moveCollection()
	elseif arg_13_1 == "btn_select_summon" then
		local var_13_0 = GachaUnit:getCurrentSelectCondition()
		
		UnlockSystem:isUnlockSystemAndMsg({
			exclude_story = true,
			id = var_13_0.system_unlock
		}, function()
			GachaUnit:pullSelectGacha()
		end)
	elseif arg_13_1 == "btn_select_previous" then
		local var_13_1 = GachaUnit:getCurrentSelectCondition()
		
		UnlockSystem:isUnlockSystemAndMsg({
			exclude_story = true,
			id = var_13_1.system_unlock
		}, function()
			GachaUnit:showPreviousSelectGachaInfo()
		end)
	elseif arg_13_1 == "btn_mileage_exchange" then
		GachaUnit:requestMileageExchange()
	elseif arg_13_1 == "btn_help" then
		GachaUnit:gachaCeilingHelp()
	elseif arg_13_1 == "btn_gacha_inven" then
		GachaTempInventory:showPopup()
	elseif arg_13_1 == "btn_help_group" then
		GachaUnit:gachaGroupPickupHelp2()
	elseif arg_13_1 == "btn_shop_open" then
		GachaUnit:groupPickupShopOpen()
	elseif arg_13_1 == "btn_select_info" then
		GachaUnit:gachaSelectHelp()
	end
end

function HANDLER.gacha_bar_menu2(arg_16_0, arg_16_1)
	if arg_16_1 == "btn_summon_gacha_rare" then
		GachaUnit:enterGachaRare()
	elseif arg_16_1 == "btn_summon_gacha_moonlight" then
		UnlockSystem:isUnlockSystemAndMsg({
			exclude_story = true,
			id = UNLOCK_ID.GACHA_MOONLIGHT
		}, function()
			GachaUnit:enterGachaMoonlight()
		end)
	elseif arg_16_1 == "btn_summon_gacha_normal" then
		GachaUnit:enterGachaNormal()
	elseif arg_16_1 == "btn_summon_gacha_element" then
		GachaUnit:enterGachaElement()
	end
end

function HANDLER.gacha_bar_banner(arg_18_0, arg_18_1)
	TopBarNew:checkhelpbuttonID("infogach")
	
	if string.starts(arg_18_1, "btn_banner") then
		local var_18_0 = string.split(arg_18_1, ":")[2]
		
		if string.starts(var_18_0, "gacha_story_") or var_18_0 == "gacha_spdash" then
			GachaUnit:enterGachaStory(var_18_0)
		elseif string.starts(var_18_0, "gacha_customgroup") then
			GachaUnit:enterGachaCustomGroup()
		elseif string.starts(var_18_0, "gacha_customspecial") then
			GachaUnit:enterGachaCustomSpecial()
		elseif string.starts(var_18_0, "gacha_substory") then
			GachaUnit:enterGachaSubstory()
		elseif string.starts(var_18_0, "gacha_special") then
			GachaUnit:enterGachaSpecial()
		elseif string.starts(var_18_0, "gacha_select") then
			GachaUnit:checkGachaSelect(var_18_0)
		else
			GachaUnit:enterGachaPickup(var_18_0)
		end
	end
end

function HANDLER.gacha_skip_btn(arg_19_0, arg_19_1)
	if arg_19_1 == "btn_skip" then
		GachaUnit:fullSkip()
	end
end

function HANDLER.gacha_result_artifact(arg_20_0, arg_20_1)
	if arg_20_1 == "btn_back" then
		GachaUnit:front()
	elseif arg_20_1 == "btn_skip" then
		GachaUnit:fullSkip()
	elseif arg_20_1 == "btn_close" then
		GachaUnit:close()
	elseif arg_20_1 == "btn_next" then
		GachaUnit:gachaNext()
	elseif arg_20_1 == "btn_summon_r1" then
		GachaUnit:confirmBuy(nil, true)
	elseif arg_20_1 == "btn_summon_r2" then
		GachaUnit:confirmBuy(nil, true)
	end
end

function HANDLER.gacha_result_unit(arg_21_0, arg_21_1)
	if arg_21_1 == "btn_back" then
		GachaUnit:front()
		TutorialGuide:procGuide("summon_hero")
	elseif arg_21_1 == "btn_close" then
		if arg_21_0.is_gacha then
			GachaUnit:close()
		else
			UnitSummonResult:close()
		end
	elseif arg_21_1 == "btn_skip" then
		GachaUnit:fullSkip()
	elseif arg_21_1 == "btn_next" then
		GachaUnit:gachaNext()
	elseif arg_21_1 == "btn_summon_r1" then
		GachaUnit:confirmBuy(nil, true)
	elseif arg_21_1 == "btn_summon_r2" then
		GachaUnit:confirmBuy(nil, true)
	elseif arg_21_1 == "btn_dedi" then
		if arg_21_0.is_gacha then
			GachaUnit:on_btn_dedi()
		else
			UnitSummonResult:on_btn_dedi()
		end
	elseif arg_21_1 == "btn_summon_up" then
		GachaUnit:confirmBuy(nil, true)
	elseif arg_21_1 == "btn_share" then
		GachaUnit:shareUnit()
	end
end

function HANDLER.gacha_info(arg_22_0, arg_22_1)
end

function HANDLER.gacha_info_special(arg_23_0, arg_23_1)
end

function HANDLER.gacha_special_info_p(arg_24_0, arg_24_1)
	if arg_24_1 == "btn_special_next" then
		GachaUnit:changeSpecialInfo(true)
	elseif arg_24_1 == "btn_special_return" then
		GachaUnit:changeSpecialInfo(false)
	elseif arg_24_1 == "btn_special_info_close" then
		GachaUnit:closeSpecialInfo()
	end
end

function HANDLER.gacha_special(arg_25_0, arg_25_1)
	if arg_25_1 == "btn_info" or arg_25_1 == "btn_special_info_close" then
		GachaUnit:toggleSpecialInfo()
	elseif arg_25_1 == "btn_special_next" then
		GachaUnit:changeSpecialInfo(true)
	elseif arg_25_1 == "btn_special_return" then
		GachaUnit:changeSpecialInfo(false)
	elseif arg_25_1 == "btn_preview" then
		balloon_message_with_sound("msg_gacha_special_wait")
	elseif string.starts(arg_25_1, "btn_select") then
		GachaUnit:setSpecialGachaCeillingGrade(to_n(string.split(arg_25_1, ":")[2]))
	elseif arg_25_1 == "btn_change" then
		GachaUnit:popupChangeSpecialCeiling()
	elseif arg_25_1 == "btn_hero_info_1" then
		GachaUnit:popupSpecialCeilingCharacter(1)
	elseif arg_25_1 == "btn_hero_info_2" then
		GachaUnit:popupSpecialCeilingCharacter(2)
	end
end

function HANDLER.gacha_summary(arg_26_0, arg_26_1)
	if arg_26_1 == "btn_back" then
		GachaUnit:front()
	elseif arg_26_1 == "btn_summon_r1" then
		GachaUnit:confirmBuy(nil, true)
	elseif arg_26_1 == "btn_summon_r2" then
		GachaUnit:confirmBuy(nil, true)
	elseif arg_26_1 == "btn_close" then
		GachaUnit:close()
	elseif arg_26_1 == "btn_next" then
		GachaUnit:gachaNext()
	elseif arg_26_1 == "btn_select_retry" then
		GachaUnit:pullSelectGacha()
	elseif arg_26_1 == "btn_select_confirm" then
		GachaUnit:decideSelectGacha()
	elseif arg_26_1 == "btn_record" then
		GachaUnit:saveSelectGacha()
		TutorialGuide:procGuide("summon_select")
	elseif arg_26_1 == "btn_share" then
		GachaUnit:shareSummary()
	end
end

function HANDLER.gacha_story_pickup(arg_27_0, arg_27_1)
	if arg_27_1 == "btn_hero_sel" then
		GachaUnit:popupSelectSubstoryHero()
	elseif arg_27_1 == "btn_popup_info" then
		GachaUnit:popupStoryInfo()
	end
end

function HANDLER.gacha_pickup_b(arg_28_0, arg_28_1)
	if arg_28_1 == "btn_info" or arg_28_1 == "btn_pickup_info_close" then
		GachaUnit:togglePickupInfo()
	elseif arg_28_1 == "btn_popup_info" then
		if GachaUnit:getGachaMode() == "gacha_substory" then
			GachaUnit:popupStoryInfo()
		else
			GachaUnit:popupPickupInfo()
		end
	elseif arg_28_1 == "btn_arti_info" then
		GachaUnit:togglePickupArtifactInfo()
	end
end

function HANDLER.gacha_element_item(arg_29_0, arg_29_1)
	if arg_29_1 == "btn_element1" then
		GachaUnit:toggleElement(1)
	elseif arg_29_1 == "btn_element2" then
		GachaUnit:toggleElement(2)
	elseif arg_29_1 == "btn_element3" then
		GachaUnit:toggleElement(3)
	elseif arg_29_1 == "btn_element4" then
		GachaUnit:toggleElement(4)
	elseif arg_29_1 == "btn_element5" then
		GachaUnit:toggleElement(5)
	end
end

function HANDLER.gacha_element(arg_30_0, arg_30_1)
	if arg_30_1 == "btn_close" then
		GachaUnit:toggleElement()
	elseif arg_30_1 == "btn_summon_3_5" then
		GachaUnit:confirmBuy(1, false)
	elseif arg_30_1 == "btn_summon_4_5" then
		GachaUnit:confirmBuy(2, false)
	elseif arg_30_1 == "btn_rate_3_5" then
		GachaUnit:gachaRate(nil, 1)
	elseif arg_30_1 == "btn_rate_4_5" then
		GachaUnit:gachaRate(nil, 2)
	end
end

function HANDLER.gacha_inven_item(arg_31_0, arg_31_1)
	if arg_31_1 == "btn_select_left" then
		GachaTempInventory:selectItem(arg_31_0)
	elseif arg_31_1 == "btn_select_right" then
		GachaTempInventoryBasket:selectItem(arg_31_0)
	end
end

function HANDLER.gacha_dash(arg_32_0, arg_32_1)
	if arg_32_1 == "btn_buy" then
		GachaUnit:packageStartBuy()
	elseif arg_32_1 == "btn_summon" then
		GachaUnit:gachaStartBuy()
	elseif arg_32_1 == "btn_popup_info" then
		GachaUnit:popupStartDashInfo()
	end
end

function HANDLER.gacha_dash_story(arg_33_0, arg_33_1)
	if arg_33_1 == "btn_buy" then
		GachaUnit:packageStartBuy()
	elseif arg_33_1 == "btn_summon" then
		GachaUnit:gachaStartBuy()
	elseif arg_33_1 == "btn_popup_info" then
		GachaUnit:popupStoryDashInfo()
	end
end

function HANDLER.gacha_select(arg_34_0, arg_34_1)
	if arg_34_1 == "btn_popup_info" then
		GachaUnit:popupSelectInfo()
	end
end

function HANDLER.gacha_dash_luckyweek(arg_35_0, arg_35_1)
	if arg_35_1 == "btn_buy" then
		GachaUnit:packageStartBuy()
	elseif arg_35_1 == "btn_summon" then
		GachaUnit:gachaStartBuy()
	elseif arg_35_1 == "btn_popup_info" then
		GachaUnit:popupStoryDashInfo()
	end
end

function HANDLER.gacha_pickup_group(arg_36_0, arg_36_1)
	if string.starts(arg_36_1, "btn_popup_info") then
		GachaUnit:gachaGroupPickupHelp(string.split(arg_36_1, ":")[2])
	elseif arg_36_1 == "btn_info" or arg_36_1 == "btn_pickup_info_close" then
		GachaUnit:togglePickupInfo()
	elseif arg_36_1 == "btn_select_target" then
		GachaUnit:popupCustomGroupSelect()
	end
end

function HANDLER.gacha_1special_custom(arg_37_0, arg_37_1)
	if string.starts(arg_37_1, "btn_popup_info") then
		GachaUnit:gachaGroupPickupHelp(string.split(arg_37_1, ":")[2])
	elseif arg_37_1 == "btn_click" or arg_37_1 == "btn_change" then
		GachaUnit:popupChangeCustomSpecialSelect(arg_37_0.select_idx)
	elseif arg_37_1 == "btn_select" then
		GachaUnit:changeCustomSpecialSelect(arg_37_0.select_idx)
	end
end

function HANDLER_BEFORE.gacha_inven_item(arg_38_0, arg_38_1, arg_38_2)
	arg_38_0.touch_tick = systick()
end

function createGachaBanner(arg_39_0, arg_39_1)
	local var_39_0
	
	if arg_39_0.use_lobby then
		var_39_0 = load_control("wnd/gacha_bar_banner_lobby.csb")
	else
		var_39_0 = load_control("wnd/gacha_bar_banner.csb")
	end
	
	var_39_0.opts = arg_39_0
	
	if_set_visible(var_39_0, "select", false)
	if_set_visible(var_39_0, "n_time", false)
	if_set_visible(var_39_0, "n_gacha_title_limited", false)
	if_set_visible(var_39_0, "n_gacha_title", false)
	if_set_visible(var_39_0, "n_gacha_title_group", false)
	if_set_visible(var_39_0, "n_gacha_title_group_limited", false)
	if_set_visible(var_39_0, "n_bi", false)
	
	local var_39_1
	
	if arg_39_0.left_character then
		var_39_1 = arg_39_0.left_character
	elseif arg_39_0.right_character then
		var_39_1 = arg_39_0.right_character
	end
	
	local var_39_2
	local var_39_3
	local var_39_4
	local var_39_5
	local var_39_6
	local var_39_7
	local var_39_8
	local var_39_9
	local var_39_10
	local var_39_11
	
	if arg_39_0.gacha_substory_banner then
		var_39_5 = DB("gacha_substory_select_list", arg_39_0.id, {
			"banner"
		})
		var_39_2 = DB("character", arg_39_0.id, {
			"name"
		})
		
		if_set_visible(var_39_0, "btn_banner", false)
	else
		local var_39_12 = arg_39_0.id
		
		if arg_39_0.gacha_ui_id then
			var_39_12 = arg_39_0.gacha_ui_id
		end
		
		local var_39_13, var_39_14
		
		var_39_4, var_39_5, var_39_6, var_39_13, var_39_8, var_39_9, var_39_14, var_39_11 = DB("gacha_ui", var_39_12, {
			"limit",
			"banner",
			"banner_data",
			"group",
			"bi_banner",
			"bi_banner_data",
			"ui_type",
			"custom_banner"
		})
		var_39_2 = DB("character", var_39_1, {
			"name"
		})
	end
	
	if not var_39_5 then
		for iter_39_0 = 1, 10 do
			Log.e(arg_39_0.id .. " banner DATA NOT FOUND !!!!")
		end
		
		return nil
	end
	
	if var_39_6 ~= nil then
		var_39_3 = string.split(var_39_6, ";")
	end
	
	if var_39_8 then
		if_set_sprite(var_39_0, "img_banner", "banner/" .. var_39_5 .. ".png")
		
		if var_39_3 ~= nil then
			var_39_0:getChildByName("n_gacha_title"):setPosition(var_39_3[2], var_39_3[3]):setAnchorPoint(0, 0)
		end
		
		if var_39_8 then
			local var_39_15 = var_39_0:getChildByName("n_bi")
			
			if false and (arg_39_1 == "gacha_dash" or arg_39_1 == "gacha_start" or arg_39_1 == "gacha_select") then
				if_set_visible(var_39_0, "n_bi_dash", true)
				if_set_visible(var_39_15, nil, false)
				
				var_39_15 = var_39_0:getChildByName("n_bi_dash")
			else
				if_set_visible(var_39_0, "n_bi_dash", false)
				if_set_visible(var_39_15, nil, true)
			end
			
			if get_cocos_refid(var_39_15) then
				if_set_visible(var_39_0, "n_bi_dash", false)
				if_set_visible(var_39_15, nil, true)
				if_set_sprite(var_39_15, nil, "banner/" .. var_39_8 .. ".png")
				GachaUnit:setDataUI(var_39_15, var_39_9)
			end
		end
	elseif var_39_11 then
		local var_39_16 = "n_gacha_title_group_limited"
		
		if_set_visible(var_39_0, var_39_16, true)
		if_set(var_39_0, "txt_cha", T(var_39_2))
		if_set_sprite(var_39_0, var_39_16, "img/" .. var_39_11 .. ".png")
		if_set_sprite(var_39_0, "img_banner", "banner/" .. var_39_5 .. ".png")
		
		if var_39_3 ~= nil then
			var_39_0:getChildByName(var_39_16):setPosition(var_39_3[2], var_39_3[3]):setAnchorPoint(0, 0)
		end
	elseif arg_39_0.gacha_start == "y" then
		if_set(var_39_0, "txt_cha", T(var_39_2))
		if_set_sprite(var_39_0, "img_banner", "banner/" .. var_39_5 .. ".png")
		
		if var_39_3 ~= nil then
			var_39_0:getChildByName("n_gacha_title"):setPosition(var_39_3[2], var_39_3[3]):setAnchorPoint(0, 0)
		end
	elseif arg_39_0.gacha_story == "y" then
		if_set(var_39_0, "txt_cha", T(var_39_2))
		if_set_sprite(var_39_0, "img_banner", "banner/" .. var_39_5 .. ".png")
		
		if var_39_3 ~= nil then
			var_39_0:getChildByName("n_gacha_title"):setPosition(var_39_3[2], var_39_3[3]):setAnchorPoint(0, 0)
		end
		
		if var_39_8 then
			local var_39_17 = var_39_0:getChildByName("n_bi_dash")
			
			if get_cocos_refid(var_39_17) then
				if_set_visible(var_39_17, nil, true)
				if_set_sprite(var_39_17, nil, "banner/" .. var_39_8 .. ".png")
				GachaUnit:setDataUI(var_39_17, var_39_9)
			end
		end
	elseif var_39_4 ~= nil then
		local var_39_18 = "n_gacha_title_limited"
		
		if_set_visible(var_39_0, var_39_18, true)
		if_set(var_39_0, "txt_cha_limited", T(var_39_2))
		if_set_sprite(var_39_0, "img_banner", "banner/" .. var_39_5 .. ".png")
		
		if var_39_3 ~= nil then
			var_39_0:getChildByName(var_39_18):setPosition(var_39_3[2], var_39_3[3]):setAnchorPoint(0, 0)
		end
	elseif var_39_4 == nil then
		local var_39_19 = "n_gacha_title"
		
		if_set_visible(var_39_0, var_39_19, true)
		if_set(var_39_0, "txt_cha", T(var_39_2))
		if_set_sprite(var_39_0, "img_banner", "banner/" .. var_39_5 .. ".png")
		
		if var_39_3 ~= nil then
			var_39_0:getChildByName(var_39_19):setPosition(var_39_3[2], var_39_3[3]):setAnchorPoint(0, 0)
		end
	else
		return nil
	end
	
	local var_39_20 = var_39_0:getChildByName("n_banner")
	local var_39_21 = var_39_20:getChildByName("btn_banner")
	
	if arg_39_0.gacha_start == "y" then
		var_39_21:setName("btn_banner:gacha_start")
		var_39_20:setName("n_banner:gacha_start")
	elseif arg_39_0.customgroup then
		var_39_21:setName("btn_banner:gacha_customgroup")
		var_39_20:setName("n_banner:gacha_customgroup")
	elseif arg_39_0.customspecial then
		var_39_21:setName("btn_banner:gacha_customspecial")
		var_39_20:setName("n_banner:gacha_customspecial")
	else
		var_39_21:setName("btn_banner:" .. arg_39_0.id)
		var_39_20:setName("n_banner:" .. arg_39_0.id)
	end
	
	if arg_39_0.touch_block then
		var_39_21:setTouchEnabled(false)
	end
	
	if arg_39_0.end_time then
		local var_39_22 = var_39_0:getChildByName("n_time")
		
		var_39_22.end_time_info = to_n(arg_39_0.end_time)
		var_39_22.banner_opts = arg_39_0
	else
		if_set_visible(var_39_0, "n_time", false)
	end
	
	return var_39_0
end

GachaUnit = {}

function GachaUnit.setCustomData(arg_40_0, arg_40_1, arg_40_2)
	if not arg_40_0.vars then
		return 
	end
	
	if not arg_40_0.vars.custom_vars then
		arg_40_0.vars.custom_vars = {}
	end
	
	arg_40_0.vars.custom_vars[arg_40_1] = arg_40_2
end

function GachaUnit.getCustomData(arg_41_0, arg_41_1)
	if not arg_41_0.vars or not arg_41_0.vars.custom_vars then
		return nil
	end
	
	return arg_41_0.vars.custom_vars[arg_41_1]
end

function GachaUnit.gachaCeilingHelp(arg_42_0)
	local var_42_0 = load_dlg("shop_buy_detail", true, "wnd")
	
	if arg_42_0.vars and arg_42_0.vars.gacha_mode == "gacha_special" then
		if_set(var_42_0, "txt_title", T("ui_gacha_special_pickup_title"))
		UIUtil:setScrollViewText(var_42_0:getChildByName("scrollview"), T("ui_gacha_special_pickup_desc"))
	elseif arg_42_0.vars and arg_42_0.vars.gacha_mode == "gacha_moonlight" then
		if_set(var_42_0, "txt_title", T("ui_gacha_moonlight_upgrade_title"))
		UIUtil:setScrollViewText(var_42_0:getChildByName("scrollview"), T("ui_gacha_moonlight_upgrade_desc"))
	else
		if_set(var_42_0, "txt_title", T("ui_gacha_pickup_popup_title"))
		UIUtil:setScrollViewText(var_42_0:getChildByName("scrollview"), T("ui_gacha_pickup_popup_desc"))
	end
	
	Dialog:msgBox("", {
		dlg = var_42_0
	})
end

function GachaUnit.popupPickupInfo(arg_43_0)
	arg_43_0:gachaEtcHelp("pickup", arg_43_0.vars.pickup_data)
end

function GachaUnit.popupSelectInfo(arg_44_0)
	arg_44_0:gachaEtcHelp("select")
end

function GachaUnit.popupStoryInfo(arg_45_0)
	arg_45_0:gachaEtcHelp("story")
end

function GachaUnit.setDataPopupStoryInfo(arg_46_0, arg_46_1, arg_46_2)
	if not arg_46_0.vars then
		return 
	end
	
	arg_46_0.vars.story_dash_help_info = {
		id = arg_46_1,
		title = arg_46_2
	}
end

function GachaUnit.popupStartDashInfo(arg_47_0)
	arg_47_0:gachaEtcHelp("start_dash")
end

function GachaUnit.popupStoryDashInfo(arg_48_0)
	if not arg_48_0.vars.story_dash_help_info then
		return 
	end
	
	arg_48_0:gachaEtcHelp("story_dash", arg_48_0.vars.story_dash_help_info)
end

function GachaUnit.gachaEtcHelp(arg_49_0, arg_49_1, arg_49_2)
	local var_49_0 = load_dlg("gacha_popup_info", true, "wnd")
	
	if arg_49_1 == "pickup" then
		if arg_49_2.limit == "y" then
			if_set(var_49_0, "txt_title", T("gacha_limit_period_tag"))
			if_set(var_49_0, "txt_desc", T("gacha_limit_desc"))
		elseif arg_49_2.limit == "a" then
			if_set(var_49_0, "txt_title", T("gacha_limit2_period_tag"))
			if_set(var_49_0, "txt_desc", T("gacha_limit2_desc"))
		elseif arg_49_2.limit == "b" then
			if_set(var_49_0, "txt_title", T("gacha_limit3_period_tag"))
			if_set(var_49_0, "txt_desc", T("gacha_limit3_desc"))
		end
	elseif arg_49_1 == "select" then
		if_set(var_49_0, "txt_title", T("gacha_select_warning_popup_title"))
		if_set(var_49_0, "txt_desc", T("gacha_select_warning_popup_desc"))
	elseif arg_49_1 == "story" then
		if_set(var_49_0, "txt_title", T("ui_gachasubstory_info_title"))
		if_set(var_49_0, "txt_desc", T("ui_gachasubstory_info_desc1") .. "\n\n" .. T("ui_gachasubstory_info_desc2"))
	elseif arg_49_1 == "story_dash" then
		local var_49_1 = arg_49_0.vars.story_dash_help_info.id
		local var_49_2 = arg_49_0.vars.story_dash_help_info.title
		
		if_set(var_49_0, "txt_title", T(var_49_2))
		
		local var_49_3 = DBT("gacha_story_ui", var_49_1, {
			"ui_info_text_title",
			"ui_info_text_1",
			"ui_info_text_2",
			"ui_info_text_3",
			"ui_info_text_4"
		})
		local var_49_4 = T(var_49_3.ui_info_text_title) .. "\n\n"
		
		for iter_49_0 = 1, 4 do
			if var_49_3["ui_info_text_" .. iter_49_0] then
				var_49_4 = var_49_4 .. T(var_49_3["ui_info_text_" .. iter_49_0]) .. "\n\n"
			end
		end
		
		if_set(var_49_0, "txt_desc", var_49_4)
	elseif arg_49_1 == "start_dash" then
		local var_49_5 = (("" .. T("gacha_start_desc_1") .. "\n\n") .. T("gacha_start_desc_2") .. "\n\n") .. T("gacha_start_desc_3") .. "\n\n"
		
		if_set(var_49_0, "txt_desc", var_49_5)
		if_set(var_49_0, "txt_title", T("ns_gacha_start_10"))
	else
		Log.e("check GachaUONit.gachaEtcHelp!")
	end
	
	Dialog:msgBox("", {
		dlg = var_49_0
	})
end

function GachaUnit.gachaGroupPickupHelp(arg_50_0, arg_50_1, arg_50_2)
	local var_50_0 = load_dlg("gacha_popup_info", true, "wnd")
	local var_50_1
	
	if arg_50_0.vars.gacha_mode == "gacha_customgroup" then
		var_50_1 = "to_gpmileage1"
	elseif arg_50_0.vars.gacha_mode == "gacha_customgroup" then
		var_50_1 = "to_gpmileage2"
	end
	
	local var_50_2 = DB("item_token", var_50_1, {
		"name"
	})
	
	if arg_50_1 == "limit" then
		if_set(var_50_0, "txt_title", T("gacha_limit_group_info_title"))
		if_set(var_50_0, "txt_desc", T("gacha_limit_group_info_desc", {
			token_type = T(var_50_2)
		}))
	elseif arg_50_1 == "customgroup" then
		if_set(var_50_0, "txt_title", T("gacha_customgroup_info_title"))
		if_set(var_50_0, "txt_desc", T("gacha_customgroup_info_desc", {
			token_type = T(var_50_2)
		}))
	elseif arg_50_1 == "customspecial" then
		if_set(var_50_0, "txt_title", T("ui_ct_gachasepcial_caution_title"))
		if_set(var_50_0, "txt_desc", T("ui_ct_gachasepcial_caution_desc", {
			token_type = T(var_50_2)
		}))
	else
		if_set(var_50_0, "txt_title", T("gacha_group_info_title"))
		if_set(var_50_0, "txt_desc", T("gacha_group_info_desc", {
			token_type = T(var_50_2)
		}))
	end
	
	if arg_50_2 then
		local var_50_3 = var_50_0:getChildByName("n_popup_move")
		
		var_50_0:getChildByName("n_popup"):setPositionX(var_50_3:getPositionX())
	end
	
	Dialog:msgBox("", {
		dlg = var_50_0
	})
end

function GachaUnit.gachaSelectHelp(arg_51_0)
	local var_51_0 = load_dlg("gacha_popup_info", true, "wnd")
	
	if_set(var_51_0, "txt_title", T("gacha_select_warning_popup_title"))
	if_set(var_51_0, "txt_desc", T("gacha_select_warning_popup_desc"))
	
	local var_51_1 = var_51_0:getChildByName("n_popup_move_select")
	local var_51_2 = var_51_0:getChildByName("n_popup")
	
	if get_cocos_refid(var_51_1) then
		var_51_2:setPositionY(var_51_1:getPositionY())
	end
	
	Dialog:msgBox("", {
		dlg = var_51_0
	})
end

function GachaUnit.gachaGroupPickupHelp2(arg_52_0)
	local var_52_0 = load_dlg("shop_buy_detail", true, "wnd")
	
	if arg_52_0.vars and arg_52_0.vars.gacha_mode == "gacha_customgroup" then
		if_set(var_52_0, "txt_title", T("ui_gacha_customgroup_popup_title"))
		UIUtil:setScrollViewText(var_52_0:getChildByName("scrollview"), T("ui_gacha_customgroup_popup_desc"))
	elseif arg_52_0.vars and arg_52_0.vars.gacha_mode == "gacha_customspecial" then
		if_set(var_52_0, "txt_title", T("ui_ct_gacha_shop_title"))
		UIUtil:setScrollViewText(var_52_0:getChildByName("scrollview"), T("ui_ct_gacha_shop_info"))
	else
		if_set(var_52_0, "txt_title", T("ui_gacha_grouppickup_popup_title"))
		UIUtil:setScrollViewText(var_52_0:getChildByName("scrollview"), T("ui_gacha_grouppickup_popup_desc"))
	end
	
	Dialog:msgBox("", {
		dlg = var_52_0
	})
end

function GachaUnit.setTutorialMode(arg_53_0, arg_53_1)
	arg_53_0.vars.tutorial_mode = arg_53_1
end

function GachaUnit.isTutorialMode(arg_54_0)
	if not arg_54_0.vars then
		return false
	end
	
	return arg_54_0.vars.tutorial_mode or TutorialGuide:isPlayingTutorial("system_011")
end

function GachaUnit.gachaSelectGetPopup(arg_55_0, arg_55_1)
	Dialog:msgBox(T("gacha_select_get"), {
		handler = function()
			GachaUnit:gachaSelectGetPopupAddResult(arg_55_1)
		end,
		title = T("gacha_select_get_title")
	})
end

function GachaUnit.gachaSelectGetPopupAddResult(arg_57_0, arg_57_1)
	if arg_57_1 and #arg_57_1 > 0 then
		UIAction:Add(SEQ(DELAY(200), CALL(Account.addRewardCoinPopupMsgBox, arg_57_0, arg_57_1, function()
			GachaUnit:front()
		end)), arg_57_0, "block")
	else
		GachaUnit:front()
	end
end

function GachaUnit.buy(arg_59_0, arg_59_1, arg_59_2, arg_59_3, arg_59_4)
	local var_59_0 = arg_59_3 or arg_59_0.vars.last_gacha_count or 1
	local var_59_1 = arg_59_0:getCeilingData(arg_59_1)
	
	if arg_59_1 == "gacha_moonlight" and arg_59_0:isMoonlightBonus() then
		arg_59_0.vars.last_not_req_rand = true
	elseif var_59_1 then
		local var_59_2 = var_59_1.ceiling_count
		
		if var_59_2 and to_n(var_59_2) > 0 then
			local var_59_3 = var_59_1.ceiling_current
			
			if var_59_0 > to_n(var_59_2) - to_n(var_59_3) then
				arg_59_0.vars.last_not_req_rand = true
			else
				arg_59_0.vars.last_not_req_rand = false
			end
		else
			arg_59_0.vars.last_not_req_rand = false
		end
	else
		arg_59_0.vars.last_not_req_rand = false
	end
	
	arg_59_0.vars.last_buy_item = arg_59_1
	arg_59_0.vars.last_gacha_count = var_59_0
	arg_59_0.vars.last_use_token = arg_59_4
	arg_59_0.vars.warning_token_change = nil
	
	UIUtil:playNPCSoundRandomly("gacha.buygacha")
	
	arg_59_2 = arg_59_2 or {}
	
	if PLATFORM == "win32" and arg_59_0.vars.test_temp == 1 then
		arg_59_2 = {
			u = 0,
			e = 0
		}
		arg_59_0.vars.last_gacha_count = 10
	end
	
	local var_59_4 = {
		item = arg_59_1,
		ricu = arg_59_2.u,
		rice = arg_59_2.e,
		gc = arg_59_0.vars.last_gacha_count,
		gsp_id = arg_59_0.vars.gsp_id
	}
	
	if arg_59_0:isMoonlightBonus() then
		var_59_4.gacha_moonlight_bonus = 1
	end
	
	query("buy_gacha", var_59_4)
end

function GachaUnit.on_btn_dedi(arg_60_0)
	DevoteTooltip:showDevoteDetail(arg_60_0.vars.unit, arg_60_0.vars.gacha_layer, {
		not_my_unit = true
	})
end

function GachaUnit._test_temp(arg_61_0, arg_61_1)
	arg_61_0.vars.test_temp = to_n(arg_61_1)
end

function GachaUnit.buy_more(arg_62_0, arg_62_1, arg_62_2, arg_62_3, arg_62_4)
	BackButtonManager:pop("GachaUnit.summaryUI")
	
	local var_62_0 = arg_62_3 or arg_62_0.vars.last_gacha_count or 1
	local var_62_1 = arg_62_0:getCeilingData(arg_62_1)
	
	if arg_62_1 == "gacha_moonlight" and arg_62_0:isMoonlightBonus() then
		arg_62_0.vars.last_not_req_rand = true
	elseif var_62_1 then
		local var_62_2 = var_62_1.ceiling_count
		
		if var_62_2 and to_n(var_62_2) > 0 then
			local var_62_3 = var_62_1.ceiling_current
			
			if var_62_0 > to_n(var_62_2) - to_n(var_62_3) then
				arg_62_0.vars.last_not_req_rand = true
			else
				arg_62_0.vars.last_not_req_rand = false
			end
		else
			arg_62_0.vars.last_not_req_rand = false
		end
	else
		arg_62_0.vars.last_not_req_rand = false
	end
	
	arg_62_0.vars.buy_more = true
	arg_62_0.vars.last_buy_item = arg_62_1
	arg_62_0.vars.last_gacha_count = arg_62_3 or arg_62_0.vars.last_gacha_count or 1
	arg_62_0.vars.last_use_token = arg_62_4
	arg_62_0.vars.warning_token_change = nil
	arg_62_2 = arg_62_2 or {}
	
	if PLATFORM == "win32" and arg_62_0.vars.test_temp == 1 then
		arg_62_2 = {
			u = 0,
			e = 0
		}
		arg_62_0.vars.last_gacha_count = 10
	end
	
	local var_62_4 = {
		item = arg_62_1,
		ricu = arg_62_2.u,
		rice = arg_62_2.e,
		gc = arg_62_0.vars.last_gacha_count,
		gsp_id = arg_62_0.vars.gsp_id
	}
	
	if arg_62_0:isMoonlightBonus() then
		var_62_4.gacha_moonlight_bonus = 1
	end
	
	query("buy_gacha", var_62_4)
end

function GachaUnit.is_new(arg_63_0)
	if not arg_63_0.vars or not arg_63_0.vars.new_codes or not arg_63_0.vars.code then
		return false
	end
	
	if string.starts(arg_63_0.vars.gacha_mode, "gacha_select") then
		return false
	else
		return arg_63_0.vars.new_codes[arg_63_0.vars.code] == true and to_n(arg_63_0.vars.summoned_code[arg_63_0.vars.code]) < 2
	end
end

function GachaUnit.saveSceneState(arg_64_0, arg_64_1, arg_64_2)
	if not arg_64_0.vars.current_info then
		arg_64_0.vars.current_info = {}
	end
	
	arg_64_0.vars.current_info.mode = arg_64_1
	arg_64_0.vars.current_info.data = arg_64_2
end

function GachaUnit.getGachaSelectCondition(arg_65_0, arg_65_1)
	if arg_65_0.vars and arg_65_0.vars.gacha_select_condition then
		return arg_65_0.vars.gacha_select_condition[arg_65_1]
	end
end

function GachaUnit.show(arg_66_0, arg_66_1, arg_66_2)
	arg_66_0.vars = {}
	arg_66_0.vars.layer = arg_66_1 or SceneManager:getDefaultLayer()
	arg_66_0.vars.gacha_ui_list = {}
	
	for iter_66_0 = 1, 99 do
		local var_66_0 = {}
		
		var_66_0.id, var_66_0.name, var_66_0.sort, var_66_0.gacha_ui_id, var_66_0.icon, var_66_0.icon_selective, var_66_0.img_eff = DBN("gacha_ui_list", iter_66_0, {
			"id",
			"name",
			"sort",
			"gacha_ui_id",
			"icon",
			"icon_selective",
			"img_eff"
		})
		
		if not var_66_0.id then
			break
		end
		
		table.push(arg_66_0.vars.gacha_ui_list, var_66_0)
	end
	
	table.sort(arg_66_0.vars.gacha_ui_list, function(arg_67_0, arg_67_1)
		return arg_67_0.sort < arg_67_1.sort
	end)
	
	arg_66_0.vars.gacha_select_condition = {}
	
	for iter_66_1 = 1, 99 do
		local var_66_1 = {}
		
		var_66_1.id, var_66_1.gacha_select_name, var_66_1.system_unlock, var_66_1.gacha_select_check, var_66_1.gacha_select_info_title, var_66_1.gacha_select_info_desc, var_66_1.gacha_select_info_icon, var_66_1.map_background, var_66_1.img, var_66_1.img_eff = DBN("gacha_select_condition", iter_66_1, {
			"id",
			"gacha_select_name",
			"system_unlock",
			"gacha_select_check",
			"gacha_select_info_title",
			"gacha_select_info_desc",
			"gacha_select_info_icon",
			"map_background",
			"img",
			"img_eff"
		})
		
		if not var_66_1.id then
			break
		end
		
		arg_66_0.vars.gacha_select_condition[var_66_1.id] = var_66_1
	end
	
	arg_66_0.vars.gacha_story_ui = {}
	
	for iter_66_2 = 1, 99 do
		local var_66_2 = {}
		
		var_66_2.id, var_66_2.char1_id, var_66_2.char1_data, var_66_2.char2_id, var_66_2.char2_data, var_66_2.char3_id, var_66_2.char3_data, var_66_2.char4_id, var_66_2.char4_data, var_66_2.bi_img, var_66_2.bi_data, var_66_2.title, var_66_2.text_1, var_66_2.text_2, var_66_2.text_3, var_66_2.text_4, var_66_2.grow_tint = DBN("gacha_story_ui", iter_66_2, {
			"id",
			"char1_id",
			"char1_data",
			"char2_id",
			"char2_data",
			"char3_id",
			"char3_data",
			"char4_id",
			"char4_data",
			"bi_img",
			"bi_data",
			"ui_info_text_title",
			"ui_info_text_1",
			"ui_info_text_2",
			"ui_info_text_3",
			"ui_info_text_4",
			"grow_tint"
		})
		
		if not var_66_2.id then
			break
		end
		
		arg_66_0.vars.gacha_story_ui[var_66_2.id] = var_66_2
	end
	
	arg_66_0.vars.gacha_mode = "no_menu"
	arg_66_0.vars.element_mode = nil
	arg_66_0.vars.gsp_id = nil
	arg_66_0.vars.new_codes = {}
	arg_66_0.vars.common = {}
	arg_66_0.vars.intro = {}
	arg_66_0.vars.book = {}
	arg_66_0.vars.result = {}
	
	arg_66_0:setMode("init")
	
	arg_66_0.vars.ei_colors = {
		"wind",
		"fire",
		"ice",
		"dark",
		"light"
	}
	arg_66_0.vars.ei_icons = {
		"icon_menu_earth.png",
		"icon_menu_fire.png",
		"icon_menu_ice.png",
		"icon_menu_prodark.png",
		"icon_menu_prolight.png"
	}
	arg_66_0.vars.gacha_layer = cc.Layer:create()
	
	arg_66_0.vars.layer:addChild(arg_66_0.vars.gacha_layer)
	
	local var_66_3 = Account:getGachaShopInfo()
	
	arg_66_0.vars.pickup_list = {}
	arg_66_0.vars.currency_list = {
		"crystal",
		"ticketrare",
		"ticketspecial",
		"ticketmoon",
		"ticketnormal",
		"hero2"
	}
	
	local var_66_4 = {}
	
	if var_66_3.pickup then
		for iter_66_3, iter_66_4 in pairs(var_66_3.pickup) do
			table.push(arg_66_0.vars.pickup_list, iter_66_4)
			
			if iter_66_4.event_shop_data and iter_66_4.event_shop_data.token then
				local var_66_5 = iter_66_4.event_shop_data.token
				
				if string.starts(var_66_5, "to_") then
					var_66_5 = string.sub(var_66_5, 4, -1)
				end
				
				var_66_4[var_66_5] = 1
			end
		end
		
		table.sort(arg_66_0.vars.pickup_list, function(arg_68_0, arg_68_1)
			return arg_68_0.sort < arg_68_1.sort
		end)
	end
	
	for iter_66_5, iter_66_6 in pairs(var_66_4) do
		table.push(arg_66_0.vars.currency_list, iter_66_5)
	end
	
	if Account:isMapCleared("tae010") then
		table.push(arg_66_0.vars.currency_list, "gacha_substory")
	end
	
	local var_66_6 = os.time()
	
	if var_66_3.gacha_special and var_66_3.gacha_special.current and var_66_6 >= to_n(var_66_3.gacha_special.current.start_time) then
		arg_66_0.vars.gacha_special = true
	else
		arg_66_0.vars.gacha_special = false
	end
	
	BackButtonManager:push({
		check_id = "TopBarNew.GachaUnit",
		back_func = function()
			SceneManager:nextScene("lobby")
		end
	})
	SoundEngine:play("event:/ui/main_hud/btn_gacha")
	
	if arg_66_0:isTutorialMode() then
		arg_66_0.vars.temp_gacha_mode = "gacha_rare"
	elseif arg_66_2 and arg_66_2.gacha_mode then
		arg_66_0.vars.temp_gacha_mode = arg_66_2.gacha_mode
	end
	
	arg_66_0:seqIntro()
	TutorialGuide:procGuide()
	
	if not Shop.ready and Stove:checkStandbyAndBalloonMessage() then
		query("market", {
			caller = "package_gacha"
		})
	end
	
	if GachaUnit:checkTimeWarning() then
		Account:saveOpenGachaDay()
	end
end

function GachaUnit.front(arg_70_0)
	arg_70_0:cleanUpResult()
	
	if get_cocos_refid(arg_70_0.vars.gacha_layer) then
		arg_70_0.vars.gacha_layer:removeFromParent()
	end
	
	arg_70_0.vars.gacha_layer = cc.Layer:create()
	
	arg_70_0.vars.layer:addChild(arg_70_0.vars.gacha_layer)
	
	arg_70_0.vars.warning_token_change = nil
	arg_70_0.vars.last_use_token = nil
	
	BackButtonManager:clear()
	BackButtonManager:push({
		check_id = "TopBarNew.GachaUnit",
		back_func = function()
			SceneManager:nextScene("lobby")
		end
	})
	arg_70_0:seqIntro()
end

function GachaUnit.touched(arg_72_0)
	if not arg_72_0.vars or not arg_72_0.vars.mode then
		return 
	end
	
	if arg_72_0.vars.mode == "summoning" or arg_72_0.vars.mode == "summon_result" or arg_72_0.vars.mode == "intro" or arg_72_0.vars.mode == "seq1" then
		GachaUnit:skip()
	end
end

function GachaUnit.onTouchDown(arg_73_0, arg_73_1, arg_73_2)
	GachaUnit:touched()
end

function GachaUnit.openReview(arg_74_0)
	if arg_74_0.vars.code then
		Review:open({
			code = arg_74_0.vars.code,
			layer = arg_74_0.vars.layer,
			callback = function(arg_75_0)
				arg_74_0.vars.gacha_layer:setVisible(not arg_75_0)
			end
		})
	end
end

function GachaUnit.getGachaMode(arg_76_0)
	if not arg_76_0.vars then
		return 
	end
	
	return arg_76_0.vars.gacha_mode
end

function GachaUnit.getNextGacha(arg_77_0)
	if arg_77_0.vars.skip_on == true then
		local var_77_0 = 0
		
		while true do
			local var_77_1 = arg_77_0:setupGachaObject()
			
			if var_77_1 == nil then
				return nil
			end
			
			if not PRODUCTION_MODE then
				print("GachaUnit.getNextGacha", "#" .. (arg_77_0.vars.current_index or "NIL") .. " / " .. (arg_77_0.vars.code or "NIL") .. " ^" .. (arg_77_0.vars.current_grade or "NIL"), var_77_1, arg_77_0:isSkipableGrade(true), arg_77_0:is_new(), arg_77_0.vars.skip_on, arg_77_0.vars.mode)
			end
			
			if arg_77_0:isSkipableGrade(true) == false or arg_77_0:is_new() then
				print("SKIP SKIP GET", arg_77_0.vars.code)
				
				return var_77_1
			end
		end
	else
		return arg_77_0:setupGachaObject()
	end
	
	return nil
end

function GachaUnit.getSceneState(arg_78_0)
	if not arg_78_0.vars then
		return 
	end
	
	if arg_78_0.vars.current_info then
		local var_78_0 = arg_78_0.vars.current_info.mode
		local var_78_1 = arg_78_0.vars.current_info.data
		
		if var_78_0 then
			return {
				gacha_mode = var_78_0
			}
		else
			print("Please Check getSceneState method.")
			
			return nil
		end
	else
		return nil
	end
end

function GachaUnit.setGachaRateInfo(arg_79_0, arg_79_1)
	arg_79_0.gacha_rate = {}
	arg_79_0.gacha_rate[arg_79_1.item] = {}
	arg_79_0.gacha_rate[arg_79_1.item].view_list = arg_79_1.view_list
	arg_79_0.gacha_rate[arg_79_1.item].view_list_sum = arg_79_1.view_list_sum
	
	if (string.starts(arg_79_1.item, "gacha_start") or string.starts(arg_79_1.item, "gacha_story") or string.starts(arg_79_1.item, "gacha_spdash")) and get_cocos_refid(arg_79_0.wnd_gacha_rate_info) then
		local var_79_0 = arg_79_0.gacha_rate[arg_79_1.item].view_list_sum
		
		arg_79_0:setGachaRateItems(arg_79_1.item, var_79_0)
	else
		arg_79_0:gachaRate(arg_79_1.item, nil, true)
	end
end

function GachaUnit.moveCollection(arg_80_0)
	Dialog:msgBox(T("collection_move"), {
		yesno = true,
		handler = function()
			if not Account:checkQueryEmptyDungeonData("collection") then
				SceneManager:nextScene("collection")
			end
		end,
		title = T("collection")
	})
end

function GachaUnit.parseGachaId(arg_82_0, arg_82_1)
	local var_82_0 = string.split(arg_82_1, ":")
	local var_82_1 = {}
	
	if var_82_0[2] then
		local var_82_2 = Account:getGachaShopInfo().pickup[var_82_0[2]]
		
		if var_82_2 then
			arg_82_1 = var_82_2.gacha_id
			var_82_1 = {
				var_82_2.gacha_id
			}
		elseif var_82_0[1] == "gacha_select" then
			arg_82_1 = var_82_0[2]
			var_82_1 = {
				var_82_0[2]
			}
		elseif var_82_0[1] == "gacha_story" or var_82_0[1] == "gacha_spdash" then
			arg_82_1 = var_82_0[2]
			var_82_1 = {
				var_82_0[2]
			}
		else
			balloon_message_with_sound("gacha_err")
		end
	elseif arg_82_1 == "gacha_normal" then
		var_82_1 = {
			"gacha_normal"
		}
	elseif arg_82_1 == "gacha_moonlight" then
		var_82_1 = {
			"gacha_moonlight"
		}
	elseif arg_82_1 == "gacha_rare" then
		var_82_1 = {
			"gacha_rare_1",
			"gacha_rare_10"
		}
	elseif arg_82_1 == "gacha_special" then
		var_82_1 = {
			"gacha_special"
		}
	elseif arg_82_1 == "gacha_element" then
		local var_82_3 = "gacha_tk_" .. arg_82_0.vars.ei_colors[arg_82_0.vars.element_mode] .. "35"
		local var_82_4 = "gacha_tk_" .. arg_82_0.vars.ei_colors[arg_82_0.vars.element_mode] .. "45"
		
		var_82_1 = {
			var_82_3,
			var_82_4
		}
	elseif arg_82_1 == "gacha_start" then
		var_82_1 = {
			"gacha_start"
		}
	elseif arg_82_1 == "gacha_customgroup" then
		var_82_1 = {
			"gacha_customgroup"
		}
	elseif arg_82_1 == "gacha_customspecial" then
		var_82_1 = {
			"gacha_customspecial"
		}
	elseif arg_82_1 == "gacha_substory" then
		var_82_1 = {
			"gacha_substory"
		}
	end
	
	return arg_82_1, var_82_1
end

function GachaUnit.checkGachaCustomGroupSelectCompleted(arg_83_0, arg_83_1)
	arg_83_1 = arg_83_1 or {}
	
	local var_83_0 = Account:getGachaShopInfo()
	
	if not var_83_0 or not var_83_0.gacha_customgroup then
		return false
	end
	
	local var_83_1 = var_83_0.gacha_customgroup
	
	if var_83_1 and var_83_1.select_list and #var_83_1.select_list >= 3 then
		if arg_83_1.check_summon_count and to_n(var_83_1.summon_count) < 1 then
			balloon_message_with_sound(arg_83_1.err_text or "gacha_customgroup_unlock_msg")
			
			return false
		end
		
		return true
	end
	
	if not arg_83_1.no_msg then
		balloon_message_with_sound(arg_83_1.err_text or "gacha_customgroup_unlock_msg")
	end
	
	return false
end

function GachaUnit.gachaNext(arg_84_0)
	BackButtonManager:pop("gacha")
	arg_84_0:cleanUpResult()
	arg_84_0:seqIntro(true, true)
	
	if arg_84_0.vars.ui_wnd_top and get_cocos_refid(arg_84_0.vars.ui_wnd_top) then
		UIAction:Add(SEQ(FADE_OUT(200), REMOVE()), arg_84_0.vars.ui_wnd_top, "block")
	end
	
	UIAction:Add(SEQ(FADE_OUT(200), REMOVE()), arg_84_0.vars.ui_wnd, "block")
	
	local var_84_0 = arg_84_0:getNextGacha()
	
	if not var_84_0 or var_84_0 == 0 then
		GachaUnit:summaryUI()
	else
		arg_84_0:seqNext()
	end
end

function GachaUnit.createGachaEffect(arg_85_0)
	arg_85_0.vars.gacha_effect = GachaEffect:CreateSeq(arg_85_0.vars.gacha_layer, {
		onIntro = function()
			arg_85_0:setMode("intro")
		end,
		onSeq1 = function()
			arg_85_0:setMode("seq1")
		end,
		onSeq2 = function()
			GachaUnit:onShowNextSummonResult()
		end,
		onGetFakeIntro = function()
			return {
				show_grade = arg_85_0.vars.begin_show_grade,
				show_moonlight = arg_85_0.vars.begin_show_moonlight
			}
		end,
		onGetFakeEffect = function()
			local var_90_0 = arg_85_0.vars.current_index
			
			if var_90_0 > table.count(arg_85_0.vars.fake_list) then
				var_90_0 = table.count(arg_85_0.vars.fake_list)
			end
			
			return arg_85_0.vars.fake_list[var_90_0]
		end,
		onGetIsNew = function()
			return arg_85_0:is_new()
		end
	})
	
	arg_85_0.vars.gacha_effect:setSkipButtonVisibleRequire(arg_85_0:isMultiResults())
end

function GachaUnit.seqNext(arg_92_0)
	BackButtonManager:pop("GachaUnit")
	BackButtonManager:push({
		check_id = "GachaUnit",
		back_func = function()
			GachaUnit:touched()
		end
	})
	
	if arg_92_0.vars.gacha_effect then
		arg_92_0.vars.gacha_effect:removeAll()
		
		arg_92_0.vars.gacha_effect = nil
	end
	
	arg_92_0:createGachaEffect()
	arg_92_0.vars.gacha_effect:begin(arg_92_0.vars.code, "seq1")
end

function GachaUnit.seqIntro(arg_94_0, arg_94_1, arg_94_2)
	arg_94_0.vars.gacha_layer:removeAllChildren()
	
	if arg_94_0.vars.callback_func then
		local var_94_0 = ccui.Button:create()
		
		var_94_0:setTouchEnabled(true)
		var_94_0:ignoreContentAdaptWithSize(false)
		var_94_0:setContentSize(VIEW_WIDTH, VIEW_HEIGHT)
		var_94_0:setPosition(VIEW_WIDTH / 2, VIEW_HEIGHT / 2)
		var_94_0:setAnchorPoint(0.5, 0.5)
		var_94_0:setName("btn_ignore")
		arg_94_0.vars.gacha_layer:addChild(var_94_0)
	end
	
	if not arg_94_2 then
		arg_94_0.vars.intro.m_bg = CACHE:getEffect("ui_gacha_bg.cfx")
		
		arg_94_0.vars.intro.m_bg:setPosition(DESIGN_WIDTH / 2 - 250, DESIGN_HEIGHT / 2)
		arg_94_0.vars.intro.m_bg:setScale(VIEW_WIDTH_RATIO)
		arg_94_0.vars.intro.m_bg:getPrimitiveNode("gacha_bg/summon_circle"):setInheritRotation(true)
		arg_94_0.vars.intro.m_bg:start()
		arg_94_0.vars.intro.m_bg:setVisible(false)
		arg_94_0.vars.gacha_layer:addChild(arg_94_0.vars.intro.m_bg, 10)
	end
	
	if not arg_94_1 then
		local var_94_1 = arg_94_0.vars.intro.m_bg:getPrimitiveNode("gacha_airbooks/root")
		
		arg_94_0.vars.intro.m_biblika_node = ur.Model:create("spani/biblika_node.scsp", "spani/biblika_node.atlas", 1)
		
		arg_94_0.vars.intro.m_biblika_node:setPosition(205, -320)
		arg_94_0.vars.intro.m_biblika_node:setScale(0.97)
		arg_94_0.vars.intro.m_biblika_node:setVisible(true)
		Action:Add(SEQ(DMOTION("intro", false), MOTION("loop", true)), arg_94_0.vars.intro.m_biblika_node)
		var_94_1:attach(arg_94_0.vars.intro.m_biblika_node)
		
		local var_94_2 = arg_94_0.vars.intro.m_biblika_node:getBoneNode("node")
		
		var_94_2:setInheritScale(true)
		var_94_2:setInheritRotation(true)
		
		arg_94_0.vars.intro.m_biblika = ur.Model:create("portrait/npc1026.scsp", "portrait/npc1026.atlas", 1)
		
		arg_94_0.vars.intro.m_biblika:setPosition(0, 0)
		arg_94_0.vars.intro.m_biblika:setScale(2.5)
		arg_94_0.vars.intro.m_biblika:setAnimation(0, "idle", true)
		arg_94_0.vars.intro.m_biblika:update(math.random())
		var_94_2:attach(arg_94_0.vars.intro.m_biblika)
		
		arg_94_0.vars.intro.m_biblio_node = ur.Model:create("spani/biblio_node.scsp", "spani/biblio_node.atlas", 1)
		
		arg_94_0.vars.intro.m_biblio_node:setPosition(205, -320)
		arg_94_0.vars.intro.m_biblio_node:setScale(0.97)
		arg_94_0.vars.intro.m_biblio_node:setVisible(true)
		Action:Add(SEQ(DMOTION("intro", false), MOTION("loop", true)), arg_94_0.vars.intro.m_biblio_node)
		var_94_1:attach(arg_94_0.vars.intro.m_biblio_node)
		
		local var_94_3 = arg_94_0.vars.intro.m_biblio_node:getBoneNode("node")
		
		var_94_3:setInheritScale(true)
		var_94_3:setInheritRotation(true)
		
		arg_94_0.vars.intro.m_biblio = ur.Model:create("portrait/npc1027.scsp", "portrait/npc1027.atlas", 1)
		
		arg_94_0.vars.intro.m_biblio:setPosition(0, 80)
		arg_94_0.vars.intro.m_biblio:setScale(2.5)
		arg_94_0.vars.intro.m_biblio:setAnimation(0, "idle", true)
		arg_94_0.vars.intro.m_biblio:update(math.random())
		var_94_3:attach(arg_94_0.vars.intro.m_biblio)
		arg_94_0.vars.intro.m_biblika_node:setVisible(false)
		arg_94_0.vars.intro.m_biblio_node:setVisible(false)
		arg_94_0:showUI()
	end
end

function GachaUnit.reqBuy(arg_95_0, arg_95_1, arg_95_2, arg_95_3)
	Dialog:closeAll()
	query("buy", {
		caller = "gacha_ticket",
		item = arg_95_1.id,
		shop = arg_95_3,
		type = arg_95_1.type,
		multiply = arg_95_2 or 1
	})
end

function GachaUnit.buyTickets(arg_96_0, arg_96_1)
	local var_96_0 = Account:getGachaShopInfo().gacha[arg_96_1]
	
	if not var_96_0 then
		return 
	end
	
	local var_96_1 = Account:isCurrencyType(var_96_0.token)
	
	if not var_96_1 then
		return 
	end
	
	if var_96_1 == "ticketspecial" and ShopPromotion:popupGachaPromotionPackages(var_96_1) then
		return 
	end
	
	if var_96_1 ~= "ticketrare" and var_96_1 ~= "ticketnormal" then
		UIUtil:checkCurrencyDialog(var_96_1)
		
		return 
	end
	
	local var_96_2 = load_dlg("gacha_popup_buy", true, "wnd")
	
	if var_96_1 == "ticketrare" then
		var_96_2:getChildByName("n_popup1"):setVisible(false)
		
		local var_96_3 = var_96_2:getChildByName("n_popup2")
		
		var_96_3:setVisible(true)
		
		local var_96_4 = table.clone(Account:getGachaShopInfo().buy_ticket.gacha_rare_1)
		
		var_96_4.bulk_purchase = "y"
		var_96_4.parent_self = arg_96_0
		
		local var_96_5 = ShopCommon:makeShopItem(var_96_4, "wnd/shop_card.csb")
		
		if_set_visible(var_96_5, "n_time", false)
		var_96_3:getChildByName("n_card1"):addChild(var_96_5)
		
		local var_96_6 = table.clone(Account:getGachaShopInfo().buy_ticket.gacha_rare_10)
		
		var_96_6.bulk_purchase = "y"
		var_96_6.parent_self = arg_96_0
		
		local var_96_7 = ShopCommon:makeShopItem(var_96_6, "wnd/shop_card.csb")
		
		if_set_visible(var_96_7, "n_time", false)
		var_96_3:getChildByName("n_card2"):addChild(var_96_7)
	else
		local var_96_8 = var_96_2:getChildByName("n_popup1")
		
		var_96_8:setVisible(true)
		var_96_2:getChildByName("n_popup2"):setVisible(false)
		
		local var_96_9 = table.clone(Account:getGachaShopInfo().buy_ticket.gacha_normal)
		
		var_96_9.bulk_purchase = "y"
		var_96_9.parent_self = arg_96_0
		
		local var_96_10 = ShopCommon:makeShopItem(var_96_9, "wnd/shop_card.csb")
		
		if_set_visible(var_96_10, "n_time", false)
		var_96_8:getChildByName("n_card"):addChild(var_96_10)
	end
	
	Dialog:msgBox(nil, {
		dlg = var_96_2,
		handler = function(arg_97_0, arg_97_1, arg_97_2)
			if arg_97_1 == "btn_close" then
			elseif arg_97_1 == "btn_block" then
				return "dont_close"
			end
		end
	})
end

function GachaUnit.isOpenConfirmBuyUI(arg_98_0)
	local var_98_0 = SceneManager:getRunningPopupScene():getChildByName("msgbox")
	
	if var_98_0 and get_cocos_refid(var_98_0) then
		return true
	end
	
	return false
end

function GachaUnit.confirmBuy(arg_99_0, arg_99_1, arg_99_2, arg_99_3)
	if arg_99_0:isOpenConfirmBuyUI() then
		return 
	end
	
	local var_99_0
	local var_99_1, var_99_2 = arg_99_0:parseGachaId(arg_99_0.vars.gacha_mode)
	
	if arg_99_2 then
		var_99_0 = arg_99_0.vars.last_buy_item
		arg_99_3 = arg_99_0.vars.last_gacha_count or 1
	else
		var_99_0 = var_99_2[math.min(arg_99_1, #var_99_2)]
		arg_99_3 = arg_99_3 or 1
	end
	
	local var_99_3 = arg_99_2 and SAVE:getOptionData("option.popupskip", false)
	
	if var_99_0 == "gacha_start" or string.starts(var_99_1, "gacha_story") or var_99_1 == "gacha_spdash" or var_99_1 == "gacha_moonlight" and arg_99_0:isMoonlightBonus() then
		var_99_3 = true
	elseif var_99_1 ~= "gacha_normal" and arg_99_3 > 1 then
		var_99_3 = false
	end
	
	if not var_99_0 then
		balloon_message_with_sound("gacha_err")
		
		return 
	end
	
	if var_99_1 == "gacha_customgroup" and arg_99_0:checkGachaCustomGroupSelectCompleted() ~= true then
		return 
	elseif var_99_1 == "gacha_customspecial" and arg_99_0:checkGachaCustomSpecialSelectCompleted() ~= true then
		return 
	end
	
	local var_99_4 = {
		u = Account:getRemainHeroInventoryCount(),
		e = Account:getCurrentArtifactCount() - Account:getFreeArtifactCount()
	}
	
	if var_99_1 == "gacha_normal" then
		if UIUtil:checkUnitInven() == false then
			return 
		end
		
		if UIUtil:checkArtifactInven() == false then
			return 
		end
	end
	
	local var_99_5 = Account:getGachaShopInfo()
	
	local function var_99_6(arg_100_0, arg_100_1, arg_100_2)
		local var_100_0 = Account:isCurrencyType(arg_100_0.token)
		local var_100_1 = Account:getCurrency(var_100_0)
		local var_100_2, var_100_3 = DB("item_token", arg_100_0.token, {
			"name",
			"type"
		})
		local var_100_4 = arg_100_0.price * (arg_100_1 or 1)
		
		if arg_99_0:isMoonlightBonus() then
			var_100_4 = 0
		end
		
		if var_100_1 < var_100_4 then
			arg_99_0:buyTickets(arg_100_0.id)
		elseif var_99_3 then
			GachaUnit:buy_more(arg_100_0.id, var_99_4, arg_100_1, arg_100_0.token)
		else
			local var_100_5 = arg_99_0:getCeilingData(arg_100_0.id)
			local var_100_6 = false
			
			if var_100_5 and var_100_5.ceiling_count and to_n(var_100_5.ceiling_count) > 0 then
				var_100_6 = to_n(var_100_5.ceiling_count) - to_n(var_100_5.ceiling_current) <= 9
			end
			
			local var_100_7 = T("shop_chk_curr_title_" .. var_100_0)
			local var_100_8 = T("shop_gacha_" .. var_100_0 .. ".desc")
			
			if arg_100_1 == 10 then
				var_100_7 = T("shop_chk_curr_title_gachaticket_10")
				
				if var_100_6 then
					var_100_8 = T("shop_gacha_" .. var_100_0 .. "_10_com.desc")
				else
					var_100_8 = T("shop_gacha_" .. var_100_0 .. "_10.desc")
				end
			end
			
			if arg_99_0.vars.warning_token_change then
				local var_100_9 = DB("item_token", arg_99_0.vars.warning_token_change, {
					"name"
				})
				
				if arg_100_1 == 10 then
					var_100_7 = T("shop_chk_curr_title_gachaticket_10")
					
					if var_100_6 then
						var_100_8 = T("summon_notenough_eventitem_10_com.desc", {
							event_item_name = T(var_100_9),
							item_name = T(var_100_2)
						})
					else
						var_100_8 = T("summon_notenough_eventitem_10.desc", {
							event_item_name = T(var_100_9),
							item_name = T(var_100_2)
						})
					end
				else
					var_100_8 = T("summon_notenough_eventitem.desc", {
						event_item_name = T(var_100_9),
						item_name = T(var_100_2)
					})
				end
			end
			
			if var_99_1 == "gacha_customgroup" then
				local var_100_10 = Account:getGachaShopInfo().gacha_customgroup
				
				if var_100_10 and to_n(var_100_10.summon_count) < 1 then
					var_100_8 = var_100_8 .. "\n\n" .. T("gacha_customgroup_unchangeable")
				end
			end
			
			if var_99_1 == "gacha_customspecial" then
				local var_100_11 = load_dlg("gacha_1special_custom_p", true, "wnd")
				local var_100_12 = var_100_11:getChildByName("disc")
				
				if tolua:type(var_100_12) ~= "ccui.RichText" then
					upgradeLabelToRichLabel(var_100_11, "disc")
				end
				
				if_set(var_100_11, "disc", var_100_8)
				
				local var_100_13, var_100_14 = DB("character", var_100_5.ceiling_character, {
					"name",
					"grade"
				})
				
				if_set(var_100_11, "t_name", T(var_100_13))
				
				local var_100_15 = var_100_11:getChildByName("n_probability_info")
				local var_100_16 = var_100_11:getChildByName("n_token_info")
				
				if_set(var_100_15, "t_probability_up", T("ui_ct_gacha_select_info"))
				
				local var_100_17 = arg_99_0:getGachaCustomSpecialSelectList()
				
				if not var_100_17 then
					return 
				end
				
				UIUtil:getRewardIcon("c", var_100_17[1], {
					no_popup = true,
					name = false,
					show_color_with_role = true,
					no_tooltip = true,
					parent = var_100_15:getChildByName("n_hero_01"),
					grade = var_100_14
				})
				UIUtil:getRewardIcon("c", var_100_17[2], {
					no_popup = true,
					name = false,
					show_color_with_role = true,
					no_tooltip = true,
					parent = var_100_15:getChildByName("n_hero_02"),
					grade = var_100_14
				})
				UIUtil:getRewardIcon(var_100_4, arg_100_0.token, {
					no_resize_name = true,
					show_name = true,
					show_small_count = true,
					detail = true,
					parent = var_100_16:getChildByName("n_token"),
					txt_name = var_100_16:getChildByName("t_name_2"),
					txt_type = var_100_16:getChildByName("txt_type")
				})
				if_set(var_100_11, "t_have", T("shop_current_currency", {
					token_name = T(var_100_2),
					token_count = var_100_1
				}))
				Dialog:msgBox("", {
					yesno = true,
					dlg = var_100_11,
					handler = function(arg_101_0, arg_101_1, arg_101_2)
						if arg_101_1 == "btn_close" then
							return "dont_close"
						end
						
						if arg_99_2 then
							GachaUnit:buy_more(arg_100_0.id, var_99_4, arg_100_1, arg_100_0.token)
						else
							GachaUnit:buy(arg_100_0.id, var_99_4, arg_100_1, arg_100_0.token)
						end
					end
				})
				if_set_visible(var_100_11, "n_title", true)
				if_set(var_100_11, "t_title", var_100_7)
			elseif var_99_1 == "gacha_special" then
				local var_100_18 = load_dlg("gacha_special_summon_p", true, "wnd")
				local var_100_19 = var_100_18:getChildByName("disc")
				
				if tolua:type(var_100_19) ~= "ccui.RichText" then
					upgradeLabelToRichLabel(var_100_18, "disc")
				end
				
				if_set(var_100_18, "disc", var_100_8)
				
				local var_100_20 = to_n(var_100_5.ceiling_count) - to_n(var_100_5.ceiling_current)
				
				if var_100_20 == 0 then
					if_set(var_100_18, "t_gacha_info", T("ui_popup_ceiling_character_count_full"))
				else
					if_set(var_100_18, "t_gacha_info", T("ui_popup_ceiling_character_count", {
						count = var_100_20
					}))
				end
				
				local var_100_21, var_100_22 = DB("character", var_100_5.ceiling_character, {
					"name",
					"grade"
				})
				
				if_set(var_100_18, "t_name", T(var_100_21))
				UIUtil:getRewardIcon("c", var_100_5.ceiling_character, {
					no_popup = true,
					name = false,
					show_color_with_role = true,
					no_tooltip = true,
					scale = 1.18,
					parent = var_100_18:getChildByName("n_icon_hero"),
					grade = var_100_22
				})
				UIUtil:getRewardIcon(var_100_4, arg_100_0.token, {
					no_resize_name = true,
					show_name = true,
					show_small_count = true,
					detail = true,
					parent = var_100_18:getChildByName("n_reward_item"),
					txt_name = var_100_18:getChildByName("t_name_2"),
					txt_type = var_100_18:getChildByName("txt_type")
				})
				if_set(var_100_18, "t_have", T("shop_current_currency", {
					token_name = T(var_100_2),
					token_count = var_100_1
				}))
				Dialog:msgBox("", {
					yesno = true,
					dlg = var_100_18,
					handler = function(arg_102_0, arg_102_1, arg_102_2)
						if arg_102_1 == "btn_detail" then
							GachaUnit:gachaGroupPickupHelp(nil, true)
							
							return "dont_close"
						end
						
						if arg_102_1 == "btn_close" then
							return "dont_close"
						end
						
						if arg_99_2 then
							GachaUnit:buy_more(arg_100_0.id, var_99_4, arg_100_1, arg_100_0.token)
						else
							GachaUnit:buy(arg_100_0.id, var_99_4, arg_100_1, arg_100_0.token)
						end
					end
				})
				if_set_visible(var_100_18, "n_title", true)
				if_set(var_100_18, "t_title", var_100_7)
			else
				local var_100_23 = load_dlg("shop_nocurrency", true, "wnd")
				
				if_set(var_100_23, "txt_shop_comment", T("shop_current_currency", {
					token_name = T(var_100_2),
					token_count = var_100_1
				}))
				UIUtil:getRewardIcon(var_100_4, arg_100_0.token, {
					show_small_count = true,
					show_name = true,
					detail = true,
					parent = var_100_23:getChildByName("n_item_pos")
				})
				
				local var_100_24 = ""
				
				if var_99_1 == "gacha_customgroup" then
					if_set_visible(var_100_23, "n_caution", true)
					
					var_100_24 = "customgroup"
				end
				
				Dialog:msgBox(var_100_8, {
					yesno = true,
					dlg = var_100_23,
					handler = function(arg_103_0, arg_103_1, arg_103_2)
						if arg_103_1 == "btn_detail" then
							GachaUnit:gachaGroupPickupHelp(var_100_24, true)
							
							return "dont_close"
						end
						
						if arg_99_2 then
							GachaUnit:buy_more(arg_100_0.id, var_99_4, arg_100_1, arg_100_0.token)
						else
							GachaUnit:buy(arg_100_0.id, var_99_4, arg_100_1, arg_100_0.token)
						end
						
						TutorialGuide:procGuide("system_011")
					end,
					title = var_100_7
				})
			end
		end
	end
	
	local var_99_7 = var_99_5.gacha[var_99_0]
	local var_99_8 = arg_99_0:getEventToken()
	
	if var_99_8 then
		if Account:getCurrency(var_99_8.token) >= to_n(var_99_8.price) * arg_99_3 then
			var_99_7 = var_99_8
		elseif arg_99_0.vars.last_use_token and arg_99_0.vars.last_use_token ~= var_99_7.token then
			arg_99_0.vars.warning_token_change = var_99_8.token
			var_99_3 = false
		end
	end
	
	local var_99_9, var_99_10 = DB("item_token", var_99_7.token, {
		"name",
		"type"
	})
	
	if var_99_1 == "gacha_normal" then
		local var_99_11 = Account:getCurrency("ticketnormal")
		local var_99_12 = var_99_7.price
		local var_99_13 = 1
		
		for iter_99_0 = 1, 10 do
			if var_99_11 < var_99_7.price * iter_99_0 then
				break
			end
			
			var_99_12 = var_99_7.price * iter_99_0
			
			local var_99_14 = iter_99_0
		end
		
		local var_99_15 = Account:isCurrencyType(var_99_7.token)
		local var_99_16 = Account:getCurrency(var_99_15)
		local var_99_17, var_99_18 = DB("item_token", var_99_7.token, {
			"name",
			"type"
		})
		
		if var_99_16 < var_99_12 then
			arg_99_0:buyTickets(var_99_7.id)
		elseif var_99_3 then
			GachaUnit:buy_more(var_99_7.id, var_99_4, arg_99_3, var_99_7.token)
		else
			local var_99_19 = load_dlg("shop_nocurrency", true, "wnd")
			
			if_set(var_99_19, "txt_shop_comment", T("shop_current_currency", {
				token_name = T(var_99_17),
				token_count = Account:getCurrency("ticketnormal")
			}))
			UIUtil:getRewardIcon(var_99_12, var_99_7.token, {
				show_small_count = true,
				show_name = true,
				detail = true,
				parent = var_99_19:getChildByName("n_item_pos")
			})
			Dialog:msgBox(T("shop_gacha_ticketnormal.desc"), {
				yesno = true,
				dlg = var_99_19,
				handler = function()
					if arg_99_2 then
						GachaUnit:buy_more(var_99_7.id, var_99_4, arg_99_3, var_99_7.token)
					else
						GachaUnit:buy(var_99_7.id, var_99_4, arg_99_3, var_99_7.token)
					end
				end,
				title = T("shop_chk_curr_title_ticketnormal")
			})
		end
	elseif var_99_1 == "gacha_rare" then
		local var_99_20 = var_99_5.free_ticket.gacha_rare_free_1
		local var_99_21, var_99_22 = arg_99_0:getFreeGachaEventCount()
		
		if var_99_0 == "gacha_rare_1" and var_99_20 and var_99_21 < var_99_22 and arg_99_3 == 1 then
			local var_99_23 = load_dlg("shop_nocurrency", true, "wnd")
			
			if_set_visible(var_99_23, "txt_shop_comment", false)
			UIUtil:getRewardIcon(0, var_99_20.token, {
				show_small_count = true,
				show_name = true,
				detail = true,
				parent = var_99_23:getChildByName("n_item_pos")
			})
			Dialog:msgBox(T("shop_gacha_ticketrare_free.desc"), {
				yesno = true,
				dlg = var_99_23,
				handler = function()
					if arg_99_2 then
						GachaUnit:buy_more(var_99_20.id, var_99_4, arg_99_3)
					else
						GachaUnit:buy(var_99_20.id, var_99_4, arg_99_3)
					end
					
					TutorialGuide:procGuide("system_011")
				end,
				title = T("shop_chk_curr_title_ticketrare_free")
			})
		elseif var_99_0 == "gacha_rare_1" and var_99_20 and var_99_22 >= var_99_21 + 10 and arg_99_3 == 10 then
			local var_99_24 = load_dlg("shop_nocurrency", true, "wnd")
			
			if_set_visible(var_99_24, "txt_shop_comment", false)
			UIUtil:getRewardIcon(0, var_99_20.token, {
				show_small_count = true,
				show_name = true,
				detail = true,
				parent = var_99_24:getChildByName("n_item_pos")
			})
			Dialog:msgBox(T("shop_gacha_ticketrare_free10.desc"), {
				yesno = true,
				dlg = var_99_24,
				handler = function()
					if arg_99_2 then
						GachaUnit:buy_more(var_99_20.id, var_99_4, arg_99_3)
					else
						GachaUnit:buy(var_99_20.id, var_99_4, arg_99_3)
					end
					
					TutorialGuide:procGuide("system_011")
				end,
				title = T("shop_chk_curr_title_ticketrare_free")
			})
		else
			var_99_6(var_99_7, arg_99_3)
		end
	elseif var_99_1 == "gacha_moonlight" then
		local var_99_25 = var_99_5.free_ticket.gacha_ml_free_1
		local var_99_26, var_99_27 = arg_99_0:getFreeGachaEventCount("gacha_ml_free_1", "gl:gachafree_daily_ml")
		
		if var_99_0 == "gacha_moonlight" and arg_99_0:isMoonlightBonus() ~= true and var_99_25 and var_99_26 < var_99_27 and arg_99_3 == 1 then
			local var_99_28 = load_dlg("shop_nocurrency", true, "wnd")
			
			if_set_visible(var_99_28, "txt_shop_comment", false)
			UIUtil:getRewardIcon(0, var_99_25.token, {
				show_small_count = true,
				show_name = true,
				detail = true,
				parent = var_99_28:getChildByName("n_item_pos")
			})
			Dialog:msgBox(T("shop_gacha_ticketmoon_free.desc"), {
				yesno = true,
				dlg = var_99_28,
				handler = function()
					if arg_99_2 then
						GachaUnit:buy_more(var_99_25.id, var_99_4, arg_99_3)
					else
						GachaUnit:buy(var_99_25.id, var_99_4, arg_99_3)
					end
					
					TutorialGuide:procGuide("system_011")
				end,
				title = T("shop_chk_curr_title_ticketmoon_free")
			})
		else
			var_99_6(var_99_7, 1)
		end
	elseif var_99_1 == "gacha_special" then
		UnlockSystem:isUnlockSystemAndMsg({
			exclude_story = true,
			id = UNLOCK_ID.GACHA_SPECIAL
		}, function()
			var_99_6(var_99_7, arg_99_3)
		end)
	elseif string.starts(arg_99_0.vars.gacha_mode, "gacha_pickup:") then
		local var_99_29 = string.split(arg_99_0.vars.gacha_mode, ":")[2]
		local var_99_30 = var_99_5.pickup[var_99_29]
		
		if var_99_30 then
			local var_99_31 = os.time()
			
			if var_99_30.start_time and var_99_31 < var_99_30.start_time or var_99_30.end_time and var_99_31 > var_99_30.end_time then
				balloon_message_with_sound("buy_gacha.invalid_time")
			else
				var_99_6(var_99_7, arg_99_3, var_99_30)
			end
		else
			balloon_message_with_sound("gacha_err")
		end
	elseif var_99_1 == "gacha_element" then
		var_99_6(var_99_7, 1)
	elseif var_99_1 == "gacha_start" then
		var_99_6(var_99_7, 1)
	elseif string.starts(var_99_1, "gacha_story") then
		var_99_6(var_99_7, 1)
	elseif var_99_1 == "gacha_spdash" then
		var_99_6(var_99_7, 1)
	elseif var_99_1 == "gacha_customgroup" then
		if arg_99_0:isEnabledGachaCustomGroup() == nil then
			balloon_message_with_sound("buy_gacha.invalid_time")
		elseif not arg_99_0:isUnlockCustomGroup() then
			Dialog:msgBox(T("gacha_customgroup_unlock_quest"))
		else
			var_99_6(var_99_7, arg_99_3)
		end
	elseif var_99_1 == "gacha_customspecial" then
		if arg_99_0:isEnabledGachaCustomSpecial() == nil then
			balloon_message_with_sound("buy_gacha.invalid_time")
		else
			var_99_6(var_99_7, arg_99_3)
		end
	elseif var_99_1 == "gacha_substory" then
		var_99_6(var_99_7, arg_99_3)
	else
		balloon_message_with_sound("gacha_err")
	end
	
	TutorialGuide:procGuide()
end

function GachaUnit.confirmDecideSelectGacha(arg_109_0)
	if not arg_109_0.vars.gacha_select_decide_index then
		return 
	end
	
	local var_109_0 = T("gacha_select_recorded_list_title")
	local var_109_1 = Account:getGachaShopInfo()
	local var_109_2 = string.split(arg_109_0.vars.gacha_mode, "gacha_select:")[2]
	local var_109_3 = var_109_1.select_list[var_109_2]
	
	if arg_109_0.vars.gacha_select_decide_index == var_109_3.current then
		var_109_0 = T("gacha_select_recorded_list_title2")
	end
	
	Dialog:msgBox(T("gacha_select_confirm_recorded_desc", {
		result = var_109_0
	}), {
		yesno = true,
		handler = function()
			query("decide_gacha_select", {
				select_id = var_109_2,
				decide_index = arg_109_0.vars.gacha_select_decide_index
			})
		end,
		title = T("gacha_select_confirm_popup_title")
	})
end

function GachaUnit.decideSelectGacha(arg_111_0)
	local var_111_0 = Account:getGachaShopInfo()
	
	arg_111_0.vars.gacha_select_decide_index = nil
	
	local var_111_1 = string.split(arg_111_0.vars.gacha_mode, "gacha_select:")[2]
	local var_111_2 = var_111_0.select_list[var_111_1]
	local var_111_3 = var_111_0.select_list["saved_" .. var_111_1]
	local var_111_4 = load_dlg("gacha_select_record", true, "wnd")
	local var_111_5 = var_111_4:getChildByName("window")
	
	if_set_visible(var_111_5, "icon_overwrite", false)
	if_set_visible(var_111_5, "bar", true)
	
	local var_111_6 = var_111_4:getChildByName("n_record_before")
	local var_111_7 = var_111_4:getChildByName("n_current")
	local var_111_8 = var_111_4:getChildByName("n_bttom")
	
	if_set_visible(var_111_8, "btn_cancel", true)
	if_set_visible(var_111_8, "btn_record", false)
	if_set_visible(var_111_8, "btn_confirm", true)
	if_set_opacity(var_111_8, "btn_confirm", 76.5)
	var_111_6:getChildByName("btn_select"):setName("btn_select_1")
	var_111_7:getChildByName("btn_select"):setName("btn_select_2")
	
	local var_111_9 = var_111_4:getChildByName("n_top")
	
	if_set(var_111_9, "title", T("gacha_select_confirm_popup_title"))
	if_set(var_111_9, "t_disc", T("gacha_select_confirm_popup_desc"))
	
	if to_n(var_111_3.current) == 0 then
		if_set_visible(var_111_6, "n_result_record", false)
		if_set_visible(var_111_6, "n_no_record", true)
		if_set_visible(var_111_6, "record_count", false)
		
		local var_111_10 = var_111_6:getChildByName("n_no_record")
		
		if_set_visible(var_111_10, "label", T("gacha_select_no_recorded_result"))
	else
		if_set_visible(var_111_6, "n_result_record", true)
		if_set_visible(var_111_6, "n_no_record", false)
		arg_111_0:updateSelectRecordIcons(var_111_6, var_111_3.previous, true)
		if_set(var_111_6, "record_count", T("gacha_select_recorded_list_order", {
			count = var_111_3.current
		}))
	end
	
	arg_111_0:updateSelectRecordIcons(var_111_7, var_111_2.previous, true)
	if_set(var_111_7, "current_count", T("gacha_select_recorded_list_order", {
		count = var_111_2.current
	}))
	Dialog:msgBox(nil, {
		yesno = true,
		dlg = var_111_4,
		handler = function(arg_112_0, arg_112_1, arg_112_2)
			if arg_112_1 == "btn_close" then
			elseif arg_112_1 == "btn_select" then
				return "dont_close"
			elseif arg_112_1 == "btn_block" then
				return "dont_close"
			elseif arg_112_1 == "btn_select_1" then
				if to_n(var_111_3.current) > 0 then
					if_set_visible(var_111_6, "img_selected", true)
					if_set_visible(var_111_7, "img_selected", false)
					if_set_opacity(var_111_8, "btn_confirm", 255)
					
					arg_111_0.vars.gacha_select_decide_index = to_n(var_111_3.current)
					
					var_111_6:setOpacity(255)
					var_111_7:setOpacity(76.5)
				end
				
				return "dont_close"
			elseif arg_112_1 == "btn_select_2" then
				if_set_visible(var_111_6, "img_selected", false)
				if_set_visible(var_111_7, "img_selected", true)
				if_set_opacity(var_111_8, "btn_confirm", 255)
				
				arg_111_0.vars.gacha_select_decide_index = to_n(var_111_2.current)
				
				var_111_6:setOpacity(76.5)
				var_111_7:setOpacity(255)
				
				return "dont_close"
			elseif arg_112_1 == "btn_confirm" then
				if not arg_111_0.vars.gacha_select_decide_index then
					balloon_message_with_sound("err_gacha_select_selection_needed")
					
					return "dont_close"
				end
				
				UIAction:Add(SEQ(DELAY(200), CALL(GachaUnit.confirmDecideSelectGacha, arg_111_0)), arg_111_0, "block")
			end
		end
	})
end

function GachaUnit.updateSelectRecordIcons(arg_113_0, arg_113_1, arg_113_2, arg_113_3)
	if not arg_113_1 or not arg_113_2 then
		return 
	end
	
	local var_113_0 = {}
	
	for iter_113_0, iter_113_1 in pairs(arg_113_2) do
		local var_113_1 = {
			code = iter_113_1.code,
			g = iter_113_1.g,
			s = to_n(iter_113_1.g) * 10
		}
		
		if string.starts(iter_113_1.code, "c") then
			var_113_1.s = var_113_1.s + 1
		end
		
		table.push(var_113_0, var_113_1)
	end
	
	table.sort(var_113_0, function(arg_114_0, arg_114_1)
		return tonumber(arg_114_0.s) > tonumber(arg_114_1.s)
	end)
	
	for iter_113_2, iter_113_3 in pairs(var_113_0) do
		local var_113_2 = arg_113_1:getChildByName("n_" .. iter_113_2)
		
		if var_113_2 then
			var_113_2:setVisible(true)
			arg_113_0:setSpecial(var_113_2, iter_113_3, {
				use_grade = true,
				no_skill_preview = true,
				no_preview = arg_113_3
			})
		end
	end
end

function GachaUnit.saveSelectGacha(arg_115_0)
	local var_115_0 = Account:getGachaShopInfo()
	local var_115_1 = string.split(arg_115_0.vars.gacha_mode, "gacha_select:")[2]
	local var_115_2 = var_115_0.select_list[var_115_1]
	local var_115_3 = var_115_0.select_list["saved_" .. var_115_1]
	
	if var_115_2.used == true then
		balloon_message_with_sound("gacha_select_over")
		
		return 
	end
	
	if var_115_2.current == var_115_3.current then
		balloon_message_with_sound("err_gacha_select_already_recorded")
		
		return 
	end
	
	if not (var_115_3 and to_n(var_115_3.current) > 0) then
		local var_115_4 = string.split(arg_115_0.vars.gacha_mode, "gacha_select:")[2]
		
		query("save_gacha_select", {
			select_id = var_115_4
		})
		
		return 
	end
	
	local var_115_5 = load_dlg("gacha_select_record", true, "wnd")
	local var_115_6 = var_115_5:getChildByName("window")
	
	if_set_visible(var_115_6, "icon_overwrite", true)
	if_set_visible(var_115_6, "bar", false)
	
	local var_115_7 = var_115_5:getChildByName("n_record_before")
	local var_115_8 = var_115_5:getChildByName("n_current")
	local var_115_9 = var_115_5:getChildByName("n_bttom")
	
	if_set_visible(var_115_9, "btn_cancel", true)
	if_set_visible(var_115_9, "btn_record", true)
	if_set_visible(var_115_9, "btn_confirm", false)
	if_set_visible(var_115_7, "img_selected", false)
	if_set_visible(var_115_8, "img_selected", false)
	
	local var_115_10 = var_115_5:getChildByName("n_top")
	
	if_set(var_115_10, "title", T("gacha_select_record_popup_title"))
	if_set(var_115_10, "t_disc", T("gacha_select_record_popup_desc"))
	if_set_visible(var_115_7, "n_result_record", true)
	if_set_visible(var_115_7, "n_no_record", false)
	arg_115_0:updateSelectRecordIcons(var_115_7, var_115_3.previous)
	if_set(var_115_7, "record_count", T("gacha_select_recorded_list_order", {
		count = var_115_3.current
	}))
	arg_115_0:updateSelectRecordIcons(var_115_8, var_115_2.previous)
	if_set(var_115_8, "current_count", T("gacha_select_recorded_list_order", {
		count = var_115_2.current
	}))
	Dialog:msgBox(nil, {
		yesno = true,
		dlg = var_115_5,
		handler = function(arg_116_0, arg_116_1, arg_116_2)
			if arg_116_1 == "btn_close" then
			elseif arg_116_1 == "btn_select" then
				return "dont_close"
			elseif arg_116_1 == "btn_block" then
				return "dont_close"
			elseif arg_116_1 == "btn_record" then
				UIAction:Add(SEQ(DELAY(200), CALL(GachaUnit.saveConfirmSelectGacha, arg_115_0)), arg_115_0, "block")
			end
		end
	})
end

function GachaUnit.saveConfirmSelectGacha(arg_117_0)
	local var_117_0 = string.split(arg_117_0.vars.gacha_mode, "gacha_select:")[2]
	local var_117_1 = Dialog:msgBox(T("gacha_select_overwrite_popup_desc"), {
		yesno = true,
		handler = function()
			query("save_gacha_select", {
				select_id = var_117_0
			})
		end,
		title = T("gacha_select_overwrite_popup_title")
	}):getChildByName("text")
	
	if get_cocos_refid(var_117_1) then
		var_117_1:setPositionY(var_117_1:getPositionY() - 20)
	end
end

function GachaUnit.pullSelectGacha(arg_119_0)
	local var_119_0 = Account:getGachaShopInfo()
	local var_119_1 = string.split(arg_119_0.vars.gacha_mode, "gacha_select:")[2]
	local var_119_2 = var_119_0.select_list[var_119_1]
	local var_119_3 = var_119_0.select_list["saved_" .. var_119_1]
	
	if var_119_2.used == true then
		balloon_message_with_sound("gacha_select_over")
		
		return 
	end
	
	if to_n(var_119_2.current) == 0 or to_n(var_119_3.current) == to_n(var_119_2.current) then
		query("pull_gacha_select", {
			select_id = var_119_1,
			pc = var_119_2.current
		})
	else
		Dialog:msgBox(T("gacha_select_again_popup_desc"), {
			yesno = true,
			handler = function()
				query("pull_gacha_select", {
					select_id = var_119_1,
					pc = var_119_2.current
				})
			end,
			title = T("gacha_select")
		})
	end
end

function GachaUnit.fullSkip(arg_121_0)
	if not arg_121_0.vars or not arg_121_0.vars.mode then
		return 
	end
	
	if arg_121_0.vars.mode == "summoning" or arg_121_0.vars.mode == "summon_result" or arg_121_0.vars.mode == "intro" or arg_121_0.vars.mode == "seq1" then
		arg_121_0.vars.current_index = #arg_121_0.vars.gacha_results + 1
		
		arg_121_0:summaryUI()
	end
end

function GachaUnit.loadDlgGachaAll(arg_122_0)
	local var_122_0 = load_dlg("gacha", true, "wnd")
	local var_122_1 = load_control("wnd/gacha_result_unit.csb")
	
	var_122_1:getChildByName("btn_close").is_gacha = true
	
	var_122_0:addChild(var_122_1)
	
	local var_122_2 = load_control("wnd/gacha_result_artifact.csb")
	
	var_122_0:addChild(var_122_2)
	
	return var_122_0
end

function GachaUnit.prepareEnterGachaVisibleOff(arg_123_0, arg_123_1, arg_123_2)
	if_set_visible(arg_123_0.vars.intro.m_biblika_node, nil, arg_123_2 or false)
	if_set_visible(arg_123_0.vars.intro.m_biblio_node, nil, arg_123_2 or false)
	if_set_visible(arg_123_0.vars.intro.m_bg, nil, arg_123_2 or false)
	if_set_visible(arg_123_1, "n_btn_gacha_inven", false)
	if_set_visible(arg_123_1, "n_btn_gacha_inven2", false)
	if_set_visible(arg_123_1, "n_pickup_ceiling_info", false)
	if_set_visible(arg_123_1, "n_pickup_group_info", false)
	if_set_visible(arg_123_1, "n_mileage_gp", false)
	if_set_visible(arg_123_1, "cm_free_tooltip", false)
	if_set_visible(arg_123_1, "cm_free_tooltip2", false)
	if_set_visible(arg_123_1, "btn_summon", false)
	if_set_visible(arg_123_1, "n_btn_summon_2", false)
	if_set_visible(arg_123_1, "n_btn_rate", false)
	if_set_visible(arg_123_1, "n_select", false)
	if_set_visible(arg_123_1, "n_special", false)
	if_set_visible(arg_123_1, "n_pickup", false)
	if_set_visible(arg_123_1, "n_btn_book", false)
	if_set_visible(arg_123_1, "btn_summon_up", false)
	if_set_visible(arg_123_1, "n_hero_tag", false)
	if_set_visible(arg_123_1, "icon_locked_summon_1", false)
	if_set_visible(arg_123_1, "icon_locked_summon_10", false)
end

function GachaUnit.packageStartBuy(arg_124_0)
	local var_124_0 = Account:getGachaShopInfo()
	local var_124_1
	
	if arg_124_0.vars.gacha_mode == "gacha_start" then
		var_124_1 = var_124_0.gacha_start
	else
		local var_124_2 = string.split(arg_124_0.vars.gacha_mode, ":")[2]
		
		var_124_1 = var_124_0.gacha_story[var_124_2]
	end
	
	if not var_124_1 then
		return 
	end
	
	local var_124_3 = os.time()
	local var_124_4 = Account:getTicketedLimit("gl:" .. var_124_1.gacha_id)
	
	if var_124_4 then
		if to_n(var_124_4.count) < to_n(var_124_4.max_c) then
			var_124_1.start_time = var_124_4.usable_tm
			var_124_1.end_time = var_124_4.buyable_tm
		else
			var_124_1.start_time = 0
			var_124_1.end_time = 0
		end
	end
	
	if var_124_4 or not AccountData.shop or not AccountData.shop.promotion or var_124_3 < to_n(var_124_1.start_time) or var_124_3 > to_n(var_124_1.end_time) then
		return 
	end
	
	local var_124_5
	
	for iter_124_0, iter_124_1 in pairs(AccountData.shop.promotion) do
		if iter_124_1.id == var_124_1.shop_id then
			var_124_5 = iter_124_1
			
			break
		end
	end
	
	if not var_124_5 then
		return 
	end
	
	ShopPromotion:reqBuy(var_124_5, "package_gacha")
end

function GachaUnit.onMsgPackageBuy(arg_125_0, arg_125_1)
	arg_125_0:showRightMenu(true, true)
	Lobby:checkMail(true)
	
	local var_125_0 = ShopPromotion:getPackageData(arg_125_1.item)
	
	if var_125_0.type == "gacha_start" then
		arg_125_0:enterGachaStart()
		ShopPromotion:popupResultGachaDashPackage(false, var_125_0)
	elseif string.starts(var_125_0.type, "gacha_story") or var_125_0.type == "gacha_spdash" then
		arg_125_0:enterGachaStory(var_125_0.type)
		ShopPromotion:popupResultGachaDashPackage(false, var_125_0)
	end
end

function GachaUnit.setDataUI(arg_126_0, arg_126_1, arg_126_2, arg_126_3)
	if not get_cocos_refid(arg_126_1) then
		return 
	end
	
	if not arg_126_2 then
		return 
	end
	
	if arg_126_3 then
		UIUtil:setPortraitPositionByFaceBone(arg_126_3)
		GachaIntroduceBG.Util:setPortraitInfoData(arg_126_3, arg_126_1, arg_126_2)
		
		return 
	end
	
	local var_126_0 = string.split(arg_126_2, ";")
	local var_126_1 = to_n(var_126_0[1])
	
	if var_126_1 == 0 then
		var_126_1 = 1
	end
	
	local var_126_2 = to_n(var_126_0[2])
	local var_126_3 = to_n(var_126_0[3])
	local var_126_4 = to_n(var_126_0[4])
	
	if var_126_4 == 0 then
		var_126_4 = 1
	end
	
	local var_126_5 = to_n(var_126_0[5])
	
	if arg_126_3 and var_126_0[6] then
		local var_126_6 = var_126_0[6]
		
		arg_126_3:setSkin(var_126_6)
	end
	
	arg_126_1:setPosition(var_126_2, var_126_3):setAnchorPoint(0, 0)
	arg_126_1:setScale(var_126_1)
	arg_126_1:setScaleX(var_126_1 * var_126_4)
	arg_126_1:setRotation(var_126_5)
end

function GachaUnit.getEventToken(arg_127_0, arg_127_1)
	arg_127_1 = arg_127_1 or arg_127_0.vars.gacha_mode
	
	if not arg_127_0.vars then
		return 
	end
	
	local var_127_0 = Account:getGachaShopInfo()
	
	if not var_127_0 then
		return nil
	end
	
	if string.starts(arg_127_1, "gacha_pickup:") then
		arg_127_1 = string.split(arg_127_1, ":")[2]
	end
	
	local var_127_1 = var_127_0.pickup[arg_127_1]
	
	if var_127_1 then
		if not var_127_1.event_shop_data or not var_127_1.event_shop_data.token == "to_ticketrare" then
			return nil
		end
		
		return var_127_1.event_shop_data
	else
		return nil
	end
end

function GachaUnit.setBiblioNodeVisible(arg_128_0, arg_128_1)
	if arg_128_0.vars and get_cocos_refid(arg_128_0.vars.intro.m_biblio_node) then
		arg_128_0.vars.intro.m_biblio_node:setVisible(arg_128_1)
	end
end

function GachaUnit.setBiblikaNodeVisible(arg_129_0, arg_129_1)
	if arg_129_0.vars and get_cocos_refid(arg_129_0.vars.intro.m_biblika_node) then
		arg_129_0.vars.intro.m_biblika_node:setVisible(arg_129_1)
	end
end

function GachaUnit.togglePickupArtifactInfo(arg_130_0)
	local var_130_0 = arg_130_0.vars.ui_wnd:getChildByName("n_before"):getChildByName("n_pickup"):getChildByName("n_arti_tooltip")
	local var_130_1 = var_130_0:getChildByName("n_tooltip_info")
	
	if_set_visible(var_130_0, "btn_arti_info", false)
	UIAction:Add(SEQ(SHOW(false), FADE_IN(300), DELAY(2500), FADE_OUT(300), CALL(if_set_visible, var_130_0, "btn_arti_info", true)), var_130_1, "n_arti_tooltip")
end

function GachaUnit.togglePickupInfo(arg_131_0)
	if not arg_131_0.vars.ui_wnd or not get_cocos_refid(arg_131_0.vars.ui_wnd) then
		return 
	end
	
	if arg_131_0.vars.gacha_mode == "gacha_customgroup" and arg_131_0:checkGachaCustomGroupSelectCompleted({
		err_text = "gacha_customgroup_unlock_info_msg"
	}) ~= true then
		return 
	end
	
	local var_131_0 = arg_131_0.vars.ui_wnd:getChildByName("n_before"):getChildByName("n_pickup_pos")
	local var_131_1 = var_131_0:getChildByName("n_pickup_infolist")
	
	if var_131_1 and get_cocos_refid(var_131_1) then
		local var_131_2 = var_131_1:isVisible()
		
		var_131_1:setVisible(not var_131_2)
		if_set_visible(var_131_0, "n_btn_pickup_info", var_131_2)
		if_set_visible(var_131_0, "n_btn_pickup_info_close", not var_131_2)
	end
end

function GachaUnit.requestMileageExchange(arg_132_0)
	local var_132_0 = Account:getGachaShopInfo()
	
	if (AccountData.gacha_mileage or 0) < var_132_0.mileage_unit then
		return 
	end
	
	query("exchange_gacha_mileage")
end

function GachaUnit.updateMileageGroup(arg_133_0, arg_133_1)
	if not arg_133_0.vars.ui_wnd or not get_cocos_refid(arg_133_0.vars.ui_wnd) then
		return 
	end
	
	local var_133_0 = arg_133_0.vars.ui_wnd:getChildByName("n_before"):getChildByName("n_pickup_group_info")
	
	if get_cocos_refid(var_133_0) then
		var_133_0:setVisible(true)
		
		local var_133_1 = DB("item_token", arg_133_1, {
			"name"
		})
		
		if_set(var_133_0, "txt_gpcoin", T(var_133_1))
		
		local var_133_2 = var_133_0:getChildByName("n_group_coin")
		
		UIUtil:getRewardIcon(nil, arg_133_1, {
			no_bg = true,
			scale = 1,
			parent = var_133_2
		})
		if_set(var_133_0, "txt_gpcoin_count", comma_value(to_n(Account:getCurrency(arg_133_1))))
	end
end

function GachaUnit.updateMileage(arg_134_0, arg_134_1)
	if not arg_134_0.vars.ui_wnd or not get_cocos_refid(arg_134_0.vars.ui_wnd) then
		return 
	end
	
	local var_134_0 = arg_134_0.vars.ui_wnd:getChildByName("n_before")
	local var_134_1 = var_134_0:getChildByName("n_mileage")
	
	if_set_visible(var_134_0, "n_mileage_gp", false)
	
	if arg_134_1 == nil or arg_134_1 == false then
		var_134_1:setVisible(false)
		
		return 
	else
		var_134_1:setVisible(true)
	end
	
	local var_134_2 = AccountData.gacha_mileage or 0
	local var_134_3 = Account:getGachaShopInfo()
	local var_134_4 = var_134_1:getChildByName("progress_bg")
	
	var_134_1:getChildByName("t_percent"):setLocalZOrder(2)
	if_set(var_134_1, "t_percent", var_134_2 .. "/" .. var_134_3.mileage_unit)
	
	local var_134_5 = var_134_2 / var_134_3.mileage_unit
	
	if var_134_5 > 1 then
		var_134_5 = 1
	end
	
	if_set_circle_percent(var_134_1, "progress_bar", var_134_5 * 100, "img/cm_hero_circool1.png")
	
	local var_134_6 = var_134_1:getChildByName("@progress")
	local var_134_7 = var_134_1:getChildByName("progress_bar")
	
	if var_134_5 >= 1 then
		var_134_7:setColor(cc.c3b(107, 193, 27))
	else
		var_134_7:setColor(cc.c3b(146, 109, 62))
	end
	
	local var_134_8 = math.floor(var_134_2 / var_134_3.mileage_unit)
	
	UIUtil:getRewardIcon(nil, "to_hero2", {
		no_popup = true,
		show_small_count = true,
		no_tooltip = true,
		no_bg = true,
		scale = 1,
		detail = true,
		parent = var_134_1:getChildByName("n_reward_item_icon")
	})
	
	local var_134_9 = var_134_1:getChildByName("n_reward_item_eff")
	
	var_134_9:removeAllChildren()
	
	if var_134_8 > 0 then
		local var_134_10 = EffectManager:Play({
			loop = true,
			scale = 4,
			fn = "ui_gacha_summon_mileage_eff.cfx",
			layer = var_134_9
		})
		
		var_134_9:setLocalZOrder(1)
	end
end

function GachaUnit.checkGachaSelect(arg_135_0, arg_135_1)
	local var_135_0 = GachaUnit:getGachaSelectCondition(arg_135_1)
	
	if var_135_0 and var_135_0.system_unlock then
		GachaUnit:enterGachaSelect(arg_135_1)
	end
end

function GachaUnit.updateRightMenu(arg_136_0, arg_136_1)
	if not arg_136_0.vars.ui_right_menu_wnd or not get_cocos_refid(arg_136_0.vars.ui_right_menu_wnd) then
		return 
	end
	
	local var_136_0 = arg_136_0.vars.ui_right_menu_wnd
	local var_136_1 = 0
	local var_136_2 = Account:getGachaShopInfo()
	local var_136_3 = arg_136_0.vars.ui_right_menu_wnd:getChildByName("scrollview")
	local var_136_4 = var_136_0:getChildByName("n_gacha_rare")
	
	if_set_visible(var_136_4, "icon_noti", arg_136_0:checkFreeGacha())
	
	local var_136_5 = var_136_0:getChildByName("n_gacha_moonlight")
	
	if get_cocos_refid(var_136_5) then
		local var_136_6 = var_136_5:getChildByName("icon_locked_select")
		
		if not UnlockSystem:isUnlockSystem(UNLOCK_ID.GACHA_MOONLIGHT) then
			var_136_5:setOpacity(76.5)
		end
		
		var_136_6:setVisible(not UnlockSystem:isUnlockSystem(UNLOCK_ID.GACHA_MOONLIGHT))
		if_set_visible(var_136_5, "icon_noti", arg_136_0:checkFreeMoonlightGacha())
	end
	
	local var_136_7
	
	if string.starts(arg_136_0.vars.gacha_mode, "gacha_pickup") then
		var_136_7 = string.split(arg_136_0.vars.gacha_mode, ":")[2]
	end
	
	for iter_136_0, iter_136_1 in ipairs(arg_136_0.vars.pickup_list) do
		local var_136_8 = var_136_3:getChildByName("n_banner:" .. iter_136_1.id)
		
		if get_cocos_refid(var_136_8) then
			if_set_visible(var_136_8, "select", iter_136_1.id == var_136_7)
			
			if iter_136_1.id == var_136_7 then
				var_136_1 = var_136_1 + 1
			end
		end
	end
	
	local var_136_9 = var_136_0:getChildByName("n_gacha_special")
	
	if get_cocos_refid(var_136_9) then
		local var_136_10 = var_136_9:getChildByName("icon_locked_select")
		
		if not UnlockSystem:isUnlockSystem(UNLOCK_ID.GACHA_SPECIAL) then
			var_136_9:setOpacity(76.5)
		end
		
		var_136_10:setVisible(not UnlockSystem:isUnlockSystem(UNLOCK_ID.GACHA_SPECIAL))
	end
	
	local var_136_11 = var_136_0:getChildByName("n_gacha_element")
	
	arg_136_0:updateGachaElementNoti()
	
	local var_136_12 = var_136_3:getChildByName("n_banner:gacha_start")
	
	if arg_136_0.vars.gacha_mode == "gacha_start" then
		if_set_visible(var_136_12, "select", true)
	else
		if_set_visible(var_136_12, "select", false)
	end
	
	local var_136_13 = var_136_3:getChildByName("n_banner:gacha_customgroup")
	
	if arg_136_0.vars.gacha_mode == "gacha_customgroup" then
		var_136_1 = var_136_1 + 1
		
		if_set_visible(var_136_13, "select", true)
	else
		if_set_visible(var_136_13, "select", false)
	end
	
	local var_136_14 = var_136_3:getChildByName("n_banner:gacha_customspecial")
	
	if arg_136_0.vars.gacha_mode == "gacha_customspecial" then
		if_set_visible(var_136_14, "select", true)
	else
		if_set_visible(var_136_14, "select", false)
	end
	
	local var_136_15 = var_136_3:getChildByName("n_banner:gacha_substory")
	
	if arg_136_0.vars.gacha_mode == "gacha_substory" then
		var_136_1 = var_136_1 + 1
		
		if_set_visible(var_136_15, "select", true)
	else
		if_set_visible(var_136_15, "select", false)
	end
	
	for iter_136_2, iter_136_3 in pairs(arg_136_0.vars.gacha_ui_list) do
		local var_136_16 = iter_136_3.id
		local var_136_17 = arg_136_0.vars.gacha_mode
		
		if string.starts(var_136_16, "gacha_select") then
			var_136_17 = string.split(var_136_17, ":")[2]
		end
		
		local var_136_18 = var_136_3:getChildByName("n_banner:" .. var_136_16)
		
		if get_cocos_refid(var_136_18) then
			if_set_visible(var_136_18, "select", iter_136_3.id == var_136_17)
		end
	end
	
	local var_136_19
	
	if string.starts(arg_136_0.vars.gacha_mode, "gacha_story") then
		var_136_19 = string.split(arg_136_0.vars.gacha_mode, ":")[2]
	end
	
	for iter_136_4, iter_136_5 in pairs(arg_136_0.vars.gacha_story_ui) do
		local var_136_20 = var_136_3:getChildByName("n_banner:" .. iter_136_5.id)
		
		if get_cocos_refid(var_136_20) then
			if_set_visible(var_136_20, "select", iter_136_5.id == var_136_19)
		end
	end
	
	for iter_136_6, iter_136_7 in pairs(arg_136_0.vars.gacha_ui_list) do
		local var_136_21 = var_136_0:getChildByName("n_" .. iter_136_7.id)
		
		if get_cocos_refid(var_136_21) then
			local var_136_22 = arg_136_0.vars.gacha_mode
			local var_136_23 = string.split(arg_136_0.vars.gacha_mode, "gacha_select:")[2]
			
			if var_136_23 then
				var_136_22 = var_136_23
			end
			
			if_set_visible(var_136_21, "cursor", iter_136_7.id == var_136_22)
			
			if iter_136_7.id == var_136_22 then
				arg_136_1 = true
			end
			
			if var_136_22 == "gacha_rare" and iter_136_7.id == var_136_22 then
				var_136_1 = var_136_1 + 1
			end
			
			local var_136_24 = GachaUnit:getGachaSelectCondition(iter_136_7.id)
			
			if var_136_24 and var_136_24.system_unlock and not UnlockSystem:isUnlockSystem(var_136_24.system_unlock) then
				if_set_opacity(var_136_21, "label", 76.5)
				if_set_opacity(var_136_21, "icon", 76.5)
				if_set_opacity(var_136_21, "icon_selective", 76.5)
				if_set_visible(var_136_21, "icon_locked_select", true)
			end
		end
	end
	
	arg_136_0:updateMileage(var_136_1 > 0)
	
	for iter_136_8, iter_136_9 in pairs(arg_136_0.vars.gacha_select_condition) do
		local var_136_25 = var_136_0:getChildByName("n_" .. iter_136_9.id)
		
		if get_cocos_refid(var_136_25) and iter_136_9.gacha_select_check and iter_136_9.system_unlock and UnlockSystem:isUnlockSystem(iter_136_9.system_unlock) then
			local var_136_26 = json.decode(Account:getConfigData("gs_unlock_reddot") or "{}")
			
			if_set_visible(var_136_25, "icon_noti", not var_136_26[iter_136_9.id])
			
			local var_136_27 = json.decode(Account:getConfigData("gs_unlock_noti") or "{}")
			
			if not var_136_27[iter_136_9.id] then
				var_136_27[iter_136_9.id] = 1
				
				SAVE:setTempConfigData("gs_unlock_noti", json.encode(var_136_27))
				
				local var_136_28 = load_dlg("unlock_system_open", true, "wnd")
				
				if_set(var_136_28, "txt_title", T(iter_136_9.gacha_select_info_title))
				if_set(var_136_28, "infor", T(iter_136_9.gacha_select_info_desc))
				if_set_sprite(var_136_28, "icon_storyguide", "img/" .. iter_136_9.gacha_select_info_icon .. ".png")
				Dialog:msgBox("", {
					dlg = var_136_28
				})
				
				break
			end
		end
	end
	
	arg_136_0:updatePickupRemainTime()
	
	if arg_136_1 then
		var_136_3:jumpToBottom()
	end
end

function GachaUnit.getPickUpActiveList(arg_137_0, arg_137_1)
	if not arg_137_1 then
		return 
	end
	
	local var_137_0 = {}
	local var_137_1 = os.time()
	
	if arg_137_1.pickup then
		for iter_137_0, iter_137_1 in pairs(arg_137_1.pickup) do
			if iter_137_1.start_time and var_137_1 > iter_137_1.start_time and iter_137_1.end_time and var_137_1 < iter_137_1.end_time then
				table.insert(var_137_0, {
					et = iter_137_1.end_time,
					id = iter_137_1.id
				})
			end
		end
	end
	
	return var_137_0
end

function GachaUnit.getDashEndTmActiveList(arg_138_0, arg_138_1)
	local var_138_0 = os.time()
	local var_138_1 = {}
	
	if not arg_138_1 then
		return 
	end
	
	if arg_138_1.gacha_story then
		for iter_138_0, iter_138_1 in pairs(arg_138_1.gacha_story) do
			local var_138_2 = iter_138_1
			local var_138_3 = Account:getTicketedLimit("gl:" .. iter_138_1.gacha_id)
			
			if var_138_3 then
				if to_n(var_138_3.count) < to_n(var_138_3.max_c) then
					var_138_2.start_time = var_138_3.usable_tm
					var_138_2.end_time = var_138_3.buyable_tm
				end
			elseif iter_138_1.id == "gacha_story_ep999" or iter_138_1.id == "gacha_spdash" then
				local var_138_4 = AccountData.package_limits["sh:" .. var_138_2.shop_id]
				
				if var_138_4 and to_n(var_138_4.count) < to_n(var_138_4.limit_count) then
					local var_138_5 = true
					local var_138_6 = ShopPromotion:getShopPromotionDataByPackageId(var_138_2.shop_id)
					
					if var_138_6 and var_138_6.condition and var_138_6.condition == "rank" and var_138_6.value then
						local var_138_7 = string.split(var_138_6.value, ",")
						local var_138_8 = Account:getLevel()
						
						if var_138_8 < to_n(var_138_7[1]) or var_138_8 > to_n(var_138_7[2] or 999) then
							var_138_5 = false
						end
					end
					
					if var_138_5 then
						var_138_2.start_time = var_138_4.start_time
						var_138_2.end_time = var_138_4.end_time
					end
				end
			end
			
			if var_138_0 >= to_n(var_138_2.start_time) - 60 and var_138_0 <= to_n(var_138_2.end_time) then
				table.push(var_138_1, {
					et = var_138_2.end_time,
					id = var_138_2.id
				})
			end
		end
	end
	
	return var_138_1
end

function GachaUnit.getSubStoryGachaEndTmOnActive(arg_139_0, arg_139_1)
	local var_139_0 = os.time()
	
	if not arg_139_1 then
		return 
	end
	
	if arg_139_1.gacha_substory and Account:isMapCleared("tae010") then
		local var_139_1 = arg_139_1.gacha_substory.end_time
		
		if var_139_0 < to_n(arg_139_1.gacha_substory.start_time) or var_139_0 > to_n(arg_139_1.gacha_substory.end_time) then
			var_139_1 = nil
		end
		
		return var_139_1
	end
end

function GachaUnit.getMoonlightEndTmOnActive(arg_140_0, arg_140_1)
	if arg_140_1 and arg_140_1.gacha_special and arg_140_1.gacha_special.current then
		return arg_140_1.gacha_special.current.moonlight_end_time
	end
end

function GachaUnit.checkTimeWarning(arg_141_0)
	if not Account:isRequireShowPeriodWarningCondition() then
		return 
	end
	
	local var_141_0 = {}
	local var_141_1 = Account:getGachaShopInfo()
	local var_141_2 = os.time()
	local var_141_3 = GAME_STATIC_VARIABLE.summon_expire_info_time or 172800
	
	if not var_141_1 then
		return 
	end
	
	local var_141_4 = arg_141_0:getPickUpActiveList(var_141_1)
	
	if var_141_4 then
		table.add(var_141_0, var_141_4)
	end
	
	table.insert(var_141_0, {
		id = "custom_special",
		et = arg_141_0:isEnabledGachaCustomSpecial()
	})
	table.insert(var_141_0, {
		id = "custom_group",
		et = arg_141_0:isEnabledGachaCustomGroup()
	})
	
	local var_141_5 = arg_141_0:getDashEndTmActiveList(var_141_1)
	
	if var_141_5 then
		table.add(var_141_0, var_141_5)
	end
	
	table.insert(var_141_0, {
		id = "substory",
		et = arg_141_0:getSubStoryGachaEndTmOnActive(var_141_1)
	})
	table.insert(var_141_0, {
		id = "moonlight",
		et = arg_141_0:getMoonlightEndTmOnActive(var_141_1)
	})
	
	for iter_141_0, iter_141_1 in pairs(var_141_0) do
		if iter_141_1.et and var_141_3 >= iter_141_1.et - var_141_2 then
			return true
		end
	end
	
	return false
end

function GachaUnit.checkNoti(arg_142_0)
	if GachaUnit:checkFreeGacha() or GachaUnit:checkFreeMoonlightGacha() then
		return true
	end
	
	local var_142_0 = {}
	
	for iter_142_0 = 1, 99 do
		local var_142_1 = {}
		
		var_142_1.id, var_142_1.system_unlock, var_142_1.gacha_select_check = DBN("gacha_select_condition", iter_142_0, {
			"id",
			"system_unlock",
			"gacha_select_check"
		})
		
		if not var_142_1.id then
			break
		end
		
		var_142_0[var_142_1.id] = var_142_1
	end
	
	local var_142_2 = Account:getGachaShopInfo()
	
	if not var_142_2 or not var_142_2.select_list then
		return false
	end
	
	for iter_142_1, iter_142_2 in pairs(var_142_0) do
		local var_142_3 = true
		
		if not UnlockSystem:isUnlockSystem(iter_142_2.system_unlock) then
			var_142_3 = false
		end
		
		if var_142_3 then
			local var_142_4 = var_142_2.select_list[iter_142_2.id]
			
			if var_142_4 and var_142_4.used == true then
				var_142_3 = false
			end
		end
		
		if var_142_3 and iter_142_2.gacha_select_check then
			local var_142_5 = var_142_2.select_list[iter_142_2.gacha_select_check]
			
			if var_142_5 and var_142_5.used ~= true then
				var_142_3 = false
			end
		end
		
		if var_142_3 and not json.decode(Account:getConfigData("gs_unlock_reddot") or "{}")[iter_142_2.id] then
			return true
		end
	end
	
	return false
end

function GachaUnit.updatePickupRemainTime(arg_143_0)
	if not arg_143_0.vars or not arg_143_0.vars.pickup_list or not get_cocos_refid(arg_143_0.vars.ui_right_menu_wnd) then
		return 
	end
	
	local var_143_0 = arg_143_0.vars.ui_right_menu_wnd:getChildByName("scrollview")
	local var_143_1 = os.time()
	
	for iter_143_0, iter_143_1 in ipairs(arg_143_0.vars.pickup_banners or {}) do
		local var_143_2 = iter_143_1
		
		if get_cocos_refid(var_143_2) then
			local var_143_3 = var_143_2:getChildByName("n_time")
			
			if get_cocos_refid(var_143_3) then
				if var_143_3.end_time_info and to_n(var_143_3.end_time_info) > 0 then
					local var_143_4 = to_n(var_143_3.end_time_info) - os.time()
					local var_143_5 = var_143_3.banner_opts or {}
					local var_143_6 = GAME_STATIC_VARIABLE.summon_expire_info_time or 172800
					
					if (var_143_5.gacha_start == "y" or var_143_5.gacha_story == "y") and var_143_4 > 0 and var_143_4 < var_143_6 then
						var_143_3:setVisible(true)
						if_set(var_143_3, "txt_progress", sec_to_string(var_143_4))
					elseif var_143_4 > 0 and var_143_4 < var_143_6 then
						var_143_3:setVisible(true)
						if_set(var_143_3, "txt_progress", sec_to_string(var_143_4))
					elseif var_143_4 <= 0 then
						var_143_3:setVisible(true)
						if_set(var_143_3, "txt_progress", T("expired"))
					else
						var_143_3:setVisible(false)
					end
				else
					var_143_3:setVisible(false)
				end
			end
		end
	end
end

function GachaUnit.showRightMenu(arg_144_0, arg_144_1, arg_144_2)
	if not arg_144_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_144_0.vars.ui_wnd) then
		return 
	end
	
	local var_144_0 = arg_144_0.vars.ui_wnd:getChildByName("n_right_menu")
	
	var_144_0:setVisible(true)
	
	if not arg_144_2 and arg_144_0.vars.ui_right_menu_wnd and get_cocos_refid(arg_144_0.vars.ui_right_menu_wnd) then
		arg_144_0:updateRightMenu(arg_144_1)
		
		return 
	end
	
	arg_144_0.vars.ui_right_menu_wnd = var_144_0
	
	local var_144_1 = os.time()
	local var_144_2 = var_144_0:getChildByName("scrollview")
	
	var_144_2:removeAllChildren()
	if_set_visible(var_144_0, "scrollview_always", false)
	
	local var_144_3 = {}
	local var_144_4 = 127
	local var_144_5 = 250
	local var_144_6 = Account:getGachaShopInfo()
	
	if var_144_6.pickup then
		for iter_144_0, iter_144_1 in ipairs(arg_144_0.vars.pickup_list) do
			if iter_144_1.start_time and var_144_1 > iter_144_1.start_time and iter_144_1.end_time and var_144_1 < iter_144_1.end_time then
				iter_144_1.touch_block = false
				
				local var_144_7 = createGachaBanner(iter_144_1)
				
				if var_144_7 then
					var_144_7:setContentSize({
						width = var_144_5,
						height = var_144_4
					})
					table.push(var_144_3, var_144_7)
				end
			end
		end
	end
	
	local var_144_8 = {}
	local var_144_9 = arg_144_0:isEnabledGachaCustomSpecial()
	
	if var_144_9 and UnlockSystem:isUnlockSystem(UNLOCK_ID.GACHA_CUSTOMGROUP) then
		local var_144_10 = createGachaBanner({
			customspecial = true,
			id = var_144_6.gacha_customspecial.id,
			end_time = var_144_9
		})
		
		if var_144_10 then
			var_144_10:setContentSize({
				width = var_144_5,
				height = var_144_4
			})
			table.push(var_144_8, {
				group = 1,
				sub_group = 1,
				pickup_banner = var_144_10
			})
		end
	end
	
	local var_144_11 = arg_144_0:isEnabledGachaCustomGroup()
	
	if var_144_11 then
		local var_144_12 = createGachaBanner({
			customgroup = true,
			id = var_144_6.gacha_customgroup.id,
			end_time = var_144_11
		})
		
		if var_144_12 then
			var_144_12:setContentSize({
				width = var_144_5,
				height = var_144_4
			})
			table.push(var_144_8, {
				group = 1,
				sub_group = 2,
				pickup_banner = var_144_12
			})
		end
	end
	
	if var_144_6.gacha_start then
		local var_144_13 = var_144_6.gacha_start
		local var_144_14 = Account:getTicketedLimit("gl:gacha_start")
		
		if var_144_14 then
			if to_n(var_144_14.count) < to_n(var_144_14.max_c) then
				var_144_13.start_time = var_144_14.usable_tm
				var_144_13.end_time = var_144_14.buyable_tm
			else
				var_144_13.start_time = 0
				var_144_13.end_time = 0
			end
		end
		
		if var_144_1 >= to_n(var_144_13.start_time) - 60 and var_144_1 <= to_n(var_144_13.end_time) then
			local var_144_15 = createGachaBanner(var_144_13, "gacha_start")
			
			if var_144_15 then
				var_144_15:setContentSize({
					width = var_144_5,
					height = var_144_4
				})
				table.push(var_144_8, {
					group = 3,
					sub_group = 1,
					pickup_banner = var_144_15
				})
			end
		end
	end
	
	local var_144_16
	
	if var_144_6.gacha_story then
		var_144_16 = 0
		
		for iter_144_2, iter_144_3 in pairs(var_144_6.gacha_story) do
			var_144_16 = var_144_16 + 1
			
			local var_144_17 = iter_144_3
			local var_144_18 = Account:getTicketedLimit("gl:" .. iter_144_3.gacha_id)
			
			if var_144_18 then
				if to_n(var_144_18.count) < to_n(var_144_18.max_c) then
					var_144_17.start_time = var_144_18.usable_tm
					var_144_17.end_time = var_144_18.buyable_tm
				else
					var_144_17.start_time = 0
					var_144_17.end_time = 0
				end
			elseif iter_144_3.id == "gacha_story_ep999" or iter_144_3.id == "gacha_spdash" then
				var_144_17.start_time = 0
				var_144_17.end_time = 0
				
				local var_144_19 = AccountData.package_limits["sh:" .. var_144_17.shop_id]
				
				if var_144_19 and to_n(var_144_19.count) < to_n(var_144_19.limit_count) then
					local var_144_20 = true
					local var_144_21 = ShopPromotion:getShopPromotionDataByPackageId(var_144_17.shop_id)
					
					if var_144_21 and var_144_21.condition and var_144_21.condition == "rank" and var_144_21.value then
						local var_144_22 = string.split(var_144_21.value, ",")
						local var_144_23 = Account:getLevel()
						
						if var_144_23 < to_n(var_144_22[1]) or var_144_23 > to_n(var_144_22[2] or 999) then
							var_144_20 = false
						end
					end
					
					if var_144_20 then
						var_144_17.start_time = var_144_19.start_time
						var_144_17.end_time = var_144_19.end_time
					end
				end
			end
			
			if var_144_1 >= to_n(var_144_17.start_time) - 60 and var_144_1 <= to_n(var_144_17.end_time) then
				local var_144_24 = createGachaBanner(var_144_17, "gacha_dash")
				
				if var_144_24 then
					var_144_24:setContentSize({
						width = var_144_5,
						height = var_144_4
					})
					table.push(var_144_8, {
						group = 3,
						pickup_banner = var_144_24,
						sub_group = 1 + var_144_16
					})
				end
			end
		end
	end
	
	if var_144_6.gacha_substory and Account:isMapCleared("tae010") then
		local var_144_25 = var_144_6.gacha_substory.end_time
		
		if var_144_1 < to_n(var_144_6.gacha_substory.start_time) or var_144_1 > to_n(var_144_6.gacha_substory.end_time) then
			var_144_25 = nil
		end
		
		local var_144_26 = createGachaBanner({
			gacha_substory = true,
			id = var_144_6.gacha_substory.id,
			end_time = var_144_25
		})
		
		if var_144_26 then
			var_144_26:setContentSize({
				width = var_144_5,
				height = var_144_4
			})
			table.push(var_144_8, {
				group = 5,
				sub_group = 1,
				pickup_banner = var_144_26
			})
		end
	end
	
	local var_144_27 = {}
	local var_144_28 = 60
	
	for iter_144_4, iter_144_5 in pairs(arg_144_0.vars.gacha_ui_list) do
		local var_144_29 = true
		local var_144_30 = iter_144_5.sort == 999
		
		if iter_144_5.id == "gacha_element" then
			local var_144_31 = 0
			local var_144_32 = UnlockSystem:isUnlockSystem(UNLOCK_ID.WORLD_BOSS) and 1 or to_n(Account:getConfigData("unlock_gacha_element"))
			
			if var_144_32 ~= 1 then
				local var_144_33 = {
					"ticketwind35",
					"ticketfire35",
					"ticketice35",
					"ticketdark35",
					"ticketlight35",
					"ticketwind45",
					"ticketfire45",
					"ticketice45",
					"ticketdark45",
					"ticketlight45"
				}
				local var_144_34 = 0
				
				for iter_144_6, iter_144_7 in pairs(var_144_33) do
					var_144_34 = var_144_34 + to_n(Account:getCurrency(iter_144_7))
				end
				
				if var_144_34 > 0 then
					var_144_32 = 1
					
					SAVE:setTempConfigData("unlock_gacha_element", var_144_32)
				end
			end
			
			if var_144_32 ~= 1 then
				var_144_29 = false
			end
		end
		
		local var_144_35
		local var_144_36
		local var_144_37
		local var_144_38
		
		if iter_144_5.id == "gacha_special" then
			var_144_30 = true
			var_144_36 = 2
			var_144_37 = 1
			
			if var_144_6 and var_144_6.gacha_special and var_144_6.gacha_special.current then
				var_144_38 = var_144_6.gacha_special.current.moonlight_end_time
			end
		end
		
		if arg_144_0.vars.gacha_select_condition[iter_144_5.id] then
			local var_144_39 = var_144_6.select_list[iter_144_5.id]
			
			if var_144_39 and var_144_39.used == true then
				var_144_29 = false
			end
			
			if var_144_29 and arg_144_0.vars.gacha_select_condition[iter_144_5.id].gacha_select_check then
				local var_144_40 = var_144_6.select_list[arg_144_0.vars.gacha_select_condition[iter_144_5.id].gacha_select_check]
				
				if var_144_40 and var_144_40.used ~= true then
					var_144_29 = false
				end
			end
			
			var_144_30 = true
			var_144_35 = "gacha_select"
			var_144_36 = 4
			var_144_37 = iter_144_4
		end
		
		if var_144_29 and var_144_30 then
			local var_144_41 = createGachaBanner({
				id = iter_144_5.id,
				gacha_ui_id = iter_144_5.gacha_ui_id,
				end_time = var_144_38
			}, var_144_35)
			
			table.push(var_144_8, {
				pickup_banner = var_144_41,
				group = var_144_36,
				sub_group = var_144_37
			})
			var_144_41:setContentSize({
				width = var_144_5,
				height = var_144_4
			})
		elseif var_144_29 then
			local var_144_42 = load_control("wnd/gacha_bar_menu2.csb")
			
			var_144_42:getChildByName("n_menu"):setName("n_" .. iter_144_5.id)
			var_144_42:getChildByName("btn_gacha"):setName("btn_summon_" .. iter_144_5.id)
			if_set_visible(var_144_42, "cursor", false)
			if_set_visible(var_144_42, "n_bar", false)
			if_set_visible(var_144_42, "icon_noti", false)
			if_set_visible(var_144_42, "icon_locked_select", false)
			if_set_visible(var_144_42, "shop_icon_event_b", false)
			if_set_visible(var_144_42, "shop_icon_bonus", false)
			
			if iter_144_5.icon_selective then
				if_set_visible(var_144_42, "icon", false)
				if_set_visible(var_144_42, "icon_selective", true)
				if_set_sprite(var_144_42, "icon_selective", iter_144_5.icon_selective .. ".png")
			else
				if_set_visible(var_144_42, "icon", true)
				if_set_visible(var_144_42, "icon_selective", false)
				if_set_sprite(var_144_42, "icon", iter_144_5.icon .. ".png")
			end
			
			if iter_144_5.img_eff then
				if_set_visible(var_144_42, "img_eff", true)
				if_set_sprite(var_144_42, "img_eff", "img/" .. iter_144_5.img_eff .. ".png")
			else
				if_set_visible(var_144_42, "img_eff", false)
			end
			
			if_set(var_144_42, "label", T(iter_144_5.name))
			
			if iter_144_5.id == "gacha_rare" then
				if arg_144_0:isFreeGachaRareEvent() then
					if_set_visible(var_144_42, "shop_icon_event_b", true)
				elseif arg_144_0:isFreeGachaRareBonus({
					"gl:gachafree_daily"
				}) then
					if_set_visible(var_144_42, "shop_icon_bonus", true)
				end
			elseif iter_144_5.id == "gacha_moonlight" and arg_144_0:isFreeGachaRareBonus({
				"gl:gachafree_daily_ml"
			}) then
				if_set_visible(var_144_42, "shop_icon_bonus", true)
			end
			
			local var_144_43 = var_144_42:getContentSize()
			
			var_144_42:setContentSize({
				width = var_144_5,
				height = var_144_43.height
			})
			table.push(var_144_27, var_144_42)
		end
	end
	
	table.sort(var_144_8, function(arg_145_0, arg_145_1)
		return arg_145_0.group * 100 + arg_145_0.sub_group < arg_145_1.group * 100 + arg_145_1.sub_group
	end)
	
	for iter_144_8, iter_144_9 in pairs(var_144_8) do
		table.insert(var_144_3, iter_144_9.pickup_banner)
	end
	
	local var_144_44 = table.count(var_144_3)
	local var_144_45 = table.count(var_144_27)
	local var_144_46 = 20
	local var_144_47 = var_144_44 * var_144_4 + var_144_45 * var_144_28 + var_144_46
	local var_144_48 = math.max(var_144_47, 653)
	
	var_144_2:setInnerContainerSize({
		width = var_144_5,
		height = var_144_48
	})
	
	for iter_144_10, iter_144_11 in pairs(var_144_3) do
		iter_144_11:setPosition(0, var_144_48 - var_144_4 * iter_144_10)
		var_144_2:addChild(iter_144_11)
	end
	
	arg_144_0.vars.pickup_banners = var_144_3
	
	for iter_144_12, iter_144_13 in pairs(var_144_27) do
		if_set_visible(iter_144_13, "n_bar", iter_144_12 == 1)
		iter_144_13:setPosition(0, var_144_48 - var_144_4 * var_144_44 - var_144_28 * iter_144_12 - var_144_46)
		var_144_2:addChild(iter_144_13)
	end
	
	arg_144_0:updateRightMenu()
end

function GachaUnit.isFreeGachaRareEvent(arg_146_0)
	local var_146_0 = Account:getGachaShopInfo()
	
	if var_146_0 == nil or var_146_0.free_ticket == nil then
		return 
	end
	
	local var_146_1 = var_146_0.free_ticket.gacha_rare_free_1
	
	if not var_146_1 then
		return 
	end
	
	if var_146_1 and var_146_1.is_free_event_day == "y" and var_146_1.intelli_option then
		local var_146_2 = Account:getTicketedLimit("gl:" .. var_146_1.intelli_option)
		local var_146_3 = os.time()
		
		if var_146_2 then
			return var_146_2 and to_n(var_146_2.max_c) > 1 and var_146_3 >= to_n(var_146_2.usable_tm) and var_146_3 <= to_n(var_146_2.buyable_tm) and to_n(var_146_2.count) < to_n(var_146_2.max_c)
		end
	end
end

function GachaUnit.isFreeGachaRareBonus(arg_147_0, arg_147_1)
	arg_147_1 = arg_147_1 or {
		"gl:gachafree_daily",
		"gl:gachafree_daily_ml"
	}
	
	local var_147_0, var_147_1 = arg_147_0:getFreeGachaBonusCount(arg_147_1)
	
	return var_147_0 < var_147_1
end

function GachaUnit.showUI(arg_148_0)
	if get_cocos_refid(arg_148_0.vars.gacha_layer) then
		arg_148_0.vars.gacha_layer:removeChild(arg_148_0.vars.dim)
	end
	
	arg_148_0.vars.ui_wnd_top = cc.Layer:create()
	arg_148_0.vars.ui_wnd = arg_148_0:loadDlgGachaAll()
	
	TopBarNew:create(T("ui_lobby_ui_gacha"), arg_148_0.vars.ui_wnd_top, function()
		if arg_148_0.vars and arg_148_0.vars.element_mode then
			GachaUnit:toggleElement()
			
			return 
		end
		
		UIUtil:playNPCSoundRandomly("gacha.leave")
		SceneManager:popScene()
	end, arg_148_0.vars.currency_list, nil, "infogach")
	arg_148_0.vars.ui_wnd:getChildByName("n_result"):setVisible(false)
	arg_148_0.vars.ui_wnd:getChildByName("n_result_artifact"):setVisible(false)
	arg_148_0.vars.ui_wnd:getChildByName("n_right_menu"):setVisible(false)
	
	if arg_148_0.vars.temp_gacha_mode then
		arg_148_0.vars.gacha_mode = arg_148_0.vars.temp_gacha_mode
		arg_148_0.vars.temp_gacha_mode = nil
	end
	
	if arg_148_0.vars.gacha_mode == "gacha_rare" then
		arg_148_0:enterGachaRare()
	elseif arg_148_0.vars.gacha_mode == "gacha_normal" then
		arg_148_0:enterGachaNormal()
	elseif arg_148_0.vars.gacha_mode == "gacha_moonlight" then
		arg_148_0:enterGachaMoonlight()
	elseif string.starts(arg_148_0.vars.gacha_mode, "gacha_pickup") then
		local var_148_0 = string.split(arg_148_0.vars.gacha_mode, ":")[2]
		
		if var_148_0 then
			arg_148_0:enterGachaPickup(var_148_0)
		else
			arg_148_0:enterGachaPickup()
		end
	elseif string.starts(arg_148_0.vars.gacha_mode, "gacha_select") then
		local var_148_1 = string.split(arg_148_0.vars.gacha_mode, ":")[2]
		
		arg_148_0:enterGachaSelect(var_148_1)
	elseif arg_148_0.vars.gacha_mode == "gacha_special" then
		arg_148_0:enterGachaSpecial()
	elseif arg_148_0.vars.gacha_mode == "gacha_element" then
		arg_148_0:enterGachaElement()
	elseif arg_148_0.vars.gacha_mode == "gacha_start" then
		arg_148_0:enterGachaStart()
	elseif string.starts(arg_148_0.vars.gacha_mode, "gacha_story") then
		local var_148_2 = string.split(arg_148_0.vars.gacha_mode, ":")[2]
		
		arg_148_0:enterGachaStory(var_148_2)
	elseif arg_148_0.vars.gacha_mode == "gacha_customgroup" then
		arg_148_0:enterGachaCustomGroup()
	elseif arg_148_0.vars.gacha_mode == "gacha_customspecial" then
		arg_148_0:enterGachaCustomSpecial()
	elseif arg_148_0.vars.gacha_mode == "gacha_substory" then
		arg_148_0:enterGachaSubstory()
	else
		arg_148_0:enterGachaPickup()
	end
	
	arg_148_0.vars.gacha_layer:addChild(arg_148_0.vars.ui_wnd, 100)
	arg_148_0.vars.gacha_layer:addChild(arg_148_0.vars.ui_wnd_top, 100)
	UIAction:Add(SEQ(FADE_IN(350)), arg_148_0.vars.ui_wnd_top, "block")
	UIAction:Add(SEQ(FADE_IN(350)), arg_148_0.vars.ui_wnd, "block")
	Scheduler:addSlow(arg_148_0.vars.ui_wnd, arg_148_0.autoUpdate, arg_148_0)
	SoundEngine:playBGM("event:/bgm/summon_title")
	BattleField:overlay(arg_148_0.vars.ui_wnd)
	GrowthGuideNavigator:proc()
end

function GachaUnit.checkFreeGacha(arg_150_0)
	local var_150_0, var_150_1 = arg_150_0:getFreeGachaEventCount()
	
	return var_150_0 < var_150_1
end

function GachaUnit.checkFreeMoonlightGacha(arg_151_0)
	local var_151_0, var_151_1 = arg_151_0:getFreeGachaEventCount("gacha_ml_free_1", "gl:gachafree_daily_ml")
	
	return var_151_0 < var_151_1
end

function GachaUnit.updateFreeGachaButton(arg_152_0)
	if not arg_152_0.vars or not get_cocos_refid(arg_152_0.vars.ui_wnd) then
		return 
	end
	
	if arg_152_0.vars.gacha_mode ~= "gacha_rare" and arg_152_0.vars.gacha_mode ~= "gacha_moonlight" then
		return 
	end
	
	local var_152_0 = arg_152_0.vars.ui_wnd:getChildByName("n_before")
	local var_152_1
	local var_152_2
	local var_152_3
	local var_152_4
	local var_152_5
	
	if arg_152_0.vars.gacha_mode == "gacha_moonlight" then
		var_152_3 = "gacha_ml_free_1"
		var_152_4 = "gl:gachafree_daily_ml"
	end
	
	local var_152_6 = var_152_0:getChildByName("n_btn_summon_2")
	
	if arg_152_0:isMoonlightBonus() then
		var_152_1 = var_152_0:getChildByName("btn_summon_up")
		var_152_2 = var_152_1:getChildByName("cm_free_tooltip")
	elseif get_cocos_refid(var_152_6) and var_152_6:isVisible() then
		var_152_1 = var_152_6:getChildByName("btn_summon_1")
		var_152_2 = var_152_1:getChildByName("cm_free_tooltip")
	else
		var_152_1 = var_152_0:getChildByName("btn_summon")
		
		if get_cocos_refid(var_152_1) then
			var_152_1:setVisible(true)
		end
		
		var_152_2 = var_152_1:getChildByName("cm_free_tooltip")
	end
	
	if get_cocos_refid(var_152_2) then
		var_152_2:setVisible(false)
	end
	
	local function var_152_7(arg_153_0, arg_153_1, arg_153_2)
		local var_153_0 = string.split(arg_153_1, "\n")
		
		var_153_0[2] = var_153_0[2] or ""
		
		if_set(arg_153_0, "txt_free", var_153_0[1] .. " " .. var_153_0[2])
		
		local var_153_1 = arg_153_0:getChildByName("txt_free")
		
		var_153_1:setString(var_153_0[1] .. " " .. var_153_0[2])
		var_153_1:setTextColor(arg_153_2)
	end
	
	local var_152_8
	
	if get_cocos_refid(var_152_6) then
		var_152_8 = var_152_6:getChildByName("btn_summon_10")
		
		if get_cocos_refid(var_152_8) then
			if_set_visible(var_152_8, "cm_free_tooltip2", false)
		end
	end
	
	local var_152_9, var_152_10 = arg_152_0:getFreeGachaEventCount(var_152_3, var_152_4)
	
	if var_152_9 < var_152_10 then
		var_152_7(var_152_2, T("gacha_free_able", {
			curr = var_152_10 - var_152_9,
			max = var_152_10
		}), cc.c3b(25, 107, 0))
		if_set_visible(var_152_1, "cm_icon_gacha", false)
		if_set(var_152_1, "cost", T("shop_price_free"))
		if_set_visible(var_152_2, nil, true)
		
		if arg_152_0.vars.gacha_mode == "gacha_rare" and var_152_10 - var_152_9 >= 10 and get_cocos_refid(var_152_8) and var_152_6:isVisible() then
			if_set(var_152_8, "cost", T("shop_price_free"))
			if_set_visible(var_152_8, "cm_free_tooltip2", true)
			
			local var_152_11 = var_152_8:getChildByName("cm_free_tooltip2")
			
			if_set(var_152_11, "txt_free", T("gacha_free10_able"))
		end
	end
end

function GachaUnit.autoUpdate(arg_154_0)
	if not arg_154_0.vars or not get_cocos_refid(arg_154_0.vars.ui_wnd) then
		return 
	end
	
	arg_154_0:updateFreeGachaButton()
	arg_154_0:updateSpecialGachaTime(false)
	arg_154_0:updateSpecialGachaTime(true)
	arg_154_0:updatePickupRemainTime()
	arg_154_0:updateGachaCustomGroupTime()
	arg_154_0:updateGachaCustomSpecialTime()
	arg_154_0:updateGachaStoryTime()
end

function GachaUnit.shareUnit(arg_155_0)
	local var_155_0 = {
		{
			action = "hide",
			path = "gacha_result_unit/n_result/n_buttons_back"
		},
		{
			action = "hide",
			path = "gacha_result_unit/n_result/n_btn_share_zl"
		},
		{
			action = "hide",
			path = "gacha_result_unit/n_result/n_buttons"
		},
		{
			action = "hide",
			path = "gacha_result_unit/n_result/n_name/n_more_info/btn_more_info"
		},
		{
			action = "hide",
			path = "gacha_result_unit/n_result/n_temp_msg"
		}
	}
	
	GachaResultShare:open(arg_155_0.vars.ui_wnd, var_155_0)
end

function GachaUnit.shareSummary(arg_156_0)
	local var_156_0 = {
		{
			action = "hide",
			path = "n_10gacha/t_title"
		},
		{
			action = "hide",
			path = "n_10gacha/t_disc"
		},
		{
			action = "hide",
			path = "n_buttons"
		},
		{
			action = "hide",
			path = "n_temp_msg"
		},
		{
			action = "move",
			path = "n_10gacha/n_list"
		}
	}
	
	GachaResultShare:open(arg_156_0.vars.ui_wnd, var_156_0)
end

function GachaUnit.isResultNewUnit(arg_157_0, arg_157_1, arg_157_2)
	if string.starts(arg_157_1, "gacha_select") then
		return not Account:getCollectionUnit(arg_157_2)
	end
	
	return arg_157_0:is_new()
end

function GachaUnit.isResultFiveGrade(arg_158_0)
	if not arg_158_0.vars or not arg_158_0.vars.gacha_results then
		return false
	end
	
	for iter_158_0, iter_158_1 in pairs(arg_158_0.vars.gacha_results) do
		if iter_158_1.g == 5 then
			return true
		end
	end
	
	return false
end

function GachaUnit.isVisibleUnitShare(arg_159_0)
	if ContentDisable:byAlias("gacha_result_share") then
		return false
	end
	
	if not IS_PUBLISHER_ZLONG then
		return false
	end
	
	if arg_159_0:isMultiResults() then
		return false
	end
	
	if not arg_159_0:isResultFiveGrade() then
		return false
	end
	
	return true
end

function GachaUnit.setUnitResultButtonsUI(arg_160_0, arg_160_1, arg_160_2)
	if not get_cocos_refid(arg_160_1) then
		return 
	end
	
	local var_160_0 = arg_160_1:getChildByName("n_buttons")
	
	if not get_cocos_refid(var_160_0) then
		return 
	end
	
	local var_160_1 = arg_160_1:getChildByName("n_buttons_ext")
	
	if not get_cocos_refid(var_160_1) then
		return 
	end
	
	if_set(var_160_1, "label", T("ui_gacha_result_btn_confirm"))
	if_set_visible(var_160_0, nil, arg_160_2)
	if_set_visible(var_160_1, nil, not arg_160_2)
	if_set_visible(arg_160_1, "n_buttons_back", false)
	if_set_visible(var_160_0, "btn_next", false)
	if_set_visible(var_160_0, "btn_summon_r1", false)
	if_set_visible(var_160_0, "btn_summon_r2", false)
	if_set_visible(var_160_0, "btn_summon_up", false)
	if_set_visible(arg_160_1, "n_btn_share_zl", arg_160_0:isVisibleUnitShare())
	
	if arg_160_2 then
		if arg_160_0:isMultiResults() then
			if_set_visible(var_160_0, "btn_next", true)
			
			if arg_160_0.vars.is_add_temp_inventory then
				local var_160_2 = arg_160_1:getChildByName("n_temp_msg_move")
				
				if_set_position_y(arg_160_1, "n_temp_msg", var_160_2:getPositionY())
			end
		elseif arg_160_0.vars.gacha_mode == "gacha_start" or string.starts(arg_160_0.vars.gacha_mode, "gacha_story") then
			if_set_visible(arg_160_1, "n_buttons_back", true)
			if_set_visible(var_160_0, "btn_summon_r2", true)
			arg_160_0:setRetryButton(var_160_0:getChildByName("btn_summon_r2"))
		else
			if_set_visible(arg_160_1, "n_buttons_back", true)
			
			local var_160_3 = arg_160_0:isMoonlightBonus() and "btn_summon_up" or "btn_summon_r1"
			
			if_set_visible(arg_160_1, "n_buttons_back", var_160_3)
			arg_160_0:setRetryButton(var_160_0:getChildByName(var_160_3))
		end
	end
end

function GachaUnit.setUnitResultUI(arg_161_0, arg_161_1, arg_161_2, arg_161_3)
	if not get_cocos_refid(arg_161_1) then
		return 
	end
	
	if_set_visible(arg_161_1, "n_skip", arg_161_0:isMultiResults())
	if_set_visible(arg_161_1, "n_temp_msg", arg_161_0.vars.is_add_temp_inventory)
	arg_161_0:setUnitResultButtonsUI(arg_161_1, arg_161_2)
	UIUtil:setUnitAllInfo(arg_161_1, arg_161_0.vars.unit, {
		use_basic_star = true
	})
	
	local var_161_0 = arg_161_1:getChildByName("txt_name")
	
	if_call(arg_161_1, "star1", "setPositionX", 10 + var_161_0:getContentSize().width * var_161_0:getScaleX() + var_161_0:getPositionX())
	
	local var_161_1 = arg_161_1:getChildByName("txt_story")
	
	var_161_1:setString(T(DB("character", arg_161_0.vars.code, "2line"), "text"))
	
	local var_161_2 = var_161_1:getStringNumLines()
	
	if_set_visible(arg_161_0.vars.ui_wnd, "n_name_top", not arg_161_0.vars.unit:isSummon())
	
	local var_161_3 = arg_161_1:getChildByName("n_more_info")
	
	var_161_3:setPositionY(var_161_1:getPositionY() - (20 + var_161_2 * var_161_1:getLineHeight() * var_161_1:getScale()))
	
	local var_161_4 = DB("character", arg_161_0.vars.code, {
		"grade"
	})
	
	WidgetUtils:setupPopup({
		control = var_161_3:getChildByName("btn_more_info"),
		creator = function()
			return UIUtil:getCharacterPopup({
				skill_preview = false,
				z = 6,
				use_basic_star = true,
				lv = 1,
				code = arg_161_0.vars.code,
				grade = var_161_4
			})
		end
	})
	if_set_visible(var_161_3, "btn_more_info", false)
	
	local var_161_5 = UnitInfosUtil:getCharacterVoiceName(arg_161_0.vars.code)
	
	if_set_visible(var_161_3, "n_cv", var_161_5)
	if_set(var_161_3, "txt_cv", var_161_5)
	
	if arg_161_0:isResultNewUnit(arg_161_0.vars.gacha_mode, arg_161_0.vars.code) then
		local var_161_6 = arg_161_1:getChildByName("n_new")
		
		if get_cocos_refid(var_161_6) then
			var_161_6:addChild(SpriteCache:getSprite("img/gacha_new.png"))
		end
	end
	
	local var_161_7 = arg_161_1:getChildByName("n_coin")
	
	if get_cocos_refid(var_161_7) and arg_161_0.vars.dupl_token and to_n(arg_161_0.vars.dupl_token.count) > 0 then
		var_161_7:setVisible(true)
		if_set(var_161_7, "label", T("summon_" .. arg_161_0.vars.dupl_token.code .. "_get"))
		
		local var_161_8 = arg_161_0.vars.dupl_token.code
		
		if string.starts(var_161_8, "to_") then
			var_161_8 = string.sub(var_161_8, 4, -1)
		end
		
		UIUtil:getRewardIcon(to_n(arg_161_0.vars.dupl_token.count), "to_" .. var_161_8, {
			parent = var_161_7:getChildByName("n_reward_item")
		})
	else
		if_set_visible(arg_161_1, "n_coin", false)
	end
	
	arg_161_0.vars.gacha_layer:addChild(arg_161_0.vars.ui_wnd, 100)
	UIAction:Add(SEQ(DELAY(arg_161_3), CALL(if_set_visible, var_161_3, "btn_more_info", true), FADE_IN(300), CALL(GachaUnit.characterIntroStory, arg_161_0), CALL(function()
		if arg_161_2 then
			BackButtonManager:pop("GachaUnit")
		end
	end), CALL(function()
		if arg_161_2 then
			if GachaUnit.vars and arg_161_0:isMultiResults() then
				BackButtonManager:push({
					check_id = "gacha",
					back_func = function()
						GachaUnit:gachaNext()
					end
				})
			else
				BackButtonManager:push({
					check_id = "gacha",
					back_func = function()
						GachaUnit:front()
					end
				})
			end
		end
	end)), arg_161_0.vars.ui_wnd, "block")
end

function GachaUnit.isResultNewArtifact(arg_167_0, arg_167_1, arg_167_2)
	if string.starts(arg_167_1, "gacha_select") then
		return not Account:getCollectionEquip(arg_167_2)
	end
	
	return arg_167_0:is_new()
end

function GachaUnit.setArtifactResultButtonsUI(arg_168_0, arg_168_1, arg_168_2)
	if not get_cocos_refid(arg_168_1) then
		return 
	end
	
	local var_168_0 = arg_168_1:getChildByName("n_buttons")
	
	if not get_cocos_refid(var_168_0) then
		return 
	end
	
	local var_168_1 = arg_168_1:getChildByName("n_buttons_ext")
	
	if not get_cocos_refid(var_168_1) then
		return 
	end
	
	if_set(var_168_1, "label", T("ui_gacha_result_btn_confirm"))
	if_set_visible(var_168_0, nil, arg_168_2)
	if_set_visible(var_168_1, nil, not arg_168_2)
	if_set_visible(arg_168_1, "n_buttons_back", false)
	if_set_visible(var_168_0, "btn_next", false)
	if_set_visible(var_168_0, "btn_summon_r1", false)
	if_set_visible(var_168_0, "btn_summon_r2", false)
	
	if arg_168_2 then
		if arg_168_0:isMultiResults() then
			if_set_visible(var_168_0, "btn_next", true)
			
			if arg_168_0.vars.is_add_temp_inventory then
				local var_168_2 = arg_168_1:getChildByName("n_temp_msg_move")
				
				if_set_position_y(arg_168_1, "n_temp_msg", var_168_2:getPositionY())
			end
		elseif arg_168_0.vars.gacha_mode == "gacha_start" or string.starts(arg_168_0.vars.gacha_mode, "gacha_story") then
			if_set_visible(arg_168_1, "n_buttons_back", true)
			if_set_visible(var_168_0, "btn_summon_r2", true)
			arg_168_0:setRetryButton(var_168_0:getChildByName("btn_summon_r2"))
		else
			if_set_visible(arg_168_1, "n_buttons_back", true)
			if_set_visible(var_168_0, "btn_summon_r1", true)
			arg_168_0:setRetryButton(var_168_0:getChildByName("btn_summon_r1"))
		end
	end
end

function GachaUnit.setArtifactResultUI(arg_169_0, arg_169_1, arg_169_2, arg_169_3)
	if not get_cocos_refid(arg_169_1) then
		return 
	end
	
	if_set_visible(arg_169_1, "n_skip", arg_169_0:isMultiResults())
	if_set_visible(arg_169_1, "n_temp_msg", arg_169_0.vars.is_add_temp_inventory)
	arg_169_0:setArtifactResultButtonsUI(arg_169_1, arg_169_2)
	
	local var_169_0 = arg_169_1:getChildByName("n_skill"):getChildByName("cm_tooltipbox")
	local var_169_1 = UIUtil:setTextAndReturnHeight(var_169_0:getChildByName("txt_skill_desc"))
	local var_169_2 = {
		wnd = arg_169_1,
		equip = arg_169_0.vars.equip
	}
	
	var_169_2.no_resize = true
	var_169_2.no_resize_name = true
	var_169_2.txt_name = arg_169_1:getChildByName("txt_name")
	
	ItemTooltip:updateItemInformation(var_169_2)
	
	local var_169_3 = UIUtil:setTextAndReturnHeight(var_169_0:getChildByName("txt_skill_desc"))
	local var_169_4, var_169_5 = DB("equip_item", arg_169_0.vars.code, {
		"artifact_grade",
		"role"
	})
	local var_169_6 = arg_169_1:getChildByName("n_role")
	local var_169_7 = 0
	
	if var_169_5 then
		if_set_sprite(var_169_6, "role", "img/cm_icon_role_" .. var_169_5 .. ".png")
		if_set(var_169_6, "txt_role", T("ui_artifact_detail_sub_role", {
			role = T("ui_hero_role_" .. var_169_5)
		}))
		var_169_6:setVisible(true)
		
		var_169_7 = 42
	else
		var_169_6:setVisible(false)
	end
	
	local var_169_8 = arg_169_1:getChildByName("n_more_info")
	
	var_169_8:setPositionY(var_169_8:getPositionY() - var_169_7)
	
	arg_169_0.vars.equip = arg_169_0.vars.equip or EQUIP:createByInfo({
		code = arg_169_0.vars.code
	})
	
	WidgetUtils:setupPopup({
		control = var_169_8:getChildByName("btn_more_info"),
		creator = function()
			return ItemTooltip:getItemTooltip({
				show_max_check_box = true,
				artifact_popup = true,
				code = arg_169_0.vars.code,
				grade = var_169_4,
				equip = arg_169_0.vars.equip,
				equip_stat = arg_169_0.vars.equip.stats
			})
		end
	})
	if_set_visible(var_169_8, "btn_more_info", false)
	
	if arg_169_0:isResultNewArtifact(arg_169_0.vars.gacha_mode, arg_169_0.vars.code) then
		local var_169_9 = arg_169_1:getChildByName("n_new")
		
		if get_cocos_refid(var_169_9) then
			var_169_9:addChild(SpriteCache:getSprite("img/gacha_new.png"))
		end
	end
	
	arg_169_0.vars.gacha_layer:addChild(arg_169_0.vars.ui_wnd, 100)
	UIAction:Add(SEQ(DELAY(arg_169_3), CALL(if_set_visible, var_169_8, "btn_more_info", true), FADE_IN(300), CALL(function()
		if arg_169_2 then
			BackButtonManager:pop("GachaUnit")
		end
	end), CALL(function()
		if arg_169_2 then
			if GachaUnit.vars and arg_169_0:isMultiResults() then
				BackButtonManager:push({
					check_id = "gacha",
					back_func = function()
						GachaUnit:gachaNext()
					end
				})
			else
				BackButtonManager:push({
					check_id = "gacha",
					back_func = function()
						GachaUnit:front()
					end
				})
			end
		end
	end)), arg_169_0.vars.ui_wnd, "block")
end

function GachaUnit.isIgnoreUseInGacha(arg_175_0)
	if arg_175_0.vars.callback_func then
		return true
	end
	
	if arg_175_0.vars.gacha_mode == "gacha_start" then
		local var_175_0 = Account:getTicketedLimit("gl:gacha_start")
		
		if var_175_0 and to_n(var_175_0.max_c) <= to_n(var_175_0.count) then
			return true
		end
	elseif string.starts(arg_175_0.vars.gacha_mode, "gacha_story") then
		local var_175_1 = string.split(arg_175_0.vars.gacha_mode, ":")[2]
		local var_175_2 = Account:getGachaShopInfo().gacha_story[var_175_1]
		local var_175_3 = Account:getTicketedLimit("gl:" .. var_175_2.gacha_id)
		
		if var_175_3 and to_n(var_175_3.max_c) <= to_n(var_175_3.count) then
			return true
		end
	end
	
	return false
end

function GachaUnit.showResultUI(arg_176_0, arg_176_1, arg_176_2)
	arg_176_1 = arg_176_1 and not arg_176_0:isIgnoreUseInGacha()
	
	if get_cocos_refid(arg_176_0.vars.gacha_layer) and get_cocos_refid(arg_176_0.vars.ui_wnd) then
		arg_176_0.vars.gacha_layer:removeChild(arg_176_0.vars.ui_wnd)
	end
	
	arg_176_0.vars.ui_wnd = arg_176_0:loadDlgGachaAll()
	
	if not get_cocos_refid(arg_176_0.vars.ui_wnd) then
		return 
	end
	
	if_set_visible(arg_176_0.vars.ui_wnd, "n_before", false)
	if_set_visible(arg_176_0.vars.ui_wnd, "n_right_menu", false)
	if_set_opacity(arg_176_0.vars.ui_wnd, nil, 0)
	
	local var_176_0 = arg_176_0.vars.ui_wnd:getChildByName("n_result")
	local var_176_1 = arg_176_0.vars.ui_wnd:getChildByName("n_result_artifact")
	local var_176_2 = arg_176_0.vars.gacha_type == "character"
	
	if_set_visible(var_176_0, nil, var_176_2)
	if_set_visible(var_176_1, nil, not var_176_2)
	
	if var_176_2 then
		arg_176_0:setUnitResultUI(var_176_0, arg_176_1, arg_176_2)
	else
		arg_176_0:setArtifactResultUI(var_176_1, arg_176_1, arg_176_2)
	end
end

function GachaUnit.createFakeEffectList(arg_177_0)
	arg_177_0.vars.fake_list = {}
	
	local var_177_0 = true
	
	if arg_177_0.vars.last_not_req_rand then
		print("ACTIVE!")
		
		var_177_0 = false
	end
	
	local var_177_1 = false
	
	if arg_177_0.vars.last_buy_item == "gacha_moonlight" then
		var_177_1 = true
	end
	
	print("is_req_rand?", var_177_0)
	
	for iter_177_0, iter_177_1 in pairs(arg_177_0.vars.gacha_results) do
		local var_177_2
		local var_177_3
		local var_177_4
		local var_177_5
		local var_177_6 = false
		local var_177_7 = math.random() * 100
		
		if not PRODUCTION_MODE and arg_177_0.vars.test_fake_set_rate then
			var_177_7 = arg_177_0.vars.test_fake_set_rate
		end
		
		if iter_177_1.gacha_type == "character" then
			local var_177_8 = iter_177_1.code
			local var_177_9, var_177_10 = DB("character", var_177_8, {
				"grade",
				"moonlight"
			})
			
			var_177_4 = var_177_9
			var_177_5 = var_177_10
			var_177_5 = var_177_5 or false
			
			if var_177_0 and var_177_9 >= 4 and var_177_7 < 10 then
				var_177_6 = true
				
				if var_177_9 == 4 then
					if not var_177_10 then
						var_177_2 = 3
						var_177_3 = false
					elseif var_177_7 > 5 or var_177_1 then
						var_177_2 = 3
						var_177_3 = false
					else
						var_177_2 = 4
						var_177_3 = false
					end
				elseif not var_177_10 then
					if var_177_7 > 5 then
						var_177_2 = 3
						var_177_3 = false
					else
						var_177_2 = 4
						var_177_3 = false
					end
				elseif var_177_7 < 3.333333333333333 or var_177_1 and var_177_7 > 5 then
					var_177_2 = 3
					var_177_3 = false
				elseif var_177_7 > 3.333333333333333 and var_177_7 < 6.666666666666666 and not var_177_1 then
					var_177_2 = 4
					var_177_3 = false
				else
					var_177_2 = 4
					var_177_3 = "y"
				end
			end
		else
			local var_177_11 = DB("equip_item", iter_177_1.code, "artifact_grade")
			
			var_177_4 = var_177_11
			var_177_5 = false
			
			if var_177_0 and var_177_11 >= 4 and var_177_7 < 10 then
				var_177_6 = true
				
				if var_177_11 == 4 then
					var_177_2 = 3
					var_177_3 = false
				elseif var_177_7 > 5 then
					var_177_2 = 3
					var_177_3 = false
				else
					var_177_2 = 4
					var_177_3 = false
				end
			end
		end
		
		if not PRODUCTION_MODE then
			if arg_177_0.vars.test_fake_mode == "not_use_fake" then
				var_177_2 = var_177_4
				var_177_3 = var_177_5
				var_177_6 = false
			elseif arg_177_0.vars.test_fake_mode and (var_177_4 > arg_177_0.vars.test_fake_grade or var_177_5 and not arg_177_0.vars.test_fake_moonlight and var_177_4 >= arg_177_0.vars.test_fake_grade) then
				var_177_2 = arg_177_0.vars.test_fake_grade
				
				if not var_177_1 then
					var_177_3 = arg_177_0.vars.test_fake_moonlight
				else
					var_177_3 = var_177_5
				end
				
				if iter_177_1.gacha_type ~= "character" or not var_177_5 then
					var_177_3 = false
				end
				
				if var_177_2 ~= var_177_4 or var_177_3 ~= var_177_5 then
					var_177_6 = true
				end
			end
		end
		
		table.insert(arg_177_0.vars.fake_list, {
			show_grade = var_177_2,
			show_moonlight = var_177_3,
			original_grade = var_177_4,
			original_moonlight = var_177_5,
			fake = var_177_6
		})
	end
	
	local var_177_12 = 6
	local var_177_13
	local var_177_14 = 3
	local var_177_15 = false
	
	for iter_177_2, iter_177_3 in pairs(arg_177_0.vars.fake_list) do
		if iter_177_3.fake then
			if var_177_12 > iter_177_3.show_grade then
				var_177_12 = iter_177_3.show_grade
				var_177_13 = iter_177_3.show_moonlight
			elseif iter_177_3.show_grade == var_177_12 and not iter_177_3.show_moonlight and var_177_13 == "y" then
				var_177_13 = iter_177_3.show_moonlight
			end
		else
			if var_177_14 < iter_177_3.original_grade then
				var_177_14 = iter_177_3.original_grade
				var_177_15 = iter_177_3.original_moonlight
			end
			
			if iter_177_3.original_grade == var_177_14 and iter_177_3.moonlight then
				var_177_15 = var_177_15 or iter_177_3.original_moonlight
			end
		end
	end
	
	if var_177_12 ~= 6 then
		arg_177_0.vars.begin_show_grade = var_177_12
		arg_177_0.vars.begin_show_moonlight = var_177_13
	else
		arg_177_0.vars.begin_show_grade = var_177_14
		arg_177_0.vars.begin_show_moonlight = var_177_15
	end
end

function GachaUnit.seqIntroBookTouchWait(arg_178_0, arg_178_1, arg_178_2)
	if not arg_178_0.vars.gacha_layer then
		return 
	end
	
	arg_178_0.vars.skip_on = nil
	arg_178_0.vars.gacha_results = arg_178_1
	arg_178_0.vars.new_codes = arg_178_2 or {}
	arg_178_0.vars.current_index = 0
	arg_178_0.vars.is_add_temp_inventory = false
	
	if arg_178_0.vars.last_buy_item == "gacha_normal" then
		arg_178_0:summaryUI()
		
		return 
	end
	
	if not arg_178_0.vars.callback_func then
		BackButtonManager:push({
			check_id = "GachaUnit",
			back_func = function()
				GachaUnit:touched()
			end
		})
	end
	
	arg_178_0:cleanUpResult()
	
	if arg_178_0.vars.buy_more == true then
		arg_178_0:seqIntro(true, true)
		
		arg_178_0.vars.buy_more = nil
	end
	
	arg_178_0:createFakeEffectList()
	
	if arg_178_0.vars.gacha_effect then
		arg_178_0.vars.gacha_effect:removeAll()
		
		arg_178_0.vars.gacha_effect = nil
	end
	
	arg_178_0:setMode("summoning")
	GachaIntroduceBG:close()
	GachaIntroduceBG.Util:setSilent()
	GachaIntroduceBG.Util:setVolume()
	
	if arg_178_0.vars.ui_wnd_top and get_cocos_refid(arg_178_0.vars.ui_wnd_top) then
		UIAction:Add(SEQ(FADE_OUT(200), REMOVE()), arg_178_0.vars.ui_wnd_top, "block")
	end
	
	UIAction:Add(SEQ(FADE_OUT(200), REMOVE()), arg_178_0.vars.ui_wnd, "block")
	
	if not arg_178_0.vars.buy_more then
		local var_178_0 = cc.LayerColor:create(cc.c4b(0, 0, 0, 255))
		
		var_178_0:setContentSize(VIEW_WIDTH, VIEW_HEIGHT)
		var_178_0:setPositionX(VIEW_BASE_LEFT)
		var_178_0:setOpacity(0)
		var_178_0:setLocalZOrder(1000)
		UIAction:Add(SEQ(LOG(FADE_IN(200)), DELAY(100), CALL(function()
			GachaUnit:setupGachaObject()
			arg_178_0.vars.gacha_effect:begin(arg_178_0.vars.code)
		end), LOG(FADE_OUT(200)), REMOVE()), var_178_0, "block")
		arg_178_0.vars.layer:addChild(var_178_0)
	else
		GachaUnit:setupGachaObject()
		arg_178_0.vars.gacha_effect:begin(arg_178_0.vars.code)
	end
end

function GachaUnit.isNextPresent(arg_181_0)
	return table.count(arg_181_0.vars.gacha_results) > arg_181_0.vars.current_index
end

function GachaUnit.isMultiResults(arg_182_0)
	return table.count(arg_182_0.vars.gacha_results) > 1
end

function GachaUnit.setupGachaObject(arg_183_0)
	arg_183_0.vars.current_index = arg_183_0.vars.current_index + 1
	
	local var_183_0 = arg_183_0.vars.gacha_results[arg_183_0.vars.current_index]
	
	if var_183_0 == nil then
		if not PRODUCTION_MODE then
			print("GachaUnit.setupGachaObject >>>>>> NIL", arg_183_0.vars.current_index)
		end
		
		return nil
	end
	
	arg_183_0.vars.gacha_type = var_183_0.gacha_type
	arg_183_0.vars.is_add_temp_inventory = var_183_0.ti == 1
	arg_183_0.vars.unit = nil
	arg_183_0.vars.equip = nil
	arg_183_0.vars.portrait = nil
	arg_183_0.vars.code = var_183_0.code
	arg_183_0.vars.dupl_token = var_183_0.dupl_token
	arg_183_0.vars.current_grade = 0
	arg_183_0.vars.summoned_code = arg_183_0.vars.summoned_code or {}
	arg_183_0.vars.summoned_code[arg_183_0.vars.code] = (arg_183_0.vars.summoned_code[arg_183_0.vars.code] or 0) + 1
	
	if not arg_183_0.vars.gacha_effect then
		arg_183_0:createGachaEffect()
	end
	
	if arg_183_0.vars.gacha_type == "character" then
		arg_183_0.vars.unit = UNIT:create({
			z = 6,
			code = var_183_0.code,
			exp = var_183_0.exp,
			g = var_183_0.g
		})
		arg_183_0.vars.current_grade = arg_183_0.vars.unit.inst.grade
	else
		if var_183_0.id then
			arg_183_0.vars.equip = Account:getEquip(var_183_0.id)
			
			if arg_183_0.vars.equip == nil then
				arg_183_0.vars.equip = EQUIP:createByInfo(var_183_0)
			end
		else
			arg_183_0.vars.equip = EQUIP:createByInfo(var_183_0)
		end
		
		arg_183_0.vars.current_grade = arg_183_0.vars.equip.grade
	end
	
	if not PRODUCTION_MODE then
		print("GachaUnit.setupGachaObject >>>>>>", "#" .. (arg_183_0.vars.current_index or "NIL") .. " / " .. (arg_183_0.vars.code or "NIL") .. " ^" .. (arg_183_0.vars.current_grade or "NIL"))
	end
	
	if arg_183_0.vars.gacha_effect then
		arg_183_0.vars.gacha_effect:setup(arg_183_0.vars.code)
	end
	
	return arg_183_0.vars.current_grade
end

function GachaUnit.onShowNextSummonResult(arg_184_0)
	arg_184_0:setMode("summon_result")
	GachaUnit:showResultUI(true, 600)
end

function GachaUnit.cleanUpResult(arg_185_0)
	if arg_185_0.vars.sfx_summary_loop and get_cocos_refid(arg_185_0.vars.sfx_summary_loop) then
		arg_185_0.vars.sfx_summary_loop:stop()
	end
	
	if not get_cocos_refid(arg_185_0.vars.gacha_layer) then
		return 
	end
	
	for iter_185_0, iter_185_1 in pairs(arg_185_0.vars.result) do
		if get_cocos_refid(iter_185_1) then
			iter_185_1:removeFromParent()
			stop_or_remove(iter_185_1)
		end
	end
	
	arg_185_0.vars.result = {}
end

function GachaUnit.isSkipableGrade(arg_186_0, arg_186_1)
	local var_186_0 = 4
	
	if arg_186_1 then
		return arg_186_0.vars.current_grade and var_186_0 > arg_186_0.vars.current_grade
	end
	
	if string.starts(arg_186_0.vars.gacha_mode, "gacha_select") then
		return true
	end
	
	if arg_186_0.vars.current_grade == 4 and SAVE:getOptionData("option.skip_4", true) == true then
		return true
	end
	
	if arg_186_0.vars.current_grade == 5 and SAVE:getOptionData("option.skip_5", true) == true then
		return true
	end
	
	return arg_186_0.vars.current_grade and var_186_0 > arg_186_0.vars.current_grade
end

function GachaUnit.setMode(arg_187_0, arg_187_1)
	if not PRODUCTION_MODE then
		print("GachaUnit.setMode", (arg_187_0.vars.mode or "NIL") .. " -> " .. (arg_187_1 or "NIL"), "#" .. (arg_187_0.vars.current_index or "NIL") .. " / " .. (arg_187_0.vars.code or "NIL") .. " ^" .. (arg_187_0.vars.current_grade or "NIL"))
	end
	
	local var_187_0 = arg_187_0.vars.mode
	
	arg_187_0.vars.mode = arg_187_1
	
	return var_187_0
end

function GachaUnit.skip(arg_188_0)
	if arg_188_0:isTutorialMode() == true and string.starts(arg_188_0.vars.gacha_mode, "gacha_select") ~= true then
		return 
	end
	
	if arg_188_0.vars.mode == "skipping" then
		return 
	end
	
	if not arg_188_0.vars.gacha_effect then
		return 
	end
	
	if arg_188_0.vars.gacha_effect and not arg_188_0.vars.gacha_effect:isSkipable() then
		return 
	end
	
	arg_188_0:setMode("skipping")
	
	arg_188_0.vars.skip_on = true
	
	Action:RemoveAll()
	
	if not arg_188_0.vars.callback_func then
		BackButtonManager:pop("GachaUnit")
	end
	
	if arg_188_0.vars.sfx_summon and get_cocos_refid(arg_188_0.vars.sfx_summon) then
		arg_188_0.vars.sfx_summon:stop()
	end
	
	if arg_188_0.vars.sfx_touch and get_cocos_refid(arg_188_0.vars.sfx_touch) then
		arg_188_0.vars.sfx_touch:stop()
	end
	
	if arg_188_0:isMultiResults() and arg_188_0:isSkipableGrade(true) == false then
		print("isMultiResults?")
		
		if arg_188_0:isSkipableGrade() then
			arg_188_0.vars.gacha_effect:requestSkip()
		else
			arg_188_0.vars.gacha_effect:requestSkip()
		end
		
		return 
	end
	
	if arg_188_0.vars.gacha_effect:isSeq1() then
		arg_188_0.vars.gacha_effect:requestSkip()
		
		return 
	end
	
	print("NOT OK")
	
	if arg_188_0:getNextGacha() == nil then
		if arg_188_0:isMultiResults() then
			if arg_188_0:isSkipableGrade() then
				arg_188_0:summaryUI()
			else
				arg_188_0.vars.gacha_effect:requestSkip()
			end
		elseif arg_188_0:isSkipableGrade() then
			arg_188_0.vars.gacha_effect:requestSkip(arg_188_0:isSkipableGrade(true) and not arg_188_0:is_new())
		else
			arg_188_0.vars.gacha_effect:requestSkip()
		end
	else
		arg_188_0:seqIntro(true, true)
		arg_188_0.vars.gacha_effect:requestSkip()
	end
end

function GachaUnit.summaryUI(arg_189_0)
	if arg_189_0.vars.ui_wnd and get_cocos_refid(arg_189_0.vars.ui_wnd) then
		arg_189_0.vars.gacha_layer:removeChild(arg_189_0.vars.ui_wnd)
	end
	
	if arg_189_0.vars.ui_wnd_top and get_cocos_refid(arg_189_0.vars.ui_wnd_top) then
		arg_189_0.vars.gacha_layer:removeChild(arg_189_0.vars.ui_wnd_top)
	end
	
	arg_189_0:cleanUpResult()
	print("summaryUI?")
	arg_189_0:setMode("summary_ui")
	arg_189_0:seqIntro(true, true)
	
	if arg_189_0.vars.gacha_effect then
		arg_189_0.vars.gacha_effect:removeCurSound()
	end
	
	GachaEffect:PlaySoundByGrade("seq2_start")
	GachaEffect:CreateBG(arg_189_0.vars.gacha_layer)
	
	arg_189_0.vars.ui_wnd = load_dlg("gacha_summary", true, "wnd")
	
	if not arg_189_0.vars.callback_func then
		BackButtonManager:push({
			check_id = "GachaUnit.summaryUI",
			back_func = function()
				GachaUnit:front()
			end
		})
	end
	
	local var_189_0 = 0
	local var_189_1 = 0
	local var_189_2 = {}
	local var_189_3 = false
	
	for iter_189_0 = 1, 10 do
		local var_189_4 = arg_189_0.vars.ui_wnd:getChildByName("n_list"):getChildByName("n_pos" .. iter_189_0)
		local var_189_5 = arg_189_0.vars.gacha_results[iter_189_0]
		
		if var_189_5 then
			if var_189_5.dupl_token then
				var_189_2[var_189_5.dupl_token.code] = (var_189_2[var_189_5.dupl_token.code] or 0) + var_189_5.dupl_token.count
			end
			
			var_189_4:setVisible(true)
			
			if var_189_5.ti == 1 then
				var_189_1 = var_189_1 + 1
			end
			
			if var_189_5.gacha_type == "character" then
				local var_189_6
				
				if var_189_5.id then
					if not var_189_6 then
						var_189_6 = UNIT:create({
							z = 6,
							code = var_189_5.code,
							exp = var_189_5.exp,
							g = var_189_5.g
						})
					end
				else
					var_189_6 = UNIT:create({
						z = 6,
						code = var_189_5.code,
						exp = var_189_5.exp,
						g = var_189_5.g
					})
				end
				
				if var_189_6 then
					local var_189_7 = UIUtil:updateGachaUnitBar(var_189_6)
					
					if_set_visible(var_189_7, "cm_icon_tmp_inven", var_189_5.ti == 1)
					if_set_visible(var_189_7, "n_obtain_token", var_189_5.dupl_token)
					
					local var_189_8 = var_189_7:getChildByName("n_obtain_token")
					
					if get_cocos_refid(var_189_8) then
						if_set_visible(var_189_8, "token_rarecoin", not var_189_6.db.moonlight)
						if_set_visible(var_189_8, "token_mooncoin", var_189_6.db.moonlight)
					end
					
					if var_189_6.inst.grade >= 4 then
						if var_189_6.db.moonlight then
							var_189_0 = var_189_0 + 1
							
							local var_189_9 = CACHE:getEffect("ui_gacha_get_moonlight_pati.cfx")
							
							var_189_9:setPosition(183, 49)
							var_189_9:update(math.random())
							var_189_9:start()
							var_189_7:getChildByName("n_effect"):addChild(var_189_9)
							
							arg_189_0.vars.result["unit_effect" .. var_189_0] = var_189_9
						else
							var_189_0 = var_189_0 + 1
							
							local var_189_10 = CACHE:getEffect("ui_gacha_get_special_pati.cfx")
							
							var_189_10:setPosition(183, 49)
							var_189_10:update(math.random())
							var_189_10:start()
							var_189_7:getChildByName("n_effect"):addChild(var_189_10)
							
							arg_189_0.vars.result["unit_effect" .. var_189_0] = var_189_10
						end
					end
					
					if var_189_6.inst.grade == 5 then
						var_189_3 = true
					end
					
					local var_189_11 = arg_189_0.vars.new_codes[var_189_5.code] == true
					
					if string.starts(arg_189_0.vars.gacha_mode, "gacha_select") and not Account:getCollectionUnit(var_189_5.code) then
						var_189_11 = true
					end
					
					if var_189_11 then
						local var_189_12 = SpriteCache:getSprite("img/gacha_new.png")
						
						var_189_12:setPosition(342, 85)
						var_189_7:addChild(var_189_12)
					end
					
					var_189_4:addChild(var_189_7)
					WidgetUtils:setupPopup({
						control = var_189_7,
						creator = function()
							return UIUtil:getCharacterPopup({
								skill_preview = false,
								z = 6,
								use_basic_star = true,
								code = var_189_5.code,
								grade = var_189_5.g,
								lv = var_189_6:getLv(),
								review_preview = string.starts(arg_189_0.vars.gacha_mode, "gacha_select")
							})
						end
					})
				end
			else
				local var_189_13
				
				if var_189_5.id then
					if not var_189_13 then
						var_189_13 = EQUIP:createByInfo(var_189_5)
					end
				else
					var_189_13 = EQUIP:createByInfo(var_189_5)
				end
				
				if var_189_13 then
					local var_189_14 = UIUtil:updateEquipBar(nil, var_189_13, {
						gacha_grade = true,
						no_tooltip = true,
						disable_slv = true,
						no_grade = true
					})
					
					if_set_visible(var_189_14, "cm_icon_tmp_inven", var_189_5.ti == 1)
					var_189_14:setPositionY(-15)
					
					if var_189_13.grade >= 4 then
						var_189_0 = var_189_0 + 1
						
						local var_189_15 = CACHE:getEffect("ui_gacha_get_artifact_pati.cfx")
						
						var_189_15:setPosition(183, 64)
						var_189_15:update(math.random())
						var_189_15:start()
						var_189_14:getChildByName("n_effect"):addChild(var_189_15)
						
						arg_189_0.vars.result["unit_effect" .. var_189_0] = var_189_15
					end
					
					local var_189_16 = arg_189_0.vars.new_codes[var_189_5.code] == true
					
					if string.starts(arg_189_0.vars.gacha_mode, "gacha_select") and not Account:getCollectionEquip(var_189_5.code) then
						var_189_16 = true
					end
					
					if var_189_16 then
						local var_189_17 = SpriteCache:getSprite("img/gacha_new.png")
						
						var_189_17:setPosition(342, 85)
						var_189_14:addChild(var_189_17)
					end
					
					var_189_4:addChild(var_189_14)
					WidgetUtils:setupPopup({
						control = var_189_14,
						creator = function()
							return ItemTooltip:getItemTooltip({
								show_max_check_box = true,
								artifact_popup = true,
								code = var_189_5.code,
								grade = var_189_5.g,
								equip = var_189_13,
								equip_stat = var_189_13.stats
							})
						end
					})
				end
			end
		else
			var_189_4:setVisible(true)
		end
	end
	
	if_set_visible(arg_189_0.vars.ui_wnd, "n_temp_msg", var_189_1 > 0)
	
	var_189_3 = var_189_3 and IS_PUBLISHER_ZLONG
	var_189_3 = var_189_3 and not ContentDisable:byAlias("gacha_result_share")
	
	if_set_visible(arg_189_0.vars.ui_wnd, "n_btn_share_zl", var_189_3)
	
	local var_189_18 = to_n(var_189_2.rarecoin)
	local var_189_19 = to_n(var_189_2.mooncoin)
	
	if var_189_18 + var_189_19 > 0 then
		local var_189_20 = arg_189_0.vars.ui_wnd:getChildByName("n_obtain_token_count")
		
		if get_cocos_refid(var_189_20) then
			var_189_20:setVisible(true)
			
			local var_189_21 = var_189_20:getChildByName("n_token01")
			local var_189_22 = var_189_20:getChildByName("n_token02")
			
			if_set_visible(var_189_21, "t_count", false)
			if_set_visible(var_189_22, "t_count", false)
			
			if var_189_18 > 0 and var_189_19 > 0 then
				var_189_21:setVisible(true)
				var_189_22:setVisible(true)
				UIUtil:getRewardIcon(nil, "to_rarecoin", {
					no_bg = true,
					parent = var_189_21:getChildByName("n_token")
				})
				if_set(var_189_21, "t_count", var_189_18)
				UIUtil:getRewardIcon(nil, "to_mooncoin", {
					no_bg = true,
					parent = var_189_22:getChildByName("n_token")
				})
				if_set(var_189_22, "t_count", var_189_19)
			elseif var_189_18 > 0 then
				var_189_21:setVisible(true)
				var_189_22:setVisible(false)
				UIUtil:getRewardIcon(nil, "to_rarecoin", {
					no_bg = true,
					parent = var_189_21:getChildByName("n_token")
				})
				if_set(var_189_21, "t_count", var_189_18)
			elseif var_189_19 > 0 then
				var_189_21:setVisible(false)
				var_189_22:setPositionX(var_189_21:getPositionX())
				var_189_22:setVisible(true)
				UIUtil:getRewardIcon(nil, "to_mooncoin", {
					no_bg = true,
					parent = var_189_22:getChildByName("n_token")
				})
				if_set(var_189_22, "t_count", var_189_19)
			end
		end
	else
		if_set_visible(arg_189_0.vars.ui_wnd, "n_obtain_token_count", false)
	end
	
	local var_189_23 = Account:getGachaShopInfo()
	local var_189_24 = arg_189_0.vars.ui_wnd:getChildByName("n_buttons")
	
	if string.starts(arg_189_0.vars.gacha_mode, "gacha_select") then
		local var_189_25 = string.split(arg_189_0.vars.gacha_mode, "gacha_select:")[2]
		local var_189_26 = var_189_23.select_list[var_189_25]
		local var_189_27 = var_189_23.select_list["saved_" .. var_189_25]
		
		if_set_visible(var_189_24, "n_normal", false)
		if_set_visible(var_189_24, "n_select", true)
		
		local var_189_28 = var_189_24:getChildByName("n_select")
		local var_189_29 = var_189_28:getChildByName("btn_select_confirm")
		local var_189_30 = var_189_28:getChildByName("btn_select_retry")
		
		TutorialGuide:startGuide("summon_select")
	else
		if_set_visible(var_189_24, "n_normal", true)
		if_set_visible(var_189_24, "n_select", false)
		if_set_visible(var_189_24, "btn_summon_r1", false)
		
		local var_189_31 = var_189_24:getChildByName("btn_summon_r1")
		
		arg_189_0:setRetryButton(var_189_31)
	end
	
	arg_189_0.vars.gacha_layer:addChild(arg_189_0.vars.ui_wnd, 100)
	
	arg_189_0.vars.sfx_summary_loop = SoundEngine:play("event:/ui/gacha/summon_loop")
end

function GachaUnit.getFreeGachaEventCount(arg_193_0, arg_193_1, arg_193_2)
	local var_193_0 = 0
	local var_193_1 = 0
	local var_193_2 = os.time()
	
	arg_193_1 = arg_193_1 or "gacha_rare_free_1"
	arg_193_2 = arg_193_2 or "gl:gachafree_daily"
	
	local var_193_3
	local var_193_4 = Account:getGachaShopInfo()
	
	if var_193_4 and var_193_4.free_ticket then
		var_193_3 = var_193_4.free_ticket[arg_193_1]
	end
	
	if var_193_3 and var_193_3.intelli_option then
		local var_193_5 = Account:getTicketedLimit("gl:" .. var_193_3.intelli_option)
		
		if var_193_5 and var_193_2 >= to_n(var_193_5.usable_tm) and var_193_2 <= to_n(var_193_5.buyable_tm) then
			var_193_0 = to_n(var_193_5.count)
			var_193_1 = to_n(var_193_5.max_c)
		end
	end
	
	local var_193_6 = Account:getTicketedLimit(arg_193_2)
	
	if var_193_6 and var_193_2 <= to_n(var_193_6.buyable_tm) and to_n(var_193_6.count) < to_n(var_193_6.max_c) then
		var_193_0 = var_193_0 + to_n(var_193_6.count)
		var_193_1 = var_193_1 + to_n(var_193_6.max_c)
	end
	
	return var_193_0, var_193_1
end

function GachaUnit.getFreeGachaBonusCount(arg_194_0, arg_194_1)
	local var_194_0 = 0
	local var_194_1 = 0
	local var_194_2 = os.time()
	
	arg_194_1 = arg_194_1 or {
		"gl:gachafree_daily",
		"gl:gachafree_daily_ml"
	}
	
	for iter_194_0, iter_194_1 in pairs(arg_194_1) do
		local var_194_3 = Account:getTicketedLimit(iter_194_1)
		
		if var_194_3 and var_194_2 <= to_n(var_194_3.buyable_tm) and to_n(var_194_3.count) < to_n(var_194_3.max_c) then
			var_194_0 = var_194_0 + to_n(var_194_3.count)
			var_194_1 = var_194_1 + to_n(var_194_3.max_c)
		end
	end
	
	return var_194_0, var_194_1
end

function GachaUnit.getCeilingData(arg_195_0, arg_195_1)
	local var_195_0 = Account:getGachaShopInfo()
	local var_195_1
	local var_195_2
	local var_195_3
	local var_195_4
	local var_195_5
	local var_195_6 = 0
	local var_195_7 = 5
	local var_195_8
	local var_195_9
	local var_195_10
	local var_195_11
	local var_195_15
	
	if arg_195_1 == "gacha_special" then
		local var_195_12 = var_195_0.gacha_special.current
		
		if to_n(var_195_12.gs_grade or 5) == 4 then
			var_195_2 = var_195_12.ceiling_character_cm4
			var_195_4 = var_195_12.ceiling_count_cm4
			var_195_5 = var_195_12.ceiling_group_cm4
			var_195_7 = 4
			var_195_8 = "ui_gacha_special_ceiling_remain_cm4"
			var_195_9 = "ui_gacha_special_ceiling_complete_cm4"
			var_195_10 = "ui_gacha_result_progress_special_remain_cm4"
			var_195_11 = "ui_gacha_result_progress_special_complete_cm4"
		else
			var_195_2 = var_195_12.ceiling_character
			var_195_4 = var_195_12.ceiling_count
			var_195_5 = var_195_12.ceiling_group
			var_195_8 = "ui_gacha_special_ceiling_remain"
			var_195_9 = "ui_gacha_special_ceiling_complete"
			var_195_10 = "ui_gacha_result_progress_special_remain_cm5"
			var_195_11 = "ui_gacha_result_progress_special_complete_cm5"
		end
		
		var_195_3 = var_195_12.portraits[var_195_2]
		
		if var_195_0.pickup_ceiling then
			local var_195_13 = var_195_0.pickup_ceiling[var_195_5]
			
			if var_195_13 then
				var_195_6 = var_195_13.current
			end
		end
	elseif arg_195_1 == "gacha_substory" then
		pickup_data = var_195_0.gacha_substory
		var_195_2 = pickup_data.ceiling_character
		var_195_4 = pickup_data.ceiling_count
		
		if var_195_0.pickup_ceiling then
			local var_195_14 = var_195_0.pickup_ceiling[pickup_data.gacha_id]
			
			if var_195_14 then
				var_195_6 = var_195_14.current
			end
		end
		
		var_195_8 = "ui_gacha_pickup_ceiling_remain"
		var_195_9 = "ui_gacha_pickup_ceiling_complete"
		var_195_10 = "ui_gacha_result_progress_limit_remain"
		var_195_11 = "ui_gacha_result_progress_limit_complete"
	else
		var_195_15 = nil
		
		for iter_195_0, iter_195_1 in pairs(var_195_0.pickup) do
			if iter_195_1.gacha_id == arg_195_1 then
				var_195_15 = iter_195_1
				var_195_1 = var_195_15.name
			end
			
			if var_195_15 then
				var_195_2 = var_195_15.ceiling_character
				var_195_4 = var_195_15.ceiling_count
				
				if var_195_0.pickup_ceiling then
					local var_195_16 = var_195_0.pickup_ceiling[var_195_15.gacha_id]
					
					if var_195_16 then
						var_195_6 = var_195_16.current
					end
				end
				
				var_195_8 = "ui_gacha_pickup_ceiling_remain"
				var_195_9 = "ui_gacha_pickup_ceiling_complete"
				var_195_10 = "ui_gacha_result_progress_limit_remain"
				var_195_11 = "ui_gacha_result_progress_limit_complete"
				
				break
			end
		end
	end
	
	return {
		gacha_title = var_195_1,
		ceiling_character = var_195_2,
		ceiling_count = var_195_4,
		ceiling_current = var_195_6,
		ceiling_grade = var_195_7,
		ceiling_portrait_data = var_195_3,
		ceiling_text = var_195_8,
		ceiling_text_full = var_195_9,
		ceiling_text_retry = var_195_10,
		ceiling_text_full_retry = var_195_11
	}
end

function GachaUnit.setRetryButton(arg_196_0, arg_196_1)
	local var_196_0 = Account:getGachaShopInfo()
	
	arg_196_0.vars.last_buy_item = arg_196_0.vars.last_buy_item or "gacha_rare_1"
	
	if arg_196_0.vars.last_buy_item == var_196_0.free_ticket.gacha_rare_free_1.id then
		arg_196_0.vars.last_buy_item = "gacha_rare_1"
	elseif arg_196_0.vars.last_buy_item == var_196_0.free_ticket.gacha_ml_free_1.id then
		arg_196_0.vars.last_buy_item = "gacha_moonlight"
	end
	
	local var_196_1 = arg_196_0.vars.last_gacha_count or 1
	local var_196_2 = var_196_0.gacha[arg_196_0.vars.last_buy_item]
	local var_196_3 = arg_196_0:getCeilingData(arg_196_0.vars.last_buy_item)
	local var_196_4 = var_196_3.gacha_title or var_196_2.gacha_title
	local var_196_5 = var_196_3.ceiling_character
	local var_196_6 = var_196_3.ceiling_count
	local var_196_7 = var_196_3.ceiling_current
	local var_196_8 = var_196_3.ceiling_text_retry
	local var_196_9 = var_196_3.ceiling_text_full_retry
	local var_196_10
	
	for iter_196_0, iter_196_1 in pairs(arg_196_0.vars.pickup_list) do
		if iter_196_1.gacha_id == arg_196_0.vars.last_buy_item then
			var_196_10 = iter_196_1
			
			break
		end
	end
	
	if arg_196_0.vars.last_buy_item == "gacha_normal" then
		local var_196_11 = Account:getCurrency("ticketnormal")
		local var_196_12 = var_196_2.price
		
		for iter_196_2 = 1, 10 do
			if var_196_11 < var_196_2.price * iter_196_2 then
				break
			end
			
			var_196_12 = var_196_2.price * iter_196_2
		end
		
		if_set(arg_196_1, "cost", var_196_12)
		if_set_visible(arg_196_1, "icon_res", true)
		if_set_sprite(arg_196_1, "icon_res", "item/" .. DB("item_token", "to_ticketnormal", {
			"icon"
		}) .. ".png")
		arg_196_1:setVisible(true)
	elseif arg_196_0.vars.last_buy_item == "gacha_start" then
		if_set_visible(arg_196_1, "icon_res", false)
		
		local var_196_13 = Account:getTicketedLimit("gl:gacha_start")
		
		if var_196_13 then
			local var_196_14 = to_n(var_196_13.max_c) - to_n(var_196_13.count)
			
			if_set(arg_196_1, "cost", var_196_14 .. "/" .. to_n(var_196_13.max_c))
		else
			if_set_visible(arg_196_1, "cost", false)
		end
	elseif string.starts(arg_196_0.vars.last_buy_item, "gacha_story") or arg_196_0.vars.last_buy_item == "gacha_spdash" then
		if_set_visible(arg_196_1, "icon_res", false)
		
		local var_196_15 = Account:getTicketedLimit("gl:" .. var_196_2.id)
		
		if var_196_15 then
			local var_196_16 = to_n(var_196_15.max_c) - to_n(var_196_15.count)
			
			if_set(arg_196_1, "cost", var_196_16 .. "/" .. to_n(var_196_15.max_c))
		else
			if_set_visible(arg_196_1, "cost", false)
		end
	elseif arg_196_0.vars.last_buy_item == "gacha_moonlight" and arg_196_0:isMoonlightBonus() then
		arg_196_1:setVisible(true)
	else
		local var_196_17
		
		if var_196_10 then
			var_196_17 = var_196_10.id
		end
		
		if var_196_17 then
			local var_196_18 = arg_196_0:getEventToken(var_196_17)
			
			if var_196_18 and var_196_18 and Account:getCurrency(var_196_18.token) >= to_n(var_196_18.price) * var_196_1 then
				var_196_2 = var_196_18
			end
		end
		
		local var_196_19 = var_196_2.price * var_196_1
		
		if_set(arg_196_1, "cost", var_196_19)
		if_set_visible(arg_196_1, "icon_res", true)
		if_set_sprite(arg_196_1, "icon_res", "item/" .. DB("item_token", var_196_2.token, {
			"icon"
		}) .. ".png")
		arg_196_1:setVisible(true)
	end
	
	if arg_196_0.vars.last_buy_item == "gacha_customgroup" then
		if_set_visible(arg_196_1, "n_balloon_gp", true)
		if_set_visible(arg_196_1, "n_balloon", false)
		
		local var_196_20 = arg_196_1:getChildByName("n_balloon_gp")
		
		if get_cocos_refid(var_196_20) then
			local var_196_21 = var_196_20:getChildByName("n_group_coin")
			
			UIUtil:getRewardIcon(nil, "to_gpmileage1", {
				scale = 0.6,
				y = 55,
				no_bg = true,
				x = 40,
				parent = var_196_21
			})
			if_set(var_196_20, "txt_gpcoin_count", comma_value(to_n(Account:getCurrency("to_gpmileage1"))))
			
			if var_196_4 then
				if_set(var_196_20, "txt", T("ui_gacha_result_progress_group", {
					gacha_title = T(var_196_4)
				}))
			end
		end
	elseif arg_196_0.vars.last_buy_item == "gacha_customspecial" then
		if_set_visible(arg_196_1, "n_balloon_gp", true)
		if_set_visible(arg_196_1, "n_balloon", false)
		
		local var_196_22 = arg_196_1:getChildByName("n_balloon_gp")
		
		if get_cocos_refid(var_196_22) then
			local var_196_23 = var_196_22:getChildByName("n_group_coin")
			
			UIUtil:getRewardIcon(nil, "to_gpmileage2", {
				scale = 0.6,
				y = 55,
				no_bg = true,
				x = 40,
				parent = var_196_23
			})
			if_set(var_196_22, "txt_gpcoin_count", comma_value(to_n(Account:getCurrency("to_gpmileage2"))))
			
			if var_196_4 then
				if_set(var_196_22, "txt", T("ui_gacha_result_progress_group", {
					gacha_title = T(var_196_4)
				}))
			end
		end
	else
		if_set_visible(arg_196_1, "n_balloon_gp", false)
		
		local var_196_24 = arg_196_1:getChildByName("n_balloon")
		
		if get_cocos_refid(var_196_24) then
			if var_196_2 and var_196_4 then
				if tolua:type(var_196_24:getChildByName("txt")) ~= "ccui.RichText" then
					upgradeLabelToRichLabel(var_196_24, "txt", true)
				end
				
				local var_196_25 = var_196_24:getChildByName("txt")
				
				if get_cocos_refid(var_196_25) then
					local var_196_26 = ""
					
					if arg_196_0.vars.last_buy_item == "gacha_moonlight" then
						var_196_26 = arg_196_0:getMoonlightBonusCountText(true)
						
						local var_196_27, var_196_28 = arg_196_0:getFreeGachaEventCount("gacha_ml_free_1", "gl:gachafree_daily_ml")
						
						if var_196_27 and var_196_28 and var_196_27 < var_196_28 then
							if_set(arg_196_1, "cost", T("shop_price_free"))
						end
					elseif var_196_5 and var_196_6 and to_n(var_196_6) > 0 then
						local var_196_29 = to_n(var_196_6) - to_n(var_196_7)
						local var_196_30 = DB("character", var_196_5, {
							"name"
						})
						
						if var_196_29 == 0 then
							var_196_26 = T(var_196_9, {
								gacha_title = T(var_196_4),
								character_name = T(var_196_30)
							})
						else
							var_196_26 = T(var_196_8, {
								gacha_title = T(var_196_4),
								character_name = T(var_196_30),
								count = var_196_29
							})
						end
					else
						var_196_26 = T("ui_gacha_result_progress_normal", {
							gacha_title = T(var_196_4)
						})
						
						if arg_196_0.vars.last_buy_item == "gacha_rare_1" then
							local var_196_31, var_196_32 = arg_196_0:getFreeGachaEventCount()
							
							if var_196_31 and var_196_32 and var_196_31 < var_196_32 then
								if var_196_32 - var_196_31 >= 10 and arg_196_0.vars.last_gacha_count == 10 then
									var_196_26 = T("ui_gacha_result_progress_normal_free10", {
										gacha_title = T(var_196_4),
										curr = var_196_32 - var_196_31,
										max = var_196_32
									})
									
									if_set(arg_196_1, "cost", T("shop_price_free"))
								elseif arg_196_0.vars.last_gacha_count == 1 then
									var_196_26 = T("ui_gacha_result_progress_normal_free", {
										gacha_title = T(var_196_4),
										curr = var_196_32 - var_196_31,
										max = var_196_32
									})
									
									if_set(arg_196_1, "cost", T("shop_price_free"))
								end
							end
						end
					end
					
					if_set(var_196_25, nil, var_196_26)
					
					local var_196_33 = var_196_24:findChildByName("talk_small_bg")
					local var_196_34 = var_196_25:getTextBoxSize()
					
					var_196_34.width = var_196_34.width * var_196_25:getScaleX()
					var_196_34.height = var_196_34.height * var_196_25:getScaleY()
					
					local var_196_35 = var_196_33:getContentSize().width
					
					var_196_34.width = var_196_35 > var_196_34.width and var_196_34.width + 35 or var_196_35
					
					var_196_33:setContentSize({
						width = var_196_34.width,
						height = var_196_34.height + 30
					})
				end
				
				var_196_24:setVisible(true)
			else
				var_196_24:setVisible(false)
			end
		end
	end
end

function GachaUnit.close(arg_197_0)
	local var_197_0 = SceneManager:getCurrentSceneName()
	
	if var_197_0 == "gacha_unit" and (arg_197_0.vars.gacha_mode == "gacha_start" or string.starts(arg_197_0.vars.gacha_mode, "gacha_story")) then
		arg_197_0:front()
		
		return 
	end
	
	if not arg_197_0.vars.callback_func and var_197_0 ~= "gacha_unit" then
		UnitSummonResult:close()
		
		return 
	end
	
	DevoteTooltip:close()
	HeroRecommend:close()
	arg_197_0.vars.layer:removeChild(arg_197_0.vars.gacha_layer)
	
	local var_197_1 = arg_197_0.vars.layer:getChildByName("block_btn")
	
	if var_197_1 then
		arg_197_0.vars.layer:removeChild(var_197_1)
	end
	
	if arg_197_0.vars.callback_func then
		arg_197_0.vars.callback_func()
	end
end

function GachaUnit.closeCharacterIntroStory(arg_198_0)
	if not arg_198_0.vars or not arg_198_0.vars.code then
		return 
	end
	
	if arg_198_0.vars.voc_player and arg_198_0.vars.voc_player:tryStop() == false then
		return 
	end
	
	if not arg_198_0:is_new() then
		return 
	end
	
	if not arg_198_0.vars.new_codes or table.count(arg_198_0.vars.new_codes) == 0 or string.starts(arg_198_0.vars.gacha_mode, "gacha_select") then
		return 
	end
	
	arg_198_0.vars.voc_player = nil
	
	if get_cocos_refid(arg_198_0.vars.ui_gacha_story) then
		arg_198_0.vars.gacha_layer:removeChild(arg_198_0.vars.ui_gacha_story)
		
		arg_198_0.vars.ui_gacha_story = nil
	end
	
	if arg_198_0:isTutorialMode() then
		TutorialGuide:startGuide("summon_hero")
	end
end

function GachaUnit.characterIntroStory(arg_199_0)
	if not arg_199_0.vars or not arg_199_0.vars.code then
		return 
	end
	
	if arg_199_0.vars.voc_player and arg_199_0.vars.voc_player:tryStop() == false then
		return 
	end
	
	if not arg_199_0:is_new() then
		return 
	end
	
	if not arg_199_0.vars.new_codes or table.count(arg_199_0.vars.new_codes) == 0 or string.starts(arg_199_0.vars.gacha_mode, "gacha_select") then
		return 
	end
	
	if not get_cocos_refid(arg_199_0.vars.ui_gacha_story) then
		arg_199_0.vars.ui_gacha_story = load_dlg("gacha_story", true, "wnd")
		
		function HANDLER.gacha_story(arg_200_0, arg_200_1)
			if arg_200_1 == "btn_next_nosound" then
				GachaUnit:closeCharacterIntroStory()
			end
		end
		
		arg_199_0.vars.gacha_layer:addChild(arg_199_0.vars.ui_gacha_story, 100)
	end
	
	local var_199_0, var_199_1, var_199_2, var_199_3 = DB("character", arg_199_0.vars.code, {
		"face_id",
		"model_id",
		"name",
		"gacha_get"
	})
	
	if_set_visible(arg_199_0.vars.ui_gacha_story, "n_portrait", false)
	if_set_visible(arg_199_0.vars.ui_gacha_story, "vignetting", false)
	
	local var_199_4 = arg_199_0.vars.ui_gacha_story:getChildByName("n_talk")
	
	if_set(var_199_4, "txt_name", T(var_199_2))
	if_set(var_199_4, "txt_info", T(var_199_3))
	
	local var_199_5 = arg_199_0.vars.ui_gacha_story:getChildByName("n_cursor")
	
	if get_cocos_refid(var_199_5) then
		local var_199_6 = string.format("event:/voc/character/%s/evt/get", var_199_1)
		
		arg_199_0.vars.voc_player = UIHelper:playTalkVoice(var_199_6, var_199_5, var_199_5:getChildByName("move_updown"))
	end
end

function GachaUnit.showPreviousSelectGachaInfo(arg_201_0)
	local var_201_0 = Account:getGachaShopInfo()
	local var_201_1 = string.split(arg_201_0.vars.gacha_mode, "gacha_select:")[2]
	local var_201_2 = var_201_0.select_list[var_201_1]
	local var_201_3 = var_201_0.select_list["saved_" .. var_201_1]
	
	if not var_201_0 or not var_201_2 or not var_201_2.previous then
		return 
	end
	
	arg_201_0.vars.gacha_results = {}
	
	local var_201_4 = {}
	
	for iter_201_0, iter_201_1 in pairs(var_201_2.previous) do
		if string.starts(iter_201_1.code, "c") then
			if not Account:getCollectionUnit(iter_201_1.code) then
				var_201_4[iter_201_1.code] = true
			end
			
			table.push(arg_201_0.vars.gacha_results, {
				exp = 0,
				id = 0,
				gacha_type = "character",
				code = iter_201_1.code,
				g = iter_201_1.g,
				new = var_201_4[iter_201_1.code] == true
			})
		elseif string.starts(iter_201_1.code, "e") then
			if not Account:getCollectionEquip(iter_201_1.code) then
				var_201_4[iter_201_1.code] = true
			end
			
			table.push(arg_201_0.vars.gacha_results, {
				exp = 0,
				id = 0,
				gacha_type = "equip",
				code = iter_201_1.code,
				g = iter_201_1.g,
				new = var_201_4[iter_201_1.code] == true
			})
		end
	end
	
	arg_201_0.vars.new_codes = var_201_4
	
	arg_201_0:summaryUI()
end

function GachaUnit.savedSelectGacha(arg_202_0, arg_202_1)
	if not arg_202_1 or not arg_202_1.gacha_shop_info then
		return 
	end
	
	if arg_202_1.gacha_shop_info then
		AccountData.gacha_shop_info = arg_202_1.gacha_shop_info
	end
	
	if arg_202_0.vars and get_cocos_refid(arg_202_0.vars.ui_wnd) then
		local var_202_0 = arg_202_0.vars.ui_wnd:getChildByName("n_buttons")
		
		if var_202_0 then
			local var_202_1 = var_202_0:getChildByName("n_select")
			
			if_set_opacity(var_202_1, "btn_record", 76.5)
		end
	end
	
	local var_202_2 = Dialog:msgBox(T("gacha_select_recorded_desc"), {
		title = T("gacha_select_recorded_title")
	}):getChildByName("text")
	
	if get_cocos_refid(var_202_2) then
		var_202_2:setPositionY(var_202_2:getPositionY() + 10)
	end
end

function GachaUnit.showSelectGachaInfo(arg_203_0, arg_203_1)
	if not arg_203_1 or not arg_203_1.info then
		return 
	end
	
	if arg_203_1.gacha_shop_info then
		AccountData.gacha_shop_info = arg_203_1.gacha_shop_info
	end
	
	if arg_203_1.info.gacha_results and #arg_203_1.info.gacha_results > 0 then
		local var_203_0 = arg_203_1.info.gacha_results
		local var_203_1 = {}
		
		for iter_203_0, iter_203_1 in pairs(var_203_0) do
			if iter_203_1.gacha_type == "character" then
				if not Account:getCollectionUnit(iter_203_1.code) then
					var_203_1[iter_203_1.code] = true
				end
				
				iter_203_1.new = var_203_1[iter_203_1.code] ~= nil
			elseif iter_203_1.gacha_type == "equip" then
				if not Account:getCollectionEquip(iter_203_1.code) then
					var_203_1[iter_203_1.code] = true
				end
				
				iter_203_1.new = var_203_1[iter_203_1.code] ~= nil
			end
		end
		
		arg_203_0.vars.last_buy_item = nil
		
		GachaUnit:seqIntroBookTouchWait(var_203_0, var_203_1)
	else
		balloon_message_with_sound("gacha_err")
	end
end

function GachaUnit.test(arg_204_0)
	arg_204_0.vars.new_codes = {}
	arg_204_0.vars.gacha_results = {
		{
			g = 5,
			exp = 1165,
			ti = 1,
			id = 11726397,
			code = "c1016",
			gacha_type = "character",
			dupl_token = {
				code = "rarecoin",
				count = 8,
				unit_code = "c1016"
			}
		},
		{
			g = 3,
			exp = 1165,
			id = 11726398,
			code = "c3023",
			gacha_type = "character"
		},
		{
			g = 4,
			exp = 1165,
			id = 111726402,
			code = "ef314",
			gacha_type = "equip",
			op = {
				{
					"att",
					8
				},
				{
					"max_hp",
					16
				}
			}
		},
		{
			g = 5,
			exp = 1230,
			id = 11726399,
			code = "c1016",
			gacha_type = "character",
			dupl_token = {
				code = "rarecoin",
				count = 8,
				unit_code = "c1016"
			}
		},
		{
			g = 5,
			exp = 1165,
			id = 11726400,
			code = "c2082",
			gacha_type = "character",
			dupl_token = {
				code = "mooncoin",
				count = 10,
				unit_code = "c2082"
			}
		},
		{
			g = 4,
			exp = 1165,
			id = 11726400,
			code = "c2004",
			gacha_type = "character"
		},
		{
			g = 3,
			exp = 1165,
			id = 11726400,
			code = "c1018",
			gacha_type = "character"
		},
		{
			g = 4,
			exp = 1165,
			id = 11726401,
			code = "c2062",
			gacha_type = "character"
		},
		{
			g = 5,
			exp = 1165,
			ti = 1,
			id = 111726402,
			code = "efw11",
			gacha_type = "equip",
			op = {
				{
					"att",
					8
				},
				{
					"max_hp",
					16
				}
			}
		},
		{
			g = 3,
			exp = 1165,
			id = 11726403,
			code = "c3044",
			gacha_type = "character"
		}
	}
	
	arg_204_0:summaryUI()
end

function GachaUnit._showCharGet(arg_205_0, arg_205_1, arg_205_2, arg_205_3, arg_205_4)
	arg_205_4 = arg_205_4 or {}
	
	local var_205_0 = arg_205_0:playBanner(arg_205_2, arg_205_4)
	
	arg_205_0.vars.close_callback = arg_205_3
	arg_205_0.vars.gacha_type = "character"
	arg_205_0.vars.code = arg_205_1
	
	if not arg_205_4.unit then
		local var_205_1 = DB("character", arg_205_1, "grade")
		
		arg_205_0.vars.unit = UNIT:create({
			exp = 0,
			z = 6,
			code = arg_205_1,
			g = var_205_1
		})
	end
	
	arg_205_0.vars.portrait = UIUtil:getPortraitAni(DB("character", arg_205_0.vars.code, "face_id"))
	
	if arg_205_0.vars.portrait then
		arg_205_0.vars.portrait:setAnchorPoint(0.5, 0)
		arg_205_0.vars.portrait:setPosition(to_n(arg_205_4.x_offset), -100)
		var_205_0:getChildByName("n_portrait"):addChild(arg_205_0.vars.portrait)
	end
	
	if arg_205_4.is_summon then
		SoundEngine:play("event:/ui/gacha/guardian_get")
	end
end

function GachaUnit.playBanner(arg_206_0, arg_206_1, arg_206_2)
	local var_206_0 = arg_206_2 or {}
	local var_206_1 = to_n(var_206_0.delay)
	local var_206_2 = arg_206_1 or SceneManager:getDefaultLayer()
	local var_206_3 = load_dlg("gacha_result", true, "wnd")
	
	if not arg_206_0.vars.gacha_layer then
		arg_206_0.vars.gacha_layer = var_206_3
	end
	
	var_206_2:addChild(var_206_3)
	var_206_3:setLocalZOrder(var_206_0.z or 1000000000)
	
	if var_206_0.no_bg then
		if_set_visible(var_206_3, "n_bg", false)
	end
	
	if var_206_0.bg then
		local var_206_4 = var_206_3:getChildByName("n_bg")
		
		var_206_4:removeAllChildren()
		
		local var_206_5 = cc.Sprite:create(var_206_0.bg)
		
		var_206_5:setPosition(DESIGN_WIDTH / 2, DESIGN_HEIGHT / 2)
		var_206_4:addChild(var_206_5)
		
		local var_206_6 = var_206_5:getContentSize()
		
		var_206_5:setScaleX(VIEW_WIDTH / var_206_6.width)
		var_206_5:setScaleY(VIEW_HEIGHT / var_206_6.height)
	end
	
	if var_206_0.z then
		var_206_3:setLocalZOrder(var_206_0.z)
	end
	
	if var_206_1 > 0 then
		var_206_3:setVisible(false)
		Action:Add(SEQ(DELAY(var_206_1), SHOW(true)), var_206_3, "block")
	end
	
	if var_206_0.sprite_type then
		local var_206_7 = var_206_3:getChildByName("n_banner_top")
		local var_206_8 = var_206_3:getChildByName("n_banner_bottom")
		
		if var_206_0.sprite_type == 2 then
			if_set_sprite(var_206_7, "Sprite_1", "img/gacha_get_bg1_1.png")
			if_set_sprite(var_206_8, "Sprite_2", "img/gacha_get_bg2_1.png")
		elseif var_206_0.sprite_type == 3 then
			if_set_sprite(var_206_7, "Sprite_1", "img/gacha_get_bg1_2.png")
			if_set_sprite(var_206_8, "Sprite_2", "img/gacha_get_bg2_2.png")
		else
			if_set_sprite(var_206_7, "Sprite_1", "img/gacha_get_bg1.png")
			if_set_sprite(var_206_8, "Sprite_2", "img/gacha_get_bg2.png")
		end
	end
	
	Action:Add(SEQ(DELAY(var_206_1), LOG(SPAWN(ROTATE(220, -50, 0), MOVE_TO(220, VIEW_BASE_LEFT - 1)))), var_206_3:getChildByName("n_banner_top"), "block")
	Action:Add(SEQ(DELAY(var_206_1), LOG(SPAWN(ROTATE(220, -50, 0), MOVE_TO(220, VIEW_BASE_RIGHT + 1)))), var_206_3:getChildByName("n_banner_bottom"), "block")
	
	return var_206_3
end

function GachaUnit.ShowCharGet(arg_207_0, arg_207_1, arg_207_2, arg_207_3, arg_207_4)
end

function GachaUnit.onLeave(arg_208_0)
	if arg_208_0.vars and arg_208_0.vars.sfx_summary_loop and get_cocos_refid(arg_208_0.vars.sfx_summary_loop) then
		arg_208_0.vars.sfx_summary_loop:stop()
	end
	
	GachaIntroduceBG:closeWithSound()
end

function GachaUnit.setTitle(arg_209_0, arg_209_1, arg_209_2, arg_209_3, arg_209_4)
	if arg_209_2 == nil or arg_209_3 == nil then
		return 
	end
	
	if not arg_209_4 then
		arg_209_4 = {}
		arg_209_4.limit, arg_209_4.artifact, arg_209_4.left_character, arg_209_4.right_character, arg_209_4.title_data = DB("gacha_ui", arg_209_2, {
			"limit",
			"aritfact",
			"left_character",
			"right_character",
			"title_data"
		})
	end
	
	local var_209_0 = arg_209_0:setTitleUI(arg_209_1, arg_209_4.limit, arg_209_4.artifact, arg_209_4.title_data)
	
	if arg_209_3.title_data then
		arg_209_4.title_data = arg_209_3.title_data
	end
	
	if var_209_0 == nil then
		return 
	end
	
	local var_209_1
	local var_209_2
	local var_209_3
	local var_209_4
	
	if arg_209_4.left_character then
		var_209_1, var_209_2, var_209_3, var_209_4 = DB("character", arg_209_4.left_character, {
			"name",
			"role",
			"grade",
			"ch_attribute"
		})
		
		if_set(var_209_0, "txt_role", T("ui_hero_role_" .. DB("character", arg_209_4.left_character, "role")))
	elseif arg_209_4.right_character then
		var_209_1, var_209_2, var_209_3, var_209_4 = DB("character", arg_209_4.right_character, {
			"name",
			"role",
			"grade",
			"ch_attribute"
		})
		
		if_set(var_209_0, "txt_role", T("ui_hero_role_" .. DB("character", arg_209_4.right_character, "role")))
	end
	
	if_set(var_209_0, "txt_cha", T(var_209_1))
	if_set(var_209_0, "txt_element", T("hero_ele_" .. tostring(var_209_4)))
	
	local var_209_5 = var_209_0:getChildByName("txt_element")
	
	arg_209_0:setStarPosition(var_209_0, var_209_5)
	
	local var_209_6 = var_209_0:getChildByName("txt_role")
	
	arg_209_0:setroleIconPosition(var_209_0, var_209_6)
	if_set_sprite(var_209_0, "icon_role", "img/cm_icon_role_" .. tostring(var_209_2) .. ".png")
	if_set_sprite(var_209_0, "icon_element", "img/cm_icon_pro" .. tostring(var_209_4) .. ".png")
	
	local var_209_7
	local var_209_8
	local var_209_9
	local var_209_10
	
	if arg_209_4.artifact ~= nil then
		local var_209_11, var_209_12, var_209_13
		
		var_209_11, var_209_8, var_209_12, var_209_13 = DB("equip_item", arg_209_4.artifact, {
			"name",
			"artifact_grade",
			"icon",
			"role"
		})
		
		local var_209_14 = var_209_0:getChildByName("gacha_title_arti")
		
		if_set(var_209_14, "txt_role", T(var_209_11))
		if_set_sprite(var_209_14, "icon_arti", "item_arti/" .. tostring(var_209_12) .. ".png")
		if_set_sprite(var_209_14, "icon_role", "img/cm_icon_role_" .. tostring(var_209_13) .. ".png")
	end
	
	arg_209_0:setStarNum(var_209_0, var_209_3, var_209_8)
	
	local var_209_15 = string.split(arg_209_4.title_data, ";")
	
	var_209_0:setPosition(var_209_15[2], var_209_15[3])
	
	if getUserLanguage() == "ko" or getUserLanguage() == "zht" then
		local var_209_16 = var_209_0:getChildByName("n_info")
		
		if var_209_16 ~= nil then
			var_209_16:setPositionX(var_209_15[2] - 30)
			var_209_16:setPositionX(var_209_15[2] - 105)
		end
	end
end

function GachaUnit.setStarNum(arg_210_0, arg_210_1, arg_210_2, arg_210_3)
	local var_210_0 = arg_210_1:getChildByName("gacha_title_bg"):getChildByName("star1")
	
	for iter_210_0 = 1, 6 do
		if_set_visible(var_210_0, "star" .. iter_210_0, iter_210_0 <= arg_210_2)
	end
	
	local var_210_1
	
	if arg_210_3 ~= nil then
		var_210_1 = arg_210_1:getChildByName("gacha_title_arti"):getChildByName("star1")
		
		for iter_210_1 = 1, 6 do
			if_set_visible(var_210_1, "star" .. iter_210_1, iter_210_1 <= arg_210_3)
		end
	end
end

function GachaUnit.setStarPosition(arg_211_0, arg_211_1, arg_211_2)
	if_call(arg_211_1, "n_star", "setPositionX", arg_211_2:getContentSize().width * arg_211_2:getScaleX() + arg_211_2:getPositionX() - 235)
end

function GachaUnit.setroleIconPosition(arg_212_0, arg_212_1, arg_212_2)
	if_call(arg_212_1, "icon_role", "setPositionX", -15 - arg_212_2:getContentSize().width * arg_212_2:getScaleX() + arg_212_2:getPositionX())
end

function GachaUnit.setTitleUI(arg_213_0, arg_213_1, arg_213_2, arg_213_3, arg_213_4)
	local var_213_0
	
	if arg_213_2 == nil and arg_213_3 == nil then
		local var_213_1 = arg_213_1:getChildByName("n_gacha_title")
		
		if get_cocos_refid(var_213_1) then
			var_213_1:setVisible(true)
		end
		
		if_set_visible(arg_213_1, "n_gacha_title_arti", false)
		if_set_visible(arg_213_1, "n_gacha_title_limited", false)
		if_set_visible(arg_213_1, "n_gacha_title_limited_arti", false)
		
		return var_213_1
	elseif arg_213_2 == nil and arg_213_3 ~= nil then
		if_set_visible(arg_213_1, "n_gacha_title", false)
		
		local var_213_2 = arg_213_1:getChildByName("n_gacha_title_arti")
		
		if get_cocos_refid(var_213_2) then
			var_213_2:setVisible(true)
		end
		
		if_set_visible(arg_213_1, "n_gacha_title_limited", false)
		if_set_visible(arg_213_1, "n_gacha_title_limited_arti", false)
		
		return var_213_2
	elseif arg_213_2 ~= nil and arg_213_3 == nil then
		if_set_visible(arg_213_1, "n_gacha_title", false)
		if_set_visible(arg_213_1, "n_gacha_title_arti", false)
		
		local var_213_3 = arg_213_1:getChildByName("n_gacha_title_limited")
		
		if get_cocos_refid(var_213_3) then
			var_213_3:setVisible(true)
		end
		
		if_set_visible(arg_213_1, "n_gacha_title_limited_arti", false)
		
		return var_213_3
	elseif arg_213_2 ~= nil and arg_213_3 ~= nil then
		if_set_visible(arg_213_1, "n_gacha_title", false)
		if_set_visible(arg_213_1, "n_gacha_title_arti", false)
		if_set_visible(arg_213_1, "n_gacha_title_limited", false)
		
		local var_213_4 = arg_213_1:getChildByName("n_gacha_title_limited_arti")
		
		if get_cocos_refid(var_213_4) then
			var_213_4:setVisible(true)
		end
		
		return var_213_4
	end
	
	return nil
end

function GachaUnit.setRecommendTag(arg_214_0, arg_214_1, arg_214_2)
	if not get_cocos_refid(arg_214_1) then
		return 
	end
	
	local var_214_0 = arg_214_1:getChildByName("n_hero_tag")
	
	if get_cocos_refid(var_214_0) then
		if arg_214_2 then
			HeroRecommend:setRecommendTag(arg_214_2, var_214_0)
		else
			var_214_0:setVisible(false)
		end
	end
end

function GachaUnit.offAllTitle(arg_215_0)
end

function GachaUnit.external_summon(arg_216_0, arg_216_1, arg_216_2, arg_216_3, arg_216_4, arg_216_5, arg_216_6)
	arg_216_0.vars = {}
	arg_216_0.vars.callback_func = arg_216_6 or function()
	end
	arg_216_0.vars.layer = arg_216_5 or SceneManager:getRunningPopupScene()
	arg_216_0.vars.last_not_req_rand = true
	arg_216_0.vars.new_codes = {}
	arg_216_0.vars.common = {}
	arg_216_0.vars.intro = {}
	arg_216_0.vars.book = {}
	arg_216_0.vars.result = {}
	
	arg_216_0:setMode("init")
	
	arg_216_0.vars.gacha_layer = cc.Layer:create()
	
	arg_216_0.vars.layer:addChild(arg_216_0.vars.gacha_layer)
	
	arg_216_0.vars.gacha_mode = "gacha_rare"
	arg_216_0.vars.ui_wnd_top = cc.Layer:create()
	arg_216_0.vars.ui_wnd = arg_216_0:loadDlgGachaAll()
	
	local var_216_0 = "character"
	local var_216_1 = DB("character", arg_216_1, {
		"grade"
	})
	
	if not var_216_1 then
		var_216_1 = DB("equip_item", arg_216_1, {
			"artifact_grade"
		})
		var_216_0 = "equip"
	end
	
	if arg_216_3 == nil then
		if var_216_0 == "character" and not Account:getCollectionUnit(arg_216_1) then
			arg_216_3 = true
		elseif var_216_0 == "equip" and not Account:getCollectionEquip(arg_216_1) then
			arg_216_3 = true
		end
	end
	
	local var_216_2 = {
		{
			ct = 1,
			exp = 0,
			opt = 1,
			id = -1,
			st = 0,
			code = arg_216_1 or "c0007",
			g = var_216_1,
			new = arg_216_3,
			gacha_type = var_216_0,
			dupl_token = arg_216_4
		}
	}
	local var_216_3 = {}
	
	for iter_216_0, iter_216_1 in pairs(var_216_2) do
		if iter_216_1.gacha_type == "character" then
			if iter_216_1.new then
				var_216_3[iter_216_1.code] = true
			end
		elseif iter_216_1.gacha_type == "equip" and iter_216_1.new then
			var_216_3[iter_216_1.code] = true
		end
	end
	
	Action:Add(SEQ(DELAY(to_n(arg_216_2)), CALL(arg_216_0.seqIntro, arg_216_0, true), CALL(arg_216_0.seqIntroBookTouchWait, arg_216_0, var_216_2, var_216_3)), arg_216_0.vars.gacha_layer)
end

function GachaUnit.isActive(arg_218_0)
	if SceneManager:getCurrentSceneName() ~= "gacha_unit" then
		return false
	end
	
	if arg_218_0.vars == nil or arg_218_0.vars.ui_wnd == nil or not get_cocos_refid(arg_218_0.vars.ui_wnd) then
		return false
	end
	
	return true
end

function GachaUnit.updateGachaTempInventoryCount(arg_219_0)
	if SceneManager:getCurrentSceneName() ~= "gacha_unit" then
		return 
	end
	
	if arg_219_0.vars == nil or arg_219_0.vars.ui_wnd == nil or not get_cocos_refid(arg_219_0.vars.ui_wnd) then
		return 
	end
	
	local var_219_0 = arg_219_0.vars.ui_wnd:getChildByName("n_before")
	
	if not get_cocos_refid(var_219_0) then
		return 
	end
	
	local var_219_1
	
	if arg_219_0.vars.gacha_mode == "gacha_element" then
		var_219_1 = var_219_0:getChildByName("n_btn_gacha_inven2")
		
		if_set_visible(var_219_0, "n_btn_gacha_inven", false)
	else
		var_219_1 = var_219_0:getChildByName("n_btn_gacha_inven")
		
		if_set_visible(var_219_0, "n_btn_gacha_inven2", false)
	end
	
	if var_219_1 then
		var_219_1:setVisible(true)
		
		local var_219_2 = Account:countGachaTempInventory()
		
		if var_219_2 > 0 then
			if_set_visible(var_219_1, "count_bg", true)
			
			if var_219_2 > 99 then
				if_set(var_219_1, "label_count", "99+")
			else
				if_set(var_219_1, "label_count", var_219_2)
			end
		else
			if_set_visible(var_219_1, "count_bg", false)
		end
	end
end

function GachaUnit.groupPickupShopOpen(arg_220_0)
	if arg_220_0.vars.gacha_mode == "gacha_customgroup" and arg_220_0:checkGachaCustomGroupSelectCompleted({
		check_summon_count = true,
		err_text = "gacha_customgroup_shop_err_msg"
	}) then
		if ContentDisable:byAlias("market_miragecoin") then
			balloon_message(T("content_disable"))
			
			return 
		end
		
		if Stove:checkStandbyAndBalloonMessage() then
			query("market", {
				caller = "gacha_customgroup"
			})
		end
	elseif arg_220_0.vars.gacha_mode == "gacha_customspecial" and arg_220_0:checkGachaCustomSpecialSelectCompleted({
		check_summon_count = true,
		err_text = "gacha_customgroup_shop_err_msg"
	}) then
		if ContentDisable:byAlias("market_moon_miragecoin") then
			balloon_message(T("content_disable"))
			
			return 
		end
		
		if Stove:checkStandbyAndBalloonMessage() then
			query("market", {
				caller = "gacha_customspecial"
			})
		end
	end
end

function GachaUnit.onMsgShopBuy(arg_221_0, arg_221_1)
	GachaUnitShopPopup:updatePopupShopList()
end
