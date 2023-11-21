CustomProfileCardList = {}
CustomProfileCardList.scrollview = {}

copy_functions(ScrollView, CustomProfileCardList.scrollview)

local var_0_0 = 5

function MsgHandler.get_profile_card_list(arg_1_0)
	if arg_1_0 and arg_1_0.res and arg_1_0.res == "ok" then
		CustomProfileCardList:setProfileCardDataList(arg_1_0.card_docs)
		CustomProfileCardList:open()
	end
end

function MsgHandler.copy_profile_card(arg_2_0)
	if arg_2_0 and arg_2_0.res and arg_2_0.res == "ok" then
		CustomProfileCardList:copyProfileCard(arg_2_0)
	end
end

function MsgHandler.delete_profile_card(arg_3_0)
	if arg_3_0 and arg_3_0.res and arg_3_0.res == "ok" then
		CustomProfileCardList:deleteProfileCard(arg_3_0)
	end
end

function MsgHandler.change_main_profile_card(arg_4_0)
	if arg_4_0 and arg_4_0.res and arg_4_0.res == "ok" then
		CustomProfileCardList:setMainProfileCard(arg_4_0)
	end
end

function HANDLER.user_profile_custom_choose(arg_5_0, arg_5_1)
	if arg_5_1 == "btn_close" then
		CustomProfileCardList:close()
	elseif arg_5_1 == "btn_copy" or arg_5_1 == "btn_delete" or arg_5_1 == "btn_m_select" or arg_5_1 == "btn_m_select_on" then
		local var_5_0 = string.len("btn_")
		local var_5_1 = string.sub(arg_5_1, var_5_0 + 1, -1)
		
		CustomProfileCardList:openProfileCardWarning(var_5_1)
	elseif arg_5_1 == "btn_edit" then
		CustomProfileCardList:openEditor()
	end
end

function HANDLER.user_profile_custom_choose_card(arg_6_0, arg_6_1)
	if arg_6_1 == "btn_select" and not table.empty(arg_6_0.item) then
		CustomProfileCardList:setSeletedID(arg_6_0.item)
	elseif arg_6_1 == "btn_making" then
		CustomProfileCardList:createNewProfileCard()
	elseif arg_6_1 == "btn_expand" and arg_6_0.card_data then
		CustomProfileCardZoom:open(arg_6_0.card_data)
	end
end

function HANDLER.user_profile_custom_choose_zoom(arg_7_0, arg_7_1)
	if arg_7_1 == "btn_close" then
		CustomProfileCardZoom:close()
	end
end

function CustomProfileCardList.open(arg_8_0)
	if not Profile:isVisible() then
		return 
	end
	
	arg_8_0.vars = {}
	arg_8_0.vars.wnd = load_dlg("user_profile_custom_choose", true, "wnd", function()
		arg_8_0:close()
	end)
	
	SceneManager:getRunningPopupScene():addChild(arg_8_0.vars.wnd)
	arg_8_0:initScrollView()
	arg_8_0:updateProfileCardList()
end

function CustomProfileCardList.close(arg_10_0)
	if not arg_10_0.vars or not get_cocos_refid(arg_10_0.vars.wnd) then
		return 
	end
	
	local var_10_0 = BackButtonManager:getTopInfo()
	
	if var_10_0 and var_10_0.dlg and var_10_0.dlg ~= arg_10_0.vars.wnd then
		return 
	end
	
	BackButtonManager:pop({
		id = "user_profile_custom_choose",
		dlg = arg_10_0.vars.wnd
	})
	arg_10_0.scrollview:clearScrollViewItems()
	arg_10_0.vars.wnd:removeFromParent()
	
	arg_10_0.vars.wnd = nil
	arg_10_0.vars = nil
end

function CustomProfileCardList.setVisible(arg_11_0, arg_11_1)
	if not arg_11_0.vars or not get_cocos_refid(arg_11_0.vars.wnd) then
		return 
	end
	
	arg_11_0.vars.wnd:setVisible(arg_11_1)
	
	if arg_11_1 then
		arg_11_0:updateProfileCardList()
	end
end

function CustomProfileCardList.initScrollView(arg_12_0)
	if not arg_12_0.vars or not get_cocos_refid(arg_12_0.vars.wnd) then
		return 
	end
	
	arg_12_0.scrollview:initScrollView(arg_12_0.vars.wnd:getChildByName("n_scrollview"), 253, 360, {
		force_horizontal = true,
		fit_height = true
	})
end

function CustomProfileCardList.setProfileCardDataList(arg_13_0, arg_13_1)
	if not arg_13_0.data then
		arg_13_0.data = {}
	end
	
	local var_13_0 = arg_13_1 or {}
	local var_13_1 = Account:getMainProfileCard()
	
	if not table.empty(var_13_1) then
		table.insert(var_13_0, var_13_1)
	end
	
	arg_13_0.data.card_data_list = var_13_0
	arg_13_0.data.main_card_id = Account:getMainProfileCardSlot()
end

function CustomProfileCardList.getProfileCardList(arg_14_0)
	if not arg_14_0.data then
		return nil
	end
	
	return arg_14_0.data.card_data_list
end

function CustomProfileCardList.getPorfileCardDataBySlot(arg_15_0, arg_15_1)
	if not arg_15_0.data or not arg_15_1 then
		return nil
	end
	
	for iter_15_0, iter_15_1 in pairs(arg_15_0.data.card_data_list or {}) do
		if iter_15_1.slot and iter_15_1.slot == arg_15_1 then
			return iter_15_1
		end
	end
	
	return nil
end

function CustomProfileCardList.setProfileCardDataBySlot(arg_16_0, arg_16_1, arg_16_2)
	if not arg_16_0.data or not arg_16_1 or not arg_16_2 then
		return 
	end
	
	local var_16_0 = arg_16_0:getPorfileCardDataBySlot(arg_16_1)
	local var_16_1 = os.time()
	
	if var_16_0 then
		var_16_0.data = arg_16_2
		var_16_0.updated = var_16_1
		
		return 
	end
	
	table.insert(arg_16_0.data.card_data_list, {
		slot = arg_16_1,
		data = arg_16_2,
		updated = var_16_1
	})
end

function CustomProfileCardList.getEmptySlot(arg_17_0)
	if table.empty(arg_17_0.data.card_data_list) then
		return 1
	end
	
	local var_17_0 = {}
	
	for iter_17_0 = 1, 5 do
		table.insert(var_17_0, iter_17_0, false)
	end
	
	for iter_17_1, iter_17_2 in pairs(arg_17_0.data.card_data_list) do
		if iter_17_2.slot and not var_17_0[iter_17_2.slot] then
			var_17_0[iter_17_2.slot] = true
		end
	end
	
	for iter_17_3, iter_17_4 in pairs(var_17_0) do
		if not iter_17_4 then
			return iter_17_3
		end
	end
	
	return nil
end

function CustomProfileCardList.updateProfileCardList(arg_18_0)
	if not arg_18_0.vars or not get_cocos_refid(arg_18_0.vars.wnd) then
		return 
	end
	
	local var_18_0 = {}
	
	for iter_18_0, iter_18_1 in pairs(arg_18_0.data.card_data_list or {}) do
		table.insert(var_18_0, iter_18_1)
	end
	
	if not table.empty(var_18_0) then
		table.sort(var_18_0, function(arg_19_0, arg_19_1)
			return arg_19_0.updated > arg_19_1.updated
		end)
	end
	
	local var_18_1 = table.count(var_18_0)
	
	if not (var_18_1 >= var_0_0) then
		local var_18_2 = {
			is_new_card = true
		}
		
		table.insert(var_18_0, 1, var_18_2)
	end
	
	arg_18_0.scrollview:clearScrollViewItems()
	arg_18_0.scrollview:setScrollViewItems(var_18_0)
	if_set(arg_18_0.vars.wnd, "txt_count", T("ui_profile_index_max", {
		number = var_18_1,
		number1 = var_0_0
	}))
	
	arg_18_0.vars.seleted_id = nil
	
	arg_18_0:updateButtons()
end

function CustomProfileCardList.updateButtons(arg_20_0)
	if not arg_20_0.vars or not get_cocos_refid(arg_20_0.vars.wnd) then
		return 
	end
	
	if not arg_20_0.data then
		return 
	end
	
	local var_20_0 = 76.5
	
	if_set_opacity(arg_20_0.vars.wnd, "btn_copy", arg_20_0.vars.seleted_id and 255 or var_20_0)
	if_set_opacity(arg_20_0.vars.wnd, "btn_edit", arg_20_0.vars.seleted_id and 255 or var_20_0)
	
	local var_20_1 = arg_20_0.data.main_card_id or Account:getMainProfileCardSlot()
	local var_20_2 = arg_20_0.vars.seleted_id and var_20_1 and arg_20_0.vars.seleted_id == var_20_1
	
	if_set_opacity(arg_20_0.vars.wnd, "btn_delete", not (not var_20_2 and arg_20_0.vars.seleted_id) and var_20_0 or 255)
	if_set_visible(arg_20_0.vars.wnd, "btn_m_select", not var_20_2)
	if_set_opacity(arg_20_0.vars.wnd, "btn_m_select", not arg_20_0.vars.seleted_id and var_20_0 or 255)
	if_set_visible(arg_20_0.vars.wnd, "btn_m_select_on", var_20_2)
	
	local var_20_3 = arg_20_0.vars.wnd:getChildByName("btn_edit")
	
	if get_cocos_refid(var_20_3) then
		if_set_visible(var_20_3, "icon_noti", HiddenMission:isExistClearedMission(HIDDEN_MISSION_TYPE.CUSTOM_PROFILE))
	end
end

function CustomProfileCardList.createNewProfileCard(arg_21_0)
	if not arg_21_0.vars or not get_cocos_refid(arg_21_0.vars.wnd) then
		return 
	end
	
	local var_21_0 = arg_21_0:getEmptySlot()
	
	if not var_21_0 then
		return 
	end
	
	CustomProfileCardEditor:open({
		id = var_21_0
	})
end

function CustomProfileCardList.openProfileCardWarning(arg_22_0, arg_22_1)
	if not arg_22_0.vars or not arg_22_0.data or not arg_22_1 then
		return 
	end
	
	if table.empty(arg_22_0.data.card_data_list) then
		balloon_message_with_sound("msg_profile_have_no_card")
		
		return 
	end
	
	if not arg_22_0:isSeletedCard() then
		balloon_message_with_sound("msg_profile_card_must_select")
		
		return 
	end
	
	local var_22_0 = table.count(arg_22_0.data.card_data_list)
	local var_22_1 = arg_22_0.data.main_card_id or Account:getMainProfileCardSlot()
	local var_22_2
	local var_22_3
	
	if arg_22_1 == "copy" then
		if var_22_0 >= var_0_0 then
			balloon_message_with_sound("msg_profile_card_no_more")
			
			return 
		end
		
		var_22_2 = T("ui_profile_card_copy_popup_title")
		var_22_3 = T("ui_profile_card_copy")
	elseif arg_22_1 == "delete" then
		if var_22_1 and arg_22_0.vars.seleted_id == var_22_1 then
			balloon_message_with_sound("msg_profile_card_main_cant_delete")
			
			return 
		end
		
		if var_22_0 <= 1 then
			balloon_message_with_sound("msg_profile_card_must_have_one")
			
			return 
		end
		
		var_22_2 = T("ui_profile_card_delete_popup_title")
		var_22_3 = T("ui_profile_card_delete")
	elseif arg_22_1 == "m_select" then
		var_22_2 = T("ui_profile_card_main_popup_title")
		var_22_3 = T("ui_profile_card_main")
	elseif arg_22_1 == "m_select_on" then
		balloon_message_with_sound("msg_profile_card_already_main")
		
		return 
	else
		return 
	end
	
	Dialog:msgBox(var_22_3, {
		yesno = true,
		title = var_22_2,
		handler = function()
			if not arg_22_0.vars or not arg_22_0.data or not arg_22_1 then
				return 
			end
			
			local var_23_0 = arg_22_0.vars.seleted_id
			
			if not var_23_0 then
				return 
			end
			
			if arg_22_1 == "copy" then
				local var_23_1 = arg_22_0:getEmptySlot()
				
				if not var_23_1 then
					Log.e("카드 최대 개수를 넘겼습니다. 예외처리를 무시하는 조건이 있는지 테스트 필요!")
					
					return 
				end
				
				query("copy_profile_card", {
					copy_slot = var_23_0,
					new_slot = var_23_1
				})
			elseif arg_22_1 == "delete" then
				query("delete_profile_card", {
					delete_slot = var_23_0
				})
			elseif arg_22_1 == "m_select" then
				query("change_main_profile_card", {
					slot = var_23_0
				})
			end
			
			arg_22_0:updateProfileCardList()
		end
	})
end

function CustomProfileCardList.copyProfileCard(arg_24_0, arg_24_1)
	if not arg_24_1.copy_slot or not arg_24_1.new_slot then
		return 
	end
	
	if not arg_24_0.vars or not get_cocos_refid(arg_24_0.vars.wnd) then
		return 
	end
	
	if table.empty(arg_24_0.data.card_data_list) then
		return 
	end
	
	local var_24_0 = arg_24_0:getPorfileCardDataBySlot(arg_24_1.copy_slot)
	
	if var_24_0 then
		local var_24_1 = table.clone(var_24_0)
		
		var_24_1.slot = arg_24_1.new_slot
		var_24_1.updated = os.time()
		
		table.insert(arg_24_0.data.card_data_list, var_24_1)
	end
	
	arg_24_0:updateProfileCardList()
end

function CustomProfileCardList.deleteProfileCard(arg_25_0, arg_25_1)
	if not arg_25_1.delete_slot then
		return 
	end
	
	if not arg_25_0.vars or not get_cocos_refid(arg_25_0.vars.wnd) then
		return 
	end
	
	if table.empty(arg_25_0.data.card_data_list) then
		return 
	end
	
	for iter_25_0, iter_25_1 in pairs(arg_25_0.data.card_data_list or {}) do
		if iter_25_1.slot and iter_25_1.slot == arg_25_1.delete_slot then
			table.remove(arg_25_0.data.card_data_list, iter_25_0)
		end
	end
	
	arg_25_0:updateProfileCardList()
end

function CustomProfileCardList.setMainProfileCard(arg_26_0, arg_26_1)
	if not arg_26_1.user_opt or arg_26_1.user_opt < 1000 then
		return 
	end
	
	if not arg_26_0.vars or not get_cocos_refid(arg_26_0.vars.wnd) then
		return 
	end
	
	local var_26_0 = getExtractedUserOption(arg_26_1.user_opt, 4)
	
	if not var_26_0 then
		return 
	end
	
	local var_26_1 = arg_26_0.data.main_card_id or Account:getMainProfileCardSlot()
	
	if not var_26_1 then
		Log.e("이전 대표 카드 정보가 있어야 교환 가능!!")
		
		return 
	end
	
	if var_26_1 == var_26_0 then
		Log.e("이미 대표 카드로 설정된 카드입니다. 예외처리를 무시하는 조건이 있는지 테스트 필요!")
		
		return 
	end
	
	local var_26_2 = arg_26_0:getPorfileCardDataBySlot(var_26_0)
	
	Account:setMainProfileCard(var_26_2)
	
	arg_26_0.data.main_card_id = var_26_0
	
	balloon_message_with_sound("msg_profile_card_select_main")
	arg_26_0:updateProfileCardList()
	Profile:updateProfileCard()
end

function CustomProfileCardList.openEditor(arg_27_0)
	if not arg_27_0.vars or not get_cocos_refid(arg_27_0.vars.wnd) then
		return 
	end
	
	if table.empty(arg_27_0.data.card_data_list) then
		balloon_message_with_sound("msg_profile_have_no_card")
		
		return 
	end
	
	if not arg_27_0:isSeletedCard() then
		balloon_message_with_sound("msg_profile_card_must_select")
		
		return 
	end
	
	local var_27_0 = arg_27_0:getPorfileCardDataBySlot(arg_27_0.vars.seleted_id)
	
	if var_27_0 then
		local var_27_1 = table.clone(var_27_0)
		
		CustomProfileCardEditor:open({
			id = arg_27_0.vars.seleted_id,
			card_data = var_27_1.data
		})
	end
end

function CustomProfileCardList.isSeletedCard(arg_28_0)
	if not arg_28_0.vars then
		return false
	end
	
	return arg_28_0.vars.seleted_id ~= nil
end

function CustomProfileCardList.setSeletedID(arg_29_0, arg_29_1)
	if not arg_29_0.vars or not get_cocos_refid(arg_29_0.vars.wnd) or table.empty(arg_29_1) then
		return 
	end
	
	arg_29_0.vars.seleted_id = arg_29_1.slot
	
	arg_29_0.scrollview:setSelectedProfileCard(arg_29_1)
	arg_29_0:updateButtons()
end

function CustomProfileCardList.scrollview.getScrollViewItem(arg_30_0, arg_30_1)
	local var_30_0 = load_control("wnd/user_profile_custom_choose_card.csb")
	
	if_set_visible(var_30_0, "n_card", false)
	if_set_visible(var_30_0, "btn_making", false)
	
	if arg_30_1.is_new_card then
		if_set_visible(var_30_0, "btn_making", true)
		
		local var_30_1 = var_30_0:getChildByName("btn_making")
		
		var_30_1:setPositionX(var_30_1:getPositionX() + 13)
	else
		local var_30_2 = CustomProfileCardList.data.main_card_id or Account:getMainProfileCardSlot()
		
		if_set_visible(var_30_0, "n_main", arg_30_1.slot == var_30_2)
		if_set_visible(var_30_0, "n_card", true)
		if_set_visible(var_30_0, "n_select", false)
		
		local var_30_3 = CustomProfileCard:create({
			is_capture = true,
			card_data = arg_30_1.data
		}):getWnd()
		
		var_30_0:getChildByName("n_custom_card"):addChild(var_30_3)
		
		var_30_0:getChildByName("btn_select").item = arg_30_1
		var_30_0:getChildByName("btn_expand").card_data = arg_30_1.data
	end
	
	return var_30_0
end

function CustomProfileCardList.scrollview.setSelectedProfileCard(arg_31_0, arg_31_1)
	if table.empty(arg_31_1) then
		return 
	end
	
	local var_31_0
	
	for iter_31_0, iter_31_1 in pairs(arg_31_0.ScrollViewItems) do
		if iter_31_1.item and arg_31_1.slot and iter_31_1.item.slot == arg_31_1.slot then
			var_31_0 = iter_31_1.control
			
			break
		end
	end
	
	if not get_cocos_refid(var_31_0) or arg_31_0.last_item == var_31_0 then
		return 
	end
	
	if_set_visible(var_31_0, "n_select", true)
	
	if arg_31_0.last_item and get_cocos_refid(arg_31_0.last_item) then
		if_set_visible(arg_31_0.last_item, "n_select", false)
	end
	
	arg_31_0.last_item = var_31_0
end

function drawCallTest(arg_32_0)
	local var_32_0 = {}
	
	for iter_32_0 = 1, arg_32_0 do
		local var_32_1 = CustomProfileCard:create({
			is_debug = true
		})
		
		table.insert(var_32_0, iter_32_0, var_32_1:save())
	end
	
	SAVE:setKeep("profile_card_list", json.encode(var_32_0))
	CustomProfileCardList:setProfileCardDataList(var_32_0)
	CustomProfileCardList:updateProfileCardList()
end

CustomProfileCardZoom = {}

function CustomProfileCardZoom.open(arg_33_0, arg_33_1)
	if arg_33_0.vars and get_cocos_refid(arg_33_0.vars.wnd) then
		arg_33_0:close()
	end
	
	arg_33_0.vars = {}
	arg_33_0.vars.wnd = load_dlg("user_profile_custom_choose_zoom", true, "wnd", function()
		arg_33_0:close()
	end)
	
	SceneManager:getRunningPopupScene():addChild(arg_33_0.vars.wnd)
	arg_33_0:setProfileCard(arg_33_1)
end

function CustomProfileCardZoom.close(arg_35_0)
	if not arg_35_0.vars or not get_cocos_refid(arg_35_0.vars.wnd) then
		return 
	end
	
	local var_35_0 = BackButtonManager:getTopInfo()
	
	if var_35_0 and var_35_0.dlg and var_35_0.dlg ~= arg_35_0.vars.wnd then
		return 
	end
	
	BackButtonManager:pop({
		id = "user_profile_custom_choose_zoom",
		dlg = arg_35_0.vars.wnd
	})
	arg_35_0.vars.wnd:removeFromParent()
	
	arg_35_0.vars.wnd = nil
	arg_35_0.vars = nil
end

function CustomProfileCardZoom.setProfileCard(arg_36_0, arg_36_1)
	if not arg_36_0.vars or not get_cocos_refid(arg_36_0.vars.wnd) or not arg_36_1 then
		return 
	end
	
	local var_36_0 = CustomProfileCard:create({
		card_data = arg_36_1
	}):getWnd()
	
	arg_36_0.vars.wnd:getChildByName("n_custom_card"):addChild(var_36_0)
end
