CustomLobbySettingBGPack = {}

function CustomLobbySettingBGPack.init(arg_1_0, arg_1_1)
	arg_1_0.Data:init()
	arg_1_0.UI:init(arg_1_1)
end

function CustomLobbySettingBGPack.show(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0.ListView:init(arg_2_1)
	arg_2_0:updateListView(arg_2_2)
end

function CustomLobbySettingBGPack.close(arg_3_0)
	arg_3_0.Data:close()
end

function CustomLobbySettingBGPack.updateListView(arg_4_0, arg_4_1)
	arg_4_0.Data:setViewDataList(arg_4_1)
	arg_4_0.ListView:setData(arg_4_1)
end

function CustomLobbySettingBGPack.onSelectBGPack(arg_5_0, arg_5_1)
	local var_5_0 = arg_5_1.id
	local var_5_1 = arg_5_0.Data:getCurrentBGPack()
	
	arg_5_0.Data:setCurrentBGPack(var_5_0)
	arg_5_0.ListView:updateSelected(var_5_0, var_5_1)
	CustomLobbySettingPreview:onSelectBGPack(var_5_0)
end

CustomLobbySettingBGPack.Data = {}

function CustomLobbySettingBGPack.Data.init(arg_6_0)
	arg_6_0.vars = {}
	arg_6_0.vars.current_bgpack = ""
	
	arg_6_0:setDefaultCurrentBGPack()
end

function CustomLobbySettingBGPack.Data.setDefaultCurrentBGPack(arg_7_0)
	local var_7_0 = arg_7_0:getCurrentDataList()
	
	arg_7_0.vars.current_bgpack = var_7_0[1].id
end

function CustomLobbySettingBGPack.Data.getCurrentBGPack(arg_8_0)
	return arg_8_0.vars.current_bgpack
end

function CustomLobbySettingBGPack.Data.setCurrentBGPack(arg_9_0, arg_9_1)
	arg_9_0.vars.current_bgpack = arg_9_1
end

function CustomLobbySettingBGPack.Data.getCurrentDataList(arg_10_0)
	local var_10_0 = get_material_bgpack_data(true, "CustomLobby")
	
	table.sort(var_10_0, function(arg_11_0, arg_11_1)
		return arg_11_0.sort < arg_11_1.sort
	end)
	
	if table.count(var_10_0) == 0 then
		Log.e("NO. BGPACK WAS EMPTY")
	end
	
	return var_10_0
end

function CustomLobbySettingBGPack.Data.setViewDataList(arg_12_0, arg_12_1)
	arg_12_0.vars.view_data_list = arg_12_1
end

function CustomLobbySettingBGPack.Data.close(arg_13_0)
	arg_13_0.vars = nil
end

CustomLobbySettingBGPack.UI = {}

function CustomLobbySettingBGPack.UI.init(arg_14_0, arg_14_1)
	arg_14_0.vars = {}
end

CustomLobbySettingBGPack.ListView = {}

function CustomLobbySettingBGPack.ListView.init(arg_15_0, arg_15_1)
	arg_15_0.vars = {}
	arg_15_0.vars.listview = ItemListView_v2:bindControl(arg_15_1)
	
	local var_15_0 = {
		onUpdate = function(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
			arg_15_0:updateListViewItem(arg_16_1, arg_16_3)
		end
	}
	local var_15_1 = load_control("wnd/lobby_custom_bgpack_card.csb")
	
	if arg_15_0.vars.listview.STRETCH_INFO then
		local var_15_2 = arg_15_0.vars.listview:getContentSize()
		
		resetControlPosAndSize(var_15_1, var_15_2.width, arg_15_0.vars.listview.STRETCH_INFO.width_prev)
	end
	
	arg_15_0.vars.listview:setRenderer(var_15_1, var_15_0)
	arg_15_0.vars.listview:setDataSource({})
end

function CustomLobbySettingBGPack.ListView.updateListViewItem(arg_17_0, arg_17_1, arg_17_2)
	local var_17_0 = CustomLobbySettingBGPack.Data:getCurrentBGPack()
	
	if_set_visible(arg_17_1, "selected", arg_17_2.id == var_17_0)
	if_set_sprite(arg_17_1, "bgpack", arg_17_2.icon)
	
	arg_17_1:getChildByName("btn_select").data = arg_17_2
	arg_17_1:getChildByName("btn_select")._mode = "bgpack"
	arg_17_1.data = arg_17_2
end

function CustomLobbySettingBGPack.ListView.setData(arg_18_0, arg_18_1)
	arg_18_0.vars.listview:setDataSource(arg_18_1)
end

function CustomLobbySettingBGPack.ListView.updateSelected(arg_19_0, arg_19_1, arg_19_2)
	if not arg_19_0.vars or not get_cocos_refid(arg_19_0.vars.listview) then
		return 
	end
	
	arg_19_0.vars.listview:enumControls(function(arg_20_0)
		if arg_20_0.data.id == arg_19_1 or arg_20_0.data.id == arg_19_2 then
			arg_19_0:updateListViewItem(arg_20_0, arg_20_0.data)
		end
	end)
end
