SubstorySystemStoryList = {}

function MsgHandler.change_substory_system_story(arg_1_0)
	if arg_1_0 and arg_1_0.res == "ok" then
		if arg_1_0.err_reward then
			SubstorySystemStoryList:closeChangeConfirm()
			SubstorySystemStoryList:showWarnning(arg_1_0.err_reward)
		else
			SubstorySystemStory:updateSubstoryProgress(arg_1_0.end_substory_id, arg_1_0.substory_progress_info)
			Account:setSystemSubstory(arg_1_0.system_story_info)
			SubstorySystemStoryList:showChangeResult(arg_1_0.system_story_info.substory_id)
			SubstorySystemStoryList:closeChangeConfirm()
		end
	end
end

function HANDLER.dungeon_story_change(arg_2_0, arg_2_1)
	if arg_2_1 == "btn" then
		if arg_2_0.item then
			SubstorySystemStoryList:changeUI(arg_2_0.item, false)
		end
	elseif arg_2_1 == "btn_start" or arg_2_1 == "btn_move_replay" then
		SubstorySystemStoryList:startSubstory()
	elseif arg_2_1 == "btn_banner" then
		if Account:getCurrencyTime("to_gacha_substory") and arg_2_0.is_enable then
			SceneManager:reserveResetSceneFlow()
			SceneManager:nextScene("gacha_unit", {
				gacha_mode = "gacha_substory"
			})
		else
			balloon_message_with_sound("system_substory_gacha_lock_info")
		end
	elseif arg_2_1 == "btn_open_search" then
		SubstorySystemStoryList:showSearch()
	elseif arg_2_1 == "btn_close_search" then
		SubstorySystemStoryList:closeSearch()
	elseif arg_2_1 == "btn_search" then
		SubstorySystemStoryList:search()
	end
end

function HANDLER.dungeon_story_change_confirm(arg_3_0, arg_3_1)
	if arg_3_1 == "btn_ignore" then
		SubstorySystemStoryList:closeChangeConfirm()
	elseif arg_3_1 == "btn_cancel" then
		SubstorySystemStoryList:closeChangeConfirm()
	elseif arg_3_1 == "btn_ok" then
		SubstorySystemStoryList:changeSystemSubstory()
	end
end

function HANDLER.dungeon_story_change_result(arg_4_0, arg_4_1)
	if arg_4_1 == "btn_close" then
		SubstorySystemStoryList:closeChangeResult()
	end
end

function SubstorySystemStoryList.show(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_2 or {}
	
	arg_5_0.vars = {}
	arg_5_0.vars.parent = arg_5_1
	arg_5_0.vars.wnd = load_dlg("dungeon_story_change", true, "wnd")
	
	arg_5_0.vars.wnd:setPositionX(arg_5_1:getContentSize().width / 2)
	arg_5_1:addChild(arg_5_0.vars.wnd)
	TopBarNew:createFromPopup(T("ui_systemsubstory_episode_title"), arg_5_0.vars.wnd, function()
		SubStoryEntrance:popMode()
	end, nil, "infosubs_10")
	if_set(arg_5_0.vars.wnd, "title_substory", T("dict_substory_list_title"))
	
	local var_5_1 = Account:getSystemSubstory()
	
	if var_5_1 and var_5_1.substory_id then
		arg_5_0.vars.progress_substory = var_5_0.id or var_5_1.substory_id
	end
	
	arg_5_0:initDB()
	arg_5_0:initScrollView()
	arg_5_0:initListView()
	arg_5_0:createSorter()
	
	arg_5_0.vars.search = arg_5_0.vars.wnd:getChildByName("layer_search")
	
	if_set(arg_5_0.vars.search, "txt", T("ui_systemsubstory_search_info2"))
	
	if arg_5_0.vars.progress_episode then
		arg_5_0:setEpisode(arg_5_0.vars.progress_episode, true)
		arg_5_0:sortItems()
	end
	
	TutorialGuide:ifStartGuide("system_substory")
	arg_5_0:showAllCompleted()
end

function SubstorySystemStoryList.showAllCompleted(arg_7_0)
	if not arg_7_0.vars or not arg_7_0.vars.wnd or not get_cocos_refid(arg_7_0.vars.wnd) then
		return 
	end
	
	if arg_7_0.vars.is_all_completed == nil then
		return 
	end
	
	local var_7_0 = SubStoryUtil:getRemainTimeToChangeSystemSubstory() <= 0
	local var_7_1 = "SubstorySystemStoryList.comp_stop_watching"
	
	if not Dialog:isSkip(var_7_1) and arg_7_0.vars.is_all_completed and var_7_0 then
		Dialog:msgBox(T("systemsubstory_comp_desc"), {
			title = T("systemsubstory_comp_title")
		})
		SAVE:set(var_7_1, getCurrent3AMTime())
	end
end

function SubstorySystemStoryList.initDB(arg_8_0)
	if not arg_8_0.vars or not arg_8_0.vars.wnd or not get_cocos_refid(arg_8_0.vars.wnd) then
		return 
	end
	
	arg_8_0.vars.episode = arg_8_0.vars.episode or {}
	arg_8_0.vars.is_all_completed = nil
	
	local var_8_0 = 0
	local var_8_1 = 0
	local var_8_2 = SubStoryUtil:getChrCodeNewSystemSubstory()
	
	for iter_8_0 = 1, 9999 do
		local var_8_3, var_8_4, var_8_5, var_8_6, var_8_7, var_8_8, var_8_9 = DBN("substory_system_main", iter_8_0, {
			"id",
			"group_episode",
			"prologue",
			"unlock_stage",
			"hero",
			"sort",
			"gacha_banner"
		})
		
		if not var_8_3 then
			break
		end
		
		local var_8_10, var_8_11, var_8_12 = DB("character", var_8_7, {
			"name",
			"role",
			"ch_attribute"
		})
		local var_8_13 = {
			hero = var_8_7,
			name = T(var_8_10),
			role = var_8_11,
			element = var_8_12
		}
		local var_8_14 = T(DB("substory_main", var_8_3, "name"))
		local var_8_15
		
		if var_8_2 and var_8_2 == var_8_7 then
			var_8_15 = "y"
		end
		
		local var_8_16 = {
			id = var_8_3,
			prologue = var_8_5,
			unlock_stage = var_8_6,
			new = var_8_15,
			db_sort = var_8_8,
			gacha_banner = var_8_9,
			substory_name = var_8_14,
			hero_db = var_8_13
		}
		
		if arg_8_0.vars.progress_substory and arg_8_0.vars.progress_substory == var_8_3 then
			arg_8_0.vars.progress_episode = var_8_4
		end
		
		if arg_8_0.vars.episode[var_8_4] == nil then
			arg_8_0.vars.episode[var_8_4] = {}
		end
		
		if SubstorySystemStory:isOpenSystemSubstorySchedule(var_8_16.id) then
			table.insert(arg_8_0.vars.episode[var_8_4], var_8_16)
			
			var_8_0 = var_8_0 + 1
			
			if SubstorySystemStory:isSubstoryCleared(var_8_16.id) then
				var_8_1 = var_8_1 + 1
			end
		end
	end
	
	for iter_8_1, iter_8_2 in pairs(arg_8_0.vars.episode) do
		if table.empty(iter_8_2) then
			arg_8_0.vars.episode[iter_8_1] = nil
		end
	end
	
	local var_8_17 = var_8_0 - var_8_1
	
	arg_8_0.vars.is_all_completed = var_8_17 == 0
	
	if not arg_8_0.vars.is_all_completed and var_8_17 == 1 then
		if SubstorySystemStory:isSubstoryCleared(arg_8_0.vars.progress_substory) then
			arg_8_0.vars.is_all_completed = false
		else
			arg_8_0.vars.is_all_completed = true
		end
	end
end

function SubstorySystemStoryList.initScrollView(arg_9_0)
	if not arg_9_0.vars or not arg_9_0.vars.wnd or not get_cocos_refid(arg_9_0.vars.wnd) then
		return 
	end
	
	if table.empty(arg_9_0.vars.episode) then
		return 
	end
	
	SubstoryEpisodeScrollView:init(arg_9_0.vars.wnd)
	SubstoryEpisodeScrollView:setEpisodeScrollViewItems(arg_9_0.vars.episode, function(arg_10_0, arg_10_1)
		arg_9_0:setEpisode(arg_10_0, arg_10_1)
	end)
end

function SubstorySystemStoryList.initListView(arg_11_0)
	if not arg_11_0.vars or not arg_11_0.vars.wnd or not get_cocos_refid(arg_11_0.vars.wnd) then
		return 
	end
	
	if not arg_11_0.vars.progress_substory then
		return 
	end
	
	SubstorySystemStoryListView:init(arg_11_0.vars.wnd, arg_11_0.vars.progress_substory)
end

function SubstorySystemStoryList.setEpisode(arg_12_0, arg_12_1, arg_12_2)
	if not arg_12_0.vars or not get_cocos_refid(arg_12_0.vars.wnd) then
		return 
	end
	
	if not arg_12_1 or type(arg_12_1) ~= "string" then
		return 
	end
	
	if arg_12_0.vars.progress_episode and arg_12_0.vars.progress_episode == arg_12_1 and not arg_12_2 then
		return 
	end
	
	arg_12_0.vars.progress_episode = arg_12_1
	
	if arg_12_2 then
		local var_12_0 = SubstoryEpisodeScrollView:getScrollViewItems()
		
		for iter_12_0, iter_12_1 in pairs(var_12_0) do
			if iter_12_1.item.title == arg_12_0.vars.progress_episode then
				SubstoryEpisodeScrollView:onSelectScrollViewItem(nil, iter_12_1)
				
				break
			end
		end
	end
	
	local var_12_1 = arg_12_0.vars.episode[arg_12_0.vars.progress_episode]
	
	if var_12_1 and not table.empty(var_12_1) then
		if_set_visible(arg_12_0.vars.wnd, "n_none", false)
		if_set_visible(arg_12_0.vars.wnd, "ListView_substory", true)
		
		local var_12_2 = SubstorySystemStoryListView:createListItems(var_12_1)
		
		arg_12_0.vars.cur_items = SubstorySystemStoryListView:sort(var_12_2)
		
		if arg_12_0.vars.sorter:getFilterActive() or arg_12_0.vars.cur_sort_mode then
			arg_12_0:applySorter()
		else
			SubstorySystemStoryListView:setItems(arg_12_0.vars.cur_items)
			
			local var_12_3 = SubstorySystemStoryListView:getCurrentSelectedItem()
			
			arg_12_0:changeUI(var_12_3, arg_12_2)
		end
		
		SubstorySystemStoryListView:scrollToItem(arg_12_0.vars.progress_substory)
	end
end

function SubstorySystemStoryList.changeUI(arg_13_0, arg_13_1, arg_13_2)
	if not arg_13_0.vars or not get_cocos_refid(arg_13_0.vars.wnd) then
		return 
	end
	
	if not arg_13_1 then
		return 
	end
	
	local var_13_0 = arg_13_1.id
	local var_13_1 = SubstorySystemStoryListView:getCurrentSelectedId()
	
	if not arg_13_2 and var_13_0 == var_13_1 then
		return 
	end
	
	arg_13_0:removeEvent()
	SubstorySystemStoryListView:setSelectedBanner(var_13_0)
	
	local var_13_2 = SubstoryUIUtil:getBGInfo(var_13_0 .. "_sum", var_13_0)
	local var_13_3 = arg_13_0.vars.wnd:getChildByName("n_bg")
	
	if var_13_3 and get_cocos_refid(var_13_3) then
		var_13_3:removeAllChildren()
		SubstoryUIUtil:setLayoutData(arg_13_0.vars.wnd, "n_bg", var_13_2.bg)
	end
	
	local var_13_4 = arg_13_0.vars.wnd:getChildByName("LEFT")
	
	if var_13_4 and get_cocos_refid(var_13_4) then
		local var_13_5 = var_13_4:getChildByName("n_portrait")
		
		if var_13_5 and get_cocos_refid(var_13_5) then
			if arg_13_0.vars.portrait_origin_pos == nil then
				arg_13_0.vars.portrait_origin_pos = {}
				arg_13_0.vars.portrait_origin_pos.x = var_13_5:getPositionX()
				arg_13_0.vars.portrait_origin_pos.y = var_13_5:getPositionY()
			end
			
			if arg_13_0.vars.portrait_origin_scale == nil then
				arg_13_0.vars.portrait_origin_scale = {}
				arg_13_0.vars.portrait_origin_scale.x = var_13_5:getScaleX()
				arg_13_0.vars.portrait_origin_scale.y = var_13_5:getScaleY()
			end
			
			var_13_5:setPosition(arg_13_0.vars.portrait_origin_pos.x, arg_13_0.vars.portrait_origin_pos.y)
			var_13_5:setScale(arg_13_0.vars.portrait_origin_scale.x, arg_13_0.vars.portrait_origin_scale.y)
			var_13_5:removeAllChildren()
			SubstoryUIUtil:setLayoutData(arg_13_0.vars.wnd, "n_portrait", var_13_2.portrait, "portrait", {
				face = (var_13_2.face or {}).c
			})
			
			local var_13_6 = var_13_5:getChildByName("portrait")
			
			if var_13_6 then
				var_13_6:setAnchorPoint(0.5, 0.5)
			end
		end
		
		local var_13_7 = var_13_4:getChildByName("n_logo")
		
		if get_cocos_refid(var_13_7) then
			var_13_7:removeAllChildren()
			SubstoryUIUtil:setLayoutData(arg_13_0.vars.wnd, "n_logo", var_13_2.logo, "img")
		end
		
		local var_13_8 = var_13_4:getChildByName("n_reward_info")
		
		if get_cocos_refid(var_13_8) then
			for iter_13_0 = 1, 6 do
				var_13_8:getChildByName("n_reward_item" .. iter_13_0):removeAllChildren()
			end
			
			local var_13_9 = DB("substory_system_main", var_13_0, "core_reward")
			local var_13_10 = string.split(var_13_9, ";")
			
			for iter_13_1, iter_13_2 in pairs(var_13_10) do
				local var_13_11 = var_13_8:getChildByName("n_reward_item" .. iter_13_1)
				
				UIUtil:getRewardIcon(nil, iter_13_2, {
					parent = var_13_11
				})
			end
		end
		
		local var_13_12 = var_13_4:getChildByName("n_pickup_info")
		
		if get_cocos_refid(var_13_12) then
			if_set_visible(var_13_12, "n_banner", false)
			if_set_color(var_13_12, "n_banner", cc.c3b(255, 255, 255))
			if_set_visible(var_13_12, "n_not_availble_pickup", false)
			if_set_visible(var_13_12, "n_no_pickup", false)
			
			local var_13_13 = arg_13_1.hero_db.name
			
			if arg_13_1.gacha_banner then
				local function var_13_14()
					if_set_visible(var_13_12, "n_banner", true)
					
					local var_14_0 = var_13_12:getChildByName("n_banner")
					
					if get_cocos_refid(var_14_0) then
						if_set(var_13_12, "txt_cha", var_13_13)
						if_set_sprite(var_13_12, "img_banner", "banner/" .. arg_13_1.gacha_banner .. ".png")
						
						local var_14_1 = var_14_0:getChildByName("btn_banner")
						
						var_14_1.is_enable = true
						
						local var_14_2 = false
						local var_14_3 = Account:getSystemSubstory()
						
						if var_14_3 and var_14_3.substory_id then
							var_14_2 = var_14_3.substory_id == var_13_0
						end
						
						if not SubstorySystemStory:isSubstoryCleared(var_13_0) and not var_14_2 then
							if string.starts(var_13_0, "v1016") then
								local var_14_4
								
								if var_13_0 == "v1016d" then
									var_14_4 = "v1016e"
								elseif var_13_0 == "v1016e" then
									var_14_4 = "v1016d"
								end
								
								if var_14_3 and var_14_3.substory_id then
									var_14_2 = var_14_3.substory_id == var_14_4
								end
								
								if not SubstorySystemStory:isSubstoryCleared(var_14_4) and not var_14_2 then
									if_set_color(var_13_12, "n_banner", cc.c3b(136, 136, 136))
									
									var_14_1.is_enable = false
								end
							else
								if_set_color(var_13_12, "n_banner", cc.c3b(136, 136, 136))
								
								var_14_1.is_enable = false
							end
						end
					end
				end
				
				local var_13_15 = SubstorySystemStory:getPickupOpenScheduleByID(var_13_0)
				local var_13_16, var_13_17 = SubstorySystemStory:getRemainTimeToPickup(var_13_15)
				
				if var_13_16 == nil and var_13_17 == nil then
					var_13_14()
				else
					if_set_visible(var_13_12, "n_not_availble_pickup", true)
					
					local var_13_18 = var_13_12:getChildByName("n_not_availble_pickup")
					
					if get_cocos_refid(var_13_18) then
						if var_13_16 and var_13_17 then
							if_set(var_13_18, "label", T("systemsubstory_storypickup_new_info", {
								name = var_13_13,
								day = var_13_17
							}))
						end
						
						if var_13_16 < 86400 then
							Scheduler:addInterval(var_13_18, 100, function()
								local var_15_0, var_15_1 = SubstorySystemStory:getRemainTimeToPickup(var_13_15)
								
								if var_15_0 == nil and var_15_1 == nil then
									if_set_visible(var_13_12, "n_not_availble_pickup", false)
									var_13_14()
									Scheduler:removeByName("system_substory.updatePickupRemainTime")
								elseif var_15_0 and var_15_1 then
									if_set(var_13_18, "label", T("systemsubstory_storypickup_new_info", {
										name = var_13_13,
										day = var_15_1
									}))
								end
							end):setName("system_substory.updatePickupRemainTime")
						end
					end
				end
			else
				if_set_visible(var_13_12, "n_no_pickup", true)
				
				local var_13_19 = var_13_12:getChildByName("n_no_pickup")
				
				if get_cocos_refid(var_13_19) then
					if_set(var_13_19, "label", T("ui_systemsubstory_not_pickup_info"))
				end
			end
		end
	end
	
	local var_13_20 = arg_13_0.vars.wnd:getChildByName("RIGHT")
	
	if var_13_20 and get_cocos_refid(var_13_20) then
		local var_13_21 = var_13_20:getChildByName("n_not_availble_story")
		
		if_set_visible(var_13_21, nil, false)
		if_set_visible(var_13_21, "n_quest", false)
		if_set_visible(var_13_21, "n_time", false)
		if_set_visible(var_13_20, "btn_start", false)
		if_set_visible(var_13_20, "btn_move_replay", false)
		
		local var_13_22 = arg_13_1.sort
		
		if var_13_22 == 1 or var_13_22 == 5 then
			if_set_visible(var_13_20, "btn_move_replay", true)
			
			local var_13_23 = var_13_20:getChildByName("btn_move_replay")
			
			if var_13_23 and get_cocos_refid(var_13_23) then
				local var_13_24
				
				if var_13_22 == 1 then
					var_13_24 = T("ui_systemsubstory_btn_move")
				elseif var_13_22 == 5 then
					var_13_24 = T("ui_systemsubstory_btn_replay")
				end
				
				if_set(var_13_23, "label", var_13_24)
			end
			
			if arg_13_0.vars.is_all_completed and var_13_0 ~= "vtutod" and var_13_22 == 5 and SubStoryUtil:getRemainTimeToChangeSystemSubstory() <= 0 then
				if_set_visible(var_13_20, "btn_move_replay", false)
				if_set_visible(var_13_20, "btn_start", true)
				
				local var_13_25 = var_13_20:getChildByName("btn_start")
				
				if var_13_25 and get_cocos_refid(var_13_25) then
					if_set(var_13_25, "label", T("ui_systemsubstory_btn_start"))
				end
			end
		elseif Account:isMapCleared(arg_13_1.unlock_stage) then
			local var_13_26 = SubStoryUtil:getRemainTimeToChangeSystemSubstory()
			
			if var_13_26 > 0 then
				if_set_visible(var_13_21, nil, true)
				if_set_visible(var_13_21, "n_time", true)
				if_set(var_13_21, "t_title", T("ui_systemsubstory_btn_time"))
				if_set(var_13_21, "t_time_left", T("systemsubstory_change_time_info", {
					time = sec_to_full_string(var_13_26, false, {
						count = 2
					})
				}))
				Scheduler:addInterval(var_13_21, 100, function()
					local var_16_0 = SubStoryUtil:getRemainTimeToChangeSystemSubstory()
					
					if var_16_0 > 0 then
						if_set(var_13_21, "t_time_left", T("systemsubstory_change_time_info", {
							time = sec_to_full_string(var_16_0, false, {
								count = 2
							})
						}))
					else
						if_set_visible(var_13_21, nil, false)
						if_set_visible(var_13_21, "n_time", false)
						if_set_visible(var_13_20, "btn_start", true)
						
						local var_16_1 = var_13_20:getChildByName("btn_start")
						
						if var_16_1 and get_cocos_refid(var_16_1) then
							if_set(var_16_1, "label", T("ui_systemsubstory_btn_start"))
						end
						
						Scheduler:removeByName("system_substory.updateChangeRemainTime")
					end
				end):setName("system_substory.updateChangeRemainTime")
			else
				if_set_visible(var_13_20, "btn_start", true)
				
				local var_13_27 = var_13_20:getChildByName("btn_start")
				
				if var_13_27 and get_cocos_refid(var_13_27) then
					if_set(var_13_27, "label", T("ui_systemsubstory_btn_start"))
				end
			end
		else
			if_set_visible(var_13_21, nil, true)
			if_set_visible(var_13_21, "n_quest", true)
			
			local var_13_28
			
			if arg_13_1.prologue then
				var_13_28 = arg_13_1.prologue
			else
				var_13_28 = arg_13_0.vars.progress_episode
			end
			
			local var_13_29 = string.match(var_13_28, "%d")
			local var_13_30 = DB("ep_select", var_13_29, "ep_num")
			local var_13_31 = DB("level_enter", arg_13_1.unlock_stage, "name")
			local var_13_32 = T(var_13_30) .. ", " .. T(var_13_31)
			
			if var_13_30 and var_13_31 then
				if_set(var_13_21, "t_quest", T_KR("systemsubstory_change_info_lock", {
					episode = var_13_32
				}))
			end
		end
		
		local var_13_33 = var_13_20:getChildByName("n_story_info")
		
		if var_13_33 and get_cocos_refid(var_13_33) then
			SubstoryUIUtil:setLayoutData(arg_13_0.vars.wnd, "t_hero_name", var_13_2.title, "txt")
			SubstoryUIUtil:setLayoutData(arg_13_0.vars.wnd, "t_story_disc", var_13_2.desc, "txt")
		end
	end
end

function SubstorySystemStoryList.removeEvent(arg_17_0)
	if not arg_17_0.vars or not get_cocos_refid(arg_17_0.vars.wnd) then
		return 
	end
	
	Scheduler:removeByName("system_substory.updatePickupRemainTime")
	Scheduler:removeByName("system_substory.updateChangeRemainTime")
end

function SubstorySystemStoryList.startSubstory(arg_18_0)
	if not arg_18_0.vars or not arg_18_0.vars.wnd or not get_cocos_refid(arg_18_0.vars.wnd) then
		return 
	end
	
	if arg_18_0.vars.is_all_completed == nil then
		return 
	end
	
	local var_18_0, var_18_1 = BackPlayUtil:checkSubstoryInBackPlay()
	
	if not var_18_0 then
		balloon_message_with_sound(var_18_1)
		
		return 
	end
	
	local var_18_2 = Account:getSystemSubstory()
	local var_18_3 = SubstorySystemStoryListView:getCurrentSelectedItem() or {
		id = SubstorySystemStoryListView:getCurrentSelectedId()
	}
	
	if not var_18_2 or not var_18_2.substory_id or not var_18_3 or not var_18_3.id then
		return 
	end
	
	if var_18_3.unlock_stage and not Account:isMapCleared(var_18_3.unlock_stage) then
		return 
	end
	
	if var_18_2.substory_id == var_18_3.id then
		SubstoryManager:queryEnter(var_18_3.id)
	elseif SubstorySystemStory:isSubstoryCleared(var_18_3.id) then
		if arg_18_0.vars.is_all_completed then
			local var_18_4 = SubstorySystemStory:getSubstoryProgressByID(var_18_3.id)
			local var_18_5 = SubStoryUtil:getRemainTimeToChangeSystemSubstory() <= 0
			
			if var_18_4 and var_18_4.end_count and var_18_4.end_count >= 1 and var_18_5 then
				SubstorySystemStoryList:showChangeConfirm(var_18_2.substory_id, var_18_3.id)
			else
				arg_18_0:moveToDict(var_18_3.id)
			end
		else
			arg_18_0:moveToDict(var_18_3.id)
		end
	else
		SubstorySystemStoryList:showChangeConfirm(var_18_2.substory_id, var_18_3.id)
	end
end

function SubstorySystemStoryList.moveToDict(arg_19_0, arg_19_1)
	if not arg_19_0.vars or not arg_19_0.vars.wnd or not get_cocos_refid(arg_19_0.vars.wnd) then
		return 
	end
	
	if not arg_19_1 then
		return 
	end
	
	SceneManager:reserveResetSceneFlow()
	SceneManager:nextScene("collection", {
		mode = "story",
		parent_id = "story7",
		select_item = {
			id = arg_19_1
		}
	})
end

function SubstorySystemStoryList.showChangeConfirm(arg_20_0, arg_20_1, arg_20_2)
	if not arg_20_0.vars or not arg_20_0.vars.parent or not get_cocos_refid(arg_20_0.vars.wnd) then
		return 
	end
	
	if not arg_20_1 or not arg_20_2 then
		return 
	end
	
	arg_20_0.vars.confirm_wnd = load_dlg("dungeon_story_change_confirm", true, "wnd", function()
		arg_20_0:closeChangeConfirm()
	end)
	
	arg_20_0.vars.confirm_wnd:setPositionX(arg_20_0.vars.parent:getContentSize().width / 2)
	arg_20_0.vars.parent:addChild(arg_20_0.vars.confirm_wnd)
	
	arg_20_0.vars.before_id = arg_20_1
	arg_20_0.vars.after_id = arg_20_2
	
	arg_20_0:initChangeConfirm()
end

function SubstorySystemStoryList.initChangeConfirm(arg_22_0)
	if not get_cocos_refid(arg_22_0.vars.confirm_wnd) then
		return 
	end
	
	if not arg_22_0.vars.before_id or not arg_22_0.vars.after_id then
		return 
	end
	
	if_set(arg_22_0.vars.confirm_wnd, "txt_title", T("systemsubstory_change_popup_title"))
	if_set(arg_22_0.vars.confirm_wnd, "txt_desc", T("systemsubstory_change_popup_desc1"))
	if_set(arg_22_0.vars.confirm_wnd, "txt_warnning", T("systemsubstory_change_popup_desc2"))
	
	local var_22_0 = SubstoryUIUtil:getBGInfo(arg_22_0.vars.before_id .. "_sum", arg_22_0.vars.before_id)
	local var_22_1 = SubstoryUIUtil:getBGInfo(arg_22_0.vars.after_id .. "_sum", arg_22_0.vars.after_id)
	local var_22_2 = arg_22_0.vars.confirm_wnd:getChildByName("n_story_bi_before")
	local var_22_3 = arg_22_0.vars.confirm_wnd:getChildByName("n_story_bi_after")
	
	if get_cocos_refid(var_22_2) and get_cocos_refid(var_22_3) then
		SubstoryUIUtil:setLayoutData(arg_22_0.vars.confirm_wnd, "n_story_bi_before", var_22_0.logo, "img")
		SubstoryUIUtil:setLayoutData(arg_22_0.vars.confirm_wnd, "n_story_bi_after", var_22_1.logo, "img")
	end
	
	local var_22_4 = arg_22_0.vars.confirm_wnd:getChildByName("n_portrait_before")
	local var_22_5 = arg_22_0.vars.confirm_wnd:getChildByName("n_portrait_after")
	
	if get_cocos_refid(var_22_4) and get_cocos_refid(var_22_5) then
		SubstoryUIUtil:setLayoutData(arg_22_0.vars.confirm_wnd, "n_portrait_before", var_22_0.portrait, "portrait", {
			face = (var_22_0.face or {}).c
		})
		
		local var_22_6 = var_22_4:getChildByName("portrait")
		
		if var_22_6 then
			var_22_6:setAnchorPoint(0.5, 0.5)
		end
		
		SubstoryUIUtil:setLayoutData(arg_22_0.vars.confirm_wnd, "n_portrait_after", var_22_1.portrait, "portrait", {
			face = (var_22_1.face or {}).c
		})
		
		local var_22_7 = var_22_5:getChildByName("portrait")
		
		if var_22_7 then
			var_22_7:setAnchorPoint(0.5, 0.5)
		end
	end
end

function SubstorySystemStoryList.changeSystemSubstory(arg_23_0)
	if not arg_23_0.vars or not get_cocos_refid(arg_23_0.vars.confirm_wnd) then
		return 
	end
	
	if not arg_23_0.vars.after_id then
		return 
	end
	
	local var_23_0
	
	SAVE:setTempConfigData("last_clear_town." .. arg_23_0.vars.after_id, "null")
	
	if SAVE:updateConfigDataByTemp() > 0 then
		var_23_0 = SAVE:getJsonConfigData()
	end
	
	query("change_substory_system_story", {
		select_id = arg_23_0.vars.after_id,
		config_datas = var_23_0
	})
end

function SubstorySystemStoryList.closeChangeConfirm(arg_24_0)
	if not get_cocos_refid(arg_24_0.vars.confirm_wnd) then
		return 
	end
	
	BackButtonManager:pop("dungeon_story_change_confirm")
	UIAction:Add(SEQ(REMOVE()), arg_24_0.vars.confirm_wnd, "block")
	
	arg_24_0.vars.confirm_wnd = nil
end

function SubstorySystemStoryList.showWarnning(arg_25_0, arg_25_1)
	if not arg_25_0.vars or not arg_25_0.vars.parent or not get_cocos_refid(arg_25_0.vars.wnd) then
		return 
	end
	
	if not arg_25_1 then
		return 
	end
	
	local var_25_0 = {}
	
	for iter_25_0, iter_25_1 in pairs(arg_25_1) do
		local var_25_1
		
		if iter_25_1 == "quest" then
			var_25_1 = T("systemsubstory_reward_get_quest")
		elseif iter_25_1 == "achieve" then
			var_25_1 = T("systemsubstory_reward_get_achiv")
		elseif iter_25_1 == "star" then
			var_25_1 = T("systemsubstory_reward_get_chapter")
		end
		
		table.insert(var_25_0, var_25_1)
	end
	
	local var_25_2
	
	for iter_25_2, iter_25_3 in pairs(var_25_0) do
		if iter_25_2 == 1 then
			var_25_2 = iter_25_3
		else
			var_25_2 = var_25_2 .. ", " .. iter_25_3
		end
	end
	
	Dialog:msgBox(T("systemsubstory_reward_get_desc", {
		contents = var_25_2
	}), {
		title = T("systemsubstory_reward_get_title")
	})
end

function SubstorySystemStoryList.showChangeResult(arg_26_0, arg_26_1)
	if not arg_26_0.vars or not arg_26_0.vars.parent or not get_cocos_refid(arg_26_0.vars.wnd) then
		return 
	end
	
	if not arg_26_0.vars.progress_episode or not arg_26_1 then
		return 
	end
	
	arg_26_0.vars.result_wnd = load_dlg("dungeon_story_change_result", true, "wnd", function()
		arg_26_0:closeChangeResult()
	end)
	
	arg_26_0.vars.result_wnd:setPositionX(arg_26_0.vars.parent:getContentSize().width / 2)
	arg_26_0.vars.parent:addChild(arg_26_0.vars.result_wnd)
	
	arg_26_0.vars.before_id = nil
	arg_26_0.vars.after_id = nil
	
	SubstoryEpisodeScrollView:setEpisodeScrollViewItems(arg_26_0.vars.episode, function(arg_28_0, arg_28_1)
		arg_26_0:setEpisode(arg_28_0, arg_28_1)
	end)
	arg_26_0:setEpisode(arg_26_0.vars.progress_episode, true)
	arg_26_0:initChangeResult(arg_26_1)
end

function SubstorySystemStoryList.initChangeResult(arg_29_0, arg_29_1)
	if not get_cocos_refid(arg_29_0.vars.result_wnd) or not arg_29_1 then
		return 
	end
	
	local var_29_0 = SubstoryUIUtil:getBGInfo(arg_29_1 .. "_sum", arg_29_1)
	
	if_set(arg_29_0.vars.result_wnd, "txt_title", T("systemsubstory_change_com_popup_title"))
	if_set(arg_29_0.vars.result_wnd, "txt_desc", T("systemsubstory_change_com_popup_desc"))
	
	local var_29_1 = arg_29_0.vars.result_wnd:getChildByName("n_story_bi_after")
	
	if get_cocos_refid(var_29_1) then
		SubstoryUIUtil:setLayoutData(arg_29_0.vars.result_wnd, "n_story_bi_after", var_29_0.logo, "img")
	end
	
	local var_29_2 = arg_29_0.vars.result_wnd:getChildByName("n_portrait_after")
	
	if get_cocos_refid(var_29_2) then
		SubstoryUIUtil:setLayoutData(arg_29_0.vars.result_wnd, "n_portrait_after", var_29_0.portrait, "portrait", {
			face = (var_29_0.face or {}).c
		})
		
		local var_29_3 = var_29_2:getChildByName("portrait")
		
		if var_29_3 then
			var_29_3:setAnchorPoint(0.5, 0.5)
		end
	end
end

function SubstorySystemStoryList.closeChangeResult(arg_30_0)
	if not get_cocos_refid(arg_30_0.vars.result_wnd) then
		return 
	end
	
	BackButtonManager:pop("dungeon_story_change_result")
	UIAction:Add(SEQ(REMOVE()), arg_30_0.vars.result_wnd, "block")
	
	arg_30_0.vars.result_wnd = nil
	
	local var_30_0 = Account:getSystemSubstory()
	
	if not var_30_0 and not var_30_0.substory_id then
		return 
	end
	
	SubstoryManager:queryEnter(var_30_0.substory_id)
end

function SubstorySystemStoryList.createSorter(arg_31_0)
	if not arg_31_0.vars or not get_cocos_refid(arg_31_0.vars.wnd) then
		return 
	end
	
	local var_31_0 = arg_31_0.vars.wnd:getChildByName("n_hero_sort")
	
	if get_cocos_refid(var_31_0) then
		arg_31_0.vars.n_sort = var_31_0
		arg_31_0.vars.sorter = Sorter:create(var_31_0, {
			use_system_substory = true,
			sorting_unit = true
		})
		
		arg_31_0:setupFilterValue()
		
		local var_31_1 = {
			{
				key = "unlcok",
				name = T("ui_systemsubstory_filter_unlock"),
				func = SubstorySortOrder.greaterThanUnlockOrder
			},
			{
				key = "element",
				name = T("ui_systemsubstory_filter_element"),
				func = SubstorySortOrder.greaterThanElement
			},
			{
				key = "role",
				name = T("ui_systemsubstory_filter_role"),
				func = SubstorySortOrder.greaterThanRole
			},
			{
				key = "name",
				name = T("ui_systemsubstory_filter_name"),
				func = SubstorySortOrder.greaterThanName
			}
		}
		
		arg_31_0.vars.show_ac_hero = false
		arg_31_0.vars.show_unac_hero = false
		arg_31_0.vars.show_unlock_story = false
		
		local var_31_2 = {
			{
				id = "show_ac_hero",
				is_filter = true,
				name = T("ui_systemsubstory_filter_ac_hero"),
				checked = arg_31_0.vars.show_ac_hero
			},
			{
				id = "show_unac_hero",
				is_filter = true,
				name = T("ui_systemsubstory_filter_unac_hero"),
				checked = arg_31_0.vars.show_unac_hero
			},
			{
				id = "show_unlock_story",
				is_filter = true,
				name = T("ui_systemsubstory_filter_unlock_story"),
				checked = arg_31_0.vars.show_unlock_story
			}
		}
		
		arg_31_0.vars.sorter:setSorter({
			not_update_content_size = true,
			default_sort_index = 1,
			menus = var_31_1,
			checkboxs = var_31_2,
			filters = arg_31_0:getFilterTable(),
			callback_sort = function(arg_32_0, arg_32_1, arg_32_2)
				if arg_32_0 ~= arg_32_1 and arg_32_2.key then
					arg_31_0:sortItems(arg_32_2.key)
				end
			end,
			callback_checkbox = function(arg_33_0, arg_33_1, arg_33_2)
				if arg_33_0 == "show_ac_hero" then
					arg_31_0.vars.show_ac_hero = arg_33_2
					
					arg_31_0:filterItems()
				elseif arg_33_0 == "show_unac_hero" then
					arg_31_0.vars.show_unac_hero = arg_33_2
					
					arg_31_0:filterItems()
				elseif arg_33_0 == "show_unlock_story" then
					arg_31_0.vars.show_unlock_story = arg_33_2
					
					arg_31_0:filterItems()
				end
			end,
			callback_on_add_filter = function(arg_34_0, arg_34_1, arg_34_2)
				arg_31_0:addFilter(arg_34_0, arg_34_1, arg_34_2)
			end,
			callback_on_commit_filter = function()
				arg_31_0:filterItems()
			end
		})
	end
end

function SubstorySystemStoryList.setupFilterValue(arg_36_0)
	if not arg_36_0.vars or not get_cocos_refid(arg_36_0.vars.wnd) then
		return 
	end
	
	if not arg_36_0.vars.sorter then
		return 
	end
	
	local var_36_0 = {}
	
	arg_36_0.vars.filter_un_hash_tbl = SubstorySortOrder:getDefaultUnHashTable()
	arg_36_0.vars.filters = {}
	
	arg_36_0:loadFilterValue(var_36_0.role, "role")
	arg_36_0:loadFilterValue(var_36_0.element, "element")
end

function SubstorySystemStoryList.loadFilterValue(arg_37_0, arg_37_1, arg_37_2)
	arg_37_1 = arg_37_1 or {}
	arg_37_0.vars.filters[arg_37_2] = {}
	
	for iter_37_0 = 1, 10 do
		local var_37_0 = arg_37_0.vars.filter_un_hash_tbl[arg_37_2][iter_37_0]
		
		if not var_37_0 then
			break
		end
		
		if arg_37_1[var_37_0] ~= nil then
			arg_37_0.vars.filters[arg_37_2][var_37_0] = arg_37_1[var_37_0]
		else
			arg_37_0.vars.filters[arg_37_2][var_37_0] = true
		end
	end
end

function SubstorySystemStoryList.getFilterTable(arg_38_0, arg_38_1)
	arg_38_1 = arg_38_1 or {}
	
	return {
		role = {
			id = "role",
			check_list = arg_38_0:getFilterCheckList("role", arg_38_1.role)
		},
		element = {
			id = "element",
			check_list = arg_38_0:getFilterCheckList("element", arg_38_1.element)
		}
	}
end

function SubstorySystemStoryList.getFilterCheckList(arg_39_0, arg_39_1, arg_39_2)
	return SubstorySortOrder:getFilterCheckList(arg_39_0.vars.filter_un_hash_tbl, arg_39_1, arg_39_2)
end

function SubstorySystemStoryList.addFilter(arg_40_0, arg_40_1, arg_40_2, arg_40_3)
	local var_40_0 = arg_40_0.vars.filter_un_hash_tbl[arg_40_1][arg_40_2]
	
	arg_40_0.vars.filters[arg_40_1][var_40_0] = arg_40_3
end

function SubstorySystemStoryList.filterItems(arg_41_0)
	if not arg_41_0.vars or not get_cocos_refid(arg_41_0.vars.wnd) then
		return 
	end
	
	if not arg_41_0.vars.sorter or table.empty(arg_41_0.vars.cur_items) then
		return 
	end
	
	local var_41_0 = {}
	local var_41_1 = table.clone(arg_41_0.vars.cur_items)
	local var_41_2 = false
	
	for iter_41_0, iter_41_1 in pairs(var_41_1) do
		if arg_41_0.vars.show_ac_hero then
			var_41_2 = true
			
			if Account:getCollectionUnit(iter_41_1.hero_db.hero) then
				table.insert(var_41_0, iter_41_1)
			end
		end
		
		if arg_41_0.vars.show_unac_hero then
			var_41_2 = true
			
			if not Account:getCollectionUnit(iter_41_1.hero_db.hero) then
				table.insert(var_41_0, iter_41_1)
			end
		end
	end
	
	if var_41_2 then
		var_41_1 = var_41_0
	end
	
	if arg_41_0.vars.show_unlock_story then
		local var_41_3 = {}
		
		for iter_41_2, iter_41_3 in pairs(var_41_1) do
			if Account:isMapCleared(iter_41_3.unlock_stage) then
				table.insert(var_41_3, iter_41_3)
			end
		end
		
		var_41_1 = var_41_3
	end
	
	local var_41_4 = {}
	
	for iter_41_4, iter_41_5 in pairs(var_41_1) do
		local var_41_5 = false
		
		if arg_41_0:checkIncludeElement(iter_41_5.hero_db.element) and arg_41_0:checkIncludeRole(iter_41_5.hero_db.role) then
			table.insert(var_41_4, iter_41_5)
		end
	end
	
	if table.empty(var_41_4) then
		local var_41_6 = arg_41_0.vars.wnd:getChildByName("n_none")
		
		if get_cocos_refid(var_41_6) then
			var_41_6:setVisible(true)
			if_set(var_41_6, "label", T("ui_systemsubstory_list_info"))
		end
		
		if_set_visible(arg_41_0.vars.wnd, "ListView_substory", false)
	else
		if_set_visible(arg_41_0.vars.wnd, "n_none", false)
		if_set_visible(arg_41_0.vars.wnd, "ListView_substory", true)
		SubstorySystemStoryListView:setItems(var_41_4)
		
		if arg_41_0.vars.cur_sort_mode then
			arg_41_0:sortItems(arg_41_0.vars.cur_sort_mode)
		end
	end
end

function SubstorySystemStoryList.checkIncludeElement(arg_42_0, arg_42_1)
	if not arg_42_0.vars.filters or not arg_42_0.vars.filters.element or not arg_42_1 then
		return false
	end
	
	local var_42_0 = false
	
	for iter_42_0, iter_42_1 in pairs(arg_42_0.vars.filters.element) do
		if iter_42_0 == arg_42_1 and iter_42_1 == true then
			var_42_0 = true
		end
	end
	
	return var_42_0
end

function SubstorySystemStoryList.checkIncludeRole(arg_43_0, arg_43_1)
	if not arg_43_0.vars.filters or not arg_43_0.vars.filters.role or not arg_43_1 then
		return false
	end
	
	local var_43_0 = false
	
	for iter_43_0, iter_43_1 in pairs(arg_43_0.vars.filters.role) do
		if iter_43_0 == arg_43_1 and iter_43_1 == true then
			var_43_0 = true
		end
	end
	
	return var_43_0
end

function SubstorySystemStoryList.sortItems(arg_44_0, arg_44_1)
	if not arg_44_0.vars or not get_cocos_refid(arg_44_0.vars.wnd) then
		return 
	end
	
	if not arg_44_0.vars.n_sort or not arg_44_0.vars.sorter then
		return 
	end
	
	local var_44_0 = SubstorySystemStoryListView:getListItems()
	
	if table.empty(var_44_0) then
		return 
	end
	
	local var_44_1 = table.clone(var_44_0)
	
	arg_44_0.vars.sorter:setItems(var_44_1)
	
	local var_44_2
	
	if arg_44_1 then
		arg_44_0.vars.cur_sort_mode = arg_44_1
		
		local var_44_3 = arg_44_0.vars.sorter:sort()
		
		if arg_44_1 == "element" or arg_44_1 == "role" then
			var_44_3 = arg_44_0:sortItemsByGroup(var_44_3, arg_44_1)
		end
		
		SubstorySystemStoryListView:setItems(var_44_3)
		
		local var_44_4 = math.abs(arg_44_0.vars.sorter:getSortIndex())
		
		var_44_2 = arg_44_0.vars.n_sort:getChildByName("btn_sort" .. var_44_4):getChildByName("txt_sort" .. var_44_4):getString()
	else
		arg_44_0.vars.sorter:sort(1)
		
		var_44_2 = T("ui_systemsubstory_filter_default")
	end
	
	local var_44_5 = arg_44_0.vars.n_sort:getChildByName("btn_toggle")
	local var_44_6 = arg_44_0.vars.n_sort:getChildByName("btn_toggle_active")
	
	if_set(var_44_5, "txt_sort", var_44_2)
	if_set(var_44_6, "txt_sort", var_44_2)
end

function SubstorySystemStoryList.sortItemsByGroup(arg_45_0, arg_45_1, arg_45_2)
	if not arg_45_0.vars or not arg_45_0.vars.sorter then
		return nil
	end
	
	if table.empty(arg_45_1) or not arg_45_2 then
		return nil
	end
	
	local var_45_0 = {}
	local var_45_1 = SubstorySortOrder:getUnHashTableByGroup(arg_45_2)
	
	if arg_45_0.vars.sorter:getSortIndex() < 0 then
		table.reverse(var_45_1)
	end
	
	for iter_45_0, iter_45_1 in pairs(var_45_1) do
		local var_45_2 = {}
		
		for iter_45_2, iter_45_3 in pairs(arg_45_1) do
			if iter_45_3.hero_db[arg_45_2] == iter_45_1 then
				table.insert(var_45_2, iter_45_3)
			end
		end
		
		local var_45_3 = SubstorySystemStoryListView:sort(var_45_2)
		
		for iter_45_4, iter_45_5 in pairs(var_45_3 or {}) do
			table.push_not_nil(var_45_0, iter_45_5)
		end
	end
	
	return var_45_0
end

function SubstorySystemStoryList.applySorter(arg_46_0)
	if not arg_46_0.vars or not get_cocos_refid(arg_46_0.vars.wnd) then
		return 
	end
	
	if not arg_46_0.vars.sorter then
		return 
	end
	
	arg_46_0:filterItems()
end

function SubstorySystemStoryList.showSearch(arg_47_0)
	if not arg_47_0.vars or not get_cocos_refid(arg_47_0.vars.wnd) or not get_cocos_refid(arg_47_0.vars.search) then
		return 
	end
	
	if_set_visible(arg_47_0.vars.search, nil, true)
	if_set(arg_47_0.vars.search, "input_search", "")
end

function SubstorySystemStoryList.search(arg_48_0)
	if not arg_48_0.vars or not get_cocos_refid(arg_48_0.vars.wnd) or not get_cocos_refid(arg_48_0.vars.search) then
		return 
	end
	
	local var_48_0 = arg_48_0.vars.search:getChildByName("input_search"):getString()
	local var_48_1 = CollectionUtil:removeRegexCharacters(var_48_0)
	
	if var_48_1 ~= nil and var_48_1 ~= "" then
		arg_48_0.vars.cur_items = arg_48_0:searchSubstory(var_48_1)
		
		if table.empty(arg_48_0.vars.cur_items) then
			local var_48_2 = arg_48_0.vars.wnd:getChildByName("n_none")
			
			if get_cocos_refid(var_48_2) then
				var_48_2:setVisible(true)
				if_set(var_48_2, "label", T("ui_systemsubstory_search_fail"))
			end
			
			if_set_visible(arg_48_0.vars.wnd, "ListView_substory", false)
		else
			if_set_visible(arg_48_0.vars.wnd, "n_none", false)
			if_set_visible(arg_48_0.vars.wnd, "ListView_substory", true)
			arg_48_0:applySorter()
		end
	end
	
	arg_48_0:closeSearch()
end

function SubstorySystemStoryList.searchSubstory(arg_49_0, arg_49_1)
	if not arg_49_0.vars.cur_items or not arg_49_1 then
		return nil
	end
	
	local var_49_0 = {}
	
	for iter_49_0, iter_49_1 in pairs(arg_49_0.vars.cur_items) do
		if string.match(iter_49_1.substory_name, arg_49_1) or string.match(iter_49_1.hero_db.name, arg_49_1) then
			table.insert(var_49_0, iter_49_1)
		end
	end
	
	return (SubstorySystemStoryListView:sort(var_49_0))
end

function SubstorySystemStoryList.closeSearch(arg_50_0)
	if not arg_50_0.vars or not get_cocos_refid(arg_50_0.vars.wnd) or not get_cocos_refid(arg_50_0.vars.search) then
		return 
	end
	
	if_set_visible(arg_50_0.vars.search, nil, false)
	if_set(arg_50_0.vars.search, "input_search", "")
end

function SubstorySystemStoryList.close(arg_51_0)
	arg_51_0:removeEvent()
	SubstoryEpisodeScrollView:reset()
	SubstorySystemStoryListView:reset()
	
	if UnitDetailStory:isVisible() then
		UnitDetailStory:updateItems()
	end
	
	local var_51_0 = SubstorySystemStoryListView:getListView()
	
	if get_cocos_refid(var_51_0) then
		var_51_0:setVisible(false)
	end
	
	if get_cocos_refid(arg_51_0.vars.wnd) then
		local var_51_1 = arg_51_0.vars.wnd:getChildByName("n_bg")
		
		if get_cocos_refid(var_51_1) then
			var_51_1:setVisible(false)
		end
		
		SubStoryEntrance:setVisibleBlackColorLayer(false)
		UIAction:Add(SEQ(LOG(FADE_OUT(300)), REMOVE()), arg_51_0.vars.wnd, "block")
	end
	
	TopBarNew:pop()
	BackButtonManager:pop("TopBarNew." .. T("system_substory_title"))
	
	arg_51_0.vars = nil
end
