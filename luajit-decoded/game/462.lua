BattleSelectDiffculty = {}
BattleSelectDiffcultyUtil = BattleSelectDiffcultyUtil or {}

function BattleSelectDiffcultyUtil.updateLimit(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0, var_1_1 = Account:getEnterLimitInfo(arg_1_2)
	
	if var_1_0 and var_1_1 then
		local var_1_2 = arg_1_1:getChildByName("n_limit")
		
		if var_1_2 then
			var_1_2:setVisible(true)
			
			local var_1_3 = var_1_0 == nil or var_1_0 > 0
			local var_1_4
			
			if var_1_3 then
				var_1_4 = "level_enter_limit_desc"
				
				local var_1_5 = string.format("%d/%d", math.min(var_1_1, math.max(var_1_0, 0)), var_1_1)
				
				if_set(var_1_2, "t_count", var_1_5)
			else
				var_1_4 = "battle_cant_getin"
				
				if_set_visible(var_1_2, "t_count", false)
			end
			
			if_set(var_1_2, "disc", T(var_1_4))
			
			local var_1_6 = var_1_2:getChildByName("t_count")
			local var_1_7 = var_1_2:getChildByName("disc")
			
			var_1_6:setPositionX(var_1_7:getContentSize().width + 7)
			
			local var_1_8 = var_1_4 == "level_enter_limit_desc" and 60 or 20
			
			if arg_1_1.getName and arg_1_1:getName() == "dungeon_story_challenge2_item" and var_1_1 >= 10 then
				var_1_8 = var_1_8 + 8
				
				if var_1_0 >= 10 then
					var_1_8 = var_1_8 + 8
				end
			end
			
			UIUserData:call(var_1_2:getChildByName("talk_small_bg"), string.format("AUTOSIZE_WIDTH(disc, 1, %d)", var_1_8))
		end
	end
end

function BattleSelectDiffculty.save(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0
	
	if arg_2_3 and arg_2_2 and arg_2_1 then
		var_2_0 = arg_2_2 + 1
	elseif arg_2_0.vars then
		var_2_0 = arg_2_0.vars.index
		arg_2_1 = arg_2_0.vars.difficulty_id
	else
		return 
	end
	
	SAVE:set("difficulty." .. arg_2_1, var_2_0)
end

function BattleSelectDiffculty.setListViewData(arg_3_0, arg_3_1)
	local var_3_0 = {}
	local var_3_1 = tonumber(SAVE:get("difficulty." .. arg_3_0.vars.difficulty_id, 1))
	
	table.insert(var_3_0, {
		index = 1,
		id = arg_3_1
	})
	
	for iter_3_0 = 1, 3 do
		local var_3_2 = DB("level_difficulty", arg_3_1, "difficulty_" .. iter_3_0)
		
		if not var_3_2 then
			break
		end
		
		table.insert(var_3_0, {
			id = var_3_2,
			index = iter_3_0 + 1
		})
	end
	
	arg_3_0.vars.listView:setDataSource(var_3_0)
	
	arg_3_0.vars.diffcultys = var_3_0
	
	if var_3_1 == nil then
		var_3_0[1].flag = true
		
		arg_3_0:selectItem(1, var_3_0[1])
	else
		var_3_0[var_3_1].flag = true
		
		arg_3_0:selectItem(var_3_1, var_3_0[var_3_1])
	end
end

function BattleSelectDiffculty.setListView(arg_4_0, arg_4_1)
	arg_4_0.vars.listViewCtrl = arg_4_1:getChildByName("scrollview_difficulty")
	arg_4_0.vars.listView = ItemListView_v2:bindControl(arg_4_0.vars.listViewCtrl)
	
	local var_4_0 = {
		onTouchUp = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
			if arg_5_4.cancelled then
				return 
			end
		end,
		onTouchDown = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
			arg_4_0:selectItem(arg_6_2, arg_6_3)
		end,
		onUpdate = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
			arg_4_0:updateListViewItem(arg_7_1, arg_7_3)
		end
	}
	local var_4_1 = load_control("wnd/battle_ready_difficulty_card.csb")
	
	if arg_4_0.vars.listViewCtrl.STRETCH_INFO then
		local var_4_2 = arg_4_0.vars.listViewCtrl:getContentSize()
		
		resetControlPosAndSize(var_4_1, var_4_2.width, arg_4_0.vars.listViewCtrl.STRETCH_INFO.width_prev)
	end
	
	if_set_visible(var_4_1, "dim", false)
	if_set_visible(var_4_1, "selected", false)
	arg_4_0.vars.listView:setRenderer(var_4_1, var_4_0)
	TutorialGuide:procGuide("substory_hurdle")
end

function BattleSelectDiffculty.isGotoFormation(arg_8_0)
	if arg_8_0.vars and arg_8_0.vars.opts then
		return arg_8_0.vars.opts.isGotoFormation
	end
	
	return false
end

function BattleSelectDiffculty.clear(arg_9_0)
	arg_9_0.vars = nil
end

function BattleSelectDiffculty.show(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	arg_10_0.vars = {}
	arg_10_0.vars.parent = arg_10_1
	arg_10_0.vars.difficulty_id = arg_10_2
	arg_10_0.vars.flag = true
	arg_10_0.vars.opts = {}
	
	local var_10_0 = arg_10_1:getChildByName("btn_select_team")
	
	if arg_10_3 then
		arg_10_0.vars.opts.isGotoFormation = arg_10_3
		
		if_set(var_10_0, "label", T("hell_ready"))
	else
		arg_10_0.vars.opts.isGotoFormation = false
		
		if_set(var_10_0, "label", T("ui_battle_ready_title"))
	end
	
	arg_10_0:setListView(arg_10_1)
	arg_10_0:setListViewData(arg_10_2)
end

function BattleSelectDiffculty.selectItem(arg_11_0, arg_11_1, arg_11_2)
	if arg_11_0.vars.index == arg_11_1 then
		return 
	end
	
	if Account:checkEnterMap(arg_11_0.vars.diffcultys[arg_11_1].id) then
		arg_11_0.vars.index = arg_11_1
		
		BattleReady:setDifficulty(arg_11_1 - 1)
		BattleReady:updateButtons()
		
		for iter_11_0, iter_11_1 in pairs(arg_11_0.vars.diffcultys) do
			local var_11_0 = arg_11_0.vars.listView:getControl(iter_11_1)
			
			if get_cocos_refid(var_11_0) then
				if_set_visible(var_11_0, "selected", iter_11_0 == arg_11_1)
			end
		end
	else
		local var_11_1 = DB("level_enter", arg_11_2.id, "req_map_msg")
		
		balloon_message_with_sound(var_11_1)
	end
end

function BattleSelectDiffculty.updateListViewItem(arg_12_0, arg_12_1, arg_12_2)
	if arg_12_2.flag then
		if_set_visible(arg_12_1, "selected", true)
	end
	
	if Account:isMapCleared(arg_12_2.id) then
		if_set_visible(arg_12_1, "icon_clear", true)
	end
	
	BattleSelectDiffcultyUtil:updateLimit(arg_12_1, arg_12_2.id)
	
	for iter_12_0 = 1, 4 do
		if_set_visible(arg_12_1, "bg" .. iter_12_0, arg_12_2.index == iter_12_0)
		if_set_visible(arg_12_1, tostring(iter_12_0), arg_12_2.index == iter_12_0)
	end
	
	if not Account:checkEnterMap(arg_12_2.id) then
		if_set_opacity(arg_12_1, "card", 76.5)
		if_set_color(arg_12_1, "n_limit", tocolor("#888888"))
	end
	
	local var_12_0 = {
		"ui_battle_ready_difficulty_easy",
		"ui_battle_ready_difficulty_normal",
		"ui_battle_ready_difficulty_hard",
		"ui_battle_ready_difficulty_hell"
	}
	
	if_set(arg_12_1, "t_difficulty", T(var_12_0[arg_12_2.index]))
	
	local var_12_1 = DB("level_enter", arg_12_2.id, "use_enterpoint")
	local var_12_2 = BattleReady:GetReqPointAndRewards(arg_12_2.id)
	
	if_set(arg_12_1, "t_stamina", tostring(var_12_1))
	if_set(arg_12_1, "t_power", comma_value(var_12_2))
	
	arg_12_1.guide_tag = arg_12_2.id
end
