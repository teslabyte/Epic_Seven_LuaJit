UnitEmotion = {}

function MsgHandler.old_set_unit_face_value(arg_1_0)
	UnitEmotion:closeWindow(arg_1_0)
end

function HANDLER.hero_detail_intimacy_face(arg_2_0, arg_2_1)
	UnitEmotion:setPortraitEmotion(getParentWindow(arg_2_0), getParentWindow(arg_2_0).db)
end

copy_functions(ScrollView, UnitEmotion)

function UnitEmotion.open(arg_3_0, arg_3_1)
	local var_3_0 = arg_3_1.inst.skin_code or arg_3_1.db.code
	
	if not DB("character", var_3_0, "emotion_id") then
		balloon_message_with_sound("cant_intimacy")
		
		return 
	end
	
	arg_3_0.vars = {
		popup = load_dlg("hero_detail_intimacy", true, "wnd", function()
			UnitEmotion:close()
		end),
		db = {},
		unit = arg_3_1,
		unlocked_category = {},
		notyet_category = {}
	}
	
	arg_3_0:initScrollView(arg_3_0.vars.popup.c.scrollview, 248, 50)
	
	local var_3_1 = arg_3_0.vars.unit:getFaceID()
	
	arg_3_0.vars.original_intimacy_level = 1
	arg_3_0.vars.intimacy_level = 1
	
	for iter_3_0 = 1, 10 do
		local var_3_2 = SLOW_DB_ALL("character_intimacy_level", (DB("character", var_3_0, "emotion_id") or var_3_0) .. "_" .. iter_3_0)
		
		if not var_3_2 then
			break
		end
		
		if not var_3_2.id then
			break
		end
		
		table.push(arg_3_0.vars.db, var_3_2)
	end
	
	if #arg_3_0.vars.db == 0 then
		return 
	end
	
	local var_3_3 = arg_3_0.vars.unit:getFavLevel()
	local var_3_4 = 0
	
	for iter_3_1, iter_3_2 in pairs(arg_3_0.vars.db) do
		if iter_3_2.emotion then
			var_3_4 = var_3_4 + 1
			
			local var_3_5 = load_control("wnd/hero_detail_intimacy_face.csb")
			local var_3_6 = iter_3_2.emotion
			
			if string.starts(var_3_6, "special") then
				var_3_6 = "special"
			end
			
			var_3_5.c.btn_face:loadTextures("img/cm_icon_face_" .. var_3_6 .. ".png", "img/cm_icon_face_" .. var_3_6 .. "_p.png")
			if_set(var_3_5, "txt_name", T("emo_" .. iter_3_2.emotion))
			if_set_visible(var_3_5, "img_locked", var_3_3 < iter_3_2.intimacy_level)
			
			if var_3_3 < iter_3_2.intimacy_level then
				var_3_5.c.n_btn:setOpacity(76.5)
				
				var_3_5.locked = true
				
				if_set(var_3_5, "txt_name", T("intimacy_lock_level", {
					level = iter_3_2.intimacy_level
				}))
			end
			
			var_3_5.db = iter_3_2
			
			arg_3_0.vars.popup.c["n_face_" .. var_3_4]:addChild(var_3_5)
			
			if iter_3_2.emotion == var_3_1 then
				arg_3_0.vars.original_intimacy_level = iter_3_2.intimacy_level
				arg_3_0.vars.intimacy_level = iter_3_2.intimacy_level
				
				arg_3_0:setPortraitEmotion(var_3_5, iter_3_2)
			end
		end
		
		if iter_3_2.voice_id then
			if var_3_3 >= iter_3_2.intimacy_level and iter_3_2.lock ~= "y" then
				arg_3_0.vars.unlocked_category[iter_3_2.voice_id] = true
			else
				local var_3_7 = arg_3_0.vars.popup:getChildByName("n_con_" .. iter_3_2.voice_id)
				
				if get_cocos_refid(var_3_7) then
					if_set(var_3_7, "txt_name", T("intimacy_lock_level", {
						level = iter_3_2.intimacy_level
					}))
				end
			end
			
			if iter_3_2.lock == "y" then
				arg_3_0.vars.notyet_category[iter_3_2.voice_id] = true
			end
		end
	end
	
	if not arg_3_0.vars.unlocked_category.battle then
		if_set_opacity(arg_3_0.vars.popup, "n_con_battle", 76.5)
	end
	
	if not arg_3_0.vars.unlocked_category.skill then
		if_set_opacity(arg_3_0.vars.popup, "n_con_skill", 76.5)
	end
	
	if not arg_3_0.vars.unlocked_category.smalltalk then
		if_set_opacity(arg_3_0.vars.popup, "n_con_smalltalk", 76.5)
	end
	
	if not arg_3_0.vars.unlocked_category.camping then
		if_set_opacity(arg_3_0.vars.popup, "n_con_camping", 76.5)
	end
	
	if_set_visible(arg_3_0.vars.popup.c.n_cat_battle, "img_locked", not arg_3_0.vars.unlocked_category.battle)
	if_set_visible(arg_3_0.vars.popup.c.n_cat_skill, "img_locked", not arg_3_0.vars.unlocked_category.skill)
	if_set_visible(arg_3_0.vars.popup.c.n_cat_smalltalk, "img_locked", not arg_3_0.vars.unlocked_category.smalltalk)
	if_set_visible(arg_3_0.vars.popup.c.n_cat_camping, "img_locked", not arg_3_0.vars.unlocked_category.camping)
	
	local var_3_8 = arg_3_1.inst.code
	
	if arg_3_1:isMoonlightDestinyUnit() then
		var_3_8 = MoonlightDestiny:getRelationCharacterCode(var_3_8)
	end
	
	local var_3_9 = UnitInfosUtil:getCharacterVoiceName(var_3_8)
	local var_3_10 = arg_3_0.vars.popup:getChildByName("n_voice"):getChildByName("txt_title")
	local var_3_11 = var_3_10:getContentSize().width
	
	var_3_10:getChildByName("txt_cv"):setPositionX(var_3_11 + 10)
	if_set(arg_3_0.vars.popup, "txt_cv", var_3_9)
	UIUtil:setFavoriteDetail(arg_3_0.vars.popup, arg_3_0.vars.unit)
	arg_3_0:selectCategory("battle")
	SceneManager:getRunningNativeScene():addChild(arg_3_0.vars.popup)
	arg_3_0.vars.popup:setOpacity(0)
	UIAction:Add(LOG(FADE_IN(250)), arg_3_0.vars.popup, "block")
	
	local var_3_12 = arg_3_0.vars.popup:getChildByName("@progress")
	
	var_3_12:setOpacity(0)
	UIAction:Add(LOG(FADE_IN(250)), var_3_12, "block")
end

function UnitEmotion.close(arg_5_0)
	if not arg_5_0.vars or not arg_5_0.vars.popup or not get_cocos_refid(arg_5_0.vars.popup) then
		return 
	end
	
	local var_5_0 = arg_5_0.vars.intimacy_level - 1
	
	if arg_5_0.vars.original_intimacy_level ~= arg_5_0.vars.intimacy_level and var_5_0 < 10 and var_5_0 >= 0 then
		query("set_unit_face_value", {
			target = arg_5_0.vars.unit:getUID(),
			value = var_5_0
		})
	else
		arg_5_0:closeWindow()
	end
end

function UnitEmotion.closeWindow(arg_6_0, arg_6_1)
	if not arg_6_0.vars or not arg_6_0.vars.popup or not get_cocos_refid(arg_6_0.vars.popup) then
		return 
	end
	
	UIAction:Add(SEQ(LOG(FADE_OUT(250)), REMOVE()), arg_6_0.vars.popup, "block")
	UIAction:Add(SEQ(LOG(FADE_OUT(250))), arg_6_0.vars.popup:getChildByName("@progress"), "block")
	BackButtonManager:pop("hero_detail_intimacy")
	
	if arg_6_1 and arg_6_1.unit_opt then
		arg_6_0.vars.unit:updateUnitOptionValue(arg_6_1.unit_opt)
	end
	
	arg_6_0.vars = nil
end

function UnitEmotion.setPortraitEmotion(arg_7_0, arg_7_1, arg_7_2)
	if arg_7_1.notyet_dev then
		balloon_message_with_sound("notyet_dev")
		
		return 
	end
	
	if arg_7_1.locked then
		balloon_message_with_sound("need_more_fav_point")
		
		return 
	end
	
	arg_7_0.vars.intimacy_level = arg_7_2.intimacy_level
	
	UnitMain:setPortraitEmotion(arg_7_0.vars.unit, UnitMain:getPortrait(), arg_7_2.emotion)
	arg_7_0.vars.popup.c.n_face_cursor:setPosition(arg_7_1:getParent():getPosition())
end

function UnitEmotion.selectCategory(arg_8_0, arg_8_1)
	if arg_8_0.vars.category == arg_8_1 then
		return 
	end
	
	arg_8_0.vars.is_unlocked = arg_8_0.vars.unlocked_category[arg_8_1]
	
	if arg_8_0.vars.notyet_category[arg_8_1] then
		balloon_message_with_sound("notyet_dev")
		
		return 
	end
	
	arg_8_0.vars.category = arg_8_1
	
	arg_8_0.vars.popup.c.n_cat_cursor:setPosition(arg_8_0.vars.popup.c["n_cat_" .. arg_8_1]:getPosition())
	
	arg_8_0.vars.voices = {}
	
	for iter_8_0 = 1, 99 do
		local var_8_0 = SLOW_DB_ALL("character_intimacy_voice", string.format("%s_%s_%02d", arg_8_0.vars.unit.inst.code, arg_8_1, iter_8_0))
		
		if not var_8_0 then
			break
		end
		
		if var_8_0.id == nil then
			break
		end
		
		table.push(arg_8_0.vars.voices, var_8_0)
	end
	
	arg_8_0:createScrollViewItems(arg_8_0.vars.voices)
end

function UnitEmotion.playVoice(arg_9_0, arg_9_1)
	if get_cocos_refid(arg_9_0.vars._played_se) then
		arg_9_0.vars._played_se:stop()
	end
	
	if not arg_9_0.vars.unlocked_category[arg_9_1.category] then
		balloon_message_with_sound("need_more_fav_point")
		
		return 
	end
	
	arg_9_0.vars._played_se = SoundEngine:playVoice("event:/" .. arg_9_1.sound_id)
	
	if not arg_9_0.vars._played_se or not arg_9_0.vars._played_se.onStopEventListener then
		return 
	end
	
	if_set_opacity(arg_9_1, "icon", 255)
	arg_9_0.vars._played_se:onStopEventListener(function()
		if_set_opacity(arg_9_1, "icon", 127.5)
	end)
end

function UnitEmotion.getScrollViewItem(arg_11_0, arg_11_1)
	local var_11_0 = load_control("wnd/hero_detail_intimacy_voice.csb")
	
	if_set(var_11_0, "label", T(arg_11_1.name))
	
	local var_11_1 = var_11_0:getChildByName("label"):getTextBoxSize()
	
	var_11_0:getChildByName("label"):setContentSize(var_11_1.width, var_11_1.height + 2)
	if_set_visible(var_11_0, "img_locked", not arg_11_0.vars.is_unlocked)
	
	var_11_0.category = arg_11_0.vars.category
	var_11_0.sound_id = arg_11_1.sound_id
	
	return var_11_0
end
