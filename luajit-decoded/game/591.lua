function clsh()
	CustomLobbySettingMain:init()
end

function clsh_i()
	CustomLobbySettingMain.Illust:init(SceneManager:getRunningPopupScene())
end

function HANDLER.lobby_custom(arg_3_0, arg_3_1)
	if arg_3_1 == "btn_open_search" then
		CustomLobbySettingMain:onOpenSearch()
	end
	
	if arg_3_1 == "btn_search" then
		CustomLobbySettingMain:onSearch()
	end
	
	if arg_3_1 == "btn_open_search_active" then
		CustomLobbySettingMain:onClearSearchResult()
	end
	
	if arg_3_1 == "btn_close_search" then
		CustomLobbySettingMain:onCloseSearch()
	end
	
	if arg_3_1 == "btn_select" then
		CustomLobbySettingMain:onSelectItem(arg_3_0)
	end
	
	if arg_3_1 == "btn_cancel" then
		CustomLobbySettingMain:onCancel()
	end
	
	if arg_3_1 == "btn_all_delete" then
		CustomLobbySettingMain:onAllDeleteSticker()
	end
	
	if string.find(arg_3_1, "tab_%d") then
		local var_3_0 = string.sub(arg_3_1, -1, -1)
		local var_3_1 = tonumber(var_3_0)
		
		CustomLobbySettingSticker:onSelectTab(var_3_1)
		
		return 
	end
	
	if arg_3_1 == "btn" then
		CustomLobbySettingSticker:onSelectSticker(arg_3_0.id)
		
		return 
	end
	
	if string.starts(arg_3_1, "tab_") then
		local var_3_2 = string.split(arg_3_1, "tab_")[2]
		
		if var_3_2 == "face" then
			var_3_2 = "emotion"
		end
		
		if var_3_2 == "bg" then
			var_3_2 = "bgpack"
		end
		
		CustomLobbySettingMain:setMode(var_3_2)
	end
	
	if arg_3_1 == "btn_dropdown" then
		CustomLobbySettingMain.Illust:onDropDown()
	end
	
	if arg_3_1 == "btn_close_illust" then
		CustomLobbySettingMain.Illust:onCloseDropDown()
	end
	
	if string.starts(arg_3_1, "sort_") then
		CustomLobbySettingMain.Illust:onSelectCategory(arg_3_0)
	end
	
	if arg_3_1 == "btn_set" then
		CustomLobbySettingMain:onLobbySet()
	end
	
	if arg_3_1 == "btn_save" then
		CustomLobbySettingMain:onSave()
	end
end

CustomLobbySettingMain = {}

function CustomLobbySettingMain.init(arg_4_0, arg_4_1)
	allSceneSetVisibleFlag(false)
	arg_4_0.Data:init()
	arg_4_0.UI:init(arg_4_1)
	
	arg_4_0.vars = {}
	arg_4_0.vars.mode_to_tbl = {
		hero = CustomLobbySettingHero,
		preview = CustomLobbySettingPreview,
		emotion = CustomLobbySettingEmotion,
		bgpack = CustomLobbySettingBGPack,
		skin = CustomLobbySettingSkin,
		sticker = CustomLobbySettingSticker
	}
	
	local var_4_0 = {
		"preview",
		"hero",
		"skin",
		"emotion",
		"bgpack",
		"sticker"
	}
	
	for iter_4_0, iter_4_1 in pairs(var_4_0) do
		arg_4_0.vars.mode_to_tbl[iter_4_1]:init(arg_4_0.UI:getUI(), arg_4_0.UI:getListViewByMode(iter_4_1))
	end
	
	CustomLobbySettingPreview:settingDefaultPreview()
	CustomLobbySettingMain:setMode("hero")
	
	local var_4_1 = CustomLobbyUnit.Data:loadUnitSettingData(true)
	
	if var_4_1 then
		arg_4_0:loadUnitSettingData(var_4_1)
	end
end

function CustomLobbySettingMain.loadUnitSettingData(arg_5_0, arg_5_1)
	CustomLobbySettingHero:onSelectItem(arg_5_1.unit_id)
	CustomLobbySettingSkin:onSelectSkin({
		code = arg_5_1.face_id
	})
	
	if arg_5_1.emotion_id then
		CustomLobbySettingEmotion:onSelectEmotion({
			emotion = arg_5_1.emotion_id
		})
	end
	
	CustomLobbySettingBGPack:onSelectBGPack({
		id = arg_5_1.background_id
	})
	CustomLobbySettingPreview:loadZoomControlSetting(arg_5_1.zoom_cont)
	CustomLobbySettingSticker:clearStickers()
	
	local var_5_0 = CustomLobbyUnit:getSortedStickerList(arg_5_1.stickers)
	
	for iter_5_0 = 1, #var_5_0 do
		CustomLobbySettingSticker:loadSticker(var_5_0[iter_5_0])
	end
	
	CustomLobbySettingPreview.Layout:setTouchStickersIgnoreMode(false)
end

function CustomLobbySettingMain.onCancel(arg_6_0)
	if CustomLobbySettingMain.Illust:isActive() then
		CustomLobbySettingMain.Illust:onCancel()
		
		return 
	end
	
	local var_6_0 = CustomLobbyUnit.Data:loadUnitSettingData(true) or CustomLobbyUnit.Data:getDefaultSettingData()
	
	arg_6_0:loadUnitSettingData(var_6_0)
	CustomLobbySettingMain:setMode("hero")
end

function CustomLobbySettingMain.onAllDeleteSticker(arg_7_0)
	CustomLobbySettingSticker:clearStickers()
end

function CustomLobbySettingMain.initIllust(arg_8_0, arg_8_1)
	arg_8_0.Illust:init(arg_8_1)
end

function CustomLobbySettingMain.onButtonClose(arg_9_0)
	allSceneSetVisibleFlag(true)
	
	for iter_9_0, iter_9_1 in pairs(arg_9_0.vars.mode_to_tbl) do
		iter_9_1:close()
	end
	
	arg_9_0.Data:close()
	arg_9_0.UI:close()
end

function CustomLobbySettingMain.onOpenSearch(arg_10_0)
	CustomLobbySettingHero:onOpenSearch()
end

function CustomLobbySettingMain.onSearch(arg_11_0)
	CustomLobbySettingHero:onSearch()
	CustomLobbySettingMain:onCloseSearch()
	CustomLobbySettingMain.UI:onSearch()
end

function CustomLobbySettingMain.onClearSearchResult(arg_12_0)
	CustomLobbySettingHero:onClearSearchResult()
	CustomLobbySettingMain.UI:onClearSearchResult()
end

function CustomLobbySettingMain.onCloseSearch(arg_13_0)
	CustomLobbySettingHero:onCloseSearch()
end

function CustomLobbySettingMain.onSelectItem(arg_14_0, arg_14_1)
	if CustomLobbySettingMain.Illust:isActive() then
		CustomLobbySettingMain.Illust:onSelectItem(arg_14_1.data)
		
		return 
	end
	
	local var_14_0 = arg_14_0.Data:getMode()
	
	if var_14_0 ~= arg_14_1._mode then
		Log.e("cont._mode is not current mode," .. tostring(var_14_0) .. "," .. tostring(arg_14_1._mode))
		
		return 
	end
	
	if var_14_0 == "hero" then
		CustomLobbySettingHero:onSelectItem(arg_14_1.id)
	elseif var_14_0 == "emotion" then
		CustomLobbySettingEmotion:onSelectEmotion(arg_14_1.data)
	elseif var_14_0 == "bgpack" then
		CustomLobbySettingBGPack:onSelectBGPack(arg_14_1.data)
	elseif var_14_0 == "skin" then
		CustomLobbySettingSkin:onSelectSkin(arg_14_1.data)
	else
		print("PLZ SET UP ON SELECT UNIT")
	end
end

function CustomLobbySettingMain.onLobbySet(arg_15_0)
	if CustomLobbySettingMain.Illust:isActive() then
		CustomLobbySettingMain.Illust:onLobbySet()
		
		return 
	end
	
	arg_15_0:saveSettings()
	arg_15_0:setAsHeroLobby()
	SAVE:setKeep("custom_lobby.unit.enter_sound", true)
	arg_15_0:reloadLobby()
end

function CustomLobbySettingMain.onSave(arg_16_0)
	if CustomLobbySettingMain.Illust:isActive() then
		CustomLobbySettingMain.Illust:onSave()
		
		return 
	end
	
	arg_16_0:saveSettings()
	CustomLobby:sendSaveQuery(true)
	balloon_message_with_sound("msg_lobby_custom_save")
end

function CustomLobbySettingMain.updateTabStatus(arg_17_0)
	arg_17_0.UI:updateTabStatus()
end

function CustomLobbySettingMain.saveSettings(arg_18_0)
	local var_18_0 = CustomLobbySettingHero.Data:getCurrentUnit()
	local var_18_1 = CustomLobbySettingPreview.Data:getSelectedEmotion()
	local var_18_2 = CustomLobbySettingPreview.Data:getSelectedFaceID()
	local var_18_3 = CustomLobbySettingPreview.Data:getSelectedBGPack()
	local var_18_4 = CustomLobbySettingPreview.Layout:getZoomContStatus()
	local var_18_5 = CustomLobbySettingPreview:getStickerSaveData()
	
	if CustomLobbyUnit.Data:saveUnitSettingData(var_18_0, var_18_2, var_18_1, var_18_3, var_18_4.pivot.x, var_18_4.pivot.y, var_18_4.pivot.scale, var_18_4.target.x, var_18_4.target.y, var_18_5) then
		if CustomLobbyChoose:isActive() then
			CustomLobbyChoose:reloadListViewUnitLobby()
		end
		
		if CustomLobbyUnit:isActive() then
			CustomLobbyUnit:reload()
		end
	end
end

function CustomLobbySettingMain.setAsHeroLobby(arg_19_0)
	CustomLobby:setAsHeroLobby()
end

function CustomLobbySettingMain.reloadLobby(arg_20_0)
	CustomLobby:sendSaveQuery()
end

function CustomLobbySettingMain.setMode(arg_21_0, arg_21_1)
	local var_21_0 = arg_21_0.vars.mode_to_tbl[arg_21_1]
	
	if var_21_0 and var_21_0.isCanShow and not var_21_0:isCanShow() then
		return false
	end
	
	arg_21_0.UI:setMode(arg_21_1)
	
	local var_21_1 = false
	
	if var_21_0 then
		var_21_1 = var_21_0:show(arg_21_0.UI:getListViewByMode(arg_21_1), arg_21_0.Data:getCurrentDataList(arg_21_0.vars.mode_to_tbl, arg_21_1))
		
		if var_21_1 == nil then
			var_21_1 = true
		end
	end
	
	if var_21_1 == false then
		return false
	end
	
	arg_21_0.Data:setMode(arg_21_1)
	CustomLobbySettingPreview.Layout:setStickerEditModeActive(arg_21_1 == "sticker")
	CustomLobbySettingPreview.Layout:setDescBoxVisible(arg_21_1 ~= "sticker")
	arg_21_0.UI:onClearSearchResult()
end

function CustomLobbySettingMain.isAnyModeSettingPopupOpen(arg_22_0)
	if arg_22_0.UI:isActive() then
		return true
	end
	
	if arg_22_0.Illust:isActive() then
		return true
	end
	
	return false
end

CustomLobbySettingMain.Data = {}

function CustomLobbySettingMain.Data.init(arg_23_0)
	arg_23_0.vars = {}
end

function CustomLobbySettingMain.Data.getMode(arg_24_0)
	return arg_24_0.vars.mode
end

function CustomLobbySettingMain.Data.setMode(arg_25_0, arg_25_1)
	arg_25_0.vars.mode = arg_25_1
end

function CustomLobbySettingMain.Data.getCurrentDataList(arg_26_0, arg_26_1, arg_26_2)
	arg_26_2 = arg_26_2 or arg_26_0.vars.mode
	
	return arg_26_1[arg_26_2].Data:getCurrentDataList()
end

function CustomLobbySettingMain.Data.getSelectedUnitCode(arg_27_0)
	return CustomLobbySettingHero.Data:getCurrentUnit()
end

function CustomLobbySettingMain.Data.close(arg_28_0)
	arg_28_0.vars = nil
end

CustomLobbySettingMain.UI = {}

function CustomLobbySettingMain.UI.init(arg_29_0, arg_29_1)
	arg_29_0.vars = {}
	arg_29_0.vars.parent = arg_29_1 or SceneManager:getRunningNativeScene()
	arg_29_0.vars.dlg = load_dlg("lobby_custom", true, "wnd")
	
	arg_29_0.vars.parent:addChild(arg_29_0.vars.dlg)
	
	arg_29_0.vars.tabs = {
		"hero",
		"skin",
		"face",
		"bg",
		"sticker"
	}
	arg_29_0.vars.tab_prefix = "tab_"
	
	TopBarNew:createFromPopup(T("ui_lobby_custom_title"), arg_29_0.vars.dlg, function()
		CustomLobbySettingMain:onButtonClose()
	end)
	TopBarNew:setDisableTopRight()
	if_set(arg_29_0.vars.dlg, "t_1_tear", T("ui_lobby_custom_title_hero"))
	arg_29_0:setAllTabBGVisibleDisable()
end

function CustomLobbySettingMain.UI.isActive(arg_31_0)
	return arg_31_0.vars and get_cocos_refid(arg_31_0.vars.dlg)
end

function CustomLobbySettingMain.UI.updateSkinTabStatus(arg_32_0)
	local var_32_0 = CustomLobbySettingHero.Data:getCurrentUnit()
	local var_32_1 = UIUtil:getSkinList(var_32_0)
	local var_32_2 = 255
	
	if table.count(var_32_1) <= 1 then
		var_32_2 = var_32_2 * 0.3
	end
	
	local var_32_3 = arg_32_0.vars.dlg:getChildByName("n_tab")
	
	if_set_opacity(var_32_3, "tab_skin", var_32_2)
end

function CustomLobbySettingMain.UI.updateEmotionTabStatus(arg_33_0)
	local var_33_0 = CustomLobbySettingPreview.Layout:isPortraitAni()
	local var_33_1 = 255
	
	if not var_33_0 then
		var_33_1 = var_33_1 * 0.3
	end
	
	local var_33_2 = arg_33_0.vars.dlg:getChildByName("n_tab")
	
	if_set_opacity(var_33_2, "tab_face", var_33_1)
end

function CustomLobbySettingMain.UI.updateTabStatus(arg_34_0)
	arg_34_0:updateSkinTabStatus()
	arg_34_0:updateEmotionTabStatus()
end

function CustomLobbySettingMain.UI.setTabBGVisible(arg_35_0, arg_35_1, arg_35_2)
	local var_35_0 = arg_35_0.vars.dlg:getChildByName("n_tab")
	local var_35_1 = arg_35_1
	
	if var_35_1 == "emotion" then
		var_35_1 = "face"
	end
	
	if var_35_1 == "bgpack" then
		var_35_1 = "bg"
	end
	
	local var_35_2 = arg_35_0.vars.tab_prefix .. var_35_1
	local var_35_3 = var_35_0:getChildByName(var_35_2)
	
	if_set_visible(var_35_3, "bg_tab", arg_35_2)
end

function CustomLobbySettingMain.UI.setAllTabBGVisibleDisable(arg_36_0)
	for iter_36_0, iter_36_1 in pairs(arg_36_0.vars.tabs) do
		arg_36_0:setTabBGVisible(iter_36_1, false)
	end
end

function CustomLobbySettingMain.UI.setMode(arg_37_0, arg_37_1)
	arg_37_0:setAllTabBGVisibleDisable()
	arg_37_0:setTabBGVisible(arg_37_1, true)
	
	local var_37_0 = arg_37_1 == "hero"
	local var_37_1 = arg_37_1 == "sticker"
	
	if_set_visible(arg_37_0.vars.dlg, "listview_hero", var_37_0)
	if_set_visible(arg_37_0.vars.dlg, "listview_sticker", var_37_1)
	if_set_visible(arg_37_0.vars.dlg, "n_hero", var_37_0)
	if_set_visible(arg_37_0.vars.dlg, "n_sticker", var_37_1)
	
	local var_37_2 = arg_37_0.vars.dlg:getChildByName("listview")
	
	if not var_37_0 and var_37_2 and var_37_2.vars and get_cocos_refid(var_37_2.vars.itemRenderer) then
		local var_37_3 = var_37_2:clone()
		
		var_37_3:setName("listview")
		var_37_2:getParent():addChild(var_37_3)
		var_37_2:removeFromParent()
	end
	
	if_set_visible(arg_37_0.vars.dlg, "listview", not var_37_0 and not var_37_1)
	if_set_visible(arg_37_0.vars.dlg, "n_nodata", false)
end

function CustomLobbySettingMain.UI.toggleSearchUI(arg_38_0, arg_38_1)
	if_set_visible(arg_38_0.vars.dlg, "btn_open_search", not arg_38_1)
	if_set_visible(arg_38_0.vars.dlg, "t_search_ok", arg_38_1)
	if_set_visible(arg_38_0.vars.dlg, "btn_open_search_active", arg_38_1)
	
	local var_38_0 = arg_38_0.vars.dlg:getChildByName("n_hero")
	
	if_set_visible(var_38_0, "n_sort", not arg_38_1)
end

function CustomLobbySettingMain.UI.onSearch(arg_39_0)
	arg_39_0:toggleSearchUI(true)
end

function CustomLobbySettingMain.UI.onClearSearchResult(arg_40_0)
	arg_40_0:toggleSearchUI(false)
end

function CustomLobbySettingMain.UI.setVisibleNoData(arg_41_0, arg_41_1)
	if_set_visible(arg_41_0.vars.dlg, "n_nodata", arg_41_1)
end

function CustomLobbySettingMain.UI.getUI(arg_42_0)
	return arg_42_0.vars.dlg
end

function CustomLobbySettingMain.UI.getRIGHT(arg_43_0)
	return arg_43_0.vars.dlg:getChildByName("RIGHT")
end

function CustomLobbySettingMain.UI.getListViewByMode(arg_44_0, arg_44_1)
	if arg_44_1 == "hero" then
		return arg_44_0.vars.dlg:getChildByName("listview_hero")
	elseif arg_44_1 == "sticker" then
		return arg_44_0.vars.dlg:getChildByName("listview_sticker")
	else
		return arg_44_0.vars.dlg:getChildByName("listview")
	end
end

function CustomLobbySettingMain.UI.close(arg_45_0)
	if get_cocos_refid(arg_45_0.vars.dlg) then
		arg_45_0.vars.dlg:removeFromParent()
		BackButtonManager:pop("custom_lobby")
		TopBarNew:setEnableTopRight()
		TopBarNew:pop()
	end
	
	arg_45_0.vars = nil
end

CustomLobbySettingMain.Illust = {}

function CustomLobbySettingMain.Illust.init(arg_46_0, arg_46_1)
	allSceneSetVisibleFlag(false)
	arg_46_0.Data:init()
	arg_46_0.UI:init(arg_46_1)
	CustomLobbySettingIllust:init(arg_46_0.UI:getUI())
	CustomLobbySettingIllust:show(arg_46_0.UI:getListView())
	arg_46_0.UI:setCategories(CustomLobbySettingIllust.Data:getCategories())
	
	local var_46_0 = CustomLobbyIllust.Data:loadIllustSettingData(true)
	
	if var_46_0 and not CustomLobbySettingIllust:loadIllustSettingData(var_46_0) then
		local var_46_1 = arg_46_0.UI:getCategoryNode(1)
		
		arg_46_0:onSelectCategory(var_46_1)
	end
end

function CustomLobbySettingMain.Illust.onSelectCategory(arg_47_0, arg_47_1)
	local var_47_0 = arg_47_1.id
	
	arg_47_0.Data:onSelectCategory(var_47_0)
	arg_47_0.UI:onSelectCategory(arg_47_1, var_47_0)
	CustomLobbySettingIllust:onSelectCategory(var_47_0)
end

function CustomLobbySettingMain.Illust.onSelectItem(arg_48_0, arg_48_1)
	local var_48_0 = arg_48_1.db.id
	
	if CustomLobbySettingIllust:isExistIllust(var_48_0) then
		CustomLobbySettingIllust:onRemoveIllustByData(arg_48_1)
	else
		CustomLobbySettingIllust:onSelectIllust(arg_48_1)
	end
end

function CustomLobbySettingMain.Illust.onDropDown(arg_49_0)
	arg_49_0.UI:showDropDown()
end

function CustomLobbySettingMain.Illust.onCloseDropDown(arg_50_0)
	arg_50_0.UI:hideDropDown()
end

function CustomLobbySettingMain.Illust.isActive(arg_51_0)
	if not get_cocos_refid(arg_51_0.UI:getUI()) then
		return 
	end
	
	return true
end

function CustomLobbySettingMain.Illust.onCancel(arg_52_0)
	local var_52_0 = CustomLobbyIllust.Data:loadIllustSettingData(true) or CustomLobbyIllust.Data:getDefaultSettingData()
	
	CustomLobbySettingIllust:loadIllustSettingData(var_52_0)
end

function CustomLobbySettingMain.Illust.onLobbySet(arg_53_0)
	arg_53_0:saveSettings()
	arg_53_0:setAsIllustLobby()
	CustomLobbySettingMain:reloadLobby()
end

function CustomLobbySettingMain.Illust.onSave(arg_54_0)
	arg_54_0:saveSettings()
	CustomLobby:sendSaveQuery(true)
	balloon_message_with_sound("msg_lobby_custom_save")
end

function CustomLobbySettingMain.Illust.saveSettings(arg_55_0)
	local var_55_0 = CustomLobbySettingIllust.Data:getCurrentIllusts()
	local var_55_1 = ""
	
	for iter_55_0, iter_55_1 in pairs(var_55_0) do
		var_55_1 = var_55_1 .. iter_55_1 .. ","
	end
	
	local var_55_2 = string.sub(var_55_1, 1, -2)
	
	if CustomLobbyIllust.Data:saveIllustSettingData(var_55_2) then
		if CustomLobbyIllust:isActive() then
			CustomLobbyIllust:reload()
		end
		
		if CustomLobbyChoose:isActive() then
			CustomLobbyChoose:reloadListViewIllustLobby()
		end
	end
end

function CustomLobbySettingMain.Illust.setAsIllustLobby(arg_56_0)
	CustomLobby:setAsIllustLobby()
end

function CustomLobbySettingMain.Illust.onButtonClose(arg_57_0)
	allSceneSetVisibleFlag(true)
	CustomLobbySettingIllust:close()
	arg_57_0.UI:close()
end

CustomLobbySettingMain.Illust.Data = {}

function CustomLobbySettingMain.Illust.Data.init(arg_58_0)
	arg_58_0.vars = {}
end

function CustomLobbySettingMain.Illust.Data.onSelectCategory(arg_59_0, arg_59_1)
	arg_59_0.vars.select_category = arg_59_1
end

function CustomLobbySettingMain.Illust.Data.getSelectCategory(arg_60_0)
	return arg_60_0.vars.select_category
end

CustomLobbySettingMain.Illust.UI = {}

function CustomLobbySettingMain.Illust.UI.init(arg_61_0, arg_61_1)
	arg_61_0.vars = {}
	arg_61_0.vars.parent = arg_61_1
	arg_61_0.vars.dlg = load_dlg("lobby_custom", true, "wnd")
	
	arg_61_0.vars.parent:addChild(arg_61_0.vars.dlg)
	TopBarNew:createFromPopup(T("ui_lobby_custom_title"), arg_61_0.vars.dlg, function()
		CustomLobbySettingMain.Illust:onButtonClose()
	end)
	TopBarNew:setDisableTopRight()
	arg_61_0:initUI()
end

function CustomLobbySettingMain.Illust.UI.getUI(arg_63_0)
	if not arg_63_0.vars then
		return 
	end
	
	return arg_63_0.vars.dlg
end

function CustomLobbySettingMain.Illust.UI.initUI(arg_64_0)
	local var_64_0 = arg_64_0.vars.dlg
	
	if_set_visible(var_64_0, "n_tab", false)
	if_set_visible(var_64_0, "n_nodata", false)
	if_set_visible(var_64_0, "n_hero", false)
	if_set_visible(var_64_0, "n_illust", true)
	if_set_visible(var_64_0, "listview", true)
	if_set_visible(var_64_0, "listview_hero", true)
	if_set(var_64_0, "t_1_tear", T("ui_lobby_custom_title_illust"))
end

function CustomLobbySettingMain.Illust.UI.getListView(arg_65_0)
	return arg_65_0.vars.dlg:getChildByName("listview")
end

function CustomLobbySettingMain.Illust.UI.setCategories(arg_66_0, arg_66_1)
	local var_66_0 = arg_66_0.vars.dlg:getChildByName("layer_sort_illust")
	local var_66_1 = var_66_0:getChildByName("bg")
	local var_66_2 = var_66_1:getContentSize()
	
	if IS_PUBLISHER_ZLONG then
		var_66_1:setContentSize(var_66_2)
	end
	
	local var_66_3 = 86
	
	var_66_2.height = table.count(arg_66_1) * 48 + var_66_3
	
	var_66_1:setContentSize(var_66_2)
	if_set_visible(var_66_0, "sort_4", false)
	
	for iter_66_0, iter_66_1 in pairs(arg_66_1) do
		local var_66_4, var_66_5, var_66_6 = DB("dic_ui", iter_66_1.id, {
			"name",
			"icon",
			"global_only"
		})
		local var_66_7 = "sort_" .. tostring(iter_66_0)
		local var_66_8 = var_66_0:getChildByName(var_66_7)
		
		if var_66_6 ~= "y" or not IS_PUBLISHER_ZLONG then
			if_set(var_66_8, "label", T(var_66_4))
			if_set_sprite(var_66_8, "icon_" .. tostring(iter_66_0), var_66_5)
			if_set_visible(var_66_8, nil, true)
			if_set_visible(var_66_8, "sort_cursor", false)
			
			var_66_8.id = iter_66_1.id
		end
		
		if false then
		end
	end
end

function CustomLobbySettingMain.Illust.UI.onSelectCategory(arg_67_0, arg_67_1, arg_67_2)
	if get_cocos_refid(arg_67_0.vars.prv_select_sort_node) then
		if_set_visible(arg_67_0.vars.prv_select_sort_node, "sort_cursor", false)
	end
	
	if_set_visible(arg_67_1, "sort_cursor", true)
	
	arg_67_0.vars.prv_select_sort_node = arg_67_1
	
	local var_67_0 = arg_67_0.vars.dlg:getChildByName("btn_dropdown")
	local var_67_1, var_67_2 = DB("dic_ui", arg_67_2, {
		"name",
		"icon"
	})
	
	if_set(var_67_0, "label", T(var_67_1))
	if_set_sprite(var_67_0, "icon_menu_story", var_67_2)
	arg_67_0:hideDropDown()
end

function CustomLobbySettingMain.Illust.UI.getCategoryNode(arg_68_0, arg_68_1)
	return arg_68_0.vars.dlg:getChildByName("sort_" .. arg_68_1)
end

function CustomLobbySettingMain.Illust.UI.setVisibleNoData(arg_69_0, arg_69_1)
	if_set_visible(arg_69_0.vars.dlg, "n_nodata", arg_69_1)
end

function CustomLobbySettingMain.Illust.UI.showDropDown(arg_70_0)
	if_set_visible(arg_70_0.vars.dlg, "layer_sort_illust", true)
end

function CustomLobbySettingMain.Illust.UI.hideDropDown(arg_71_0)
	if_set_visible(arg_71_0.vars.dlg, "layer_sort_illust", false)
end

function CustomLobbySettingMain.Illust.UI.close(arg_72_0)
	if not arg_72_0.vars then
		return 
	end
	
	if get_cocos_refid(arg_72_0.vars.dlg) then
		arg_72_0.vars.dlg:removeFromParent()
		
		arg_72_0.vars.dlg = nil
		
		BackButtonManager:pop("custom_lobby_illust")
		TopBarNew:setEnableTopRight()
		TopBarNew:pop()
	end
	
	CustomLobbyIllust.Util:safeReleaseScheudler("setting")
	
	arg_72_0.vars = nil
end
