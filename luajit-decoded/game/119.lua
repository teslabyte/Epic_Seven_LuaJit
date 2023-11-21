function HANDLER.story_home(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_sub_story" then
		SubStoryEntrance:setMode("SUBSTORY_LIST")
	elseif arg_1_1 == "btn_epilogue" then
		SubstoryManager:queryEnter("vewrda")
	elseif arg_1_1 == "btn_ibrary" then
		SubStoryDlc:enterQuery()
	elseif arg_1_1 == "btn_theater" then
		SubStoryEntrance:setMode("MOONLIGHT_THEATER")
	elseif arg_1_1 == "btn_go_story_book" then
		SubStoryEntrance:_enterCollection()
	elseif arg_1_1 == "btn_go_chronicle" then
		Account:showServerResUI("chronicle")
	elseif arg_1_1 == "btn_go_herostory" then
		Account:showServerResUI("system_story")
	elseif arg_1_1 == "btn_etc" then
	end
end

SubStoryEntrance = SubStoryEntrance or {}

function SubStoryEntrance.show(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	local var_2_0 = arg_2_4 or {}
	local var_2_1 = var_2_0
	
	var_2_1.mode = arg_2_1
	
	local var_2_2 = Account:checkQueryEmptyDungeonData("substory_home.show", var_2_1)
	
	if not arg_2_3 and var_2_2 then
		return 
	end
	
	arg_2_1 = arg_2_1 or "HOME"
	
	if MusicBoxUI:isShow() then
		MusicBoxUI:close()
	end
	
	if arg_2_0:isVisible() and arg_2_0:getMode() == arg_2_1 then
		return 
	end
	
	if arg_2_0:isVisible() then
		arg_2_0:setBackType(arg_2_2)
		arg_2_0:setMode(arg_2_1 or "HOME", var_2_0)
		
		return 
	end
	
	arg_2_0.vars = {}
	arg_2_0.vars.mode_obj = {
		HOME = SubStoryHome,
		SUBSTORY_LIST = SubStoryListMain,
		MOONLIGHT_THEATER = MoonlightTheaterList,
		CHRONICLE = SubStoryChronicle,
		SYSTEM_STORY = SubstorySystemStoryList
	}
	arg_2_0.vars.layer = cc.Layer:create()
	
	arg_2_0.vars.layer:setContentSize(VIEW_WIDTH, VIEW_HEIGHT)
	arg_2_0.vars.layer:setPosition(VIEW_BASE_LEFT, 0)
	SceneManager:getRunningPopupScene():addChild(arg_2_0.vars.layer)
	arg_2_0.vars.layer:setLocalZOrder(99999)
	arg_2_0:setBackType(arg_2_2)
	
	local var_2_3 = cc.LayerColor:create(cc.c3b(0, 0, 0))
	
	var_2_3:setContentSize(VIEW_WIDTH, VIEW_HEIGHT)
	var_2_3:setPosition(0, 0)
	var_2_3:setVisible(true)
	
	arg_2_0.vars.black_color_layer = var_2_3
	
	arg_2_0.vars.layer:addChild(var_2_3)
	
	local var_2_4 = ccui.Button:create()
	
	var_2_4:setTouchEnabled(true)
	var_2_4:ignoreContentAdaptWithSize(false)
	var_2_4:setContentSize(VIEW_WIDTH, VIEW_HEIGHT)
	var_2_4:setPosition(VIEW_WIDTH / 2, VIEW_HEIGHT / 2)
	var_2_4:setName("touch_block")
	arg_2_0.vars.layer:addChild(var_2_4)
	
	arg_2_0.vars.mode_flow = {}
	
	arg_2_0:setMode(arg_2_1 or "HOME", var_2_0)
end

function SubStoryEntrance.setBackType(arg_3_0, arg_3_1)
	if not arg_3_0:isVisible() then
		return 
	end
	
	arg_3_0.vars.back_type = arg_3_1 or "pop"
end

function SubStoryEntrance.setForceBackLobby(arg_4_0, arg_4_1)
	if not arg_4_0:isVisible() then
		return 
	end
	
	arg_4_0.vars.force_back_lobby = arg_4_1
end

function SubStoryEntrance.setMode(arg_5_0, arg_5_1, arg_5_2)
	if not arg_5_1 then
		Log.e("SubStoryEntrance.setMode", "invalid_mode")
		
		return 
	end
	
	if not arg_5_0.vars then
		Log.e("SubStoryEntrance.setMode", "invalid_vars")
		
		return 
	end
	
	if not arg_5_0.vars.mode_obj then
		Log.e("SubStoryEntrance.setMode", "invalid_mode_obj")
		
		return 
	end
	
	if not arg_5_0.vars.mode_obj[arg_5_1] then
		Log.e("SubStoryEntrance.setMode", "invalid_mode")
		
		return 
	end
	
	if arg_5_0.vars.mode == arg_5_1 then
		return 
	end
	
	SubStoryLobby:refreshBGM(false)
	
	if arg_5_0.vars.mode then
		arg_5_0.vars.mode_obj[arg_5_0.vars.mode]:close(arg_5_0.vars.mode)
	end
	
	arg_5_0.vars.mode = arg_5_1
	
	local var_5_0 = arg_5_0.vars.mode_obj[arg_5_0.vars.mode]
	
	if not var_5_0 then
		Log.e("SubStoryEntrance.setMode", "invalid_mode_obj")
		
		return 
	end
	
	if not get_cocos_refid(arg_5_0.vars.layer) then
		Log.e("SubStoryEntrance.setMode", "invalid_layer")
		
		return 
	end
	
	SceneManager:cancelReseveResetSceneFlow()
	table.insert(arg_5_0.vars.mode_flow, arg_5_1)
	var_5_0:show(arg_5_0.vars.layer, arg_5_2)
	GrowthGuideNavigator:proc()
end

function SubStoryEntrance.popMode(arg_6_0)
	local var_6_0 = table.pop(arg_6_0.vars.mode_flow)
	local var_6_1 = arg_6_0.vars.mode_flow[#arg_6_0.vars.mode_flow] or "HOME"
	
	if var_6_0 == "HOME" or table.empty(arg_6_0.vars.mode_flow) then
		arg_6_0.vars.mode_flow = {}
		
		arg_6_0:close()
	else
		arg_6_0:setMode(var_6_1, {
			skip_fade_in = true
		})
	end
end

function SubStoryEntrance.getMode(arg_7_0)
	if not arg_7_0.vars then
		return 
	end
	
	return arg_7_0.vars.mode
end

function SubStoryEntrance.isVisible(arg_8_0)
	return arg_8_0.vars and get_cocos_refid(arg_8_0.vars.layer) and arg_8_0.vars.layer:isVisible()
end

function SubStoryEntrance._enterCollection(arg_9_0)
	if SceneManager:getCurrentSceneName() == "collection" then
		CollectionController:release()
	end
	
	SceneManager:nextScene("collection", {
		enter_by_substory_home = "home",
		mode = "story",
		parent_id = "story7"
	})
end

function SubStoryEntrance.setVisibleBlackColorLayer(arg_10_0, arg_10_1)
	if arg_10_0.vars and get_cocos_refid(arg_10_0.vars.black_color_layer) then
		arg_10_0.vars.black_color_layer:setVisible(arg_10_1)
	end
end

function SubStoryEntrance.updateOffsetDlg(arg_11_0)
	if not arg_11_0:isVisible() then
		return 
	end
	
	if get_cocos_refid(arg_11_0.vars.black_color_layer) then
		arg_11_0.vars.black_color_layer:setContentSize(VIEW_WIDTH, VIEW_HEIGHT)
		arg_11_0.vars.black_color_layer:setPosition(0, 0)
	end
	
	local var_11_0 = arg_11_0.vars.mode_obj[arg_11_0.vars.mode]
	
	if var_11_0 and type(var_11_0.updateOffsetDlg) == "function" then
		var_11_0:updateOffsetDlg()
	end
end

function SubStoryEntrance.close(arg_12_0, arg_12_1)
	arg_12_1 = arg_12_1 or {}
	
	if not arg_12_0:isVisible() then
		return 
	end
	
	if arg_12_0.vars.delete_eff then
		return 
	end
	
	local var_12_0 = arg_12_0.vars.mode_obj[arg_12_0.vars.mode]
	
	if not var_12_0 then
		Log.e("SubStoryEntrance.close", "invalid_mode_obj")
		
		return 
	end
	
	var_12_0:close()
	
	if get_cocos_refid(arg_12_0.vars.layer) then
		arg_12_0.vars.delete_eff = true
		
		UIAction:Add(SEQ(LOG(DELAY(300)), REMOVE()), arg_12_0.vars.layer, "block")
	end
	
	local function var_12_1()
		SceneManager:nextScene("lobby")
		
		if get_cocos_refid(arg_12_0.vars.black_color_layer) then
			arg_12_0.vars.black_color_layer:setVisible(true)
		end
	end
	
	if arg_12_0.vars.back_type and arg_12_0.vars.back_type == "close" then
		SubStoryLobby:refreshBGM(true)
	end
	
	local var_12_2
	
	if arg_12_0.vars.force_back_lobby then
		var_12_1()
		
		return 
	elseif arg_12_0.vars.back_type ~= "close" then
		var_12_2 = SceneManager:getCurrentSceneName()
		
		for iter_12_0, iter_12_1 in pairs(SUBSTORY_HOME_BACK_LOBBY_SCENE) do
			if var_12_2 == iter_12_1 then
				var_12_1()
				
				return 
			end
		end
	end
end

SubStoryHome = SubStoryHome or {}

function SubStoryHome.show(arg_14_0, arg_14_1, arg_14_2)
	arg_14_0.vars = {}
	arg_14_0.vars.wnd = load_dlg("story_home", true, "wnd")
	
	arg_14_0.vars.wnd:setPositionX(arg_14_1:getContentSize().width / 2)
	
	local var_14_0 = (arg_14_2 or {}).skip_fade_in or false
	local var_14_1 = 300
	
	if var_14_0 then
		var_14_1 = 0
	end
	
	UIAction:Add(SEQ(LOG(FADE_IN(var_14_1)), CALL(function()
		TutorialNotice:update("story_home")
	end), DELAY(100), CALL(arg_14_0.playUnlockCategoryEffect, arg_14_0)), arg_14_0.vars.wnd, "block")
	arg_14_1:addChild(arg_14_0.vars.wnd)
	
	arg_14_0.vars.scrollview = arg_14_0.vars.wnd:getChildByName("scrollview")
	arg_14_0.vars.scrollview.origin_pos_x = arg_14_0.vars.scrollview:getPositionX()
	
	arg_14_0.vars.scrollview:setPositionX(arg_14_0.vars.scrollview.origin_pos_x + VIEW_BASE_LEFT)
	
	local var_14_2 = arg_14_0.vars.scrollview:getChildren()
	
	for iter_14_0, iter_14_1 in pairs(var_14_2) do
		iter_14_1.origin_pos_x = iter_14_1:getPositionX()
		
		iter_14_1:setOpacity(0)
		UIAction:Add(SEQ(DELAY((iter_14_0 - 1) * 30), SLIDE_IN(300, -1300)), iter_14_1, "block")
	end
	
	local function var_14_3()
		SubStoryEntrance:close()
		
		return TopBarNew.BACK_BUTTON_RESULT.BACK_BUTTON_MANAGER_NEED_POP
	end
	
	TopBarNew:createFromPopup(T("substory_title"), arg_14_0.vars.wnd, var_14_3, nil, "infosubs")
	arg_14_0:updateStoryItem()
	arg_14_0:updateTheaterItem()
	arg_14_0:updateEpilogueItem()
	arg_14_0:updateDlcItem()
	arg_14_0:updateSystemSubstoryList()
end

function SubStoryHome.close(arg_17_0)
	UIAction:Add(SEQ(LOG(FADE_OUT(300)), REMOVE()), arg_17_0.vars.wnd, "block")
	TutorialNotice:detachByPoint("substyory_list")
	TopBarNew:pop()
	BackButtonManager:pop("TopBarNew." .. T("substory_title"))
	TopBarNew:updateSubstoryButton()
	TopBarNew:updateSeasonPass()
end

function SubStoryHome.updateOffsetDlg(arg_18_0)
	if not arg_18_0.vars or not get_cocos_refid(arg_18_0.vars.scrollview) then
		return 
	end
	
	arg_18_0.vars.scrollview:setPositionX(arg_18_0.vars.scrollview.origin_pos_x + VIEW_BASE_LEFT)
	
	local var_18_0 = arg_18_0.vars.scrollview:getChildren()
	
	for iter_18_0, iter_18_1 in pairs(var_18_0) do
		if get_cocos_refid(iter_18_1) then
			iter_18_1:setPositionX(iter_18_1.origin_pos_x)
		end
	end
end

function SubStoryHome.playUnlockCategoryEffect(arg_19_0)
	set_high_fps_tick(5000)
	
	local var_19_0 = 300
	local var_19_1 = 600
	local var_19_2 = {}
	local var_19_3 = {}
	local var_19_4 = arg_19_0.vars.wnd:getChildByName("n_theater")
	local var_19_5 = arg_19_0.vars.wnd:getChildByName("n_library")
	local var_19_6 = arg_19_0.vars.wnd:getChildByName("n_epilogue")
	
	table.insert(var_19_3, {
		item = var_19_4:getChildByName("Sprite_14"),
		unlock_id = UNLOCK_ID.MOONLIGHT_THEATER
	})
	table.insert(var_19_3, {
		item = var_19_6:getChildByName("Sprite_14"),
		unlock_id = UNLOCK_ID.WORLD_LEVEL
	})
	table.insert(var_19_3, {
		item = var_19_5:getChildByName("Sprite_14"),
		unlock_id = UNLOCK_ID.SUBSTORY_DLC
	})
	
	for iter_19_0, iter_19_1 in pairs(var_19_3) do
		local var_19_7 = iter_19_1.unlock_id
		
		if get_cocos_refid(iter_19_1.item) and var_19_7 and UnlockSystem:isUnlockSystem(var_19_7) and not Account:getConfigData("unlock_eff." .. var_19_7) then
			table.insert(var_19_2, {
				item = iter_19_1.item,
				unlock_id = var_19_7
			})
		end
	end
	
	for iter_19_2, iter_19_3 in pairs(var_19_2) do
		UIAction:Add(SEQ(DELAY(var_19_0 + var_19_1 * (iter_19_2 - 1)), CALL(arg_19_0.playCategoryEffect, arg_19_0, iter_19_3.unlock_id, iter_19_3.item)), arg_19_0, "block")
	end
	
	local var_19_8 = #var_19_2
	
	if var_19_8 > 0 then
		local var_19_9 = ccui.Button:create()
		
		var_19_9:setTouchEnabled(true)
		var_19_9:ignoreContentAdaptWithSize(false)
		var_19_9:setContentSize(VIEW_WIDTH, VIEW_HEIGHT)
		var_19_9:setLocalZOrder(999999)
		var_19_9:setPosition(VIEW_WIDTH / 2, VIEW_HEIGHT / 2)
		arg_19_0.vars.wnd:addChild(var_19_9)
		UIAction:Add(SEQ(DELAY(var_19_0 + var_19_1 * var_19_8), CALL(function()
			SAVE:sendQueryServerConfig()
		end), REMOVE()), var_19_9, "block")
	end
end

function SubStoryHome.playCategoryEffect(arg_21_0, arg_21_1, arg_21_2)
	local var_21_0, var_21_1 = arg_21_2:getPosition()
	local var_21_2 = arg_21_2:getContentSize()
	local var_21_3 = 0
	local var_21_4 = "ui_substory_normal_unlock"
	local var_21_5 = SceneManager:convertToSceneSpace(arg_21_2:getParent(), {
		x = 0,
		y = 0
	})
	
	EffectManager:Play({
		z = 99998,
		fn = var_21_4 .. ".cfx",
		layer = arg_21_0.vars.wnd,
		x = var_21_5.x + var_21_2.width / 2,
		y = var_21_5.y + var_21_2.height / 2 + var_21_3
	})
	SAVE:setTempConfigData("unlock_eff." .. arg_21_1, true)
end

function SubStoryHome.updateStoryItem(arg_22_0)
	if not arg_22_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_22_0.vars.wnd) then
		return 
	end
	
	local var_22_0 = arg_22_0.vars.wnd:getChildByName("n_sub_story")
	
	if not get_cocos_refid(var_22_0) then
		return 
	end
	
	local var_22_1 = var_22_0:getChildByName("n_contents")
	
	if not get_cocos_refid(var_22_1) then
		return 
	end
	
	local var_22_2 = var_22_1:getChildByName("n_title")
	local var_22_3 = SubStoryUtil:getStoryList(true)[1]
	
	if_set(var_22_2, "txt_etc", T("level_battlemenu_list_substory"))
	if_set(var_22_2, "txt_title", T("level_battlemenu_name_substory"))
	if_set_visible(var_22_1, "locale_logo_img", false)
	
	if not var_22_3 or table.empty(var_22_3) then
		if_set_visible(var_22_0, "n_story_locked", true)
		if_set_visible(var_22_0, "n_period", false)
		if_set_visible(var_22_0, "noti", false)
	else
		local var_22_4 = var_22_3.unlock
		local var_22_5, var_22_6, var_22_7 = SubStoryUtil:getEventTimeInfo(var_22_3)
		local var_22_8 = var_22_3.background_home
		local var_22_9 = SubstoryUIUtil:getBGInfo(var_22_8, var_22_3.id)
		local var_22_10 = T("ui_dungeon_story_period", timeToStringDef({
			preceding_with_zeros = true,
			start_time = var_22_6,
			end_time = var_22_7
		}))
		local var_22_11
		
		if var_22_3.hide_date then
			var_22_10 = ""
			var_22_11 = ""
		end
		
		local var_22_12 = "img/_dungeon_menu_story_f.png"
		
		if var_22_9.bg and var_22_9.bg.img then
			var_22_12 = var_22_9.bg.img .. ".png"
		elseif var_22_9.portrait and var_22_9.portrait.portrait then
			local var_22_13 = DB("character", var_22_9.portrait.portrait, "ch_attribute")
			
			if var_22_13 then
				var_22_12 = "img/_dungeon_menu_story_" .. string.sub(var_22_13, 1, 1) .. ".png"
			end
		end
		
		local var_22_14 = (var_22_9.logo_title or {}).txt
		local var_22_15 = (var_22_9.logo or {}).img
		local var_22_16 = (var_22_9.logo or {}).offset_x
		local var_22_17 = (var_22_9.logo or {}).offset_y
		local var_22_18
		
		if var_22_5 == SUBSTORY_CONSTANTS.STATE_READY then
			var_22_18 = 76.5
		end
		
		local var_22_19 = GlobalSubstoryManager:isNotiAblum()
		local var_22_20 = var_22_1:getChildByName("bg")
		
		if var_22_12 then
			if_set_sprite(var_22_20, nil, var_22_12)
		end
		
		local var_22_21 = var_22_1:getChildByName("n_period")
		
		if var_22_10 then
			if_set(var_22_21, "txt_period", var_22_10)
		end
		
		if var_22_11 then
			if_set(var_22_21, "txt_period_title", var_22_11)
		end
		
		if_set_visible(var_22_1, "noti", var_22_19)
		
		if var_22_14 then
			if_set(var_22_1, "logo_title", T(var_22_14))
		end
		
		local var_22_22
		
		if var_22_15 then
			local var_22_23 = var_22_1:getChildByName("locale_logo_img")
			
			var_22_22 = cc.Sprite:create(var_22_15 .. ".png")
			
			if get_cocos_refid(var_22_23) and get_cocos_refid(var_22_22) then
				var_22_23:getParent():addChild(var_22_22)
				var_22_22:setPosition(var_22_23:getPosition())
				var_22_22:setPositionX(var_22_22:getPositionX() + (var_22_16 or 0))
				var_22_22:setPositionY(var_22_22:getPositionY() + (var_22_17 or 0))
			end
		end
		
		local var_22_24 = var_22_9.portrait
		local var_22_25
		
		if var_22_24 and var_22_5 ~= SUBSTORY_CONSTANTS.STATE_READY then
			var_22_25 = UIUtil:getPortraitAni(var_22_24.portrait, {
				layer = arg_22_0.vars.wnd
			})
			
			var_22_25:setPosition(220, -50)
			var_22_25:setScale(0.75)
			
			if var_22_9.face then
				UIUtil:setPortraitFace(var_22_25, (var_22_9.face or {}).c)
			end
			
			if var_22_9 and var_22_9.portrait and var_22_9.portrait.portrait_flip then
				var_22_25:setScaleX(var_22_25:getScaleX() * -1)
			end
			
			var_22_1:getChildByName("clip"):addChild(var_22_25)
		end
		
		if not (var_22_4 == nil or UnlockSystem:isUnlockSystem(var_22_4)) then
			var_22_18 = 76.5
			
			if get_cocos_refid(var_22_22) then
				var_22_22:setColor(cc.c3b(97, 97, 97))
			end
			
			if_set_visible(var_22_1, "n_period", false)
			if_set_visible(var_22_1, "n_core_reward", false)
			var_22_1:getChildByName("clip"):setColor(cc.c3b(97, 97, 97))
			
			if get_cocos_refid(var_22_25) then
				var_22_25:setColor(cc.c3b(97, 97, 97))
			end
		else
			local var_22_26 = var_22_9.menu_color or {}
			
			var_22_20:setColor(cc.c3b(var_22_26.r or 255, var_22_26.g or 255, var_22_26.b or 255))
			if_set_visible(var_22_1, "n_custom_frame", var_22_3 and (var_22_3.custom_type == "y" or var_22_3.custom_type == "frame"))
			
			if var_22_3 and var_22_3.custom_type and var_22_3.custom_type == "y" then
				local var_22_27 = var_22_1:getChildByName("n_core_reward")
				local var_22_28 = {
					hero_multiply_scale = 0.85,
					artifact_multiply_scale = 0.6,
					multiply_scale = 0.8
				}
				
				SubstoryManager:setCoreRewardIcons(var_22_27, var_22_3.id, var_22_28)
			end
		end
		
		if var_22_18 then
			var_22_0:setOpacity(var_22_18)
		end
	end
end

function SubStoryHome.updateTheaterItem(arg_23_0)
	if not arg_23_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_23_0.vars.wnd) then
		return 
	end
	
	local var_23_0 = arg_23_0.vars.wnd:getChildByName("n_theater")
	local var_23_1 = var_23_0:getChildByName("n_contents")
	local var_23_2 = MoonlightTheaterManager:getTotalRedNoti() or MoonlightTheaterManager:isWorldCastingRewardExist() or MoonlightTheaterManager:getTotalSeasonReceivableRewardExist()
	
	if_set_visible(var_23_1, "noti", var_23_2)
	
	local var_23_3 = UNLOCK_ID.MOONLIGHT_THEATER
	local var_23_4 = UnlockSystem:isUnlockSystem(var_23_3)
	
	if not var_23_4 then
		var_23_1:setColor(cc.c3b(97, 97, 97))
	end
	
	if var_23_3 then
		UnlockSystem:setUnlockUIState(var_23_0, "btn_theater", var_23_3, {
			icon_name = "n_locked",
			no_opacity = true
		})
	end
	
	local var_23_5 = MoonlightTheaterManager:getFreeIconNoti()
	local var_23_6 = MoonlightTheaterManager:getNewIconNoti()
	local var_23_7 = var_23_1:getChildByName("n_badge")
	
	if get_cocos_refid(var_23_7) then
		if_set_visible(var_23_7, nil, var_23_5 or var_23_6)
		
		if var_23_6 then
			if_set_sprite(var_23_7, "new", "img/shop_icon_new.png")
		elseif var_23_5 then
			if_set_sprite(var_23_7, "new", "img/shop_icon_free_c.png")
		end
	end
	
	if_set_visible(var_23_1, "txt_enter", var_23_4)
end

function SubStoryHome.updateEpilogueItem(arg_24_0)
	if not arg_24_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_24_0.vars.wnd) then
		return 
	end
	
	local var_24_0 = arg_24_0.vars.wnd:getChildByName("n_epilogue")
	local var_24_1 = var_24_0:getChildByName("n_contents")
	local var_24_2 = "vewrda"
	local var_24_3 = false
	
	if_set_visible(var_24_1, "noti", var_24_3)
	
	local var_24_4 = SubStoryUtil:getSubstoryDB(var_24_2)
	local var_24_5 = var_24_4.unlock == nil or UnlockSystem:isUnlockSystem(var_24_4.unlock)
	
	if not var_24_5 then
		var_24_1:setColor(cc.c3b(97, 97, 97))
	end
	
	if var_24_4.unlock then
		UnlockSystem:setUnlockUIState(var_24_0, "btn_epilogue", var_24_4.unlock, {
			icon_name = "n_locked",
			no_opacity = true
		})
	end
	
	if_set_visible(var_24_1, "txt_enter", var_24_5)
end

function SubStoryHome.updateDlcItem(arg_25_0)
	if not arg_25_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_25_0.vars.wnd) then
		return 
	end
	
	local var_25_0 = arg_25_0.vars.wnd:getChildByName("n_library")
	local var_25_1 = var_25_0:getChildByName("n_contents")
	local var_25_2 = "vcudlc"
	local var_25_3 = false
	
	if_set_visible(var_25_1, "noti", var_25_3)
	
	local var_25_4 = SubStoryUtil:getSubstoryDB(var_25_2)
	local var_25_5 = var_25_4.unlock == nil or UnlockSystem:isUnlockSystem(var_25_4.unlock)
	
	if not var_25_5 then
		var_25_1:setColor(cc.c3b(97, 97, 97))
	end
	
	if var_25_4.unlock then
		UnlockSystem:setUnlockUIState(var_25_0, "btn_ibrary", var_25_4.unlock, {
			icon_name = "n_locked",
			no_opacity = true
		})
	end
	
	if_set_visible(var_25_1, "n_badge", SubstoryManager:isNewDlc())
	if_set_visible(var_25_1, "txt_enter", var_25_5)
end

function SubStoryHome.updateSystemSubstoryList(arg_26_0)
	local var_26_0 = UnlockSystem:isUnlockSystem(UNLOCK_ID.SYSTEM_SUBSTORY)
	local var_26_1 = Account:getConfigData("sss_new_chr")
	local var_26_2 = SubstorySystemStory:isNewCharNoti()
	
	UnlockSystem:setUnlockUIState(arg_26_0.vars.wnd, "btn_go_herostory", UNLOCK_ID.SYSTEM_SUBSTORY, {
		icon_name = "n_locked",
		no_opacity = true
	})
	
	if var_26_2 then
		local var_26_3 = arg_26_0.vars.wnd:getChildByName("n_newstory")
		
		var_26_3:setVisible(true)
		
		local var_26_4 = var_26_3:getChildByName("n_face_icon")
		local var_26_5 = DB("character", var_26_2, "name")
		
		if_set(var_26_3, "disc", T("systemsubstory_newchar_info", {
			name = T(var_26_5)
		}))
		UIUtil:getRewardIcon(nil, var_26_2, {
			no_popup = true,
			no_grade = true,
			parent = var_26_4
		})
		SAVE:setTempConfigData("sss_new_chr", var_26_2)
	end
end
