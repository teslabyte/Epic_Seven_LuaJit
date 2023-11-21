LotaRoleEnhancementUI = {}

function HANDLER.clan_heritage_enhancement(arg_1_0, arg_1_1)
	if arg_1_1 == "btn" then
		LotaRoleEnhancementUI:select(arg_1_0:getParent():getName())
	end
	
	if arg_1_1 == "btn_enhancement" then
		LotaRoleEnhancementUI:requestEnhancement()
	end
	
	if arg_1_1 == "btn_level_up_info" then
		LotaRoleEnhancementUI:openInfoPopup()
	end
end

function HANDLER.clan_heritage_joplevel_info(arg_2_0, arg_2_1)
	if arg_2_1 == "btn_close" then
		LotaRoleEnhancementUI:closeInfoPopup()
	end
end

function LotaRoleEnhancementUI.open(arg_3_0, arg_3_1)
	arg_3_0.vars = {}
	arg_3_0.vars.parent_layer = arg_3_1
	
	local var_3_0 = LotaUtil:getUIDlg("clan_heritage_enhancement")
	
	arg_3_0.vars.parent_layer:addChild(var_3_0)
	
	arg_3_0.vars.dlg = var_3_0
	arg_3_0.vars.scroll_view_hero = arg_3_0.vars.dlg:findChildByName("ScrollView_hero")
	arg_3_0.vars.ScrollView = {}
	
	copy_functions(ScrollView, arg_3_0.vars.ScrollView)
	
	function arg_3_0.vars.ScrollView.getScrollViewItem(arg_4_0, arg_4_1)
		return UIUtil:getRewardIcon("c", arg_4_1:getDisplayCode(), {
			no_popup = true,
			zodiac = 6,
			role = false,
			no_db_grade = true,
			grade = 6,
			is_enemy = false,
			lv = 60,
			scale = 0.85
		})
	end
	
	arg_3_0.vars.ScrollView:initScrollView(arg_3_0.vars.scroll_view_hero, 75, 88)
	TopBarNew:createFromPopup(T("ui_clanheritage_roleup_title"), arg_3_0.vars.dlg, function()
		LotaRoleEnhancementUI:onButtonClose()
	end)
	TopBarNew:setCurrencies({
		"clanheritage",
		"clanheritagecoin"
	})
	TopBarNew:checkhelpbuttonID("heritagerolelevel")
	arg_3_0:buildUI()
	TutorialGuide:startGuide("tuto_heritage_roleup")
	
	if TutorialGuide:isPlayingTutorial() then
		ChatMain:hide()
	end
end

function LotaRoleEnhancementUI.makeConfirmDlg(arg_6_0)
	local var_6_0 = LotaUtil:getUIDlg("clan_heritage_enhancement_confirm")
	local var_6_1 = var_6_0:findChildByName("n_contents")
	local var_6_2 = var_6_1:findChildByName("n_lv_before")
	local var_6_3 = var_6_1:findChildByName("n_lv_after")
	local var_6_4 = var_6_1:findChildByName("ext")
	local var_6_5 = var_6_1:findChildByName("job_icon")
	local var_6_6 = "img/" .. CollectionUtil.ROLE_COMP_TO_KEY_DATA_ICON[arg_6_0.vars.selected_role]
	
	SpriteCache:resetSprite(var_6_5, var_6_6)
	arg_6_0:updateStatDiff(var_6_4, var_6_2, var_6_3, arg_6_0.vars.selected_role)
	
	return var_6_0
end

function LotaRoleEnhancementUI.makeCompleteDlg(arg_7_0)
	return LotaUtil:makeCompleteDlg(arg_7_0.vars.selected_role)
end

function LotaRoleEnhancementUI.requestEnhancement(arg_8_0)
	if not arg_8_0.vars.selected_role then
		balloon_message_with_sound("msg_clanheritage_roleup_select")
		
		return 
	end
	
	local var_8_0 = LotaUserData:getRoleLevelWithoutArtifactByRole(arg_8_0.vars.selected_role)
	
	if not (var_8_0 < LotaUserData:getMaxRoleLevel()) then
		balloon_message_with_sound("msg_clanheritage_roleup_max")
		
		return 
	end
	
	if var_8_0 >= LotaUserData:getUserLevel() then
		balloon_message_with_sound("msg_clanheritage_role_level_high")
		
		return 
	end
	
	local var_8_1 = arg_8_0:getLevelupRequirePoint()
	
	if var_8_1 > LotaUserData:getEnhanceMaterialCount() then
		balloon_message_with_sound("msg_clanheritage_roleup_lack_point")
		
		return 
	end
	
	local var_8_2 = arg_8_0:makeConfirmDlg()
	
	Dialog:msgBox(T("ui_clanheritage_roleup_popup_desc", {
		count = var_8_1
	}), {
		ignore_text_alignment = true,
		yesno = true,
		dlg = var_8_2,
		handler = function(arg_9_0, arg_9_1)
			if arg_9_1 == "btn_enhancement " then
				LotaNetworkSystem:sendQuery("lota_role_enhancement", {
					role = arg_8_0.vars.selected_role
				})
			elseif arg_9_1 == "btn_block" then
				return "dont_close"
			end
		end
	})
end

function LotaRoleEnhancementUI.onResponse(arg_10_0)
	local var_10_0 = arg_10_0:makeCompleteDlg()
	
	Dialog:msgBox(T("ui_clanheritage_roleup_popup_desc_2"), {
		ignore_text_alignment = true,
		dlg = var_10_0
	})
	arg_10_0:updateSelected()
	arg_10_0:updateUI()
end

function LotaRoleEnhancementUI.onButtonClose(arg_11_0)
	if arg_11_0.vars and get_cocos_refid(arg_11_0.vars.dlg) then
		arg_11_0.vars.dlg:removeFromParent()
		
		arg_11_0.vars = nil
		
		BackButtonManager:pop("clan_heritage_enhancement")
		TopBarNew:pop()
		
		if LotaStatusUI:isActive() then
			LotaStatusUI:update()
			LotaStatusUI:setVisible(true)
		else
			LotaStatusUI:open(LotaSystem:getUIPopupLayer(), LotaUtil:getMyUserInfo())
		end
	end
end

function LotaRoleEnhancementUI.getLevelupRequirePoint(arg_12_0)
	return LotaUtil:getLevelupRequirePoint(arg_12_0.vars.selected_role)
end

function LotaRoleEnhancementUI.select(arg_13_0, arg_13_1)
	if arg_13_0.vars.selected_node then
		LotaUtil:onDeselectAnimation(arg_13_0.vars.selected_node:findChildByName("n_select"), "enhance")
	end
	
	local var_13_0 = arg_13_0.vars.dlg:findChildByName(arg_13_1)
	local var_13_1 = string.sub(arg_13_1, 3, -1)
	
	arg_13_0.vars.selected_node = var_13_0
	arg_13_0.vars.selected_role = var_13_1
	
	arg_13_0:updateSelected()
	TutorialGuide:procGuide("tuto_heritage_roleup")
end

function LotaRoleEnhancementUI.updateStatDiff(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
	LotaUtil:settingStatNames(arg_14_1)
	
	local var_14_0 = LotaUserData:getRoleLevelWithoutArtifactByRole(arg_14_4)
	local var_14_1 = var_14_0 + 1
	
	LotaUtil:settingStats(arg_14_1:findChildByName("n_before"), arg_14_4, var_14_0)
	
	local var_14_2 = var_14_0 < LotaUserData:getMaxRoleLevel()
	
	if_set_visible(arg_14_1, "n_after", var_14_2)
	if_set_visible(arg_14_3, nil, var_14_2)
	if_set_visible(arg_14_1, "icon_arrow", var_14_2)
	
	if var_14_2 then
		LotaUtil:settingStats(arg_14_1:findChildByName("n_after"), arg_14_4, var_14_1, var_14_0)
		
		local var_14_3 = UIUtil:numberDigitToCharOffset(var_14_1, 1, 19)
		
		UIUtil:setLevel(arg_14_3, var_14_1, 15, 2, nil, nil, var_14_3)
	end
	
	local var_14_4, var_14_5 = UIUtil:setLevel(arg_14_2, var_14_0, 15, 2)
	
	if var_14_5 then
		if_set_position_x(arg_14_2, "tag_lv", 22)
		if_set_position_x(arg_14_2, "max", 81)
	else
		if_set_position_x(arg_14_2, "tag_lv", var_14_4 < 2 and 57 or 43)
	end
end

function LotaRoleEnhancementUI.updateSelected(arg_15_0)
	if not arg_15_0.vars.selected_node or not arg_15_0.vars.selected_role then
		return 
	end
	
	local var_15_0 = arg_15_0.vars.selected_role
	local var_15_1 = arg_15_0.vars.selected_node
	
	LotaUtil:onSelectAnimation(var_15_1:findChildByName("n_select"), "enhance")
	if_set_visible(arg_15_0.vars.dlg, "n_noselect", false)
	if_set_visible(arg_15_0.vars.dlg, "n_selected", true)
	
	local var_15_2 = arg_15_0.vars.dlg:findChildByName("n_selected")
	local var_15_3 = var_15_2:findChildByName("n_lv_before")
	local var_15_4 = var_15_2:findChildByName("n_lv_after")
	local var_15_5 = var_15_2:findChildByName("ext")
	
	arg_15_0:updateStatDiff(var_15_5, var_15_3, var_15_4, var_15_0)
	
	local var_15_6 = LotaUserData:getRoleLevelWithoutArtifactByRole(var_15_0)
	local var_15_7 = var_15_6 < LotaUserData:getMaxRoleLevel()
	local var_15_8 = var_15_6 >= LotaUserData:getUserLevel()
	local var_15_9 = var_15_7 and not var_15_8
	local var_15_10 = 255
	local var_15_11 = 0
	
	if_set_visible(var_15_2, "icon_arrow", var_15_9)
	
	if var_15_7 then
		var_15_11 = arg_15_0:getLevelupRequirePoint()
		
		if var_15_11 > LotaUserData:getEnhanceMaterialCount() then
			var_15_9 = false
		end
	end
	
	if not var_15_9 then
		var_15_10 = var_15_10 * 0.3
	end
	
	local var_15_12 = "img/" .. CollectionUtil.ROLE_COMP_TO_KEY_DATA_ICON[var_15_0]
	local var_15_13 = arg_15_0.vars.dlg:findChildByName("job_icon")
	
	SpriteCache:resetSprite(var_15_13, var_15_12)
	
	local var_15_14 = arg_15_0.vars.dlg:findChildByName("RIGHT")
	
	if_set_opacity(var_15_14, "btn_enhancement", var_15_10)
	
	local var_15_15 = var_15_14:findChildByName("btn_enhancement")
	
	if_set(var_15_15, "label_0", var_15_11)
	arg_15_0.vars.ScrollView:clearScrollViewItems()
	
	local var_15_16 = LotaUserData:getRegistrationListByRole(var_15_0)
	
	arg_15_0.vars.ScrollView:createScrollViewItems(var_15_16)
	
	local var_15_17 = table.count(var_15_16)
	
	if_set_visible(arg_15_0.vars.ScrollView, nil, var_15_17 > 0)
	if_set_visible(arg_15_0.vars.dlg, "n_hero_none", var_15_17 == 0)
end

function LotaRoleEnhancementUI.openInfoPopup(arg_16_0)
	local var_16_0 = LotaUtil:getUIDlg("clan_heritage_joplevel_info")
	local var_16_1 = LotaSystem:getUIPopupLayer()
	
	var_16_0:setLocalZOrder(1000001)
	
	local var_16_2 = var_16_0:getChildByName("ScrollView")
	local var_16_3 = ccui.Layout:create()
	
	var_16_3:setContentSize(var_16_2:getContentSize().width, 0)
	var_16_3:setLayoutType(ccui.LayoutType.VERTICAL)
	var_16_3:setAutoSizeEnabled(true)
	var_16_3:setCascadeOpacityEnabled(true)
	var_16_3:setName("@layout")
	
	local var_16_4 = LotaUserData:getMaxRoleLevel()
	
	for iter_16_0 = 1, var_16_4 do
		local var_16_5 = LotaUtil:getRoleStatId("warrior", iter_16_0)
		local var_16_6 = DB("clan_heritage_role_stat_data", var_16_5, "need_point")
		
		if not var_16_6 then
			break
		end
		
		local var_16_7 = load_control("wnd/clan_heritage_joplevel_info_item.csb")
		local var_16_8 = UIUtil:numberDigitToCharOffset(iter_16_0, 1, 19)
		
		UIUtil:setLevel(var_16_7:getChildByName("n_lv"), iter_16_0, 99, 2, nil, nil, var_16_8)
		if_set(var_16_7, "t_count", var_16_6)
		var_16_3:addChild(var_16_7)
	end
	
	var_16_3:forceDoLayout()
	var_16_2:addChild(var_16_3)
	var_16_2:setInnerContainerSize({
		width = 0,
		height = var_16_3:getContentSize().height
	})
	var_16_1:addChild(var_16_0)
	
	arg_16_0.vars.info_popup = var_16_0
	
	BackButtonManager:push({
		check_id = "lota_joplevel_info",
		back_func = function()
			LotaRoleEnhancementUI:closeInfoPopup()
		end
	})
end

function LotaRoleEnhancementUI.closeInfoPopup(arg_18_0)
	if get_cocos_refid(arg_18_0.vars.info_popup) then
		arg_18_0.vars.info_popup:removeFromParent()
		
		arg_18_0.vars.info_popup = nil
		
		BackButtonManager:pop("lota_joplevel_info")
	end
end

function LotaRoleEnhancementUI.updateUI(arg_19_0)
	LotaUtil:setJobLevelUI(arg_19_0.vars.dlg:findChildByName("n_job"))
end

function LotaRoleEnhancementUI.buildUI(arg_20_0)
	if_set_visible(arg_20_0.vars.dlg, "n_noselect", true)
	
	local var_20_0 = arg_20_0.vars.dlg:findChildByName("RIGHT")
	local var_20_1 = arg_20_0.vars.dlg:findChildByName("n_enhancement_meterial")
	
	if_set_visible(var_20_1, nil, false)
	if_set_opacity(var_20_0, "btn_enhancement", 76.5)
	
	local var_20_2 = var_20_0:findChildByName("btn_enhancement")
	
	if_set(var_20_2, "label_0", 0)
	LotaUtil:setJobLevelUI(arg_20_0.vars.dlg:findChildByName("n_job"))
end
