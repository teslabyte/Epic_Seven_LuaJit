SubStoryFestivalOffice = SubStoryFestivalOffice or {}

function HANDLER.dungeon_story_custom_office(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_get_all" then
		SubStoryFestivalOffice:req_rewards()
	end
end

function MsgHandler.substory_festival_score_reward(arg_2_0)
	if arg_2_0 then
		if arg_2_0.rewards then
			local var_2_0 = Account:addReward(arg_2_0.rewards)
			
			Dialog:msgScrollRewards(T("fm_reward_popup2_desc"), {
				open_effect = true,
				title = T("ui_msgbox_rewards_title"),
				rewards = var_2_0.rewards
			})
		end
		
		SubStoryFestivalOffice:res_rewards(arg_2_0)
		SubStoryLobbyUIFestival:updateUI()
	end
end

function SubStoryFestivalOffice.show(arg_3_0, arg_3_1)
	if arg_3_0.vars and get_cocos_refid(arg_3_0.vars.wnd) then
		return 
	end
	
	local var_3_0 = (SubstoryManager:getInfo() or {}).id
	local var_3_1 = Account:getSubStoryFestivalInfo(var_3_0)
	
	if not var_3_1 or table.empty(var_3_1) then
		return 
	end
	
	arg_3_0.vars = {}
	arg_3_0.vars.parent = arg_3_1 or SceneManager:getRunningPopupScene()
	arg_3_0.vars.wnd = load_dlg("dungeon_story_custom_office", true, "wnd")
	
	arg_3_0.vars.parent:addChild(arg_3_0.vars.wnd)
	
	arg_3_0.vars.substory_id = var_3_0
	arg_3_0.vars.festival_info = var_3_1
	arg_3_0.vars.day = var_3_1.day or 1
	arg_3_0.vars.festival_score = tonumber(arg_3_0.vars.festival_info.festival_score)
	arg_3_0.vars.festival_reward = tonumber(arg_3_0.vars.festival_info.festival_reward)
	
	TopBarNew:createFromPopup(T("fm_office_btn"), arg_3_0.vars.wnd, function()
		arg_3_0:close()
	end)
	arg_3_0:updateData()
	arg_3_0:updateUI()
	arg_3_0:updatePortrait()
	arg_3_0:fadeIn()
	
	if var_3_0 == "vma1ba" then
		TutorialGuide:startGuide("tuto_vma1ba_fmcenter")
	end
end

function SubStoryFestivalOffice.fadeIn(arg_5_0)
	local var_5_0 = arg_5_0.vars.wnd
	local var_5_1 = var_5_0:getChildByName("n_pos")
	local var_5_2 = var_5_0:getChildByName("n_board")
	
	var_5_1:setOpacity(0)
	UIAction:Add(SEQ(FADE_IN(150)), var_5_1, "block")
	var_5_2:setOpacity(0)
	UIAction:Add(SEQ(FADE_IN(200)), var_5_2, "block")
end

function SubStoryFestivalOffice.updateData(arg_6_0)
	arg_6_0.vars.data = {}
	arg_6_0.vars.recieved_reward_count = 0
	arg_6_0.vars.can_receive = false
	
	for iter_6_0 = 1, 99 do
		local var_6_0 = string.format("%s_%02d", arg_6_0.vars.substory_id, iter_6_0)
		local var_6_1 = DBT("substory_festival_office", var_6_0, {
			"id",
			"need_point",
			"reward_item",
			"reward_item_value",
			"grade_rate",
			"set_drop_rate_id"
		})
		
		if not var_6_1 or table.empty(var_6_1) then
			break
		end
		
		if var_6_1.need_point <= arg_6_0.vars.festival_reward then
			var_6_1.already_receive = true
		elseif var_6_1.need_point <= arg_6_0.vars.festival_score and arg_6_0.vars.festival_reward < var_6_1.need_point then
			var_6_1.can_receive = true
			arg_6_0.vars.can_receive = true
		end
		
		if var_6_1.already_receive or var_6_1.can_receive then
			arg_6_0.vars.recieved_reward_count = arg_6_0.vars.recieved_reward_count + 1
		end
		
		table.insert(arg_6_0.vars.data, var_6_1)
	end
end

function SubStoryFestivalOffice.updateUI(arg_7_0)
	arg_7_0:updateRewardIcons()
	arg_7_0:updateProgressBar()
	if_set(arg_7_0.vars.wnd, "t_score", arg_7_0.vars.festival_score)
	
	if arg_7_0.vars.can_receive then
		if_set_opacity(arg_7_0.vars.wnd, "btn_get_all", 255)
	else
		if_set_opacity(arg_7_0.vars.wnd, "btn_get_all", 76.5)
	end
end

function SubStoryFestivalOffice.updateRewardIcons(arg_8_0)
	local var_8_0 = arg_8_0.vars.wnd:getChildByName("n_board")
	
	for iter_8_0 = 1, 99 do
		local var_8_1 = var_8_0:getChildByName("n_reward" .. iter_8_0)
		
		if get_cocos_refid(var_8_1) then
			local var_8_2 = var_8_1:getChildByName("reward_item")
			local var_8_3 = arg_8_0.vars.data[iter_8_0]
			local var_8_4 = var_8_1:getChildByName("t_score")
			
			if not get_cocos_refid(var_8_1) or not var_8_3 then
				break
			end
			
			var_8_2:removeAllChildren()
			
			local var_8_5 = UIUtil:getRewardIcon(var_8_3.reward_item_value, var_8_3.reward_item, {
				no_detail_popup = true,
				parent = var_8_2,
				grade_rate = var_8_3.grade_rate,
				set_fx = var_8_3.set_drop_rate_id
			})
			
			if_set_visible(var_8_1, "icon_check_reward", var_8_3.already_receive)
			if_set(var_8_1, "t_score", var_8_3.need_point)
			
			if var_8_3.already_receive or var_8_3.can_receive then
				if_set_sprite(var_8_1, "img_light", "img/z_custom_light_on.png")
			else
				if_set_sprite(var_8_1, "img_light", "img/z_custom_light_off.png")
			end
			
			if var_8_3.already_receive then
				var_8_4:setTextColor(tocolor("#6bc11b"))
				var_8_2:setColor(tocolor("#888888"))
			else
				var_8_4:setTextColor(tocolor("#ffffff"))
				var_8_2:setColor(tocolor("#ffffff"))
			end
		end
	end
end

function SubStoryFestivalOffice.updateProgressBar(arg_9_0)
	local var_9_0 = 10
	local var_9_1 = 0.01 + arg_9_0.vars.recieved_reward_count / var_9_0 * 0.98
	
	if_set_percent(arg_9_0.vars.wnd, "progress_bar", var_9_1)
end

function SubStoryFestivalOffice.updatePortrait(arg_10_0)
	local var_10_0 = getChildByPath(arg_10_0.vars.wnd, "n_pos")
	local var_10_1, var_10_2 = DB("substory_festival_fm", arg_10_0.vars.substory_id, {
		"id",
		"npc_office"
	})
	
	if var_10_1 and var_10_2 then
		local var_10_3 = DB("character", var_10_2, {
			"face_id"
		})
		
		if var_10_3 and get_cocos_refid(var_10_0) then
			local var_10_4, var_10_5 = UIUtil:getPortraitAni(var_10_3, {})
			
			var_10_0:addChild(var_10_4)
			var_10_4:setLocalZOrder(1)
			var_10_4:setScale(1)
			var_10_4:setPosition(-110, -520)
			
			arg_10_0.vars.portrait = var_10_4
			
			arg_10_0:showBalloonMessage()
		end
	end
end

function SubStoryFestivalOffice.showBalloonMessage(arg_11_0)
	if not arg_11_0.vars or not get_cocos_refid(arg_11_0.vars.portrait) then
		return 
	end
	
	if not arg_11_0.vars.balloon_id then
		local var_11_0 = string.format("%s_%02d", arg_11_0.vars.substory_id, arg_11_0.vars.day)
		local var_11_1 = DB("substory_festival", var_11_0, {
			"balloon_office"
		})
		
		if var_11_1 then
			arg_11_0.vars.balloon_id = var_11_1
		end
	end
	
	if not arg_11_0.vars.balloon_id then
		return 
	end
	
	local var_11_2 = arg_11_0.vars.wnd:getChildByName("n_balloon")
	
	if get_cocos_refid(var_11_2) then
		var_11_2:setScale(0)
	end
	
	local var_11_3 = arg_11_0.vars.balloon_id .. ".enter"
	local var_11_4 = arg_11_0.vars.balloon_id .. ".idle"
	
	UIUtil:playNPCSoundAndTextRandomly(var_11_3, arg_11_0.vars.wnd, "txt_balloon", nil, var_11_4, arg_11_0.vars.portrait)
end

function SubStoryFestivalOffice.req_rewards(arg_12_0)
	if not arg_12_0.vars.can_receive then
		balloon_message_with_sound("fm_error_5")
		
		return 
	end
	
	query("substory_festival_score_reward", {
		substory_id = arg_12_0.vars.substory_id
	})
end

function SubStoryFestivalOffice.res_rewards(arg_13_0, arg_13_1)
	local var_13_0 = (arg_13_1 or {}).info or {}
	
	Account:setSubStoryFestivals(arg_13_0.vars.substory_id, var_13_0)
	
	arg_13_0.vars.festival_reward = var_13_0.festival_reward or 0
	arg_13_0.vars.festival_score = var_13_0.festival_score or 0
	
	arg_13_0:updateData()
	arg_13_0:updateUI()
end

function SubStoryFestivalOffice.close(arg_14_0)
	if not arg_14_0.vars or not get_cocos_refid(arg_14_0.vars.wnd) then
		return 
	end
	
	TopBarNew:pop()
	BackButtonManager:pop("dungeon_story_custom_office")
	UIAction:Add(SEQ(FADE_OUT(300), REMOVE(), CALL(function()
		arg_14_0.vars = nil
	end)), arg_14_0.vars.wnd, "block")
end
