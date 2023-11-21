RumbleUI = {}

function HANDLER.rumble_ready(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_remove" or arg_1_1 == "btn_change" then
		local var_1_0 = arg_1_0:getParent()
		
		if var_1_0 and var_1_0.unit then
			RumbleBoard:onSelectUnit(var_1_0.unit)
		end
	elseif arg_1_1 == "btn_detail" then
		local var_1_1 = arg_1_0:getParent()
		
		if var_1_1 and var_1_1.unit then
			RumbleUnitPopup:open({
				unit = var_1_1.unit
			})
		end
	elseif arg_1_1 == "btn_transfer" then
		local var_1_2 = RumbleBoard:getSelectedUnit()
		
		if var_1_2 then
			RumblePlayer:sellUnit(var_1_2)
		end
	end
	
	if RumbleBoard:getSelectedUnit() then
		RumbleBoard:deselectUnit()
	end
	
	if arg_1_1 == "btn_go" then
		if #RumblePlayer:getTeamUnits() < 1 then
			balloon_message_with_sound("rumble_err_02")
			
			return 
		end
		
		RumbleSystem:beginBattle()
	elseif arg_1_1 == "btn_b" then
		RumbleSummon:onGacha(1)
	elseif arg_1_1 == "btn_s" then
		RumbleSummon:onGacha(2)
	elseif arg_1_1 == "btn_g" then
		RumbleSummon:onGacha(3)
	elseif arg_1_1 == "btn_expand" then
		RumbleUI:onButtonUpgrade()
	elseif arg_1_1 == "btn_damage" then
		RumbleUI:showStatistics(true)
	elseif arg_1_1 == "btn_synergy" then
		RumbleUI:showStatistics(false)
	elseif arg_1_1 == "btn_setting" then
		RumbleEsc:open()
	elseif arg_1_1 == "n_pop" then
		RumbleUI:openUnitPopup(arg_1_0.unit)
	elseif arg_1_1 == "btn_pop" then
		RumbleUI:openSynergyPopup(arg_1_0.id)
	elseif arg_1_1 == "btn_chat" then
		local var_1_3 = RumbleUI:getLayer() or SceneManager:getRunningPopupScene()
		
		ChatMain:show(var_1_3)
	elseif arg_1_1 == "btn_Help" then
		HelpGuide:open({
			contents_id = "rumblestart",
			parent = RumbleUI:getLayer()
		})
	elseif arg_1_1 == "btn_speed" then
		RumbleUI:setTimeScaleMode(true)
	elseif arg_1_1 == "btn_speed2" then
		RumbleUI:setTimeScaleMode(false)
	end
end

function RumbleUI.init(arg_2_0, arg_2_1)
	if not get_cocos_refid(arg_2_1) then
		return 
	end
	
	for iter_2_0, iter_2_1 in pairs(RumbleUI) do
		if type(iter_2_1) == "table" and iter_2_1.init then
			iter_2_1:init(arg_2_1)
		end
	end
	
	arg_2_0.vars = {}
	arg_2_0.vars.wnd = load_dlg("rumble_ready", true, "wnd", function()
		RumbleEsc:open()
	end)
	arg_2_0.vars.layer = arg_2_1
	
	arg_2_0.vars.layer:addChild(arg_2_0.vars.wnd)
	
	arg_2_0.vars.edit_mode = true
	
	arg_2_0:cache()
	arg_2_0:showStatistics(false)
	
	local var_2_0 = load_control("wnd/top_bar_token.csb", nil, true)
	
	if_set_visible(var_2_0, "bar", false)
	if_set_visible(var_2_0, "txt_max", false)
	if_set_visible(arg_2_0.vars.n_token, nil, true)
	
	local var_2_1 = var_2_0:getChildByName("icon")
	
	if get_cocos_refid(var_2_1) then
		local var_2_2 = RumbleUtil:getTokenIcon({
			zero = true,
			no_bg = true
		})
		
		var_2_1:addChild(var_2_2)
	end
	
	arg_2_0.vars.n_token:addChild(var_2_0)
	
	local var_2_3 = RumbleUtil:getTokenSprite()
	
	for iter_2_2, iter_2_3 in pairs(arg_2_0.vars.summon_btns or {}) do
		if_set_sprite(iter_2_3, "n_token", var_2_3)
	end
	
	if_set_sprite(arg_2_0.vars.n_transfer, "n_token", var_2_3)
	RumbleBench:init(arg_2_0.vars.n_herolist)
	arg_2_0:updateOffset()
	arg_2_0:update()
	arg_2_0:updateLife(true)
end

function RumbleUI.cache(arg_4_0)
	arg_4_0.vars.RIGHT = arg_4_0.vars.wnd:getChildByName("RIGHT")
	arg_4_0.vars.top_right = arg_4_0.vars.wnd:getChildByName("top_right")
	arg_4_0.vars.n_button = arg_4_0.vars.wnd:getChildByName("n_button")
	arg_4_0.vars.summon_btns = {}
	arg_4_0.vars.summon_btns[1] = arg_4_0.vars.n_button:getChildByName("btn_b")
	arg_4_0.vars.summon_btns[2] = arg_4_0.vars.n_button:getChildByName("btn_s")
	arg_4_0.vars.summon_btns[3] = arg_4_0.vars.n_button:getChildByName("btn_g")
	arg_4_0.vars.n_standby = arg_4_0.vars.wnd:getChildByName("n_standby")
	arg_4_0.vars.n_formation = arg_4_0.vars.wnd:getChildByName("n_formation")
	arg_4_0.vars.n_herolist = arg_4_0.vars.wnd:getChildByName("n_herolist")
	arg_4_0.vars.n_synergy = arg_4_0.vars.wnd:getChildByName("n_synergy")
	arg_4_0.vars.n_damage = arg_4_0.vars.wnd:getChildByName("n_damage")
	arg_4_0.vars.n_token = arg_4_0.vars.top_right:getChildByName("n_token")
	arg_4_0.vars.n_transfer = arg_4_0.vars.wnd:getChildByName("n_transfer")
	arg_4_0.vars.n_speed = arg_4_0.vars.wnd:getChildByName("n_speed")
	arg_4_0.vars.n_help = arg_4_0.vars.wnd:getChildByName("n_help")
	arg_4_0.vars.n_time = arg_4_0.vars.wnd:getChildByName("n_time")
	arg_4_0.vars.btn_go = arg_4_0.vars.wnd:getChildByName("btn_go")
	arg_4_0.vars.btn_synergy_on = arg_4_0.vars.wnd:getChildByName("btn_synergy_on")
	arg_4_0.vars.btn_damage_on = arg_4_0.vars.wnd:getChildByName("btn_damage_on")
	arg_4_0.vars.txt_title = arg_4_0.vars.wnd:getChildByName("txt_title")
	arg_4_0.vars.txt_time = arg_4_0.vars.n_time:getChildByName("txt_time")
	arg_4_0.vars.RIGHT.ox = arg_4_0.vars.RIGHT.ox or arg_4_0.vars.RIGHT:getPositionX()
	arg_4_0.vars.n_button.oy = arg_4_0.vars.n_button.oy or arg_4_0.vars.n_button:getPositionY()
	arg_4_0.vars.n_time.ox = arg_4_0.vars.n_time.ox or arg_4_0.vars.n_time:getPositionX()
	arg_4_0.vars.n_herolist.ox = arg_4_0.vars.n_herolist.ox or arg_4_0.vars.n_herolist:getPositionX()
end

function RumbleUI.getLayer(arg_5_0)
	return arg_5_0.vars and arg_5_0.vars.layer
end

function RumbleUI.update(arg_6_0)
	arg_6_0:updateSummonButton()
	arg_6_0:updateBoardCount()
	arg_6_0:updateStartButton()
	arg_6_0:updateToken()
	arg_6_0:updateSynergyInfo()
	
	if RumbleSystem:getChampionInfo() then
		arg_6_0:setTitle(T("rumble_end_champion"))
	else
		arg_6_0:setTitle(T("rumble_main_round", {
			count = RumbleSystem:getStage()
		}))
	end
end

function RumbleUI.updateOffset(arg_7_0)
	if not arg_7_0.vars then
		return 
	end
	
	if get_cocos_refid(arg_7_0.vars.n_herolist) then
		arg_7_0.vars.n_herolist:setPositionX(arg_7_0.vars.n_herolist.ox + VIEW_BASE_LEFT)
	end
	
	UIAction:Remove(arg_7_0.vars.RIGHT)
	UIAction:Remove(arg_7_0.vars.n_time)
	UIAction:Remove(arg_7_0.vars.n_button)
	if_set_visible(arg_7_0.vars.RIGHT, nil, arg_7_0.vars.edit_mode)
	if_set_visible(arg_7_0.vars.n_time, nil, not arg_7_0.vars.edit_mode)
	if_set_visible(arg_7_0.vars.n_button, nil, arg_7_0.vars.edit_mode)
	if_set_position_x(arg_7_0.vars.RIGHT, nil, arg_7_0.vars.RIGHT.ox)
	if_set_position_x(arg_7_0.vars.n_time, nil, arg_7_0.vars.n_time.ox)
	if_set_position_y(arg_7_0.vars.n_button, nil, arg_7_0.vars.n_button.oy)
	if_set_opacity(arg_7_0.vars.RIGHT, nil, 255)
	if_set_opacity(arg_7_0.vars.n_time, nil, 255)
	if_set_opacity(arg_7_0.vars.n_button, nil, 255)
end

function RumbleUI.setEditMode(arg_8_0, arg_8_1)
	if not arg_8_0.vars then
		return 
	end
	
	arg_8_0.vars.edit_mode = arg_8_1
	
	UIAction:Add(arg_8_1 and SLIDE_IN(400, -300) or SLIDE_OUT(400, 300), arg_8_0.vars.RIGHT, "block")
	UIAction:Add(arg_8_1 and SLIDE_OUT(400, 300) or SLIDE_IN(400, -300), arg_8_0.vars.n_time, "block")
	UIAction:Add(arg_8_1 and SLIDE_IN_Y(400, 200) or SLIDE_OUT_Y(400, -200), arg_8_0.vars.n_button, "block")
	RumbleBench:show(arg_8_1)
	arg_8_0:showStatistics(not arg_8_1)
end

function RumbleUI.updateSummonButton(arg_9_0)
	if not arg_9_0.vars or not get_cocos_refid(arg_9_0.vars.wnd) then
		return 
	end
	
	for iter_9_0 = 1, 3 do
		local var_9_0, var_9_1 = RumbleSummon:isAvailable(iter_9_0)
		local var_9_2 = arg_9_0.vars.summon_btns[iter_9_0]
		
		if_set(var_9_2, "txt_count", RumbleSummon:getGachaPrice(iter_9_0))
		if_set_color(var_9_2, nil, not var_9_0 and cc.c3b(91, 91, 91) or cc.c3b(255, 255, 255))
	end
end

function RumbleUI.updateStartButton(arg_10_0)
	if not arg_10_0.vars then
		return 
	end
	
	if_set_opacity(arg_10_0.vars.btn_go, nil, #RumblePlayer:getTeamUnits() < 1 and 76.5 or 255)
end

function RumbleUI.updateBenchCount(arg_11_0)
	if not arg_11_0.vars then
		return 
	end
	
	if_set(arg_11_0.vars.n_standby, "txt_count", RumbleBelt:getItemCount() .. "/" .. RumblePlayer:getBenchMax())
end

function RumbleUI.updateBoardCount(arg_12_0)
	if not arg_12_0.vars then
		return 
	end
	
	if_set(arg_12_0.vars.n_formation, "txt_count", #RumblePlayer:getTeamUnits() .. "/" .. RumblePlayer:getTeamMax())
end

function RumbleUI.updateToken(arg_13_0, arg_13_1)
	local var_13_0 = arg_13_0.vars.n_token
	
	if not get_cocos_refid(var_13_0) then
		return 
	end
	
	local var_13_1 = RumblePlayer:getGold()
	
	if var_13_0.curr_value == var_13_1 then
		return 
	end
	
	arg_13_1 = arg_13_1 or {}
	
	local var_13_2 = var_13_0:getChildByName("txt_value")
	local var_13_3 = to_n(var_13_2:getString():gsub(",", ""))
	
	UIAction:Add(INC_NUMBER(100, var_13_1, nil, var_13_3), var_13_2, "topbar.inc")
	
	if not arg_13_1.no_sound then
		SoundEngine:play("event:/ui/gold")
	end
	
	var_13_0.curr_value = var_13_1
	
	local var_13_4 = 0
	local var_13_5 = 0
	
	var_13_2:setPositionX(0)
	
	local var_13_6 = var_13_2:getString()
	
	var_13_2:setString(comma_value(var_13_1))
	
	local var_13_7 = var_13_5 + var_13_2:getContentSize().width
	
	var_13_2:setString(var_13_6)
	var_13_0:getChildByName("n_begin"):setPositionX(0 - var_13_7)
	
	local var_13_8 = var_13_0:getChildByName("btn_bg")
	local var_13_9 = var_13_8:getContentSize()
	
	var_13_9.width = var_13_7 + 40
	
	var_13_8:setContentSize(var_13_9)
end

function RumbleUI.setTitle(arg_14_0, arg_14_1)
	if not arg_14_0.vars then
		return 
	end
	
	local var_14_0 = arg_14_0.vars.txt_title
	
	if get_cocos_refid(var_14_0) then
		var_14_0:setString(arg_14_1)
		
		local var_14_1 = var_14_0:getPositionX() + var_14_0:getContentSize().width * var_14_0:getScaleX() + 15
		
		if_set_position_x(arg_14_0.vars.n_help, nil, var_14_1)
	end
end

function RumbleUI.setTimer(arg_15_0, arg_15_1)
	if not arg_15_0.vars then
		return 
	end
	
	if_set(arg_15_0.vars.txt_time, nil, T("remain_sec", {
		sec = math.floor(arg_15_1 / 1000)
	}))
end

function RumbleUI.onButtonUpgrade(arg_16_0)
	local var_16_0 = RumblePlayer:getTeamMax()
	local var_16_1 = var_16_0 + (RumbleSystem:getConfig("rumble_battlefield_add_value") or 1)
	
	if var_16_1 > (RumbleSystem:getConfig("rumble_battlefield_max") or 0) then
		balloon_message_with_sound("rumble_main_msg_teammax")
		
		return 
	end
	
	local var_16_2 = RumblePlayer:getSlotCost()
	local var_16_3 = load_dlg("msgbox_expand", true, "wnd")
	
	if_set(var_16_3, "txt_rest", var_16_2)
	if_set(var_16_3, "txt_before", var_16_0)
	if_set(var_16_3, "txt_after", var_16_1)
	if_set_sprite(var_16_3, "n_item", RumbleUtil:getTokenSprite())
	Dialog:msgBox("", {
		dlg = var_16_3,
		handler = function()
			if RumblePlayer:getGold() < var_16_2 then
				Dialog:msgBox(T("rumble_main_msg_goldneed"))
				
				return 
			end
			
			RumblePlayer:addGold(-1 * var_16_2)
			RumblePlayer:addSlot()
			RumbleUI:update()
		end,
		cost = var_16_2,
		material = RumbleSystem:getConfig("rumble_token_id")
	})
end

function RumbleUI.updateSynergyInfo(arg_18_0)
	if not arg_18_0.vars then
		return 
	end
	
	if not arg_18_0.vars.synergy_node then
		arg_18_0.vars.synergy_node = {}
	end
	
	for iter_18_0, iter_18_1 in pairs(arg_18_0.vars.synergy_node) do
		if RumbleSynergy:getSynergyLevel(iter_18_0) < 1 then
			iter_18_1:setVisible(false)
			
			iter_18_1.lv = 0
		end
	end
	
	local var_18_0 = RumbleSynergy:getCurrentSynergy()
	local var_18_1 = {}
	
	for iter_18_2, iter_18_3 in pairs(var_18_0) do
		table.insert(var_18_1, {
			id = iter_18_2,
			count = iter_18_3,
			level = RumbleSynergy:getSynergyLevel(iter_18_2)
		})
	end
	
	table.sort(var_18_1, function(arg_19_0, arg_19_1)
		if arg_19_0.count == arg_19_1.count then
			return arg_19_0.level > arg_19_1.level
		end
		
		return arg_19_0.count > arg_19_1.count
	end)
	
	local var_18_2 = 1
	
	for iter_18_4 = #var_18_1, 1, -1 do
		local var_18_3 = var_18_1[iter_18_4]
		local var_18_4 = arg_18_0:getSynergyNode(var_18_3.id)
		
		if not var_18_4 then
			break
		end
		
		if_set_visible(var_18_4, nil, true)
		
		local var_18_5 = var_18_4:getContentSize()
		local var_18_6 = to_n(var_18_3.level)
		local var_18_7 = RumbleSynergy:getSynergyMaxLevel(var_18_3.id)
		
		if_set_visible(var_18_4, "n_" .. var_18_7, true)
		
		for iter_18_5 = 1, var_18_7 do
			if_set_visible(var_18_4, "n_" .. iter_18_5 .. "/" .. var_18_7, iter_18_5 <= var_18_6)
		end
		
		local var_18_8 = var_18_6 > 0 and "<#ff7800>" or "<#888888>"
		local var_18_9 = RumbleSynergy:getSynergyMaxCount(var_18_3.id)
		
		if_set(var_18_4, "txt_count", var_18_8 .. var_18_3.count .. "</><#888888>/" .. var_18_9 .. "</>")
		if_set_color(var_18_4, "icon_synergy", var_18_6 > 0 and cc.c3b(255, 255, 255) or cc.c3b(136, 136, 136))
		
		local var_18_10 = arg_18_0.vars.n_synergy:getChildByName("n_" .. var_18_2)
		
		if get_cocos_refid(var_18_10) then
			if_set_position(var_18_4, nil, var_18_10:getPositionX(), var_18_10:getPositionY())
		end
		
		if var_18_6 > to_n(var_18_4.lv) then
			local var_18_11 = var_18_4:getChildByName("n_eff")
			
			if get_cocos_refid(var_18_11) then
				var_18_11:removeAllChildren()
				EffectManager:Play({
					fn = "ui_rumble_synergy.cfx",
					layer = var_18_11,
					x = var_18_5.width * 0.5,
					y = var_18_5.height * 0.5
				})
			end
		end
		
		var_18_4.lv = var_18_6
		var_18_2 = var_18_2 + 1
	end
end

function RumbleUI.onSelectUnit(arg_20_0, arg_20_1)
	if not arg_20_0.vars or not arg_20_1 then
		return 
	end
	
	local function var_20_0(arg_21_0)
		if not get_cocos_refid(arg_21_0) then
			return 
		end
		
		local var_21_0 = arg_21_0:getChildByName("n_noti")
		
		if not get_cocos_refid(var_21_0) then
			return 
		end
		
		UIAction:Add(LOOP(RumbleUtil:getOpacityAct(2000, 1, 0.4, var_21_0)), var_21_0, "rumble.synergy_noti")
		var_21_0:setVisible(true)
		var_21_0:setOpacity(255)
	end
	
	local var_20_1 = arg_20_0:getSynergyNode(arg_20_1:getRole())
	
	var_20_0(var_20_1)
	
	local var_20_2 = arg_20_0:getSynergyNode(arg_20_1:getCamp())
	
	var_20_0(var_20_2)
	arg_20_0:showFormationUI(arg_20_1)
end

function RumbleUI.onDeselectUnit(arg_22_0, arg_22_1)
	arg_22_0:clearFormationUI()
	UIAction:Remove("rumble.synergy_noti")
	
	if not arg_22_0.vars or not arg_22_1 then
		return 
	end
	
	local var_22_0 = arg_22_0:getSynergyNode(arg_22_1:getRole())
	local var_22_1 = arg_22_0:getSynergyNode(arg_22_1:getCamp())
	
	if_set_visible(var_22_0, "n_noti", false)
	if_set_visible(var_22_1, "n_noti", false)
end

function RumbleUI.getSynergyNode(arg_23_0, arg_23_1)
	if not arg_23_0.vars then
		return 
	end
	
	if not arg_23_0.vars.synergy_node then
		arg_23_0.vars.synergy_node = {}
	end
	
	local var_23_0 = arg_23_0.vars.synergy_node[arg_23_1]
	
	if not var_23_0 then
		var_23_0 = load_control("wnd/rumble_ready_synergy.csb", nil, true)
		
		local var_23_1 = RumbleSynergy:getSynergyIcon(arg_23_1)
		
		if_set_sprite(var_23_0, "icon_synergy", var_23_1)
		if_set_visible(var_23_0, "n_noti", false)
		upgradeLabelToRichLabel(var_23_0, "txt_count", true)
		
		arg_23_0.vars.synergy_node[arg_23_1] = var_23_0
		
		arg_23_0.vars.n_synergy:addChild(var_23_0)
		var_23_0:setVisible(false)
		
		local var_23_2 = var_23_0:getChildByName("btn_pop")
		
		if get_cocos_refid(var_23_2) then
			var_23_2.id = arg_23_1
		end
	end
	
	return var_23_0
end

function RumbleUI.updateStatistics(arg_24_0)
	local var_24_0 = RumbleStat:getStatistics("atk") or {}
	local var_24_1 = 1
	
	for iter_24_0 = #var_24_0, 1, -1 do
		local var_24_2 = var_24_0[iter_24_0]
		local var_24_3 = arg_24_0:getStatNode(var_24_2)
		
		if not get_cocos_refid(var_24_3) then
			break
		end
		
		local var_24_4 = arg_24_0.vars.n_damage:getChildByName("n_" .. var_24_1)
		
		if get_cocos_refid(var_24_4) then
			if_set_position(var_24_3, nil, var_24_4:getPositionX(), var_24_4:getPositionY())
		end
		
		local var_24_5 = var_24_3:getChildByName("txt_count")
		local var_24_6 = var_24_3:getChildByName("n_count_move")
		
		if not var_24_5.org_x then
			var_24_5.org_x, var_24_5.org_y = var_24_5:getPosition()
		end
		
		if iter_24_0 == 1 then
			var_24_5:setPosition(var_24_6:getPosition())
		else
			var_24_5:setPosition(var_24_5.org_x, var_24_5.org_y)
		end
		
		if_set(var_24_5, nil, comma_value(var_24_2.value))
		if_set_visible(var_24_3, "txt_1", iter_24_0 == 1)
		
		var_24_1 = var_24_1 + 1
	end
end

function RumbleUI.getStatNode(arg_25_0, arg_25_1)
	if not arg_25_0.vars then
		return 
	end
	
	if not arg_25_0.vars.stat_node then
		arg_25_0.vars.stat_node = {}
	end
	
	local var_25_0 = arg_25_1.uid
	local var_25_1 = arg_25_0.vars.stat_node[var_25_0]
	
	if not var_25_1 then
		var_25_1 = load_control("wnd/rumble_ready_hero.csb", nil, true)
		
		local var_25_2 = var_25_1:getChildByName("n_mob_icon")
		local var_25_3 = RumbleUtil:getHeroIcon(arg_25_1.unit:getCode(), {
			no_star = true
		})
		
		if get_cocos_refid(var_25_3) then
			var_25_2:addChild(var_25_3)
		end
		
		local var_25_4 = var_25_1:getChildByName("n_pop")
		
		if get_cocos_refid(var_25_4) then
			var_25_4.unit = arg_25_1.unit
		end
		
		arg_25_0.vars.stat_node[var_25_0] = var_25_1
		
		arg_25_0.vars.n_damage:addChild(var_25_1)
	end
	
	return var_25_1
end

function RumbleUI.resetStatNode(arg_26_0)
	if arg_26_0.vars and arg_26_0.vars.stat_node then
		for iter_26_0, iter_26_1 in pairs(arg_26_0.vars.stat_node) do
			if get_cocos_refid(iter_26_1) then
				iter_26_1:removeFromParent()
			end
			
			arg_26_0.vars.stat_node[iter_26_0] = nil
		end
	end
end

function RumbleUI.showStatistics(arg_27_0, arg_27_1)
	if not arg_27_0.vars then
		return 
	end
	
	if arg_27_0.vars.show_stat == arg_27_1 then
		return 
	end
	
	arg_27_0.vars.show_stat = arg_27_1
	
	if not get_cocos_refid(arg_27_0.vars.n_synergy) then
		return 
	end
	
	if not get_cocos_refid(arg_27_0.vars.n_damage) then
		return 
	end
	
	local var_27_0 = arg_27_1 and arg_27_0.vars.n_damage or arg_27_0.vars.n_synergy
	local var_27_1 = arg_27_1 and arg_27_0.vars.n_synergy or arg_27_0.vars.n_damage
	
	if_set_visible(arg_27_0.vars.btn_synergy_on, nil, not arg_27_1)
	if_set_visible(arg_27_0.vars.btn_damage_on, nil, arg_27_1)
	var_27_0:setVisible(true)
	UIAction:Add(SLIDE_IN(200, 300), var_27_0, "block")
	UIAction:Add(SLIDE_OUT(200, -300), var_27_1, "block")
end

function RumbleUI.openUnitPopup(arg_28_0, arg_28_1)
	if not arg_28_0.vars or not get_cocos_refid(arg_28_0.vars.wnd) then
		return 
	end
	
	local var_28_0 = arg_28_0.vars.wnd:getChildByName("n_unit_pop")
	
	RumbleUnitPopup:open({
		no_dim = true,
		layer = var_28_0,
		unit = arg_28_1
	})
end

function RumbleUI.openSynergyPopup(arg_29_0, arg_29_1)
	if not arg_29_0.vars or not get_cocos_refid(arg_29_0.vars.wnd) then
		return 
	end
	
	local var_29_0 = arg_29_0.vars.wnd:getChildByName("n_synergy_pop")
	
	RumbleSynergyPopup:open({
		no_dim = true,
		layer = var_29_0,
		id = arg_29_1
	})
end

function RumbleUI.updateLife(arg_30_0, arg_30_1)
	if not arg_30_0.vars or not get_cocos_refid(arg_30_0.vars.wnd) then
		return 
	end
	
	local var_30_0 = RumblePlayer:getLife()
	local var_30_1 = arg_30_0.vars.wnd:getChildByName("n_life")
	
	if not get_cocos_refid(var_30_1) then
		return 
	end
	
	for iter_30_0 = 1, 3 do
		if_set_visible(var_30_1, "n_" .. iter_30_0, iter_30_0 <= var_30_0)
	end
	
	if not arg_30_1 and var_30_0 < arg_30_0.vars.life then
		for iter_30_1 = var_30_0 + 1, arg_30_0.vars.life do
			local var_30_2 = var_30_1:getChildByName("slot_" .. iter_30_1)
			
			EffectManager:Play({
				x = 11,
				y = 10,
				fn = "ui_rumble_heart_break.cfx",
				layer = var_30_2
			})
		end
	end
	
	arg_30_0.vars.life = var_30_0
end

function RumbleUI.showFormationUI(arg_31_0, arg_31_1)
	if not arg_31_0.vars or not get_cocos_refid(arg_31_0.vars.wnd) then
		return 
	end
	
	arg_31_0.vars.formation_ui = {}
	
	local var_31_0 = 22
	local var_31_1 = arg_31_0.vars.wnd:getChildByName("selected_btn")
	local var_31_2 = RumbleBoard:getUnits()
	
	for iter_31_0, iter_31_1 in ipairs(var_31_2 or {}) do
		local var_31_3 = iter_31_1 == arg_31_1
		local var_31_4 = iter_31_1:getUnitNode()
		
		if get_cocos_refid(var_31_4) then
			local var_31_5 = SceneManager:convertToSceneSpace(var_31_4, {
				x = 0,
				y = 0
			})
			local var_31_6 = var_31_1:clone()
			
			var_31_6.unit = iter_31_1
			
			if_set_visible(var_31_6, "btn_change", not var_31_3)
			if_set_visible(var_31_6, "btn_detail", var_31_3)
			if_set_visible(var_31_6, "btn_remove", var_31_3)
			var_31_6:setPosition(var_31_5.x, var_31_5.y + var_31_0)
			var_31_6:setVisible(true)
			arg_31_0.vars.wnd:addChild(var_31_6)
			table.insert(arg_31_0.vars.formation_ui, var_31_6)
		end
	end
	
	arg_31_0:showSellUI(true)
end

function RumbleUI.clearFormationUI(arg_32_0)
	if not arg_32_0.vars or not get_cocos_refid(arg_32_0.vars.wnd) then
		return 
	end
	
	for iter_32_0, iter_32_1 in pairs(arg_32_0.vars.formation_ui or {}) do
		if get_cocos_refid(iter_32_1) then
			iter_32_1:removeFromParent()
		end
	end
	
	arg_32_0.vars.formation_ui = nil
	
	arg_32_0:showSellUI(false)
end

function RumbleUI.showSellUI(arg_33_0, arg_33_1)
	if not arg_33_0.vars or not get_cocos_refid(arg_33_0.vars.n_transfer) then
		return 
	end
	
	UIAction:Remove("rumble.sell")
	
	if arg_33_1 then
		local var_33_0 = RumbleBoard:getSelectedUnit()
		
		if_set(arg_33_0.vars.n_transfer, "txt_count", "+" .. (var_33_0 and var_33_0:getSellPrice() or 0))
		
		local var_33_1 = arg_33_0.vars.n_transfer:getChildByName("n_eff")
		local var_33_2 = arg_33_0.vars.n_transfer:getChildByName("n_eff2")
		
		UIAction:Add(LOOP(RumbleUtil:getOpacityAct(2000, 1, 0.4, var_33_1)), var_33_1, "rumble.sell")
		UIAction:Add(LOOP(RumbleUtil:getOpacityAct(2000, 1, 0.8, var_33_2)), var_33_2, "rumble.sell")
	end
	
	if_set_visible(arg_33_0.vars.n_transfer, nil, arg_33_1)
end

function RumbleUI.setTimeScaleMode(arg_34_0, arg_34_1)
	if not arg_34_0.vars then
		return 
	end
	
	RumbleSystem:setTimeScaleMode(arg_34_1)
	if_set_visible(arg_34_0.vars.n_speed, "btn_speed", not arg_34_1)
	if_set_visible(arg_34_0.vars.n_speed, "btn_speed2", arg_34_1)
end
