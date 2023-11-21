function HANDLER.dungeon_story_bar(arg_1_0, arg_1_1)
	local var_1_0 = getParentWindow(arg_1_0)
	
	if arg_1_1 == "btn_go" or arg_1_1 == "btn_closing_soon" or arg_1_1 == "btn_pre" then
		SubstoryManager:queryEnter(var_1_0.info.id)
		
		return 
	end
end

SubStoryListMain = SubStoryListMain or {}

function SubStoryListMain.show(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0.vars = {}
	arg_2_0.vars.wnd = load_dlg("story_sub_main", true, "wnd")
	
	arg_2_0.vars.wnd:setPositionX(arg_2_1:getContentSize().width / 2)
	arg_2_1:addChild(arg_2_0.vars.wnd)
	
	local function var_2_0()
		SubStoryHome:close()
	end
	
	TopBarNew:createFromPopup(T("substory_title"), arg_2_0.vars.wnd, function()
		SubStoryEntrance:setMode("HOME", {
			skip_fade_in = true
		})
	end, nil, "infosubs")
	
	local var_2_1 = arg_2_0.vars.wnd:getChildByName("n_substory_bg")
	
	arg_2_0.vars.substory_list = SubStoryUtil:getStoryList(true)
	arg_2_0.vars.scrollview = arg_2_1:getChildByName("story_scrollview")
	
	if get_cocos_refid(arg_2_1) then
		SubStoryList:initScrollView(arg_2_0.vars.scrollview, 350, 180)
		SubStoryList:createScrollViewItems(arg_2_0.vars.substory_list)
	end
	
	local var_2_2
	local var_2_3 = table.empty(arg_2_0.vars.substory_list)
	
	if var_2_3 then
		var_2_2 = SubstoryUIUtil:getBackground(nil, "default")
	elseif arg_2_0.vars.substory_list[1] and arg_2_0.vars.substory_list[1].unlock and not UnlockSystem:isUnlockSystem(arg_2_0.vars.substory_list[1].unlock) then
		var_2_2 = SubstoryUIUtil:getBackground(nil, "default")
	else
		local var_2_4 = arg_2_0.vars.substory_list[1].background_battle
		
		var_2_2 = SubstoryUIUtil:getBackground(arg_2_0.vars.substory_list[1].id, var_2_4)
	end
	
	if_set_visible(arg_2_0.vars.wnd, "n_info", var_2_3)
	
	if not var_2_2 then
		Log.e("SubStoryList.show", "no_bg")
	end
	
	var_2_2:setPositionX(var_2_2:getPositionX() + VIEW_BASE_LEFT)
	var_2_1:addChild(var_2_2)
	
	local var_2_5 = arg_2_0.vars.wnd:getChildByName("RIGHT")
	
	var_2_1:setOpacity(0)
	var_2_1:setPositionX(var_2_1:getPositionX() - 300)
	var_2_5:setPositionX(var_2_5:getPositionX() + 300)
	UIAction:Add(MOVE_BY(200, 300), var_2_1, "block")
	UIAction:Add(MOVE_BY(200, -300), var_2_5, "block")
	
	if var_2_3 == false then
		TutorialGuide:ifStartGuide("system_091")
	end
	
	SubStoryEntrance:setForceBackLobby(true)
end

function SubStoryListMain.getList(arg_5_0)
	if not arg_5_0.vars then
		return 
	end
	
	return arg_5_0.vars.substory_list
end

function SubStoryListMain.getWnd(arg_6_0)
	if not arg_6_0.vars then
		return 
	end
	
	return arg_6_0.vars.wnd
end

function SubStoryListMain.close(arg_7_0)
	UIAction:Add(SEQ(LOG(FADE_OUT(300)), REMOVE()), arg_7_0.vars.wnd, "block")
	TopBarNew:pop()
	BackButtonManager:pop("TopBarNew." .. T("substory_title"))
end

SubStoryList = SubStoryList or {}

copy_functions(ScrollView, SubStoryList)

function SubStoryList.getScrollViewItem(arg_8_0, arg_8_1)
	local var_8_0 = load_control("wnd/dungeon_story_bar.csb")
	
	var_8_0.parent = arg_8_0
	var_8_0.info = arg_8_1
	var_8_0.idx = #arg_8_0.ScrollViewItems + 1
	var_8_0.guide_tag = arg_8_1.id
	
	local var_8_1 = arg_8_1.start_time
	local var_8_2 = arg_8_1.end_time
	local var_8_3 = var_8_0:getChildByName("banner_pivot")
	local var_8_4 = SubstoryUIUtil:createBanner(arg_8_1.icon_enter, arg_8_1.banner_icon, arg_8_1.logo_position)
	
	if not var_8_4 and not PRODUCTION_MODE then
		if_set(var_8_0, "txt_progress", arg_8_1.id)
		var_8_0:getChildByName("txt_progress"):setPositionY(100)
		
		return var_8_0
	end
	
	var_8_3:addChild(var_8_4)
	
	local var_8_5 = SubStoryUtil:getEventState(var_8_1, var_8_2)
	local var_8_6 = true
	
	if arg_8_1.unlock then
		UnlockSystem:setUnlockUIState(var_8_0, "btn_locked", arg_8_1.unlock, {
			icon_name = "btn_locked",
			no_opacity = true
		})
		
		var_8_6 = UnlockSystem:isUnlockSystem(arg_8_1.unlock)
	end
	
	if not var_8_6 then
		if_set_color(var_8_0, "n_banner", cc.c3b(136, 136, 136))
	end
	
	if_set_visible(var_8_0, "n_time", var_8_5 == SUBSTORY_CONSTANTS.STATE_OPEN and arg_8_1.hide_date == nil)
	if_set_visible(var_8_0, "btn_go", var_8_5 == SUBSTORY_CONSTANTS.STATE_OPEN and var_8_6 == true)
	if_set_visible(var_8_0, "n_pre", var_8_5 == SUBSTORY_CONSTANTS.STATE_READY and arg_8_1.hide_date == nil)
	if_set_visible(var_8_0, "btn_pre", var_8_5 == SUBSTORY_CONSTANTS.STATE_READY and var_8_6 == true)
	if_set_visible(var_8_0, "n_time_closing_soon", var_8_5 == SUBSTORY_CONSTANTS.STATE_CLOSE_SOON and arg_8_1.hide_date == nil)
	if_set_visible(var_8_0, "btn_closing_soon", var_8_5 == SUBSTORY_CONSTANTS.STATE_CLOSE_SOON and var_8_6 == true)
	
	local var_8_7 = SUBSTORY_CONSTANTS.ONE_WEEK
	local var_8_8 = os.time()
	local var_8_9
	local var_8_10
	local var_8_11 = ""
	local var_8_12 = GlobalSubstoryManager:isContentsType(arg_8_1, GLOBAL_SUBSTORY_CONTENTS_TYPE.SUBSTORY_ALBUM) and SubstoryAlbum:canReceiveMissionReward(arg_8_1.id)
	
	if_set_visible(var_8_0, "img_noti", var_8_12)
	
	local var_8_13 = SubStoryUtil:isSystemSubStory(arg_8_1.id, arg_8_1)
	local var_8_14 = false
	
	if var_8_13 then
		var_8_14 = SubStoryUtil:isChangeSystemSubstory()
	end
	
	if_set_visible(var_8_0, "n_newstory_noti", var_8_13 and var_8_14)
	
	if arg_8_1.hide_date then
		if DEBUG.DEBUG_MAP_ID then
			var_8_9 = var_8_0:getChildByName("n_time")
			
			if_set_visible(var_8_9, nil, true)
			
			local var_8_15 = arg_8_1.id
			
			if arg_8_1.type == "system" then
				var_8_15 = var_8_15 .. "*"
			end
			
			if_set(var_8_9, "txt_progress", var_8_15)
		end
		
		return var_8_0
	end
	
	if SUBSTORY_CONSTANTS.STATE_OPEN == var_8_5 then
		var_8_9 = var_8_0:getChildByName("n_time")
		
		local var_8_16 = var_8_0:getChildByName("btn_go")
		local var_8_17 = var_8_2 - var_8_8
		
		var_8_11 = T("time_remain", {
			time = sec_to_string(var_8_17)
		})
	elseif SUBSTORY_CONSTANTS.STATE_CLOSE_SOON == var_8_5 then
		var_8_9 = var_8_0:getChildByName("n_time_closing_soon")
		
		local var_8_18 = var_8_0:getChildByName("btn_go")
		local var_8_19 = var_8_2 + var_8_7 - var_8_8
		
		var_8_11 = T("time_remain", {
			time = sec_to_string(var_8_19)
		})
	elseif SUBSTORY_CONSTANTS.STATE_CLOSE == var_8_5 then
		return var_8_0
	elseif SUBSTORY_CONSTANTS.STATE_READY == var_8_5 then
		if arg_8_1.show_preview == "y" and var_8_8 > var_8_1 - SUBSTORY_CONSTANTS.ONE_WEEK then
			var_8_9 = var_8_0:getChildByName("n_pre")
			
			local var_8_20 = var_8_1 - var_8_8
			
			var_8_11 = T("time_wait", {
				time = sec_to_string(var_8_20)
			})
			
			var_8_3:setColor(cc.c3b(170, 170, 170))
		else
			return var_8_0
		end
	end
	
	if DEBUG.DEBUG_MAP_ID then
		var_8_11 = arg_8_1.id .. "." .. var_8_11
	end
	
	if get_cocos_refid(var_8_9) then
		if_set(var_8_9, "txt_progress", var_8_11)
	end
	
	return var_8_0
end

function SubStoryList.onSelectScrollViewItem(arg_9_0, arg_9_1, arg_9_2)
end

function SubStoryList.getDungeonControlBySubstoryID(arg_10_0, arg_10_1)
	for iter_10_0, iter_10_1 in pairs(arg_10_0.ScrollViewItems) do
		if iter_10_1.item.id == arg_10_1 then
			if #arg_10_0.ScrollViewItems > 1 then
				arg_10_0:jumpToIndex(iter_10_0)
			end
			
			return iter_10_1.control
		end
	end
end

SubStoryUICheat = SubStoryUICheat or {}

function SubStoryUICheat.changeForceBI(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	if PRODUCTION_MODE then
		return 
	end
	
	local var_11_0 = SubStoryListMain:getList()
	
	var_11_0[arg_11_1].icon_enter = arg_11_2
	var_11_0[arg_11_1].banner_icon = arg_11_3
	
	SubStoryList:createScrollViewItems(var_11_0)
end

function SubStoryUICheat.setBIPosition(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	if PRODUCTION_MODE then
		return 
	end
	
	local var_12_0 = 1
	local var_12_1 = SubStoryListMain:getList()
	
	if type(arg_12_1) == "number" then
		var_12_0 = arg_12_1
	else
		for iter_12_0, iter_12_1 in pairs(var_12_1) do
			if string.starts(iter_12_1.id, arg_12_1) and string.ends(iter_12_1.background_summary, "_sum") then
				var_12_0 = iter_12_0
			end
		end
	end
	
	var_12_1[var_12_0].logo_position.x = arg_12_2
	var_12_1[var_12_0].logo_position.y = arg_12_3
	
	SubStoryList:createScrollViewItems(var_12_1)
end

function SubStoryUICheat.exportPositionData(arg_13_0)
	if PRODUCTION_MODE then
		return 
	end
	
	local var_13_0 = SubStoryListMain:getList()
	local var_13_1 = ""
	
	for iter_13_0, iter_13_1 in pairs(var_13_0 or {}) do
		if iter_13_1.logo_position then
			var_13_1 = var_13_1 .. iter_13_1.id .. " = "
			var_13_1 = var_13_1 .. "poster_bi_x=" .. (iter_13_1.logo_position.poster_bi_x or 0)
			var_13_1 = var_13_1 .. ",poster_bi_y=" .. (iter_13_1.logo_position.poster_bi_y or 0)
			var_13_1 = var_13_1 .. ",poster_bi_z=" .. (iter_13_1.logo_position.poster_bi_scale or 0)
			var_13_1 = var_13_1 .. ",x=" .. (iter_13_1.logo_position.x or 0)
			var_13_1 = var_13_1 .. ",y=" .. (iter_13_1.logo_position.y or 0)
			var_13_1 = var_13_1 .. "\n"
		end
	end
	
	print("\n" .. var_13_1)
end

function SubStoryUICheat.setBIPosition(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	if PRODUCTION_MODE then
		return 
	end
	
	local var_14_0 = SubStoryListMain:getList()
	local var_14_1 = 1
	
	if type(arg_14_1) == "number" then
		var_14_1 = arg_14_1
	else
		for iter_14_0, iter_14_1 in pairs(var_14_0) do
			if string.starts(iter_14_1.id, arg_14_1) and string.ends(iter_14_1.background_summary, "_sum") then
				var_14_1 = iter_14_0
			end
		end
	end
	
	var_14_0[var_14_1].logo_position.x = arg_14_2
	var_14_0[var_14_1].logo_position.y = arg_14_3
	
	SubStoryList:createScrollViewItems(var_14_0)
end

function SubStoryUICheat.setPosterBI(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
	local var_15_0
	
	var_15_0 = arg_15_4 or 1
	
	local var_15_1
	local var_15_2 = SubstoryManager:getInfo()
	local var_15_3 = SubStoryListMain:getWnd()
	
	if var_15_2 then
		local var_15_4 = SubStoryLobby:getWnd()
		
		if get_cocos_refid(var_15_4) then
			var_15_1 = var_15_4
			var_15_1 = var_15_1:getChildByName("n_notch_left"):getChildByName("dungeon_story_poster"):getChildByName("n_bg"):getChildren()[1]
		end
	end
	
	if get_cocos_refid(var_15_3) then
		var_15_1 = var_15_3:getChildByName("n_substory_bg"):getChildByName("n_logo"):getChildByName("dungeon_story_poster"):getChildByName("n_bg"):getChildren()[1]
	end
	
	if var_15_1 then
		var_15_1:setPositionX(arg_15_1)
		var_15_1:setPositionY(arg_15_2)
		var_15_1:setScale(arg_15_3)
	end
end
