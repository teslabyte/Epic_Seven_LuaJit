DungeonHunt = {}

copy_functions(DungeonCommon, DungeonHunt)

function DungeonHunt.getDungeonDBName(arg_1_0)
	return "level_battlemenu_hunt"
end

function DungeonHunt.getMainWindowScrollViewName(arg_2_0)
	return "hunt_scrollview"
end

function DungeonHunt.getBackgroundLayer(arg_3_0, arg_3_1)
	return EffectManager:Play({
		fn = "bgeff_dungeon_hunt_01",
		layer = arg_3_1:getChildByName("n_bg")
	}), true
end

function DungeonHunt.onAfterEnter(arg_4_0)
	if_set_visible(arg_4_0.vars.wnd, "back_purple", false)
	if_set_visible(arg_4_0.vars.wnd, "back_blue", true)
	if_set_visible(arg_4_0.vars.wnd, "back_green", false)
	
	local var_4_0 = arg_4_0.vars.wnd:getChildByName("n_set")
	local var_4_1 = arg_4_0:getInfo()
	
	if get_cocos_refid(var_4_0) and var_4_1 and var_4_1.dungeon_id then
		var_4_0:setVisible(true)
		
		local var_4_2 = DB(arg_4_0:getDungeonDBName(), tostring(var_4_1.dungeon_id), "set_id")
		local var_4_3 = {}
		
		for iter_4_0 = 1, 999 do
			local var_4_4 = DB("item_set_rate", string.format("%s_%02d", var_4_2, iter_4_0), "set_id")
			
			if not var_4_4 then
				break
			end
			
			table.push(var_4_3, var_4_4)
		end
		
		local var_4_5 = table.count(var_4_3)
		local var_4_6 = var_4_0:getChildByName("n_set_icons")
		
		for iter_4_1 = 1, 4 do
			local var_4_7 = "set_icon" .. iter_4_1
			
			if iter_4_1 <= var_4_5 then
				if_set_sprite(var_4_6, var_4_7, EQUIP:getSetItemIconPath(var_4_3[iter_4_1]))
			else
				if_set_visible(var_4_6, var_4_7, false)
			end
		end
		
		var_4_1.set_ids = var_4_3
		
		if var_4_5 <= 3 then
			var_4_6:setPositionX(var_4_6:getPositionX() + 22)
		end
		
		local var_4_8 = arg_4_0.vars.wnd:getChildByName("LEFT"):getChildByName("n_expedition")
		
		if_set_visible(var_4_8, nil, false)
		if_set_visible(var_4_0, "bar_visible", false)
	end
end

function DungeonHunt.onUpdateRemainTime(arg_5_0, arg_5_1)
end

function DungeonHunt.onHandler(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	if arg_6_2 == "btn_discussion" then
		local var_6_0 = arg_6_0:getInfo()
		
		if var_6_0 then
			Stove:openHuntGuidePage(var_6_0.dungeon_id, arg_6_0:getUnlockedMaxFloor())
		end
	elseif arg_6_2 == "btn_go" then
		UIUtil:checkBtnTouchPos(arg_6_1, arg_6_4, arg_6_5)
		arg_6_0:ready()
	elseif arg_6_2 == "btn_obtainable" or arg_6_2 == "btn_obtainable_ex" then
		DungeonHunt:showSetTooltip(false)
	end
end

function DungeonHunt.onHandlerBefore(arg_7_0, arg_7_1, arg_7_2)
	if arg_7_2 == "btn_obtainable" or arg_7_2 == "btn_obtainable_ex" then
		DungeonHunt:showSetTooltip(true)
	end
end

function DungeonHunt.onHandlerCancel(arg_8_0, arg_8_1, arg_8_2)
	if arg_8_2 == "btn_obtainable" or arg_8_2 == "btn_obtainable_ex" then
		DungeonHunt:showSetTooltip(false)
	end
end

function DungeonHunt.getPhase(arg_9_0, arg_9_1)
	local var_9_0 = arg_9_0:getFloorList(arg_9_1) or {}
	local var_9_1
	
	for iter_9_0 = 1, GAME_STATIC_VARIABLE.hunt_last_floor or 11 do
		local var_9_2 = var_9_0[iter_9_0]
		
		if not var_9_2 then
			break
		end
		
		if var_9_2.isLock then
			break
		end
		
		var_9_1 = var_9_2.name
	end
	
	return var_9_1
end

function DungeonHunt.showSetTooltip(arg_10_0, arg_10_1)
	UIUtil:showObtainableSetTooltip(arg_10_0.vars.wnd, arg_10_0:getInfo().set_ids, arg_10_1)
	
	if arg_10_1 then
		local var_10_0 = arg_10_0.vars.wnd:getChildByName("n_set_tooltip")
		
		var_10_0:setPositionY(0)
		
		local var_10_1 = var_10_0:getChildByName("set_bg")
		local var_10_2 = var_10_1:getPositionY() - var_10_1:getContentSize().height
		local var_10_3 = -10 - var_10_2
		
		var_10_0:setPositionY(var_10_3)
	end
end
