CustomLobbySettingSticker = {}

function HANDLER.lobby_custom_sticker_x(arg_1_0, arg_1_1)
	if arg_1_1 == "btn" then
		CustomLobbySettingSticker:onRemoveSticker(arg_1_0.uid)
	end
end

function CustomLobbySettingSticker.init(arg_2_0, arg_2_1)
	arg_2_0.Data:init()
	arg_2_0.UI:init(arg_2_1)
end

function CustomLobbySettingSticker.show(arg_3_0, arg_3_1, arg_3_2)
	arg_3_0.ListView:init(arg_3_1)
	arg_3_0:updateListView(arg_3_2)
end

function CustomLobbySettingSticker.close(arg_4_0)
	arg_4_0.Data:close()
end

function CustomLobbySettingSticker.clearStickers(arg_5_0)
	arg_5_0.Data:clearStickers()
	CustomLobbySettingPreview:clearStickers()
end

function CustomLobbySettingSticker.updateListView(arg_6_0, arg_6_1)
	arg_6_0.Data:setViewDataList(arg_6_1)
	arg_6_0.ListView:setData(arg_6_1)
	CustomLobbySettingMain.UI:setVisibleNoData(table.count(arg_6_1) == 0)
end

function CustomLobbySettingSticker.onSelectSticker(arg_7_0, arg_7_1)
	if arg_7_0.Data:getStickerLength() >= 5 then
		balloon_message_with_sound("ui_sticker_full")
		
		return 
	end
	
	local var_7_0 = arg_7_0.Data:pushStickerId(arg_7_1)
	
	CustomLobbySettingPreview:onAddSticker(var_7_0)
end

function CustomLobbySettingSticker.loadSticker(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0.Data:addSticker(arg_8_1)
	
	CustomLobbySettingPreview:onAddSticker(var_8_0)
end

function CustomLobbySettingSticker.onRemoveSticker(arg_9_0, arg_9_1)
	arg_9_0.Data:removeStickerById(arg_9_1)
	CustomLobbySettingPreview:onRemoveSticker(arg_9_1)
end

function CustomLobbySettingSticker.onSelectTab(arg_10_0, arg_10_1)
	arg_10_0.Data:setTabByIdx(arg_10_1)
	arg_10_0.UI:selectTab(arg_10_1)
	
	local var_10_0 = arg_10_0.Data:getCurrentDataList()
	
	arg_10_0:updateListView(var_10_0)
end

CustomLobbySettingSticker.Data = {}

function CustomLobbySettingSticker.Data.init(arg_11_0)
	arg_11_0.vars = {}
	arg_11_0.vars.current_tab = arg_11_0:getTabData()[1]
	arg_11_0.vars.sticker_list = {}
	arg_11_0.vars.uid_cnt = 0
end

function CustomLobbySettingSticker.Data.getTabData(arg_12_0)
	return {
		"emotion",
		"environment"
	}
end

function CustomLobbySettingSticker.Data.getStickerLength(arg_13_0)
	return #arg_13_0.vars.sticker_list
end

function CustomLobbySettingSticker.Data.pushStickerId(arg_14_0, arg_14_1)
	local var_14_0 = tostring(arg_14_0.vars.uid_cnt)
	
	arg_14_0.vars.uid_cnt = arg_14_0.vars.uid_cnt + 1
	
	local var_14_1 = {
		uid = var_14_0,
		id = arg_14_1
	}
	
	table.insert(arg_14_0.vars.sticker_list, var_14_1)
	
	return var_14_1
end

function CustomLobbySettingSticker.Data.clearStickers(arg_15_0)
	arg_15_0.vars.uid_cnt = 0
	arg_15_0.vars.sticker_list = {}
end

function CustomLobbySettingSticker.Data.addSticker(arg_16_0, arg_16_1)
	local var_16_0 = tostring(arg_16_0.vars.uid_cnt)
	
	arg_16_0.vars.uid_cnt = arg_16_0.vars.uid_cnt + 1
	arg_16_1.uid = var_16_0
	
	table.insert(arg_16_0.vars.sticker_list, arg_16_1)
	
	return arg_16_1
end

function CustomLobbySettingSticker.Data.removeStickerById(arg_17_0, arg_17_1)
	local var_17_0
	
	for iter_17_0, iter_17_1 in pairs(arg_17_0.vars.sticker_list) do
		if iter_17_1.uid == arg_17_1 then
			var_17_0 = iter_17_0
		end
	end
	
	table.remove(arg_17_0.vars.sticker_list, var_17_0)
end

function CustomLobbySettingSticker.Data.setTabByIdx(arg_18_0, arg_18_1)
	arg_18_0.vars.current_tab = arg_18_0:getTabData()[arg_18_1]
end

function CustomLobbySettingSticker.Data.getCurrentTab(arg_19_0)
	return arg_19_0.vars.current_tab
end

function CustomLobbySettingSticker.Data.getCurrentTabIdx(arg_20_0)
	local var_20_0 = arg_20_0.vars.current_tab
	
	for iter_20_0, iter_20_1 in pairs(arg_20_0:getTabData()) do
		if iter_20_1 == var_20_0 then
			return iter_20_0
		end
	end
	
	return nil
end

function CustomLobbySettingSticker.Data.getCurrentDataList(arg_21_0)
	local var_21_0 = Account.items
	local var_21_1 = {}
	
	for iter_21_0, iter_21_1 in pairs(var_21_0) do
		local var_21_2, var_21_3, var_21_4, var_21_5 = DB("item_material", iter_21_0, {
			"sort",
			"ma_type",
			"ma_type2",
			"sticker_img"
		})
		
		if var_21_3 == "sticker" then
			table.insert(var_21_1, {
				id = iter_21_0,
				ma_type = var_21_3,
				ma_type2 = var_21_4,
				sticker_img = var_21_5,
				sort = var_21_2
			})
		end
	end
	
	local var_21_6 = {
		"ma_sticker_emo1",
		"ma_sticker_emo2",
		"ma_sticker_emo3",
		"ma_sticker_emo4",
		"ma_sticker_emo5",
		"ma_sticker_emo6",
		"ma_sticker_emo7",
		"ma_sticker_emo8",
		"ma_sticker_env1",
		"ma_sticker_env2",
		"ma_sticker_env3",
		"ma_sticker_env4",
		"ma_sticker_env5",
		"ma_sticker_env6",
		"ma_sticker_env7",
		"ma_sticker_env8"
	}
	
	for iter_21_2, iter_21_3 in pairs(var_21_6) do
		local var_21_7, var_21_8, var_21_9, var_21_10 = DB("item_material", iter_21_3, {
			"sort",
			"ma_type",
			"ma_type2",
			"sticker_img"
		})
		
		if var_21_8 == "sticker" then
			table.insert(var_21_1, {
				id = iter_21_3,
				ma_type = var_21_8,
				ma_type2 = var_21_9,
				sticker_img = var_21_10,
				sort = var_21_7
			})
		else
			Log.e("기본 제공되는 스티커인데 타입이 스티커가 아닙니다. 마아압소사. ID : ", iter_21_3)
		end
	end
	
	local var_21_11 = {}
	
	for iter_21_4, iter_21_5 in pairs(var_21_1) do
		if iter_21_5.ma_type2 == arg_21_0.vars.current_tab then
			table.insert(var_21_11, iter_21_5)
		end
	end
	
	table.sort(var_21_11, function(arg_22_0, arg_22_1)
		return arg_22_0.sort < arg_22_1.sort
	end)
	
	return var_21_11
end

function CustomLobbySettingSticker.Data.setViewDataList(arg_23_0, arg_23_1)
	arg_23_0.vars.view_data_list = arg_23_1
end

function CustomLobbySettingSticker.Data.close(arg_24_0)
	arg_24_0.vars = nil
end

CustomLobbySettingSticker.UI = {}

function CustomLobbySettingSticker.UI.init(arg_25_0, arg_25_1)
	arg_25_0.vars = {}
	arg_25_0.vars.parent_ui = arg_25_1
	arg_25_0.vars.n_sticker = arg_25_0.vars.parent_ui:getChildByName("n_sticker")
	arg_25_0.vars.tabs = {}
	
	for iter_25_0 = 1, 4 do
		local var_25_0 = arg_25_0.vars.n_sticker:getChildByName("tab_" .. iter_25_0)
		
		if get_cocos_refid(var_25_0) then
			arg_25_0.vars.tabs[iter_25_0] = var_25_0
		end
	end
	
	local var_25_1 = CustomLobbySettingSticker.Data:getCurrentTabIdx()
	
	arg_25_0:selectTab(var_25_1)
end

function CustomLobbySettingSticker.UI.selectTab(arg_26_0, arg_26_1)
	for iter_26_0, iter_26_1 in pairs(arg_26_0.vars.tabs) do
		if_set_visible(iter_26_1, "bg_sel", iter_26_0 == arg_26_1)
	end
end

CustomLobbySettingSticker.ListView = {}

function CustomLobbySettingSticker.ListView.init(arg_27_0, arg_27_1)
	arg_27_0.vars = {}
	arg_27_0.vars.listview = ItemListView_v2:bindControl(arg_27_1)
	
	local var_27_0 = {
		onUpdate = function(arg_28_0, arg_28_1, arg_28_2, arg_28_3)
			arg_27_0:updateListViewItem(arg_28_1, arg_28_3)
		end
	}
	local var_27_1 = load_control("wnd/lobby_custom_sticker.csb")
	
	var_27_1:setContentSize({
		width = 102,
		height = 102
	})
	
	if arg_27_0.vars.listview.STRETCH_INFO then
		local var_27_2 = arg_27_0.vars.listview:getContentSize()
		
		resetControlPosAndSize(var_27_1, var_27_2.width, arg_27_0.vars.listview.STRETCH_INFO.width_prev)
	end
	
	arg_27_0.vars.listview:setRenderer(var_27_1, var_27_0)
	arg_27_0.vars.listview:setDataSource({})
	print("CustomLobbySettingSticker.ListView.init?")
end

function CustomLobbySettingSticker.ListView.updateListViewItem(arg_29_0, arg_29_1, arg_29_2)
	local var_29_0 = CustomLobbyUnit.Sticker:stickerImgPathToRealPath(arg_29_2.sticker_img)
	
	if_set_sprite(arg_29_1, "sticker", var_29_0)
	arg_29_1:getChildByName("sticker"):setContentSize({
		width = 84,
		height = 84
	})
	arg_29_1:getChildByName("sticker"):setPosition(25.5, 0)
	arg_29_1:getChildByName("btn"):setContentSize({
		width = 84,
		height = 84
	})
	arg_29_1:getChildByName("btn"):setPosition(25.5, 0)
	
	arg_29_1:getChildByName("btn").id = arg_29_2.id
end

function CustomLobbySettingSticker.ListView.setData(arg_30_0, arg_30_1)
	arg_30_0.vars.listview:setDataSource(arg_30_1)
end

function CustomLobbySettingSticker.ListView.updateSelected(arg_31_0, arg_31_1, arg_31_2)
	if not arg_31_0.vars or not get_cocos_refid(arg_31_0.vars.listview) then
		return 
	end
	
	arg_31_0.vars.listview:enumControls(function(arg_32_0)
		if arg_32_0.data.id == arg_31_1 or arg_32_0.data.id == arg_31_2 then
			arg_31_0:updateListViewItem(arg_32_0, arg_32_0.data)
		end
	end)
end
