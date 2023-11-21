ShopChapterUtil = ShopChapterUtil or {}

function ShopChapterUtil.onMsgHandler(arg_1_0, arg_1_1)
	local var_1_0 = WorldMapManager:getController()
	
	if var_1_0:getMode() == "WORLD" then
		return 
	end
	
	WorldMapManager:getNavigator():openNavi("SHOP")
	
	local var_1_1 = var_1_0:getMapKey()
	
	if EpisodeForce:getForceID() then
		if arg_1_1 then
			ShopChapterForcePopup:show()
		else
			ShopChapterForce:clear()
			WorldMapManager:getNavigator():openNavi("SHOP")
			ShopChapterForce:show()
		end
	elseif arg_1_1 then
		ShopChapterPopup:show()
	else
		ShopChapter:clear()
		WorldMapManager:getNavigator():openNavi("SHOP")
		ShopChapter:show()
	end
end

function ShopChapterUtil.getShopChatperObj(arg_2_0, arg_2_1)
	if EpisodeForce:getForceID() then
		if arg_2_1 then
			return ShopChapterForcePopup
		else
			return ShopChapterForce
		end
	elseif arg_2_1 then
		return ShopChapterPopup
	else
		return ShopChapter
	end
end

function ShopChapterUtil.onUpdateUI(arg_3_0)
	local var_3_0 = arg_3_0:getShopChatperObj(true)
	
	if var_3_0 and var_3_0.ItemListRefresh then
		var_3_0:ItemListRefresh()
	end
	
	local var_3_1 = arg_3_0:getShopChatperObj()
	
	if var_3_1 and var_3_1.ItemListRefresh then
		var_3_1:ItemListRefresh()
	end
end

ShopChapterCommon = ShopChapterCommon or {}

copy_functions(ShopCommon, ShopChapterCommon)
copy_functions(ScrollView, ShopChapterCommon)

function MsgHandler.market_episode(arg_4_0)
	Account:setChapterShopEpisodeItems(arg_4_0.worldmap_world_id, arg_4_0.list)
	ShopChapterUtil:onMsgHandler(arg_4_0.popup)
end

function HANDLER.mapshop_unlock_popup(arg_5_0, arg_5_1)
	if arg_5_1 == "btn_ok" then
		Dialog:close("mapshop_unlock_popup")
	elseif arg_5_1 == "btn_close" then
		Dialog:close("mapshop_unlock_popup")
	end
end

function ShopChapterCommon.query(arg_6_0)
	local var_6_0 = WorldMapManager:getController():getWorldIDByMapKey()
	local var_6_1 = Account:getChapterShopItemsByWorldID(var_6_0)
	
	if table.count(var_6_1) <= 0 then
		query("market_episode", {
			worldmap_world_id = var_6_0
		})
	else
		ShopChapterUtil:onMsgHandler()
	end
end

function ShopChapterCommon.clear(arg_7_0)
	arg_7_0.vars = {}
end

function ShopChapterCommon.close(arg_8_0)
	if not arg_8_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_8_0.vars.unlock_popup_wnd) then
		return 
	end
	
	UIAction:Add(SEQ(LOG(FADE_OUT(200)), REMOVE()), arg_8_0.vars.unlock_popup_wnd, "block")
	BackButtonManager:pop("Dialog.mapshop_unlock_popup")
end

function ShopChapterCommon.isShow(arg_9_0)
	if not arg_9_0.vars then
		return false
	end
	
	return get_cocos_refid(arg_9_0.vars.wnd) ~= false
end

function ShopChapterCommon.show(arg_10_0)
	arg_10_0.vars = {}
	
	local var_10_0 = WorldMapManager:getNavigator():getWnd()
	local var_10_1 = var_10_0:getChildByName("n_shop")
	
	arg_10_0.vars.wnd = var_10_1
	arg_10_0.vars.parents = var_10_0
	arg_10_0.vars.scrollview = var_10_1:getChildByName("scrollview")
	
	local var_10_2 = WorldMapManager:getController()
	local var_10_3 = var_10_2:getMapKey()
	local var_10_4 = var_10_2:getWorldIDByMapKey()
	local var_10_5 = DB("level_world_3_chapter", var_10_3, "shop_cp_category")
	
	arg_10_0.vars.category_id = var_10_5
	
	if not var_10_5 then
		return 
	end
	
	local var_10_6 = DBT("shop_chapter_category", arg_10_0.vars.category_id, {
		"id",
		"npc",
		"material",
		"name",
		"desc",
		"unlock_stage",
		"unlock_stage_desc",
		"unlock_quest",
		"pre_quest_story",
		"clear_quest_story",
		"condition_state",
		"core_reward1",
		"core_reward2",
		"force_id",
		"unlock_story"
	})
	
	arg_10_0.vars.category_db = var_10_6
	
	local var_10_7 = Account:getItemCount(var_10_6.material)
	local var_10_8 = DB("item_material", var_10_6.material, "name")
	
	arg_10_0:initScrollView(arg_10_0.vars.scrollview, 666, 150)
	if_set(var_10_1, "t_shop", T(var_10_6.name))
	if_set(var_10_1, "t_disc", T(var_10_6.desc))
	if_set(var_10_1, "title_contr_point", T(var_10_8))
	
	arg_10_0.vars.world_id = var_10_4
	arg_10_0.vars.chapter_id = var_10_3
	
	local var_10_9 = Account:getChapterShopItems(arg_10_0.vars.world_id, arg_10_0.vars.chapter_id)
	local var_10_10 = var_10_9 or {}
	
	arg_10_0.vars.list = var_10_10
	arg_10_0.vars.DB = {}
	
	for iter_10_0, iter_10_1 in pairs(var_10_10) do
		arg_10_0.vars.DB[iter_10_1.id] = iter_10_1
	end
	
	local var_10_11 = var_10_3 == "wrd_rehas"
	
	if_set_visible(var_10_1, "n_btn_change", not var_10_11)
	if_set_visible(var_10_1, "n_tap_catalyst", var_10_11)
	
	if var_10_11 then
		arg_10_0:epilogue_story(var_10_1, var_10_9)
	end
	
	arg_10_0:loadData()
	arg_10_0:initUI(var_10_1)
	arg_10_0:updateUI()
	arg_10_0:createPortrait()
	
	local var_10_12 = arg_10_0:isBtnNoti()
	
	arg_10_0:updatePopupBtnNoti(var_10_12)
	GrowthGuideNavigator:proc()
	
	return var_10_1
end

function ShopChapterCommon.epilogue_story(arg_11_0, arg_11_1, arg_11_2)
	if arg_11_0.vars.chapter_id ~= "wrd_rehas" then
		return 
	end
	
	arg_11_0.vars.epilogue_tap = {}
	arg_11_0.vars.epilogue_tap.rare = arg_11_1:getChildByName("tap_rare_catalyst")
	arg_11_0.vars.epilogue_tap.legendary = arg_11_1:getChildByName("tap_legendary_catalyst")
	
	for iter_11_0, iter_11_1 in pairs(arg_11_2 or {}) do
		if iter_11_1.type and iter_11_1.world_material_grade == nil then
			local var_11_0 = DB("item_material", iter_11_1.type, "grade")
			
			iter_11_1.world_material_grade = tostring(var_11_0 or 0)
		end
	end
	
	arg_11_0.vars.epilogue_origianl_data = arg_11_2
	
	arg_11_0:epilogue_set_mode("rare", {
		no_scroll_create = true
	})
end

function ShopChapterCommon.get_epilogue_items(arg_12_0)
	if arg_12_0.vars.chapter_id ~= "wrd_rehas" then
		return {}
	end
	
	local var_12_0 = {}
	local var_12_1 = {}
	
	var_12_1["3"] = "rare"
	var_12_1["5"] = "legendary"
	
	for iter_12_0, iter_12_1 in pairs(arg_12_0.vars.epilogue_origianl_data or {}) do
		print(iter_12_1.world_material_grade, "?", arg_12_0.vars.epilogue_tap_mode)
		
		if var_12_1[iter_12_1.world_material_grade] == arg_12_0.vars.epilogue_tap_mode then
			table.insert(var_12_0, iter_12_1)
		end
	end
	
	return var_12_0
end

function ShopChapterCommon.epilogue_set_mode(arg_13_0, arg_13_1, arg_13_2)
	arg_13_2 = arg_13_2 or {}
	
	if arg_13_0.vars.chapter_id ~= "wrd_rehas" then
		return 
	end
	
	if arg_13_1 == arg_13_0.vars.epilogue_tap_mode then
		return 
	end
	
	arg_13_0.vars.epilogue_tap_mode = arg_13_1
	
	for iter_13_0, iter_13_1 in pairs(arg_13_0.vars.epilogue_tap) do
		if get_cocos_refid(iter_13_1) then
			iter_13_1:setVisible(arg_13_0.vars.epilogue_tap_mode == iter_13_0)
		end
	end
	
	arg_13_0.vars.list = arg_13_0:get_epilogue_items()
	
	if not arg_13_2.no_scroll_create then
		arg_13_0:createScrollViewItems(arg_13_0.vars.list)
		arg_13_0:updateTimeLimitedItems(os.time())
		arg_13_0:jumpToPercent(0)
	end
end

function ShopChapterCommon.loadData(arg_14_0)
end

function ShopChapterCommon.initUI(arg_15_0, arg_15_1)
end

function ShopChapterCommon.getCategoryDB(arg_16_0)
	return arg_16_0.vars.category_db
end

function ShopChapterCommon.updateBalloon(arg_17_0, arg_17_1, arg_17_2)
	if not arg_17_0.vars then
		return 
	end
	
	if not arg_17_0.vars.wnd then
		return 
	end
	
	if not get_cocos_refid(arg_17_0.vars.wnd) then
		return 
	end
	
	local var_17_0 = WorldMapManager:getWorldMapUI():getWnd()
	
	if not get_cocos_refid(var_17_0) then
		return 
	end
	
	local var_17_1 = var_17_0:getChildByName("n_npc_portrait")
	
	if get_cocos_refid(var_17_1) and arg_17_0.vars.category_id then
		local var_17_2 = var_17_1:getChildByName("talk_bg")
		
		if get_cocos_refid(var_17_2) then
			var_17_2:setScale(0)
			UIUtil:playNPCSoundAndTextRandomly("shop_chapter(" .. arg_17_0.vars.category_id .. ")" .. arg_17_1, var_17_2, "disc", 300, "shop_chapter(" .. arg_17_0.vars.category_id .. ")" .. (arg_17_2 or ".idle"), arg_17_0.vars.portrait)
		end
	end
end

function ShopChapterCommon.createPortrait(arg_18_0)
	if arg_18_0.vars.category_db.npc then
		arg_18_0:addChapterPortrait("n_npc_portrait")
		
		if arg_18_0.vars.category_db.unlock_story and not Account:isClearedChapterShopStory(arg_18_0.vars.category_id) then
			arg_18_0:updateBalloon(".before", ".before")
		elseif arg_18_0.vars.category_db.unlock_quest and not Account:isStartChapterShopQuest(arg_18_0.vars.category_id) then
			arg_18_0:updateBalloon(".before", ".before")
		elseif arg_18_0.vars.category_db.unlock_quest and Account:isPlayingChapterShopQuest(arg_18_0.vars.category_id) then
			arg_18_0:updateBalloon(".ing", ".ing")
		else
			arg_18_0:updateBalloon(".enter")
		end
	end
end

function ShopChapterCommon.addChapterPortrait(arg_19_0, arg_19_1)
	local var_19_0 = WorldMapManager:getWorldMapUI():getWnd()
	local var_19_1 = UIUtil:getPortraitAni(arg_19_0.vars.category_db.npc, {
		layer = var_19_0
	})
	local var_19_2 = var_19_0:getChildByName(arg_19_1)
	
	if not get_cocos_refid(var_19_2) then
		return 
	end
	
	local var_19_3 = var_19_2:getChildByName("n_portrait")
	
	if var_19_1 then
		var_19_3:removeAllChildren()
		var_19_3:addChild(var_19_1)
		var_19_1:setPositionY(var_19_1:getPositionY() - 250)
		var_19_1:setScale(0.9)
	end
	
	arg_19_0.vars.portrait = var_19_1
end

function ShopChapterCommon.showBuyPopup(arg_20_0, arg_20_1)
	if not arg_20_0:isUnlockCredit(arg_20_1.item) then
		local var_20_0 = DB("shop_chapter_force_credit_grade", arg_20_1.item.credit_grade, "name")
		local var_20_1 = T("credit_error_msg", {
			credit_type = T(var_20_0)
		})
		
		balloon_message_with_sound_raw_text(var_20_1)
		
		return 
	end
	
	SoundEngine:play("event:/ui/ok")
	
	if arg_20_1.item.sold_out then
		balloon_message_with_sound("sold_out")
		
		return 
	end
	
	local var_20_2
	local var_20_3
	
	if arg_20_1.item.limit_cooltime then
		var_20_3 = arg_20_0:getRestCoolTime(arg_20_1.item.id)
	else
		var_20_2 = arg_20_0:getRestTime(arg_20_1.item.id)
	end
	
	if var_20_2 and var_20_2 > 0 or var_20_3 and var_20_3 > 0 then
		if arg_20_1.item.limit_period == "only_once" then
			balloon_message_with_sound("sold_out")
		else
			balloon_message_with_sound("notyet_buy")
		end
	else
		arg_20_0:ShowConfirmDialog(arg_20_1.item)
		GrowthGuideNavigator:proc()
	end
end

function ShopChapterCommon.updateUI(arg_21_0)
	if not arg_21_0:isShow() then
		return 
	end
	
	local var_21_0 = Account:getItemCount(arg_21_0.vars.category_db.material)
	
	if_set(arg_21_0.vars.wnd, "count_cp", T("mission_base_cpshop_cp_value", {
		value = var_21_0
	}))
end

function ShopChapterCommon.updatePopupBtnNoti(arg_22_0)
	if not arg_22_0:isShow() then
		return false
	end
	
	local var_22_0 = arg_22_0.vars.wnd:getChildByName("n_btn_change")
	local var_22_1 = arg_22_0:isBtnNoti()
	
	if_set_visible(var_22_0, "icon_noti", var_22_1)
end

function ShopChapterCommon.isBtnNoti(arg_23_0)
	local var_23_0 = false
	local var_23_1 = WorldMapManager:getController():getWorldIDByMapKey()
	local var_23_2 = DB("level_world_1_world", tostring(var_23_1), "key_continent")
	local var_23_3 = WorldMapUtil:getContinentListByContinentKey(var_23_2)
	
	for iter_23_0, iter_23_1 in pairs(var_23_3) do
		if ShopChapter:hasEffectNoti(iter_23_1.key_normal) then
			var_23_0 = true
			
			break
		end
	end
	
	return var_23_0
end

function ShopChapterCommon.isShow(arg_24_0)
	if not arg_24_0.vars then
		return false
	end
	
	if not arg_24_0.vars.wnd then
		return false
	end
	
	if not get_cocos_refid(arg_24_0.vars.wnd) then
		return false
	end
	
	return arg_24_0.vars.wnd:isVisible()
end

function ShopChapterCommon.updateTimeLimitedItems(arg_25_0)
	if not arg_25_0:isShow() then
		return 
	end
	
	local var_25_0 = os.time()
	
	for iter_25_0, iter_25_1 in pairs(arg_25_0.ScrollViewItems) do
		if get_cocos_refid(iter_25_1.control) then
			local var_25_1
			local var_25_2
			
			if iter_25_1.item.limit_cooltime then
				var_25_2 = arg_25_0:getRestCoolTime(iter_25_1.item.id, var_25_0)
				
				if_set_visible(iter_25_1.control, "n_time", var_25_2 and var_25_2 > 0)
			else
				var_25_1 = arg_25_0:getRestTime(iter_25_1.item.id, var_25_0)
				
				if_set_visible(iter_25_1.control, "n_time", var_25_1 and var_25_1 > 0)
			end
			
			local var_25_3 = iter_25_1.control:getChildByName("btn_go")
			
			if var_25_1 and var_25_1 > 0 or var_25_2 and var_25_2 > 0 then
				if_set_opacity(iter_25_1.control, "n_base", 76.5)
				if_set_opacity(iter_25_1.control, "n_cost", 76.5)
				if_set_opacity(iter_25_1.control, "n_right", 76.5)
				if_set_opacity(iter_25_1.control, "n_btn_counter", 76.5)
				
				iter_25_1.control.soldout = true
			else
				if_set_opacity(iter_25_1.control, "n_right", 255)
				if_set_opacity(iter_25_1.control, "n_btn_counter", 255)
			end
			
			local var_25_4, var_25_5, var_25_6 = arg_25_0:GetRestCount(iter_25_1.item, var_25_0)
			
			if var_25_1 then
				if var_25_1 > 0 and var_25_6 ~= "only_once" then
					if_set(iter_25_1.control, "txt_time", T("time_reset_shop", {
						time = sec_to_string(var_25_1)
					}))
					if_set_visible(iter_25_1.control, "grow", true)
				else
					if_set_visible(iter_25_1.control, "txt_time", false)
					if_set_visible(iter_25_1.control, "grow", false)
				end
			end
			
			if var_25_2 then
				if var_25_2 > 0 and var_25_6 ~= "only_once" then
					if_set(iter_25_1.control, "txt_time", T("time_reset_shop", {
						time = sec_to_string(var_25_2)
					}))
					if_set_visible(iter_25_1.control, "grow", true)
				else
					if_set_visible(iter_25_1.control, "txt_time", false)
					if_set_visible(iter_25_1.control, "grow", false)
				end
			end
			
			if var_25_5 then
				if_set(iter_25_1.control, "txt_count", var_25_4 .. "/" .. var_25_5)
				
				if var_25_6 then
					if_set(iter_25_1.control, "txt_count_info", T("shop_period_" .. var_25_6, "shop_period_" .. var_25_6 .. "(#count#)", {
						count = var_25_5
					}))
				else
					if_set(iter_25_1.control, "txt_count_info", "")
				end
				
				set_scale_fit_width(iter_25_1.control:getChildByName("txt_count_info"), 255 + (VIEW_WIDTH - 1280))
				
				iter_25_1.item.rest_count = var_25_4
			else
				if_set_visible(iter_25_1.control, "txt_count_info", false)
			end
			
			if iter_25_1.item.token == "offer_wall" then
				if_set_opacity(iter_25_1.control, "n_btn_counter", 0)
				if_set(iter_25_1.control, "txt_buy", T("ui_offer_wall_get_free"))
				iter_25_1.control:getChildByName("txt_buy"):setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
			end
		end
	end
	
	arg_25_0:updateUI()
end

function ShopChapterCommon.getScrollViewItem(arg_26_0, arg_26_1)
	arg_26_1.is_limit_button = arg_26_1 and arg_26_1.limit_count
	
	local var_26_0 = arg_26_0:makeShopItem(arg_26_1, "wnd/shop_card.csb")
	local var_26_1 = Account:getChapterShopItems(arg_26_0.vars.world_id, arg_26_0.vars.chapter_id)[arg_26_0.vars.category_id]
	
	arg_26_0:updateScrollViewItemInfo(var_26_0, arg_26_1)
	
	var_26_0.guide_tag = arg_26_1.id
	
	return var_26_0
end

function ShopChapterCommon.updateScrollViewItems(arg_27_0)
	for iter_27_0, iter_27_1 in pairs(arg_27_0.ScrollViewItems) do
		arg_27_0:updateScrollViewItemInfo(iter_27_1.control, iter_27_1.item)
	end
end

function ShopChapterCommon.updateScrollViewItemInfo(arg_28_0, arg_28_1, arg_28_2)
	local var_28_0 = arg_28_0:isUnlockItem(arg_28_2)
	local var_28_1 = arg_28_0:isUnlockCredit(arg_28_2)
	local var_28_2 = 255
	
	if_set_visible(arg_28_1, "n_mapshop_lock", not var_28_0 or not var_28_1)
	
	if not var_28_0 or not var_28_1 then
		var_28_2 = 76.5
		
		if not var_28_0 then
		elseif not var_28_1 then
			local var_28_3 = DB("shop_chapter_force_credit_grade", arg_28_2.credit_grade, "name")
			
			if_set(arg_28_1, "t_lock", T("credit_error_msg", {
				credit_type = T(var_28_3)
			}))
		end
	end
	
	if_set_opacity(arg_28_1, "n_base", var_28_2)
	if_set_opacity(arg_28_1, "btn_go", var_28_2)
	if_set_opacity(arg_28_1, "n_cost", var_28_2)
	if_set_opacity(arg_28_1, "n_counter", var_28_2)
end

function ShopChapterCommon.isUnlockItem(arg_29_0, arg_29_1)
	return true
end

function ShopChapterCommon.isUnlockCredit(arg_30_0, arg_30_1)
	if not arg_30_1.credit_grade then
		return true
	end
end

function ShopChapterCommon.getUnlockData(arg_31_0)
	if not arg_31_0.unlock_data then
		arg_31_0.unlock_data = {}
		
		for iter_31_0 = 1, 999 do
			local var_31_0, var_31_1, var_31_2 = DBN("shop_chapter", iter_31_0, {
				"id",
				"category",
				"unlock_enter"
			})
			
			if not var_31_0 then
				break
			end
			
			if var_31_1 and not arg_31_0.unlock_data[var_31_1] then
				arg_31_0.unlock_data[var_31_1] = {}
			end
			
			table.insert(arg_31_0.unlock_data[var_31_1], {
				id = var_31_0,
				unlock_enter = var_31_2
			})
		end
	end
	
	return arg_31_0.unlock_data
end

function ShopChapterCommon.hasEffectNoti(arg_32_0, arg_32_1)
	local var_32_0 = arg_32_0:getUnlockData()
	local var_32_1 = WorldMapManager:getController()
	
	arg_32_1 = arg_32_1 or var_32_1:getMapKey()
	
	local var_32_2 = DB("level_world_3_chapter", arg_32_1, {
		"shop_cp_category"
	})
	
	if not var_32_2 then
		return false
	end
	
	local var_32_3, var_32_4, var_32_5 = DB("shop_chapter_category", var_32_2, {
		"unlock_stage",
		"unlock_quest",
		"unlock_story"
	})
	
	if var_32_3 and var_32_4 and not Account:isStartChapterShopQuest(var_32_2) and Account:isMapCleared(var_32_3) then
		return true
	end
	
	if var_32_3 and var_32_5 and Account:isMapCleared(var_32_3) and not Account:isStartChapterShopQuest(var_32_2) then
		return true
	end
	
	if var_32_4 and Account:isPlayingChapterShopQuest(var_32_2) then
		local var_32_6 = Account:getChapterShopQuests()
		
		for iter_32_0, iter_32_1 in pairs(var_32_6) do
			if string.split(iter_32_0, "_")[1] == var_32_2 and iter_32_1.state == CHAPTER_SHOP_QUEST.CLEAR then
				return true
			end
		end
	end
	
	return false
end

function ShopChapterCommon.enterBattle(arg_33_0, arg_33_1)
	BattleReady:show({
		enter_id = arg_33_1.enter_stage,
		callback = ShopChapter
	})
end

function ShopChapterCommon.showPresentWnd(arg_34_0, arg_34_1, arg_34_2, arg_34_3, arg_34_4)
end

function ShopChapterCommon.onBtnGo(arg_35_0, arg_35_1)
	if arg_35_1.state >= 2 then
	elseif arg_35_1.state == 1 then
		query("get_reward_shop_chapter_quest", {
			contents_id = arg_35_1.contents_id
		})
	elseif arg_35_1.state == 0 then
		if arg_35_1.give_code then
			arg_35_0:showPresentWnd(nil, arg_35_1.contents_id, arg_35_1.give_code, arg_35_1.give_count)
		elseif arg_35_1.enter_stage then
			arg_35_0:enterBattle(arg_35_1)
		elseif arg_35_1.btn_move then
			local var_35_0 = WorldMapManager:getNavigator()
			
			if var_35_0 and var_35_0:isOpenNavi() then
				var_35_0:backNavi()
			end
			
			movetoPath(arg_35_1.btn_move)
		end
	end
end

function ShopChapterCommon.reqBuy(arg_36_0, arg_36_1, arg_36_2)
	query("buy", {
		shop = "chapter",
		item = arg_36_1.id,
		type = arg_36_1.type,
		multiply = arg_36_2 or 1
	})
end

function ShopChapterCommon.setLockUI(arg_37_0)
	local var_37_0 = arg_37_0.vars.wnd:getChildByName("n_quest_info")
	
	arg_37_0:setCoreRewardItems(var_37_0)
	if_set(var_37_0, "txt_info", T(arg_37_0.vars.category_db.unlock_stage_desc))
end

function ShopChapterCommon.setCoreRewardItems(arg_38_0, arg_38_1)
	local function var_38_0(arg_39_0, arg_39_1)
		if not arg_39_0 then
			return 
		end
		
		local var_39_0
		
		for iter_39_0, iter_39_1 in pairs(arg_38_0.vars.list) do
			if iter_39_1.id == arg_39_0 then
				var_39_0 = iter_39_1
				
				break
			end
		end
		
		if var_39_0 then
			local var_39_1 = UIUtil:getRewardIcon(var_39_0.value, var_39_0.type, {
				equip_stat = (var_39_0.data or {}).op,
				grade = (var_39_0.data or {}).g,
				set_fx = (var_39_0.data or {}).f,
				count = var_39_0.value,
				parent = arg_39_1
			})
		end
	end
	
	var_38_0(arg_38_0.vars.category_db.core_reward1, arg_38_1:getChildByName("n_item1"))
	var_38_0(arg_38_0.vars.category_db.core_reward2, arg_38_1:getChildByName("n_item2"))
end

function ShopChapterCommon.playStoryQuest(arg_40_0)
end

function MsgHandler.start_chapter_shop_unlock_quest(arg_41_0)
	if arg_41_0.info then
		Account:setShopChapter(arg_41_0.info)
	end
	
	if ShopChapterPopup:isShow() then
		ShopChapterPopupChapterList:onUpdateSelectedChapter()
	else
		ShopChapter:show()
	end
	
	BackPlayManager:forceStopPlay("chapter_shop")
	ConditionContentsManager:getChapterShopQuest():initConditionListner()
	WorldMapManager:getNavigator():updateLocalStoreNoti()
end

function MsgHandler.end_chapter_shop_unlock_story(arg_42_0)
	if arg_42_0.info then
		Account:setShopChapter(arg_42_0.info)
	end
	
	if ShopChapterPopup:isShow() then
		ShopChapterPopupChapterList:onUpdateSelectedChapter()
	else
		ShopChapter:show()
	end
	
	WorldMapManager:getNavigator():updateLocalStoreNoti()
end

function MsgHandler.end_chapter_shop_unlock_quest(arg_43_0)
	if arg_43_0.info then
		Account:setShopChapter(arg_43_0.info)
	end
	
	if ShopChapterPopup:isShow() then
		ShopChapterPopupChapterList:onUpdateSelectedChapter()
	else
		ShopChapter:show()
	end
	
	WorldMapManager:getNavigator():updateLocalStoreNoti()
end

function MsgHandler.give_shop_chapter_quest(arg_44_0)
	Account:addReward(arg_44_0.result)
	Account:setChapterShopQuest(arg_44_0.contents_id, arg_44_0.info)
	
	if arg_44_0.conditions and arg_44_0.conditions.clear_conditions then
		for iter_44_0, iter_44_1 in pairs(arg_44_0.conditions.clear_conditions) do
			ConditionContentsManager:setConditionGroupData(iter_44_1)
		end
		
		for iter_44_2, iter_44_3 in pairs(arg_44_0.conditions.update_conditions or {}) do
			ConditionContentsManager:setConditionGroupData(iter_44_3)
		end
	end
	
	ShopChapter:ItemListRefresh()
	ShopChapterForceDetail:ItemListRefresh()
	
	local var_44_0 = ShopChapterUtil:getShopChatperObj(true)
	
	if var_44_0 then
		var_44_0:ItemListRefresh()
	end
	
	balloon_message_with_sound("success_give_classchange_quest")
	WorldMapManager:getNavigator():updateLocalStoreNoti()
	ShopChapter:updateUI()
	ShopChapterForce:updateUI()
	
	local var_44_1 = ShopChapterUtil:getShopChatperObj(true)
	
	if var_44_1 then
		var_44_1:updateUI()
	end
end

ShopChapter = ShopChapter or {}

copy_functions(ShopChapterCommon, ShopChapter)

function ShopChapter.initUI(arg_45_0, arg_45_1)
	local var_45_0 = true
	local var_45_1 = true
	local var_45_2 = true
	local var_45_3 = arg_45_0.vars.category_db
	local var_45_4 = not var_45_3.unlock_stage or Account:isMapCleared(var_45_3.unlock_stage)
	
	if var_45_3.unlock_quest and var_45_3.condition_state then
		var_45_1 = var_45_4 and Account:isClearedChapterShopQuest(arg_45_0.vars.category_id)
	end
	
	if var_45_3.unlock_story then
		var_45_2 = var_45_4 and Account:isClearedChapterShopStory(arg_45_0.vars.category_id)
	end
	
	local var_45_5 = var_45_1 and var_45_2
	
	if_set_visible(arg_45_1, "n_shop_items", var_45_5)
	if_set_visible(arg_45_1, "n_chapter_shop_quest", var_45_4 and var_45_3.unlock_quest and not var_45_1)
	if_set_visible(arg_45_1, "n_quest_info", not var_45_4)
	
	if not var_45_4 then
		arg_45_0:setLockUI()
	end
	
	if var_45_4 and var_45_3.unlock_quest and not var_45_1 then
		if get_cocos_refid(arg_45_0.vars.listView) then
			arg_45_0.vars.listView:setDataSource({})
		end
		
		if Account:isStartChapterShopQuest(arg_45_0.vars.category_id) then
			arg_45_0:createQuestListView()
			
			local var_45_6 = arg_45_1:getChildByName("n_reward_info")
			
			var_45_6:setVisible(true)
			arg_45_0:setCoreRewardItems(var_45_6)
		end
		
		arg_45_0:showQuestStoryPopup()
		
		return 
	elseif var_45_4 and var_45_3.unlock_story and not var_45_2 then
		arg_45_0:playUnlockStoryOnly()
	end
	
	if var_45_5 then
		arg_45_0:createScrollViewItems(arg_45_0.vars.list)
		arg_45_0:updateTimeLimitedItems(os.time())
		arg_45_0:jumpToPercent(0)
	end
end

function ShopChapter.updateItem(arg_46_0, arg_46_1, arg_46_2)
	local var_46_0 = Account:getChapterShopQuest(arg_46_2.id).state or 0
	local var_46_1 = arg_46_1:getChildByName("btn_cshop_go")
	local var_46_2 = 255
	
	if var_46_0 == 2 then
		var_46_2 = 150
	end
	
	local var_46_3 = {
		give = arg_46_2.give_code,
		battle = arg_46_2.enter_stage,
		active_text = T("condition_battle_text")
	}
	
	UIUtil:setColorRewardButtonState(var_46_0, arg_46_1, var_46_1, {
		give = arg_46_2.give_code,
		battle = arg_46_2.enter_stage
	})
	
	if arg_46_2.mission_icon_1 then
		local var_46_4 = 1.5
		local var_46_5 = DB("character", arg_46_2.mission_icon_1, "id")
		local var_46_6 = UIUtil:getRewardIcon(nil, arg_46_2.mission_icon_1, {
			no_popup = true,
			hero_multiply_scale = 1.15,
			no_grade = true,
			parent = arg_46_1:getChildByName("mob_icon")
		})
		
		if_set_opacity(var_46_6, nil, var_46_2)
		if_set_visible(arg_46_1, "spr_icon", false)
	elseif arg_46_2.mission_icon_2 then
		arg_46_1:getChildByName("mob_icon"):removeAllChildren()
		if_set_visible(arg_46_1, "spr_icon", true)
		if_set_sprite(arg_46_1, "spr_icon", arg_46_2.mission_icon_2 .. ".png")
	end
	
	if var_46_0 == 2 then
		if_set_opacity(arg_46_1, "n_normal", var_46_2)
		if_set_opacity(arg_46_1, "n_right", var_46_2)
	end
	
	local var_46_7 = arg_46_2.condition_group_db
	local var_46_8 = ConditionContentsManager:getChapterShopQuest():getScore(arg_46_2.id)
	local var_46_9 = totable(arg_46_2.value).count
	local var_46_10 = arg_46_1:getChildByName("n_left")
	
	if_set(var_46_10, "txt_title", T(arg_46_2.category_name))
	if_set(var_46_10, "txt_sub_title", T(arg_46_2.mission_name))
	set_scale_fit_width_node(var_46_10:getChildByName("txt_sub_title"), var_46_10:getChildByName("progress"))
	if_set(var_46_10, "txt_name", T(arg_46_2.mission_desc))
	
	if DEBUG.DEBUG_MAP_ID then
		if_set(var_46_10, "txt_name", T(arg_46_2.id))
	else
		if_set(var_46_10, "txt_name", T(arg_46_2.mission_desc))
	end
	
	if (arg_46_2.id == "jer_quest_04" or arg_46_2.id == "mel_quest_04") and var_46_0 >= CHAPTER_SHOP_QUEST.CLEAR then
		var_46_8 = var_46_9
	end
	
	if_set_percent(var_46_10, "progress", var_46_8 / var_46_9)
	if_set(var_46_10, "txt_progress", comma_value(math.min(var_46_8, var_46_9)) .. " / " .. comma_value(var_46_9))
	
	if var_46_0 == 0 and not arg_46_2.btn_move and not arg_46_2.give_code and not arg_46_2.enter_stage then
		if_set_visible(arg_46_1, "btn_cshop_go", false)
	end
	
	var_46_1.parent = arg_46_0
	var_46_1.contents_id = arg_46_2.id
	var_46_1.state = var_46_0
	var_46_1.give_code = arg_46_2.give_code
	var_46_1.give_count = arg_46_2.give_count
	var_46_1.btn_move = arg_46_2.btn_move
	var_46_1.enter_stage = arg_46_2.enter_stage
	var_46_1.enter_condition_state = arg_46_2.enter_condition_state
	
	var_46_1:getChildByName("noti"):setVisible(arg_46_2.give_code and var_46_0 == 0 and Account:getPropertyCount(arg_46_2.give_code) >= arg_46_2.give_count)
end

function ShopChapter.showPresentWnd(arg_47_0, arg_47_1, arg_47_2, arg_47_3, arg_47_4)
	local var_47_0 = Dialog:open("wnd/destiny_present", arg_47_0)
	
	arg_47_1 = arg_47_1 or SceneManager:getRunningPopupScene()
	
	arg_47_1:addChild(var_47_0)
	UIUtil:getRewardIcon(arg_47_4, arg_47_3, {
		show_name = true,
		detail = true,
		parent = var_47_0:getChildByName("n_item")
	})
	UIUtil:getRewardIcon(nil, arg_47_3, {
		no_frame = true,
		scale = 0.6,
		parent = var_47_0:getChildByName("n_pay_token")
	})
	if_set(var_47_0, "txt_price", comma_value(arg_47_4))
	if_set(var_47_0, "txt_item_hoiding", T("text_item_have_count", {
		count = comma_value(Account:getPropertyCount(arg_47_3) or 0)
	}))
	if_set(var_47_0, "txt_title", T("ui_shop_chapter_present_title"))
	if_set(var_47_0, "txt_disc", T("ui_shop_chapter_present_desc"))
	
	local var_47_1 = var_47_0:getChildByName("btn_present")
	
	var_47_1.parent = arg_47_0
	var_47_1.give_code = arg_47_3
	var_47_1.give_count = arg_47_4
	var_47_1.contents_id = arg_47_2
end

function ShopChapter.giveItem(arg_48_0, arg_48_1)
	if not arg_48_1 or not arg_48_1.give_code or not arg_48_1.give_code then
		return Log.e("destiny", "giveItem.null")
	end
	
	if Account:getPropertyCount(arg_48_1.give_code) < arg_48_1.give_count then
		balloon_message_with_sound("lack_give_currencies_count")
		
		return 
	end
	
	ConditionContentsManager:setIgnoreQuery(true)
	ConditionContentsManager:dispatch("chaptershop.give", {
		give = arg_48_1.contents_id
	})
	ConditionContentsManager:setIgnoreQuery(false)
	
	local var_48_0 = ConditionContentsManager:getUpdateConditions()
	
	ConditionContentsManager:resetAllAdd()
	
	if var_48_0 then
		query("give_shop_chapter_quest", {
			contents_id = arg_48_1.contents_id,
			update_condition_groups = json.encode(var_48_0)
		})
	end
	
	Dialog:close("destiny_present")
end

function ShopChapter.playEndStory(arg_49_0, arg_49_1, arg_49_2)
	start_new_story(nil, arg_49_1, {
		force = true,
		on_finish = function()
			query("end_chapter_shop_unlock_quest", {
				category_id = arg_49_2
			})
		end
	})
end

function ShopChapter.playStoryQuest(arg_51_0)
	if not arg_51_0.vars then
		return 
	end
	
	if not arg_51_0.vars.category_db then
		return 
	end
	
	local var_51_0 = arg_51_0.vars.category_db.pre_quest_story
	
	if not var_51_0 then
		return 
	end
	
	start_new_story(nil, var_51_0, {
		force = true,
		on_finish = function()
			query("start_chapter_shop_unlock_quest", {
				category_id = arg_51_0.vars.category_id
			})
		end
	})
end

function ShopChapter.playUnlockStoryOnly(arg_53_0)
	if not arg_53_0.vars then
		return 
	end
	
	if not arg_53_0.vars.category_db then
		return 
	end
	
	local var_53_0 = arg_53_0.vars.category_db.unlock_story
	
	if not var_53_0 then
		return 
	end
	
	start_new_story(nil, var_53_0, {
		force = true,
		on_finish = function()
			query("end_chapter_shop_unlock_story", {
				category_id = arg_53_0.vars.category_id
			})
		end
	})
end

function ShopChapter.initQuestData(arg_55_0)
	local var_55_0 = arg_55_0.vars.category_db.unlock_quest
	
	arg_55_0.vars.quest_datas = {}
	
	for iter_55_0 = 1, 99 do
		local var_55_1 = var_55_0 .. string.format("_%02d", iter_55_0)
		local var_55_2 = DBT("shop_chapter_quest", var_55_1, {
			"id",
			"category",
			"category_name",
			"mission_name",
			"mission_icon_1",
			"mission_icon_2",
			"icon",
			"mission_desc",
			"sort",
			"give_code",
			"give_count",
			"enter_stage",
			"reward_id1",
			"reward_count1",
			"condition",
			"value",
			"btn_move"
		})
		
		if not var_55_2.id then
			break
		end
		
		table.insert(arg_55_0.vars.quest_datas, var_55_2)
		table.sort(arg_55_0.vars.quest_datas, function(arg_56_0, arg_56_1)
			return arg_56_0.sort < arg_56_1.sort
		end)
	end
end

function ShopChapter.createQuestListView(arg_57_0)
	arg_57_0:initQuestData()
	
	if not get_cocos_refid(arg_57_0.vars.listView) then
		local var_57_0 = arg_57_0.vars.wnd:getChildByName("n_chapter_shop_quest"):getChildByName("listview")
		local var_57_1 = load_control("wnd/mission_cshop_quest_item.csb")
		
		arg_57_0.vars.listView = ItemListView_v2:bindControl(var_57_0)
		
		if var_57_0.STRETCH_INFO then
			local var_57_2 = var_57_0:getContentSize()
			
			resetControlPosAndSize(var_57_1, var_57_2.width, var_57_0.STRETCH_INFO.width_prev)
		end
		
		local var_57_3 = {
			onUpdate = function(arg_58_0, arg_58_1, arg_58_2, arg_58_3)
				arg_57_0:updateItem(arg_58_1, arg_58_3, arg_58_2)
				
				return arg_58_3.skill_id
			end
		}
		
		arg_57_0.vars.listView:setRenderer(var_57_1, var_57_3)
	end
	
	arg_57_0.vars.listView:removeAllChildren()
	arg_57_0.vars.listView:setDataSource(arg_57_0.vars.quest_datas)
	ConditionContentsManager:checkState(CONTENTS_TYPE.CHAPTER_SHOP_QUEST, {
		db_data = arg_57_0.vars.quest_datas
	})
	arg_57_0.vars.listView:jumpToTop()
end

function ShopChapter.ItemListRefresh(arg_59_0)
	if not arg_59_0:isShow() then
		return 
	end
	
	if not get_cocos_refid(arg_59_0.vars.listView) then
		return 
	end
	
	arg_59_0.vars.listView:refresh()
end

function ShopChapter.showQuestStoryPopup(arg_60_0)
	if not Account:isStartChapterShopQuest(arg_60_0.vars.category_id) then
		local var_60_0 = SceneManager:getRunningPopupScene()
		local var_60_1 = Dialog:open("wnd/mapshop_unlock_popup", arg_60_0, {
			back_func = function()
				arg_60_0:close()
				arg_60_0:playStoryQuest()
			end
		})
		
		arg_60_0.vars.unlock_popup_wnd = var_60_1
		
		local var_60_2 = var_60_1:getChildByName("n_eff")
		
		if var_60_2 then
			EffectManager:Play({
				pivot_x = 0,
				fn = "ui_reward_popup_eff.cfx",
				pivot_y = 0,
				pivot_z = 99998,
				layer = var_60_2
			}, var_60_1, "block")
		end
		
		var_60_0:addChild(var_60_1)
		if_set(var_60_1, "txt_disc", T("shopchapter_quest_desc"))
		if_set(var_60_1, "label", T("btn_shopchapter_quest"))
		if_set(var_60_1, "txt_title", T("shopchapter_quest_title"))
		
		local var_60_3 = var_60_1:getChildByName("btn_ok")
		
		var_60_3:setVisible(true)
		
		var_60_3.parent = arg_60_0
		
		return true
	elseif Account:isPlayingChapterShopQuest(arg_60_0.vars.category_id) and ConditionContentsState:isClearedByStateID(arg_60_0.vars.category_db.condition_state) then
		arg_60_0:playEndStory(arg_60_0.vars.category_db.clear_quest_story, arg_60_0.vars.category_id)
		
		return true
	end
	
	if false then
	end
	
	return false
end

function MsgHandler.get_reward_shop_chapter_quest(arg_62_0)
	if arg_62_0.quest_doc and arg_62_0.contents_id then
		Account:setChapterShopQuest(arg_62_0.contents_id, arg_62_0.quest_doc)
	end
	
	local var_62_0 = {
		desc = T("quest_shop_chapter_reward_desc")
	}
	
	Account:addReward(arg_62_0.rewards, {
		play_reward_data = var_62_0,
		handler = function()
			local var_63_0 = DB("shop_chapter_quest", arg_62_0.contents_id, {
				"category"
			})
			local var_63_1 = string.split(var_63_0, "_quest")[1]
			local var_63_2, var_63_3 = DB("shop_chapter_category", var_63_1, {
				"condition_state",
				"clear_quest_story"
			})
			
			if ConditionContentsState:isClearedByStateID(var_63_2) and var_63_3 then
				ShopChapter:playEndStory(var_63_3, var_63_1)
			end
		end
	})
	ShopChapter:ItemListRefresh()
	
	local var_62_1 = ShopChapterUtil:getShopChatperObj(true)
	
	if var_62_1 then
		var_62_1:ItemListRefresh()
	end
	
	WorldMapManager:getNavigator():updateLocalStoreNoti()
end
