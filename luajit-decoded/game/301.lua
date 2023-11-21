function HANDLER.rankup(arg_1_0)
	if UIAction:Find("block") then
		return 
	end
	
	if arg_1_0:getName() == "btn_close" then
		Rankup:close()
	end
end

Rankup = Rankup or {}

function Rankup.show(arg_2_0, arg_2_1)
	print("RANKUP " .. arg_2_1.lv_before .. " > " .. arg_2_1.lv_after)
	
	arg_2_0.current_level = arg_2_1.lv_before
	arg_2_0.lv_after = arg_2_1.lv_after
	
	set_high_fps_tick(3000)
	SoundEngine:playVoice("event:/ui/rankup_voc")
	
	return arg_2_0:innserShow(arg_2_1)
end

function Rankup.innserShow(arg_3_0, arg_3_1)
	arg_3_1 = arg_3_1 or {}
	
	if arg_3_0.current_level >= arg_3_0.lv_after then
		return false
	end
	
	local var_3_0 = load_dlg("rankup", true, "wnd")
	
	if arg_3_1.parent then
		var_3_0:setPosition(0, 0)
		var_3_0:setAnchorPoint(0, 0)
		arg_3_1.parent:addChild(var_3_0)
	end
	
	if_set_visible(var_3_0, "btn_close", arg_3_1.no_close_btn ~= true)
	var_3_0:setLocalZOrder(100000000)
	
	local var_3_1 = CACHE:getEffect("new_rankup_panel.cfx")
	
	var_3_0:getChildByName("n_effpos"):addChild(var_3_1)
	var_3_1:setVisible(true)
	var_3_1:start()
	
	local var_3_2 = arg_3_0.lv_after
	local var_3_3 = {}
	local var_3_4 = math.floor(var_3_2 / 100)
	local var_3_5 = math.floor((var_3_2 - var_3_4 * 100) / 10)
	local var_3_6 = var_3_2 % 10
	local var_3_7 = 78
	local var_3_8 = 70
	local var_3_9 = 67
	local var_3_10 = 1
	local var_3_11 = 0
	
	if var_3_4 > 0 then
		table.insert(var_3_3, var_3_4)
		
		var_3_10 = var_3_10 + 1
	end
	
	if var_3_5 > 0 then
		table.insert(var_3_3, var_3_5)
		
		var_3_10 = var_3_10 + 1
	end
	
	table.insert(var_3_3, var_3_6)
	
	if var_3_10 == 1 then
		var_3_7 = 0
	end
	
	if var_3_10 == 2 then
		var_3_7 = 40
		var_3_8 = 85
	end
	
	local var_3_12 = {}
	
	for iter_3_0, iter_3_1 in pairs(var_3_3) do
		local var_3_13 = CACHE:getEffect("rankup_num_" .. iter_3_1 .. ".scsp")
		
		var_3_0:getChildByName("n_effpos"):addChild(var_3_13)
		var_3_13:setVisible(false)
		table.insert(var_3_12, var_3_13)
	end
	
	local function var_3_14(arg_4_0)
		if get_cocos_refid(var_3_12[arg_4_0]) then
			local var_4_0 = var_3_12[arg_4_0]
			
			if var_3_10 == 3 and arg_4_0 == 2 then
				var_3_11 = 8
			end
			
			if var_3_10 == 3 and arg_4_0 == 3 then
				var_3_11 = 0
			end
			
			var_4_0:setPosition(0 - var_3_7 + (arg_4_0 - 1) * var_3_8, -20 + var_3_11)
			var_4_0:setAnimation(0, "intro", false)
			UIAction:Add(SEQ(SHOW(true), DMOTION("intro"), MOTION("loop", true)), var_4_0, "num_eff")
			
			if arg_4_0 < var_3_10 then
				UIAction:Add(SEQ(DELAY(var_3_9), CALL(var_3_14, arg_4_0 + 1)), arg_3_0, "rankup_eff")
			end
		end
	end
	
	UIAction:Add(SEQ(DELAY(333), CALL(var_3_14, 1)), arg_3_0, "rankup_eff")
	
	local var_3_15 = CACHE:getEffect("new_rankup_eff.cfx")
	
	var_3_0:getChildByName("n_effpos"):addChild(var_3_15)
	var_3_15:setLocalZOrder(9999)
	var_3_15:setVisible(true)
	var_3_15:start()
	
	local var_3_16 = UIUtil:getPortraitAni("npc1003", {
		pin_sprite_position_y = true
	})
	
	if var_3_16 then
		var_3_16:setScaleX(-1)
		var_3_0:getChildByName("n_portrait"):addChild(var_3_16)
	end
	
	local var_3_17 = var_3_0:getChildByName("slide")
	
	UIAction:Add(SEQ(DELAY(1000), CALL(Rankup.procLevelUp, arg_3_0, var_3_0, arg_3_0.current_level, arg_3_0.current_level + 1)), var_3_17, "block")
	
	local var_3_18 = var_3_0:getChildByName("btn_close")
	
	if var_3_18 then
		var_3_18:setLocalZOrder(-2)
	end
	
	arg_3_0.wnd = var_3_0
	arg_3_0.current_level = arg_3_0.current_level + 1
	
	SoundEngine:play("event:/ui/rankup")
	
	return var_3_0
end

function Rankup.procLevelUp(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	if arg_5_2 == nil or arg_5_3 == nil then
		return 
	end
end

function Rankup.close(arg_6_0)
	UIAction:Remove("rankup.cursor")
	UIAction:Add(SEQ(FADE_OUT(200), SHOW(false)), arg_6_0.wnd, "block")
end

function Rankup.test(arg_7_0, arg_7_1, arg_7_2)
	arg_7_0:open(arg_7_1, arg_7_2)
end

function Rankup.open(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	arg_8_3 = arg_8_3 or SceneManager:getRunningPopupScene()
	
	local var_8_0
	local var_8_2
	
	if AccountData.shop_rankpack and arg_8_2 <= 30 then
		local var_8_1 = AccountData.shop_rankpack.e7_2022rankup1_30 or {}
		
		var_8_2 = {}
		
		for iter_8_0, iter_8_1 in pairs(var_8_1) do
			if iter_8_1.f then
				local var_8_3 = 0
				
				for iter_8_2, iter_8_3 in pairs(iter_8_1.f) do
					if arg_8_2 <= to_n(iter_8_3.give_rank) then
						var_8_2[iter_8_3.item_id] = (var_8_2[iter_8_3.item_id] or 0) + iter_8_3.value
						var_8_3 = iter_8_3.give_rank
					end
				end
				
				if table.count(var_8_2) > 0 then
					var_8_0 = {
						rewards = var_8_2,
						give_rank = var_8_3
					}
					
					break
				end
			end
		end
	end
	
	local var_8_4 = DB("acc_rank", tostring(arg_8_2), "acq_st")
	local var_8_5 = T("ui_msg_rankup", {
		stamina = var_8_4
	})
	local var_8_6 = Rankup:show({
		lv_before = arg_8_1,
		lv_after = arg_8_2
	})
	
	if var_8_0 then
		local var_8_7 = var_8_6:getChildByName("n_rankup"):getChildByName("window_frame")
		local var_8_8 = var_8_7:getContentSize()
		
		var_8_7:setContentSize(var_8_8.width, var_8_8.height + 30)
		if_set_visible(var_8_7, "n_balloon", true)
		if_set_visible(var_8_7, "n_common", false)
		
		local var_8_9 = var_8_7:getChildByName("n_balloon")
		
		if_set(var_8_9, "txt_disc", T("txt_rank_reward_get_info_1", {
			num = var_8_4
		}))
		if_set_visible(var_8_7, "n_package_preview", true)
		
		local var_8_10 = var_8_7:getChildByName("n_package_preview")
		
		if_set_visible(var_8_10, "reward_item1", false)
		if_set_visible(var_8_10, "reward_item2", false)
		
		local var_8_11 = 0
		
		for iter_8_4, iter_8_5 in pairs(var_8_0.rewards) do
			var_8_11 = var_8_11 + 1
			
			if_set_visible(var_8_10, "reward_item" .. var_8_11, true)
			UIUtil:getRewardIcon(iter_8_5, iter_8_4, {
				show_small_count = true,
				detail = false,
				parent = var_8_10:getChildByName("reward_item" .. var_8_11)
			})
		end
		
		if arg_8_2 == var_8_0.give_rank then
			if_set(var_8_10, "t_disc", T("ui_rankup_reward_info_1"))
			if_set(var_8_10, "t_package", T("ui_rankup_reward_info_4"))
		else
			if_set(var_8_10, "t_disc", T("ui_rankup_reward_info_2", {
				num = var_8_0.give_rank
			}))
			if_set(var_8_10, "t_package", T("ui_rankup_reward_info_3", {
				num = var_8_0.give_rank
			}))
		end
		
		local var_8_12 = var_8_6:getChildByName("n_effpos")
		
		var_8_12:setPositionY(var_8_12:getPositionY() + 30)
		if_set_visible(var_8_6, "n_arrow", false)
	else
		local var_8_13 = var_8_6:getChildByName("n_rankup"):getChildByName("window_frame")
		
		if_set_visible(var_8_13, "n_package_preview", false)
		if_set_visible(var_8_13, "n_balloon", false)
		if_set_visible(var_8_13, "n_common", true)
	end
	
	Dialog:msgBox(var_8_5, {
		dlg = var_8_6,
		parent = arg_8_3,
		handler = function(arg_9_0, arg_9_1)
			if arg_9_1 == "btn_block" then
				return "dont_close"
			else
				local var_9_0 = DB("acc_rank", tostring(arg_8_1), "max_st")
				local var_9_1 = DB("acc_rank", tostring(arg_8_2), "max_st")
				
				if var_9_0 ~= var_9_1 then
					local var_9_2 = Account:getCurrencyMaxBonus("stamina")
					
					Dialog:msgBox(T("popup_rankup_desc"), {
						dlg = load_dlg("dlg_rankup_up", true, "wnd"),
						title = T("popup_rankup_title"),
						parent = arg_8_3,
						txt_before = comma_value(var_9_0 + var_9_2),
						txt_after = comma_value(var_9_1 + var_9_2),
						handler = function()
							if arg_8_4 then
								arg_8_4()
							end
						end
					})
				elseif arg_8_4 then
					arg_8_4()
				end
			end
		end
	})
end
