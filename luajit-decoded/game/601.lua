CustomLobbyChoose = {}

function HANDLER.lobby_choose_card(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_sel" then
		CustomLobbyChoose:choose(arg_1_0.type)
	end
end

function HANDLER.lobby_choose(arg_2_0, arg_2_1)
	if arg_2_1 == "btn_set" then
		CustomLobbyChoose:setAsLobby()
	end
	
	if arg_2_1 == "btn_detail" then
		CustomLobbyChoose:detail()
	end
	
	if arg_2_1 == "btn_cancel" or arg_2_1 == "btn_close" then
		CustomLobbyChoose:close()
	end
end

function CustomLobbyChoose.open(arg_3_0, arg_3_1)
	CustomLobby:setAsDefaultOnNotExistSave()
	
	arg_3_1 = arg_3_1 or {}
	
	local var_3_0 = arg_3_1.parent_layer or SceneManager:getRunningPopupScene()
	
	arg_3_0.vars = {}
	
	local var_3_1 = load_dlg("lobby_choose", true, "wnd")
	
	BackButtonManager:push({
		check_id = "custom_lobby_choose_box",
		back_func = function()
			arg_3_0:close()
		end,
		dlg = var_3_1
	})
	
	arg_3_0.vars.dlg = var_3_1
	arg_3_0.vars.display_count = 3
	arg_3_0.vars.scroll_ratio = 0.5
	arg_3_0.vars.item_gap = 484.5
	arg_3_0.vars.selected_item_pos = 0.5
	arg_3_0.vars.zoom_scale = 0.48
	arg_3_0.vars.items = {}
	
	arg_3_0:setupUI()
	
	local var_3_2 = SAVE:getKeep("custom_lobby.mode") or "default"
	
	arg_3_0:choose(var_3_2)
	arg_3_0:setDefaultListViewPos(var_3_2)
	var_3_0:addChild(var_3_1)
end

function CustomLobbyChoose.isActive(arg_5_0)
	return arg_5_0.vars and get_cocos_refid(arg_5_0.vars.dlg)
end

function CustomLobbyChoose.setDefaultListViewPos(arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0.vars.dlg:getChildByName("new_card_listview")
	local var_6_1
	
	for iter_6_0, iter_6_1 in pairs(arg_6_0.vars.layout_items) do
		if iter_6_1.id == arg_6_1 then
			var_6_1 = iter_6_1.idx
			
			break
		end
	end
	
	var_6_1 = var_6_1 or 1
	
	arg_6_0:scrollToIndex(var_6_1)
end

CUSTOM_LOBBY_INNER_HEIGHT = 324

local var_0_0 = 0.97
local var_0_1 = 27
local var_0_2 = 10

function CustomLobbyChoose.reCalcRendererSize(arg_7_0, arg_7_1)
	local var_7_0 = CUSTOM_LOBBY_INNER_HEIGHT
	local var_7_1 = var_7_0 * (VIEW_WIDTH / VIEW_HEIGHT)
	local var_7_2 = arg_7_1:getContentSize().height
	local var_7_3 = var_7_1 + 39
	
	arg_7_1:setContentSize(var_7_3, var_7_2)
	;(function(arg_8_0, arg_8_1)
		local var_8_0 = arg_8_0
		
		if var_8_0 then
			local var_8_1 = var_8_0.vars.layout:getContentSize()
			local var_8_2 = arg_7_1:getChildByName("n_selected")
			local var_8_3 = var_8_2:getChildByName("line")
			
			if arg_8_1 then
				var_8_3:setVisible(false)
				
				var_8_3 = var_8_2:getChildByName("line_illust")
				
				var_8_3:setVisible(true)
				var_8_0.vars.layout:setScale(var_0_0)
			end
			
			local var_8_4 = table.clone(var_8_1)
			local var_8_5 = 4
			
			var_8_4.width = var_7_1 + var_8_5
			var_8_4.height = var_7_0 + var_8_5
			
			local var_8_6 = 24
			local var_8_7 = -2
			
			var_8_3:setContentSize(var_8_4)
			var_8_3:setPosition(var_8_4.width / 2 + var_8_6, var_8_4.height / 2 + var_8_7)
		end
		
		local var_8_8 = {
			width = var_7_1,
			height = var_7_0
		}
		
		var_8_0:updateDimSize(arg_7_1:getChildByName("thumbnail"):getContentSize())
		var_8_0.vars.layout:setContentSize(var_8_8)
	end)(arg_7_1.layout, arg_7_1.illust_layout)
	
	local var_7_4 = arg_7_1:getChildByName("selected")
	local var_7_5 = VIEW_WIDTH / VIEW_HEIGHT / (DESIGN_WIDTH / DESIGN_HEIGHT)
	
	var_7_4:setPositionX(var_7_3 / 2)
	var_7_4:setScaleX(5.3 * var_7_5)
	
	local var_7_6 = arg_7_1:getChildByName("t_desc")
	
	if var_7_6 then
		local var_7_7 = var_7_6:getContentSize().height
		
		var_7_6:setContentSize(var_7_3, var_7_7)
		var_7_6:setTextAreaSize({
			width = var_7_3,
			height = var_7_7
		})
	end
	
	arg_7_1:getChildByName("btn_sel"):setContentSize(var_7_3, var_7_2)
end

function CustomLobbyChoose.createListViewItemCommon(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = load_control("wnd/lobby_choose_card.csb")
	local var_9_1, var_9_2, var_9_3 = DB("lobby_type", arg_9_1, {
		"icon",
		"title",
		"desc"
	})
	local var_9_4 = "img/" .. var_9_1 .. ".png"
	
	if_set_sprite(var_9_0, "icon_title", var_9_4)
	if_set(var_9_0, "t_title", T(var_9_2))
	if_set(var_9_0, "t_desc", T(var_9_3))
	
	local var_9_5 = CUSTOM_LOBBY_INNER_HEIGHT
	local var_9_6 = var_9_5 * (VIEW_WIDTH / VIEW_HEIGHT)
	
	;(function()
		local var_10_0 = CustomLobbySettingPreview.Layout:createInstance(var_9_0, {
			width = var_9_6,
			height = var_9_5
		}, 0, arg_9_1 == "illust")
		
		var_10_0.vars.layout:setPosition(25, 0)
		
		if arg_9_1 == "illust" then
			var_10_0.vars.layout:setScale(var_0_0)
			var_10_0.vars.layout:setPosition(var_0_1, var_0_2)
		end
		
		var_9_0.layout = var_10_0
		
		local var_10_1 = var_9_0:getChildByName("btn_sel")
		
		if arg_9_1 == "pub" then
			var_10_1.type = "default"
		else
			var_10_1.type = arg_9_1
		end
		
		if_set_visible(var_10_1, nil, false)
		var_10_0.vars.layout:setTouchEnabled(false)
		var_9_0:getChildByName("thumbnail"):setTouchEnabled(false)
		
		return var_10_0
	end)()
	
	return var_9_0
end

function CustomLobbyChoose.createListViewItemDefaultLobby(arg_11_0)
	local var_11_0 = arg_11_0:createListViewItemCommon("pub")
	
	arg_11_0.vars.items.default = var_11_0
	
	return var_11_0
end

function CustomLobbyChoose.loadHeroLayout(arg_12_0, arg_12_1)
	local var_12_0 = CustomLobbyUnit.Data:loadUnitSettingData(true)
	
	if var_12_0 then
		arg_12_1:onSelectSkin(var_12_0.face_id)
		
		if var_12_0.emotion_id then
			arg_12_1:onSelectEmotion(var_12_0.emotion_id)
		end
		
		arg_12_1:onSelectBGPack(var_12_0.background_id)
		arg_12_1:loadZoomControlSetting(var_12_0.zoom_cont)
		arg_12_1:clearStickers()
		
		local var_12_1 = CustomLobbyUnit:getSortedStickerList(var_12_0.stickers or {})
		
		for iter_12_0 = 1, #var_12_1 do
			local var_12_2 = var_12_1[iter_12_0]
			
			var_12_2.uid = iter_12_0
			
			arg_12_1:onAddSticker(var_12_2)
		end
		
		arg_12_1:setTouchStickersIgnoreMode(false)
	end
end

function CustomLobbyChoose.createListViewItemUnitLobby(arg_13_0)
	local var_13_0 = arg_13_0:createListViewItemCommon("hero")
	local var_13_1 = var_13_0.layout
	
	arg_13_0:loadHeroLayout(var_13_1)
	
	arg_13_0.vars.items.hero = var_13_0
	
	return var_13_0
end

function CustomLobbyChoose.reloadListViewUnitLobby(arg_14_0)
	if not arg_14_0:isActive() then
		return 
	end
	
	local var_14_0 = arg_14_0.vars.items.hero.layout
	
	arg_14_0:loadHeroLayout(var_14_0)
end

function CustomLobbyChoose.loadIllustLayout(arg_15_0, arg_15_1, arg_15_2)
	arg_15_1:onSelectIllust(arg_15_2)
end

function CustomLobbyChoose.loadIllustLayouts(arg_16_0, arg_16_1)
	local var_16_0 = CustomLobbyIllust.Data:loadIllustSettingData(true)
	local var_16_1 = CustomLobbyIllust.Util:getIllustIdToTable(var_16_0)
	local var_16_2 = CustomLobbyIllust.Data:getCurIllustId(var_16_0)
	local var_16_3 = {}
	
	for iter_16_0, iter_16_1 in pairs(var_16_1) do
		var_16_3[iter_16_1] = iter_16_0
	end
	
	table.sort(var_16_1, function(arg_17_0, arg_17_1)
		if arg_17_0 == var_16_2 then
			return false
		end
		
		if arg_17_1 == var_16_2 then
			return true
		end
		
		return var_16_3[arg_17_0] < var_16_3[arg_17_1]
	end)
	
	local var_16_4 = #var_16_1
	local var_16_5 = arg_16_1
	
	if_set_visible(var_16_5.vars.layout, nil, false)
	
	local var_16_6 = var_16_5
	local var_16_7 = var_16_1[var_16_4]
	
	if_set_visible(var_16_6.vars.layout, nil, true)
	arg_16_0:loadIllustLayout(var_16_6, var_16_7)
	var_16_6:setVisibleMockup(var_16_4 == #var_16_1)
end

function CustomLobbyChoose.createListViewItemIllustLobby(arg_18_0)
	local var_18_0 = arg_18_0:createListViewItemCommon("illust")
	local var_18_1 = var_18_0.layout
	
	arg_18_0:loadIllustLayouts(var_18_1)
	
	var_18_0.illust_layout = true
	arg_18_0.vars.items.illust = var_18_0
	
	return var_18_0
end

function CustomLobbyChoose.reloadListViewIllustLobby(arg_19_0)
	if not arg_19_0:isActive() then
		return 
	end
	
	local var_19_0 = arg_19_0.vars.items.illust.layout
	
	arg_19_0:loadIllustLayouts(var_19_0)
end

function CustomLobbyChoose.onScrollViewEvent(arg_20_0, arg_20_1, arg_20_2)
	if not arg_20_0.vars then
		return 
	end
	
	if arg_20_2 == 9 then
		arg_20_0:arrangeItems()
	elseif arg_20_2 == 10 then
		arg_20_0:arrangeItems()
	end
	
	if false then
	end
	
	arg_20_0.vars.scroll_event_tick = uitick()
end

function CustomLobbyChoose.updateScrollIndex(arg_21_0)
	local var_21_0 = arg_21_0.vars.scrollview:getInnerContainerPosition()
	
	if math.is_nan_or_inf(var_21_0.x) then
		arg_21_0.vars.scrollview:setInnerContainerPosition({
			x = 0,
			y = var_21_0.y
		})
	end
	
	local var_21_1 = arg_21_0.vars.scrollview:getInnerContainerPosition()
	
	arg_21_0.vars.offset = var_21_1.x
	arg_21_0.f_index = (arg_21_0.vars.item_size * arg_21_0.vars.item_count + arg_21_0.vars.offset * arg_21_0.vars.scroll_ratio) / arg_21_0.vars.item_size
end

function CustomLobbyChoose.getControlInfo(arg_22_0, arg_22_1)
	local var_22_0 = 1
	local var_22_1 = arg_22_0.f_index
	
	if var_22_1 < -1 then
		var_22_1 = -1
	end
	
	if var_22_1 > arg_22_0.vars.item_count + 0.5 then
		var_22_1 = arg_22_0.vars.item_count + 0.5
	end
	
	local var_22_2 = 1
	local var_22_3 = math.max(var_22_2, math.floor(arg_22_0.vars.display_count * arg_22_0.vars.selected_item_pos))
	local var_22_4 = arg_22_0.vars.display_count - var_22_3
	
	if arg_22_1 < var_22_1 - var_22_3 - 1 or arg_22_1 > var_22_1 + var_22_4 + 2 then
		return nil
	end
	
	if arg_22_1 < var_22_1 - var_22_3 then
		var_22_0 = 1 - math.min(0.7, var_22_1 - var_22_3 - arg_22_1)
	end
	
	if arg_22_1 > var_22_1 + var_22_4 + 1 then
		var_22_0 = 1 - (arg_22_1 - (var_22_1 + var_22_4 + 1))
	end
	
	local var_22_5 = math.abs(var_22_1 - arg_22_1)
	
	if var_22_5 > 3 then
		return arg_22_0.vars.zoom_scale, var_22_0
	end
	
	local var_22_6 = 0.95
	
	return math.max(arg_22_0.vars.zoom_scale, var_22_6 - (var_22_6 - arg_22_0.vars.zoom_scale) * (var_22_5 / 3)), var_22_0
end

function CustomLobbyChoose.getControl(arg_23_0, arg_23_1, arg_23_2)
	local var_23_0 = arg_23_0.vars.layouts[arg_23_2]
	
	if not var_23_0._was_setting then
		var_23_0:setAnchorPoint(0.5, 0)
		
		var_23_0._was_setting = true
		var_23_0.item = arg_23_1
	end
	
	return var_23_0
end

function CustomLobbyChoose.arrangeItems(arg_24_0)
	arg_24_0:updateScrollIndex()
	
	local var_24_0 = 0
	local var_24_1 = 0
	local var_24_2 = -1
	local var_24_3
	
	for iter_24_0 = arg_24_0.vars.item_count, 1, -1 do
		local var_24_4 = arg_24_0.vars.layout_items[iter_24_0]
		local var_24_5, var_24_6 = arg_24_0:getControlInfo(iter_24_0)
		local var_24_7 = arg_24_0:getControl(var_24_4, iter_24_0)
		
		if var_24_5 then
			var_24_0, var_24_1, var_24_2, var_24_3 = arg_24_0:_arrangeItemsOnHaveScale(var_24_7, var_24_4, iter_24_0, var_24_5, var_24_6, var_24_0, var_24_1, var_24_2, var_24_3)
		else
			var_24_0, var_24_1 = arg_24_0:_arrangeItemsOnElse(var_24_7, iter_24_0, var_24_0, var_24_1)
		end
	end
	
	arg_24_0:_arrangeItemsOnFinish(var_24_3, var_24_1)
end

function CustomLobbyChoose._arrangeItemsOnElse(arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4)
	if arg_25_1 then
		arg_25_1:setVisible(false)
	end
	
	arg_25_3 = arg_25_3 + arg_25_0.vars.item_gap
	
	if arg_25_2 >= arg_25_0.f_index then
		arg_25_4 = arg_25_4 - arg_25_0.vars.item_gap
	end
	
	return arg_25_3, arg_25_4
end

function CustomLobbyChoose._arrangeItemsOnHaveScale(arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4, arg_26_5, arg_26_6, arg_26_7, arg_26_8, arg_26_9)
	arg_26_1.idx = arg_26_3
	
	if not arg_26_1:isVisible() then
		arg_26_1:setVisible(true)
	end
	
	local var_26_0 = arg_26_1:getScaleX()
	
	if var_26_0 ~= arg_26_4 then
		arg_26_1:setScaleX(arg_26_4)
		arg_26_1:setScaleY(arg_26_4)
	end
	
	local var_26_1 = arg_26_0.vars.item_gap
	local var_26_2 = arg_26_0.vars.item_count - arg_26_3
	
	if arg_26_4 > arg_26_0.vars.zoom_scale then
		var_26_2 = var_26_2 + arg_26_4 * 100
	end
	
	arg_26_1:setLocalZOrder(var_26_2)
	
	if arg_26_8 < var_26_2 then
		arg_26_8 = var_26_2
		arg_26_9 = arg_26_2
		arg_26_0.index = arg_26_3
	end
	
	if arg_26_4 > arg_26_0.vars.zoom_scale then
		var_26_1 = arg_26_0.vars.item_gap + (arg_26_0.vars.item_size - arg_26_0.vars.item_gap * 2) * ((arg_26_4 - arg_26_0.vars.zoom_scale) / (1 - arg_26_0.vars.zoom_scale))
		var_26_1 = arg_26_0.vars.item_gap
		
		if var_26_0 ~= arg_26_4 then
			local var_26_3 = (arg_26_4 - arg_26_0.vars.zoom_scale) / (1 - arg_26_0.vars.zoom_scale)
		end
	end
	
	arg_26_1:setPositionX(arg_26_6)
	
	arg_26_6 = arg_26_6 + var_26_1
	
	if arg_26_3 > arg_26_0.f_index then
		arg_26_7 = arg_26_7 - var_26_1
	elseif arg_26_0.f_index - arg_26_3 < 1 then
		arg_26_7 = arg_26_7 - var_26_1 * (1 - (arg_26_0.f_index - arg_26_3))
	end
	
	arg_26_1:setOpacity(255 * arg_26_5)
	
	if arg_26_0.vars.cur_item then
		local function var_26_4(arg_27_0)
			if arg_26_0.vars.cur_item == arg_26_2 then
				arg_27_0:setDimOpacity(0)
				if_set_color(arg_26_1, nil, tocolor("#FFFFFF"))
			else
				arg_27_0:setDimOpacity(0.5)
				if_set_color(arg_26_1, nil, tocolor("#7F7F7F"))
			end
		end
		
		local var_26_5 = arg_26_1.layout
		
		var_26_4(var_26_5)
	end
	
	return arg_26_6, arg_26_7, arg_26_8, arg_26_9
end

function CustomLobbyChoose._arrangeItemsOnFinish(arg_28_0, arg_28_1, arg_28_2)
	arg_28_2 = arg_28_2 + arg_28_0.vars.panel_size * (1 - arg_28_0.vars.selected_item_pos)
	arg_28_2 = arg_28_2 + 100
	
	arg_28_0.vars.panel:setPositionX(arg_28_2)
	
	if arg_28_1 and arg_28_0.vars.cur_item ~= arg_28_1 then
		arg_28_0.vars.cur_item = arg_28_1
		
		arg_28_0:choose(arg_28_0.vars.cur_item.id)
	end
	
	if arg_28_1 and arg_28_0.vars.cur_item == arg_28_1 then
	end
end

function CustomLobbyChoose.onTouchBegin(arg_29_0, arg_29_1, arg_29_2)
	local var_29_0 = arg_29_1:getLocation()
	
	if not checkCollisionDynamic(arg_29_0.vars.scrollview, var_29_0.x, var_29_0.y) then
		arg_29_0.vars.scrollview_touch_x = nil
		arg_29_0.vars.scrollview_touch_y = nil
		
		return false
	end
	
	if arg_29_0:isScrolling() and arg_29_0.vars.scrollview:getScrollPower() > 20 then
		return false
	end
	
	arg_29_0.touched = true
	arg_29_0.vars.scrollview_dragging = nil
	arg_29_0.vars.scrollview_touch_x = var_29_0.x
	arg_29_0.vars.scrollview_touch_y = var_29_0.y
	arg_29_0.vars.scrollview_touch_tick = systick()
	
	return true
end

function CustomLobbyChoose.isScrolling(arg_30_0)
	if not arg_30_0.vars then
		return 
	end
	
	return arg_30_0.vars.scroll_event_tick and uitick() - arg_30_0.vars.scroll_event_tick < 60
end

function CustomLobbyChoose.onTouchEnd(arg_31_0, arg_31_1, arg_31_2)
	local var_31_0 = arg_31_1:getLocation()
	
	if not arg_31_0.touched then
		return true
	end
	
	arg_31_0.touched = false
	
	if arg_31_0.vars.scrollview_touch_tick and systick() - arg_31_0.vars.scrollview_touch_tick > 200 then
		return false
	end
	
	arg_31_0.vars.scrollview_touch_tick = nil
	
	local var_31_1, var_31_2 = arg_31_0:getTouchedItem(var_31_0.x, var_31_0.y)
	
	if not var_31_1 then
		return false
	end
	
	arg_31_0:onSelectItem(var_31_1, var_31_2)
	
	return false
end

function CustomLobbyChoose.getTouchedItem(arg_32_0, arg_32_1, arg_32_2)
	if not checkCollision(arg_32_0.vars.scrollview, arg_32_1, arg_32_2) or arg_32_0.vars.scrollview_touch_x == nil then
		return false
	end
	
	if math.abs(arg_32_0.vars.scrollview_touch_x - arg_32_1) > DESIGN_HEIGHT * 0.02 or math.abs(arg_32_0.vars.scrollview_touch_y - arg_32_2) > DESIGN_HEIGHT * 0.02 then
		return false
	end
	
	local var_32_0
	local var_32_1
	local var_32_2 = -1
	
	for iter_32_0, iter_32_1 in pairs(arg_32_0.vars.layouts or {}) do
		if iter_32_1:isVisible() then
			local var_32_3 = iter_32_1:getLocalZOrder()
			
			if get_cocos_refid(iter_32_1) and checkCollision(iter_32_1, arg_32_1, arg_32_2) and var_32_2 < var_32_3 then
				var_32_2 = var_32_3
				
				local var_32_4 = iter_32_0
				
				var_32_1 = iter_32_1
			end
		end
	end
	
	if not var_32_1 then
		return false
	end
	
	return var_32_1.item, var_32_1
end

function CustomLobbyChoose.scrollToIndex(arg_33_0, arg_33_1, arg_33_2)
	if not arg_33_1 then
		return 
	end
	
	if arg_33_2 == nil then
		arg_33_2 = math.abs(arg_33_0.f_index - arg_33_1) / arg_33_0.vars.item_count * 1 + 0.2
	end
	
	local var_33_0 = 100 * ((arg_33_1 - 1) / (arg_33_0.vars.item_count - 1))
	
	if var_33_0 == 0 then
		var_33_0 = 0.1
	end
	
	arg_33_0:scrollToPercent(var_33_0, arg_33_2, true)
end

function CustomLobbyChoose.scrollToPercent(arg_34_0, arg_34_1, arg_34_2)
	arg_34_0.vars.scrollview:scrollToPercentHorizontal(arg_34_1, arg_34_2, true)
end

function CustomLobbyChoose.onSelectItem(arg_35_0, arg_35_1, arg_35_2)
	local var_35_0 = arg_35_1.idx
	
	if arg_35_0.vars.cur_item ~= arg_35_1 then
		arg_35_0.vars.selected_item = arg_35_1
		
		arg_35_0:scrollToIndex(var_35_0)
	elseif arg_35_0.vars.cur_item == arg_35_1 then
	end
end

function CustomLobbyChoose.registerTouchHandler(arg_36_0)
	local function var_36_0(arg_37_0, arg_37_1)
		if UIAction:Find("block") or NetWaiting:isWaiting() then
			return false
		end
		
		return arg_36_0.onTouchBegin(arg_36_0, arg_37_0, arg_37_1)
	end
	
	local function var_36_1(arg_38_0, arg_38_1)
		if UIAction:Find("block") or NetWaiting:isWaiting() then
			arg_36_0.touched = false
			
			return false
		end
		
		return arg_36_0.onTouchEnd(arg_36_0, arg_38_0, arg_38_1)
	end
	
	arg_36_0.vars.scrollview:setSwallowTouches(false)
	
	local var_36_2 = arg_36_0.vars.panel:getEventDispatcher()
	
	arg_36_0.vars.listener = cc.EventListenerTouchOneByOne:create()
	
	arg_36_0.vars.listener:registerScriptHandler(var_36_0, cc.Handler.EVENT_TOUCH_BEGAN)
	arg_36_0.vars.listener:registerScriptHandler(var_36_1, cc.Handler.EVENT_TOUCH_ENDED)
	var_36_2:addEventListenerWithSceneGraphPriority(arg_36_0.vars.listener, arg_36_0.vars.panel)
end

function CustomLobbyChoose.setupUI(arg_39_0)
	local var_39_0 = arg_39_0.vars.dlg
	local var_39_1 = var_39_0:findChildByName("new_card_listview")
	local var_39_2 = cc.Layer:create()
	local var_39_3 = cc.Layer:create()
	
	var_39_2:setPosition(380, -167)
	var_39_2:setLocalZOrder(-99)
	var_39_2:addChild(var_39_3)
	var_39_0:addChild(var_39_2)
	var_39_0:findChildByName("new_card_listview"):setLocalZOrder(-100)
	var_39_0:findChildByName("btn_block"):setLocalZOrder(-101)
	var_39_0:findChildByName("grow"):setLocalZOrder(-102)
	var_39_0:findChildByName("dim_img"):setLocalZOrder(-103)
	
	arg_39_0.vars.panel = var_39_3
	
	arg_39_0.vars.panel:setPositionY(450)
	
	local var_39_4 = var_39_1:getContentSize()
	local var_39_5 = var_39_4.width
	local var_39_6 = var_39_4.height
	local var_39_7 = arg_39_0:createListViewItemDefaultLobby()
	local var_39_8 = arg_39_0:createListViewItemUnitLobby()
	local var_39_9 = arg_39_0:createListViewItemIllustLobby()
	local var_39_10 = {
		var_39_9,
		var_39_8,
		var_39_7
	}
	
	arg_39_0.vars.layouts = var_39_10
	arg_39_0.vars.layout_items = {
		{
			id = "illust",
			idx = 3
		},
		{
			id = "hero",
			idx = 2
		},
		{
			id = "default",
			idx = 1
		}
	}
	arg_39_0.vars.item_size = 560
	arg_39_0.vars.item_count = table.count(var_39_10)
	
	var_39_1:setInnerContainerSize({
		width = arg_39_0.vars.item_size * arg_39_0.vars.item_count * 2,
		height = var_39_6
	})
	
	for iter_39_0, iter_39_1 in pairs(var_39_10) do
		var_39_3:addChild(iter_39_1)
		
		if iter_39_1.layout then
			iter_39_1.layout:disableTouch()
		elseif iter_39_1.layouts then
			for iter_39_2 = 1, #iter_39_1.layouts do
				iter_39_1.layouts[iter_39_2]:disableTouch()
			end
		else
			Log.e("layout is nil. could not disable touch.")
		end
	end
	
	arg_39_0.vars.scrollview = var_39_1
	
	local function var_39_11(arg_40_0, arg_40_1)
		arg_39_0:onScrollViewEvent(arg_40_0, arg_40_1)
	end
	
	var_39_1:setInnerContainerPosition({
		x = 0,
		y = 0
	})
	arg_39_0.vars.scrollview:addEventListener(var_39_11)
	arg_39_0.vars.scrollview:setScrollBarAutoHideEnabled(false)
	arg_39_0.vars.scrollview:setScrollBarEnabled(false)
	
	arg_39_0.vars.panel_size = var_39_5
	
	arg_39_0:registerTouchHandler()
	var_39_2:setPositionX(380 + VIEW_BASE_LEFT)
	NotchManager:addListener(var_39_1, nil, function(arg_41_0, arg_41_1, arg_41_2)
		local var_41_0 = 0
		
		for iter_41_0, iter_41_1 in pairs(arg_39_0.vars.items) do
			arg_39_0:reCalcRendererSize(iter_41_1)
			
			arg_39_0.vars.item_size = iter_41_1:getContentSize().width
			var_41_0 = var_41_0 + iter_41_1:getContentSize().width - arg_39_0.vars.item_gap
		end
		
		local var_41_1 = var_39_1:getInnerContainerSize()
		
		arg_39_0.vars.width = VIEW_WIDTH
		
		local var_41_2 = arg_39_0.vars.item_size * (arg_39_0.vars.item_count - 1) / arg_39_0.vars.scroll_ratio + arg_39_0.vars.width
		
		var_39_1:setInnerContainerSize({
			width = var_41_2,
			height = var_41_1.height
		})
		arg_39_0.vars.scrollview:setScrollStep(arg_39_0.vars.item_size / arg_39_0.vars.scroll_ratio)
		arg_39_0:arrangeItems()
	end)
	arg_39_0:arrangeItems()
end

function CustomLobbyChoose.choose(arg_42_0, arg_42_1)
	local var_42_0 = SAVE:getKeep("custom_lobby.mode") or "default"
	
	for iter_42_0, iter_42_1 in pairs(arg_42_0.vars.items) do
		if_set_visible(iter_42_1, "selected", iter_42_0 == arg_42_1)
	end
	
	local var_42_1 = cc.c3b(255, 255, 255)
	
	if arg_42_1 == "default" then
		var_42_1 = cc.c3b(76, 76, 76)
	end
	
	if arg_42_1 == var_42_0 then
		if_set_color(arg_42_0.vars.dlg, "btn_set", cc.c3b(76, 76, 76))
	else
		if_set_color(arg_42_0.vars.dlg, "btn_set", cc.c3b(255, 255, 255))
	end
	
	if_set_color(arg_42_0.vars.dlg, "btn_detail", var_42_1)
	
	local var_42_2 = arg_42_1
	
	if arg_42_1 == "default" then
		var_42_2 = "pub"
	end
	
	local var_42_3, var_42_4, var_42_5 = DB("lobby_type", var_42_2, {
		"icon",
		"title",
		"desc"
	})
	local var_42_6 = "img/" .. var_42_3 .. ".png"
	
	if_set_sprite(arg_42_0.vars.dlg, "icon_title", var_42_6)
	if_set(arg_42_0.vars.dlg, "t_title", T(var_42_4))
	if_set(arg_42_0.vars.dlg, "t_desc", T(var_42_5))
	
	arg_42_0.vars.selected_type = arg_42_1
end

function CustomLobbyChoose.setAsLobby(arg_43_0)
	local var_43_0 = SAVE:getKeep("custom_lobby.mode") or "default"
	
	if arg_43_0.vars.selected_type == var_43_0 then
		balloon_message_with_sound("msg_lobby_choose_already_set_lobby")
		
		return 
	end
	
	if arg_43_0.vars.selected_type == "hero" then
		CustomLobby:setAsHeroLobby()
		SAVE:setKeep("custom_lobby.unit.enter_sound", true)
		CustomLobby:sendSaveQuery()
	elseif arg_43_0.vars.selected_type == "illust" then
		CustomLobby:setAsIllustLobby()
		CustomLobby:sendSaveQuery()
	elseif arg_43_0.vars.selected_type == "default" then
		CustomLobby:setAsDefaultLobby()
		CustomLobby:sendSaveQuery()
	end
end

function CustomLobbyChoose.detail(arg_44_0)
	if arg_44_0.vars.selected_type == "default" then
		balloon_message_with_sound("msg_lobby_choose_cannot_detail")
		
		return 
	end
	
	if arg_44_0.vars.selected_type == "hero" then
		CustomLobbySettingMain:init(SceneManager:getRunningPopupScene())
	elseif arg_44_0.vars.selected_type == "illust" then
		CustomLobbySettingMain.Illust:init(SceneManager:getRunningPopupScene())
	end
end

function CustomLobbyChoose.close(arg_45_0)
	if not arg_45_0.vars then
		return 
	end
	
	if get_cocos_refid(arg_45_0.vars.dlg) then
		arg_45_0.vars.dlg:removeFromParent()
		
		arg_45_0.vars.dlg = nil
		
		BackButtonManager:pop()
		TutorialGuide:checkAsepaTutorial()
	end
	
	CustomLobbyIllust.Util:safeReleaseScheudler("choose")
	
	arg_45_0.vars = nil
end
