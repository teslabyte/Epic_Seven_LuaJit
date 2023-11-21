WorldMapEpisodeUtil = WorldMapEpisodeUtil or {}

function WorldMapEpisodeUtil.setEpCardUI(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	local var_1_0
	
	if arg_1_2.world_id then
		var_1_0 = arg_1_1:getChildByName("n_open_ep")
	else
		var_1_0 = arg_1_1:getChildByName("n_unopen_ep")
	end
	
	if_set_visible(arg_1_1, "n_open_ep", arg_1_2.world_id)
	if_set_visible(arg_1_1, "n_unopen_ep", arg_1_2.world_id == nil)
	
	if arg_1_2.world_id then
		if_set_sprite(var_1_0, "sp_ep_bg", "episode/" .. arg_1_2.ep_img)
	end
	
	if_set(var_1_0, "txt_ep", T(arg_1_2.ep_num))
	if_set(var_1_0, "txt_title", T(arg_1_2.ep_name))
end

WorldMapEpisodeList = WorldMapEpisodeList or {}

copy_functions(ScrollView, WorldMapEpisodeList)

function HANDLER_BEFORE.episode_base(arg_2_0, arg_2_1, arg_2_2)
	if arg_2_1 == "btn_block" then
		arg_2_0.touch_tick = systick()
	end
end

function HANDLER.episode_base(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	if arg_3_1 == "btn_close" then
		WorldMapEpisodeList:close()
		
		return 
	end
	
	if arg_3_1 == "btn_block" and systick() - to_n(arg_3_0.touch_tick) < 80 then
		WorldMapEpisodeList:close()
	end
	
	if arg_3_1 == "btn_episode_go" then
		WorldMapEpisodeList:close()
		WorldMapManager:moveLastEpisode()
	end
end

function HANDLER.episode_card(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	if arg_4_1 == "btn_ep" and arg_4_0.info then
		WorldMapEpisodeList:setVisibleScrollView(false)
		WorldMapEpisodeDetail:show(arg_4_0.info)
		
		return 
	elseif arg_4_1 == "btn_ep" and arg_4_0.info == nil then
		Dialog:msgBox(T("mission_notyet"))
	end
end

function HANDLER.episode_list(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	if arg_5_1 == "btn_top_back" then
		WorldMapEpisodeDetail:close()
		
		return 
	end
	
	if arg_5_1 == "btn_right" then
		local var_5_0 = WorldMapEpisodeDetail:getFocusIdx()
		
		WorldMapEpisodeDetail:moveSelectAction(var_5_0 + 1, "right")
		
		return 
	end
	
	if arg_5_1 == "btn_left" then
		local var_5_1 = WorldMapEpisodeDetail:getFocusIdx()
		
		WorldMapEpisodeDetail:moveSelectAction(var_5_1 - 1, "left")
		
		return 
	end
	
	if arg_5_1 == "btn_move" then
		local var_5_2 = arg_5_0.movePath
		
		if var_5_2 then
			WorldMapEpisodeList:close(true)
			WorldMapEpisodeDetail:close(true)
			movetoPath(var_5_2)
		else
			Dialog:msgBox(T("mission_notyet"))
		end
	end
end

function WorldMapEpisodeList.show(arg_6_0, arg_6_1)
	if BackPlayManager:isRunning() then
		local var_6_0, var_6_1 = BackPlayUtil:checkAdventureInBackPlay()
		
		if not var_6_0 then
			balloon_message_with_sound(var_6_1)
			
			return 
		end
	end
	
	arg_6_1 = arg_6_1 or SceneManager:getRunningPopupScene()
	arg_6_0.vars = {}
	arg_6_0.vars.wnd = Dialog:open("wnd/episode_base", arg_6_0)
	
	arg_6_0.vars.wnd:setOpacity(0)
	UIAction:Add(LOG(FADE_IN(200)), arg_6_0.vars.wnd, "block")
	arg_6_1:addChild(arg_6_0.vars.wnd)
	
	arg_6_0.vars.last_open_ep_idx = 1
	arg_6_0.vars.datas = {}
	
	for iter_6_0 = 1, 999 do
		local var_6_2, var_6_3, var_6_4, var_6_5, var_6_6, var_6_7 = DBN("ep_select", iter_6_0, {
			"id",
			"world_id",
			"ep_num",
			"ep_name",
			"ep_story",
			"ep_img"
		})
		
		if not var_6_2 then
			break
		end
		
		local var_6_8 = #arg_6_0.vars.datas + 1
		local var_6_9, var_6_10 = DB("level_world_1_world", tostring(var_6_3), {
			"name",
			"key_continent"
		})
		
		table.insert(arg_6_0.vars.datas, {
			idx = var_6_8,
			id = var_6_2,
			world_id = var_6_3,
			ep_num = var_6_4,
			ep_name = var_6_5,
			ep_story = var_6_6,
			ep_img = var_6_7,
			world_name = var_6_9,
			key_continent = var_6_10
		})
		
		if var_6_3 then
			arg_6_0.vars.last_open_ep_idx = var_6_8
		end
	end
	
	local var_6_11 = arg_6_0.vars.wnd:getChildByName("ep_scrollview")
	
	arg_6_0.vars.scrollview = var_6_11
	arg_6_0.vars.scrollview.STRETCH_INFO = nil
	
	arg_6_0:initScrollView(arg_6_0.vars.scrollview, 365, 530, {
		force_horizontal = true
	})
	arg_6_0:createScrollViewItems(arg_6_0.vars.datas)
	var_6_11:getInnerContainer():setContentSize(var_6_11:getInnerContainerSize().width + 200, var_6_11:getInnerContainerSize().height)
	arg_6_0:slideEffect()
	if_set_visible(arg_6_0.vars.wnd, "n_move", true)
end

function WorldMapEpisodeList.isShow(arg_7_0)
	if arg_7_0.vars and get_cocos_refid(arg_7_0.vars.wnd) then
		return true
	end
	
	return false
end

function WorldMapEpisodeList.getDatas(arg_8_0)
	return arg_8_0.vars.datas
end

function WorldMapEpisodeList.getDataByIdx(arg_9_0, arg_9_1)
	return arg_9_0.vars.datas[arg_9_1]
end

function WorldMapEpisodeList.getScrollViewItem(arg_10_0, arg_10_1)
	local var_10_0 = load_control("wnd/episode_card.csb")
	local var_10_1 = var_10_0:getChildByName("n_base")
	
	var_10_1:setScale(0.85)
	WorldMapEpisodeUtil:setEpCardUI(var_10_0, arg_10_1)
	
	var_10_0:getChildByName("btn_ep").info = arg_10_1
	
	local var_10_2 = ConditionContentsManager:getQuestMissions()
	
	if arg_10_1.key_continent and var_10_2:isActiveQuestInWorld(arg_10_1.key_continent) then
		local var_10_3 = var_10_0:getChildByName("n_noti_quest")
		local var_10_4 = UIUtil:makeNavigatorAni({
			scale = 0.6
		})
		
		var_10_4:setPositionY(-90)
		var_10_3:addChild(var_10_4)
		var_10_4:setName("spr_navi")
	end
	
	if_set_visible(var_10_1, "img_noti_new", NewChapterNavigator:isNew({
		continent = arg_10_1.key_continent
	}))
	
	return var_10_0
end

function WorldMapEpisodeList.getLastOpenEpIdx(arg_11_0)
	return arg_11_0.vars.last_open_ep_idx
end

function WorldMapEpisodeList.close(arg_12_0, arg_12_1)
	if arg_12_1 then
		Dialog:close("episode_base")
	else
		UIAction:Add(SEQ(LOG(FADE_OUT(200)), REMOVE()), arg_12_0.vars.wnd, "block")
		BackButtonManager:pop({
			check_id = "Dialog.episode_base",
			dlg = arg_12_0.vars.wnd
		})
	end
end

function WorldMapEpisodeList.slideEffect(arg_13_0)
	for iter_13_0, iter_13_1 in pairs(arg_13_0.ScrollViewItems) do
		local var_13_0 = iter_13_1.control:getPositionX() + 100
		local var_13_1 = iter_13_1.control:getPositionY()
		local var_13_2 = VIEW_WIDTH + var_13_0
		
		iter_13_1.control:setPositionX(var_13_2)
		UIAction:Add(SEQ(DELAY(to_n(0) + iter_13_0 * 80), SPAWN(LOG(MOVE_TO(250, var_13_0, var_13_1), 200), RLOG(OPACITY(250, 0, 1)))), iter_13_1.control, "block")
	end
end

function WorldMapEpisodeList.setVisibleScrollView(arg_14_0, arg_14_1)
	if arg_14_1 then
		UIAction:Add(LOG(FADE_IN(200)), arg_14_0.vars.scrollview, "block")
	else
		UIAction:Add(LOG(FADE_OUT(200)), arg_14_0.vars.scrollview, "block")
	end
end

WorldMapEpisodeDetail = WorldMapEpisodeDetail or {}

function WorldMapEpisodeDetail.show(arg_15_0, arg_15_1)
	local var_15_0 = SceneManager:getRunningPopupScene()
	
	arg_15_0.vars = {}
	arg_15_0.vars.wnd = Dialog:open("wnd/episode_list", arg_15_0)
	
	var_15_0:addChild(arg_15_0.vars.wnd)
	arg_15_0:createListView(arg_15_1.key_continent)
	
	local var_15_1 = WorldMapEpisodeList:getDatas()
	
	arg_15_0.vars.cards = {}
	
	local var_15_2 = arg_15_0.vars.wnd:getChildByName("n_list")
	
	arg_15_0.vars.original_list_pos = {
		x = var_15_2:getPositionX(),
		y = var_15_2:getPositionY()
	}
	
	for iter_15_0 = 1, 99 do
		if not var_15_1[iter_15_0] then
			break
		end
		
		local var_15_3 = load_control("wnd/episode_card.csb")
		local var_15_4 = arg_15_0.vars.wnd:getChildByName("card_" .. iter_15_0)
		
		var_15_4:addChild(var_15_3)
		WorldMapEpisodeUtil:setEpCardUI(var_15_4, var_15_1[iter_15_0], true)
		
		local var_15_5 = var_15_3:getContentSize()
		
		var_15_3:setPosition(-var_15_5.width / 2, -var_15_5.height / 2)
		var_15_3:setName("ep_card")
		
		var_15_4.info = var_15_1[iter_15_0]
		
		table.insert(arg_15_0.vars.cards, {
			n_card = var_15_4,
			idx = iter_15_0,
			data = var_15_1[iter_15_0],
			origial_pos_x = var_15_4:getPositionX()
		})
		if_set_visible(var_15_3, "img_noti_new", NewChapterNavigator:isNew({
			type = "episode",
			continent = var_15_4.info.key_continent
		}))
	end
	
	arg_15_0:moveSelectAction(arg_15_1.idx, "scale")
	BackButtonManager:pop({
		check_id = "Dialog.episode_list",
		dlg = arg_15_0.vars.wnd
	})
	BackButtonManager:push({
		check_id = "episode_detail",
		back_func = function()
			arg_15_0:close()
		end,
		dlg = arg_15_0.vars.wnd
	})
	arg_15_0.vars.wnd:setOpacity(0)
	UIAction:Add(LOG(FADE_IN(200)), arg_15_0.vars.wnd, "block")
end

function WorldMapEpisodeDetail.moveSelectAction(arg_17_0, arg_17_1, arg_17_2)
	local var_17_0 = arg_17_0.vars.wnd:getChildByName("n_list")
	local var_17_1 = WorldMapEpisodeList:getLastOpenEpIdx()
	
	if arg_17_2 == "right" and var_17_1 < arg_17_1 then
		return 
	elseif arg_17_2 == "left" and arg_17_1 < 1 then
		return 
	end
	
	if arg_17_2 == "right" then
		UIAction:Add(LOG(SPAWN(MOVE_BY(300, -431, 0))), var_17_0, "block")
	elseif arg_17_2 == "left" then
		UIAction:Add(LOG(SPAWN(MOVE_BY(300, 431, 0))), var_17_0, "block")
	elseif arg_17_2 == "scale" then
		var_17_0:setPositionX(arg_17_0.vars.original_list_pos.x - (arg_17_1 - 1) * 431)
	end
	
	for iter_17_0, iter_17_1 in pairs(arg_17_0.vars.cards) do
		if iter_17_0 < arg_17_1 then
			arg_17_0.vars.cards[iter_17_0].n_card:setPositionX(arg_17_0.vars.cards[iter_17_0].origial_pos_x - 265)
			arg_17_0.vars.cards[iter_17_0].n_card:setScale(0.85)
			arg_17_0.vars.cards[iter_17_0].n_card:setVisible(true)
			arg_17_0.vars.cards[iter_17_0].n_card:setColor(cc.c3b(170, 170, 170))
			
			local var_17_2 = arg_17_0.vars.cards[iter_17_0].n_card:getChildByName("n_ep")
			local var_17_3 = arg_17_0.vars.cards[iter_17_0].n_card:getChildByName("n_title")
			
			var_17_2:setVisible(true)
			var_17_3:setVisible(true)
		elseif iter_17_0 == arg_17_1 then
			arg_17_0.vars.cards[iter_17_0].n_card:setPositionX(arg_17_0.vars.cards[iter_17_0].origial_pos_x)
			arg_17_0.vars.cards[iter_17_0].n_card:setScale(1)
			arg_17_0.vars.cards[iter_17_0].n_card:setOpacity(255)
			arg_17_0.vars.cards[iter_17_0].n_card:setVisible(true)
			arg_17_0.vars.cards[iter_17_0].n_card:setColor(cc.c3b(255, 255, 255))
			
			local var_17_4 = arg_17_0.vars.cards[iter_17_0].n_card:getChildByName("n_ep")
			local var_17_5 = arg_17_0.vars.cards[iter_17_0].n_card:getChildByName("n_title")
			
			var_17_4:setVisible(false)
			var_17_5:setVisible(false)
			
			if arg_17_2 == "scale" then
				UIAction:Add(LOG(SPAWN(FADE_IN(200), SCALE(200, 0.85, 1))), arg_17_0.vars.cards[iter_17_0].n_card, "block")
			end
		else
			arg_17_0.vars.cards[iter_17_0].n_card:setPositionX(arg_17_0.vars.cards[iter_17_0].origial_pos_x)
			arg_17_0.vars.cards[iter_17_0].n_card:setScale(0.85)
			arg_17_0.vars.cards[iter_17_0].n_card:setColor(cc.c3b(170, 170, 170))
			
			if var_17_1 < iter_17_0 then
				arg_17_0.vars.cards[iter_17_0].n_card:setVisible(false)
			end
			
			local var_17_6 = arg_17_0.vars.cards[iter_17_0].n_card:getChildByName("n_ep")
			local var_17_7 = arg_17_0.vars.cards[iter_17_0].n_card:getChildByName("n_title")
			
			var_17_6:setVisible(true)
			var_17_7:setVisible(true)
		end
	end
	
	local var_17_8 = arg_17_0.vars.wnd:getChildByName("btn_left")
	local var_17_9 = arg_17_0.vars.wnd:getChildByName("btn_right")
	
	var_17_8:setVisible(arg_17_1 ~= 1)
	var_17_9:setVisible(arg_17_1 ~= var_17_1)
	
	arg_17_0.vars.focus_idx = arg_17_1
	
	arg_17_0:updateUI()
end

function WorldMapEpisodeDetail.updateUI(arg_18_0)
	local var_18_0 = WorldMapEpisodeList:getDatas()
	
	WorldMapEpisodeDetail:setListData(var_18_0[arg_18_0.vars.focus_idx].key_continent)
	
	local var_18_1 = arg_18_0.vars.wnd:getChildByName("n_right_list")
	
	if_set(var_18_1, "txt_area", T(var_18_0[arg_18_0.vars.focus_idx].world_name))
	if_set(var_18_1, "txt_ep", T(var_18_0[arg_18_0.vars.focus_idx].ep_num))
	
	local var_18_2 = arg_18_0.vars.wnd:getChildByName("n_ep_info")
	
	if_set(var_18_2, "txt_title", T(var_18_0[arg_18_0.vars.focus_idx].ep_name))
	if_set(var_18_2, "txt_disc", T(var_18_0[arg_18_0.vars.focus_idx].ep_story))
end

function WorldMapEpisodeDetail.getFocusIdx(arg_19_0)
	return arg_19_0.vars.focus_idx
end

function WorldMapEpisodeDetail.createListView(arg_20_0, arg_20_1)
	local var_20_0 = arg_20_0.vars.wnd:getChildByName("listview_area")
	local var_20_1 = load_control("wnd/episode_area_bar.csb")
	
	arg_20_0.vars.listView = ItemListView_v2:bindControl(var_20_0)
	
	local var_20_2 = {
		onUpdate = function(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
			WorldMapEpisodeDetail:updateListItem(arg_21_1, arg_21_3, arg_21_2)
			
			return arg_21_3.skill_id
		end
	}
	
	arg_20_0.vars.listView:setListViewCascadeEnabled(true)
	arg_20_0.vars.listView:setRenderer(var_20_1, var_20_2)
	arg_20_0.vars.listView:removeAllChildren()
end

function WorldMapEpisodeDetail.setListData(arg_22_0, arg_22_1)
	arg_22_0.vars.list_datas = WorldMapUtil:getContinentListByContinentKey(arg_22_1)
	
	table.sort(arg_22_0.vars.list_datas, function(arg_23_0, arg_23_1)
		return (tonumber(arg_23_0.ep_sort) or 999) < (tonumber(arg_23_1.ep_sort) or 999)
	end)
	
	arg_22_0.vars.no_star = arg_22_1 == "vewrda"
	
	arg_22_0.vars.listView:removeAllChildren()
	arg_22_0.vars.listView:setDataSource(arg_22_0.vars.list_datas)
	arg_22_0.vars.listView:jumpToTop()
end

function WorldMapEpisodeDetail.close(arg_24_0, arg_24_1)
	if arg_24_1 then
		Dialog:close("episode_list")
	else
		local var_24_0 = arg_24_0.vars.wnd:getChildByName("n_right_list")
		
		UIAction:Add(SEQ(LOG(FADE_OUT(0))), var_24_0, "block")
		var_24_0:setVisible(false)
		arg_24_0.vars.listView:setVisible(false)
		UIAction:Add(SEQ(LOG(FADE_OUT(300)), REMOVE()), arg_24_0.vars.wnd, "block")
		WorldMapEpisodeList:setVisibleScrollView(true)
		BackButtonManager:pop({
			check_id = "episode_detail",
			dlg = arg_24_0.vars.wnd
		})
	end
end

function WorldMapEpisodeDetail.refresh(arg_25_0)
	arg_25_0.vars.listView:refresh()
end

function WorldMapEpisodeDetail.updateListItem(arg_26_0, arg_26_1, arg_26_2, arg_26_3)
	local var_26_0 = T(arg_26_2.name)
	local var_26_1 = string.split(var_26_0, ".")
	
	if_set(arg_26_1, "txt_number", var_26_1[1])
	
	local var_26_2 = arg_26_1:findChildByName("txt_area")
	local var_26_3 = arg_26_0.vars.no_star
	local var_26_4, var_26_5 = DB("level_world_3_chapter", arg_26_2.key_normal, {
		"id",
		"world_id"
	})
	
	if not var_26_4 or not var_26_5 then
		var_26_3 = true
	end
	
	if var_26_3 then
		var_26_2 = arg_26_1:findChildByName("txt_area_none_star")
	end
	
	if_set(var_26_2, nil, string.trim(var_26_1[2]))
	set_scale_fit_width_multi_line(var_26_2, 2, 60)
	
	arg_26_1:getChildByName("btn_move").movePath = arg_26_2.ep_select_path
	
	if ConditionContentsManager:getQuestMissions():isActiveQuestInChapter(arg_26_2.key_normal) then
		local var_26_6 = arg_26_1:getChildByName("n_noti_quest")
		
		var_26_6:removeAllChildren()
		
		local var_26_7 = UIUtil:makeNavigatorSprite()
		
		var_26_7:setRotation(270)
		var_26_6:addChild(var_26_7)
		var_26_7:setScale(0.9)
		var_26_7:setPositionX(20)
	end
	
	local var_26_8 = arg_26_1:getChildByName("img_noti_new")
	
	if get_cocos_refid(var_26_8) then
		if_set_visible(var_26_8, nil, NewChapterNavigator:isNew({
			chapter = arg_26_2.key_normal
		}))
		var_26_8:bringToFront()
	end
	
	if_set_visible(arg_26_1, "txt_area_none_star", var_26_3)
	if_set_visible(arg_26_1, "txt_area", not var_26_3)
	if_set_visible(arg_26_1, "label_star_num", not var_26_3)
	if_set_visible(arg_26_1, "img_star", not var_26_3)
	
	if not arg_26_0.vars.no_star then
		StarMissionUI:updateEpisodeDetailUI(arg_26_2.key_normal, arg_26_1)
	end
end
