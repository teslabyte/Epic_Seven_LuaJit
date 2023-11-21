CustomLobbySettingPreview = {}

function CustomLobbySettingPreview.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.Data:init(arg_1_3)
	arg_1_0.Layout:init(arg_1_1, nil, nil, arg_1_3)
end

function CustomLobbySettingPreview.close(arg_2_0)
	arg_2_0.Data:close()
	arg_2_0.Layout:close()
	UIAction:Remove("ui_show_hide")
end

function CustomLobbySettingPreview.onSelectUnit(arg_3_0, arg_3_1)
	arg_3_0.Data:onSelectUnit(arg_3_1)
	arg_3_0.Layout:onSelectUnit(arg_3_1)
end

function CustomLobbySettingPreview.setTouchStickersIgnoreMode(arg_4_0, arg_4_1)
	arg_4_0.Layout:setTouchStickersIgnore(arg_4_1)
end

function CustomLobbySettingPreview.onSelectEmotion(arg_5_0, arg_5_1)
	arg_5_0.Data:onSelectEmotion(arg_5_1)
	arg_5_0.Layout:onSelectEmotion(arg_5_1)
end

function CustomLobbySettingPreview.onSelectBGPack(arg_6_0, arg_6_1)
	if arg_6_0.Data:getSelectedBGPack() == arg_6_1 then
		return 
	end
	
	if not arg_6_1 or not DB("item_material_bgpack", arg_6_1, "id") then
		CustomLobbyUnit:setAsDefault()
		
		arg_6_1 = CustomLobbyUnit.Data:loadUnitSettingData(true).background_id
	end
	
	arg_6_0.Data:onSelectBGPack(arg_6_1)
	arg_6_0.Layout:onSelectBGPack(arg_6_1)
end

function CustomLobbySettingPreview.onSelectSkin(arg_7_0, arg_7_1)
	arg_7_0.Data:onSelectSkin(arg_7_1)
	arg_7_0.Layout:onSelectSkin(arg_7_1)
end

function CustomLobbySettingPreview.onSelectIllust(arg_8_0, arg_8_1)
	arg_8_0.Data:onSelectIllust(arg_8_1)
	arg_8_0.Layout:onSelectIllust(arg_8_1)
end

function CustomLobbySettingPreview.onAddSticker(arg_9_0, arg_9_1)
	arg_9_0.Data:addStickerData(arg_9_1)
	
	local var_9_0 = arg_9_0.Data:getStickerData(arg_9_1.uid)
	
	arg_9_0.Layout:onAddSticker(var_9_0)
end

function CustomLobbySettingPreview.onRemoveSticker(arg_10_0, arg_10_1)
	arg_10_0.Data:removeStickerData(arg_10_1)
	arg_10_0.Layout:onRemoveSticker(arg_10_1)
end

function CustomLobbySettingPreview.getStickerSaveData(arg_11_0)
	local var_11_0 = {}
	local var_11_1 = arg_11_0.Data:getAllStickerList()
	
	for iter_11_0, iter_11_1 in pairs(var_11_1) do
		local var_11_2 = arg_11_0.Layout:getStickerInfo(iter_11_1.uid)
		
		var_11_2.id = iter_11_1.id
		
		table.insert(var_11_0, var_11_2)
	end
	
	return var_11_0
end

function CustomLobbySettingPreview.clearStickers(arg_12_0)
	arg_12_0.Data:clearStickers()
	arg_12_0.Layout:clearStickers()
end

function CustomLobbySettingPreview.settingDefaultPreview(arg_13_0)
	arg_13_0:onSelectUnit(CustomLobbySettingHero.Data:getCurrentUnit())
	
	local var_13_0 = CustomLobbySettingSkin.Data:getCurrentSkin()
	
	if var_13_0 ~= "" and var_13_0 ~= nil then
		arg_13_0:onSelectSkin(CustomLobbySettingSkin.Data:getCurrentSkin())
	end
	
	arg_13_0:onSelectEmotion(CustomLobbySettingEmotion.Data:getCurrentEmotion())
	arg_13_0:onSelectBGPack(CustomLobbySettingBGPack.Data:getCurrentBGPack())
end

function CustomLobbySettingPreview.loadZoomControlSetting(arg_14_0, arg_14_1)
	arg_14_0.Layout:loadZoomControlSetting(arg_14_1)
end

function CustomLobbySettingPreview.settingDefaultPreviewIllust(arg_15_0)
end

CustomLobbySettingPreview.Data = {}

function CustomLobbySettingPreview.Data.init(arg_16_0, arg_16_1)
	arg_16_0.vars = {}
	arg_16_0.vars.sticker_data = {}
	arg_16_0.vars.is_illust = arg_16_1
end

function CustomLobbySettingPreview.Data.isIllustMode(arg_17_0)
	return arg_17_0.vars.is_illust
end

function CustomLobbySettingPreview.Data.onSelectUnit(arg_18_0, arg_18_1)
	arg_18_0.vars.selected_face_id = arg_18_1
end

function CustomLobbySettingPreview.Data.onSelectBGPack(arg_19_0, arg_19_1)
	arg_19_0.vars.selected_bg_pack_id = arg_19_1
end

function CustomLobbySettingPreview.Data.onSelectEmotion(arg_20_0, arg_20_1)
	arg_20_0.vars.selected_emotion_id = arg_20_1
end

function CustomLobbySettingPreview.Data.onSelectSkin(arg_21_0, arg_21_1)
	arg_21_0.vars.selected_skin_id = arg_21_1
	arg_21_0.vars.selected_face_id = DB("character", arg_21_1, "face_id")
end

function CustomLobbySettingPreview.Data.onSelectIllust(arg_22_0, arg_22_1)
	arg_22_0.vars.selected_illust_id = arg_22_1
end

function CustomLobbySettingPreview.Data.addStickerData(arg_23_0, arg_23_1)
	arg_23_0.vars.sticker_data[arg_23_1.uid] = arg_23_1
	
	local var_23_0 = CustomLobbyUnit.Sticker:getStickerDefaultSize()
	
	arg_23_1.x = arg_23_1.x or 0
	arg_23_1.y = arg_23_1.y or VIEW_HEIGHT / 2
	arg_23_1.scale_x = arg_23_1.scale_x or 1
	arg_23_1.scale_y = arg_23_1.scale_y or 1
	arg_23_1.rotation = arg_23_1.rotation or 0
end

function CustomLobbySettingPreview.Data.removeStickerData(arg_24_0, arg_24_1)
	arg_24_0.vars.sticker_data[arg_24_1] = nil
end

function CustomLobbySettingPreview.Data.getAllStickerList(arg_25_0)
	local var_25_0 = {}
	
	for iter_25_0, iter_25_1 in pairs(arg_25_0.vars.sticker_data) do
		table.insert(var_25_0, {
			uid = iter_25_1.uid,
			id = iter_25_1.id
		})
	end
	
	return var_25_0
end

function CustomLobbySettingPreview.Data.clearStickers(arg_26_0)
	arg_26_0.vars.sticker_data = {}
end

function CustomLobbySettingPreview.Data.getStickerData(arg_27_0, arg_27_1)
	return arg_27_0.vars.sticker_data[arg_27_1]
end

function CustomLobbySettingPreview.Data.getSelectedBGPack(arg_28_0)
	return arg_28_0.vars.selected_bg_pack_id
end

function CustomLobbySettingPreview.Data.getSelectedFaceID(arg_29_0)
	return arg_29_0.vars.selected_face_id
end

function CustomLobbySettingPreview.Data.getSelectedEmotionFaceID(arg_30_0)
	local var_30_0 = arg_30_0:getSelectedFaceID()
	local var_30_1 = CustomLobbySettingHero.Data:getCurrentUnit()
	local var_30_2 = UIUtil:getSkinList(var_30_0)
	
	for iter_30_0, iter_30_1 in pairs(var_30_2) do
		local var_30_3, var_30_4 = DB("character", iter_30_1.code, {
			"face_id",
			"emotion_id"
		})
		
		print("face_id, emotion_id", var_30_3, var_30_4)
		
		if var_30_3 == var_30_0 then
			return var_30_4
		end
	end
	
	return nil
end

function CustomLobbySettingPreview.Data.getSelectedEmotion(arg_31_0)
	return arg_31_0.vars.selected_emotion_id
end

function CustomLobbySettingPreview.Data.getSelectedSkin(arg_32_0)
	return arg_32_0.vars.selected_skin_id
end

function CustomLobbySettingPreview.Data.getSelectedIllust(arg_33_0)
	return arg_33_0.vars.selected_illust_id
end

function CustomLobbySettingPreview.Data.GetStaticPreviewWidth(arg_34_0)
	return arg_34_0:getPreviewWidth(nil, arg_34_0:GetStaticPreviewHeight())
end

function CustomLobbySettingPreview.Data.GetStaticPreviewHeight(arg_35_0)
	return 442
end

function CustomLobbySettingPreview.Data.GetStaticPreviewSize(arg_36_0)
	return {
		width = arg_36_0:GetStaticPreviewWidth(),
		height = arg_36_0:GetStaticPreviewHeight()
	}
end

function CustomLobbySettingPreview.Data.GetStaticPreviewMargin(arg_37_0)
	return arg_37_0:getPreviewStretchVersionWidth(arg_37_0:GetStaticPreviewHeight()) - arg_37_0:GetStaticPreviewWidth()
end

function CustomLobbySettingPreview.Data.getPreviewHeight(arg_38_0)
	local var_38_0 = 442
	
	return arg_38_0.vars.setting_height or var_38_0
end

function CustomLobbySettingPreview.Data.getPreviewStretchVersionWidth(arg_39_0, arg_39_1)
	local var_39_0 = 788
	local var_39_1 = arg_39_1 or arg_39_0:getPreviewHeight()
	
	return var_39_0 * get_stretch_ratio(VIEW_WIDTH, DESIGN_WIDTH, {
		width = var_39_0,
		height = var_39_1
	}, 1)
end

function CustomLobbySettingPreview.Data.getPreviewWidth(arg_40_0, arg_40_1, arg_40_2)
	arg_40_1 = arg_40_1 or VIEW_WIDTH
	
	local var_40_0 = arg_40_1 / DESIGN_HEIGHT
	
	return (arg_40_2 or arg_40_0:getPreviewHeight()) * var_40_0
end

function CustomLobbySettingPreview.Data.getPreviewSize(arg_41_0)
	return {
		width = arg_41_0:getPreviewWidth(),
		height = arg_41_0:getPreviewHeight()
	}
end

function CustomLobbySettingPreview.Data.getPreviewMargin(arg_42_0)
	return arg_42_0:getPreviewStretchVersionWidth() - arg_42_0:getPreviewWidth()
end

function CustomLobbySettingPreview.Data.close(arg_43_0)
	arg_43_0.vars = nil
end

CustomLobbySettingPreview.Layout = {}

function CustomLobbySettingPreview.Layout.createInstance(arg_44_0, arg_44_1, arg_44_2, arg_44_3, arg_44_4, arg_44_5)
	local var_44_0 = {}
	
	copy_functions(CustomLobbySettingPreview.Layout, var_44_0)
	var_44_0:init(arg_44_1, arg_44_2, arg_44_3, arg_44_4, "choose", arg_44_5)
	
	return var_44_0
end

function CustomLobbySettingPreview.Layout.init(arg_45_0, arg_45_1, arg_45_2, arg_45_3, arg_45_4, arg_45_5, arg_45_6)
	arg_45_0.vars = {}
	arg_45_0.vars.parent = arg_45_1
	arg_45_0.vars.create_path = arg_45_5 or "setting"
	
	if arg_45_1:findChildByName("CENTER") then
		arg_45_0.vars.CENTER = arg_45_1:findChildByName("CENTER")
	else
		arg_45_0.vars.CENTER = arg_45_0.vars.parent
	end
	
	arg_45_0.vars.cur_portrait = nil
	arg_45_0.vars.cur_bg = nil
	arg_45_0.vars.force_set_preview_sz = arg_45_3 ~= nil
	
	local var_45_0 = arg_45_1:getChildByName("n_bottom")
	
	if var_45_0 and not arg_45_2 and not arg_45_4 then
		arg_45_0.vars.n_bottom = var_45_0
		
		arg_45_0.vars.n_bottom:ejectFromParent()
		arg_45_0.vars.CENTER:addChild(arg_45_0.vars.n_bottom)
	end
	
	if var_45_0 and arg_45_4 then
		var_45_0:setVisible(false)
	end
	
	arg_45_2 = arg_45_2 or CustomLobbySettingPreview.Data:getPreviewSize()
	arg_45_3 = arg_45_3 or CustomLobbySettingPreview.Data:getPreviewMargin()
	
	local var_45_1 = arg_45_2.width
	local var_45_2 = arg_45_2.height
	
	arg_45_0.vars.preview_sz = arg_45_2
	arg_45_0.vars.preview_margin = arg_45_3
	
	if arg_45_4 ~= nil then
		arg_45_0.vars.is_illust_mode = arg_45_4
	else
		arg_45_0.vars.is_illust_mode = CustomLobbySettingPreview.Data:isIllustMode()
	end
	
	arg_45_0.vars.layout = ccui.Layout:create()
	
	arg_45_0.vars.layout:setContentSize(var_45_1, var_45_2)
	arg_45_0.vars.layout:setClippingEnabled(true)
	arg_45_0.vars.layout:setTouchEnabled(true)
	arg_45_0.vars.layout:setPositionX(22 + arg_45_0.vars.preview_margin / 2)
	arg_45_0.vars.layout:setPositionY(127)
	arg_45_0.vars.layout:setName("layout")
	
	arg_45_0.vars.ignore_touch_event = false
	arg_45_0.vars.custom_layout_poses_callback = arg_45_6
	
	arg_45_0.vars.CENTER:addChild(arg_45_0.vars.layout)
	arg_45_0:setupThumbnail()
	arg_45_0:updateLayoutPoses()
	arg_45_0:replaceGrowWhite()
	arg_45_0:updateDimColor(true, cc.c3b(0, 0, 0))
	NotchManager:addListener(arg_45_0.vars.layout, nil, function(arg_46_0, arg_46_1, arg_46_2)
		arg_45_0:updateLayoutPoses()
		arg_45_0:updateThumbnailPoses()
		arg_45_0:updateIllustZoomStatus()
	end)
	arg_45_0:setZoomCont()
	arg_45_0:setTouchEvent()
	
	if arg_45_0.vars.n_bottom then
		arg_45_0.vars.n_bottom:setLocalZOrder(999999)
		
		if arg_45_4 then
			if_set(var_45_0, "label", T("ui_lobby_custom_desc_box_illust"))
		else
			if_set(var_45_0, "label", T("ui_lobby_custom_desc_box"))
		end
	end
	
	arg_45_0:setupStickerLayer()
end

function CustomLobbySettingPreview.Layout.createButtonAsLayoutSize(arg_47_0, arg_47_1)
	local var_47_0 = ccui.Button:create()
	
	var_47_0:ignoreContentAdaptWithSize(false)
	var_47_0:setContentSize(arg_47_0.vars.layout:getContentSize())
	var_47_0:setAnchorPoint(0, 0)
	var_47_0:setPosition(0, 0)
	var_47_0:setTouchEnabled(true)
	var_47_0:addTouchEventListener(arg_47_1)
	arg_47_0:disableTouch()
	arg_47_0.vars.layout:addChild(var_47_0)
end

function CustomLobbySettingPreview.Layout.updateDimSize(arg_48_0, arg_48_1)
	if get_cocos_refid(arg_48_0.vars.dim_image) then
		arg_48_0.vars.dim_image:setContentSize(arg_48_1)
	end
end

function CustomLobbySettingPreview.Layout.setDimOpacity(arg_49_0, arg_49_1)
	if not arg_49_0.vars.dim_image then
		local var_49_0 = arg_49_0.vars.thumbnail:getChildByName("thumbnail"):getContentSize()
		
		arg_49_0.vars.dim_image = cc.LayerColor:create(tocolor("#000000"), var_49_0.width, var_49_0.height)
		
		arg_49_0.vars.dim_image:setPositionX(0)
		arg_49_0.vars.dim_image:setName("dim_image")
		arg_49_0.vars.dim_image:setOpacity(30)
		arg_49_0.vars.thumbnail:addChild(arg_49_0.vars.dim_image)
	end
	
	if get_cocos_refid(arg_49_0.vars.dim_image) then
		arg_49_0.vars.dim_image:setOpacity(arg_49_1 * 255)
	end
end

function CustomLobbySettingPreview.Layout.setColor(arg_50_0, arg_50_1)
	if get_cocos_refid(arg_50_0.vars.thumbnail) then
		arg_50_0.vars.thumbnail:setColor(arg_50_1)
	end
	
	if get_cocos_refid(arg_50_0.vars.cur_portrait) then
		arg_50_0.vars.cur_portrait:setColor(arg_50_1)
	end
	
	if get_cocos_refid(arg_50_0.vars.zoom_cont.target) then
		arg_50_0.vars.zoom_cont.target:setColor(arg_50_1)
	end
	
	if get_cocos_refid(arg_50_0.vars.sticker_layer) then
		arg_50_0.vars.sticker_layer:setColor(arg_50_1)
	end
end

function CustomLobbySettingPreview.Layout.setupStickerLayer(arg_51_0)
	local var_51_0 = arg_51_0.vars.thumbnail:getChildByName("n_lobby")
	
	arg_51_0.vars.sticker_layer = CustomLobbyUnit.Sticker:setStickerLayer(var_51_0)
end

function CustomLobbySettingPreview.Layout.setupThumbnail(arg_52_0)
	local var_52_0 = load_control("wnd/lobby_custom_thumbnail.csb")
	
	arg_52_0.vars.thumbnail = var_52_0
	
	arg_52_0.vars.layout:addChild(var_52_0)
	arg_52_0:updateThumbnailPoses()
end

function CustomLobbySettingPreview.Layout.setVisibleMockup(arg_53_0, arg_53_1)
	if not get_cocos_refid(arg_53_0.vars.thumbnail) then
		return 
	end
	
	local var_53_0 = arg_53_0.vars.thumbnail
	local var_53_1 = var_53_0:getChildByName("mockup_left")
	local var_53_2 = var_53_0:getChildByName("mockup_right")
	local var_53_3 = var_53_0:getChildByName("n_grow")
	
	if_set_visible(var_53_1, nil, arg_53_1)
	if_set_visible(var_53_2, nil, arg_53_1)
	if_set_visible(var_53_3, nil, arg_53_1)
end

function CustomLobbySettingPreview.Layout.updateForceSize(arg_54_0, arg_54_1, arg_54_2)
	if not get_cocos_refid(arg_54_0.vars.layout) then
		return 
	end
	
	arg_54_0.vars.preview_sz = arg_54_1
	arg_54_0.vars.preview_margin = arg_54_2
	
	local var_54_0 = arg_54_0.vars.preview_sz.width
	local var_54_1 = arg_54_0.vars.preview_sz.height
	
	arg_54_0.vars.layout:setContentSize(var_54_0, var_54_1)
end

function CustomLobbySettingPreview.Layout.updateThumbnailPoses(arg_55_0)
	if not get_cocos_refid(arg_55_0.vars.thumbnail) then
		return 
	end
	
	local var_55_0 = arg_55_0.vars.thumbnail
	local var_55_1 = arg_55_0.vars.preview_sz.height / DESIGN_HEIGHT
	local var_55_2 = VIEW_BASE_LEFT
	
	arg_55_0:setupThumbnailValues(var_55_0, var_55_2)
	
	local var_55_3 = var_55_0:getChildByName("n_empty")
	
	arg_55_0:setupThumbnailValues(var_55_3, var_55_2)
	
	local var_55_4 = var_55_3:getChildByName("cm_icon")
	local var_55_5 = var_55_3:getChildByName("n_info")
	
	if not var_55_3._origin_x then
		local var_55_6 = var_55_4:getPositionX()
		
		var_55_3._origin_n_info_x, var_55_3._origin_x = var_55_5:getPositionX(), var_55_6
	end
	
	var_55_4:setPositionX(var_55_3._origin_x - var_55_2)
	var_55_5:setPositionX(var_55_3._origin_n_info_x - var_55_2)
	var_55_0:setScale(var_55_1)
end

function CustomLobbySettingPreview.Layout.setupThumbnailValues(arg_56_0, arg_56_1, arg_56_2)
	local var_56_0 = arg_56_1:getChildByName("mockup_left")
	local var_56_1 = arg_56_1:getChildByName("mockup_right")
	local var_56_2 = arg_56_1:getChildByName("n_grow")
	local var_56_3 = var_56_2:getChildByName("top_grow")
	local var_56_4 = var_56_2:getChildByName("LEFT")
	local var_56_5 = var_56_2:getChildByName("TOP_LEFT")
	local var_56_6 = var_56_2:getChildByName("RIGHT")
	
	if not var_56_0._origin_x then
		local var_56_7 = var_56_0:getPositionX()
		local var_56_8 = var_56_1:getPositionX()
		local var_56_9 = var_56_4:getPositionX()
		local var_56_10 = var_56_6:getPositionX()
		local var_56_11 = var_56_5:getPositionX()
		local var_56_12 = var_56_3:getPositionX()
		
		var_56_0._origin_x = var_56_7
		var_56_1._origin_x = var_56_8
		var_56_4._origin_x = var_56_9
		var_56_6._origin_x = var_56_10
		var_56_5._origin_x = var_56_11
		var_56_3._origin_x = var_56_12
	end
	
	var_56_4:setPositionX(arg_56_2 + var_56_4._origin_x)
	var_56_6:setPositionX(-arg_56_2 + var_56_6._origin_x)
	var_56_5:setPositionX(arg_56_2 + var_56_5._origin_x)
	var_56_3:setPositionX(arg_56_2 + var_56_3._origin_x)
	
	local var_56_13 = var_56_3:getContentSize().height
	
	var_56_3:setContentSize(arg_56_0.vars.preview_sz.width, var_56_13)
	
	local var_56_14 = arg_56_0.vars.thumbnail:getChildByName("bg")
	
	var_56_14:setContentSize(VIEW_WIDTH, DESIGN_HEIGHT)
	var_56_14:setPositionX(0)
	var_56_0:setPositionX(0)
	var_56_1:setPositionX(VIEW_WIDTH)
end

function CustomLobbySettingPreview.Layout.updateIllustZoomStatus(arg_57_0)
	if not arg_57_0.vars.is_illust_mode then
		return 
	end
	
	if not get_cocos_refid(arg_57_0.vars.illust) then
		return 
	end
	
	if not arg_57_0.vars.zoom_cont then
		return 
	end
	
	CustomLobbyIllust.Util:resetZoomController(arg_57_0.vars.zoom_cont, arg_57_0.vars.illust)
end

function CustomLobbySettingPreview.Layout.touchEventHandler(arg_58_0, arg_58_1, arg_58_2)
	if arg_58_0.vars.is_illust_mode then
		return true
	end
	
	if arg_58_0.vars.ignore_touch_event then
		return true
	end
	
	if arg_58_0.vars.touch_listener_mode == "sticker_edit" then
		if cc.EventCode.ENDED == arg_58_2:getEventCode() then
			arg_58_0:changeEditDrawNode(nil)
		end
	elseif cc.EventCode.BEGAN == arg_58_2:getEventCode() then
		if arg_58_0.onTouchDown then
			arg_58_0:onTouchDown(arg_58_1, arg_58_2)
			
			return true
		end
	elseif cc.EventCode.MOVED == arg_58_2:getEventCode() then
		if arg_58_0.onTouchMove then
			arg_58_0:onTouchMove(arg_58_1, arg_58_2)
			
			return true
		end
	elseif cc.EventCode.ENDED == arg_58_2:getEventCode() then
		if arg_58_0.onTouchUp then
			arg_58_0:onTouchUp(arg_58_1, arg_58_2)
			
			return true
		end
	elseif cc.EventCode.CANCELLED == arg_58_2:getEventCode() and arg_58_0.onTouchCancelled then
		arg_58_0:onTouchCancelled(arg_58_1, arg_58_2)
		
		return true
	end
end

function CustomLobbySettingPreview.Layout.setTouchIgnoreMode(arg_59_0, arg_59_1)
	arg_59_0.vars.ignore_touch_event = arg_59_1
end

function CustomLobbySettingPreview.Layout.setTouchStickersIgnoreMode(arg_60_0, arg_60_1)
	if get_cocos_refid(arg_60_0.vars.sticker_layer) then
		for iter_60_0, iter_60_1 in pairs(arg_60_0.vars.sticker_layer:getChildren() or {}) do
			local var_60_0 = iter_60_1:getChildByName("btn")
			
			if var_60_0 then
				var_60_0:setVisible(arg_60_1)
			end
		end
	end
end

function CustomLobbySettingPreview.Layout.setStickerEditModeActive(arg_61_0, arg_61_1)
	if arg_61_1 then
		arg_61_0.vars.touch_listener_mode = "sticker_edit"
	else
		arg_61_0:changeEditDrawNode(nil)
		
		arg_61_0.vars.touch_listener_mode = "default"
	end
	
	arg_61_0:setTouchStickersIgnoreMode(arg_61_1)
end

function CustomLobbySettingPreview.Layout.setDescBoxVisible(arg_62_0, arg_62_1)
	if_set_visible(arg_62_0.vars.n_bottom, nil, arg_62_1)
end

function CustomLobbySettingPreview.Layout.onTouchDown(arg_63_0, arg_63_1, arg_63_2)
	if not arg_63_0.vars or not get_cocos_refid(arg_63_0.vars.layout) then
		return 
	end
	
	set_high_fps_tick()
	
	return arg_63_0.vars.zoom_cont:onTouchDown(arg_63_1, arg_63_2)
end

function CustomLobbySettingPreview.Layout.onTouchMove(arg_64_0, arg_64_1, arg_64_2)
	if not arg_64_0.vars or not get_cocos_refid(arg_64_0.vars.layout) then
		return 
	end
	
	set_high_fps_tick()
	
	return arg_64_0.vars.zoom_cont:onTouchMove(arg_64_1, arg_64_2)
end

function CustomLobbySettingPreview.Layout.onEmpty(arg_65_0, arg_65_1)
	if not arg_65_0.vars or not get_cocos_refid(arg_65_0.vars.layout) then
		return 
	end
	
	if_set_visible(arg_65_0.vars.thumbnail, "n_empty", arg_65_1)
	if_set_visible(arg_65_0.vars.thumbnail, "thumbnail", not arg_65_1)
end

function CustomLobbySettingPreview.Layout.onGestureZoom(arg_66_0, arg_66_1, arg_66_2, arg_66_3)
	if not arg_66_0.vars or not get_cocos_refid(arg_66_0.vars.layout) then
		return 
	end
	
	if arg_66_0.vars.touch_listener_mode == "sticker_edit" then
		return 
	end
	
	if arg_66_0.vars.is_illust_mode then
		return 
	end
	
	set_high_fps_tick()
	arg_66_0.vars.zoom_cont:onGestureZoom(arg_66_1, arg_66_2, arg_66_3)
end

function CustomLobbySettingPreview.Layout.onMouseWheel(arg_67_0, arg_67_1, arg_67_2)
	if not arg_67_0.vars or not get_cocos_refid(arg_67_0.vars.layout) then
		return 
	end
	
	if arg_67_0.vars.touch_listener_mode == "sticker_edit" then
		return 
	end
	
	set_high_fps_tick()
	arg_67_0.vars.zoom_cont:onMouseWheel(arg_67_1)
end

function CustomLobbySettingPreview.Layout.setTouchEvent(arg_68_0)
	if not arg_68_0.vars.parent:getChildByName("n_panel") then
		return 
	end
	
	if arg_68_0.vars.force_set_preview_sz then
		return 
	end
	
	arg_68_0.vars.touches = {}
	
	local function var_68_0(arg_69_0, arg_69_1)
		if not arg_68_0.vars or not arg_68_0.vars.touches then
			return 
		end
		
		local var_69_0
		
		for iter_69_0, iter_69_1 in pairs(arg_69_0) do
			arg_68_0.vars.touches[iter_69_1:getId() + 1] = iter_69_1
			
			if iter_69_1:getId() == 0 then
				var_69_0 = iter_69_1
				
				break
			end
		end
		
		if arg_68_0.onGestureZoom and get_cocos_refid(arg_69_0[1]) and get_cocos_refid(arg_69_0[2]) then
			local var_69_1 = arg_69_0[1]:getStartLocationInView()
			local var_69_2 = arg_69_0[1]:getLocationInView()
			local var_69_3 = arg_69_0[2]:getStartLocationInView()
			local var_69_4 = arg_69_0[2]:getLocationInView()
			local var_69_5 = math.sqrt(math.pow(var_69_3.x - var_69_1.x, 2) + math.pow(var_69_3.y - var_69_1.y, 2))
			local var_69_6 = math.sqrt(math.pow(var_69_4.x - var_69_2.x, 2) + math.pow(var_69_4.y - var_69_2.y, 2))
			local var_69_7 = arg_69_0[1]:getLocation()
			local var_69_8 = arg_69_0[2]:getLocation()
			local var_69_9 = {
				x = (var_69_7.x + var_69_8.x) * 0.5,
				y = (var_69_7.y + var_69_8.y) * 0.5
			}
			
			arg_68_0:onGestureZoom(arg_68_0.vars._gestureFactor or var_69_6, var_69_6, var_69_9)
			
			arg_68_0.vars._gestureFactor = var_69_6
		else
			arg_68_0.vars._gestureFactor = nil
			
			if var_69_0 then
				arg_68_0:touchEventHandler(var_69_0, arg_69_1, arg_69_0)
			end
		end
	end
	
	local var_68_1 = TouchBlocker:pushBlockingScene(SceneManager:getCurrentSceneName(), function()
		return not arg_68_0.vars or not get_cocos_refid(arg_68_0.vars.layout)
	end)
	
	TouchBlocker:pushInterrupter(SceneManager:getCurrentSceneName(), function(arg_71_0, arg_71_1, arg_71_2)
		if not arg_68_0.vars or not get_cocos_refid(arg_68_0.vars.layout) then
			return 
		end
		
		if not WidgetUtils:isHitTest(arg_68_0.vars.layout, arg_71_0) then
			return 
		end
		
		var_68_0(arg_71_2, arg_71_1)
	end)
	arg_68_0:disableTouch()
end

function CustomLobbySettingPreview.Layout.disableTouch(arg_72_0)
	arg_72_0:eachDisableTouchListener(arg_72_0.vars.layout)
	
	if get_cocos_refid(arg_72_0.vars.parent) then
		if arg_72_0.vars.parent:getChildByName("n_panel") then
			arg_72_0.vars.parent:getChildByName("n_panel"):setTouchEnabled(false)
		end
		
		local var_72_0 = arg_72_0.vars.parent:getChildByName("n_dim_img")
		
		if var_72_0 then
			arg_72_0:eachDisableTouchListener(var_72_0)
		end
	end
end

function CustomLobbySettingPreview.Layout.setZoomCont(arg_73_0)
	if not arg_73_0.vars.is_illust_mode then
		arg_73_0.vars.zoom_cont = CustomLobbyUnit.Util:createZoomController(arg_73_0.vars.layout:getChildByName("n_portrait"))
	else
		arg_73_0.vars.zoom_cont = CustomLobbyIllust.Util:createZoomController(arg_73_0.vars.layout:getChildByName("n_portrait"))
	end
	
	arg_73_0:attachWheelListener()
end

function CustomLobbySettingPreview.Layout.isPortraitAni(arg_74_0)
	if not arg_74_0.vars then
		return false
	end
	
	return arg_74_0.vars.cur_portrait_is_ani
end

function CustomLobbySettingPreview.Layout.getZoomContStatus(arg_75_0)
	local var_75_0 = arg_75_0.vars.zoom_cont.pivot
	local var_75_1 = arg_75_0.vars.zoom_cont.target
	local var_75_2, var_75_3 = var_75_0:getPosition()
	local var_75_4, var_75_5 = var_75_1:getPosition()
	local var_75_6 = var_75_0:getScale()
	
	return {
		pivot = {
			x = var_75_2,
			y = var_75_3,
			scale = var_75_6
		},
		target = {
			x = var_75_4,
			y = var_75_5
		}
	}
end

function CustomLobbySettingPreview.Layout.resetZoomControlSetting(arg_76_0)
	local var_76_0 = arg_76_0.vars.zoom_cont.pivot
	local var_76_1 = arg_76_0.vars.zoom_cont.target
	local var_76_2 = CustomLobbyUnit.Data:getDefaultSettingData()
	local var_76_3 = var_76_2.zoom_cont.pivot
	local var_76_4 = var_76_2.zoom_cont.target
	
	var_76_0:setPosition(var_76_3.x, var_76_3.y)
	
	if arg_76_0.vars.is_illust_mode then
	else
		var_76_0:setScale(var_76_3.scale)
	end
	
	var_76_1:setPosition(var_76_4.x, var_76_4.y)
end

function CustomLobbySettingPreview.Layout.loadZoomControlSetting(arg_77_0, arg_77_1)
	local var_77_0 = arg_77_0.vars.zoom_cont.pivot
	local var_77_1 = arg_77_0.vars.zoom_cont.target
	
	var_77_0:setPosition(arg_77_1.pivot.x, arg_77_1.pivot.y)
	
	if arg_77_0.vars.is_illust_mode then
	else
		var_77_0:setScale(arg_77_1.pivot.scale)
	end
	
	var_77_1:setPosition(arg_77_1.target.x, arg_77_1.target.y)
end

function CustomLobbySettingPreview.Layout.attachWheelListener(arg_78_0)
	if arg_78_0.vars.force_set_preview_sz then
		return 
	end
	
	if PLATFORM ~= "win32" or arg_78_0.vars.is_illust_mode then
		return 
	end
	
	local var_78_0 = SceneManager:getCurrentScene()
	
	if var_78_0 and var_78_0.layer then
		local var_78_1 = var_78_0.layer:getEventDispatcher()
		
		arg_78_0._zoom_listener = cc.EventListenerMouse:create()
		
		arg_78_0._zoom_listener:registerScriptHandler(function(arg_79_0, arg_79_1)
			CustomLobbySettingPreview.Layout:onMouseWheel(arg_79_0)
			
			return true
		end, cc.Handler.EVENT_MOUSE_SCROLL)
		var_78_1:addEventListenerWithSceneGraphPriority(arg_78_0._zoom_listener, var_78_0.layer)
	end
end

function CustomLobbySettingPreview.Layout.close(arg_80_0)
	if get_cocos_refid(arg_80_0._zoom_listener) then
		cc.Director:getInstance():getEventDispatcher():removeEventListener(arg_80_0._zoom_listener)
		
		arg_80_0._zoom_listener = nil
	end
end

function CustomLobbySettingPreview.Layout.eachDisableTouchListener(arg_81_0, arg_81_1)
	if arg_81_1.addTouchEventListener then
		arg_81_1:setTouchEnabled(false)
		arg_81_1:addTouchEventListener(function()
		end)
	end
	
	for iter_81_0, iter_81_1 in pairs(arg_81_1:getChildren()) do
		arg_81_0:eachDisableTouchListener(iter_81_1)
	end
end

function CustomLobbySettingPreview.Layout.updateLayoutPoses(arg_83_0)
	if arg_83_0.vars.force_set_preview_sz then
		if arg_83_0.vars.custom_layout_poses_callback then
			print("custom_layout_poses_callback!!!")
			arg_83_0.vars.custom_layout_poses_callback(arg_83_0, true)
		end
		
		return 
	end
	
	if not arg_83_0.vars.force_set_preview_sz then
		arg_83_0.vars.preview_sz = CustomLobbySettingPreview.Data:getPreviewSize()
		arg_83_0.vars.preview_margin = CustomLobbySettingPreview.Data:getPreviewMargin()
	end
	
	local var_83_0 = arg_83_0.vars.preview_sz
	local var_83_1 = arg_83_0.vars.preview_margin
	local var_83_2 = var_83_0.width
	local var_83_3 = var_83_0.height
	
	arg_83_0.vars.layout:setPositionX(22 + arg_83_0.vars.preview_margin / 2)
	arg_83_0.vars.layout:setContentSize(var_83_2, var_83_3)
	
	if arg_83_0.vars.custom_layout_poses_callback then
		arg_83_0.vars.custom_layout_poses_callback(arg_83_0)
	end
end

function CustomLobbySettingPreview.Layout.update(arg_84_0)
end

function CustomLobbySettingPreview.Layout.onSelectUnit(arg_85_0, arg_85_1)
	arg_85_0:settingUnit(arg_85_1)
end

function CustomLobbySettingPreview.Layout.onSelectSkin(arg_86_0, arg_86_1)
	arg_86_0:settingUnit(arg_86_1)
end

function CustomLobbySettingPreview.Layout.replaceGrowWhite(arg_87_0)
	local var_87_0 = arg_87_0.vars.thumbnail:getChildByName("n_grow")
	local var_87_1 = var_87_0:getChildByName("top_grow")
	local var_87_2 = var_87_0:getChildByName("LEFT")
	local var_87_3 = var_87_0:getChildByName("RIGHT")
	local var_87_4 = var_87_0:getChildByName("TOP_LEFT")
	local var_87_5 = {
		var_87_2,
		var_87_3,
		var_87_4
	}
	
	SpriteCache:resetSprite(var_87_1, "img/_grow_s_white.png")
	
	local var_87_6 = {
		"grow",
		"grow1",
		"grow2"
	}
	
	for iter_87_0, iter_87_1 in pairs(var_87_5) do
		for iter_87_2, iter_87_3 in pairs(var_87_6) do
			local var_87_7 = iter_87_1:getChildByName(iter_87_3)
			
			if get_cocos_refid(var_87_7) then
				SpriteCache:resetSprite(var_87_7, "img/_grow_white.png")
			end
		end
	end
end

function CustomLobbySettingPreview.Layout.updateDimColor(arg_88_0, arg_88_1, arg_88_2, arg_88_3)
	if not arg_88_2 then
		local var_88_0 = arg_88_0.vars.thumbnail:getChildByName("n_lobby")
		local var_88_1 = {}
		
		if arg_88_0.vars.is_illust_mode then
			var_88_1.illust_id = arg_88_3 or CustomLobbySettingPreview.Data:getSelectedIllust()
		else
			var_88_1.background_id = arg_88_3 or CustomLobbySettingPreview.Data:getSelectedBGPack()
		end
		
		local var_88_2 = "hero"
		
		if arg_88_0.vars.is_illust_mode then
			var_88_2 = "illust"
		end
		
		arg_88_2 = CustomLobby:findTintColor(var_88_1, var_88_2).dim_color
	end
	
	local var_88_3 = arg_88_0.vars.thumbnail:getChildByName("n_grow")
	local var_88_4 = var_88_3:getChildByName("top_grow")
	local var_88_5 = var_88_3:getChildByName("LEFT")
	local var_88_6 = var_88_3:getChildByName("TOP_LEFT")
	local var_88_7 = var_88_3:getChildByName("RIGHT")
	
	local function var_88_8(arg_89_0)
		arg_89_0:setColor(arg_88_2)
	end
	
	var_88_8(var_88_4)
	var_88_8(var_88_5)
	var_88_8(var_88_7)
	var_88_8(var_88_6)
end

function CustomLobbySettingPreview.Layout.setVisibleBG(arg_90_0, arg_90_1)
	if not arg_90_0.vars or not get_cocos_refid(arg_90_0.vars.layout) then
		return 
	end
	
	if_set_visible(arg_90_0.vars.layout, "bg", arg_90_1)
end

function CustomLobbySettingPreview.Layout.onSelectIllust(arg_91_0, arg_91_1)
	local var_91_0 = arg_91_0.vars.thumbnail:getChildByName("n_lobby")
	
	arg_91_0:clearIllust()
	
	local var_91_1
	local var_91_2
	local var_91_3
	local var_91_4
	local var_91_5 = DB("dic_data_illust", arg_91_1, "illust")
	
	if var_91_5 and string.find(var_91_5, "theme:") then
		var_91_1 = CustomLobbyIllust.Util:createThemeIllust(var_91_5, var_91_0)
		var_91_4 = true
	else
		var_91_1, var_91_2, var_91_3 = CustomLobbyIllust.Util:createIllust(arg_91_1, arg_91_0.vars.create_path)
	end
	
	if var_91_4 then
	elseif var_91_2 then
		var_91_0:addChild(var_91_1)
		EffectManager:EffectPlay(var_91_3)
	else
		var_91_0:addChild(var_91_1)
	end
	
	CustomLobbyIllust.Util:resetZoomController(arg_91_0.vars.zoom_cont, var_91_1)
	
	arg_91_0.vars.illust = var_91_1
	
	if_set_visible(arg_91_0.vars.layout, "bg", false)
	arg_91_0:updateDimColor(nil, nil, arg_91_1)
end

function CustomLobbySettingPreview.Layout.clearIllust(arg_92_0)
	if arg_92_0.vars.zoom_cont and get_cocos_refid(arg_92_0.vars.zoom_cont.target) then
		local var_92_0 = arg_92_0.vars.thumbnail:getChildByName("n_lobby")
		local var_92_1 = arg_92_0.vars.zoom_cont.target
		local var_92_2 = arg_92_0.vars.zoom_cont.pivot
		
		arg_92_0.vars.zoom_cont:detachZoomNode()
		var_92_1:release()
		var_92_2:release()
		arg_92_0:setZoomCont()
	end
end

function CustomLobbySettingPreview.Layout.settingUnit(arg_93_0, arg_93_1, arg_93_2)
	local var_93_0
	
	if not arg_93_2 then
		var_93_0 = DB("character", arg_93_1, "face_id")
	else
		var_93_0 = arg_93_1
	end
	
	local var_93_1, var_93_2 = UIUtil:getPortraitAni(var_93_0)
	
	if get_cocos_refid(arg_93_0.vars.cur_portrait) then
		arg_93_0.vars.cur_portrait:removeFromParent()
	end
	
	arg_93_0.vars.thumbnail:getChildByName("n_portrait"):addChild(var_93_1)
	
	arg_93_0.vars.cur_portrait = var_93_1
	arg_93_0.vars.cur_portrait_is_ani = var_93_2
	
	arg_93_0:resetZoomControlSetting()
	CustomLobbyUnit.Util:setPortraitPoses(arg_93_0.vars.cur_portrait, CustomLobbyUnit:getPortraitPosesContentSz(), var_93_2)
	arg_93_0.vars.zoom_cont:setHeadLineMode(var_93_2)
end

function CustomLobbySettingPreview.Layout.onSelectEmotion(arg_94_0, arg_94_1)
	local var_94_0 = arg_94_0.vars.cur_portrait
	
	if arg_94_1 and var_94_0 and var_94_0.setSkin then
		var_94_0:setSkin(arg_94_1)
	end
end

function CustomLobbySettingPreview.Layout.onSelectBGPack(arg_95_0, arg_95_1)
	local var_95_0 = SLOW_DB_ALL("item_material_bgpack", arg_95_1)
	
	if not var_95_0 or not var_95_0.id then
		Log.e("ERR : BG NOT EXIST", arg_95_1)
		
		return 
	end
	
	if get_cocos_refid(arg_95_0.vars.cur_bg) then
		arg_95_0.vars.cur_bg:removeFromParent()
	end
	
	local var_95_1 = CustomLobbyUnit.Util:setupBG(arg_95_0.vars.thumbnail:getChildByName("n_lobby"), arg_95_1)
	
	arg_95_0.vars.cur_bg = var_95_1
	
	if_set_visible(arg_95_0.vars.thumbnail, "bg", false)
	arg_95_0:updateDimColor(nil, nil, arg_95_1)
end

function CustomLobbySettingPreview.Layout.convertToStickerNodePos(arg_96_0, arg_96_1, arg_96_2, arg_96_3)
	local var_96_0 = arg_96_1:convertToNodeSpace({
		x = arg_96_2,
		y = arg_96_3
	})
	local var_96_1 = arg_96_1:getContentSize().width
	local var_96_2 = var_96_0.x - var_96_1 / 2
	local var_96_3 = var_96_0.y - var_96_1 / 2
	
	return var_96_2, var_96_3
end

function CustomLobbySettingPreview.Layout.changeEditDrawNode(arg_97_0, arg_97_1)
	if arg_97_0.vars.selected_sticker_node then
		if_set_visible(arg_97_0.vars.selected_sticker_node, "preview_area_draw_node", false)
	end
	
	arg_97_0.vars.selected_sticker_node = arg_97_1
	
	if_set_visible(arg_97_0.vars.selected_sticker_node, "preview_area_draw_node", true)
end

function CustomLobbySettingPreview.Layout.checkScalePointIn(arg_98_0, arg_98_1, arg_98_2, arg_98_3)
	local var_98_0 = {
		{
			x = -arg_98_1 / 2,
			y = -arg_98_1 / 2
		},
		{
			x = arg_98_1 / 2,
			y = -arg_98_1 / 2
		},
		{
			x = arg_98_1 / 2,
			y = arg_98_1 / 2
		},
		{
			x = -arg_98_1 / 2,
			y = arg_98_1 / 2
		}
	}
	local var_98_1 = CustomLobbyUnit.Sticker:getDragPointDefaultRadius(arg_98_1)
	local var_98_2 = var_98_1 * var_98_1
	
	for iter_98_0, iter_98_1 in pairs(var_98_0) do
		local var_98_3 = arg_98_2 - iter_98_1.x
		local var_98_4 = arg_98_3 - iter_98_1.y
		
		if var_98_2 > var_98_3 * var_98_3 + var_98_4 * var_98_4 then
			return true, iter_98_0
		end
	end
	
	return false
end

function CustomLobbySettingPreview.Layout.onStickerTouchDown(arg_99_0, arg_99_1, arg_99_2, arg_99_3)
	arg_99_0:changeEditDrawNode(arg_99_1:getParent():getParent())
	
	local var_99_0, var_99_1 = arg_99_0:convertToStickerNodePos(arg_99_1, arg_99_2, arg_99_3)
	local var_99_2 = arg_99_1:getParent():getContentSize().width
	
	if arg_99_0:checkScalePointIn(var_99_2, var_99_0, var_99_1) then
		arg_99_0.vars.state = "scale_or_rotate"
	else
		arg_99_0.vars.state = "move"
	end
	
	arg_99_0.vars.state_active_status = false
	
	local var_99_3 = arg_99_0.vars.sticker_layer:convertToNodeSpace({
		x = arg_99_2,
		y = arg_99_3
	})
	local var_99_4, var_99_5 = arg_99_0:convertToStickerNodePos(arg_99_0.vars.selected_sticker_node, arg_99_2, arg_99_3)
	local var_99_6 = math.atan2(var_99_5, var_99_4) * 180 / math.pi + 180
	
	arg_99_0.vars.sticker_move_anchor_pos = {
		x = var_99_3.x,
		y = var_99_3.y
	}
	arg_99_0.vars.state_active_check_anchor_pos = {
		x = arg_99_2,
		y = arg_99_3
	}
	arg_99_0.vars.sticker_anchor_pos = {
		x = var_99_4,
		y = var_99_4
	}
	arg_99_0.vars.sticker_anchor_angle = var_99_6
	arg_99_0.vars.sticker_touch_move = false
end

function CustomLobbySettingPreview.Layout.onStickerTouchMove(arg_100_0, arg_100_1, arg_100_2, arg_100_3)
	if not arg_100_0.vars.state_active_status then
		local var_100_0 = arg_100_2
		local var_100_1 = arg_100_3
		
		if math.abs(var_100_0 - arg_100_0.vars.state_active_check_anchor_pos.x) + math.abs(var_100_1 - arg_100_0.vars.state_active_check_anchor_pos.y) > 8 then
			if arg_100_0.vars.state == "move" then
				local var_100_2 = arg_100_0.vars.sticker_layer:convertToNodeSpace({
					x = arg_100_2,
					y = arg_100_3
				})
				
				arg_100_0.vars.sticker_move_anchor_pos.x = var_100_2.x
				arg_100_0.vars.sticker_move_anchor_pos.y = var_100_2.y
			else
				local var_100_3, var_100_4 = arg_100_0:convertToStickerNodePos(arg_100_0.vars.selected_sticker_node, arg_100_2, arg_100_3)
				local var_100_5 = math.atan2(var_100_4, var_100_3) * 180 / math.pi + 180
				
				arg_100_0.vars.sticker_anchor_angle = var_100_5
				arg_100_0.vars.sticker_anchor_pos.x = var_100_3
				arg_100_0.vars.sticker_anchor_pos.y = var_100_4
			end
			
			arg_100_0.vars.state_active_status = true
		else
			return 
		end
	end
	
	local var_100_6 = arg_100_1:getParent()
	
	if arg_100_0.vars.state == "move" then
		local var_100_7 = var_100_6:getParent()
		local var_100_8 = arg_100_0.vars.sticker_layer:convertToNodeSpace({
			x = arg_100_2,
			y = arg_100_3
		})
		local var_100_9 = arg_100_0.vars.sticker_move_anchor_pos
		local var_100_10, var_100_11 = var_100_7:getPosition()
		
		var_100_7:setPosition(var_100_10 + (var_100_8.x - var_100_9.x), var_100_11 + (var_100_8.y - var_100_9.y))
		
		arg_100_0.vars.sticker_move_anchor_pos.x = var_100_8.x
		arg_100_0.vars.sticker_move_anchor_pos.y = var_100_8.y
	elseif arg_100_0.vars.state == "scale_or_rotate" then
		local var_100_12, var_100_13 = arg_100_0:convertToStickerNodePos(var_100_6:getParent(), arg_100_2, arg_100_3)
		local var_100_14 = math.atan2(var_100_13, var_100_12) * 180 / math.pi + 180
		local var_100_15 = arg_100_0.vars.sticker_anchor_angle - var_100_14
		local var_100_16 = 1
		
		var_100_6:setRotation(var_100_6:getRotation() + var_100_15 * var_100_16)
		
		arg_100_0.vars.sticker_anchor_angle = var_100_14
		
		local var_100_17 = math.abs(var_100_12) + math.abs(var_100_13) - (math.abs(arg_100_0.vars.sticker_anchor_pos.x) + math.abs(arg_100_0.vars.sticker_anchor_pos.y))
		local var_100_18 = var_100_6:getContentSize()
		
		var_100_18.width = math.max(var_100_18.width + var_100_17, 30)
		var_100_18.height = math.max(var_100_18.height + var_100_17, 30)
		var_100_18.width = math.min(var_100_18.width, 450)
		var_100_18.height = math.min(var_100_18.height, 450)
		
		local var_100_19 = CustomLobbyUnit.Sticker:getStickerBtnAdditionalWidth()
		
		arg_100_1:setContentSize({
			width = var_100_18.width + var_100_19,
			height = var_100_18.height + var_100_19
		})
		arg_100_1:setPosition(var_100_18.width / 2, var_100_18.width / 2)
		var_100_6:setContentSize(var_100_18)
		var_100_6:getChildByName("sticker"):setContentSize(var_100_18)
		var_100_6:getChildByName("lobby_custom_sticker_x"):setPosition(var_100_18.width, var_100_18.height)
		CustomLobbyUnit.Sticker:updatePreviewArea(var_100_6:getChildByName("preview_area_draw_node"), var_100_18.width)
		
		arg_100_0.vars.sticker_anchor_pos.x = var_100_12
		arg_100_0.vars.sticker_anchor_pos.y = var_100_13
	else
		print("UNKNOWN STATE: ", arg_100_0.vars.state)
	end
	
	arg_100_0.vars.sticker_touch_move = true
end

function CustomLobbySettingPreview.Layout.onStickerTouchUp(arg_101_0, arg_101_1, arg_101_2, arg_101_3)
	if not arg_101_0.vars.sticker_touch_move then
		local var_101_0, var_101_1 = arg_101_0:convertToStickerNodePos(arg_101_1, arg_101_2, arg_101_3)
		local var_101_2 = arg_101_0.vars.sticker_anchor_pos
		local var_101_3 = arg_101_1:getParent():getContentSize().width
		local var_101_4, var_101_5 = arg_101_0:checkScalePointIn(var_101_3, var_101_0, var_101_1)
		
		if var_101_4 and var_101_5 == 3 then
			CustomLobbySettingSticker:onRemoveSticker(arg_101_1.uid)
		end
	end
end

function CustomLobbySettingPreview.Layout.onStickerTouchEventHandler(arg_102_0, arg_102_1, arg_102_2, arg_102_3, arg_102_4)
	if arg_102_0.vars.touch_listener_mode ~= "sticker_edit" then
		return 
	end
	
	if arg_102_2 == 0 then
		arg_102_0:onStickerTouchDown(arg_102_1, arg_102_3, arg_102_4)
	end
	
	if arg_102_2 == 1 then
		arg_102_0:onStickerTouchMove(arg_102_1, arg_102_3, arg_102_4)
	end
	
	if arg_102_2 == 2 then
		arg_102_0:onStickerTouchUp(arg_102_1, arg_102_3, arg_102_4)
	end
end

function CustomLobbySettingPreview.Layout.onAddSticker(arg_103_0, arg_103_1)
	local var_103_0 = arg_103_0.vars.sticker_layer
	local var_103_1 = CustomLobbyUnit.Sticker:getStickerRenderObject(arg_103_1, true, function(arg_104_0, arg_104_1, arg_104_2, arg_104_3)
		arg_103_0:onStickerTouchEventHandler(arg_104_0, arg_104_1, arg_104_2, arg_104_3)
	end)
	
	var_103_0:addChild(var_103_1)
	
	if arg_103_0.vars.touch_listener_mode == "sticker_edit" then
		arg_103_0:changeEditDrawNode(var_103_1)
	end
end

function CustomLobbySettingPreview.Layout.onRemoveSticker(arg_105_0, arg_105_1)
	local var_105_0 = arg_105_0.vars.sticker_layer:getChildByName("custom_lobby_sticker:" .. arg_105_1)
	
	if get_cocos_refid(var_105_0) then
		var_105_0:removeFromParent()
	end
end

function CustomLobbySettingPreview.Layout.clearStickers(arg_106_0)
	arg_106_0.vars.sticker_layer:removeAllChildren()
end

function CustomLobbySettingPreview.Layout.getStickerInfo(arg_107_0, arg_107_1)
	local var_107_0 = arg_107_0.vars.sticker_layer:getChildByName("custom_lobby_sticker:" .. arg_107_1)
	local var_107_1
	
	if get_cocos_refid(var_107_0) then
		local var_107_2 = var_107_0:getChildByName("lobby_custom_sticker")
		
		if get_cocos_refid(var_107_2) then
			var_107_1 = {}
			
			local var_107_3 = var_107_2:getContentSize()
			local var_107_4, var_107_5 = var_107_0:getPosition()
			local var_107_6 = CustomLobbyUnit.Sticker:getStickerDefaultSize()
			
			var_107_1.uid = arg_107_1
			var_107_1.scale_x = var_107_3.width / var_107_6
			var_107_1.scale_y = var_107_3.height / var_107_6
			var_107_1.x = var_107_4
			var_107_1.y = var_107_5
			var_107_1.rotation = var_107_2:getRotation()
		end
	end
	
	return var_107_1
end

function CustomLobbySettingPreview.Layout.createTest(arg_108_0)
	local var_108_0 = cc.LayerColor:create(cc.c3b(192, 72, 201))
	
	var_108_0:setContentSize(2000, 2000)
	arg_108_0.vars.layout:addChild(var_108_0)
end
