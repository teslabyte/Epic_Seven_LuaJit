SPECIALITEM_GRADE = {
	{
		"sp_worldboss_clear_d",
		"sp_worldboss_clear_c",
		"sp_worldboss_clear_b",
		"sp_worldboss_clear_a",
		"sp_worldboss_clear_a_p"
	},
	{
		"sp_worldboss_clear_s",
		"sp_worldboss_clear_s_p",
		"sp_worldboss_clear_ss",
		"sp_worldboss_clear_ss_p",
		"sp_worldboss_clear_sss",
		"sp_worldboss_clear_sss_p"
	}
}
UIWorldBossRewardBox = ClassDef()

function UIWorldBossRewardBox.constructor(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.info = arg_1_2
	arg_1_0.vars = {}
	arg_1_0.vars.is_open = false
	arg_1_0.vars.parent = arg_1_1
	arg_1_0.vars.open_callback = arg_1_3
	arg_1_0.vars.idle_effect = nil
	
	local var_1_0 = arg_1_2.randomboxes[1]
	
	if var_1_0 and var_1_0.opts then
		local var_1_1 = var_1_0.randombox
		
		if not var_1_0.opts.rand_grade then
			local var_1_2 = 0
		end
	end
	
	local var_1_3 = arg_1_2.randomboxes[1]
	
	if var_1_3 then
		local var_1_4 = {
			no_frame = true,
			no_tooltip = true,
			no_count = true,
			scale = 1,
			no_detail_popup = true,
			parent = arg_1_1,
			touch_callback = function()
				arg_1_0:openBox()
			end
		}
		local var_1_5 = 1
		
		if var_1_3.randombox then
			for iter_1_0, iter_1_1 in pairs(SPECIALITEM_GRADE) do
				for iter_1_2, iter_1_3 in pairs(iter_1_1) do
					if var_1_3.randombox == iter_1_3 then
						var_1_5 = iter_1_0
						
						break
					end
				end
			end
		end
		
		local var_1_6 = 0
		
		if var_1_3.opts then
			var_1_6 = var_1_3.opts.rand_grade
		end
		
		local var_1_7 = UIUtil:getRewardIcon(nil, var_1_3.randombox, var_1_4)
		
		if get_cocos_refid(var_1_7) then
			local var_1_8
			
			if var_1_5 == 2 then
				if var_1_6 == 2 then
					var_1_8 = "ui_worldboss_box_unique_idle_eff2.cfx"
				elseif var_1_6 == 1 then
					var_1_8 = "ui_worldboss_box_rare_idle_eff2.cfx"
				end
			elseif var_1_6 == 2 then
				var_1_8 = "ui_worldboss_box_unique_idle_eff1.cfx"
			elseif var_1_6 == 1 then
				var_1_8 = "ui_worldboss_box_rare_idle_eff1.cfx"
			end
			
			local var_1_9 = "ui_worldboss_box_normal_open_eff.cfx"
			
			if var_1_6 == 2 then
				var_1_9 = "ui_worldboss_box_unique_open_eff.cfx"
			elseif var_1_6 == 1 then
				var_1_9 = "ui_worldboss_box_rare_open_eff.cfx"
			end
			
			arg_1_0.vars.open_path = var_1_9
			
			local var_1_10 = var_1_7:getContentSize()
			
			if var_1_10 and var_1_8 then
				arg_1_0.vars.idle_effect = EffectManager:Play({
					z = 1,
					fn = var_1_8,
					layer = var_1_7,
					x = var_1_10.width / 2,
					y = var_1_10.height / 2 - 4
				})
			end
		end
	end
end

function UIWorldBossRewardBox.openBox(arg_3_0)
	if not arg_3_0.vars then
		return 
	end
	
	if not arg_3_0.vars.parent then
		return 
	end
	
	if arg_3_0.vars.is_open then
		return 
	end
	
	arg_3_0.vars.parent:removeAllChildren()
	
	local var_3_0
	local var_3_1
	local var_3_2 = {
		scale = 1,
		no_detail_popup = true,
		parent = arg_3_0.vars.parent
	}
	
	if arg_3_0.info.new_items then
		local var_3_3 = table.count(arg_3_0.info.randomboxes) > 1 and arg_3_0.info.randomboxes[2] or arg_3_0.info.randomboxes[1]
		
		if var_3_3 then
			var_3_0 = var_3_3.count
			var_3_1 = var_3_3.code
			var_3_2 = {
				show_count = true,
				scale = 1,
				no_detail_popup = true,
				parent = arg_3_0.vars.parent
			}
		end
	elseif arg_3_0.info.new_equips then
		local var_3_4 = arg_3_0.info.new_equips[1]
		
		if var_3_4 then
			local var_3_5 = EQUIP:createByInfo(var_3_4)
			
			if var_3_5 then
				var_3_0 = "equip"
				var_3_1 = var_3_4.code
				var_3_2 = {
					no_count = true,
					parent = arg_3_0.vars.parent,
					equip = var_3_5,
					grade = var_3_5.grade
				}
			end
		end
	elseif arg_3_0.info.new_units then
		local var_3_6 = arg_3_0.info.new_units[1]
		
		if var_3_6 then
			var_3_1 = var_3_6.code
			var_3_2 = {
				no_count = true,
				no_tooltip = true,
				parent = arg_3_0.vars.parent
			}
		end
	elseif arg_3_0.info.currency_time then
		local var_3_7 = table.count(arg_3_0.info.randomboxes) > 1 and arg_3_0.info.randomboxes[2] or arg_3_0.info.randomboxes[1]
		
		if var_3_7 then
			var_3_0 = var_3_7.count
			var_3_1 = var_3_7.code
		end
	else
		table.print(arg_3_0.info.randomboxes)
		
		for iter_3_0, iter_3_1 in pairs(arg_3_0.info.randomboxes) do
			var_3_0 = iter_3_1.count
			var_3_1 = iter_3_1.code
		end
	end
	
	if var_3_1 then
		local var_3_8 = UIUtil:getRewardIcon(var_3_0, var_3_1, var_3_2)
		
		var_3_8:setOpacity(0)
		
		if get_cocos_refid(var_3_8) then
			local var_3_9 = var_3_8:getContentSize()
			
			if var_3_9 and arg_3_0.vars.open_path then
				UIAction:Add(SEQ(CALL(EffectManager.Play, EffectManager, {
					z = 1,
					fn = arg_3_0.vars.open_path,
					layer = var_3_8,
					x = var_3_9.width / 2,
					y = var_3_9.height / 2
				}), DELAY(100), OPACITY(0, 0, 1)), var_3_8, "block")
			end
		end
	end
	
	arg_3_0.vars.is_open = true
	
	if arg_3_0.vars.open_callback then
		arg_3_0.vars.open_callback()
	end
	
	return true
end

function UIWorldBossRewardBox.isOpen(arg_4_0)
	if not arg_4_0.vars then
		return 
	end
	
	return arg_4_0.vars.is_open
end

function HANDLER.clan_worldboss_result_reward(arg_5_0, arg_5_1)
	if arg_5_1 == "btn_open" then
		WorldBossBattleReward:openAllBox()
	end
	
	if arg_5_1 == "btn_ok" then
		WorldBossBattleReward:hide()
	end
end

WorldBossBattleReward = WorldBossBattleReward or {}

function WorldBossBattleReward.show(arg_6_0, arg_6_1)
	arg_6_0.vars = {}
	arg_6_0.vars.rewardBoxList = {}
	arg_6_0.vars.wnd = load_dlg("clan_worldboss_result_reward", true, "wnd")
	
	if not get_cocos_refid(arg_6_0.vars.wnd) then
		return 
	end
	
	arg_6_0.vars.wnd:setOpacity(0)
	;(arg_6_1.layer or SceneManager:getRunningNativeScene()):addChild(arg_6_0.vars.wnd)
	
	arg_6_0.parents = {}
	arg_6_0.parents.item58 = arg_6_0.vars.wnd:findChildByName("n_item_5/8")
	
	if not get_cocos_refid(arg_6_0.parents.item58) then
		return 
	end
	
	arg_6_0.parents.item24 = arg_6_0.vars.wnd:findChildByName("n_item_move2_4")
	
	if not get_cocos_refid(arg_6_0.parents.item24) then
		return 
	end
	
	arg_6_0.parents.item3 = arg_6_0.vars.wnd:findChildByName("n_item_move3")
	
	if not get_cocos_refid(arg_6_0.parents.item3) then
		return 
	end
	
	arg_6_0.vars.okBtn = arg_6_0.vars.wnd:findChildByName("btn_ok")
	
	if not get_cocos_refid(arg_6_0.vars.okBtn) then
		return 
	end
	
	arg_6_0.vars.okBtn:setVisible(false)
	
	arg_6_0.vars.openBtn = arg_6_0.vars.wnd:findChildByName("btn_open")
	
	if not get_cocos_refid(arg_6_0.vars.openBtn) then
		return 
	end
	
	arg_6_0.vars.openBtn:setVisible(true)
	if_set_sprite(arg_6_0.vars.wnd, "icon_rank", "img/rank_raid_" .. string.lower(arg_6_1.grade) .. ".png")
	
	if arg_6_1.reward then
		local var_6_0 = table.count(arg_6_1.reward)
		local var_6_1
		
		if var_6_0 > 4 then
			local var_6_2 = arg_6_0.parents.item58
		elseif var_6_0 == 2 or var_6_0 == 4 then
			local var_6_3 = arg_6_0.parents.item24
		else
			local var_6_4 = arg_6_0.parents.item3
		end
		
		local var_6_5
		
		for iter_6_0, iter_6_1 in pairs(arg_6_1.reward) do
			local var_6_6 = iter_6_1.randomboxes[1]
			
			if var_6_6 then
				local var_6_7 = var_6_6.randombox
				
				var_6_5 = DB("item_special", var_6_7, "value")
				
				if var_6_5 then
					break
				end
			end
		end
		
		local var_6_8 = {}
		local var_6_9
		
		if var_6_5 then
			var_6_9 = nil
			
			for iter_6_2 = 1, 9999 do
				local var_6_10, var_6_11, var_6_12, var_6_13 = DBN("randombox", iter_6_2, {
					"id",
					"item_special_value",
					"item_id",
					"rate"
				})
				
				if var_6_5 == var_6_11 then
					var_6_8[var_6_12] = var_6_13
					var_6_9 = true
				elseif var_6_9 then
					break
				end
			end
		end
		
		local var_6_14 = 0
		
		for iter_6_3, iter_6_4 in pairs(var_6_8) do
			var_6_14 = var_6_14 + iter_6_4
		end
		
		for iter_6_5, iter_6_6 in pairs(arg_6_1.reward) do
			local var_6_15 = arg_6_0.parents.item58:findChildByName("n_" .. iter_6_5)
			
			if get_cocos_refid(var_6_15) then
				local var_6_16 = UIWorldBossRewardBox(var_6_15, iter_6_6, function()
					arg_6_0:onOpenBox()
				end)
				
				table.insert(arg_6_0.vars.rewardBoxList, var_6_16)
			end
		end
	end
	
	BackButtonManager:push({
		check_id = "WorldBossBattleReward.backButton",
		back_func = function()
			arg_6_0:backButton()
		end
	})
	UIAction:Add(FADE_IN(300), arg_6_0.vars.wnd, "block")
end

function WorldBossBattleReward.hide(arg_9_0)
	if not arg_9_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_9_0.vars.wnd) then
		return 
	end
	
	BackButtonManager:pop("WorldBossBattleReward.backButton")
	
	if arg_9_0.vars and get_cocos_refid(arg_9_0.vars.wnd) then
		UIAction:Add(SEQ(FADE_OUT(200), REMOVE()), arg_9_0.vars.wnd, "block")
	end
end

function WorldBossBattleReward.backButton(arg_10_0)
	if not arg_10_0:_isAllOpen() then
		arg_10_0:openAllBox()
	else
		arg_10_0:hide()
	end
end

function WorldBossBattleReward.openAllBox(arg_11_0)
	if not arg_11_0.vars then
		return 
	end
	
	if not arg_11_0.vars.rewardBoxList then
		return 
	end
	
	local var_11_0 = 1
	local var_11_1 = table.count(arg_11_0.vars.rewardBoxList)
	
	UIAction:Add(COND_LOOP(DELAY(1000), function()
		local var_12_0 = arg_11_0.vars.rewardBoxList[var_11_0]
		
		if var_12_0 then
			var_12_0:openBox()
			
			var_11_0 = var_11_0 + 1
		end
		
		if var_11_0 > var_11_1 then
			return true
		end
	end), arg_11_0.vars.wnd, "block")
	arg_11_0.vars.openBtn:setVisible(false)
	arg_11_0.vars.okBtn:setVisible(true)
end

function WorldBossBattleReward.onOpenBox(arg_13_0)
	if arg_13_0:_isAllOpen() then
		arg_13_0.vars.openBtn:setVisible(false)
		arg_13_0.vars.okBtn:setVisible(true)
	end
end

function WorldBossBattleReward._isAllOpen(arg_14_0)
	local var_14_0 = true
	
	for iter_14_0, iter_14_1 in pairs(arg_14_0.vars.rewardBoxList) do
		if not iter_14_1:isOpen() then
			var_14_0 = false
			
			break
		end
	end
	
	return var_14_0
end
