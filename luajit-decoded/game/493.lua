SanctuaryForest = {}
SanctuaryMain.MODE_LIST.Forest = SanctuaryForest

function MsgHandler.forest_start(arg_1_0)
	Account:setForestState(arg_1_0.forest_attributes)
	SanctuaryForest:onEnter(SanctuaryForest.vars.root_layer)
	SanctuaryForest:updatePushNoti(false, LOCAL_PUSH_IDS.FOREST_MURA_GET)
	SanctuaryForest:updatePushNoti(true, LOCAL_PUSH_IDS.FOREST_PENGUIN)
	SanctuaryForest:updatePushNoti(true, LOCAL_PUSH_IDS.FOREST_SPIRIT)
end

function MsgHandler.forest_mura_farm_receive(arg_2_0)
	if arg_2_0.forest_info then
		Account:setForestStateUseCode(arg_2_0.forest_info.code, arg_2_0.forest_info)
	end
	
	arg_2_0.play_cinematic = true
	
	SanctuaryForest:recieveItem(arg_2_0)
	SanctuaryForest:updatePushNoti(false, LOCAL_PUSH_IDS.FOREST_MURA_GET)
end

function MsgHandler.forest_mura_water(arg_3_0)
	if arg_3_0.forest_info then
		Account:setForestStateUseCode(arg_3_0.forest_info.code, arg_3_0.forest_info)
	end
	
	SanctuaryForest:playWaterEffect()
	SanctuaryForest:updatePushNoti(false, LOCAL_PUSH_IDS.FOREST_MURA_GET)
end

function MsgHandler.forest_farm_immediate(arg_4_0)
	if arg_4_0.forest_info then
		Account:setForestStateUseCode(arg_4_0.forest_info.code, arg_4_0.forest_info)
	end
	
	SanctuaryForest:recieveItem(arg_4_0)
end

function MsgHandler.forest_farm_receive(arg_5_0)
	if arg_5_0.forest_info then
		Account:setForestStateUseCode(arg_5_0.forest_info.code, arg_5_0.forest_info)
	end
	
	arg_5_0.play_cinematic = true
	
	SanctuaryForest:recieveItem(arg_5_0)
	
	local var_5_0
	
	if arg_5_0.forest_info then
		var_5_0 = arg_5_0.forest_info.code
	end
	
	SanctuaryForest:updatePushNoti(true, var_5_0 == SanctuaryForest.Type.Penguin and LOCAL_PUSH_IDS.FOREST_PENGUIN or LOCAL_PUSH_IDS.FOREST_SPIRIT)
end

function ErrHandler.forest_farm_receive(arg_6_0, arg_6_1, arg_6_2)
	if arg_6_1 == "not_yot_time" then
		balloon_message_with_sound("error_try_again")
		
		return 
	end
	
	on_net_error(arg_6_0, arg_6_1, arg_6_2)
end

function ErrHandler.forest_mura_farm_receive(arg_7_0, arg_7_1, arg_7_2)
	if arg_7_1 == "not_yot_time" then
		balloon_message_with_sound("error_try_again")
		
		return 
	end
	
	on_net_error(arg_7_0, arg_7_1, arg_7_2)
end

function ErrHandler.forest_mura_water(arg_8_0, arg_8_1, arg_8_2)
	if arg_8_1 == "limit_start_time" or arg_8_1 == "limit_water_time" then
		balloon_message_with_sound("error_try_again")
		
		return 
	end
	
	on_net_error(arg_8_0, arg_8_1, arg_8_2)
end

function HANDLER.sanctuary_forest(arg_9_0, arg_9_1)
	if arg_9_1 == "btn_penguin_nest" then
		if not SanctuaryForest:isHarvestable(SanctuaryForest.Type.Penguin) then
			SanctuaryForest:showInfoPopUp(SanctuaryForest.Type.Penguin)
		else
			query("forest_farm_receive", {
				key = SanctuaryForest.Type.Penguin
			})
		end
	elseif arg_9_1 == "btn_sprit_fountain" then
		if not SanctuaryForest:isHarvestable(SanctuaryForest.Type.Spirit) then
			SanctuaryForest:showInfoPopUp(SanctuaryForest.Type.Spirit)
		else
			query("forest_farm_receive", {
				key = SanctuaryForest.Type.Spirit
			})
		end
	elseif arg_9_1 == "btn_marragora" then
		if SanctuaryForest:canWaterTheMura() then
			query("forest_mura_water")
		elseif SanctuaryForest:isHarvestable(SanctuaryForest.Type.Mura) then
			query("forest_mura_farm_receive")
		else
			SanctuaryForest:showInfoPopUp(SanctuaryForest.Type.Mura)
		end
	elseif arg_9_1 == "btn_sprit_altar" then
		SanctuaryForest:showAlterPopUp()
	end
end

function HANDLER.sanctuary_forest_popup(arg_10_0, arg_10_1)
	if arg_10_1 == "btn_close" then
		SanctuaryForest:closePopUp()
	end
end

function HANDLER.sanctuary_forest_popup_item(arg_11_0, arg_11_1)
	if string.starts(arg_11_1, "btn_cost") then
		if (Account:isCurrencyType("to_stigma") or Account:isMaterialCurrencyType("to_stigma")) and UIUtil:checkCurrencyDialog("to_stigma", arg_11_0.data.price) ~= true then
			return 
		end
		
		if arg_11_0.data.count > 1 then
			Dialog:openDailySkipPopup("sanctuary.stop_watching", {
				info = "ui_forest_x10_desc2",
				title = "ui_forest_x10_title",
				desc = "ui_forest_x10_desc1",
				func = function()
					query("forest_farm_immediate", {
						key = arg_11_0.data.key,
						count = arg_11_0.data.count
					})
				end
			})
		else
			query("forest_farm_immediate", {
				key = arg_11_0.data.key,
				count = arg_11_0.data.count
			})
		end
	end
end

function HANDLER.sanctuary_forest_info_popup(arg_13_0, arg_13_1)
	if arg_13_1 == "btn_close" then
		if TutorialGuide:isPlayingTutorial() then
			TutorialGuide:procGuide()
		end
		
		SanctuaryForest:closePopUp()
	elseif arg_13_1 == "btn_block" and TutorialGuide:isPlayingTutorial() then
		TutorialGuide:procGuide()
		SanctuaryForest:closePopUp()
	end
end

function SanctuaryForest.isForestStateNeedUpdate(arg_14_0)
	local var_14_0 = Account:getForestState()
	
	if SanctuaryMain:GetLevels("Forest")[2] > 0 then
		if not var_14_0.f_pen then
			return true
		end
		
		if not var_14_0.f_spirit then
			return true
		end
	end
	
	if not var_14_0.f_mura then
		return true
	end
	
	return false
end

function SanctuaryForest.playWaterEffect(arg_15_0)
	local var_15_0 = arg_15_0.vars.wnd:getChildByName("n_time")
	
	arg_15_0.vars.n_water_time_origin_pos = arg_15_0.vars.n_water_time_origin_pos or {
		x = var_15_0:getPositionX(),
		y = var_15_0:getPositionY()
	}
	
	var_15_0:setPosition(arg_15_0.vars.n_water_time_origin_pos.x, arg_15_0.vars.n_water_time_origin_pos.y)
	var_15_0:setOpacity(0)
	var_15_0:setVisible(true)
	if_set(var_15_0, "t_time", T("ui_mura_time_reduction"))
	UIAction:Add(SEQ(SPAWN(FADE_IN(200), LOG(MOVE_BY(800, 0, 20)), LOG(SCALE(200, 0, 1))), DELAY(1000), SPAWN(FADE_OUT(200), LOG(MOVE_BY(800, 0, 40)), LOG(SCALE(200, 1, 0.5)))), var_15_0, "block")
	
	local var_15_1 = EffectManager:Play({
		fn = "ui_eff_spforest_new_mura_enchant.cfx",
		layer = arg_15_0.vars.wnd:getChildByName("n_mura_water_eff")
	})
	
	UIAction:Add(SEQ(DELAY(2000), CALL(function()
		if get_cocos_refid(var_15_1) then
			var_15_1:removeFromParent()
		end
	end)), arg_15_0.vars.wnd, "block")
end

function SanctuaryForest.updateForestObject(arg_17_0, arg_17_1, arg_17_2)
	if not arg_17_0.vars then
		return 
	end
	
	arg_17_0.vars.forest_objects = arg_17_0.vars.forest_objects or {}
	arg_17_0.vars.forest_objects[arg_17_1] = arg_17_0.vars.forest_objects[arg_17_1] or {}
	
	local var_17_0 = arg_17_1
	
	if arg_17_1 == SanctuaryForest.Type.Spirit then
		var_17_0 = SanctuaryForest.Type.Element_1
	end
	
	local var_17_1 = arg_17_0:getFrontData()[var_17_0]
	local var_17_2 = Account:getForestState()[arg_17_1]
	
	if not var_17_2 or not var_17_1 then
		return 
	end
	
	local var_17_3 = SanctuaryMain:GetLevels("Forest")
	local var_17_4
	local var_17_5 = os.time()
	local var_17_6 = arg_17_0:getSancUpgradeInfo()["forest_2_" .. SanctuaryMain:GetLevels("Forest")[3]].value_1
	
	var_17_6 = arg_17_1 ~= SanctuaryForest.Type.Mura and var_17_6 or 1
	
	local var_17_7 = math.ceil((var_17_1.produce1_end + var_17_1.produce2_end) * var_17_6)
	local var_17_8 = math.ceil(var_17_7 / 2)
	
	if arg_17_1 ~= SanctuaryForest.Type.Mura then
		if var_17_5 > var_17_2.start_time + var_17_7 then
			var_17_4 = 3
		elseif var_17_5 > var_17_2.start_time + var_17_8 then
			var_17_4 = 2
		elseif var_17_5 <= var_17_2.start_time + var_17_8 then
			var_17_4 = 1
		end
		
		if arg_17_2 then
			print("per = ", var_17_6)
			print(os.date("start = %y, %m , %d , %H:%M:%S", var_17_2.start_time))
			print(os.date("end = %y, %m , %d , %H:%M:%S", var_17_2.start_time + var_17_7))
			print(os.date("half = %y, %m , %d , %H:%M:%S", var_17_2.start_time + var_17_8))
			print(os.date("now = %y, %m , %d , %H:%M:%S", var_17_5))
		end
	else
		local var_17_9 = var_17_2.start_time + var_17_1.time - var_17_2.water_count * var_17_1.grow_shorten_time
		local var_17_10 = math.ceil((var_17_1.produce1_end + var_17_1.produce2_end - var_17_2.water_count * var_17_1.grow_shorten_time) / 2)
		
		var_17_4 = var_17_5 > var_17_2.start_time and var_17_9 < var_17_5 and 3 or arg_17_0:isRestTime() and 4 or var_17_5 > var_17_2.start_time + var_17_10 and 2 or 1
		
		if arg_17_2 then
			print("water_count = ", var_17_2.water_count)
			print(os.date("start = %y, %m , %d , %H:%M:%S", var_17_2.start_time))
			print(os.date("end = %y, %m , %d , %H:%M:%S", var_17_9))
			print(os.date("half = %y, %m , %d , %H:%M:%S", var_17_2.start_time + var_17_10))
			print(os.date("now = %y, %m , %d , %H:%M:%S", var_17_5))
		end
	end
	
	if arg_17_2 then
		print(arg_17_1, var_17_4)
	end
	
	local var_17_11
	
	if arg_17_1 == SanctuaryForest.Type.Mura then
		var_17_11 = arg_17_0.vars.wnd:getChildByName("n_marragora")
	elseif arg_17_1 == SanctuaryForest.Type.Spirit then
		var_17_11 = arg_17_0.vars.wnd:getChildByName("n_sprit_fountain")
	elseif arg_17_1 == SanctuaryForest.Type.Penguin then
		var_17_11 = arg_17_0.vars.wnd:getChildByName("n_penguin_nest")
	end
	
	local var_17_12 = var_17_11:getChildByName("n_effect")
	
	for iter_17_0 = 3, 1, -1 do
		local var_17_13 = arg_17_0.vars.forest_objects[arg_17_1][iter_17_0]
		local var_17_14
		
		if var_17_13 then
			if var_17_13.state ~= var_17_4 then
				var_17_14 = true
			end
		else
			var_17_14 = true
		end
		
		local var_17_15
		
		if arg_17_1 ~= SanctuaryForest.Type.Mura and iter_17_0 > var_17_3[2] then
			var_17_15 = true
		end
		
		if var_17_15 then
			if var_17_13 and var_17_13.effect and get_cocos_refid(var_17_13.effect) then
				var_17_13.effect:removeFromParent()
			end
			
			arg_17_0.vars.forest_objects[arg_17_1][iter_17_0] = nil
		elseif var_17_14 then
			if var_17_13 and var_17_13.effect and get_cocos_refid(var_17_13.effect) then
				var_17_13.effect:removeFromParent()
			end
			
			local var_17_16 = 4 - iter_17_0
			local var_17_17 = var_17_12:getChildByName("n_effect0" .. iter_17_0)
			
			if get_cocos_refid(var_17_17) then
				local var_17_18 = var_17_1.stat_cfx
				
				if arg_17_1 ~= SanctuaryForest.Type.Mura then
					if var_17_16 == 3 then
						var_17_18 = var_17_18 .. "_center_"
					elseif var_17_16 == 2 then
						var_17_18 = var_17_18 .. "_left_"
					elseif var_17_16 == 1 then
						var_17_18 = var_17_18 .. "_right_"
					end
					
					if arg_17_1 == SanctuaryForest.Type.Penguin and var_17_4 == 1 then
						var_17_18 = var_17_18 .. "2"
					else
						var_17_18 = var_17_18 .. var_17_4
					end
				else
					var_17_18 = var_17_18 .. "_" .. var_17_4
				end
				
				if var_17_4 ~= 4 then
					var_17_13 = {
						effect = EffectManager:Play({
							delay = 0,
							fn = var_17_18,
							layer = var_17_17
						}),
						state = var_17_4
					}
				end
				
				arg_17_0.vars.forest_objects[arg_17_1][iter_17_0] = var_17_13
			end
		end
	end
	
	return arg_17_0.vars.forest_objects[arg_17_1], var_17_4
end

function SanctuaryForest.updateUI(arg_18_0)
	if not arg_18_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_18_0.vars.wnd) then
		return 
	end
	
	if_set(arg_18_0.vars.wnd:getChildByName("n_sprit_altar"), "t_title", T(arg_18_0:getFrontData().f_growth.title))
	if_set(arg_18_0.vars.wnd:getChildByName("n_sprit_fountain"), "t_title", T(arg_18_0:getFrontData().f_spirit.title))
	if_set(arg_18_0.vars.wnd:getChildByName("n_marragora"), "t_title", T(arg_18_0:getFrontData().f_mura.title))
	if_set(arg_18_0.vars.wnd:getChildByName("n_penguin_nest"), "t_title", T(arg_18_0:getFrontData().f_pen.title))
	
	local var_18_0 = SanctuaryMain:GetLevels("Forest")
	
	if_set_visible(arg_18_0.vars.wnd, "un_lock_01", var_18_0[2] and var_18_0[2] == 0)
	if_set_visible(arg_18_0.vars.wnd, "un_lock_02", var_18_0[2] and var_18_0[2] == 0)
	if_set_visible(arg_18_0.vars.wnd, "un_lock_03", var_18_0[2] and var_18_0[2] == 0)
	if_set_visible(arg_18_0.vars.wnd, "un_lock_content", var_18_0[2] and var_18_0[2] == 0)
	if_set_opacity(arg_18_0.vars.wnd, "n_sprit_fountain", var_18_0[2] and var_18_0[2] == 0 and 76.5 or 255)
	if_set_opacity(arg_18_0.vars.wnd, "n_penguin_nest", var_18_0[2] and var_18_0[2] == 0 and 76.5 or 255)
	if_set_opacity(arg_18_0.vars.wnd, "n_sprit_altar", var_18_0[2] and var_18_0[2] == 0 and 76.5 or 255)
end

function SanctuaryForest.getSancUpgradeInfo(arg_19_0)
	arg_19_0.sanc_upgrade = arg_19_0.sanc_upgrade or {}
	
	for iter_19_0 = 1, 999 do
		local var_19_0, var_19_1, var_19_2 = DBN("sanctuary_upgrade", iter_19_0, {
			"id",
			"value_1",
			"value_2"
		})
		
		if not var_19_0 then
			break
		end
		
		if string.find(var_19_0, "forest_") then
			arg_19_0.sanc_upgrade[var_19_0] = {
				value_1 = var_19_1,
				value_2 = var_19_2
			}
		end
	end
	
	return arg_19_0.sanc_upgrade
end

function SanctuaryForest.getFrontData(arg_20_0)
	arg_20_0.front_data = arg_20_0.front_data or arg_20_0:buildData()
	
	return arg_20_0.front_data
end

function SanctuaryForest.playSceneCinema(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	arg_21_2 = arg_21_2 or 2200
	arg_21_3 = arg_21_3 or 1.05
	
	if not arg_21_1 then
		UIAction:Add(DELAY(200), arg_21_0.vars.wnd, "block")
		UIAction:Add(SEQ(SPAWN(LOG(FADE_IN(200)), LOG(SCALE(arg_21_2, 1, arg_21_3)))), arg_21_0.vars.wnd, "sanc.forest.enter")
		
		local var_21_0 = "day"
		
		if SanctuaryMain.vars.is_night then
			var_21_0 = "night"
		end
		
		if arg_21_0.vars.enter_eff then
			arg_21_0.vars.enter_eff:removeFromParent()
		end
		
		arg_21_0.vars.enter_eff = EffectManager:Play({
			fn = "sanctuary_" .. var_21_0 .. "_intro.cfx",
			layer = arg_21_0.vars.wnd,
			x = DESIGN_WIDTH / 2,
			y = DESIGN_HEIGHT / 2
		})
	end
end

function SanctuaryForest.procArgs(arg_22_0, arg_22_1)
	if arg_22_1.show_alter_popup then
		UIAction:Add(SEQ(DELAY(400), CALL(function()
			arg_22_0:showAlterPopUp()
		end)), arg_22_0.vars.wnd, "block")
	end
end

function SanctuaryForest.onEnter(arg_24_0, arg_24_1, arg_24_2, arg_24_3)
	arg_24_0.vars = {}
	arg_24_3 = arg_24_3 or {}
	arg_24_0.vars.root_layer = arg_24_1
	
	if arg_24_0:isForestStateNeedUpdate() then
		query("forest_start")
		
		return 
	end
	
	arg_24_0.vars.wnd = load_dlg("sanctuary_forest", true, "wnd")
	
	EffectManager:Play({
		fn = "ui_eff_spforest_new_bg.cfx",
		layer = arg_24_0.vars.wnd:getChildByName("n_bg")
	})
	arg_24_0.vars.wnd:getChildByName("n_bg"):setScale(1.05)
	
	arg_24_0.vars.cloud_layer = cc.Node:create()
	
	arg_24_1:addChild(arg_24_0.vars.wnd)
	arg_24_1:addChild(arg_24_0.vars.cloud_layer)
	arg_24_0.vars.cloud_layer:bringToFront()
	arg_24_0:onUpdate()
	arg_24_0:updateUI()
	TopBarNew:setCurrencies({
		"gold",
		"stone",
		"stigma"
	})
	arg_24_0.vars.wnd:setOpacity(0)
	Scheduler:add(arg_24_0.vars.wnd, arg_24_0.onUpdate, arg_24_0)
	SoundEngine:play("event:/ui/sanctuary/enter_forest")
	arg_24_0:playSceneCinema()
	
	if SanctuaryMain:GetLevels("Forest")[2] == 0 then
		TutorialGuide:ifStartGuide("system_068")
	else
		TutorialGuide:ifStartGuide("system_068_new")
	end
	
	GrowthGuideNavigator:proc()
end

SanctuaryForest.Type = {
	Altar = "f_growth",
	Penguin = "f_pen",
	Element_2 = "f_elemental_2",
	Element_1 = "f_elemental_1",
	Mura = "f_mura",
	Spirit = "f_spirit",
	Element_3 = "f_elemental_3"
}

function SanctuaryForest.recieveItem(arg_25_0, arg_25_1)
	local function var_25_0(arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4)
		if not arg_26_0 then
			return 
		end
		
		local var_26_0 = 0
		local var_26_1 = T(arg_26_1 == SanctuaryForest.Type.Element_1 and "ui_reward_spirit_title" or "ui_reward_pen_title")
		local var_26_2 = T(arg_26_1 == SanctuaryForest.Type.Element_1 and "ui_reward_spirit_desc" or "ui_reward_pen_desc")
		
		for iter_26_0, iter_26_1 in pairs(arg_26_4 or {}) do
			var_26_0 = var_26_0 + iter_26_1.item.diff
		end
		
		if var_26_0 == 1 then
			arg_26_3 = arg_26_3 or "img/sanc.jpg"
			
			Dialog:ShowRareDrop({
				code = arg_26_0
			})
		else
			local var_26_3 = var_26_0 >= 10 and T("ui_reward_growth_desc") or var_26_2
			local var_26_4 = var_26_0 >= 10 and T("ui_reward_growth_title") or var_26_1
			local var_26_5 = Dialog:msgRewards(var_26_3, {
				rewards = arg_26_4
			})
			
			if_set(var_26_5, "txt_title", var_26_4)
		end
	end
	
	local var_25_1
	local var_25_2 = {}
	
	if arg_25_1.rewards.new_units then
		for iter_25_0, iter_25_1 in pairs(arg_25_1.rewards.new_units) do
			local var_25_3 = UNIT:create({
				lv = 20,
				id = iter_25_1.id,
				code = iter_25_1.code,
				exp = iter_25_1.exp,
				g = iter_25_1.g
			})
			
			var_25_3.inst.lv = 20
			
			table.insert(var_25_2, {
				unit = var_25_3
			})
			
			var_25_1 = var_25_3.db.code
		end
	else
		for iter_25_2, iter_25_3 in pairs(arg_25_1.rewards.new_items) do
			iter_25_3.diff = iter_25_3.c - Account:getItemCount(iter_25_3.code)
			
			table.insert(var_25_2, {
				item = iter_25_3
			})
			
			var_25_1 = iter_25_3.code
		end
	end
	
	if not var_25_1 then
		return 
	end
	
	if arg_25_1.dec_result then
		Account:addReward(arg_25_1.dec_result)
	end
	
	if arg_25_1.rewards then
		Account:addReward(arg_25_1.rewards, {
			content = "forest"
		})
	end
	
	local var_25_4 = arg_25_1.rewards.new_items or arg_25_1.rewards.new_units
	local var_25_5
	
	if arg_25_1.forest_info then
		var_25_5 = arg_25_1.forest_info.code
	else
		var_25_5 = string.starts(var_25_4[1].code, "ma_elem") and "f_elemental_1" or "f_pen"
	end
	
	if var_25_5 == "f_spirit" then
		var_25_5 = "f_elemental_1"
	end
	
	local var_25_6 = table.count(var_25_2)
	
	if var_25_2[1] and var_25_2[1].item and var_25_2[1].item.diff >= 2 then
		local var_25_7 = var_25_2[1].item.diff
	end
	
	local var_25_8 = arg_25_0:getFrontData()
	local var_25_9
	local var_25_10
	
	if SanctuaryForest.Type.Penguin == var_25_5 then
		var_25_9 = "ui_forest_get_egg.cfx"
		var_25_10 = "ui_forest_get_egg"
	elseif SanctuaryForest.Type.Element_1 == var_25_5 then
		var_25_9 = "ui_forest_get_stone.cfx"
		var_25_10 = "ui_forest_get_stone"
	elseif SanctuaryForest.Type.Mura == var_25_5 then
		local var_25_11 = string.sub(var_25_1, -1)
		
		if not var_25_11 or string.len(var_25_11) <= 0 then
			var_25_11 = 1
		end
		
		var_25_9 = string.format("ui_forest_get_mora_%02d.cfx", var_25_11)
		var_25_10 = string.format("ui_forest_get_mora_%02d", var_25_11)
	end
	
	local var_25_12 = SceneManager:getRunningPopupScene()
	
	if var_25_9 and arg_25_1.play_cinematic then
		local var_25_13 = EffectManager:Play({
			z = 99999,
			fn = var_25_9,
			layer = var_25_12,
			x = DESIGN_WIDTH / 2,
			y = DESIGN_HEIGHT / 2
		})
		local var_25_14 = SoundEngine:play("event:/ui/forest_get/" .. (var_25_10 or ""))
		local var_25_15 = ccui.Button:create()
		
		var_25_15:setTouchEnabled(true)
		var_25_15:ignoreContentAdaptWithSize(false)
		var_25_15:setContentSize(DESIGN_WIDTH, DESIGN_WIDTH)
		var_25_15:setPosition(DESIGN_WIDTH / 2, DESIGN_HEIGHT / 2)
		var_25_15:setLocalZOrder(99999)
		var_25_15:addTouchEventListener(function(arg_27_0, arg_27_1)
			if arg_27_1 ~= 2 then
				return 
			end
			
			var_25_15:setTouchEnabled(false)
			UIAction:Remove("block")
			
			if get_cocos_refid(var_25_14) then
				var_25_14:stop()
			end
			
			local var_27_0 = cc.c3b(255, 255, 255)
			
			if var_25_5 == "mura" then
				var_27_0 = cc.c3b(0, 0, 0)
			end
			
			local var_27_1 = cc.LayerColor:create(var_27_0)
			
			var_27_1:setContentSize(VIEW_WIDTH, VIEW_WIDTH)
			var_27_1:setPosition(VIEW_BASE_LEFT, 0)
			var_27_1:setLocalZOrder(99999)
			var_25_12:addChild(var_27_1)
			var_27_1:setOpacity(0)
			UIAction:Add(SEQ(FADE_IN(200), CALL(var_25_0, var_25_1, var_25_5, var_25_12, nil, var_25_2), FADE_OUT(300), TARGET(var_25_13, REMOVE()), TARGET(var_25_15, REMOVE()), REMOVE()), var_27_1, "block")
		end)
		var_25_12:addChild(var_25_15)
		UIAction:Add(SEQ(DELAY(2900), CALL(var_25_0, var_25_1, var_25_5, var_25_12, nil, var_25_2), CALL(var_25_15.setTouchEnabled, var_25_15, false), DELAY(1000), TARGET(var_25_13, REMOVE()), REMOVE()), var_25_15, "block")
	else
		var_25_0(var_25_1, var_25_5, var_25_12, nil, var_25_2)
	end
end

function SanctuaryForest.updateBtns(arg_28_0)
	if_set_visible(arg_28_0.vars.wnd:getChildByName("n_penguin_nest"), "talk_bg", arg_28_0:isHarvestable(SanctuaryForest.Type.Penguin))
	if_set_visible(arg_28_0.vars.wnd:getChildByName("n_sprit_fountain"), "talk_bg", arg_28_0:isHarvestable(SanctuaryForest.Type.Element_1))
	if_set_visible(arg_28_0.vars.wnd:getChildByName("n_marragora"), "talk_bg", arg_28_0:isHarvestable(SanctuaryForest.Type.Mura) or arg_28_0:canWaterTheMura())
	if_set_visible(arg_28_0.vars.wnd:getChildByName("n_marragora"), "icon_menu_grow", arg_28_0:canWaterTheMura())
	if_set_visible(arg_28_0.vars.wnd:getChildByName("n_marragora"), "reward_icon", arg_28_0:isHarvestable(SanctuaryForest.Type.Mura))
end

function SanctuaryForest.isRestTime(arg_29_0)
	local var_29_0 = Account:getForestState()[SanctuaryForest.Type.Mura]
	local var_29_1 = false
	
	if var_29_0.start_time > os.time() then
		var_29_1 = true
	end
	
	return var_29_1
end

function SanctuaryForest.isShowPopUp(arg_30_0)
	if not arg_30_0.vars then
		return 
	end
	
	return get_cocos_refid(arg_30_0.vars.popup)
end

function SanctuaryForest.updatePopup(arg_31_0)
	if not get_cocos_refid(arg_31_0.vars.popup) then
		return 
	end
	
	local function var_31_0(arg_32_0)
		local var_32_0 = timeToStringDef({
			preceding_with_zeros = true,
			remain_time_with_day = arg_32_0
		})
		local var_32_1
		
		if to_n(var_32_0.day) > 0 then
			var_32_1 = T("ui_forest_timer_common_day", var_32_0)
		else
			var_32_1 = T("ui_forest_timer_common", var_32_0)
		end
		
		return var_32_1
	end
	
	if arg_31_0.vars.popup_type then
		local var_31_1 = os.time()
		
		if arg_31_0.vars.popup_type == SanctuaryForest.Type.Mura then
			local var_31_2 = Account:getForestState()[SanctuaryForest.Type.Mura]
			local var_31_3 = arg_31_0:getFrontData()[SanctuaryForest.Type.Mura]
			local var_31_4 = var_31_2.water_time or 0
			local var_31_5 = var_31_2.water_count or 0
			local var_31_6 = var_31_2.start_time
			
			if arg_31_0:isRestTime() then
				if_set(arg_31_0.vars.popup, "t_time", var_31_0(math.max(var_31_6 - var_31_1, 0)))
				if_set_color(arg_31_0.vars.popup, "t_get_time", cc.c3b(255, 120, 0))
			else
				if_set(arg_31_0.vars.popup:getChildByName("n_water"), "t_water", T("ui_mura_popup_care_time"))
				if_set(arg_31_0.vars.popup:getChildByName("n_water_number"), "t_number", T("ui_mura_popup_care_count1"))
				
				local var_31_7 = var_31_4 < var_31_6 and var_31_6 or var_31_4
				
				if var_31_4 < var_31_6 and true or false then
					if var_31_1 <= var_31_7 + arg_31_0:getFrontData()[SanctuaryForest.Type.Mura].grow_cooltime then
						if_set(arg_31_0.vars.popup, "t_water_time", var_31_0(math.max(var_31_7 + arg_31_0:getFrontData()[SanctuaryForest.Type.Mura].grow_cooltime - var_31_1, 0)))
					end
				elseif var_31_1 <= var_31_7 + arg_31_0:getFrontData()[SanctuaryForest.Type.Mura].able_grow then
					if_set(arg_31_0.vars.popup, "t_water_time", var_31_0(math.max(var_31_7 + arg_31_0:getFrontData()[SanctuaryForest.Type.Mura].able_grow - var_31_1, 0)))
				end
				
				if_set_color(arg_31_0.vars.popup, "t_get_time", cc.c3b(171, 135, 89))
				if_set_opacity(arg_31_0.vars.popup, "t_get_time", 178.5)
				
				if arg_31_0:getWaterCount() >= arg_31_0:getFrontData()[SanctuaryForest.Type.Mura].grow_count then
					if_set(arg_31_0.vars.popup, "t_water", T("ui_water_max_count"))
				end
				
				if_set(arg_31_0.vars.popup, "t_count", T("ui_mura_popup_care_count2", {
					count_now = var_31_3.grow_count - arg_31_0:getWaterCount(),
					count_max = arg_31_0:getFrontData()[SanctuaryForest.Type.Mura].grow_count
				}))
				
				local var_31_8 = Account:getForestState()[arg_31_0.vars.popup_type].start_time + arg_31_0:getFrontData()[arg_31_0.vars.popup_type].time - var_31_5 * var_31_3.grow_shorten_time
				
				if_set(arg_31_0.vars.popup, "t_time", var_31_0(math.max(var_31_8 - var_31_1, 0)))
			end
		else
			if_set_color(arg_31_0.vars.popup, "t_get_time", cc.c3b(171, 135, 89))
			if_set_opacity(arg_31_0.vars.popup, "t_get_time", 178.5)
			
			local var_31_9 = arg_31_0:getSancUpgradeInfo()["forest_2_" .. SanctuaryMain:GetLevels("Forest")[3]].value_1
			
			if_set(arg_31_0.vars.popup, "t_time", var_31_0(math.max(Account:getForestState()[arg_31_0.vars.popup_type].start_time + math.ceil(arg_31_0:getFrontData()[arg_31_0.vars.popup_type].time * var_31_9) - var_31_1, 0)))
		end
	else
		if_set(arg_31_0.vars.popup, "t_token_count", comma_value(Account:getCurrency("stigma")))
	end
end

function SanctuaryForest.isHarvestable(arg_33_0, arg_33_1)
	if not arg_33_1 then
		return 
	end
	
	if table.count(Account:getForestState()) == 0 then
		return 
	end
	
	if arg_33_1 == SanctuaryForest.Type.Altar then
		return 
	end
	
	if arg_33_1 == SanctuaryForest.Type.Element_1 then
		arg_33_1 = SanctuaryForest.Type.Spirit
	end
	
	local var_33_0 = Account:getForestState()[arg_33_1]
	
	if not var_33_0 then
		return 
	end
	
	local var_33_1 = arg_33_0:getFrontData()[arg_33_1]
	local var_33_2 = os.time()
	local var_33_3
	
	if arg_33_1 ~= SanctuaryForest.Type.Mura then
		local var_33_4 = arg_33_0:getSancUpgradeInfo()["forest_2_" .. SanctuaryMain:GetLevels("Forest")[3]].value_1
		
		var_33_3 = var_33_2 > var_33_0.start_time + math.ceil(var_33_1.time * var_33_4)
	else
		var_33_3 = var_33_2 > var_33_0.start_time + var_33_1.time - var_33_0.water_count * var_33_1.grow_shorten_time
	end
	
	return var_33_3
end

function SanctuaryForest.canWaterTheMura(arg_34_0)
	local var_34_0 = Account:getForestState()[SanctuaryForest.Type.Mura]
	
	if not var_34_0 then
		return 
	end
	
	local var_34_1 = var_34_0.water_time or 0
	local var_34_2 = var_34_0.start_time
	local var_34_3 = arg_34_0:getFrontData()[SanctuaryForest.Type.Mura]
	
	if var_34_3.grow_count <= var_34_0.water_count then
		return false
	end
	
	if arg_34_0:isHarvestable(SanctuaryForest.Type.Mura) then
		return false
	end
	
	if arg_34_0:isRestTime() then
		return false
	end
	
	local var_34_4 = os.time()
	
	if var_34_1 < var_34_2 and true or false then
		return var_34_4 > var_34_3.able_grow + var_34_2
	else
		return var_34_4 > var_34_1 + var_34_3.grow_cooltime
	end
end

function SanctuaryForest.getWaterCount(arg_35_0)
	if not Account:getForestState()[SanctuaryForest.Type.Mura] then
		return 
	end
	
	return to_n(Account:getForestState()[SanctuaryForest.Type.Mura].water_count)
end

function SanctuaryForest.showInfoPopUp(arg_36_0, arg_36_1)
	if get_cocos_refid(arg_36_0.vars.popup) then
		return 
	end
	
	if arg_36_1 == SanctuaryForest.Type.Element_1 then
		arg_36_1 = SanctuaryForest.Type.Spirit
	end
	
	if TutorialGuide:isPlayingTutorial() then
		TutorialGuide:procGuide()
	end
	
	local var_36_0 = SanctuaryMain:GetLevels("Forest")
	
	if var_36_0 and var_36_0[2] == 0 and arg_36_1 ~= SanctuaryForest.Type.Mura then
		balloon_message(T("ui_lock_produce"))
		
		return 
	end
	
	arg_36_0.vars.popup = load_dlg("sanctuary_forest_info_popup", true, "wnd", function()
		arg_36_0:closePopUp()
	end)
	
	if_set(arg_36_0.vars.popup, "t_title", T(arg_36_0:getFrontData()[arg_36_1].title))
	if_set(arg_36_0.vars.popup, "t_get_number", arg_36_1 == SanctuaryForest.Type.Mura and 1 or var_36_0[2])
	
	local var_36_1 = arg_36_1 == SanctuaryForest.Type.Mura and "ui_mura_popup_rest" or arg_36_1 == SanctuaryForest.Type.Penguin and "ui_pen_popup_time" or arg_36_1 == SanctuaryForest.Type.Spirit and "ui_spirit_popup_time"
	
	if_set(arg_36_0.vars.popup, "t_get_time", T(var_36_1))
	if_set(arg_36_0.vars.popup, "txt_disc", T(arg_36_1 == SanctuaryForest.Type.Mura and "ui_mura_popup_explain" or arg_36_1 == SanctuaryForest.Type.Penguin and "ui_pen_popup_explain" or arg_36_1 == SanctuaryForest.Type.Spirit and "ui_spirit_popup_explain"))
	if_set_visible(arg_36_0.vars.popup, "n_water", arg_36_1 == SanctuaryForest.Type.Mura)
	
	if arg_36_1 ~= SanctuaryForest.Type.Mura then
		local var_36_2 = arg_36_0.vars.popup:getChildByName("move_get_time"):getPositionX()
		local var_36_3 = arg_36_0.vars.popup:getChildByName("move_get_time"):getPositionY()
		
		arg_36_0.vars.popup:getChildByName("n_get_time"):setPosition(var_36_2, var_36_3)
		
		local var_36_4 = var_36_0[2] >= 2 and "_" or ""
		local var_36_5 = var_36_0[2] >= 2 and var_36_0[2] or ""
		
		if_set_sprite(arg_36_0.vars.popup, "img_icon", string.split(arg_36_0:getFrontData()[arg_36_1].ui_icon, ".")[1] .. var_36_4 .. var_36_5 .. ".png")
	else
		local var_36_6 = arg_36_0:getFrontData()[SanctuaryForest.Type.Mura]
		
		if arg_36_0:isRestTime() then
			local var_36_7 = arg_36_0.vars.popup:getChildByName("move_get_time"):getPositionX()
			local var_36_8 = arg_36_0.vars.popup:getChildByName("move_get_time"):getPositionY()
			
			arg_36_0.vars.popup:getChildByName("n_get_time"):setPosition(var_36_7, var_36_8)
			if_set_visible(arg_36_0.vars.popup, "n_water", false)
		else
			if_set(arg_36_0.vars.popup, "t_water_time", T("ui_mura_popup_care_time"))
			if_set(arg_36_0.vars.popup, "t_get_time", T("ui_mura_popup_get_time"))
			
			if arg_36_0:getWaterCount() >= var_36_6.grow_count then
				local var_36_9 = arg_36_0.vars.popup:getChildByName("move_water_number"):getPositionX()
				local var_36_10 = arg_36_0.vars.popup:getChildByName("move_water_number"):getPositionY()
				
				arg_36_0.vars.popup:getChildByName("n_water_number"):setPosition(var_36_9, var_36_10)
				if_set_opacity(arg_36_0.vars.popup, "n_water_number", 76.5)
				if_set_visible(arg_36_0.vars.popup, "n_time", false)
			end
		end
		
		local var_36_11, var_36_12 = arg_36_0:updateForestObject(SanctuaryForest.Type.Mura)
		local var_36_13 = var_36_12 >= 2 and "_" or ""
		local var_36_14 = var_36_12 >= 2 and var_36_12 or ""
		
		if_set_sprite(arg_36_0.vars.popup, "img_icon", string.split(arg_36_0:getFrontData()[arg_36_1].ui_icon, ".")[1] .. var_36_13 .. var_36_14 .. ".png")
	end
	
	arg_36_0.vars.popup_type = arg_36_1
	
	arg_36_0:updatePopup(arg_36_1)
	SceneManager:getRunningPopupScene():addChild(arg_36_0.vars.popup)
end

SanctuaryForestPopup = {}

function SanctuaryForestPopup.setDefaultData(arg_38_0, arg_38_1, arg_38_2)
	arg_38_0.data = arg_38_1
	arg_38_0.sale = arg_38_2
end

function SanctuaryForestPopup.getScrollViewItem(arg_39_0, arg_39_1)
	local var_39_0 = load_control("wnd/sanctuary_forest_popup_item.csb")
	local var_39_1 = var_39_0:getChildByName("btn_cost_01")
	local var_39_2 = var_39_0:getChildByName("btn_cost_02")
	local var_39_3 = arg_39_0.data[arg_39_1.type]
	local var_39_4 = math.floor(var_39_3.get1_value * arg_39_0.sale)
	local var_39_5 = math.floor(var_39_3.get10_value * arg_39_0.sale)
	local var_39_6 = var_39_4 / var_39_4
	local var_39_7 = var_39_5 / var_39_4
	
	if_set(var_39_0, "txt_name", T(var_39_3.title))
	if_set(var_39_0, "txt_disc", T(var_39_3.desc))
	if_set(var_39_1, "cost", var_39_4)
	if_set(var_39_2, "cost", var_39_5)
	if_set(var_39_1, "txt_btn_name", T("text_item_earn_count", {
		count = var_39_6
	}))
	if_set(var_39_2, "txt_btn_name", T("text_item_earn_count", {
		count = var_39_7
	}))
	if_set_sprite(var_39_0, "img_icon", var_39_3.ui_icon)
	
	var_39_1.data = {
		price = to_n(var_39_4),
		count = var_39_6,
		key = arg_39_1.type
	}
	var_39_2.data = {
		price = to_n(var_39_5),
		count = var_39_7,
		key = arg_39_1.type
	}
	
	return var_39_0
end

function SanctuaryForest.showAlterPopUp(arg_40_0, arg_40_1)
	if get_cocos_refid(arg_40_0.vars.popup) then
		return 
	end
	
	if TutorialGuide:isPlayingTutorial() then
		TutorialGuide:procGuide()
	end
	
	local var_40_0 = SanctuaryMain:GetLevels("Forest")
	
	if var_40_0 and var_40_0[2] == 0 then
		balloon_message(T("ui_lock_produce"))
		
		return 
	end
	
	copy_functions(ScrollView, SanctuaryForestPopup)
	
	arg_40_0.vars.popup = load_dlg("sanctuary_forest_popup", true, "wnd", function()
		arg_40_0:closePopUp()
	end)
	
	if_set(arg_40_0.vars.popup, "txt_title", T("ui_grow_popup_title"))
	if_set(arg_40_0.vars.popup, "t_token_count", comma_value(Account:getCurrency("stigma")))
	UIUtil:getRewardIcon(nil, "to_stigma", {
		no_bg = true,
		parent = arg_40_0.vars.popup:getChildByName("icon_token")
	}):setAnchorPoint(0, 0)
	
	arg_40_0.vars.scrollview = arg_40_0.vars.popup:getChildByName("scroll_view")
	
	SanctuaryForestPopup:initScrollView(arg_40_0.vars.scrollview, 828, 187)
	
	local var_40_1 = to_n(DB("sanctuary_upgrade", "forest_2_" .. var_40_0[3], "value_1"))
	
	SanctuaryForestPopup:setDefaultData(arg_40_0:getFrontData(), var_40_1)
	
	local var_40_2 = {}
	
	table.insert(var_40_2, {
		type = SanctuaryForest.Type.Penguin
	})
	table.insert(var_40_2, {
		type = SanctuaryForest.Type.Element_1
	})
	table.insert(var_40_2, {
		type = SanctuaryForest.Type.Element_2
	})
	table.insert(var_40_2, {
		type = SanctuaryForest.Type.Element_3
	})
	SanctuaryForestPopup:createScrollViewItems(var_40_2)
	SceneManager:getRunningPopupScene():addChild(arg_40_0.vars.popup)
	GrowthGuideNavigator:proc()
end

function SanctuaryForest.closePopUp(arg_42_0)
	if not get_cocos_refid(arg_42_0.vars.popup) then
		return 
	end
	
	BackButtonManager:pop()
	arg_42_0.vars.popup:removeFromParent()
	
	arg_42_0.vars.popup_type = nil
end

function SanctuaryForest.buildData(arg_43_0)
	local var_43_0 = {}
	
	for iter_43_0 = 1, 999 do
		local var_43_1, var_43_2, var_43_3, var_43_4, var_43_5, var_43_6, var_43_7, var_43_8, var_43_9, var_43_10, var_43_11, var_43_12, var_43_13, var_43_14, var_43_15, var_43_16 = DBN("forest_spirit_function", iter_43_0, {
			"id",
			"title",
			"stat_cfx",
			"item_id",
			"time",
			"produce1_end",
			"produce2_end",
			"grow_count",
			"grow_shorten_time",
			"able_grow",
			"grow_cooltime",
			"ui_icon",
			"token_type",
			"get1_value",
			"get10_value",
			"desc"
		})
		
		if not var_43_1 then
			break
		end
		
		var_43_0[var_43_1] = {
			id = var_43_1,
			title = var_43_2,
			desc = var_43_16,
			stat_cfx = var_43_3,
			item_id = var_43_4,
			time = var_43_5,
			produce1_end = var_43_6,
			produce2_end = var_43_7,
			grow_count = var_43_8,
			grow_shorten_time = var_43_9,
			able_grow = var_43_10,
			grow_cooltime = var_43_11,
			ui_icon = var_43_12,
			token_type = var_43_13,
			get1_value = var_43_14,
			get10_value = var_43_15
		}
	end
	
	return var_43_0
end

function SanctuaryForest.getEndTime(arg_44_0, arg_44_1)
	if arg_44_1 == SanctuaryForest.Type.Element_1 then
		arg_44_1 = SanctuaryForest.Type.Spirit
	end
	
	local var_44_0 = arg_44_0:getFrontData()[arg_44_1]
	local var_44_1 = Account:getForestState()[arg_44_1]
	local var_44_2 = arg_44_0:getSancUpgradeInfo()["forest_2_" .. SanctuaryMain:GetLevels("Forest")[3]].value_1
	
	var_44_2 = arg_44_1 ~= SanctuaryForest.Type.Mura and var_44_2 or 1
	
	if arg_44_1 == SanctuaryForest.Type.Mura then
		local var_44_3 = var_44_1.start_time + var_44_0.time - var_44_1.water_count * var_44_0.grow_shorten_time
		
		return math.ceil(var_44_3 - os.time())
	else
		local var_44_4 = (var_44_0.produce1_end + var_44_0.produce2_end) * var_44_2
		
		return math.ceil(var_44_1.start_time + var_44_4 - os.time())
	end
end

function SanctuaryForest.updatePushNoti(arg_45_0, arg_45_1, arg_45_2)
	cancel_local_push(arg_45_2)
	
	local var_45_0
	local var_45_1
	
	if arg_45_2 == LOCAL_PUSH_IDS.FOREST_PENGUIN then
		var_45_0 = SanctuaryForest.Type.Penguin
		var_45_1 = "FOREST_PENGUIN"
	elseif arg_45_2 == LOCAL_PUSH_IDS.FOREST_MURA_GET then
		var_45_0 = SanctuaryForest.Type.Mura
		var_45_1 = "FOREST_MURA_GET"
	elseif arg_45_2 == LOCAL_PUSH_IDS.FOREST_SPIRIT then
		var_45_0 = SanctuaryForest.Type.Spirit
		var_45_1 = "FOREST_SPIRIT"
	end
	
	if Account:getForestState()[var_45_0] then
		add_local_push(var_45_1, SanctuaryForest:getEndTime(var_45_0))
	end
	
	if not arg_45_1 then
		cancel_local_push(LOCAL_PUSH_IDS.FOREST_MURA_WATER)
		
		local var_45_2 = Account:getForestState()[SanctuaryForest.Type.Mura].water_time or 0
		local var_45_3 = Account:getForestState()[SanctuaryForest.Type.Mura].water_count
		local var_45_4 = Account:getForestState()[SanctuaryForest.Type.Mura].start_time
		local var_45_5 = SanctuaryForest:getFrontData()[SanctuaryForest.Type.Mura].able_grow
		local var_45_6 = SanctuaryForest:getFrontData()[SanctuaryForest.Type.Mura].grow_cooltime
		local var_45_7 = os.time()
		local var_45_8 = SAVE:get("t_local_push_" .. LOCAL_PUSH_IDS.FOREST_MURA_WATER.id, nil)
		
		if var_45_3 >= 3 then
			return 
		end
		
		if arg_45_0:isRestTime() then
			add_local_push("FOREST_MURA_WATER", var_45_4 + var_45_5 - var_45_7)
			
			return 
		end
		
		if not var_45_8 then
			if var_45_4 < var_45_2 then
				add_local_push("FOREST_MURA_WATER", var_45_2 + var_45_6 - var_45_7)
			elseif var_45_7 >= var_45_4 + var_45_5 then
				add_local_push("FOREST_MURA_WATER", 0)
			else
				add_local_push("FOREST_MURA_WATER", var_45_4 + var_45_5 - var_45_7)
			end
		end
	end
end

function SanctuaryForest.onLeave(arg_46_0, arg_46_1)
	TopBarNew:setCurrencies({
		"crystal",
		"gold",
		"stone"
	})
	Scheduler:remove(arg_46_0.onUpdate)
	arg_46_0.vars.wnd:removeFromParent()
	arg_46_0:playSceneCinema(true)
end

function SanctuaryForest.onPushBackButton(arg_47_0)
	if arg_47_0.vars and get_cocos_refid(arg_47_0.vars.popup_wnd) then
		return 
	end
	
	SanctuaryMain:setMode("Main")
end

function SanctuaryForest.getBatchList(arg_48_0)
	local var_48_0 = AccountData.sanc_forest or {}
	local var_48_1 = {}
	
	for iter_48_0, iter_48_1 in pairs(var_48_0) do
		table.insert(var_48_1, to_n(iter_48_0))
	end
	
	table.sort(var_48_1, function(arg_49_0, arg_49_1)
		return arg_49_0 < arg_49_1
	end)
	
	return var_48_1
end

function SanctuaryForest.updateSlots(arg_50_0)
	arg_50_0:updatePopup()
	arg_50_0:updateBtns()
	
	for iter_50_0, iter_50_1 in pairs(SanctuaryForest.Type or {}) do
		arg_50_0:updateForestObject(iter_50_1)
	end
end

function SanctuaryForest.onUpdate(arg_51_0)
	arg_51_0:updateSlots()
end

function SanctuaryForest.onUpdateUpgrade(arg_52_0)
	arg_52_0:updateSlots()
end

function SanctuaryForest.CheckNotification(arg_53_0)
	if not UnlockSystem:isUnlockSystem(UNLOCK_ID.SANC_FOREST) then
		return false
	end
	
	if TutorialCondition:isEnable("system_068") then
		return true
	end
	
	if arg_53_0:isForestStateNeedUpdate() then
		return true
	end
	
	for iter_53_0, iter_53_1 in pairs(SanctuaryForest.Type or {}) do
		if arg_53_0:isHarvestable(iter_53_1) then
			return true
		end
	end
	
	if arg_53_0:canWaterTheMura() then
		return true
	end
	
	return SanctuaryMain:GetTotalLevel("Forest") < 9 and Account:getCurrency("stone") > 0
end
