CollectionNewHero = CollectionNewHero or {}

function HANDLER.dict_arti_detail(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_equip_arti" then
		if ContentDisable:byAlias("eq_arti_statistics") then
			balloon_message(T("content_disable"))
		elseif CollectionNewHero:getCurrentUnitCode() then
			Stove:openArtifactUsagePage(CollectionNewHero:getCurrentUnitCode())
		end
	end
end

function HANDLER.hero_story_go_on_dict(arg_2_0, arg_2_1)
	if arg_2_1 == "btn_go" then
		CollectionNewHero:playStory()
		CollectionNewHero:hidePopup()
	elseif arg_2_1 == "btn_cancel" then
		CollectionNewHero:hidePopup()
	end
end

function HANDLER.dict_unit_detail(arg_3_0, arg_3_1)
	if arg_3_1 == "btn_stat" then
	elseif arg_3_1 == "btn_show_stat" then
		CollectionNewHero:showStatPopup()
	elseif arg_3_1 == "btn_skill_preview" then
		CollectionNewHero:showSkillPreview()
	elseif arg_3_1 == "btn_story" then
		if not arg_3_0.active_flag then
			return 
		end
		
		CollectionNewHero:showStory()
		CollectionNewHero:hideButtons()
	elseif arg_3_1 == "btn_zodiac" then
		CollectionNewHero:showZodiac()
	elseif arg_3_1 == "btn_rate" then
		CollectionNewHero:showReview()
	elseif arg_3_1 == "btn_dedi" or arg_3_1 == "btn_dedi2" then
		CollectionNewHero:showDevoteDetail()
	elseif arg_3_1 == "btn_skin" then
		if arg_3_0:getOpacity() < 255 then
			balloon_message_with_sound("ui_skin_none")
			
			return 
		end
		
		CollectionNewHero:showSkinPopup()
	elseif arg_3_1 == "btn_count" then
		CollectionNewHero:requestHeroCount()
	end
	
	if arg_3_1 == "btn_cur" then
		CollectionNewHero:select_generation(CollectionNewHero.vars.current_generation, "next")
	elseif arg_3_1 == "btn_pre" then
		CollectionNewHero:select_generation(CollectionNewHero.vars.current_generation, "pre")
	end
end

function HANDLER.hero_story_clear(arg_4_0, arg_4_1)
	if arg_4_1 == "btn_ok" then
		getParentWindow(arg_4_0):removeFromParent()
	end
end

function HANDLER.artifact_card(arg_5_0, arg_5_1)
	if arg_5_1 == "btn_zoom" then
		ArtiZoom:onCreate({
			code = CollectionNewHero:getCurrentUnitCode(),
			layer = SceneManager:getRunningPopupScene(),
			close_callback = function()
				CollectionNewHero:ArtiZoomNodeAction()
			end
		})
	end
end

function MsgHandler.collection_unit_get_count(arg_7_0)
	CollectionNewHero:updateHeroCount(arg_7_0.unit_get_count)
end

function CollectionNewHero.hideButtons(arg_8_0)
	UIAction:Add(SPAWN(LOG(MOVE_BY(500, 0, -300))), arg_8_0.vars.wnd:getChildByName("pos_bbs"), "block")
	
	if get_cocos_refid(arg_8_0.vars.btn_show_stat) then
		UIAction:Add(SPAWN(LOG(MOVE_BY(500, 0, -300))), arg_8_0.vars.btn_show_stat, "block")
	end
	
	UIAction:Add(SPAWN(LOG(MOVE_BY(500, 0, -300))), arg_8_0.vars.wnd:getChildByName("btn_story"), "block")
	UIAction:Add(SPAWN(LOG(MOVE_BY(500, 0, -300))), arg_8_0.vars.wnd:getChildByName("btn_skill_preview"), "block")
	UIAction:Add(SPAWN(LOG(MOVE_BY(500, 0, -300))), arg_8_0.vars.wnd:getChildByName("btn_zodiac"), "block")
	
	if get_cocos_refid(arg_8_0.vars.btn_skin) then
		UIAction:Add(SPAWN(LOG(MOVE_BY(500, 0, -300))), arg_8_0.vars.btn_skin, "block")
	end
	
	UIAction:Add(SPAWN(LOG(MOVE_BY(500, 0, -300))), arg_8_0.vars.wnd:getChildByName("lock_story"), "block")
end

function CollectionNewHero.showButtons(arg_9_0)
	UIAction:Add(SPAWN(LOG(MOVE_BY(200, 0, 300))), arg_9_0.vars.wnd:getChildByName("pos_bbs"), "block")
	
	if get_cocos_refid(arg_9_0.vars.btn_show_stat) then
		UIAction:Add(SPAWN(LOG(MOVE_BY(200, 0, 300))), arg_9_0.vars.btn_show_stat, "block")
	end
	
	UIAction:Add(SPAWN(LOG(MOVE_BY(200, 0, 300))), arg_9_0.vars.wnd:getChildByName("btn_story"), "block")
	UIAction:Add(SPAWN(LOG(MOVE_BY(200, 0, 300))), arg_9_0.vars.wnd:getChildByName("btn_skill_preview"), "block")
	UIAction:Add(SPAWN(LOG(MOVE_BY(200, 0, 300))), arg_9_0.vars.wnd:getChildByName("btn_zodiac"), "block")
	
	if get_cocos_refid(arg_9_0.vars.btn_skin) then
		UIAction:Add(SPAWN(LOG(MOVE_BY(200, 0, 300))), arg_9_0.vars.btn_skin, "block")
	end
	
	UIAction:Add(SPAWN(LOG(MOVE_BY(200, 0, 300))), arg_9_0.vars.wnd:getChildByName("lock_story"), "block")
end

function CollectionNewHero.showArtifact(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	arg_10_0.vars = {}
	arg_10_0.vars.opts = arg_10_3 or {}
	arg_10_0.vars.parent = arg_10_1 or SceneManager:getDefaultLayer()
	arg_10_0.vars.wnd = load_dlg("dict_arti_detail", true, "wnd")
	
	UIUtil:changeButtonState(arg_10_0.vars.wnd.c.btn_illust, false, true)
	
	arg_10_0.vars.unit = EQUIP:createByInfo({
		code = arg_10_2
	})
	
	local var_10_0 = EQUIP:createByInfo({
		dup_pt = 5,
		code = arg_10_2,
		exp = EQUIP.getMaxExp(arg_10_0.vars.unit, 5)
	})
	local var_10_1 = arg_10_0.vars.unit.op[1][2]
	local var_10_2 = arg_10_0.vars.unit.op[2][2]
	local var_10_3, var_10_4, var_10_5, var_10_6 = var_10_0:getMainStat()
	
	if_set(arg_10_0.vars.wnd, "txt_att_minnum", to_var_str(var_10_1, "att"))
	if_set(arg_10_0.vars.wnd, "txt_hp_minnum", to_var_str(var_10_2, "max_hp"))
	ItemTooltip:updateItemInformation({
		no_star_align = true,
		wnd = arg_10_0.vars.wnd,
		equip = arg_10_0.vars.unit
	})
	if_set(arg_10_0.vars.wnd.c.max_info, "txt_main_name", getStatName("att"))
	if_set(arg_10_0.vars.wnd.c.max_info, "txt_main_name2", getStatName("max_hp"))
	if_set(arg_10_0.vars.wnd, "txt_att_maxnum", to_var_str(var_10_3, "att"))
	if_set(arg_10_0.vars.wnd, "txt_hp_maxnum", to_var_str(var_10_5, "max_hp"))
	
	arg_10_0.vars.code = arg_10_2
	
	local var_10_7 = arg_10_0.vars.unit.db.grade_min
	local var_10_8 = arg_10_0.vars.unit
	local var_10_9 = arg_10_0.vars.wnd:getChildByName("LEFT")
	local var_10_10 = arg_10_0.vars.wnd:getChildByName("RIGHT")
	local var_10_11 = arg_10_0.vars.wnd:getChildByName("CENTER")
	
	for iter_10_0 = 1, 6 do
		if_set_visible(arg_10_0.vars.wnd, "star" .. iter_10_0, false)
	end
	
	for iter_10_1 = 1, var_10_7 do
		if_set_visible(arg_10_0.vars.wnd, "star" .. iter_10_1, true)
	end
	
	if_set(arg_10_0.vars.wnd, "txt_skill_desc", TooltipUtil:getSkillTooltipText(arg_10_0.vars.unit.db.artifact_skill, 0))
	if_set(arg_10_0.vars.wnd, "txt_maxskill_desc", TooltipUtil:getSkillTooltipText(arg_10_0.vars.unit.db.artifact_skill, 10))
	if_set(arg_10_0.vars.wnd, "txt_name", arg_10_0.vars.unit:getName())
	
	local var_10_12 = arg_10_0.vars.unit.db.role == nil and "txt_story_no_role" or "txt_story"
	local var_10_13 = arg_10_0.vars.code .. "_desc"
	local var_10_14 = ""
	
	if DB("text", var_10_13, "text") then
		var_10_14 = T(var_10_13)
	end
	
	if_set(arg_10_0.vars.wnd, var_10_12, string.gsub(var_10_14, "\\n", "\n"))
	if_set_visible(arg_10_0.vars.wnd, "txt_story", arg_10_0.vars.unit.db.role)
	if_set_visible(arg_10_0.vars.wnd, "txt_story_no_role", not arg_10_0.vars.unit.db.role)
	
	local var_10_15 = IS_PUBLISHER_STOVE and not ContentDisable:byAlias("eq_arti_statistics")
	
	if_set_visible(arg_10_0.vars.wnd, "btn_equip_arti", var_10_15)
	arg_10_0.vars.parent:addChild(arg_10_0.vars.wnd)
	
	local var_10_16 = load_control("wnd/artifact_card.csb")
	local var_10_17 = {
		wnd = var_10_16,
		equip = arg_10_0.vars.unit
	}
	
	var_10_17.no_resize = true
	var_10_17.no_resize_name = true
	var_10_17.zoom_on = true
	var_10_17.txt_name = var_10_17.wnd:getChildByName("txt_name")
	
	ItemTooltip:updateItemInformation(var_10_17)
	arg_10_0.vars.wnd:getChildByName("n_artifact"):addChild(var_10_16)
	
	if arg_10_0.vars.opts.close_callback then
		TopBarNew:createFromPopup(T("system_051_title"), arg_10_0.vars.parent, function()
			arg_10_0.vars.opts.close_callback()
		end)
	end
end

function CollectionNewHero.ArtiZoomNodeAction(arg_12_0)
	if not arg_12_0.vars or not get_cocos_refid(arg_12_0.vars.wnd) then
		return 
	end
	
	local var_12_0 = arg_12_0.vars.wnd:findChildByName("n_artifact")
	
	if not get_cocos_refid(var_12_0) then
		return 
	end
	
	ArtiZoom:ArtiZoomNodeAction(var_12_0:findChildByName("n_zoom"))
end

function CollectionNewHero.hideMode(arg_13_0)
	if not arg_13_0.vars then
		arg_13_0:closeAll()
		SceneManager:nextScene("lobby")
		
		return 
	end
	
	if arg_13_0.vars.mode == "DETAIL" then
		if arg_13_0.vars.opts.close_callback then
			arg_13_0.vars.opts.close_callback()
		end
		
		arg_13_0:closeAll()
	elseif arg_13_0.vars.mode == "STORY" then
		CollectionNewHero:hideStory()
	elseif arg_13_0.vars.mode == "ZODIAC" then
		CollectionNewHero:hideZodiac()
	elseif arg_13_0.vars.mode == "REVIEW" then
		CollectionNewHero:hideReview()
	end
end

function CollectionNewHero.closeAll(arg_14_0)
	if not arg_14_0.vars then
		return 
	end
	
	if get_cocos_refid(arg_14_0.vars.wnd) then
		arg_14_0.vars.wnd:removeFromParent()
	end
	
	if get_cocos_refid(arg_14_0.vars.popup) then
		arg_14_0.vars.popup:removeFromParent()
	end
	
	if get_cocos_refid(arg_14_0.vars.stat_wnd) then
		arg_14_0.vars.stat_wnd:removeFromParent()
	end
	
	if get_cocos_refid(arg_14_0.vars.relation_wnd) then
		arg_14_0.vars.relation_wnd:removeFromParent()
	end
	
	if get_cocos_refid(arg_14_0.vars.review_wnd) then
		Review:close()
		arg_14_0.vars.review_wnd:removeFromParent()
	end
	
	local var_14_0 = SceneManager:getRunningPopupScene():getChildByName("hero_story_fix_detail")
	
	if var_14_0 and get_cocos_refid(var_14_0) then
		var_14_0:removeFromParent()
	end
	
	arg_14_0.vars = nil
end

function CollectionNewHero._makeUnit(arg_15_0, arg_15_1)
	local var_15_0, var_15_1, var_15_2 = DB("character", arg_15_1, {
		"grade",
		"face_id",
		"type"
	})
	
	return UNIT:create({
		z = 6,
		awake = 6,
		exp = 0,
		lv = 1,
		code = arg_15_1,
		g = var_15_0
	}), var_15_0, var_15_1, var_15_2
end

function CollectionNewHero._setButtonStory(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	local var_16_0 = arg_16_3:checkStory()
	
	UIUtil:changeButtonState(arg_16_2, var_16_0, true)
	
	arg_16_2.active_flag = var_16_0
	
	if_set_visible(arg_16_1, "lock_story", not var_16_0)
end

function CollectionNewHero._setUIText(arg_17_0, arg_17_1, arg_17_2)
	UIUtil:setUnitAllInfo(arg_17_1, arg_17_2, {
		ignore_stat_diff = true,
		use_basic_star = true
	})
	UIUtil:setUnitSkillInfo(arg_17_1, arg_17_2, {
		dict_mode = true,
		tooltip_opts = {
			show_effs = "right"
		}
	})
	UIUtil:setSubtaskSkill(arg_17_1, arg_17_2, {
		tooltip_creator = function()
			return UIUtil:getSubtaskSkillTooltip(arg_17_2)
		end
	})
end

function CollectionNewHero._setStarPosition(arg_19_0, arg_19_1, arg_19_2)
	if_call(arg_19_1, "star1", "setPositionX", 10 + arg_19_2:getContentSize().width * arg_19_2:getScaleX() + arg_19_2:getPositionX())
end

function CollectionNewHero._setUnitStory(arg_20_0, arg_20_1, arg_20_2)
	local var_20_0 = arg_20_1:getChildByName("LEFT")
	local var_20_1 = arg_20_1:getChildByName("RIGHT")
	
	if_set_visible(var_20_0, "detail", false)
	
	local var_20_2 = var_20_0:getChildByName("txt_story")
	
	if_set(var_20_2, nil, T(DB("character", arg_20_2, "2line")))
	
	local var_20_3 = var_20_1:getChildByName("txt_story")
	
	if_set(var_20_3, nil, T(DB("character", arg_20_2, "story")))
end

function CollectionNewHero._makePortait(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	arg_21_1:getChildByName("portrait"):removeAllChildren()
	
	local var_21_0 = UIUtil:getPortraitAni(arg_21_2, {
		pin_sprite_position_y = true,
		parent_pos_y = arg_21_3
	})
	
	if var_21_0 then
		var_21_0:setScale(0.8)
		arg_21_1:getChildByName("portrait"):addChild(var_21_0)
	end
	
	return var_21_0
end

function CollectionNewHero.getCurrentUnitCode(arg_22_0)
	if arg_22_0.vars and arg_22_0.vars.code then
		return arg_22_0.vars.code
	end
	
	return nil
end

function CollectionNewHero.requestHeroCount(arg_23_0, arg_23_1)
	if not arg_23_0.vars or not arg_23_0.vars.code then
		return 
	end
	
	query("collection_unit_get_count", {
		code = arg_23_0.vars.code
	})
end

function CollectionNewHero.updateHeroCount(arg_24_0, arg_24_1)
	if not arg_24_0.vars or not arg_24_1 then
		return 
	end
	
	local var_24_0 = arg_24_0.vars.wnd:getChildByName("LEFT"):getChildByName("n_hero_count")
	
	if get_cocos_refid(var_24_0) then
		if_set_visible(var_24_0, "btn_count", false)
		if_set_visible(var_24_0, "icon_arrow", false)
		if_set_visible(var_24_0, "t_count", true)
		if_set(var_24_0, "t_count", T("txt_char_info_get_count", {
			num = arg_24_1.ac
		}))
	end
end

function CollectionNewHero.setUnit(arg_25_0, arg_25_1)
	local var_25_0, var_25_1, var_25_2, var_25_3 = arg_25_0:_makeUnit(arg_25_1)
	
	arg_25_0.vars.code = arg_25_1
	arg_25_0.vars.unit = var_25_0
	arg_25_0.vars.default_grade = var_25_1
	arg_25_0.vars.face_id = var_25_2
	
	local var_25_4 = arg_25_0.vars.wnd:getChildByName("LEFT")
	local var_25_5 = var_25_4:getChildByName("n_hero_count")
	
	if get_cocos_refid(var_25_5) then
		if Account:getCollectionUnit(arg_25_1) and to_n(var_25_1) >= 5 and var_25_3 == "character" then
			var_25_5:setVisible(true)
			
			local var_25_6 = var_25_4:getChildByName("n_normal")
			local var_25_7 = var_25_4:getChildByName("n_normal_move")
			
			var_25_6:setPositionY(var_25_7:getPositionY())
			if_set_visible(var_25_5, "btn_count", true)
			if_set_visible(var_25_5, "icon_arrow", true)
			if_set_visible(var_25_5, "t_count", false)
		else
			var_25_5:setVisible(false)
		end
	end
	
	local var_25_8 = arg_25_0.vars.wnd:getChildByName("CENTER")
	
	arg_25_0:_setButtonStory(var_25_8, arg_25_0.vars.story, var_25_0)
	arg_25_0:_setUIText(arg_25_0.vars.wnd, var_25_0)
	
	local var_25_9 = arg_25_0.vars.wnd:getChildByName("txt_name")
	
	arg_25_0:_setStarPosition(arg_25_0.vars.wnd, var_25_9)
	arg_25_0:_setUnitStory(arg_25_0.vars.wnd, arg_25_1)
	
	if not arg_25_0.vars.portrait_pos_y then
		arg_25_0.vars.portrait_pos_y = var_25_8:getChildByName("portrait"):getPositionY()
	end
	
	arg_25_0.vars.portrait = arg_25_0:_makePortait(var_25_8, var_25_2, arg_25_0.vars.portrait_pos_y)
	
	arg_25_0:set_infoText()
	arg_25_0:set_exclusiveText()
	arg_25_0:set_cvText()
	if_set_opacity(arg_25_0.vars.btn_skin, nil, var_25_0:isSkinViewable() and 255 or 76)
	if_set_visible(arg_25_0.vars.btn_skin, nil, DB("character", var_25_0.inst.code, "skill_show_monster") ~= "y")
	if_set_visible(arg_25_0.vars.wnd, "btn_dedi", DB("character", var_25_0.inst.code, "skill_show_monster") ~= "y")
end

function CollectionNewHero.show(arg_26_0, arg_26_1, arg_26_2, arg_26_3)
	arg_26_0.vars = {}
	arg_26_0.vars.opts = arg_26_3 or {}
	arg_26_0.vars.parent = arg_26_1 or SceneManager:getRunningPopupScene()
	arg_26_0.vars.wnd = load_dlg("dict_unit_detail", true, "wnd")
	
	arg_26_0:_customSetupForPub()
	
	arg_26_0.vars.mode = "DETAIL"
	arg_26_0.vars.skill_preview = arg_26_0.vars.wnd:getChildByName("btn_skill_preview")
	arg_26_0.vars.story = arg_26_0.vars.wnd:getChildByName("btn_story")
	arg_26_0.vars.zodiac = arg_26_0.vars.wnd:getChildByName("btn_zodiac")
	
	if_set(arg_26_0.vars.wnd, "txt_skill_preview_on_center", T("preview_skill"))
	if_set(arg_26_0.vars.btn_show_stat, "txt_show_stat_on_center", T("preview_stat"))
	if_set(arg_26_0.vars.wnd, "txt_story_on_center", T("unit_menu_story"))
	if_set(arg_26_0.vars.wnd, "txt_zodiac_on_center", T("unit_menu_awakening"))
	
	local var_26_0 = arg_26_0.vars.wnd:getChildByName("CENTER")
	local var_26_1 = var_26_0:getChildByName("pos_lock")
	local var_26_2 = arg_26_0.vars.wnd:getChildByName("toggle_view")
	
	var_26_1:setVisible(false)
	if_set(var_26_0, "txt_show_stat", T("preview_stat"))
	if_set(var_26_0, "txt_zodiac", T("hero_btn_zodiac"))
	if_set_visible(var_26_0, "alert_story", false)
	if_set_visible(var_26_0, "alert_upgrade", false)
	if_set_visible(var_26_0, "btn", true)
	arg_26_0.vars.parent:addChild(arg_26_0.vars.wnd)
	
	if arg_26_0.vars.opts.topbar_title then
		TopBarNew:createFromPopup(arg_26_0.vars.opts.topbar_title, arg_26_0.vars.parent, function()
			CollectionNewHero:hideMode()
		end)
	end
	
	arg_26_0:setUnit(arg_26_2)
	arg_26_0:updateSpecialty(arg_26_2)
	NotchManager:addListener(arg_26_0.vars.wnd:getChildByName("LEFT_TOP"), true)
	
	return arg_26_0.vars.wnd
end

function CollectionNewHero._customSetupForPub(arg_28_0)
	if not get_cocos_refid(arg_28_0.vars.wnd) then
		return 
	end
	
	local var_28_0 = arg_28_0.vars.wnd:getChildByName("n_btn")
	
	if get_cocos_refid(var_28_0) then
		arg_28_0.vars.btn_show_stat = var_28_0:getChildByName("btn_show_stat")
		arg_28_0.vars.btn_skin = var_28_0:getChildByName("btn_skin")
	end
	
	if IS_PUBLISHER_ZLONG then
		local var_28_1 = arg_28_0.vars.wnd:getChildByName("n_btn_zl")
		
		if_set_visible(var_28_0, nil, false)
		if_set_visible(var_28_1, nil, true)
		
		if get_cocos_refid(var_28_1) then
			arg_28_0.vars.btn_show_stat = var_28_1:getChildByName("btn_show_stat")
			arg_28_0.vars.btn_skin = var_28_1:getChildByName("btn_skin")
		end
	end
end

function CollectionNewHero.set_infoText(arg_29_0)
	local var_29_0 = DB("character_reference", arg_29_0.vars.unit.db.code, {
		"self_promo_desc"
	})
	
	if arg_29_0.vars.unit:isLimitedUnit() == true and var_29_0 ~= nil then
		if_set_visible(arg_29_0.vars.wnd, "n_info", true)
		
		local var_29_1 = arg_29_0.vars.wnd:getChildByName("n_info")
		local var_29_2 = var_29_1:getChildByName("txt_info")
		
		if_set(var_29_2, nil, T(var_29_0))
		
		local var_29_3 = var_29_2:getStringNumLines()
		
		if var_29_3 >= 2 then
			local var_29_4 = var_29_3 - 1
			local var_29_5 = var_29_1:getChildByName("cm_icon_etcinfor")
			
			var_29_5:setPositionY(var_29_5:getPositionY() - 20)
			var_29_5:setPositionY(var_29_5:getPositionY() + 20 * var_29_4)
		end
	elseif arg_29_0.vars.unit:isDevotionUnit() == true then
		if_set_visible(arg_29_0.vars.wnd, "n_info", true)
		
		local var_29_6 = arg_29_0.vars.wnd:getChildByName("n_info")
		local var_29_7 = var_29_6:getChildByName("txt_info")
		
		if not var_29_0 then
			var_29_0 = "self_promo_desc_devotion"
			
			if_set(var_29_7, nil, T(var_29_0, {
				name = T(arg_29_0.vars.unit.db.name)
			}))
		else
			if_set(var_29_7, nil, T(var_29_0))
		end
		
		local var_29_8 = var_29_7:getStringNumLines()
		
		if var_29_8 >= 2 then
			local var_29_9 = var_29_8 - 1
			local var_29_10 = var_29_6:getChildByName("cm_icon_etcinfor")
			
			var_29_10:setPositionY(var_29_10:getPositionY() - 20)
			var_29_10:setPositionY(var_29_10:getPositionY() + 20 * var_29_9)
		end
	else
		if_set_visible(arg_29_0.vars.wnd, "n_info", false)
	end
end

function CollectionNewHero.set_exclusiveText(arg_30_0)
	local var_30_0 = arg_30_0.vars.unit:getExclusiveEquip()
	
	arg_30_0:reset_exclusiveText()
	
	if var_30_0 then
		local var_30_1 = arg_30_0.vars.wnd:getChildByName("n_private_item")
		
		if get_cocos_refid(var_30_1) then
			var_30_1:setVisible(true)
			
			local var_30_2 = DB("character_reference", arg_30_0.vars.unit.db.code, "skillequip_sell") == "y"
			
			if_set(var_30_1, "txt_private_title", T("dict_exclusive_title", {
				name = T(arg_30_0.vars.unit.db.name)
			}))
			if_set(var_30_1, "txt_private_info", T(var_30_2 and "dict_exclusive_desc" or "dict_exclusive_desc2"))
		end
		
		UIUtil:getRewardIcon(1, var_30_0, {
			show_all_exc_skills = true,
			parent = var_30_1:getChildByName("n_item")
		})
		
		local var_30_3 = DB("character_reference", arg_30_0.vars.unit.db.code, {
			"self_promo_desc"
		})
		
		if arg_30_0.vars.unit:isDevotionUnit() or arg_30_0.vars.unit:isLimitedUnit() == true and var_30_3 ~= nil then
			var_30_1:setPositionY(0)
		else
			var_30_1:setPositionY(-72)
		end
	end
end

function CollectionNewHero.reset_exclusiveText(arg_31_0)
	local var_31_0 = arg_31_0.vars.wnd:getChildByName("n_private_item")
	
	if not get_cocos_refid(var_31_0) then
		return 
	end
	
	var_31_0:getChildByName("n_item"):removeAllChildren()
	var_31_0:setVisible(false)
end

function CollectionNewHero.set_cvText(arg_32_0)
	local var_32_0 = UnitInfosUtil:getCharacterVoiceName(arg_32_0.vars.unit.db.code)
	
	if_set_visible(arg_32_0.vars.wnd, "n_cv", var_32_0)
	if_set(arg_32_0.vars.wnd, "txt_cv", var_32_0)
end

function CollectionNewHero.show_preview_by_toggle(arg_33_0)
	local var_33_0 = 300
	
	UIAction:Add(SPAWN(MOVE_TO(var_33_0, -DESIGN_WIDTH * 0.034), ROTATE(var_33_0, 90, -90)), arg_33_0.vars.wnd:getChildByName("toggle_view"), "block")
	UIAction:Add(SEQ(MOVE_TO(var_33_0, 0)), arg_33_0.vars.wnd:getChildByName("LEFT"), "block")
	UIAction:Add(SEQ(MOVE_TO(var_33_0, DESIGN_WIDTH)), arg_33_0.vars.wnd:getChildByName("RIGHT"), "block")
	UIAction:Add(SEQ(MOVE_TO(var_33_0, DESIGN_WIDTH * 1.5)), arg_33_0.vars.relation_wnd, "block")
end

function CollectionNewHero.getSimpleFace(arg_34_0, arg_34_1, arg_34_2)
	local var_34_0 = cc.CSLoader:createNode("wnd/wnd_story_target.csb")
	
	var_34_0:setAnchorPoint(0.5, 0.5)
	
	local var_34_1, var_34_2 = DB("character", arg_34_1, {
		"name",
		"face_id"
	})
	
	if var_34_2 == nil then
		Log.e("잘못된 데이터(character_relationship.db)", "character_id값 : ", arg_34_1, "face_id값", var_34_2)
		
		var_34_2 = "c1007"
	end
	
	if_set_sprite(var_34_0, "img_face", "face/" .. var_34_2 .. "_s.png")
	if_set(var_34_0, "chara_name", T(var_34_1))
	
	if arg_34_2 then
		local var_34_3, var_34_4 = UIUtil:getRelationColorIcon(arg_34_2)
		
		if_set_sprite(var_34_0, "icon_longing", var_34_4)
		if_set_color(var_34_0, "cm_hero_cirfrm_lock", var_34_3)
	else
		if_set_visible(var_34_0, "icon_longing", false)
	end
	
	if_set_visible(var_34_0, "cm_cool_hero_1", false)
	if_set_visible(var_34_0, "icon_locked", false)
	if_set_visible(var_34_0, "txt_name_0", false)
	
	return var_34_0
end

function CollectionNewHero.showDetailPopup(arg_35_0, arg_35_1, arg_35_2, arg_35_3, arg_35_4)
	if not arg_35_1 or not arg_35_3 then
		return 
	end
	
	RelationPipeLine:showDetailPopup(arg_35_0.vars.slot_info, arg_35_0.vars.slot_req_story, arg_35_1, arg_35_2, arg_35_3, arg_35_4)
end

function CollectionNewHero.getSlotStatDesc(arg_36_0, arg_36_1, arg_36_2)
	local var_36_0, var_36_1 = DB("character_relationship_bonus", "rb_" .. arg_36_1 .. "_" .. arg_36_2, {
		"bonus_type",
		"stat"
	})
	local var_36_2 = ""
	local var_36_3 = DB("skill", var_36_0, "sk_description")
	
	if not var_36_3 then
		if tonumber(var_36_1) then
			var_36_2 = getStatName(var_36_0) .. " +" .. to_var_str(var_36_1, var_36_0)
		else
			var_36_2 = T("hero_skill_info_error")
		end
	else
		var_36_2 = T(var_36_3)
	end
	
	return var_36_2
end

function CollectionNewHero.onSlotTouch(arg_37_0, arg_37_1)
	if arg_37_1 ~= 2 then
		return 
	end
	
	local var_37_0 = string.split(arg_37_0:getName(), "slot_")[2]
	local var_37_1 = CollectionNewHero.vars.slot_info[var_37_0]
	
	if var_37_1.slot_type == "fix" then
		if UIAction:Find("block") then
			return 
		end
		
		if var_37_1.locked then
			UnitStory:showUnlockInfoText(var_37_1)
		else
			CollectionNewHero:showDetailPopup(var_37_1, CollectionNewHero.vars.released_slot[var_37_0], var_37_0)
		end
	else
		balloon_message_with_sound("cant_relation")
	end
end

function CollectionNewHero.toggleDetailStat(arg_38_0)
	if arg_38_0.vars.detailed then
		UIAction:Add(LOG(MOVE_TO(200, 0, 30)), arg_38_0.vars.wnd:getChildByName("detail"), "block")
		UIAction:Add(SEQ(SHOW(true), LOG(FADE_IN(200))), arg_38_0.vars.wnd:getChildByName("n_skills"), "block")
		UIAction:Add(LOG(FADE_OUT(200)), arg_38_0.vars.wnd:getChildByName("ext"), "block")
		if_set_visible(arg_38_0.vars.wnd, "icon_sort", true)
	else
		UIAction:Add(LOG(MOVE_TO(200, 0, 250)), arg_38_0.vars.wnd:getChildByName("detail"), "block")
		UIAction:Add(SEQ(LOG(FADE_OUT(200)), SHOW(false)), arg_38_0.vars.wnd:getChildByName("n_skills"), "block")
		UIAction:Add(LOG(FADE_IN(200)), arg_38_0.vars.wnd:getChildByName("ext"), "block")
		if_set_visible(arg_38_0.vars.wnd, "icon_sort", false)
	end
	
	arg_38_0.vars.detailed = not arg_38_0.vars.detailed
end

function CollectionNewHero.showPopup(arg_39_0, arg_39_1)
	local var_39_0 = load_dlg("hero_story_go_on_dict", true, "wnd")
	
	SceneManager:getRunningPopupScene():addChild(var_39_0)
	
	arg_39_0.vars.popup = var_39_0 or {}
	arg_39_0.vars.popup.item = arg_39_1
	
	if_set(var_39_0, "txt_title", T(arg_39_1.db.story_title))
	
	if arg_39_1.state == "lock" then
		if_set(var_39_0, "txt_guide", T("ch_story_limit_zodiac_grade"))
		if_set_enabled(var_39_0, "btn_go", false)
	elseif arg_39_1.state == "require" then
		if_set(var_39_0, "txt_guide", T("ch_story_pre_story"))
	elseif arg_39_1.state == "already" then
		if_set(var_39_0, "txt_guide", T("ch_story_clear"))
	elseif arg_39_1.db.story_type == "battle" then
		if_set(var_39_0, "txt_guide", T("ch_story_battle_type"))
	else
		if_set(var_39_0, "txt_guide", T("ch_story_story_type"))
	end
	
	local var_39_1 = var_39_0:getChildByName("icon_storyguide")
	
	if get_cocos_refid(var_39_1) then
		local var_39_2 = var_39_1:getContentSize()
		local var_39_3 = "img/cm_icon_etcchatting.png"
		
		if arg_39_1.db.story_type == "battle" then
			var_39_3 = "img/cm_icon_etcbp.png"
		end
		
		if_set_sprite(var_39_0, "icon_storyguide", var_39_3)
		
		local var_39_4 = var_39_1:getContentSize()
		
		var_39_1:setScaleX(var_39_2.width / var_39_4.width * var_39_1:getScaleX())
		var_39_1:setScaleY(var_39_2.height / var_39_4.height * var_39_1:getScaleY())
	end
	
	SoundEngine:play("event:/ui/popup/tap")
end

function CollectionNewHero.hidePopup(arg_40_0, arg_40_1)
	if arg_40_0.vars and get_cocos_refid(arg_40_0.vars.popup) then
		arg_40_0.vars.popup:removeFromParent()
	end
end

function CollectionNewHero.playStory(arg_41_0, arg_41_1)
	local var_41_0 = arg_41_0.vars.item
	
	if var_41_0.state == "lock" or var_41_0.state == "require" then
		return 
	end
	
	if var_41_0.db.story_type == "battle" then
		local var_41_1 = {}
		local var_41_2 = TutorialBattle:getStoryUnits(var_41_0.db.party_preset, arg_41_0.vars.unit)
		
		BattleReady:show({
			hide_hpbar = true,
			skip_intro = false,
			is_story = true,
			callback = arg_41_0,
			enter_id = var_41_0.db.story_id,
			preset = var_41_0.db.party_preset,
			team = var_41_2
		})
	elseif var_41_0.db.story_type == "story" then
		local var_41_3 = SceneManager:getRunningNativeScene()
		
		start_new_story(var_41_3, var_41_0.db.story_id, {
			force = true
		})
		query("clear_relation_story", {
			code = arg_41_0.vars.unit.db.code,
			story_id = var_41_0.id
		})
	end
end

function CollectionNewHero.select_generation(arg_42_0, arg_42_1, arg_42_2)
	if arg_42_2 == "next" then
		arg_42_1 = arg_42_1 + 1
	else
		arg_42_1 = arg_42_1 - 1
	end
	
	if arg_42_0.vars.current_generation == arg_42_1 then
		return 
	end
	
	if arg_42_1 > arg_42_0.vars.totla_generation then
		return 
	end
	
	arg_42_0.vars.current_generation = arg_42_1
	
	arg_42_0:heroChangeInStory(arg_42_0.vars.unit.db.code)
end

function CollectionNewHero.showSkillPreview(arg_43_0, arg_43_1)
	if not DB("dic_data", arg_43_1 or arg_43_0.vars.code, "skill_preview") then
		balloon_message_with_sound("skill_preview_none")
		
		return 
	end
	
	TopBarNew:pop("CollectionNewHero")
	TopBarNew:pop("system_051_title")
	SceneManager:cancelReseveResetSceneFlow()
	startSkillPreview(arg_43_1 or arg_43_0.vars.code)
end

function CollectionNewHero.showStatPopup(arg_44_0, arg_44_1)
	HeroStatViewer:showStatPopup(arg_44_0.vars.unit)
end

function CollectionNewHero.isStoryVailed(arg_45_0)
	if not arg_45_0.vars then
		return 
	end
	
	return arg_45_0.vars.mode == "STORY"
end

function CollectionNewHero.heroChangeInStory(arg_46_0, arg_46_1, arg_46_2)
	if not arg_46_0.vars or not arg_46_1 then
		return 
	end
	
	local var_46_0 = string.format("re_%s_%d", arg_46_1, arg_46_0.vars.current_generation)
	local var_46_1 = DB("character_relationship_ui", var_46_0, {
		"relation_ui"
	}) or "wnd_story_v10_1"
	
	BackButtonManager:pop(var_46_1)
	
	if get_cocos_refid(arg_46_0.vars.relation_wnd) then
		arg_46_0.vars.relation_wnd:removeFromParent()
	end
	
	local var_46_2 = SceneManager:getRunningPopupScene():getChildByName("hero_story_fix_detail")
	
	if var_46_2 and get_cocos_refid(var_46_2) then
		var_46_2:removeFromParent()
		BackButtonManager:pop("hero_story_fix_detail")
	end
	
	if arg_46_2 then
		arg_46_0.vars.totla_generation, arg_46_0.vars.current_generation = RelationPipeLine:getGeneration(arg_46_1)
	end
	
	arg_46_0:setUnit(arg_46_1)
	arg_46_0:showStory(true)
	arg_46_0:updateSpecialty(arg_46_1)
end

function CollectionNewHero.set_generationButton(arg_47_0, arg_47_1)
	if not arg_47_0.vars or not get_cocos_refid(arg_47_0.vars.wnd) then
		return 
	end
	
	RelationPipeLine:setGenerationButton(arg_47_0.vars.wnd, arg_47_0.vars.unit, arg_47_1, arg_47_0.vars.totla_generation, arg_47_0.vars.current_generation)
end

function CollectionNewHero.showStory(arg_48_0, arg_48_1)
	local var_48_0 = arg_48_0.vars.unit
	local var_48_1 = DB("character", arg_48_0.vars.unit.db.code, {
		"face_id"
	})
	
	if arg_48_1 == nil then
		arg_48_0.vars.totla_generation, arg_48_0.vars.current_generation = RelationPipeLine:getGeneration(var_48_0.db.code)
	end
	
	RelationPipeLine:start()
	
	local var_48_2 = RelationPipeLine:makeRelationWnd(var_48_0, arg_48_0.vars.current_generation, {
		back_func = function()
			CollectionNewHero:hideMode()
		end
	})
	
	arg_48_0.vars.relation_wnd = var_48_2
	
	var_48_2:setPosition(DESIGN_WIDTH * 0.35, DESIGN_HEIGHT * 1)
	var_48_2:setOpacity(0)
	arg_48_0.vars.wnd:addChild(var_48_2)
	
	local var_48_3 = RelationPipeLine:getCache("current_id")
	
	arg_48_0:set_generationButton(var_48_3)
	
	arg_48_0.vars.mode = "STORY"
	
	RelationPipeLine:generateRelationMap(var_48_2, arg_48_0.onSlotTouch)
	
	arg_48_0.vars.slot_info = RelationPipeLine:getCache("slot_info")
	arg_48_0.vars.released_slot = {}
	arg_48_0.vars.slot_req_story = {}
	
	local var_48_4 = 300
	local var_48_5 = arg_48_0.vars.wnd:getChildByName("info")
	local var_48_6 = arg_48_0.vars.wnd:getChildByName("n_skills")
	local var_48_7 = arg_48_0.vars.wnd:getChildByName("portrait")
	
	UIAction:Add(SPAWN(FADE_OUT(var_48_4 + 50), SLIDE_OUT(200, -600)), var_48_5, "block")
	
	if not arg_48_1 then
		UIAction:Add(SPAWN(FADE_OUT(var_48_4 + 50), SLIDE_OUT(200, -600)), var_48_6, "block")
	end
	
	UIAction:Add(SPAWN(FADE_OUT(var_48_4 + 25), MOVE_TO(var_48_4, 0, -600)), var_48_7, "block")
	UIAction:Add(SPAWN(FADE_IN(var_48_4), LOG(MOVE_TO(var_48_4 - 150, DESIGN_WIDTH * 0.35, DESIGN_HEIGHT * 0.5))), arg_48_0.vars.relation_wnd, "block")
	
	for iter_48_0, iter_48_1 in pairs(arg_48_0.vars.relation_wnd:getChildren()) do
		if string.starts(iter_48_1:getName(), "new_line_") then
			for iter_48_2, iter_48_3 in pairs(iter_48_1:getChildren()) do
				iter_48_3:setOpacity(0)
				UIAction:Add(SEQ(FADE_IN(var_48_4 + 400)), iter_48_3, "block")
			end
		end
	end
	
	if_set_visible(arg_48_0.vars.wnd, "star1", false)
	if_set_visible(arg_48_0.vars.wnd, "n_info", false)
	if_set_visible(arg_48_0.vars.wnd, "n_cv", false)
	arg_48_0:reset_exclusiveText()
	RelationPipeLine:End()
end

function CollectionNewHero.hideStory(arg_50_0)
	arg_50_0.vars.mode = "DETAIL"
	
	local var_50_0 = 300
	local var_50_1 = arg_50_0.vars.wnd:getChildByName("info")
	local var_50_2 = arg_50_0.vars.wnd:getChildByName("n_skills")
	local var_50_3 = arg_50_0.vars.wnd:getChildByName("portrait")
	
	if_set_visible(arg_50_0.vars.wnd, "n_gener", false)
	UIAction:Add(SPAWN(FADE_IN(var_50_0 + 50), SLIDE_IN(var_50_0, 600)), var_50_1, "block")
	UIAction:Add(SPAWN(FADE_IN(var_50_0 + 50), SLIDE_IN(var_50_0, 600)), var_50_2, "block")
	UIAction:Add(SPAWN(FADE_IN(var_50_0 + 25), LOG(MOVE_TO(var_50_0, -45, 350))), var_50_3, "block")
	arg_50_0:showButtons()
	UIAction:Add(SPAWN(FADE_OUT(var_50_0), LOG(MOVE_TO(var_50_0 - 150, DESIGN_WIDTH * 0.35, DESIGN_HEIGHT * -0.5))), arg_50_0.vars.relation_wnd, "block")
	
	local var_50_4 = string.format("re_%s_%d", arg_50_0.vars.unit.db.code, arg_50_0.vars.current_generation)
	local var_50_5 = DB("character_relationship_ui", var_50_4, {
		"relation_ui"
	}) or "wnd_story_v10_1"
	
	BackButtonManager:pop(var_50_5)
	arg_50_0:set_infoText()
	arg_50_0:set_exclusiveText()
	arg_50_0:set_cvText()
	UIAction:Add(FADE_IN(200), arg_50_0.vars.wnd:getChildByName("star1"))
end

function CollectionNewHero.isClassChangeHero(arg_51_0, arg_51_1)
	if not arg_51_1 then
		return 
	end
	
	for iter_51_0 = 1, 999 do
		local var_51_0, var_51_1 = DBN("classchange_category", iter_51_0, {
			"char_id",
			"char_id_cc"
		})
		
		if not var_51_0 then
			break
		end
		
		if arg_51_1 == var_51_1 then
			return true
		end
	end
	
	return false
end

function CollectionNewHero.isPotentialHero(arg_52_0, arg_52_1)
	return DB("char_awake", "ca_" .. arg_52_1 .. "_" .. 1, "id") ~= nil
end

function CollectionNewHero.showZodiac(arg_53_0)
	if arg_53_0:isClassChangeHero(arg_53_0.vars.unit.db.code) or UnitExtension:getSkillTreeDB(arg_53_0.vars.unit.db.code) then
		local var_53_0 = arg_53_0.vars.unit:clone()
		
		var_53_0.inst.stree = {
			3,
			3,
			3,
			3,
			3,
			3,
			3,
			3,
			3,
			3,
			3,
			3,
			3,
			3,
			3
		}
		
		UnitZodiac:beginDictMode(arg_53_0.vars.parent, var_53_0, nil, true)
	elseif arg_53_0:isPotentialHero(arg_53_0.vars.unit.db.code) then
		UnitZodiac:beginDictMode(arg_53_0.vars.parent, arg_53_0.vars.unit, nil, true)
	else
		UnitZodiac:beginDictMode(arg_53_0.vars.parent, arg_53_0.vars.unit)
	end
	
	arg_53_0.vars.wnd:setVisible(false)
	
	arg_53_0.vars.mode = "ZODIAC"
	
	BackButtonManager:push({
		check_id = "CollectionNewHero.Zodiac",
		back_func = function()
			CollectionNewHero:hideMode()
		end
	})
end

function CollectionNewHero.hideZodiac(arg_55_0)
	arg_55_0.vars.mode = "DETAIL"
	
	UnitZodiac:endDictMode()
	arg_55_0.vars.wnd:setVisible(true)
	BackButtonManager:pop("CollectionNewHero.Zodiac")
end

function CollectionNewHero.showReview(arg_56_0)
	arg_56_0.vars.mode = "REVIEW"
	
	UIAction:Add(SEQ(SPAWN(FADE_OUT(125)), SHOW(false), CALL(function()
		arg_56_0.vars.review_wnd = UIUtil:openReview(CollectionNewHero.vars.code, CollectionNewHero.vars.parent)
	end)), CollectionNewHero.vars.wnd, "block")
end

function CollectionNewHero.hideReview(arg_58_0)
	arg_58_0.vars.mode = "DETAIL"
	
	UIAction:Add(SEQ(FADE_IN(125)), CollectionNewHero.vars.wnd, "block")
	Review:close()
	arg_58_0.vars.review_wnd:removeFromParent()
end

function CollectionNewHero.showDevoteDetail(arg_59_0)
	DevoteTooltip:showDevoteDetail(arg_59_0.vars.unit, arg_59_0.vars.wnd, {
		not_my_unit = true
	})
end

function CollectionNewHero.showSkinPopup(arg_60_0)
	UnitSkin:show(arg_60_0.vars.unit, true)
end

function CollectionNewHero.updateSpecialty(arg_61_0, arg_61_1)
	local var_61_0 = arg_61_0.vars.unit
	local var_61_1 = var_61_0:getSubTaskMissionSkill()
	
	if var_61_1 then
		local var_61_2 = DBT("character", arg_61_1, {
			"ch_command",
			"ch_attractive",
			"ch_politics"
		})
		local var_61_3 = arg_61_0.vars.wnd:getChildByName("n_specialty")
		
		if_set(var_61_3, "txt_stat1_count", var_61_2.ch_command or 0)
		if_set(var_61_3, "txt_stat2_count", var_61_2.ch_attractive or 0)
		if_set(var_61_3, "txt_stat3_count", var_61_2.ch_politics or 0)
		
		local var_61_4 = var_61_3:getChildByName("n_icon_specialty")
		
		if get_cocos_refid(var_61_4) then
			if_set_sprite(var_61_4, "icon", "skill/" .. (var_61_1.icon or ""))
		end
		
		WidgetUtils:setupTooltip({
			delay = 0,
			control = var_61_4:getChildByName("icon"),
			creator = function()
				if not arg_61_0.vars then
					return 
				end
				
				return UIUtil:getSubtaskSkillTooltip(arg_61_0.vars.unit)
			end
		})
		if_set(var_61_3, "txt_name", T(var_61_1.name))
		if_set(var_61_3, "txt_disc", T(var_61_1.desc))
	else
		if_set_visible(arg_61_0.vars.wnd, "n_specialty", false)
	end
	
	UIUtil:setDevoteDetail_new(arg_61_0.vars.wnd, var_61_0, {
		target = "n_dedi",
		not_my_unit = true
	})
end
