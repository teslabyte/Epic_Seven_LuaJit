CustomLobbySettingEmotion = {}

function CustomLobbySettingEmotion.init(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0.Data:init()
	arg_1_0.UI:init(arg_1_1)
end

function CustomLobbySettingEmotion.isCanShow(arg_2_0)
	if not CustomLobbySettingPreview.Layout:isPortraitAni() then
		balloon_message_with_sound("no_detail_info")
		
		return false
	end
	
	return true
end

function CustomLobbySettingEmotion.setDefault(arg_3_0)
	local var_3_0 = arg_3_0.Data:getCurrentEmotion()
	
	arg_3_0.Data:setDefault()
	
	local var_3_1 = arg_3_0.Data:getCurrentEmotion()
	
	arg_3_0.ListView:updateSelected(var_3_1, var_3_0)
	CustomLobbySettingPreview:onSelectEmotion(var_3_1)
end

function CustomLobbySettingEmotion.show(arg_4_0, arg_4_1, arg_4_2)
	arg_4_0.ListView:init(arg_4_1)
	arg_4_0:updateListView(arg_4_2)
end

function CustomLobbySettingEmotion.close(arg_5_0)
	arg_5_0.Data:close()
end

function CustomLobbySettingEmotion.updateListView(arg_6_0, arg_6_1)
	arg_6_0.Data:setViewDataList(arg_6_1)
	arg_6_0.ListView:setData(arg_6_1)
end

function CustomLobbySettingEmotion.onSelectEmotion(arg_7_0, arg_7_1)
	if arg_7_1.locked then
		balloon_message_with_sound("need_more_fav_point")
		
		return 
	end
	
	local var_7_0 = arg_7_1.emotion
	local var_7_1 = arg_7_0.Data:getCurrentEmotion()
	
	arg_7_0.Data:setCurrentEmotion(var_7_0)
	
	local var_7_2 = arg_7_0.Data:getCurrentEmotion()
	
	arg_7_0.ListView:updateSelected(var_7_2, var_7_1)
	CustomLobbySettingPreview:onSelectEmotion(var_7_2)
end

CustomLobbySettingEmotion.Data = {}

function CustomLobbySettingEmotion.Data.init(arg_8_0)
	arg_8_0.vars = {}
	arg_8_0.vars.current_emotion = "normal"
end

function CustomLobbySettingEmotion.Data.setDefault(arg_9_0)
	arg_9_0.vars.current_emotion = "normal"
end

function CustomLobbySettingEmotion.Data.getCurrentEmotion(arg_10_0)
	return arg_10_0.vars.current_emotion
end

function CustomLobbySettingEmotion.Data.setCurrentEmotion(arg_11_0, arg_11_1)
	arg_11_0.vars.current_emotion = arg_11_1
end

function CustomLobbySettingEmotion.Data.getFavLevel(arg_12_0, arg_12_1)
	local var_12_0 = Account:getUnitsByCode(arg_12_1)
	local var_12_1 = 0
	
	for iter_12_0, iter_12_1 in pairs(var_12_0 or {}) do
		var_12_1 = math.max(var_12_1, iter_12_1:getFavLevel())
	end
	
	return var_12_1
end

function CustomLobbySettingEmotion.Data.getCurrentDataList(arg_13_0)
	local var_13_0 = CustomLobbySettingHero.Data:getCurrentUnit()
	local var_13_1 = CustomLobbySettingPreview.Data:getSelectedFaceID()
	local var_13_2 = var_13_1 or var_13_0
	
	if var_13_1 == DB("character", var_13_0, "face_id") then
		var_13_2 = var_13_0
	end
	
	local var_13_3 = {}
	
	for iter_13_0 = 1, 10 do
		local var_13_4 = SLOW_DB_ALL("character_intimacy_level", (DB("character", var_13_2, "emotion_id") or var_13_2) .. "_" .. iter_13_0)
		
		if not var_13_4 then
			break
		end
		
		if not var_13_4.id then
			break
		end
		
		table.push(var_13_3, var_13_4)
	end
	
	local var_13_5 = arg_13_0:getCurrentEmotion()
	local var_13_6 = {}
	local var_13_7 = 0
	local var_13_8 = arg_13_0:getFavLevel(var_13_0)
	
	for iter_13_1, iter_13_2 in pairs(var_13_3) do
		if iter_13_2.emotion then
			var_13_7 = var_13_7 + 1
			
			local var_13_9 = table.clone(iter_13_2)
			
			if var_13_8 < iter_13_2.intimacy_level then
				var_13_9.locked = true
			end
			
			table.insert(var_13_6, var_13_9)
		end
	end
	
	return var_13_6
end

function CustomLobbySettingEmotion.Data.setViewDataList(arg_14_0, arg_14_1)
	arg_14_0.vars.view_data_list = arg_14_1
end

function CustomLobbySettingEmotion.Data.close(arg_15_0)
	arg_15_0.vars = nil
end

CustomLobbySettingEmotion.UI = {}

function CustomLobbySettingEmotion.UI.init(arg_16_0, arg_16_1)
	arg_16_0.vars = {}
end

CustomLobbySettingEmotion.ListView = {}

function CustomLobbySettingEmotion.ListView.init(arg_17_0, arg_17_1)
	arg_17_0.vars = {}
	arg_17_0.vars.listview = ItemListView_v2:bindControl(arg_17_1)
	
	local var_17_0 = {
		onUpdate = function(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
			arg_17_0:updateListViewItem(arg_18_1, arg_18_3)
		end
	}
	local var_17_1 = load_control("wnd/lobby_custom_face_card.csb")
	
	if arg_17_0.vars.listview.STRETCH_INFO then
		local var_17_2 = arg_17_0.vars.listview:getContentSize()
		
		resetControlPosAndSize(var_17_1, var_17_2.width, arg_17_0.vars.listview.STRETCH_INFO.width_prev)
	end
	
	arg_17_0.vars.listview:setRenderer(var_17_1, var_17_0)
	arg_17_0.vars.listview:setDataSource({})
end

function CustomLobbySettingEmotion.ListView.updateListViewItem(arg_19_0, arg_19_1, arg_19_2)
	arg_19_1:getChildByName("card"):setPositionX(0)
	
	local var_19_0 = arg_19_2.emotion
	
	if string.starts(var_19_0, "special") then
		var_19_0 = "special"
	end
	
	local var_19_1 = "img/cm_icon_face_" .. var_19_0 .. ".png"
	
	if_set_sprite(arg_19_1, "sprite_face", var_19_1)
	if_set(arg_19_1, "t_face", T("emo_" .. arg_19_2.emotion))
	if_set_visible(arg_19_1, "icon_check", arg_19_2.default)
	
	local var_19_2 = cc.c3b(255, 255, 255)
	
	if arg_19_2.default then
		var_19_2 = cc.c3b(107, 193, 27)
	elseif arg_19_2.locked then
		var_19_2 = cc.c3b(45, 45, 45)
	end
	
	if_set_color(arg_19_1, "t_face", var_19_2)
	
	if arg_19_2.locked then
		if_set_color(arg_19_1, "sprite_face", cc.c3b(45, 45, 45))
	else
		if_set_color(arg_19_1, "sprite_face", cc.c3b(255, 255, 255))
	end
	
	local var_19_3 = CustomLobbySettingEmotion.Data:getCurrentEmotion()
	
	if_set_visible(arg_19_1, "lock", arg_19_2.locked)
	if_set_visible(arg_19_1, "icon_check", arg_19_2.emotion == var_19_3)
	if_set_visible(arg_19_1, "selected", arg_19_2.emotion == var_19_3)
	
	local var_19_4 = arg_19_1:findChildByName("btn_select")
	
	var_19_4.data = arg_19_2
	var_19_4._mode = "emotion"
	arg_19_1.data = arg_19_2
end

function CustomLobbySettingEmotion.ListView.setData(arg_20_0, arg_20_1)
	arg_20_0.vars.listview:setDataSource(arg_20_1)
end

function CustomLobbySettingEmotion.ListView.updateSelected(arg_21_0, arg_21_1, arg_21_2)
	if not arg_21_0.vars or not get_cocos_refid(arg_21_0.vars.listview) then
		return 
	end
	
	arg_21_0.vars.listview:enumControls(function(arg_22_0)
		if arg_22_0.data.emotion == arg_21_1 or arg_22_0.data.emotion == arg_21_2 then
			arg_21_0:updateListViewItem(arg_22_0, arg_22_0.data)
		end
	end)
end
