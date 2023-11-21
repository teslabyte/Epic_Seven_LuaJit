PetHelper = {}

copy_functions(ScrollView, PetHelper)

function HANDLER.pet_setting_p(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_checkbox_g" then
		PetHelper:toggle_repeatLose()
	elseif arg_1_1 == "btn_checkbox_g2" then
		PetHelper:toggle_checkAllUnit()
	elseif arg_1_1 == "btn_checkbox_g3" then
		PetHelper:toggle_maxFavoriteUnit()
	elseif arg_1_1 == "btn_charge" then
		PetHelper:toggle_staminaChargePopup()
	elseif string.starts(arg_1_1, "sort") then
		PetHelper:toggle_staminaChargePopup(string.sub(arg_1_1, -1))
	elseif arg_1_1 == "btn_close_select" then
		PetHelper:toggle_staminaChargePopup()
	elseif arg_1_1 == "btn_blockslider" then
		if PetHelper:isBackPlayPet() then
			balloon_message_with_sound("msg_bgbattle_cant_change_pet_count")
		else
			balloon_message_with_sound("ui_pet_auto_battle_other_btn")
		end
	elseif arg_1_1 == "btn_close" then
		PetHelper:close_petSetting()
	end
	
	if arg_1_1 == "btn_minus" then
		PetHelper:minus()
	end
	
	if arg_1_1 == "btn_plus" then
		PetHelper:plus()
	end
end

function PetHelper.open_petSetting(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = arg_2_3 or {}
	
	arg_2_0.vars = {}
	arg_2_0.vars.cur_pet = arg_2_1
	arg_2_0.vars.team_idx = arg_2_2
	arg_2_0.vars.is_back_play = var_2_0.is_back_play
	
	if SceneManager:getCurrentSceneName() == "battle" and not arg_2_1 then
		local var_2_1 = arg_2_0:getCurrentTeam()
		
		arg_2_0.vars.cur_pet = var_2_1[7]
	end
	
	if not arg_2_0.vars.cur_pet then
		Log.e("펫정보가 없습니다.")
		
		return 
	end
	
	arg_2_0.vars.is_back_play_pet = BackPlayManager:isRunningTeamPet(arg_2_0.vars.cur_pet:getUID())
	arg_2_0.vars.pet_setting_wnd = load_dlg("pet_setting_p", true, "wnd", function()
		PetHelper:close_petSetting()
	end)
	
	if_set_visible(arg_2_0.vars.pet_setting_wnd, "n_dim_img", not var_2_0.is_back_play)
	arg_2_0:init_petSettingPopup()
	
	if SceneManager:getCurrentSceneName() == "battle" and not PetSettingPopup.vars then
		BattleRepeat:getParentPopup():addChild(arg_2_0.vars.pet_setting_wnd)
		arg_2_0.vars.pet_setting_wnd:bringToFront()
	else
		SceneManager:getRunningPopupScene():addChild(arg_2_0.vars.pet_setting_wnd)
		arg_2_0.vars.pet_setting_wnd:bringToFront()
	end
end

function PetHelper.isBackPlayPet(arg_4_0)
	return arg_4_0.vars.is_back_play_pet
end

function PetHelper.getCurrentTeam(arg_5_0)
	local var_5_0
	
	if arg_5_0.vars.team_idx then
		var_5_0 = Account:getTeam(arg_5_0.vars.team_idx)
	elseif DescentReady:isShow() then
		var_5_0 = Account:getTeam(Account:getDescentPetTeamIdx())
	elseif BurningReady:isShow() then
		var_5_0 = Account:getTeam(Account:getBurningPetTeamIdx())
	elseif arg_5_0.vars.is_back_play and BackPlayManager:getRunningTeamIdxRaw() then
		var_5_0 = Account:getTeam(BackPlayManager:getRunningTeamIdxRaw())
	else
		var_5_0 = Account:getCurrentTeam()
	end
	
	return var_5_0 or {}
end

function PetHelper.isshow(arg_6_0)
	if not arg_6_0.vars then
		return false
	end
	
	return get_cocos_refid(arg_6_0.vars.pet_setting_wnd)
end

function PetHelper.init_petSettingPopup(arg_7_0)
	local var_7_0 = arg_7_0.vars.cur_pet
	local var_7_1 = arg_7_0.vars.cur_pet:getType()
	local var_7_2 = arg_7_0.vars.pet_setting_wnd
	local var_7_3 = UIUtil:getPetModel(var_7_0)
	
	if not var_7_3 then
		Log.e("펫 모델을 찾을수 없습니다.")
		
		return 
	end
	
	var_7_2:getChildByName("n_pos"):addChild(var_7_3)
	
	local var_7_4 = var_7_0:getGrade()
	local var_7_5 = var_7_2:getChildByName("n_stars")
	
	for iter_7_0 = 1, 6 do
		local var_7_6 = "star" .. iter_7_0
		
		if iter_7_0 <= var_7_4 then
			if_set_visible(var_7_2, var_7_6, true)
		else
			if_set_visible(var_7_2, var_7_6, false)
		end
	end
	
	if_set(var_7_2, "txt_generation", T("petgrade_pg_" .. var_7_0:getGrade()))
	
	local var_7_7 = var_7_2:getChildByName("txt_disc")
	
	if var_7_1 == PET_TYPE.LOBBY then
		if_set(var_7_2, "txt_top_title", T("ui_pet_help_popup_title_l"))
		if_set(var_7_2, "txt_disc", T("ui_pet_help_popup_desc_l"))
	else
		if_set(var_7_2, "txt_top_title", T("ui_pet_help_popup_title_b"))
		if_set(var_7_2, "txt_disc", T("ui_pet_help_popup_desc_b"))
	end
	
	local var_7_8 = var_7_7:getStringNumLines()
	
	if var_7_8 >= 2 then
		local var_7_9 = (var_7_8 - 1) * 18
		local var_7_10 = var_7_2:getChildByName("cm_tooltipbox")
		local var_7_11 = var_7_10:getContentSize()
		
		var_7_11.height = var_7_11.height + var_7_9
		
		var_7_10:setContentSize(var_7_11.width, var_7_11.height)
	end
	
	if_set(var_7_2, "txt_title", T("ui_pet_config_popup_info"))
	
	if var_7_1 == PET_TYPE.BATTLE then
		if_set_visible(var_7_2, "n_contents", true)
		if_set_visible(var_7_2, "n_lobby", false)
		SpriteCache:resetSprite(var_7_2:getChildByName("tip_image"), "img/pet_skill_info.png")
		
		local var_7_12 = var_7_2:getChildByName("n_token")
		
		if var_7_12 then
			arg_7_0:updateAllTokenCount()
			
			local var_7_13 = "update_token"
			
			if not Scheduler:findByName(var_7_13) then
				Scheduler:addSlow(var_7_2, arg_7_0.updateAllTokenCount, arg_7_0):setName(var_7_13)
			end
			
			arg_7_0:registerAllTokenTooltips(var_7_2)
			var_7_12:setVisible(true)
		end
		
		local var_7_14 = var_7_2:getChildByName("checkbox_g")
		
		if var_7_14 then
			var_7_14:addEventListener(PetHelper.toggle_repeatLose)
			var_7_14:setSelected(BattleRepeat:getRepeaatLose())
		end
		
		local var_7_15 = var_7_2:getChildByName("checkbox_g2")
		
		if var_7_15 then
			var_7_15:addEventListener(PetHelper.toggle_checkAllUnit)
			var_7_15:setSelected(BattleRepeat:getConfigCheckAllUnit())
		end
		
		local var_7_16 = var_7_2:getChildByName("checkbox_g3")
		
		if var_7_16 then
			var_7_16:addEventListener(PetHelper.toggle_maxFavoriteUnit)
			var_7_16:setSelected(BattleRepeat:getConfigMaxFavoriteUnit())
		end
		
		local var_7_17 = "ui_pet_help_popup_auto_no"
		
		if Account:getConfigData("autoBuyStamina_currency") == "to_crystal" then
			var_7_17 = "ui_pet_help_popup_auto_crystal"
		elseif Account:getConfigData("autoBuyStamina_currency") == "to_light" then
			var_7_17 = "ui_pet_help_popup_auto_leef"
		elseif Account:getConfigData("autoBuyStamina_currency") == "all" then
			var_7_17 = "ui_pet_help_popup_auto_all"
		end
		
		if_set(arg_7_0.vars.pet_setting_wnd:getChildByName("btn_charge"), "label", T(var_7_17))
		
		local var_7_18 = var_7_2:getChildByName("sort_1")
		
		if_set(var_7_18, "label", T("ui_pet_help_popup_auto_no"))
		
		local var_7_19 = var_7_2:getChildByName("sort_2")
		
		if_set(var_7_19, "label", T("ui_pet_help_popup_auto_crystal"))
		
		local var_7_20 = var_7_2:getChildByName("sort_3")
		
		if_set(var_7_20, "label", T("ui_pet_help_popup_auto_leef"))
		if_set(var_7_2, "txt_time", T("ui_pet_help_popup_help_b"))
		arg_7_0:init_slider()
	elseif var_7_1 == PET_TYPE.LOBBY then
		if_set_visible(var_7_2, "n_contents", false)
		if_set_visible(var_7_2, "n_lobby", true)
		SpriteCache:resetSprite(var_7_2:getChildByName("tip_image"), "img/pet_skill_info2.png")
		arg_7_0:initScrollView(var_7_2:findChildByName("scrollview"), 457, 100, {
			fit_height = true
		})
		
		local var_7_21 = var_7_0:getGiftTime()
		local var_7_22 = var_7_0:getGiftItemID()
		local var_7_23 = DB("item_special", var_7_22, {
			"value"
		})
		
		arg_7_0.vars.randombox_items = {}
		
		for iter_7_1 = 1, 9999 do
			local var_7_24, var_7_25, var_7_26, var_7_27, var_7_28 = DBN("randombox", iter_7_1, {
				"id",
				"item_special_value",
				"type",
				"item_id",
				"min"
			})
			
			if var_7_25 == var_7_23 then
				local var_7_29 = {
					id = var_7_24,
					item_special_value = var_7_25,
					type = var_7_26,
					item_id = var_7_27,
					min = var_7_28
				}
				
				table.insert(arg_7_0.vars.randombox_items, var_7_29)
			end
		end
		
		arg_7_0:createScrollViewItems(arg_7_0.vars.randombox_items)
		if_set(var_7_2, "txt_time", T("ui_pet_help_popup_help_l", {
			time = sec_to_full_string(var_7_21)
		}))
	end
end

function PetHelper.updateAllTokenCount(arg_8_0)
	if not arg_8_0.vars or not arg_8_0.vars.pet_setting_wnd or not get_cocos_refid(arg_8_0.vars.pet_setting_wnd) then
		return 
	end
	
	local var_8_0 = arg_8_0.vars.pet_setting_wnd
	
	arg_8_0:updateTokenCount(var_8_0, "to_stamina")
	arg_8_0:updateTokenCount(var_8_0, "to_light")
	arg_8_0:updateTokenCount(var_8_0, "to_crystal")
end

function PetHelper.updateTokenCount(arg_9_0, arg_9_1, arg_9_2)
	if not arg_9_1 or not get_cocos_refid(arg_9_1) or not arg_9_2 or not Account:isCurrencyType(arg_9_2) then
		return 
	end
	
	local var_9_0 = string.gsub(arg_9_2, "to", "txt")
	local var_9_1 = Account:getCurrency(arg_9_2)
	
	if var_9_1 then
		if_set(arg_9_1, var_9_0, comma_value(var_9_1))
	end
end

function PetHelper.registerAllTokenTooltips(arg_10_0, arg_10_1)
	if not arg_10_1 or not get_cocos_refid(arg_10_1) then
		return 
	end
	
	arg_10_0:registerTokenTooltip(arg_10_1, "to_stamina")
	arg_10_0:registerTokenTooltip(arg_10_1, "to_light")
	arg_10_0:registerTokenTooltip(arg_10_1, "to_crystal")
end

function PetHelper.registerTokenTooltip(arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = string.gsub(arg_11_2, "to", "btn")
	local var_11_1 = arg_11_1:getChildByName(var_11_0)
	
	if var_11_1 then
		WidgetUtils:setupTooltip({
			delay = 100,
			control = var_11_1,
			creator = function()
				return ItemTooltip:getItemTooltip({
					code = arg_11_2
				})
			end
		})
	end
end

function PetHelper.getMax_repeat_count(arg_13_0)
	if not arg_13_0.vars or not arg_13_0.vars.cur_pet then
		return 
	end
	
	return arg_13_0.vars.cur_pet:getRepeat_count()
end

local function var_0_0(arg_14_0, arg_14_1)
	PetHelper:onChangeSlider(arg_14_0:getPercent(), arg_14_1)
end

function PetHelper.init_slider(arg_15_0)
	local var_15_0
	local var_15_1
	
	arg_15_0.vars.slide_count, var_15_1 = BattleRepeat:getConfigRepeatBattleCount(arg_15_0.vars.team_idx)
	
	if arg_15_0.vars.slide_count > arg_15_0:getMax_repeat_count() or var_15_1 then
		arg_15_0.vars.slide_count = arg_15_0:getMax_repeat_count()
	end
	
	local var_15_2 = arg_15_0.vars.pet_setting_wnd:getChildByName("slider")
	
	if not get_cocos_refid(var_15_2) then
		return 
	end
	
	arg_15_0.vars.slider = var_15_2
	
	arg_15_0.vars.slider:addEventListener(var_0_0)
	arg_15_0:updateCountPopup(arg_15_0.vars.slide_count)
	
	local var_15_3 = false
	
	if arg_15_0:isBackPlayPet() then
		var_15_3 = true
	elseif BattleReady:isShow() or DescentReady:isShow() or BurningReady:isShow() then
		local var_15_4 = arg_15_0:getCurrentTeam()
		
		if not var_15_4 or not var_15_4[7] or arg_15_0.vars.cur_pet ~= var_15_4[7] then
			var_15_3 = true
		end
	elseif SceneManager:getCurrentSceneName() == "battle" and not BattleReady:isShow() then
		var_15_3 = true
	end
	
	if var_15_3 then
		if_set_opacity(arg_15_0.vars.pet_setting_wnd, "n_slider", 76.5)
		arg_15_0.vars.slider:setTouchEnabled(false)
		arg_15_0.vars.pet_setting_wnd:getChildByName("btn_plus"):setTouchEnabled(false)
		arg_15_0.vars.pet_setting_wnd:getChildByName("btn_minus"):setTouchEnabled(false)
		if_set_visible(arg_15_0.vars.pet_setting_wnd, "btn_blockslider", true)
	end
end

function PetHelper.onChangeSlider(arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = round(arg_16_0:getMax_repeat_count() * arg_16_1 / 100)
	
	arg_16_0:updateCountPopup(var_16_0)
end

function PetHelper.updateCountPopup(arg_17_0, arg_17_1)
	if arg_17_1 == 0 and arg_17_0:getMax_repeat_count() > 0 then
		arg_17_1 = 1
	end
	
	arg_17_0.vars.slide_count = arg_17_1
	
	local var_17_0 = arg_17_0.vars.slide_count * 100 / arg_17_0:getMax_repeat_count()
	
	arg_17_0.vars.slider:setPercent(var_17_0)
	
	if arg_17_1 ~= 0 then
		if_set(arg_17_0.vars.wnd, "t_mix_count", tostring(arg_17_0.vars.slide_count) .. "/" .. arg_17_0:getMax_repeat_count())
	end
	
	if arg_17_0:getMax_repeat_count() > 0 then
		arg_17_0.vars.slider:setPercent(arg_17_0.vars.slide_count * 100 / arg_17_0:getMax_repeat_count())
	else
		arg_17_0.vars.slider:setPercent(0)
	end
	
	if_set(arg_17_0.vars.pet_setting_wnd, "txt_slide", arg_17_0.vars.slide_count .. "/" .. arg_17_0:getMax_repeat_count())
end

function PetHelper.plus(arg_18_0)
	if arg_18_0.vars.slide_count + 1 > arg_18_0:getMax_repeat_count() then
		return 
	end
	
	arg_18_0.vars.slide_count = arg_18_0.vars.slide_count + 1
	
	arg_18_0:updateCountPopup(arg_18_0.vars.slide_count)
end

function PetHelper.minus(arg_19_0)
	if arg_19_0.vars.slide_count - 1 < 1 then
		return 
	end
	
	arg_19_0.vars.slide_count = arg_19_0.vars.slide_count - 1
	
	arg_19_0:updateCountPopup(arg_19_0.vars.slide_count)
end

function PetHelper.getScrollViewItem(arg_20_0, arg_20_1)
	local var_20_0 = load_control("wnd/pet_setting_card.csb")
	
	if_set_visible(var_20_0, "txt", false)
	if_set_visible(var_20_0, "bar1_l", false)
	var_20_0:setAnchorPoint(0.5, 0.5)
	var_20_0:setPosition(0, 0)
	
	local function var_20_1(arg_21_0)
		return DB("item_material", arg_21_0, "name") or DB("item_token", arg_21_0, "name") or DB("item_special", arg_21_0, "name")
	end
	
	if_set(var_20_0, "txt_name", T(var_20_1(arg_20_1.item_id)))
	
	local var_20_2 = UIUtil:getRewardIcon(tonumber(arg_20_1.min), arg_20_1.item_id, {
		show_small_count = true,
		no_name = true,
		parent = var_20_0:getChildByName("n_reward_icon")
	})
	
	if var_20_2 then
		if_set(var_20_2, "txt_small_count", comma_value(arg_20_1.min))
	end
	
	return var_20_0
end

function PetHelper.toggle_repeatLose(arg_22_0)
	local var_22_0 = PetHelper.vars.pet_setting_wnd:getChildByName("checkbox_g")
	local var_22_1 = BattleRepeat:getRepeaatLose()
	
	BattleRepeat:setRepeaatLose(not var_22_1)
	var_22_0:setSelected(not var_22_1)
end

function PetHelper.toggle_checkAllUnit(arg_23_0)
	local var_23_0 = PetHelper.vars.pet_setting_wnd:getChildByName("checkbox_g2")
	local var_23_1 = not BattleRepeat:getConfigCheckAllUnit()
	
	BattleRepeat:setConfigCheckAllUnit(var_23_1)
	var_23_0:setSelected(var_23_1)
	BattleRepeat:markMaxLevelUnit()
end

function PetHelper.toggle_maxFavoriteUnit(arg_24_0)
	local var_24_0 = PetHelper.vars.pet_setting_wnd:getChildByName("checkbox_g3")
	local var_24_1 = not BattleRepeat:getConfigMaxFavoriteUnit()
	
	BattleRepeat:setConfigCheckMaxFavoriteUnit(var_24_1)
	var_24_0:setSelected(var_24_1)
	BattleRepeat:markMaxFavoriteUnit()
end

function PetHelper.toggle_staminaChargePopup(arg_25_0, arg_25_1)
	local var_25_0 = tonumber(arg_25_1)
	
	if not arg_25_0.vars or not get_cocos_refid(arg_25_0.vars.pet_setting_wnd) then
		return 
	end
	
	local var_25_1 = arg_25_0.vars.pet_setting_wnd:getChildByName("charge_sort")
	
	if not var_25_1 then
		return 
	end
	
	if var_25_0 then
		if var_25_0 == 1 then
			if_set(arg_25_0.vars.pet_setting_wnd:getChildByName("btn_charge"), "label", T("ui_pet_help_popup_auto_no"))
			SAVE:setTempConfigData("autoBuyStamina_currency", "none")
		elseif var_25_0 == 2 then
			if_set(arg_25_0.vars.pet_setting_wnd:getChildByName("btn_charge"), "label", T("ui_pet_help_popup_auto_crystal"))
			SAVE:setTempConfigData("autoBuyStamina_currency", "to_crystal")
		elseif var_25_0 == 3 then
			if_set(arg_25_0.vars.pet_setting_wnd:getChildByName("btn_charge"), "label", T("ui_pet_help_popup_auto_leef"))
			SAVE:setTempConfigData("autoBuyStamina_currency", "to_light")
		elseif var_25_0 == 4 then
			if_set(arg_25_0.vars.pet_setting_wnd:getChildByName("btn_charge"), "label", T("ui_pet_help_popup_auto_all"))
			balloon_message_with_sound("pet_auto_charge_all_message")
			SAVE:setTempConfigData("autoBuyStamina_currency", "all")
		end
	end
	
	var_25_1:setVisible(not var_25_1:isVisible())
end

function PetHelper.close_petSetting(arg_26_0)
	if not arg_26_0.vars or not get_cocos_refid(arg_26_0.vars.pet_setting_wnd) then
		return 
	end
	
	BackButtonManager:pop("pet_setting_p")
	
	if arg_26_0.vars.slide_count then
		local var_26_0 = arg_26_0.vars.slide_count
		
		if arg_26_0.vars.slide_count > arg_26_0:getMax_repeat_count() then
			var_26_0 = arg_26_0:getMax_repeat_count()
		end
		
		if BattleReady:isShow() or UnitMain:getMode() and UnitMain:getMode() == "Main" or DescentReady:isShow() or BurningReady:isShow() or arg_26_0.vars.is_back_play then
			local var_26_1 = arg_26_0:getCurrentTeam()
			
			if var_26_1 and var_26_1[7] and arg_26_0.vars.cur_pet == var_26_1[7] then
				if not BackPlayManager:isRunning() then
					BattleRepeat:set_repeatMaxCount(var_26_0)
				end
				
				BattleRepeat:setConfigRepeatBattleCount(var_26_0, DescentReady:isShow() and Account:getDescentPetTeamIdx() or BurningReady:isShow() and Account:getBurningPetTeamIdx() or arg_26_0.vars.team_idx)
			end
		end
		
		Formation:update_repeatCount(arg_26_0.vars.cur_pet)
		
		if DescentReady:isShow() then
			DescentReady:update_repeatCount(arg_26_0.vars.cur_pet)
		elseif BurningReady:isShow() then
			BurningReady:update_repeatCount(arg_26_0.vars.cur_pet)
		end
	end
	
	arg_26_0.vars.pet_setting_wnd:removeFromParent()
	
	arg_26_0.vars = nil
end
