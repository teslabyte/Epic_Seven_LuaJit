UnitInfosEmotion = {}

function MsgHandler.old_set_unit_face_value(arg_1_0)
	if UnitMain:getMode() == "Detail" then
		UnitEmotion:closeWindow(arg_1_0)
		
		return 
	end
	
	UnitInfosEmotion:onMsgUnitFace(arg_1_0)
end

function HANDLER.hero_detail_expression(arg_2_0, arg_2_1)
	if arg_2_1 == "btn_face" then
		UnitInfosEmotion:setPortraitEmotion(arg_2_0.data, true)
		
		return 
	end
	
	if arg_2_1 == "btn_voice" then
		UnitInfosVoicePopup:create(UnitInfosEmotion:getLayer(), UnitInfosEmotion:getDB(), UnitInfosEmotion:getUnit())
		
		return 
	end
	
	if arg_2_1 == "btn_set" then
		UnitInfosEmotion:setDefaultEmotion()
		
		return 
	end
end

function UnitInfosEmotion.setPortraitEmotion(arg_3_0, arg_3_1, arg_3_2)
	if arg_3_1.notyet_dev then
		balloon_message_with_sound("notyet_dev")
		
		return 
	end
	
	if arg_3_1.locked then
		balloon_message_with_sound("need_more_fav_point")
		
		return 
	end
	
	arg_3_0.vars.intimacy_level = arg_3_1.intimacy_level
	
	UnitMain:setPortraitEmotion(arg_3_0.vars.unit, UnitMain:getPortrait(), arg_3_1.emotion)
	
	if arg_3_2 and not arg_3_1.selected then
		arg_3_1.selected = true
		arg_3_0.vars.prv_data.selected = false
		
		arg_3_0.vars.listView:refresh()
		
		arg_3_0.vars.prv_data = arg_3_1
	end
end

function UnitInfosEmotion.setDefaultEmotion(arg_4_0)
	local var_4_0 = arg_4_0.vars.prv_data
	
	arg_4_0.vars.intimacy_level = var_4_0.intimacy_level
	arg_4_0.vars.commit_data = arg_4_0.vars.prv_data
	
	local var_4_1 = arg_4_0.vars.intimacy_level - 1
	
	if arg_4_0.vars.original_intimacy_level ~= arg_4_0.vars.intimacy_level and var_4_1 < 10 and var_4_1 >= 0 then
		query("set_unit_face_value", {
			target = arg_4_0.vars.unit:getUID(),
			value = var_4_1
		})
		
		arg_4_0.vars.original_intimacy_level = arg_4_0.vars.intimacy_level
	end
	
	if false then
	end
end

function UnitInfosEmotion.onMsgUnitFace(arg_5_0, arg_5_1)
	if arg_5_1 and arg_5_1.unit_opt then
		arg_5_0.vars.unit:updateUnitOptionValue(arg_5_1.unit_opt)
		
		arg_5_0.vars.default_data.default = false
		arg_5_0.vars.commit_data.default = true
		arg_5_0.vars.default_data = arg_5_0.vars.commit_data
		arg_5_0.vars.commit_data = nil
		
		arg_5_0.vars.listView:refresh()
	end
end

function UnitInfosEmotion.getLayer(arg_6_0)
	return arg_6_0.vars.dlg
end

function UnitInfosEmotion.getDB(arg_7_0)
	return arg_7_0.vars.db
end

function UnitInfosEmotion.getUnit(arg_8_0)
	return arg_8_0.vars.unit
end

function UnitInfosEmotion.setData(arg_9_0)
	arg_9_0.vars.db = {}
	
	local var_9_0 = arg_9_0.vars.unit.db.code
	
	if arg_9_0.vars.unit.inst.skin_code ~= nil and arg_9_0.vars.unit.inst.skin_code ~= "" then
		var_9_0 = arg_9_0.vars.unit.inst.skin_code
	end
	
	for iter_9_0 = 1, 10 do
		local var_9_1 = SLOW_DB_ALL("character_intimacy_level", (DB("character", var_9_0, "emotion_id") or var_9_0) .. "_" .. iter_9_0)
		
		if not var_9_1 then
			break
		end
		
		if not var_9_1.id then
			break
		end
		
		table.push(arg_9_0.vars.db, var_9_1)
	end
	
	arg_9_0.vars.original_intimacy_level = 1
	arg_9_0.vars.intimacy_level = 1
	
	if #arg_9_0.vars.db == 0 then
		return false
	end
	
	local var_9_2 = arg_9_0.vars.unit:getFavLevel()
	
	arg_9_0.vars.emotion_data = {}
	
	local var_9_3 = arg_9_0.vars.unit:getFaceID() or "normal"
	local var_9_4 = 0
	
	for iter_9_1, iter_9_2 in pairs(arg_9_0.vars.db) do
		if iter_9_2.emotion then
			var_9_4 = var_9_4 + 1
			
			local var_9_5 = table.clone(iter_9_2)
			
			if var_9_2 < iter_9_2.intimacy_level then
				var_9_5.locked = true
			end
			
			if iter_9_2.emotion == var_9_3 then
				arg_9_0.vars.original_intimacy_level = iter_9_2.intimacy_level
				arg_9_0.vars.intimacy_level = iter_9_2.intimacy_level
				var_9_5.selected = true
				var_9_5.default = true
				arg_9_0.vars.prv_data = var_9_5
				arg_9_0.vars.default_data = var_9_5
				
				arg_9_0:setPortraitEmotion(var_9_5)
			end
			
			table.insert(arg_9_0.vars.emotion_data, var_9_5)
		end
	end
end

function UnitInfosEmotion.updateItem(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = arg_10_2.emotion
	
	if string.starts(var_10_0, "special") then
		var_10_0 = "special"
	end
	
	local var_10_1 = "img/cm_icon_face_" .. var_10_0 .. ".png"
	
	if_set_sprite(arg_10_1, "icon", var_10_1)
	if_set(arg_10_1, "txt_name", T("emo_" .. arg_10_2.emotion))
	if_set_visible(arg_10_1, "icon_check", arg_10_2.default)
	
	local var_10_2 = cc.c3b(255, 255, 255)
	
	if arg_10_2.default then
		var_10_2 = cc.c3b(107, 193, 27)
	elseif arg_10_2.locked then
		var_10_2 = cc.c3b(45, 45, 45)
	end
	
	if_set_color(arg_10_1, "txt_name", var_10_2)
	
	if arg_10_2.locked then
		if_set_color(arg_10_1, "icon", cc.c3b(45, 45, 45))
	else
		if_set_color(arg_10_1, "icon", cc.c3b(255, 255, 255))
	end
	
	if_set_visible(arg_10_1, "icon_locked", arg_10_2.locked)
	if_set_visible(arg_10_1, "select", arg_10_2.selected)
	
	arg_10_1:findChildByName("btn_face").data = arg_10_2
end

function UnitInfosEmotion.setListView(arg_11_0)
	arg_11_0.vars.listView = ItemListView_v2:bindControl(arg_11_0.vars.dlg:findChildByName("ListView"))
	
	arg_11_0:setData()
	
	local var_11_0 = load_control("wnd/hero_detail_expression_face.csb")
	local var_11_1 = {
		onUpdate = function(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
			UnitInfosEmotion:updateItem(arg_12_1, arg_12_3)
			
			return arg_12_3.id
		end
	}
	
	arg_11_0.vars.listView:setRenderer(var_11_0, var_11_1)
	arg_11_0.vars.listView:setDataSource(arg_11_0.vars.emotion_data)
end

function UnitInfosEmotion.onCreate(arg_13_0, arg_13_1)
	arg_13_0.vars = {}
	arg_13_0.vars.unit = UnitInfosController:getUnit()
	arg_13_0.vars.dlg = load_dlg("hero_detail_expression", true, "wnd")
	
	local var_13_0 = arg_13_0.vars.dlg:findChildByName("LEFT")
	local var_13_1 = arg_13_0.vars.dlg:findChildByName("RIGHT")
	
	UnitInfosUtil:setUnitDetail(arg_13_0.vars.dlg, var_13_0)
	UIUtil:setFavoriteDetail(var_13_0, arg_13_0.vars.unit)
	arg_13_0:setListView()
	var_13_0:setVisible(false)
	var_13_1:setVisible(false)
	UIAction:Add(SEQ(SLIDE_IN(300, 600)), var_13_0, "block")
	UIAction:Add(SEQ(SLIDE_IN(300, -600)), var_13_1, "block")
	UnitMain:movePortrait("Emotion")
	arg_13_1:addChild(arg_13_0.vars.dlg)
	UnitInfosVoicePopup:close(true)
end

function UnitInfosEmotion.onLeave(arg_14_0)
	if not arg_14_0.vars then
		return 
	end
	
	arg_14_0:setPortraitEmotion(arg_14_0.vars.default_data)
	UnitInfosVoicePopup:close(true)
	
	if not get_cocos_refid(arg_14_0.vars.dlg) then
		return 
	end
	
	local var_14_0 = arg_14_0.vars.dlg:findChildByName("LEFT")
	local var_14_1 = arg_14_0.vars.dlg:findChildByName("RIGHT")
	
	UIAction:Add(SEQ(SLIDE_OUT(200, -600)), var_14_0, "block")
	UIAction:Add(SEQ(SLIDE_OUT(200, 600)), var_14_1, "block")
	UIAction:Add(SEQ(DELAY(200), REMOVE()), arg_14_0.vars.dlg, "block")
end

function HANDLER.hero_detail_intimacy_voice(arg_15_0, arg_15_1)
	UnitInfosVoicePopup:playVoice(getParentWindow(arg_15_0))
end

function HANDLER.hero_detail_voice(arg_16_0, arg_16_1)
	if arg_16_1 == "btn_close" then
		UnitInfosVoicePopup:close()
	end
	
	if string.starts(arg_16_1, "btn_cat_") then
		UnitInfosVoicePopup:selectCategory(string.sub(arg_16_1, #"btn_cat_" + 1))
	end
end

UnitInfosVoicePopup = {}

copy_functions(ScrollView, UnitInfosVoicePopup)

function UnitInfosVoicePopup.playVoice(arg_17_0, arg_17_1)
	if get_cocos_refid(arg_17_0.vars._played_se) then
		arg_17_0.vars._played_se:stop()
	end
	
	if not arg_17_0.vars.unlocked_category[arg_17_1.category] then
		balloon_message_with_sound("need_more_fav_point")
		
		return 
	end
	
	arg_17_0.vars._played_se = SoundEngine:playVoice("event:/" .. arg_17_1.sound_id)
	
	if not arg_17_0.vars._played_se or not arg_17_0.vars._played_se.onStopEventListener then
		return 
	end
	
	if_set_opacity(arg_17_1, "icon", 255)
	arg_17_0.vars._played_se:onStopEventListener(function()
		if_set_opacity(arg_17_1, "icon", 127.5)
	end)
end

function UnitInfosVoicePopup.selectCategory(arg_19_0, arg_19_1)
	local var_19_0 = arg_19_0.vars.dlg:findChildByName("n_cat_cursor")
	local var_19_1 = arg_19_0.vars.dlg:findChildByName("n_cat_" .. arg_19_1)
	
	if not get_cocos_refid(var_19_1) then
		print("NOT EXISTS! n_cat.", arg_19_1)
		
		return 
	end
	
	if arg_19_0.vars.cur_category == arg_19_1 then
		return 
	end
	
	if arg_19_0.vars.notyet_category[arg_19_1] then
		balloon_message_with_sound("notyet_dev")
		
		return 
	end
	
	var_19_0:setPosition(var_19_1:getPosition())
	
	arg_19_0.vars.cur_category = arg_19_1
	arg_19_0.vars.cur_voice_db = arg_19_0.vars.voice_db[arg_19_1]
	arg_19_0.vars.is_unlocked = arg_19_0.vars.unlocked_category[arg_19_1]
	
	if get_cocos_refid(arg_19_0.vars.scrollView) then
		if not arg_19_0.vars.is_unlocked then
			if_set_opacity(arg_19_0.vars.dlg, arg_19_0.vars.scrollView:getName(), 76.5)
		else
			if_set_opacity(arg_19_0.vars.dlg, arg_19_0.vars.scrollView:getName(), 255)
		end
	end
	
	arg_19_0:createScrollViewItems(arg_19_0.vars.cur_voice_db)
end

function UnitInfosVoicePopup.setData(arg_20_0, arg_20_1, arg_20_2)
	local var_20_0 = arg_20_2:getFavLevel()
	
	arg_20_0.vars.notyet_category = {}
	arg_20_0.vars.unlocked_category = {}
	
	for iter_20_0, iter_20_1 in pairs(arg_20_1) do
		if iter_20_1.voice_id then
			if var_20_0 >= iter_20_1.intimacy_level and iter_20_1.lock ~= "y" then
				arg_20_0.vars.unlocked_category[iter_20_1.voice_id] = true
			end
			
			if iter_20_1.lock == "y" then
				arg_20_0.vars.notyet_category[iter_20_1.voice_id] = true
			end
		end
	end
	
	local var_20_1 = {
		"battle",
		"skill",
		"smalltalk",
		"camping"
	}
	
	arg_20_0.vars.voice_db = {}
	
	local var_20_2 = arg_20_2.db.code
	
	if arg_20_2:isMoonlightDestinyUnit() then
		var_20_2 = MoonlightDestiny:getRelationCharacterCode(var_20_2)
	end
	
	local var_20_3 = arg_20_2:getSkinCode()
	
	for iter_20_2, iter_20_3 in pairs(var_20_1) do
		local var_20_4 = {}
		
		for iter_20_4 = 1, 99 do
			local var_20_5 = var_20_2
			
			if var_20_3 then
				local var_20_6 = string.format("%s_%s_%02d", var_20_3, iter_20_3, iter_20_4)
				
				if DB("character_intimacy_voice", var_20_6, "id") then
					var_20_5 = var_20_3
				end
			end
			
			local var_20_7 = string.format("%s_%s_%02d", var_20_5, iter_20_3, iter_20_4)
			local var_20_8 = SLOW_DB_ALL("character_intimacy_voice", var_20_7)
			
			if not var_20_8 then
				break
			end
			
			if var_20_8.id == nil then
				break
			end
			
			table.insert(var_20_4, var_20_8)
		end
		
		if #var_20_4 > 0 then
			arg_20_0.vars.voice_db[iter_20_3] = var_20_4
		end
	end
end

function UnitInfosVoicePopup.setUI(arg_21_0, arg_21_1, arg_21_2)
	local var_21_0 = {
		"battle",
		"skill",
		"smalltalk",
		"camping"
	}
	local var_21_1 = arg_21_2:getFavLevel()
	
	for iter_21_0, iter_21_1 in pairs(arg_21_1) do
		if iter_21_1.voice_id and (not (var_21_1 >= iter_21_1.intimacy_level) or iter_21_1.lock == "y") then
			local var_21_2 = arg_21_0.vars.dlg:getChildByName("n_con_" .. iter_21_1.voice_id)
			
			if get_cocos_refid(var_21_2) then
				if_set(var_21_2, "txt_name", T("intimacy_lock_level", {
					level = iter_21_1.intimacy_level
				}))
			end
		end
	end
	
	for iter_21_2, iter_21_3 in pairs(var_21_0) do
		local var_21_3 = arg_21_0.vars.dlg:findChildByName("n_cat_" .. iter_21_3)
		
		if not arg_21_0.vars.unlocked_category[iter_21_3] then
			if_set_opacity(var_21_3, "n_con_" .. iter_21_3, 76.5)
		end
		
		if_set_visible(var_21_3, "img_locked", not arg_21_0.vars.unlocked_category[iter_21_3])
	end
	
	local var_21_4 = arg_21_2.inst.code
	
	if arg_21_2:isMoonlightDestinyUnit() then
		var_21_4 = MoonlightDestiny:getRelationCharacterCode(var_21_4)
	end
	
	local var_21_5 = UnitInfosUtil:getCharacterVoiceName(var_21_4)
	
	if_set(arg_21_0.vars.dlg, "txt_cv", var_21_5)
	
	arg_21_0.vars.scrollView = arg_21_0.vars.dlg:getChildByName("scrollview")
	
	arg_21_0:initScrollView(arg_21_0.vars.scrollView, 248, 50)
end

function UnitInfosVoicePopup.getScrollViewItem(arg_22_0, arg_22_1)
	local var_22_0 = load_control("wnd/hero_detail_intimacy_voice.csb")
	
	if_set(var_22_0, "label", T(arg_22_1.name))
	
	local var_22_1 = var_22_0:getChildByName("label"):getTextBoxSize()
	
	var_22_0:getChildByName("label"):setContentSize(var_22_1.width, var_22_1.height + 2)
	
	var_22_0.category = arg_22_0.vars.cur_category
	var_22_0.sound_id = arg_22_1.sound_id
	
	return var_22_0
end

function UnitInfosVoicePopup.create(arg_23_0, arg_23_1, arg_23_2, arg_23_3)
	if arg_23_0.vars then
		return 
	end
	
	arg_23_0.vars = {}
	arg_23_0.vars.dlg = load_dlg("hero_detail_voice", true, "wnd")
	
	local var_23_0 = arg_23_0.vars.dlg:getPositionX()
	local var_23_1 = arg_23_0.vars.dlg:getPositionY()
	
	arg_23_0.vars.dlg:setPositionY(var_23_1 - 500)
	UIAction:Add(SEQ(LOG(MOVE_TO(300, var_23_0, var_23_1))), arg_23_0.vars.dlg, "block")
	arg_23_1:addChild(arg_23_0.vars.dlg)
	arg_23_0:setData(arg_23_2, arg_23_3)
	arg_23_0:setUI(arg_23_2, arg_23_3)
	arg_23_0:selectCategory("battle")
end

function UnitInfosVoicePopup.close(arg_24_0, arg_24_1)
	if not arg_24_0.vars then
		return 
	end
	
	if get_cocos_refid(arg_24_0.vars.dlg) then
		if arg_24_1 then
			arg_24_0.vars.dlg:removeFromParent()
		else
			local var_24_0 = arg_24_0.vars.dlg:getPositionX()
			local var_24_1 = arg_24_0.vars.dlg:getPositionY()
			
			UIAction:Add(SEQ(RLOG(MOVE_TO(300, var_24_0, var_24_1 - 500)), REMOVE()), arg_24_0.vars.dlg, "block")
		end
	end
	
	arg_24_0.vars = nil
end
