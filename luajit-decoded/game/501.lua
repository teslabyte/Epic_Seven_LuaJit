CustomProfileCardEditor = {}
CustomProfileCardEditor.LayerCommand = {}

function MsgHandler.save_profile_card(arg_1_0)
	if arg_1_0 and arg_1_0.res and arg_1_0.res == "ok" then
		if arg_1_0.profile_card_ban_tm then
			Account:setProfileCardBanRemainTime(arg_1_0.profile_card_ban_tm)
			
			if arg_1_0.profile_card_ban_tm == -1 or arg_1_0.profile_card_ban_tm ~= 0 then
				balloon_message_with_sound("msg_profile_card_save_fail")
			end
			
			return 
		end
		
		local var_1_0 = false
		
		if arg_1_0.user_opt and getExtractedUserOption(arg_1_0.user_opt, 4) == 1 then
			var_1_0 = true
		end
		
		CustomProfileCardEditor:applyRecentSaveData(var_1_0)
	end
end

function HANDLER.profile_custom(arg_2_0, arg_2_1)
	if arg_2_1 == "btn_check1" then
	elseif arg_2_1 == "btn_check2" then
		CustomProfileCardEditor:toggleLayerViewMode(arg_2_0)
	elseif arg_2_1 == "btn_cancel" then
		CustomProfileCardEditor:setFocusLayer(nil)
	elseif string.find(arg_2_1, "tab_%a") then
		CustomProfileCardEditor:onClickTapBtn(arg_2_1)
	elseif arg_2_1 == "btn_first" or arg_2_1 == "btn_front" or arg_2_1 == "btn_back" or arg_2_1 == "btn_last" then
		local var_2_0 = string.len("btn_")
		local var_2_1 = string.sub(arg_2_1, var_2_0 + 1, -1)
		local var_2_2 = CustomProfileCardEditor:getFocusLayer()
		
		if arg_2_0.is_layer_view and arg_2_0.layer then
			var_2_2 = arg_2_0.layer
		end
		
		CustomProfileCardEditor:sortLayer(var_2_1, var_2_2)
	elseif arg_2_1 == "btn_before" or arg_2_1 == "btn_after" then
		CustomProfileCardEditor:getLayerCommand():doCommand(arg_2_1)
	elseif arg_2_1 == "btn_select" then
		if arg_2_0.item then
			if arg_2_0.callback and type(arg_2_0.callback) == "function" and not arg_2_0:callback(arg_2_0.item) then
				return 
			end
			
			CustomProfileCardEditor:openSelectPopup(arg_2_0)
		end
		
		if arg_2_0.is_layer_view and arg_2_0.layer then
			if not arg_2_0.layer:isLock() and not CustomProfileCardEditor:isFocusLayer(arg_2_0.layer) then
				CustomProfileCardEditor:setFocusLayer(arg_2_0.layer, arg_2_0.is_layer_view)
			end
			
			return 
		end
		
		if arg_2_0.is_skin then
			arg_2_0:callback()
			
			return 
		end
	elseif arg_2_1 == "btn_check_sd" then
		CustomProfileCardHero:toggleShowSDHero()
	elseif string.find(arg_2_1, "search") then
		if arg_2_1 == "btn_close_search" then
			CustomProfileCardHero:showHeroSearchPopup(false)
		elseif arg_2_1 == "btn_search" then
			CustomProfileCardHero:searchHero()
		elseif string.find(arg_2_1, "btn_open_search") then
			if string.find(arg_2_1, "active") then
				CustomProfileCardHero:resetSearch()
			else
				CustomProfileCardHero:showHeroSearchPopup(true)
			end
		end
	elseif arg_2_1 == "btn_dropdown" then
		CustomProfileCardBg:showDropDown(true)
	elseif arg_2_1 == "btn_close_illust" then
		CustomProfileCardBg:showDropDown(false)
	elseif string.find(arg_2_1, "sort_") then
		CustomProfileCardBg:setIllustCategory(arg_2_0)
	elseif string.find(arg_2_1, "tab_%d") then
		local var_2_3 = string.len("tab_")
		local var_2_4 = string.sub(arg_2_1, var_2_3 + 1, -1)
		
		CustomProfileCardEditor:setListViewMode(var_2_4)
	elseif arg_2_1 == "btn_copy" then
		CustomProfileCardEditor:copyLayer()
	elseif arg_2_1 == "btn_save" then
		CustomProfileCardEditor:saveProfileCard()
	elseif arg_2_1 == "btn_delet" then
		CustomProfileCardEditor:deleteLayerItem()
	elseif (arg_2_1 == "btn_off" or arg_2_1 == "btn_on") and arg_2_0.is_layer_view and arg_2_0.callback and type(arg_2_0.callback) == "function" then
		arg_2_0:callback(arg_2_0)
	end
end

function HANDLER.profile_custom_item_locked(arg_3_0, arg_3_1)
	if arg_3_1 == "btn_close" or arg_3_1 == "btn_cancel" then
		CustomProfileCardEditor:closeSelectPopup()
	elseif arg_3_1 == "btn_yes" and arg_3_0.callback and type(arg_3_0.callback) == "function" then
		arg_3_0:callback()
	end
end

function MsgHandler.buy_profile_card_material(arg_4_0)
	if arg_4_0 and arg_4_0.res and arg_4_0.res == "ok" then
		CustomProfileCardEditor:onBuyLayerItem(arg_4_0)
	end
end

function CustomProfileCardEditor.open(arg_5_0, arg_5_1)
	arg_5_1 = arg_5_1 or {}
	
	CustomProfileCardZoom:close()
	CustomProfileCardList:close()
	Profile:close()
	
	arg_5_0.vars = {}
	arg_5_0.vars.wnd = load_dlg("profile_custom", true, "wnd")
	
	SceneManager:getRunningPopupScene():addChild(arg_5_0.vars.wnd)
	
	arg_5_0.vars.n_right = arg_5_0.vars.wnd:getChildByName("RIGHT")
	
	arg_5_0:initDB()
	arg_5_0:createTargetCard(arg_5_1)
	arg_5_0:initUI()
	TopBarNew:createFromPopup(T("ui_profile_card_popup_title"), arg_5_0.vars.wnd, function()
		arg_5_0:checkModification()
	end, {
		"crystal",
		"gold"
	})
	TopBarNew:setDisableTopRight()
	ConditionContentsManager:customProfileForceUpdateConditions()
	LuaEventDispatcher:addIfNotEventListener("arena_net.notifier.remove_all", LISTENER(ArenaNetNotifier.removeAll, ArenaNetNotifier), "profile_card_editor.close")
end

function CustomProfileCardEditor.close(arg_7_0)
	if not arg_7_0.vars or not get_cocos_refid(arg_7_0.vars.wnd) or not arg_7_0.LayerCommand then
		return 
	end
	
	LuaEventDispatcher:dispatchEvent("arena_net.notifier.remove_all")
	Scheduler:removeByName("profile_card.updateLayerControlInfo")
	Scheduler:removeByName("profile_card.updateProfileCardSaveDelay")
	
	for iter_7_0, iter_7_1 in pairs(arg_7_0.vars.category_list) do
		iter_7_1:release()
	end
	
	arg_7_0.LayerCommand:release()
	TopBarNew:setEnableTopRight()
	TopBarNew:pop()
	BackButtonManager:pop({
		id = "profile_custom",
		dlg = arg_7_0.vars.wnd
	})
	arg_7_0.vars.wnd:removeFromParent()
	
	arg_7_0.vars = nil
	
	Profile:open({
		open_profile_card_list = not Account:getProfileCardBanState()
	})
end

function CustomProfileCardEditor.getWnd(arg_8_0)
	if not arg_8_0.vars or not get_cocos_refid(arg_8_0.vars.wnd) then
		return nil
	end
	
	return arg_8_0.vars.wnd
end

function CustomProfileCardEditor.isOpen(arg_9_0)
	if not arg_9_0.vars or not get_cocos_refid(arg_9_0.vars.wnd) or not arg_9_0.vars.wnd:isVisible() then
		return false
	end
	
	return arg_9_0.vars.wnd:isVisible()
end

function CustomProfileCardEditor.checkModification(arg_10_0)
	if not arg_10_0.vars or not get_cocos_refid(arg_10_0.vars.wnd) then
		return 
	end
	
	if not arg_10_0.vars.target_card or not arg_10_0.vars.last_save_card_data then
		return 
	end
	
	if arg_10_0.vars.last_save_card_data ~= arg_10_0.vars.target_card:save() then
		Dialog:msgBox(T("ui_profile_card_not_save"), {
			yesno = true,
			title = T("ui_profile_card_popup_title"),
			handler = function()
				arg_10_0:close()
			end
		})
		
		return 
	end
	
	arg_10_0:close()
end

function CustomProfileCardEditor.createTargetCard(arg_12_0, arg_12_1)
	if not arg_12_0.vars or not get_cocos_refid(arg_12_0.vars.wnd) then
		return 
	end
	
	arg_12_1 = arg_12_1 or {}
	arg_12_0.vars.target_card_id = arg_12_1.id
	
	if not arg_12_1.card_data then
		arg_12_0.vars.target_card = CustomProfileCard:create({
			is_new = true,
			is_edit_mode = true
		})
	else
		arg_12_0.vars.target_card = CustomProfileCard:create({
			is_edit_mode = true,
			card_data = arg_12_1.card_data
		})
	end
	
	arg_12_0.vars.last_save_card_data = arg_12_0.vars.target_card:save()
end

ProfileCardConfigData = {}

function CustomProfileCardEditor.initDB(arg_13_0)
	if not arg_13_0.vars or not get_cocos_refid(arg_13_0.vars.wnd) or not get_cocos_refid(arg_13_0.vars.n_right) or not arg_13_0.LayerCommand then
		return 
	end
	
	for iter_13_0 = 1, 9999 do
		local var_13_0, var_13_1 = DBN("profile_config", iter_13_0, {
			"id",
			"client_value"
		})
		
		if not var_13_0 then
			break
		end
		
		ProfileCardConfigData[var_13_0] = var_13_1
		
		if var_13_0 == "flip_not_allowed" then
			local var_13_2 = ProfileCardConfigData[var_13_0]
			
			ProfileCardConfigData[var_13_0] = string.split(var_13_2, ";")
		end
	end
	
	arg_13_0.vars.item_unlock_infos = {}
	
	for iter_13_1 = 1, 9999 do
		local var_13_3, var_13_4, var_13_5, var_13_6, var_13_7, var_13_8, var_13_9, var_13_10, var_13_11 = DBN("item_material_profile", iter_13_1, {
			"id",
			"material_id",
			"unlock",
			"hide_not_possessed",
			"token",
			"price",
			"mission_id",
			"unlock_title",
			"bg_img"
		})
		
		if not var_13_3 then
			break
		end
		
		arg_13_0.vars.item_unlock_infos[var_13_3] = {
			material_id = var_13_4,
			unlock = var_13_5,
			hide_not_possessed = var_13_6,
			token = var_13_7,
			price = var_13_8,
			mission_id = var_13_9,
			unlock_title = var_13_10,
			bg_img = var_13_11
		}
	end
	
	arg_13_0.LayerCommand:init()
	
	arg_13_0.vars.category_list = {
		hero = CustomProfileCardHero,
		bg = CustomProfileCardBg,
		shape = CustomProfileCardShape,
		text = CustomProfileCardText,
		badge = CustomProfileCardBadge
	}
	
	for iter_13_2, iter_13_3 in pairs(arg_13_0.vars.category_list) do
		local var_13_12 = arg_13_0.vars.n_right:getChildByName("tab_" .. iter_13_2)
		local var_13_13 = arg_13_0.vars.n_right:getChildByName("n_" .. iter_13_2)
		
		if get_cocos_refid(var_13_12) and get_cocos_refid(var_13_13) then
			local var_13_14 = true
			
			if (iter_13_2 == "text" or iter_13_2 == "shape") and ContentDisable:byAlias("profile_card_" .. iter_13_2) then
				var_13_14 = false
			end
			
			if var_13_14 then
				local var_13_15 = {
					n_tab = var_13_12,
					category_wnd = var_13_13
				}
				
				iter_13_3:create(var_13_15)
			else
				if_set_visible(var_13_12, nil, false)
				if_set_visible(var_13_13, nil, false)
				
				arg_13_0.vars.category_list[iter_13_2] = nil
			end
		end
	end
	
	arg_13_0.vars.is_exist_modify = false
end

function CustomProfileCardEditor.initUI(arg_14_0)
	if not arg_14_0.vars or not get_cocos_refid(arg_14_0.vars.wnd) then
		return 
	end
	
	if not arg_14_0.vars.target_card_id or not arg_14_0.vars.target_card then
		return 
	end
	
	local var_14_0 = arg_14_0.vars.wnd:getChildByName("LEFT")
	
	arg_14_0.vars.n_layer = var_14_0:getChildByName("n_layer")
	
	if_set_visible(arg_14_0.vars.n_layer, nil, false)
	NotchManager:addListener(arg_14_0.vars.n_layer, false, function(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
		if arg_14_0.vars.n_layer:isVisible() then
			arg_14_0:setLayerView(true, true)
		end
	end)
	arg_14_0:initLayerView()
	
	local var_14_1 = arg_14_0.vars.n_right:getChildByName("checkbox1")
	
	if get_cocos_refid(var_14_1) then
		var_14_1:setSelected(false)
	end
	
	local var_14_2 = arg_14_0.vars.n_right:getChildByName("checkbox2")
	
	if get_cocos_refid(var_14_2) then
		var_14_2:setSelected(false)
	end
	
	local var_14_3 = arg_14_0.vars.wnd:getChildByName("n_edit")
	
	if get_cocos_refid(var_14_3) then
		local var_14_4 = var_14_3:getChildByName("n_unit")
		
		if get_cocos_refid(var_14_4) then
			local var_14_5 = arg_14_0.vars.target_card:getWnd()
			
			var_14_4:addChild(var_14_5)
		end
		
		if_set_visible(var_14_3, "n_bottom", false)
	end
	
	arg_14_0:setCatrgory("hero")
end

function CustomProfileCardEditor.initLayerView(arg_16_0)
	if not arg_16_0.vars or not get_cocos_refid(arg_16_0.vars.wnd) or not get_cocos_refid(arg_16_0.vars.n_layer) then
		return 
	end
	
	if_set(arg_16_0.vars.n_layer, "txt_count", "0/" .. tostring(ProfileCardConfigData.max_layer_arrangement or 80))
	
	arg_16_0.vars.layer_listview = ItemListView_v2:bindControl(arg_16_0.vars.n_layer:getChildByName("listview_layer"))
	
	local var_16_0 = {
		onUpdate = function(arg_17_0, arg_17_1, arg_17_2, arg_17_3)
			arg_16_0:updateLayerListviewItem(arg_17_1, arg_17_3)
			
			return arg_17_3.id
		end
	}
	local var_16_1 = load_control("wnd/profile_custom_layer_card.csb")
	
	arg_16_0.vars.layer_listview:setRenderer(var_16_1, var_16_0)
	arg_16_0.vars.layer_listview:removeAllChildren()
end

function CustomProfileCardEditor.isNeedHideCheckLayerItem(arg_18_0, arg_18_1)
	if not arg_18_0.vars or table.empty(arg_18_0.vars.item_unlock_infos) or not arg_18_1 or not arg_18_0.vars.item_unlock_infos[arg_18_1] then
		return false
	end
	
	local var_18_0 = arg_18_0.vars.item_unlock_infos[arg_18_1]
	
	if var_18_0.hide_not_possessed and var_18_0.hide_not_possessed == "y" then
		return true
	end
	
	return false
end

function CustomProfileCardEditor.checkLayerItemUnlock(arg_19_0, arg_19_1)
	if not arg_19_0.vars or table.empty(arg_19_0.vars.item_unlock_infos) or not arg_19_1 or not arg_19_0.vars.item_unlock_infos[arg_19_1] then
		return nil, nil
	end
	
	local var_19_0 = arg_19_0.vars.item_unlock_infos[arg_19_1]
	
	if var_19_0.unlock == "basic" then
		return true, var_19_0.unlock
	elseif var_19_0.unlock == "reward" or var_19_0.unlock == "purchase" then
		return Account:getItemCount(var_19_0.material_id) > 0, var_19_0.unlock
	elseif var_19_0.unlock == "achievement" then
		return HiddenMission:isCleared(var_19_0.mission_id), var_19_0.unlock
	end
	
	return nil, nil
end

function CustomProfileCardEditor.toggleLayerViewMode(arg_20_0, arg_20_1)
	if not arg_20_0.vars or not get_cocos_refid(arg_20_0.vars.wnd) or not get_cocos_refid(arg_20_0.vars.n_right) or not get_cocos_refid(arg_20_1) then
		return 
	end
	
	local var_20_0 = arg_20_0.vars.n_right:getChildByName("checkbox2")
	
	if get_cocos_refid(var_20_0) then
		local var_20_1 = var_20_0:isSelected()
		
		arg_20_0:setLayerView(not var_20_1)
		var_20_0:setSelected(not var_20_1)
	end
end

function CustomProfileCardEditor.setCatrgory(arg_21_0, arg_21_1, arg_21_2)
	if not arg_21_0.vars or not get_cocos_refid(arg_21_0.vars.wnd) or not get_cocos_refid(arg_21_0.vars.n_right) or not arg_21_1 then
		return 
	end
	
	if not arg_21_2 and arg_21_0.vars.focus_layer then
		arg_21_0.vars.focus_layer:activeEditorBox(false)
		
		arg_21_0.vars.focus_layer = nil
		
		arg_21_0:setFocusLayerViewItem()
	end
	
	if arg_21_0.vars.cur_category then
		arg_21_0.vars.category_list[arg_21_0.vars.cur_category]:resetUI()
	end
	
	arg_21_0.vars.cur_category = arg_21_1
	
	arg_21_0.vars.category_list[arg_21_0.vars.cur_category]:setUI()
	arg_21_0:updateBottom(arg_21_1)
end

function CustomProfileCardEditor.getCurrnetCatrgory(arg_22_0)
	if not arg_22_0.vars or not get_cocos_refid(arg_22_0.vars.wnd) then
		return nil
	end
	
	return arg_22_0.vars.cur_category
end

function CustomProfileCardEditor.createLayer(arg_23_0, arg_23_1)
	if not arg_23_0.vars or not get_cocos_refid(arg_23_0.vars.wnd) or table.empty(arg_23_1) then
		return 
	end
	
	if not arg_23_0.vars.target_card_id or not arg_23_0.vars.target_card then
		return 
	end
	
	if arg_23_0.vars.target_card:getLayerCount() >= (ProfileCardConfigData.max_layer_arrangement or 80) then
		balloon_message_with_sound("msg_profile_prop_max")
		
		return 
	end
	
	local var_23_0 = arg_23_0.vars.target_card:getTypeLayers(arg_23_1.type)
	local var_23_1 = ProfileCardConfigData["max_" .. arg_23_1.type .. "_arrangement"] or 0
	local var_23_2
	
	if arg_23_1.type == "hero" then
		var_23_2 = "msg_profile_char_max"
	elseif arg_23_1.type == "bg" then
		var_23_2 = "msg_profile_bg_max"
	elseif arg_23_1.type == "badge" then
		var_23_2 = "msg_profile_badge_max"
	elseif arg_23_1.type == "text" then
		var_23_2 = "msg_profile_text_max"
	end
	
	if arg_23_1.type ~= "shape" and not table.empty(var_23_0) and var_23_1 <= table.count(var_23_0) then
		balloon_message_with_sound(var_23_2)
		
		return 
	end
	
	if (arg_23_1.type == "hero" or arg_23_1.type == "bg" or arg_23_1.type == "badge") and arg_23_0.vars.target_card:checkDuplicationLayer(arg_23_1.type, arg_23_1.id) then
		balloon_message_with_sound("msg_profile_already_placed")
		
		return 
	end
	
	arg_23_0.vars.target_card:createLayer(arg_23_1)
	arg_23_0:updateBottom(arg_23_1.type)
	arg_23_0:updateLayerView()
end

function CustomProfileCardEditor.updateBottom(arg_24_0, arg_24_1)
	if not arg_24_0.vars or not get_cocos_refid(arg_24_0.vars.wnd) or not get_cocos_refid(arg_24_0.vars.n_right) or not arg_24_1 then
		return 
	end
	
	if not arg_24_0.vars.target_card_id or not arg_24_0.vars.target_card then
		return 
	end
	
	if arg_24_0.vars.focus_layer then
		local var_24_0 = arg_24_0.vars.wnd:getChildByName("n_edit")
		
		if get_cocos_refid(var_24_0) then
			if_set_visible(var_24_0, "n_bottom", true)
			Scheduler:removeByName("profile_card.updateLayerControlInfo")
			
			local var_24_1 = {
				hero = T("ui_profile_manual_character"),
				bg = T("ui_profile_manual_bg"),
				shape = T("ui_profile_manual_shape"),
				text = T("ui_profile_manual_text"),
				badge = T("ui_profile_manual_badge")
			}
			
			if_set(var_24_0, "txt_info", var_24_1[arg_24_1])
			
			local var_24_2 = os.time()
			local var_24_3 = 3
			
			Scheduler:addSlow(var_24_0:getChildByName("txt_info"), function()
				if os.time() - var_24_2 >= var_24_3 then
					if_set_visible(var_24_0, "n_bottom", false)
					Scheduler:removeByName("profile_card.updateLayerControlInfo")
				end
			end):setName("profile_card.updateLayerControlInfo")
		end
	end
	
	local var_24_4 = arg_24_0.vars.n_right:getChildByName("n_bottom")
	
	if get_cocos_refid(var_24_4) then
		local var_24_5 = {
			text = "icon_menu_text.png",
			hero = "icon_menu_hero.png",
			shape = "icon_menu_shape.png",
			bg = "icon_menu_bgpack.png",
			badge = "icon_menu_insignia.png"
		}
		local var_24_6 = "img/" .. var_24_5[arg_24_1]
		
		if_set_sprite(var_24_4, "icon_tab", var_24_6)
		
		local var_24_7 = arg_24_0.vars.target_card:getTypeLayers(arg_24_1)
		local var_24_8 = 0
		
		if not table.empty(var_24_7) then
			var_24_8 = table.count(var_24_7)
		end
		
		local var_24_9
		
		if arg_24_1 == "shape" then
			var_24_9 = tostring(var_24_8)
		else
			local var_24_10 = ProfileCardConfigData["max_" .. arg_24_1 .. "_arrangement"] or 0
			
			var_24_9 = tostring(var_24_8) .. "/" .. tostring(var_24_10)
		end
		
		if_set(var_24_4, "txt_count", var_24_9)
	end
	
	arg_24_0:updateUndoAndRedoButtons()
end

function CustomProfileCardEditor.updateUndoAndRedoButtons(arg_26_0)
	if not arg_26_0.vars or not get_cocos_refid(arg_26_0.vars.wnd) or not get_cocos_refid(arg_26_0.vars.n_right) or not arg_26_0.LayerCommand then
		return 
	end
	
	if not arg_26_0.vars.target_card_id or not arg_26_0.vars.target_card then
		return 
	end
	
	local var_26_0 = arg_26_0.vars.n_right:getChildByName("n_bottom")
	
	if get_cocos_refid(var_26_0) then
		if_set_opacity(var_26_0, "btn_before", arg_26_0.LayerCommand:isEmptyUndo() and 76.5 or 255)
		if_set_opacity(var_26_0, "btn_after", arg_26_0.LayerCommand:isEmptyRedo() and 76.5 or 255)
	end
end

function CustomProfileCardEditor.getTargetCard(arg_27_0)
	if not arg_27_0.vars or not get_cocos_refid(arg_27_0.vars.wnd) then
		return nil
	end
	
	if not arg_27_0.vars.target_card_id then
		return nil
	end
	
	return arg_27_0.vars.target_card
end

function CustomProfileCardEditor.setFocusLayer(arg_28_0, arg_28_1, arg_28_2)
	if not arg_28_0.vars or not get_cocos_refid(arg_28_0.vars.wnd) then
		return 
	end
	
	if not arg_28_0.vars.target_card_id or not arg_28_0.vars.target_card then
		return 
	end
	
	local var_28_0 = true
	local var_28_1 = arg_28_0.vars.focus_layer
	
	if var_28_1 then
		var_28_1:activeEditorBox(not var_28_0)
	end
	
	arg_28_0.vars.focus_layer = arg_28_1
	
	if arg_28_0.vars.focus_layer then
		arg_28_0.vars.focus_layer:activeEditorBox(var_28_0)
		
		local var_28_2 = arg_28_0.vars.focus_layer:getType()
		
		arg_28_0:setCatrgory(var_28_2, arg_28_0.vars.focus_layer)
	else
		arg_28_0:setCatrgory(arg_28_0.vars.cur_category)
	end
	
	arg_28_0:setFocusLayerViewItem(not arg_28_2)
end

function CustomProfileCardEditor.getFocusLayer(arg_29_0)
	if not arg_29_0.vars or not get_cocos_refid(arg_29_0.vars.wnd) then
		return nil
	end
	
	if not arg_29_0.vars.target_card_id or not arg_29_0.vars.target_card then
		return nil
	end
	
	return arg_29_0.vars.focus_layer
end

function CustomProfileCardEditor.isFocusLayer(arg_30_0, arg_30_1)
	if not arg_30_0.vars or not get_cocos_refid(arg_30_0.vars.wnd) then
		return false
	end
	
	if not arg_30_0.vars.target_card_id or not arg_30_0.vars.target_card then
		return false
	end
	
	if not arg_30_0.vars.focus_layer or not arg_30_1 then
		return false
	end
	
	return arg_30_0.vars.focus_layer == arg_30_1
end

function CustomProfileCardEditor.setListViewMode(arg_31_0, arg_31_1)
	if not arg_31_0.vars or not get_cocos_refid(arg_31_0.vars.wnd) then
		return 
	end
	
	if not arg_31_0.vars.target_card_id or not arg_31_0.vars.target_card then
		return 
	end
	
	if not arg_31_1 then
		return 
	end
	
	if arg_31_0.vars.cur_category == "hero" or arg_31_0.vars.cur_category == "bg" then
		arg_31_0.vars.category_list[arg_31_0.vars.cur_category]:setListViewMode(arg_31_1)
	end
end

function CustomProfileCardEditor.sortLayer(arg_32_0, arg_32_1, arg_32_2)
	if not arg_32_0.vars or not get_cocos_refid(arg_32_0.vars.wnd) then
		return 
	end
	
	if not arg_32_0.vars.target_card or not arg_32_1 then
		return 
	end
	
	if not arg_32_2 then
		balloon_message_with_sound("msg_profile_layer_cant_use")
		
		return 
	end
	
	if arg_32_2 and arg_32_2:isLock() then
		return 
	end
	
	arg_32_0:setFocusLayer(arg_32_2)
	
	if arg_32_1 == "first" then
		arg_32_0.vars.target_card:moveFirstLayer(arg_32_2)
	elseif arg_32_1 == "front" then
		arg_32_0.vars.target_card:moveFrontLayer(arg_32_2)
	elseif arg_32_1 == "back" then
		arg_32_0.vars.target_card:moveBackLayer(arg_32_2)
	elseif arg_32_1 == "last" then
		arg_32_0.vars.target_card:moveLastLayer(arg_32_2)
	end
end

function CustomProfileCardEditor.copyLayer(arg_33_0)
	if not arg_33_0.vars or not get_cocos_refid(arg_33_0.vars.wnd) then
		return 
	end
	
	if not arg_33_0.vars.target_card_id or not arg_33_0.vars.target_card then
		return 
	end
	
	if not arg_33_0.vars.focus_layer then
		balloon_message_with_sound("msg_profile_layer_cant_use")
		
		return 
	else
		local var_33_0 = arg_33_0.vars.focus_layer:getType()
		
		if var_33_0 == "text" or var_33_0 == "shape" then
			arg_33_0:createLayer({
				type = var_33_0,
				load_data = arg_33_0.vars.focus_layer:clone()
			})
		end
	end
end

function CustomProfileCardEditor.openSelectPopup(arg_34_0, arg_34_1)
	if not arg_34_0.vars or not get_cocos_refid(arg_34_1) or table.empty(arg_34_1.item or {}) then
		return 
	end
	
	local var_34_0 = arg_34_1.item
	
	if not var_34_0.type or not var_34_0.id then
		return 
	end
	
	if table.empty(arg_34_0.vars.item_unlock_infos) or not arg_34_0.vars.item_unlock_infos[var_34_0.id] then
		return 
	end
	
	if get_cocos_refid(arg_34_0.vars.select_popup) then
		arg_34_0:closeSelectPopup()
	end
	
	if var_34_0.type == "hero" or var_34_0.type == "bg" or var_34_0.type == "badge" then
		arg_34_0.vars.select_popup = load_dlg("profile_custom_item_locked", true, "wnd", function()
			arg_34_0:closeSelectPopup()
		end)
		arg_34_0.vars.select_popup.btn_select = arg_34_1
		
		if_set_visible(arg_34_0.vars.select_popup, "btn_close", true)
		
		local var_34_1 = arg_34_0.vars.item_unlock_infos[var_34_0.id]
		
		if_set(arg_34_0.vars.select_popup, "txt_title", T(var_34_1.unlock_title))
		if_set_visible(arg_34_0.vars.select_popup, "lock", var_34_1.unlock == "reward" or var_34_1.unlock == "achievement")
		if_set_visible(arg_34_0.vars.select_popup, "n_free", var_34_1.unlock == "reward" or var_34_1.unlock == "achievement")
		if_set_visible(arg_34_0.vars.select_popup, "txt_count", var_34_1.unlock ~= "reward")
		if_set_visible(arg_34_0.vars.select_popup, "n_below", var_34_1.unlock == "reward" or var_34_1.unlock == "achievement")
		
		local var_34_2 = arg_34_0.vars.select_popup:getChildByName("n_below")
		
		if get_cocos_refid(var_34_2) and var_34_2:isVisible() then
			if_set_arrow(arg_34_0.vars.select_popup, "n_arrow")
		end
		
		if_set_visible(arg_34_0.vars.select_popup, "txt_pay", var_34_1.unlock == "purchase")
		if_set_visible(arg_34_0.vars.select_popup, "n_bottom", var_34_1.unlock == "purchase")
		
		if var_34_1.unlock == "reward" or var_34_1.unlock == "achievement" then
			if var_34_0.desc then
				if_set(arg_34_0.vars.select_popup, "txt_free", T(var_34_0.desc))
			end
			
			if var_34_1.mission_id then
				local var_34_3 = ConditionContentsManager:getContents(CONTENTS_TYPE.HIDDEN_MISSION)
				
				if var_34_3 then
					local var_34_4 = var_34_3:getScore(var_34_1.mission_id)
					local var_34_5 = var_34_3:getMaxCount(var_34_1.mission_id)
					local var_34_6 = T("ui_profile_card_achieve_ongoing", {
						now = var_34_4,
						max = var_34_5
					})
					local var_34_7 = var_34_3:getGroup(var_34_1.mission_id)
					
					if var_34_7 and var_34_7.condition == "straitlogin_day_count" then
						local var_34_8 = T("ui_profile_card_badge_popup_attendance", {
							days = AccountData.login_days_cont
						})
						
						var_34_6 = var_34_6 .. " (" .. var_34_8 .. ")"
					end
					
					if_set(arg_34_0.vars.select_popup, "txt_count", var_34_6)
				end
			end
		elseif var_34_1.unlock == "purchase" then
			local var_34_9 = arg_34_0.vars.select_popup:getChildByName("n_bottom")
			local var_34_10 = var_34_1.token
			local var_34_11 = var_34_1.price
			
			if get_cocos_refid(var_34_9) and var_34_10 and var_34_11 then
				if_set(var_34_9, "cost", comma_value(var_34_11))
				
				local var_34_12 = var_34_9:getChildByName("icon_res")
				
				if get_cocos_refid(var_34_12) then
					UIUtil:getRewardIcon(nil, var_34_10, {
						no_bg = true,
						parent = var_34_12
					})
				end
				
				local var_34_13 = var_34_9:getChildByName("btn_yes")
				
				if get_cocos_refid(var_34_13) then
					function var_34_13.callback()
						if Account:getCurrency(var_34_10) < var_34_11 then
							balloon_message_with_sound("mgs_profile_card_lack_token")
							
							return 
						end
						
						query("buy_profile_card_material", {
							m_p_id = var_34_0.id
						})
						
						if arg_34_1.after_buy_callback and type(arg_34_1.after_buy_callback) == "function" then
							arg_34_0.vars.after_buy_callback = arg_34_1.after_buy_callback
						end
					end
				end
			end
		end
		
		local var_34_14
		
		if_set_visible(arg_34_0.vars.select_popup, "n_mob_icon", false)
		if_set_visible(arg_34_0.vars.select_popup, "n_bg", false)
		if_set_visible(arg_34_0.vars.select_popup, "n_badge", false)
		
		if var_34_0.type == "hero" then
			var_34_14 = "n_mob_icon"
		elseif var_34_0.type == "bg" then
			var_34_14 = "n_bg"
		elseif var_34_0.type == "badge" then
			var_34_14 = "n_badge"
		end
		
		if not var_34_14 then
			return 
		end
		
		if_set_visible(arg_34_0.vars.select_popup, var_34_14, true)
		
		if var_34_1.unlock == "reward" and var_34_0.type == "hero" then
			arg_34_0.vars.select_popup:getChildByName(var_34_14):setColor(tocolor("#5b5b5b"))
		else
			if_set_opacity(arg_34_0.vars.select_popup, var_34_14, var_34_1.unlock == "achievement" and 76.5 or 255)
		end
		
		local var_34_15
		local var_34_16
		
		if var_34_0.type == "bg" or var_34_0.type == "badge" then
			var_34_16 = {
				count = 1,
				parent = arg_34_0.vars.select_popup:getChildByName(var_34_14),
				scale = var_34_0.type == "badge" and 0.9 or 1
			}
		elseif var_34_0.type == "hero" then
			var_34_16 = {
				show_grade = true,
				show_color_with_role = true,
				parent = arg_34_0.vars.select_popup:getChildByName(var_34_14)
			}
		end
		
		local var_34_17 = UIUtil:getRewardIcon(1, var_34_0.material_id, var_34_16)
		
		if var_34_0.type == "bg" or var_34_0.type == "badge" then
			if_set_visible(var_34_17, "bg", false)
			
			if var_34_0.content_type and var_34_0.type and var_34_0.icon then
				if_set_sprite(var_34_17, "icon", var_34_0.content_type .. "/" .. var_34_0.type .. "/" .. var_34_0.icon .. ".png")
			end
		end
		
		SceneManager:getRunningPopupScene():addChild(arg_34_0.vars.select_popup)
	end
end

function CustomProfileCardEditor.onClickTapBtn(arg_37_0, arg_37_1)
	if string.empty(arg_37_1) then
		return 
	end
	
	local var_37_0 = string.len("tab_")
	local var_37_1 = string.sub(arg_37_1, var_37_0 + 1, -1)
	
	CustomProfileCardEditor:setCatrgory(var_37_1)
	
	if var_37_1 == "badge" then
		local var_37_2 = HiddenMission:getClearedMissionIds(HIDDEN_MISSION_TYPE.CUSTOM_PROFILE)
		
		if not table.empty(var_37_2) then
			query("complete_hidden_mission", {
				mission_type = HIDDEN_MISSION_TYPE.CUSTOM_PROFILE,
				mission_ids = array_to_json(var_37_2)
			})
		end
	end
end

function CustomProfileCardEditor.onBuyLayerItem(arg_38_0, arg_38_1)
	if not arg_38_1 or not arg_38_1.dec_result or not arg_38_1.result then
		return 
	end
	
	Account:addReward(arg_38_1.dec_result)
	TopBarNew:topbarUpdate(true)
	
	local var_38_0 = {
		single = true,
		buy = true,
		use_drop_icon = true,
		play_reward_data = {
			desc = "",
			title = T("read_mail")
		}
	}
	
	Account:addReward(arg_38_1.result, var_38_0)
	
	if arg_38_0.vars.after_buy_callback and type(arg_38_0.vars.after_buy_callback) == "function" then
		arg_38_0.vars:after_buy_callback()
		
		arg_38_0.vars.after_buy_callback = nil
	end
	
	arg_38_0:closeSelectPopup()
end

function CustomProfileCardEditor.closeSelectPopup(arg_39_0)
	if not arg_39_0.vars or not get_cocos_refid(arg_39_0.vars.select_popup) then
		return 
	end
	
	BackButtonManager:pop("profile_custom_item_locked", {
		dlg = arg_39_0.vars.select_popup
	})
	arg_39_0.vars.select_popup:removeFromParent()
	
	arg_39_0.vars.select_popup = nil
end

function CustomProfileCardEditor.saveProfileCard(arg_40_0)
	if not arg_40_0.vars or not get_cocos_refid(arg_40_0.vars.wnd) then
		return 
	end
	
	if not arg_40_0.vars.target_card_id or not arg_40_0.vars.target_card then
		return 
	end
	
	if Scheduler:findByName("profile_card.updateProfileCardSaveDelay") then
		balloon_message_with_sound("msg_profile_card_save_cooltime")
		
		return 
	end
	
	local var_40_0 = arg_40_0.vars.target_card:save()
	
	if arg_40_0.vars.last_save_card_data and arg_40_0.vars.last_save_card_data == arg_40_0.vars.target_card:save() then
		balloon_message_with_sound("msg_profile_card_no_change")
		
		return 
	end
	
	local var_40_1 = os.time()
	local var_40_2 = ProfileCardConfigData.save_delay or 10
	
	Scheduler:addSlow(arg_40_0.vars.wnd, function()
		if os.time() - var_40_1 >= var_40_2 then
			Scheduler:removeByName("profile_card.updateProfileCardSaveDelay")
			if_set_opacity(arg_40_0.vars.wnd, "btn_save", 255)
		end
	end):setName("profile_card.updateProfileCardSaveDelay")
	if_set_opacity(arg_40_0.vars.wnd, "btn_save", 76.5)
	
	arg_40_0.vars.recent_save_data = {}
	arg_40_0.vars.recent_save_data = {
		slot = arg_40_0.vars.target_card_id,
		data = var_40_0
	}
	
	query("save_profile_card", {
		slot = arg_40_0.vars.target_card_id,
		data = var_40_0
	})
	
	arg_40_0.vars.last_save_card_data = var_40_0
end

function CustomProfileCardEditor.applyRecentSaveData(arg_42_0, arg_42_1)
	if not arg_42_0.vars or table.empty(arg_42_0.vars.recent_save_data) then
		return 
	end
	
	local var_42_0 = arg_42_0.vars.recent_save_data.slot
	local var_42_1 = arg_42_0.vars.recent_save_data.data
	
	CustomProfileCardList:setProfileCardDataBySlot(var_42_0, var_42_1)
	
	if arg_42_1 then
		local var_42_2 = CustomProfileCardList:getPorfileCardDataBySlot(var_42_0)
		
		Account:setMainProfileCard(var_42_2)
	end
	
	arg_42_0.vars.recent_save_data = nil
	arg_42_0.vars.is_exist_modify = false
	
	balloon_message_with_sound("msg_profile_card_save")
end

function CustomProfileCardEditor.setLayerView(arg_43_0, arg_43_1, arg_43_2)
	if not arg_43_0.vars or not get_cocos_refid(arg_43_0.vars.wnd) or not get_cocos_refid(arg_43_0.vars.n_layer) then
		return 
	end
	
	local var_43_0 = 0
	local var_43_1 = arg_43_0.vars.wnd:getChildByName("n_edit")
	
	if get_cocos_refid(var_43_1) then
		local var_43_2 = var_43_1:getChildByName("n_view")
		
		if get_cocos_refid(var_43_2) then
			local var_43_3 = var_43_1:getChildByName("n_view_move")
			
			if get_cocos_refid(var_43_3) then
				if arg_43_1 then
					var_43_0 = var_43_3:getPositionX()
				else
					var_43_0 = var_43_3:getPositionX() - 70
				end
				
				var_43_2:setPositionX(var_43_0)
			end
		end
	end
	
	local var_43_4 = arg_43_0.vars.wnd:getChildByName("LEFT"):getChildByName("n_layer_move")
	
	if get_cocos_refid(var_43_4) then
		if arg_43_1 then
			var_43_0 = var_43_4:getPositionX()
		else
			var_43_0 = var_43_4:getPositionX() - 306
		end
		
		arg_43_0.vars.n_layer:setPositionX(var_43_0)
		arg_43_0.vars.n_layer:setVisible(arg_43_1)
	end
	
	if arg_43_1 and not arg_43_2 then
		arg_43_0:updateLayerView()
	end
end

function CustomProfileCardEditor.isVisibleLayerView(arg_44_0)
	if not arg_44_0.vars or not get_cocos_refid(arg_44_0.vars.wnd) or not get_cocos_refid(arg_44_0.vars.n_layer) then
		return false
	end
	
	return arg_44_0.vars.n_layer:isVisible()
end

function CustomProfileCardEditor.updateLayerView(arg_45_0)
	if not arg_45_0.vars or not get_cocos_refid(arg_45_0.vars.wnd) then
		return 
	end
	
	if not get_cocos_refid(arg_45_0.vars.n_layer) or not get_cocos_refid(arg_45_0.vars.layer_listview) then
		return 
	end
	
	if not arg_45_0.vars.target_card then
		return 
	end
	
	if not arg_45_0:isVisibleLayerView() then
		return 
	end
	
	local var_45_0 = arg_45_0.vars.target_card:getLayerCount()
	
	if_set(arg_45_0.vars.n_layer, "txt_count", tostring(var_45_0) .. "/" .. tostring(ProfileCardConfigData.max_layer_arrangement or 80))
	
	local var_45_1 = arg_45_0.vars.target_card:getLayers()
	local var_45_2 = {}
	
	for iter_45_0, iter_45_1 in pairs(var_45_1) do
		table.insert(var_45_2, iter_45_0, iter_45_1)
	end
	
	table.reverse(var_45_2)
	arg_45_0.vars.layer_listview:removeAllChildren()
	arg_45_0.vars.layer_listview:setDataSource(var_45_2)
	arg_45_0:setFocusLayerViewItem(true)
end

function CustomProfileCardEditor.updateLayerViewItemCursor(arg_46_0, arg_46_1)
	if not arg_46_0.vars or not get_cocos_refid(arg_46_0.vars.wnd) then
		return 
	end
	
	if not get_cocos_refid(arg_46_0.vars.n_layer) or not get_cocos_refid(arg_46_0.vars.layer_listview) then
		return 
	end
	
	if not arg_46_0:isVisibleLayerView() or not arg_46_1 then
		return 
	end
	
	local var_46_0 = arg_46_0.vars.layer_listview:getControl(arg_46_1)
	local var_46_1
	
	if get_cocos_refid(var_46_0) then
		var_46_1 = arg_46_1:isLock()
		
		if var_46_1 then
			if arg_46_0.vars.cur_layer_card and arg_46_0.vars.cur_layer_card == var_46_0 then
				arg_46_0.vars.cur_layer_card = nil
			end
			
			if_set_visible(var_46_0, "n_cursor", false)
		else
			if_set_visible(arg_46_0.vars.cur_layer_card, "n_cursor", false)
			
			arg_46_0.vars.cur_layer_card = var_46_0
			
			if_set_visible(arg_46_0.vars.cur_layer_card, "n_cursor", true)
		end
		
		for iter_46_0, iter_46_1 in pairs(var_46_0:getChildren()) do
			if get_cocos_refid(iter_46_1) then
				if iter_46_1:getName() == "btn_front" or iter_46_1:getName() == "btn_back" then
					iter_46_1:setOpacity(var_46_1 and 76.5 or 255)
				end
				
				if iter_46_1:getName() == "btn_select" then
					iter_46_1:setColor(var_46_1 and tocolor("#5b5b5b") or cc.c3b(255, 255, 255))
				end
			end
		end
	end
end

function CustomProfileCardEditor.setFocusLayerViewItem(arg_47_0, arg_47_1)
	if not arg_47_0.vars or not get_cocos_refid(arg_47_0.vars.wnd) or not get_cocos_refid(arg_47_0.vars.layer_listview) then
		return 
	end
	
	if not arg_47_0:isVisibleLayerView() then
		return 
	end
	
	if arg_47_0.vars.focus_layer then
		local var_47_0 = arg_47_0.vars.layer_listview:getDataSource()
		
		if table.empty(var_47_0) then
			return 
		end
		
		for iter_47_0, iter_47_1 in pairs(var_47_0) do
			if arg_47_0.vars.focus_layer == iter_47_1 then
				if arg_47_1 then
					arg_47_0.vars.layer_listview:jumpToIndex(iter_47_0)
				end
				
				local var_47_1 = arg_47_0.vars.layer_listview:getControl(iter_47_1)
				
				if get_cocos_refid(var_47_1) then
					arg_47_0:updateLayerViewItemCursor(iter_47_1)
					
					return 
				end
			end
		end
	elseif arg_47_0.vars.cur_layer_card then
		if_set_visible(arg_47_0.vars.cur_layer_card, "n_cursor", false)
		
		arg_47_0.vars.cur_layer_card = nil
	end
end

function CustomProfileCardEditor.deleteLayerItem(arg_48_0)
	if not arg_48_0.vars or not get_cocos_refid(arg_48_0.vars.wnd) or not get_cocos_refid(arg_48_0.vars.layer_listview) then
		return 
	end
	
	if not arg_48_0:isVisibleLayerView() or not arg_48_0.vars.target_card or not arg_48_0.vars.focus_layer then
		return 
	end
	
	if arg_48_0.vars.focus_layer:isLock() then
		return 
	end
	
	local var_48_0 = arg_48_0.vars.focus_layer:getOrder()
	local var_48_1 = arg_48_0.vars.focus_layer:getType()
	
	arg_48_0.vars.target_card:deleteLayer({
		order = var_48_0,
		type = var_48_1
	})
end

function CustomProfileCardEditor.updateLayerListviewItem(arg_49_0, arg_49_1, arg_49_2)
	if not arg_49_0.vars or not get_cocos_refid(arg_49_0.vars.wnd) then
		return 
	end
	
	if not get_cocos_refid(arg_49_0.vars.n_layer) or not get_cocos_refid(arg_49_0.vars.layer_listview) then
		return 
	end
	
	if not get_cocos_refid(arg_49_1) or not arg_49_2 then
		return 
	end
	
	local var_49_0 = arg_49_1:getChildByName("n_blind")
	
	if get_cocos_refid(var_49_0) then
		local function var_49_1(arg_50_0)
			if not get_cocos_refid(arg_50_0) then
				return 
			end
			
			local var_50_0 = arg_50_0:getName()
			local var_50_1 = false
			
			if var_50_0 == "btn_off" then
				var_50_1 = false
			elseif var_50_0 == "btn_on" then
				var_50_1 = true
			end
			
			arg_49_2:setVisible(var_50_1)
			
			local var_50_2 = arg_49_2:isVisible()
			
			if_set_visible(var_49_0, "btn_off", var_50_2)
			if_set_visible(var_49_0, "btn_on", not var_50_2)
			
			if not arg_49_2:isLock() then
				arg_49_0:setFocusLayer(arg_49_2)
			end
			
			arg_49_0:updateLayerViewItemCursor(arg_49_2)
		end
		
		local var_49_2 = var_49_0:getChildByName("btn_off")
		
		var_49_2.is_layer_view = true
		var_49_2.callback = var_49_1
		
		local var_49_3 = var_49_0:getChildByName("btn_on")
		
		var_49_3.is_layer_view = true
		var_49_3.callback = var_49_1
		
		local var_49_4 = arg_49_2:isVisible()
		
		if_set_visible(var_49_0, "btn_off", var_49_4)
		if_set_visible(var_49_0, "btn_on", not var_49_4)
	end
	
	local var_49_5 = arg_49_1:getChildByName("n_lock")
	
	if get_cocos_refid(var_49_5) then
		local function var_49_6(arg_51_0)
			if not get_cocos_refid(arg_51_0) then
				return 
			end
			
			local var_51_0 = arg_51_0:getName()
			local var_51_1 = false
			
			if var_51_0 == "btn_off" then
				var_51_1 = true
			elseif var_51_0 == "btn_on" then
				var_51_1 = false
			end
			
			arg_49_2:setLock(var_51_1)
			
			local var_51_2 = arg_49_2:isLock()
			
			if_set_visible(var_49_5, "btn_off", not var_51_2)
			if_set_visible(var_49_5, "btn_on", var_51_2)
			
			if var_51_1 then
				if arg_49_0.vars.focus_layer == arg_49_2 then
					arg_49_0:setFocusLayer(nil)
				end
			else
				arg_49_0:setFocusLayer(arg_49_2)
			end
			
			arg_49_0:updateLayerViewItemCursor(arg_49_2)
		end
		
		local var_49_7 = var_49_5:getChildByName("btn_off")
		
		var_49_7.is_layer_view = true
		var_49_7.callback = var_49_6
		
		local var_49_8 = var_49_5:getChildByName("btn_on")
		
		var_49_8.is_layer_view = true
		var_49_8.callback = var_49_6
		
		local var_49_9 = arg_49_2:isLock()
		
		if_set_visible(var_49_5, "btn_off", not var_49_9)
		if_set_visible(var_49_5, "btn_on", var_49_9)
		
		if var_49_9 then
			for iter_49_0, iter_49_1 in pairs(arg_49_1:getChildren()) do
				if get_cocos_refid(iter_49_1) then
					if iter_49_1:getName() == "btn_front" or iter_49_1:getName() == "btn_back" then
						iter_49_1:setOpacity(76.5)
					end
					
					if iter_49_1:getName() == "btn_select" then
						iter_49_1:setColor(tocolor("#5b5b5b"))
					end
				end
			end
		end
	end
	
	local var_49_10 = arg_49_1:getChildByName("btn_front")
	
	if get_cocos_refid(var_49_10) then
		var_49_10.is_layer_view = true
		var_49_10.layer = arg_49_2
	end
	
	local var_49_11 = arg_49_1:getChildByName("btn_back")
	
	if get_cocos_refid(var_49_11) then
		var_49_11.is_layer_view = true
		var_49_11.layer = arg_49_2
	end
	
	local var_49_12 = arg_49_1:getChildByName("btn_select")
	
	if get_cocos_refid(var_49_12) then
		var_49_12.is_layer_view = true
		var_49_12.layer = arg_49_2
	end
	
	if arg_49_0.vars.focus_layer == arg_49_2 then
		arg_49_0:updateLayerViewItemCursor(arg_49_2)
	end
	
	function arg_49_2.sync_layer_view_callback()
		arg_49_0:updateLayerListviewItem(arg_49_1, arg_49_2)
	end
	
	local var_49_13 = arg_49_2:getType()
	
	if var_49_13 == "hero" then
		local var_49_14 = arg_49_1:getChildByName("n_hero_card")
		
		var_49_14:setVisible(true)
		var_49_14:removeAllChildren()
		
		local var_49_15 = load_control("wnd/profile_custom_hero_card.csb")
		
		if_set_visible(var_49_15, "btn_select", false)
		
		local var_49_16 = var_49_15:getChildByName("mob_icon")
		local var_49_17
		local var_49_18 = arg_49_2:getId()
		
		if arg_49_2:isSDModel() then
			local var_49_19 = CustomProfileCardHero:getSDModelDataById(var_49_18)
			
			if not table.empty(var_49_19) then
				local var_49_20 = var_49_19.bind_unit_id ~= nil
				local var_49_21 = UIUtil:getUserIcon(var_49_19.bind_unit_info or UNIT:create({
					code = "c1001"
				}), {
					no_lv = true,
					scale = 1.3,
					parent = var_49_16,
					base_grade = var_49_20,
					no_grade = not var_49_20,
					show_color = var_49_20,
					no_role = not var_49_20
				})
				
				if_set_visible(var_49_21, "n_element", var_49_20)
				if_set_sprite(var_49_21, "icon_element", var_49_20 and UIUtil:getColorIcon(var_49_19.bind_unit_info))
				if_set_sprite(var_49_21, "face", var_49_19.icon .. ".png")
			end
		else
			local var_49_22 = UNIT:create({
				code = var_49_18
			})
			local var_49_23 = UIUtil:getUserIcon(var_49_22, {
				base_grade = true,
				scale = 1.3,
				no_lv = true,
				show_color = true,
				parent = var_49_16
			})
			
			if_set_visible(var_49_23, "n_element", true)
			if_set_sprite(var_49_23, "icon_element", UIUtil:getColorIcon(var_49_22))
		end
		
		var_49_14:addChild(var_49_15)
	elseif var_49_13 == "bg" then
		local var_49_24
		local var_49_25
		
		if arg_49_2:isIllust() then
			var_49_24 = "n_illust_card"
			var_49_25 = load_control("wnd/profile_custom_illust_card.csb")
			
			if_set_visible(var_49_25, "img_nodata", false)
			if_set_visible(var_49_25, "btn_select", false)
			if_set_visible(var_49_25, "n_illust", true)
			
			local var_49_26 = arg_49_2:getId()
			local var_49_27 = DB("dic_data_illust", var_49_26, "illust")
			local var_49_28 = var_49_25:getChildByName("n_illust")
			local var_49_29 = var_49_25:getChildByName("img")
			
			if get_cocos_refid(var_49_29) then
				var_49_29:removeFromParent()
			end
			
			if string.find(var_49_27, ".cfx") then
				var_49_29 = CACHE:getEffect(var_49_27, "effect")
				
				local var_49_30 = {
					effect = var_49_29,
					fn = var_49_27
				}
				
				var_49_30.x = 109
				var_49_30.y = 62
				var_49_30.scale = 0.23
				var_49_30.layer = var_49_28
				
				EffectManager:EffectPlay(var_49_30)
			else
				local var_49_31
				
				if arg_49_2.thumbnail then
					var_49_31 = "item/art/" .. arg_49_2.thumbnail .. ".png"
				else
					var_49_31 = UIUtil:getIllustPath("story/bg/", var_49_27)
				end
				
				if get_cocos_refid(var_49_29) then
					local var_49_32 = cc.Sprite:create(var_49_31)
					
					if get_cocos_refid(var_49_32) then
						var_49_32:setPosition(109, 62)
						var_49_32:setScale(0.23)
						var_49_32:setAnchorPoint(0.5, 0.5)
						var_49_28:addChild(var_49_32)
					end
				end
			end
		else
			var_49_24 = "n_bg_card"
			var_49_25 = load_control("wnd/profile_custom_bg_card.csb")
			
			if_set_visible(var_49_25, "btn_select", false)
			
			local var_49_33 = arg_49_2:getId()
			local var_49_34 = DB("item_material_profile", var_49_33, {
				"material_id"
			})
			local var_49_35 = DBT("item_material", var_49_34, {
				"ma_type",
				"ma_type2",
				"drop_icon"
			})
			
			if var_49_35.ma_type and var_49_35.ma_type2 and var_49_35.drop_icon then
				if_set_sprite(var_49_25, "n_bg", var_49_35.ma_type .. "/" .. var_49_35.ma_type2 .. "/" .. var_49_35.drop_icon .. ".png")
			end
		end
		
		local var_49_36 = arg_49_1:getChildByName(var_49_24)
		
		var_49_36:setVisible(true)
		var_49_36:addChild(var_49_25)
	elseif var_49_13 == "badge" then
		if_set_visible(arg_49_1, "n_badge", true)
		
		local var_49_37 = arg_49_2:getId()
		local var_49_38 = DB("item_material_profile", var_49_37, {
			"material_id"
		})
		local var_49_39 = DBT("item_material", var_49_38, {
			"ma_type",
			"ma_type2",
			"drop_icon"
		})
		
		if var_49_39.ma_type and var_49_39.ma_type2 and var_49_39.drop_icon then
			if_set_sprite(arg_49_1, "n_badge", var_49_39.ma_type .. "/" .. var_49_39.ma_type2 .. "/" .. var_49_39.drop_icon .. ".png")
		end
	elseif var_49_13 == "shape" then
		local var_49_40 = arg_49_1:getChildByName("n_shape_card")
		
		var_49_40:setVisible(true)
		var_49_40:removeAllChildren()
		
		local var_49_41 = load_control("wnd/profile_custom_shape_card.csb")
		
		if_set_visible(var_49_41, "btn_select", false)
		
		local var_49_42 = arg_49_2:getId()
		local var_49_43 = DB("item_material_profile", var_49_42, {
			"material_id"
		})
		local var_49_44 = DBT("item_material", var_49_43, {
			"ma_type",
			"ma_type2",
			"drop_icon"
		})
		
		if var_49_44.ma_type and var_49_44.ma_type2 and var_49_44.drop_icon then
			if_set_sprite(var_49_41, "n_shape_s", var_49_44.ma_type .. "/" .. var_49_44.ma_type2 .. "/" .. var_49_44.drop_icon .. ".png")
			if_set_color(var_49_41, "n_shape_s", arg_49_2:getShapeColor())
		end
		
		var_49_40:addChild(var_49_41)
	elseif var_49_13 == "text" then
		if_set_visible(arg_49_1, "txt_normal", false)
		if_set_visible(arg_49_1, "txt_bold", false)
		
		local var_49_45
		local var_49_46 = arg_49_2:isBlod() and "txt_bold" or "txt_normal"
		
		if_set_visible(arg_49_1, var_49_46, true)
		
		local var_49_47 = arg_49_2:getText()
		local var_49_48 = utf8sub(var_49_47, 1, 2)
		
		if_set(arg_49_1, var_49_46, var_49_48)
		if_set_color(arg_49_1, var_49_46, arg_49_2:getFontColor())
	end
end

function CustomProfileCardEditor.showMissionRewardPopup(arg_53_0, arg_53_1)
	if not arg_53_0.vars or not arg_53_0.vars.item_unlock_infos or not arg_53_1 then
		return 
	end
	
	local var_53_0 = {}
	
	for iter_53_0, iter_53_1 in pairs(arg_53_0.vars.item_unlock_infos) do
		if iter_53_1.mission_id and table.find(arg_53_1, iter_53_1.mission_id) then
			table.insert(var_53_0, {
				count = 1,
				code = iter_53_1.material_id
			})
		end
	end
	
	if not table.empty(var_53_0) then
		Dialog:msgRewards(T("ui_title_profile_get_item"), {
			no_bg = true,
			scale = 0.95,
			rewards = var_53_0
		})
	end
	
	arg_53_0:setCatrgory("badge")
end

function CustomProfileCardEditor.onUpdateUI(arg_54_0)
	if arg_54_0.vars and get_cocos_refid(arg_54_0.vars.wnd) then
		if get_cocos_refid(arg_54_0.vars.select_popup) then
			if HiddenMission:isExistClearedMission(HIDDEN_MISSION_TYPE.CUSTOM_PROFILE) then
				arg_54_0:closeSelectPopup()
				arg_54_0:onClickTapBtn("btn_badge")
			else
				arg_54_0:openSelectPopup(arg_54_0.vars.select_popup.btn_select)
			end
		elseif arg_54_0.vars.category_list and arg_54_0.vars.category_list.badge then
			arg_54_0.vars.category_list.badge:updateTapNoti()
		end
	end
end

function CustomProfileCardEditor.getLayerCommand(arg_55_0)
	return arg_55_0.LayerCommand
end

function CustomProfileCardEditor.LayerCommand.init(arg_56_0)
	arg_56_0.vars = {}
	arg_56_0.vars.max_count = 20
	arg_56_0.vars.undo_list = {}
	arg_56_0.vars.redo_list = {}
end

function CustomProfileCardEditor.LayerCommand.release(arg_57_0)
	if not arg_57_0.vars then
		return 
	end
	
	arg_57_0.vars.undo_list = nil
	arg_57_0.vars.redo_list = nil
end

function CustomProfileCardEditor.LayerCommand.isEmptyUndo(arg_58_0)
	if not arg_58_0.vars or not arg_58_0.vars.undo_list then
		return true
	end
	
	if table.empty(arg_58_0.vars.undo_list) then
		return true
	end
	
	return false
end

function CustomProfileCardEditor.LayerCommand.isEmptyRedo(arg_59_0)
	if not arg_59_0.vars or not arg_59_0.vars.redo_list then
		return true
	end
	
	if table.empty(arg_59_0.vars.redo_list) then
		return true
	end
	
	return false
end

function CustomProfileCardEditor.LayerCommand.pushUndo(arg_60_0, arg_60_1, arg_60_2)
	if not arg_60_0.vars or not arg_60_0.vars.undo_list or not arg_60_1 then
		return 
	end
	
	if table.count(arg_60_0.vars.undo_list) >= arg_60_0.vars.max_count then
		table.remove(arg_60_0.vars.undo_list, arg_60_0.vars.max_count)
	end
	
	table.insert(arg_60_0.vars.undo_list, 1, arg_60_1)
	
	if arg_60_2 then
		arg_60_0.vars.redo_list = {}
	end
	
	CustomProfileCardEditor:updateUndoAndRedoButtons()
end

function CustomProfileCardEditor.LayerCommand.pushRedo(arg_61_0, arg_61_1)
	if not arg_61_0.vars or not arg_61_0.vars.redo_list or not arg_61_1 then
		return 
	end
	
	table.insert(arg_61_0.vars.redo_list, 1, arg_61_1)
	CustomProfileCardEditor:updateUndoAndRedoButtons()
end

function CustomProfileCardEditor.LayerCommand.doCommand(arg_62_0, arg_62_1)
	if not arg_62_0.vars or not arg_62_1 then
		return 
	end
	
	local var_62_0 = string.len("btn_")
	local var_62_1 = string.sub(arg_62_1, var_62_0 + 1, -1)
	
	if var_62_1 == "before" then
		arg_62_0:undo()
	elseif var_62_1 == "after" then
		arg_62_0:redo()
	end
end

function CustomProfileCardEditor.LayerCommand.undo(arg_63_0)
	if not arg_63_0.vars or not arg_63_0.vars.undo_list then
		return 
	end
	
	if table.empty(arg_63_0.vars.undo_list) then
		balloon_message_with_sound("msg_profile_card_undo_limit")
		
		return 
	end
	
	local var_63_0 = table.remove(arg_63_0.vars.undo_list, 1)
	
	var_63_0:undo_func()
	
	local var_63_1 = var_63_0.layer
	
	if var_63_1 then
		CustomProfileCardEditor:setFocusLayer(var_63_1)
		
		if var_63_1.sync_layer_view_callback and type(var_63_1.sync_layer_view_callback) == "function" then
			var_63_1:sync_layer_view_callback()
		end
	end
	
	arg_63_0:pushRedo(var_63_0)
	CustomProfileCardEditor:updateUndoAndRedoButtons()
end

function CustomProfileCardEditor.LayerCommand.redo(arg_64_0)
	if not arg_64_0.vars or not arg_64_0.vars.redo_list then
		return 
	end
	
	if table.empty(arg_64_0.vars.redo_list) then
		balloon_message_with_sound("msg_profile_card_redo_limit")
		
		return 
	end
	
	local var_64_0 = table.remove(arg_64_0.vars.redo_list, 1)
	
	var_64_0:redo_func()
	
	local var_64_1 = var_64_0.layer
	
	if var_64_1 then
		CustomProfileCardEditor:setFocusLayer(var_64_1)
		
		if var_64_1.sync_layer_view_callback and type(var_64_1.sync_layer_view_callback) == "function" then
			var_64_1:sync_layer_view_callback()
		end
	end
	
	arg_64_0:pushUndo(var_64_0)
	CustomProfileCardEditor:updateUndoAndRedoButtons()
end
