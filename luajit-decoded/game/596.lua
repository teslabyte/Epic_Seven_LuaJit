CustomLobbySettingSkin = {}

function CustomLobbySettingSkin.init(arg_1_0, arg_1_1)
	arg_1_0.Data:init()
	arg_1_0.UI:init(arg_1_1)
end

function CustomLobbySettingSkin.isCanShow(arg_2_0)
	if not arg_2_0.Data:isSkinExist() then
		balloon_message_with_sound("msg_lobby_hero_type_no_skin")
		
		return false
	end
	
	return true
end

function CustomLobbySettingSkin.show(arg_3_0, arg_3_1, arg_3_2)
	if not arg_3_0:isCanShow() then
		return false
	end
	
	arg_3_0.Data:ifNotExistSetDefaultCurrentSkin()
	arg_3_0.ListView:init(arg_3_1)
	arg_3_0:updateListView(arg_3_2)
end

function CustomLobbySettingSkin.setDefault(arg_4_0)
	local var_4_0 = arg_4_0.Data:getCurrentSkin()
	
	arg_4_0.Data:setDefaultCurrentSkin()
	
	local var_4_1 = arg_4_0.Data:getCurrentSkin()
	
	arg_4_0.ListView:updateSelected(var_4_1, var_4_0)
	CustomLobbySettingPreview:onSelectSkin(var_4_1)
end

function CustomLobbySettingSkin.close(arg_5_0)
	arg_5_0.Data:close()
end

function CustomLobbySettingSkin.updateListView(arg_6_0, arg_6_1)
	arg_6_0.Data:setViewDataList(arg_6_1)
	arg_6_0.ListView:setData(arg_6_1)
end

function CustomLobbySettingSkin.onSelectSkin(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_1.code
	local var_7_1 = arg_7_0.Data:getCurrentDataList()
	local var_7_2
	
	for iter_7_0, iter_7_1 in pairs(var_7_1) do
		if iter_7_1.code == var_7_0 then
			var_7_2 = iter_7_1.material
		end
	end
	
	if var_7_2 and Account:getItemCount(var_7_2) <= 0 then
		balloon_message_with_sound("msg_lobby_custom_not_own_skin")
		
		return 
	end
	
	local var_7_3 = arg_7_0.Data:getCurrentSkin()
	
	arg_7_0.Data:setCurrentSkin(var_7_0)
	arg_7_0.ListView:updateSelected(var_7_0, var_7_3)
	CustomLobbySettingPreview:onSelectSkin(var_7_0)
	CustomLobbySettingEmotion:setDefault()
end

CustomLobbySettingSkin.Data = {}

function CustomLobbySettingSkin.Data.init(arg_8_0)
	arg_8_0.vars = {}
	arg_8_0.vars.current_skin = ""
end

function CustomLobbySettingSkin.Data.isSkinExist(arg_9_0)
	local var_9_0 = arg_9_0:getCurrentDataList()
	
	return table.count(var_9_0) > 1
end

function CustomLobbySettingSkin.Data.ifNotExistSetDefaultCurrentSkin(arg_10_0)
	local var_10_0 = arg_10_0:getCurrentDataList()
	local var_10_1 = false
	
	for iter_10_0, iter_10_1 in pairs(var_10_0) do
		if iter_10_1.code == arg_10_0.vars.current_skin then
			var_10_1 = true
			
			break
		end
	end
	
	if not var_10_1 then
		arg_10_0:setDefaultCurrentSkin()
	end
end

function CustomLobbySettingSkin.Data.getMostFavUnitSkinCode(arg_11_0)
	local var_11_0 = CustomLobbySettingMain.Data:getSelectedUnitCode()
	local var_11_1 = Account:getUnitsByCode(var_11_0)
	local var_11_2 = -10
	local var_11_3 = 99999999999
	local var_11_4
	
	for iter_11_0, iter_11_1 in pairs(var_11_1 or {}) do
		local var_11_5 = iter_11_1:getFavLevel()
		local var_11_6 = iter_11_1:getUID()
		
		if var_11_2 == var_11_5 then
			if var_11_6 < var_11_3 then
				var_11_2 = var_11_5
				var_11_3 = iter_11_1:getUID()
				var_11_4 = iter_11_1
			end
		elseif var_11_2 < var_11_5 then
			var_11_2 = var_11_5
			var_11_3 = var_11_6
			var_11_4 = iter_11_1
		end
	end
	
	if var_11_4 then
		if not var_11_4:getSkinCode() then
			local var_11_7 = UIUtil:getSkinList(var_11_4.inst.code)
			local var_11_8 = var_11_7[#var_11_7].code
		end
		
		return var_11_4:getSkinCode()
	end
end

function CustomLobbySettingSkin.Data.setDefaultCurrentSkin(arg_12_0)
	local var_12_0 = CustomLobbySettingMain.Data:getSelectedUnitCode()
	
	if not arg_12_0:isSkinExist() then
		arg_12_0.vars.current_skin = DB("character", var_12_0, "face_id")
		
		return 
	end
	
	local var_12_1 = arg_12_0:getMostFavUnitSkinCode()
	
	if var_12_1 then
		arg_12_0.vars.current_skin = var_12_1
	else
		arg_12_0.vars.current_skin = var_12_0
	end
end

function CustomLobbySettingSkin.Data.getCurrentSkin(arg_13_0)
	return arg_13_0.vars.current_skin
end

function CustomLobbySettingSkin.Data.setCurrentSkin(arg_14_0, arg_14_1)
	print("setCurrentSkin", arg_14_1)
	
	arg_14_0.vars.current_skin = arg_14_1
end

function CustomLobbySettingSkin.Data.getCurrentDataList(arg_15_0)
	local var_15_0 = CustomLobbySettingHero.Data:getCurrentUnit()
	local var_15_1 = UIUtil:getSkinList(var_15_0)
	
	for iter_15_0, iter_15_1 in pairs(var_15_1) do
		if is_mer_series(iter_15_1.code) then
			iter_15_1.code = DB("character", iter_15_1.code, "face_id")
		end
	end
	
	return var_15_1
end

function CustomLobbySettingSkin.Data.setViewDataList(arg_16_0, arg_16_1)
	arg_16_0.vars.view_data_list = arg_16_1
end

function CustomLobbySettingSkin.Data.close(arg_17_0)
	arg_17_0.vars = nil
end

CustomLobbySettingSkin.UI = {}

function CustomLobbySettingSkin.UI.init(arg_18_0, arg_18_1)
	arg_18_0.vars = {}
end

CustomLobbySettingSkin.ListView = {}

function CustomLobbySettingSkin.ListView.init(arg_19_0, arg_19_1)
	arg_19_0.vars = {}
	arg_19_0.vars.listview = ItemListView_v2:bindControl(arg_19_1)
	
	local var_19_0 = {
		onUpdate = function(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
			arg_19_0:updateListViewItem(arg_20_1, arg_20_3)
		end
	}
	local var_19_1 = load_control("wnd/lobby_custom_skin_card.csb")
	
	if arg_19_0.vars.listview.STRETCH_INFO then
		local var_19_2 = arg_19_0.vars.listview:getContentSize()
		
		resetControlPosAndSize(var_19_1, var_19_2.width, arg_19_0.vars.listview.STRETCH_INFO.width_prev)
	end
	
	arg_19_0.vars.listview:setRenderer(var_19_1, var_19_0)
	arg_19_0.vars.listview:setDataSource({})
end

function CustomLobbySettingSkin.ListView.updateListViewItem(arg_21_0, arg_21_1, arg_21_2)
	local var_21_0 = CustomLobbySettingSkin.Data:getCurrentSkin()
	
	if_set_visible(arg_21_1, "selected", var_21_0 == arg_21_2.code)
	
	local var_21_1 = DB("character", arg_21_2.code, "face_id")
	
	replaceSprite(arg_21_1, "face", "face/" .. var_21_1 .. "_s.png")
	if_set_visible(arg_21_1, "tag_bg", not arg_21_2.material)
	
	local var_21_2 = DB("item_material", arg_21_2.material, "grade") or 1
	local var_21_3 = UIUtil:getSkinGradeBorder(var_21_2)
	local var_21_4 = UIUtil:getSkinGradeBG(var_21_2)
	
	replaceSprite(arg_21_1, "frame", "item/border/" .. var_21_3 .. ".png")
	replaceSprite(arg_21_1, "frame_bg", "img/" .. var_21_4 .. ".png")
	
	if arg_21_2.material then
		arg_21_1:setColor(Account:getItemCount(arg_21_2.material) > 0 and cc.c3b(255, 255, 255) or cc.c3b(75, 75, 75))
	end
	
	local var_21_5, var_21_6, var_21_7, var_21_8, var_21_9, var_21_10 = DB("item_material", arg_21_2.material, {
		"id",
		"name",
		"ma_type",
		"grade",
		"desc_category",
		"desc"
	})
	
	if var_21_5 then
		if_set(arg_21_1, "txt_subtitle", T(var_21_9))
		if_set(arg_21_1, "txt_title", T(var_21_6))
	else
		if_set(arg_21_1, "txt_subtitle", T("item_category_skin_normal"))
		if_set(arg_21_1, "txt_title", T("item_skin_normal_name"))
	end
	
	if_set_color(arg_21_1, "txt_subtitle", UIUtil:getGradeColor(nil, var_21_8 or 1))
	
	arg_21_1:getChildByName("btn_select").data = arg_21_2
	arg_21_1:getChildByName("btn_select")._mode = "skin"
	arg_21_1.data = arg_21_2
end

function CustomLobbySettingSkin.ListView.setData(arg_22_0, arg_22_1)
	arg_22_0.vars.listview:setDataSource(arg_22_1)
end

function CustomLobbySettingSkin.ListView.updateSelected(arg_23_0, arg_23_1, arg_23_2)
	if not arg_23_0.vars or not get_cocos_refid(arg_23_0.vars.listview) then
		return 
	end
	
	arg_23_0.vars.listview:enumControls(function(arg_24_0)
		if arg_24_0.data.code == arg_23_1 or arg_24_0.data.code == arg_23_2 then
			arg_23_0:updateListViewItem(arg_24_0, arg_24_0.data)
		end
	end)
end
