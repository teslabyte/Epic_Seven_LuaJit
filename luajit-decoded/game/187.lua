BattleRepeat = {}
BattleRepeat.map_id = nil

local var_0_0 = {}

local function var_0_1(arg_1_0, arg_1_1)
	if ignore_crc32 then
		return 
	end
	
	if not bit then
		return 
	end
	
	if not bit.bxor64 then
		return 
	end
	
	if not bit.bhash64 then
		return 
	end
	
	local var_1_0 = math.random(268435456, 4294967295)
	
	local function var_1_1(arg_2_0, arg_2_1)
		if not arg_2_1 then
			return 
		end
		
		var_0_0[arg_2_0] = var_0_0[arg_2_0] or math.random(1, 1000)
		
		return bit.bhash64(arg_2_1 + var_0_0[arg_2_0])
	end
	
	local function var_1_2(arg_3_0, arg_3_1)
		if not arg_3_0 then
			return 
		end
		
		if arg_3_1 then
			if not arg_3_0 then
				return 
			end
			
			return bit.bxor64(arg_3_0[1] or 0, arg_3_0[2])
		end
		
		return {
			bit.bxor64(arg_3_0, var_1_0),
			var_1_0
		}
	end
	
	local function var_1_3(arg_4_0)
		local var_4_0 = {
			__index = function(arg_5_0, arg_5_1)
				local var_5_0 = getmetatable(arg_5_0)
				local var_5_1 = var_5_0.hash[arg_5_1]
				
				if var_5_1 then
					local var_5_2 = var_1_2(var_5_0.enval[arg_5_1], true)
					local var_5_3 = var_1_1(arg_5_1, var_5_2)
					
					if var_5_3 == var_5_1 then
					elseif not var_5_0.error[arg_5_1] then
						var_5_0.error[arg_5_1] = true
						
						if #g_UNIT_CONVIC < 5 then
							local var_5_4 = var_5_0.enval[arg_5_1] and var_5_0.enval[arg_5_1][1]
							local var_5_5 = var_5_0.enval[arg_5_1] and var_5_0.enval[arg_5_1][2]
							
							table.insert(g_UNIT_CONVIC, {
								reason = "mem." .. tostring(arg_5_1),
								k0 = arg_5_1,
								k1 = var_5_4,
								k2 = var_5_5,
								v0 = var_5_2,
								c0 = var_5_1,
								c1 = var_5_3
							})
						end
					end
					
					return var_5_2
				end
				
				return rawget(arg_5_0, arg_5_1)
			end,
			__newindex = function(arg_6_0, arg_6_1, arg_6_2)
				local var_6_0 = getmetatable(arg_6_0)
				
				if var_6_0.hash[arg_6_1] then
					var_6_0.enval[arg_6_1] = var_1_2(arg_6_2)
					var_6_0.hash[arg_6_1] = var_1_1(arg_6_1, arg_6_2)
					
					return 
				else
					rawset(arg_6_0, arg_6_1, arg_6_2)
				end
			end,
			__pairs = function(arg_7_0)
				local function var_7_0(arg_8_0, arg_8_1)
					local var_8_0
					local var_8_1
					
					arg_8_1, var_8_1 = next(arg_8_0, arg_8_1)
					
					if var_8_1 then
						return arg_8_1, var_8_1
					end
				end
				
				local var_7_1
				local var_7_2
				local var_7_3 = {}
				
				repeat
					local var_7_4
					
					var_7_1, var_7_4 = next(arg_7_0, var_7_1)
					
					if var_7_1 then
						var_7_3[var_7_1] = var_7_4
					end
				until not var_7_4
				
				local var_7_5 = getmetatable(arg_7_0)
				local var_7_6
				
				repeat
					local var_7_7
					
					var_7_6, var_7_7 = next(var_7_5.enval, var_7_6)
					
					if var_7_6 then
						var_7_3[var_7_6] = var_1_2(var_7_7, true)
					end
				until not var_7_7
				
				return var_7_0, var_7_3, nil
			end
		}
		
		if getmetatable(arg_4_0) then
			return arg_4_0
		end
		
		local var_4_1 = {}
		local var_4_2 = {}
		local var_4_3 = {}
		
		for iter_4_0, iter_4_1 in pairs(arg_4_0) do
			if type(iter_4_1) == "number" then
				var_4_3[iter_4_0] = var_1_2(iter_4_1)
				var_4_2[iter_4_0] = var_1_1(iter_4_0, iter_4_1)
			else
				var_4_1[iter_4_0] = iter_4_1
			end
		end
		
		var_4_0.error = {}
		var_4_0.enval = var_4_3
		var_4_0.hash = var_4_2
		
		setmetatable(var_4_1, var_4_0)
		
		return var_4_1
	end
	
	local function var_1_4(arg_9_0)
		local var_9_0 = getmetatable(arg_9_0, nil)
		
		setmetatable(arg_9_0, nil)
		
		if var_9_0 and var_9_0.enval then
			for iter_9_0, iter_9_1 in pairs(var_9_0.enval) do
				arg_9_0[iter_9_0] = var_1_2(iter_9_1, true)
			end
		end
		
		return arg_9_0
	end
	
	if arg_1_1 then
		arg_1_0(var_1_3)
	else
		arg_1_0(var_1_4)
	end
end

local function var_0_2(arg_10_0, arg_10_1)
	local var_10_0 = math.random(268435456, 4294967295)
	
	local function var_10_1(arg_11_0, arg_11_1)
		return crc32_string(tostring(arg_11_0), arg_11_1)
	end
	
	local function var_10_2(arg_12_0, arg_12_1)
		if not arg_12_0 then
			return 
		end
		
		if arg_12_1 then
			if not arg_12_0 then
				return 
			end
			
			local var_12_0, var_12_1 = math.modf(tonumber(arg_12_0[2]) or 0)
			
			return bit.bxor(arg_12_0[1] or 0, arg_12_0[3]) + var_12_1
		end
		
		local var_12_2, var_12_3 = math.modf(arg_12_0)
		
		return {
			bit.bxor(var_12_2, var_10_0),
			var_12_3,
			var_10_0
		}
	end
	
	local function var_10_3(arg_13_0)
		local var_13_0 = {
			__index = function(arg_14_0, arg_14_1)
				local var_14_0 = getmetatable(arg_14_0)
				local var_14_1 = var_14_0.crc32[arg_14_1]
				
				if var_14_1 then
					local var_14_2 = var_10_2(var_14_0.enval[arg_14_1], true)
					
					if var_10_1(arg_14_1, var_14_2) == var_14_1 then
					elseif not var_14_0.error[arg_14_1] then
						var_14_0.error[arg_14_1] = true
						
						if #g_UNIT_CONVIC < 5 then
						end
					end
					
					return var_14_2
				end
				
				return rawget(arg_14_0, arg_14_1)
			end,
			__newindex = function(arg_15_0, arg_15_1, arg_15_2)
				local var_15_0 = getmetatable(arg_15_0)
				
				if var_15_0.crc32[arg_15_1] then
					var_15_0.enval[arg_15_1] = var_10_2(arg_15_2)
					var_15_0.crc32[arg_15_1] = var_10_1(arg_15_1, arg_15_2)
					
					return 
				end
				
				rawset(arg_15_0, arg_15_1, arg_15_2)
			end,
			__pairs = function(arg_16_0)
				local function var_16_0(arg_17_0, arg_17_1)
					local var_17_0
					local var_17_1
					
					arg_17_1, var_17_1 = next(arg_17_0, arg_17_1)
					
					if var_17_1 then
						return arg_17_1, var_17_1
					end
				end
				
				local var_16_1
				local var_16_2
				local var_16_3 = {}
				
				repeat
					local var_16_4
					
					var_16_1, var_16_4 = next(arg_16_0, var_16_1)
					
					if var_16_1 then
						var_16_3[var_16_1] = var_16_4
					end
				until not var_16_4
				
				local var_16_5 = getmetatable(arg_16_0)
				local var_16_6
				
				repeat
					local var_16_7
					
					var_16_6, var_16_7 = next(var_16_5.enval, var_16_6)
					
					if var_16_6 then
						var_16_3[var_16_6] = var_10_2(var_16_7, true)
					end
				until not var_16_7
				
				return var_16_0, var_16_3, nil
			end
		}
		
		if getmetatable(arg_13_0) then
			return arg_13_0
		end
		
		local var_13_1 = {}
		local var_13_2 = {}
		local var_13_3 = {}
		local var_13_4 = {}
		
		for iter_13_0, iter_13_1 in pairs(arg_13_0) do
			if type(iter_13_1) == "number" then
				var_13_4[iter_13_0] = var_10_2(iter_13_1)
				var_13_2[iter_13_0] = var_10_1(iter_13_0, iter_13_1)
			else
				var_13_1[iter_13_0] = iter_13_1
			end
		end
		
		var_13_0.error = {}
		var_13_0.enval = var_13_4
		var_13_0.crc32 = var_13_2
		
		setmetatable(var_13_1, var_13_0)
		
		return var_13_1
	end
	
	local function var_10_4(arg_18_0)
		local var_18_0 = getmetatable(arg_18_0, nil)
		
		setmetatable(arg_18_0, nil)
		
		if var_18_0 and var_18_0.enval then
			for iter_18_0, iter_18_1 in pairs(var_18_0.enval) do
				arg_18_0[iter_18_0] = var_10_2(iter_18_1, true)
			end
		end
		
		return arg_18_0
	end
	
	if arg_10_1 then
		arg_10_0.encrypt = var_10_3(arg_10_0.encrypt)
	else
		arg_10_0.encrypt = var_10_4(arg_10_0.encrypt)
	end
end

function BattleRepeat.initBeforeBattleStart(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
	if not arg_19_1 or not arg_19_2 then
		return 
	end
	
	if BackPlayManager:isRunning() or BattleReady:isQuestExistOnReady() then
		return 
	end
	
	arg_19_0.map_id = arg_19_2
	arg_19_0.opts = arg_19_3 or {}
	
	local var_19_0 = arg_19_3.is_descent
	local var_19_1 = arg_19_3.is_burning
	local var_19_2 = arg_19_3.npcteam_id
	local var_19_3 = arg_19_3.is_crehunt
	local var_19_4
	local var_19_5 = arg_19_1
	local var_19_6 = Account:getPetInTeam(var_19_5) or nil
	
	if var_19_0 then
		var_19_4 = {}
		
		for iter_19_0, iter_19_1 in pairs(DESCENT_TEAM_IDX) do
			local var_19_7 = Account:getTeam(iter_19_1)
			
			if var_19_7 and not table.empty(var_19_7) then
				for iter_19_2, iter_19_3 in pairs(var_19_7) do
					table.insert(var_19_4, iter_19_3)
				end
			end
		end
	elseif var_19_1 then
		var_19_4 = {}
		
		for iter_19_4, iter_19_5 in pairs(BURNING_TEAM_IDX) do
			local var_19_8 = Account:getTeam(iter_19_5)
			
			if var_19_8 and not table.empty(var_19_8) then
				for iter_19_6, iter_19_7 in pairs(var_19_8) do
					table.insert(var_19_4, iter_19_7)
				end
			end
		end
	else
		var_19_4 = Account:getTeam(var_19_5)
	end
	
	local var_19_9 = PetUtil:set_repeatBattle(arg_19_2, var_19_6, {
		team_idx = var_19_5,
		is_descent = var_19_0,
		is_burning = var_19_1,
		is_npc_team = var_19_2,
		is_crehunt = var_19_3
	})
	
	arg_19_0:setConfigRepeatPlay(var_19_9)
	arg_19_0:initScoreRate()
	
	if var_19_9 then
		arg_19_0.teamInfo = var_19_4
		
		arg_19_0:markMaxLevelUnit(var_19_4)
		arg_19_0:markMaxFavoriteUnit(var_19_4)
		arg_19_0:reset_repeatCount(var_19_5)
		arg_19_0:set_urgentMissionNotiCount(0)
	else
		arg_19_0:disableRepeatBattleCount()
	end
	
	arg_19_0:set_isEndRepeatPlay(false)
	arg_19_0:resetPetRepeatItems()
	arg_19_0:reset_coopMissionCount()
	BackPlayControlBox:resetValue()
end

function BattleRepeat.stop_repeatPlay(arg_20_0)
	balloon_message_with_sound("ui_pet_auto_battle_off_ok")
	arg_20_0:setConfigRepeatPlay(false)
	arg_20_0:set_isEndRepeatPlay(true)
	
	if not SAVE:getKeep("app.auto_battle") then
		Battle:toggleAutoBattle()
	end
	
	BattleRepeat.isCounting = false
	
	if get_cocos_refid(BattleTopBar.topbar_wnd) then
		if_set_opacity(BattleTopBar.topbar_wnd, "btn_top_auto", 255)
	end
	
	BattleTopBar:close_RepeateControl()
end

function BattleRepeat.end_repeatPlay(arg_21_0, arg_21_1)
	local var_21_0 = arg_21_1 or false
	
	balloon_message_with_sound("ui_pet_auto_battle_off_ok")
	
	BattleRepeat.isCounting = false
	
	arg_21_0:set_isEndRepeatPlay(true)
	
	if var_21_0 then
		BattleTopBar:open_RepeateControlAgain()
	else
		BattleTopBar:close_RepeateControl()
	end
end

function BattleRepeat.setCheckBoxValue(arg_22_0, arg_22_1)
	if not arg_22_0.vars then
		arg_22_0.vars = {}
	end
	
	arg_22_0.vars.checkBoxValue = arg_22_1
end

function BattleRepeat.getCheckBoxValue(arg_23_0)
	if not arg_23_0.vars then
		arg_23_0.vars = {}
	end
	
	if arg_23_0:isInGamePVP() then
		return false
	end
	
	if arg_23_0.is_pet_blocking then
		return false
	end
	
	if arg_23_0.vars.checkBoxValue == nil then
		arg_23_0.vars.checkBoxValue = arg_23_0:getConfigRepeatPlay()
	end
	
	return arg_23_0.vars.checkBoxValue
end

function BattleRepeat.set_checkBox(arg_24_0, arg_24_1, arg_24_2)
	if not arg_24_0.repaet_checkbox or not get_cocos_refid(arg_24_0.n_checkbox) then
		return 
	end
	
	local var_24_0 = arg_24_2 or BattleReady:getEnterID()
	
	if not var_24_0 then
		return 
	end
	
	if not UnlockSystem:isUnlockSystem(UNLOCK_ID.PET) then
		arg_24_0.n_checkbox:setVisible(false)
		
		return 
	end
	
	arg_24_0.n_checkbox:setVisible(true)
	
	if not PetUtil:isPetEnableMap(var_24_0) or not Account:isMapCleared(var_24_0) or string.starts(var_24_0, "tot") or not BattleRepeat:check_cleared_ije005() or not PetUtil:isRepeatBattleEnableMap(var_24_0) or BackPlayManager:isRunning() or BattleReady:isQuestExistOnReady() then
		arg_24_0.n_checkbox:setOpacity(76.5)
		
		return 
	end
	
	if arg_24_1 == false then
		arg_24_0.n_checkbox:setOpacity(76.5)
	else
		arg_24_0.n_checkbox:setOpacity(255)
	end
end

function BattleRepeat.check_cleared_ije005(arg_25_0)
	if DEBUG.MAP_DEBUG then
		return true
	end
	
	return Account:isMapCleared("ije005")
end

function BattleRepeat.toggle_repeatPlay(arg_26_0)
	local var_26_0 = BattleRepeat:getCheckBoxValue()
	local var_26_1 = BattleReady:getEnterID()
	local var_26_2 = BattleRepeat.is_pet_blocking or false
	local var_26_3 = false
	local var_26_4 = false
	
	if not var_26_1 then
		var_26_1 = DescentReady:getEnterID()
		
		if var_26_1 and DescentReady:isShow() then
			var_26_3 = true
		end
		
		if not var_26_1 then
			var_26_1 = BurningReady:getEnterID()
			
			if var_26_1 and BurningReady:isShow() then
				var_26_4 = true
			end
		end
	end
	
	if var_26_1 then
		if not PetUtil:isPetEnableMap(var_26_1) then
			balloon_message_with_sound("ui_pet_repeat_cant_stage")
			BattleRepeat.repaet_checkbox:setSelected(var_26_0)
			
			return 
		end
		
		if not PetUtil:isRepeatBattleEnableMap(var_26_1) or var_26_2 then
			balloon_message_with_sound("pet_ui_battle_no_repeat")
			BattleRepeat.repaet_checkbox:setSelected(var_26_0)
			
			return 
		end
		
		if not Account:isMapCleared(var_26_1) then
			balloon_message_with_sound("ui_pet_repeat_one_clear")
			BattleRepeat.repaet_checkbox:setSelected(var_26_0)
			
			return 
		end
		
		if BattleReady:isQuestExistOnReady() then
			balloon_message_with_sound("msg_bgbattle_questmap_not_possible")
			BattleRepeat.repaet_checkbox:setSelected(var_26_0)
			
			return 
		end
		
		if string.starts(var_26_1, "tot") or not BattleRepeat:check_cleared_ije005() then
			BattleRepeat.repaet_checkbox:setSelected(var_26_0)
			
			return 
		end
		
		local var_26_5 = Account:getCurrentTeam()
		
		if var_26_3 then
			var_26_5 = Account:getTeam(DESCENT_TEAM_IDX[1])
		elseif var_26_4 then
			var_26_5 = Account:getTeam(BURNING_TEAM_IDX[1])
		end
		
		if DungeonCreviceUtil:isCrehuntMode(var_26_1) then
			var_26_5 = Account:getTeam(Account:getCrehuntTeamIndex())
		end
		
		if not var_26_5 or not var_26_5[7] then
			balloon_message_with_sound("ui_repeat_no_pet")
			BattleRepeat.repaet_checkbox:setSelected(var_26_0)
			
			return 
		end
		
		if BackPlayManager:isRunning() then
			balloon_message_with_sound("msg_bgbattle_pet_check_error")
			BattleRepeat.repaet_checkbox:setSelected(var_26_0)
			
			return 
		end
	end
	
	BattleRepeat:setCheckBoxValue(not var_26_0)
	
	if get_cocos_refid(BattleRepeat.repaet_checkbox) then
		BattleRepeat.repaet_checkbox:setSelected(not var_26_0)
	end
end

function BattleRepeat.block_buttons(arg_27_0, arg_27_1)
	local var_27_0 = {
		btn_lobby = true,
		btn_hero_upgrade = true,
		btn_lose_again = true,
		btn_lose_guide = true,
		btn_stat = true,
		btn_discussion = true,
		btn_sell = true,
		btn_next = true,
		btn_go = true,
		btn_growth_guide = true,
		btn_delete = true,
		btn_delete_after = true,
		btn_back = true
	}
	
	if not arg_27_0:get_isEndRepeatPlay() and Battle.logic and not Battle.logic:isPVP() and not Battle.logic:isTutorial() and Battle:isAutoPlayableStage() and BattleRepeat.isCounting then
		if BackPlayManager:isRunning() then
			return false
		end
		
		if var_27_0[arg_27_1] or string.starts(arg_27_1, "btn_move") then
			balloon_message_with_sound("ui_pet_auto_battle_other_btn")
			
			return true
		end
	end
	
	return false
end

function BattleRepeat.canRepeatPlayContinue(arg_28_0, arg_28_1)
	local var_28_0 = arg_28_1 or {}
	
	if var_28_0.back_ground_disable then
		arg_28_0:end_repeatPlay()
		BattleRepeat:_debugLogErr("Err: Content Disable")
		
		return 
	end
	
	if not BattleRepeat.map_id or not arg_28_0:getConfigRepeatPlay() or BattleRepeat:get_repeatCount() <= 0 then
		if BattleRepeat:get_repeatCount() <= 0 then
			balloon_message_with_sound("ui_pet_auto_battle_off_ok")
			
			BattleRepeat.isCounting = false
			
			BattleTopBar:setEnd_repeatCountText()
			BattleRepeatPopup:closeItemListPopup()
		else
			arg_28_0:end_repeatPlay()
		end
		
		BattleRepeat:_debugLogErr("Err: 반복전투 횟수 만료 종료")
		
		return 
	end
	
	if var_28_0.lose and not arg_28_0:getRepeaatLose() then
		arg_28_0:end_repeatPlay(true)
		BattleRepeat:_debugLogErr("Err: 반복전투 패배후 전투종료")
		
		return 
	end
	
	local var_28_1 = false
	local var_28_2
	
	var_28_0.is_only_repeat = true
	
	if not UIUtil:checkUnitInven(nil, var_28_0) then
		var_28_1 = true
		var_28_2 = "max_unit"
	elseif not UIUtil:checkTotalInven(var_28_0) then
		var_28_1 = true
		var_28_2 = "max_inven"
	end
	
	if var_28_1 then
		arg_28_0:end_repeatPlay(true)
		
		return false, var_28_2
	end
	
	if not arg_28_0:checkUnits() then
		arg_28_0:end_repeatPlay(true)
		BattleRepeat:_debugLogErr("Err: 반복전투 만랩유닛 발생으로 인해 종료")
		
		return false
	end
	
	if not arg_28_0:checkFavoriteUnit() then
		arg_28_0:end_repeatPlay(true)
		BattleRepeat:_debugLogErr("Err: 반복전투 호감도 만렙 유닛 발생으로 인해 종료")
		
		return false
	end
	
	local var_28_3, var_28_4, var_28_5 = BattleRepeat:getEnterInfo(BattleRepeat.map_id)
	
	if not var_28_3 and var_28_5 then
		arg_28_0:end_repeatPlay(true)
		BattleRepeat:_debugLogErr("Err: 반복전투 입장재화 부족 관련 종료")
		
		return 
	end
	
	if not var_28_3 and var_28_4 == "to_stamina" then
		local var_28_6
		
		if Account:getConfigData("autoBuyStamina_currency") == "to_crystal" then
			var_28_6 = "currency_4"
		elseif Account:getConfigData("autoBuyStamina_currency") == "to_light" then
			var_28_6 = "currency_9"
		elseif Account:getConfigData("autoBuyStamina_currency") == "all" then
			var_28_6 = Account:getCurrency("to_light") > 0 and "currency_9" or "currency_4"
		end
		
		if var_28_6 then
			local var_28_7 = var_28_0.caller or "battle_repeat"
			
			query("buy", {
				shop = "normal",
				item = var_28_6,
				caller = var_28_7
			})
			
			return false, "buy_req"
		else
			BattleRepeat:_debugLogErr("Err: 반복전투 입장재화 부족 관련 종료")
		end
	end
	
	local var_28_8, var_28_9 = DB("level_enter", BattleRepeat.map_id, {
		"id",
		"type"
	})
	
	if var_28_9 and var_28_9 == "genie" and not checkGenieEnterable(BattleRepeat.map_id) then
		arg_28_0:end_repeatPlay(true)
		BattleRepeat:_debugLogErr("Err: 정령의제단 입장불가능으로 변경되서 종료")
		
		return false, "no_genie_enter"
	end
	
	return true
end

function BattleRepeat._debugLogErr(arg_29_0, arg_29_1)
	if not arg_29_1 then
		return 
	end
	
	if PRODUCTION_MODE then
		return 
	end
	
	print("error BattleRepeat: " .. arg_29_1)
end

function BattleRepeat.repeat_battle(arg_30_0, arg_30_1)
	local var_30_0 = arg_30_1 or {}
	
	if not arg_30_0:canRepeatPlayContinue(var_30_0) then
		return 
	end
	
	local function var_30_1()
		local var_31_0 = BattleTopBar:get_repeateControl()
		
		if get_cocos_refid(var_31_0) then
			if_set_visible(var_31_0, "n_count", true)
			if_set_visible(var_31_0, "game_eff_score", false)
			
			local var_31_1 = var_31_0:getChildByName("n_number")
			
			arg_30_0.countDown = 5
			arg_30_0.lb_countDown = cc.Label:createWithBMFont("font/score.fnt", comma_value(arg_30_0.countDown))
			
			arg_30_0.lb_countDown:setAlignment(cc.TEXT_ALIGNMENT_CENTER)
			
			arg_30_0.isCounting = true
			
			var_31_1:addChild(arg_30_0.lb_countDown)
			Scheduler:addSlow(var_31_0, arg_30_0.counting, arg_30_0)
		end
	end
	
	arg_30_0:req_startBattle(var_30_1)
end

function BattleRepeat.req_startBattle(arg_32_0, arg_32_1)
	local function var_32_0()
		local var_33_0 = DB("level_enter", BattleRepeat.map_id, {
			"supporter"
		})
		
		BattleRepeat.auto_supporter_unit = nil
		
		if var_33_0 then
			BattleRepeat.auto_supporter_unit = BattleReadyFriends:setAutoFriend(BattleRepeat.map_id)
			
			if not BattleRepeat.auto_supporter_unit then
				BattleReadyFriends:clearLastUseFriend(BattleRepeat.map_id)
			end
		end
		
		if arg_32_1 then
			arg_32_1()
		end
	end
	
	if not BattleReadyFriends:requestFriend(var_32_0, BattleRepeat.map_id, true) then
		var_32_0()
	end
end

function BattleRepeat.counting(arg_34_0)
	if PAUSED then
		return 
	end
	
	if arg_34_0.countDown >= 0 then
		arg_34_0.lb_countDown:setString(arg_34_0.countDown)
		
		arg_34_0.countDown = arg_34_0.countDown - 1
		
		if not arg_34_0:getConfigRepeatPlay() then
			Scheduler:remove(BattleRepeat.counting)
			
			BattleRepeat.isCounting = false
			
			return 
		end
	elseif arg_34_0:getConfigRepeatPlay() then
		if not BackPlayManager:isRunning() then
			BattleRepeat:repeat_battle_start()
		end
		
		Scheduler:remove(BattleRepeat.counting)
		
		BattleRepeat.isCounting = false
		
		return 
	end
end

function BattleRepeat.init_repeatCheckbox(arg_35_0, arg_35_1, arg_35_2, arg_35_3)
	if not get_cocos_refid(arg_35_1) then
		return 
	end
	
	arg_35_0.n_checkbox = arg_35_1
	arg_35_0.repaet_checkbox = arg_35_1:getChildByName("checkbox_g")
	
	if not arg_35_0.repaet_checkbox then
		return 
	end
	
	arg_35_0.is_pet_blocking = arg_35_3
	
	arg_35_0.repaet_checkbox:addEventListener(BattleRepeat.toggle_repeatPlay)
	arg_35_0:set_checkBox(nil, arg_35_2)
	arg_35_0.repaet_checkbox:setSelected(arg_35_0:getCheckBoxValue())
end

function BattleRepeat.update_repeatCheckbox(arg_36_0)
	if not get_cocos_refid(arg_36_0.n_checkbox) then
		return 
	end
	
	arg_36_0:set_checkBox()
	arg_36_0.repaet_checkbox:setSelected(arg_36_0:getCheckBoxValue())
end

function BattleRepeat.getRepeatBattleInfo(arg_37_0, arg_37_1)
	if not arg_37_1 then
		return 
	end
	
	if arg_37_0:getConfigRepeatPlay() then
		local var_37_0
		local var_37_1 = 0
		
		arg_37_0.encrypt = arg_37_0.encrypt or {}
		
		if bit and bit.bxor64 and bit.bhash64 then
			var_0_1(function(arg_38_0)
				arg_37_0.encrypt = arg_38_0(arg_37_0.encrypt)
			end, false)
		else
			var_0_2(arg_37_0, false)
		end
		
		local var_37_2 = arg_37_0:getKey()
		local var_37_3 = arg_37_0:get_repeatCount()
		
		if bit and bit.bxor64 and bit.bhash64 then
			var_0_1(function(arg_39_0)
				arg_37_0.encrypt = arg_39_0(arg_37_0.encrypt)
			end, true)
		else
			var_0_2(arg_37_0, true)
		end
		
		arg_37_1.pet_repeat = var_37_2
		arg_37_1.repeat_count = var_37_3
	end
end

function BattleRepeat.repeat_battle_start(arg_40_0, arg_40_1, arg_40_2)
	arg_40_2 = arg_40_2 or {}
	
	local var_40_0, var_40_1, var_40_2 = BattleRepeat:getEnterInfo(BattleRepeat.map_id)
	
	if var_40_0 then
		if bit and bit.bxor64 and bit.bhash64 then
			var_0_1(function(arg_41_0)
				arg_40_0.encrypt = arg_41_0(arg_40_0.encrypt)
			end, false)
		else
			var_0_2(arg_40_0, false)
		end
		
		arg_40_0:set_repeatCount(arg_40_0:get_repeatCount() - 1)
		
		if bit and bit.bxor64 and bit.bhash64 then
			var_0_1(function(arg_42_0)
				arg_40_0.encrypt = arg_42_0(arg_40_0.encrypt)
			end, true)
		else
			var_0_2(arg_40_0, true)
		end
		
		if not BattleRepeat.opts then
			BattleRepeat.opts = {}
		end
		
		BattleRepeat.opts.use_friend = BattleRepeat.auto_supporter_unit
		BattleRepeat.opts.repeat_battle = true
		BattleRepeat.opts.is_back_ground = arg_40_1
		BattleRepeat.opts.back_play_team_idx = arg_40_2.back_ground_team_idx
		
		arg_40_0:getRepeatBattleInfo(BattleRepeat.opts)
		ChatMain:setRepeatMode(ChatMain:isVisible())
		ChatEmojiPopup:setRepeatMode(ChatEmojiPopup:isVisible())
		startBattle(BattleRepeat.map_id, BattleRepeat.opts)
		BattleTopBar:update_repeatCount()
	elseif not var_40_0 and var_40_2 then
		if BackPlayManager:isRunning() then
			BackPlayManager:endRepeatPlay()
		end
		
		BackPlayManager:setRunning(false)
		balloon_message_with_sound("battle_cant_getin")
		BattleTopBar:close_RepeateControl()
	else
		balloon_message_with_sound("ui_pet_repeat_token_off")
		
		if BackPlayManager:isRunning() then
			BackPlayManager:endRepeatPlay()
		end
		
		BackPlayManager:setRunning(false)
		arg_40_0:set_isEndRepeatPlay(true)
		if_set_visible(BattleTopBar:get_repeateControl(), "n_count", false)
		BattleTopBar:open_RepeateControlAgain()
	end
end

function BattleRepeat.disableRepeatBattleCount(arg_43_0)
	if BackPlayManager:isRunning() or BackPlayControlBox:canOpen() then
		return 
	end
	
	if not arg_43_0.encrypt or not arg_43_0.encrypt.repeatBattle_count then
		arg_43_0.encrypt = {}
		arg_43_0.encrypt.repeatBattle_count = -1
		arg_43_0.encrypt.key = os.time()
		
		if bit and bit.bxor64 and bit.bhash64 then
			var_0_1(function(arg_44_0)
				arg_43_0.encrypt = arg_44_0(arg_43_0.encrypt)
			end, true)
		else
			var_0_2(arg_43_0, true)
		end
		
		return 
	end
	
	if bit and bit.bxor64 and bit.bhash64 then
		var_0_1(function(arg_45_0)
			arg_43_0.encrypt = arg_45_0(arg_43_0.encrypt)
		end, false)
	else
		var_0_2(arg_43_0, false)
	end
	
	arg_43_0.encrypt.repeatBattle_count = -1
	arg_43_0.encrypt.key = os.time()
	
	if bit and bit.bxor64 and bit.bhash64 then
		var_0_1(function(arg_46_0)
			arg_43_0.encrypt = arg_46_0(arg_43_0.encrypt)
		end, true)
	else
		var_0_2(arg_43_0, true)
	end
	
	if not arg_43_0.vars then
		arg_43_0.vars = {}
	end
end

function BattleRepeat.reset_repeatCount(arg_47_0, arg_47_1)
	if not arg_47_0.encrypt or not arg_47_0.encrypt.repeatBattle_count then
		arg_47_0.encrypt = {}
		arg_47_0.encrypt.repeatBattle_count = arg_47_0:getConfigRepeatBattleCount(arg_47_1)
		arg_47_0.encrypt.key = os.time()
		
		if bit and bit.bxor64 and bit.bhash64 then
			var_0_1(function(arg_48_0)
				arg_47_0.encrypt = arg_48_0(arg_47_0.encrypt)
			end, true)
		else
			var_0_2(arg_47_0, true)
		end
		
		return 
	end
	
	if bit and bit.bxor64 and bit.bhash64 then
		var_0_1(function(arg_49_0)
			arg_47_0.encrypt = arg_49_0(arg_47_0.encrypt)
		end, false)
	else
		var_0_2(arg_47_0, false)
	end
	
	arg_47_0.encrypt.repeatBattle_count = arg_47_0:getConfigRepeatBattleCount(arg_47_1)
	arg_47_0.encrypt.key = os.time()
	
	if bit and bit.bxor64 and bit.bhash64 then
		var_0_1(function(arg_50_0)
			arg_47_0.encrypt = arg_50_0(arg_47_0.encrypt)
		end, true)
	else
		var_0_2(arg_47_0, true)
	end
	
	if not arg_47_0.vars then
		arg_47_0.vars = {}
	end
end

function BattleRepeat.incLoseScore(arg_51_0, arg_51_1)
	if not arg_51_0.vars or not arg_51_1 and not arg_51_0:isPlayingRepeatPlay() then
		return 
	end
	
	if not arg_51_1 and BackPlayManager:isRunning() then
		return 
	end
	
	if BattleRepeat:get_repeatMaxCount() == BattleRepeat:get_repeatCount() then
		return 
	end
	
	arg_51_0.vars.lose_score = arg_51_0.vars.lose_score + 1
	
	BattleTopBar:update_winRateScore()
end

function BattleRepeat.incWinScore(arg_52_0, arg_52_1)
	if not arg_52_0.vars or not arg_52_1 and not arg_52_0:isPlayingRepeatPlay() then
		return 
	end
	
	if not arg_52_1 and BackPlayManager:isRunning() then
		return 
	end
	
	if BattleRepeat:get_repeatMaxCount() == BattleRepeat:get_repeatCount() then
		return 
	end
	
	arg_52_0.vars.win_score = arg_52_0.vars.win_score + 1
	
	BattleTopBar:update_winRateScore()
end

function BattleRepeat.getScores(arg_53_0)
	if not arg_53_0.vars then
		return 
	end
	
	return arg_53_0.vars.win_score, arg_53_0.vars.lose_score
end

function BattleRepeat.initScoreRate(arg_54_0)
	if not arg_54_0.vars then
		return 
	end
	
	arg_54_0.vars.win_score = 0
	arg_54_0.vars.lose_score = 0
end

function BattleRepeat.getKey(arg_55_0)
	return arg_55_0.encrypt.key
end

function BattleRepeat.isInGamePVP(arg_56_0)
	if Battle.logic and Battle.logic:isPVP() and SceneManager:getCurrentSceneName() == "battle" then
		return true
	end
	
	return false
end

function BattleRepeat.isInCoop(arg_57_0)
	if Battle.logic and Battle.logic:isCoop() and SceneManager:getCurrentSceneName() == "battle" then
		return true
	end
	
	return false
end

function BattleRepeat.isInSkillPreview(arg_58_0)
	if Battle.logic and Battle.logic:isSkillPreview() then
		return true
	end
	
	return false
end

function BattleRepeat.getRepeatPlayingTeamIndex(arg_59_0)
	if not arg_59_0:isPlayingRepeatPlay() then
		return 
	end
	
	if Battle.logic and Battle.logic.team_data and Battle.logic.team_data.team_index then
		return Battle.logic.team_data.team_index
	end
end

function BattleRepeat.isPlayingRepeatPlay(arg_60_0)
	if BackPlayManager:isRunning() then
		return false
	end
	
	if arg_60_0:isInGamePVP() then
		return false
	end
	
	if arg_60_0:isInCoop() then
		return false
	end
	
	if arg_60_0:isInSkillPreview() then
		return false
	end
	
	if arg_60_0:get_isEndRepeatPlay() then
		return false
	end
	
	if arg_60_0:get_repeatCount() >= 0 and arg_60_0:getConfigRepeatPlay() then
		return true
	end
	
	return false
end

function BattleRepeat.set_isCounting(arg_61_0, arg_61_1)
	arg_61_0.isCounting = arg_61_1
end

function BattleRepeat.get_isCounting(arg_62_0)
	return arg_62_0.isCounting or false
end

function BattleRepeat.setRepeaatLose(arg_63_0, arg_63_1)
	if arg_63_1 == false then
		arg_63_1 = "null"
	end
	
	SAVE:setTempConfigData("repeat_lose", arg_63_1)
end

function BattleRepeat.getRepeaatLose(arg_64_0)
	return Account:getConfigData("repeat_lose") or false
end

function BattleRepeat.initOnce(arg_65_0)
	BattleRepeat:setConfigRepeatPlay(false)
end

function BattleRepeat.setConfigRepeatPlay(arg_66_0, arg_66_1)
	if arg_66_1 == false then
		arg_66_1 = "null"
	end
	
	SAVE:setTempConfigData("repeatPlay", arg_66_1)
end

function BattleRepeat.getConfigRepeatPlay(arg_67_0)
	if BackPlayManager:isRunning() then
		return true
	end
	
	if arg_67_0:isInGamePVP() then
		return false
	end
	
	return Account:getConfigData("repeatPlay") or false
end

function BattleRepeat.setConfigRepeatBattleCount(arg_68_0, arg_68_1, arg_68_2)
	if not arg_68_2 then
		print(debug.traceback())
		Log.e("Err: no team_idx value, setConfigRepeatBattleCount")
	end
	
	local var_68_0 = arg_68_2 or Account:getCurrentTeamIndex()
	
	if not var_68_0 then
		return 
	end
	
	if arg_68_1 > GAME_STATIC_VARIABLE.pet_repeat_battle_count then
		arg_68_1 = 1
		
		Log.e("err more than max value")
	end
	
	SAVE:setUserDefaultData("team_repeat_count_" .. var_68_0, arg_68_1)
end

function BattleRepeat.getConfigRepeatBattleCount(arg_69_0, arg_69_1)
	if not arg_69_1 then
		print(debug.traceback())
		Log.e("Err: no team_idx value, getConfigRepeatBattleCount")
	end
	
	local var_69_0 = arg_69_1 or Account:getCurrentTeamIndex()
	local var_69_1 = SAVE:getUserDefaultData("team_repeat_count_" .. var_69_0, -1)
	local var_69_2 = false
	
	if var_69_1 == -1 then
		var_69_2 = true
		var_69_1 = 1
	end
	
	return var_69_1, var_69_2
end

function BattleRepeat.updateRepeatCount(arg_70_0, arg_70_1, arg_70_2, arg_70_3)
	local var_70_0 = Account:getTeams()
	
	for iter_70_0, iter_70_1 in pairs(var_70_0) do
		if type(iter_70_0) == "number" and Account:canAddPetToTeam(iter_70_0) then
			local var_70_1 = Account:getPetInTeam(iter_70_0)
			
			if var_70_1 and var_70_1.isPet and var_70_1.getRepeat_count then
				local var_70_2 = var_70_1:getUID()
				local var_70_3 = var_70_1:getRepeat_count()
				local var_70_4 = arg_70_0:getConfigRepeatBattleCount(iter_70_0)
				
				if (arg_70_1 == var_70_2 or arg_70_2 == var_70_2) and var_70_3 == var_70_4 then
					arg_70_0:setConfigRepeatBattleCount(arg_70_3, iter_70_0)
				end
			end
		end
	end
end

function BattleRepeat.setConfigCheckAllUnit(arg_71_0, arg_71_1)
	if arg_71_1 == false then
		arg_71_1 = "null"
	end
	
	SAVE:setTempConfigData("checkAllUnit", arg_71_1)
end

function BattleRepeat.getConfigCheckAllUnit(arg_72_0)
	return Account:getConfigData("checkAllUnit") or false
end

function BattleRepeat.setConfigCheckMaxFavoriteUnit(arg_73_0, arg_73_1)
	if arg_73_1 == false then
		arg_73_1 = "null"
	end
	
	SAVE:setTempConfigData("checkMaxFavoriteUnit", arg_73_1)
end

function BattleRepeat.getConfigMaxFavoriteUnit(arg_74_0)
	return Account:getConfigData("checkMaxFavoriteUnit") or false
end

function BattleRepeat.getCurRepeatCount(arg_75_0)
	local var_75_0 = BattleRepeat:get_repeatMaxCount() - BattleRepeat:get_repeatCount()
	
	return math.min(var_75_0, BattleRepeat:get_repeatMaxCount())
end

function BattleRepeat.get_repeatCount(arg_76_0)
	if not arg_76_0.encrypt then
		return 0
	end
	
	return arg_76_0.encrypt.repeatBattle_count or 0
end

function BattleRepeat.set_repeatCount(arg_77_0, arg_77_1)
	arg_77_0.encrypt.repeatBattle_count = arg_77_1
end

function BattleRepeat.set_repeatMaxCount(arg_78_0, arg_78_1)
	if not arg_78_0.vars then
		arg_78_0.vars = {}
	end
	
	arg_78_0.vars.repeatMaxCount = arg_78_1
end

function BattleRepeat.get_repeatMaxCount(arg_79_0)
	if not arg_79_0.vars then
		Log.e("BattleRepeat", "get_repeatMaxCount")
		
		return 0
	end
	
	return arg_79_0.vars.repeatMaxCount
end

function BattleRepeat._checkEquips(arg_80_0, arg_80_1)
	if not arg_80_0.vars or not arg_80_0.vars.repeatItems then
		return 
	end
	
	local var_80_0 = {}
	local var_80_1 = {}
	
	if arg_80_1 then
		var_80_1 = arg_80_0.vars.repeatItems
	else
		var_80_1 = table.clone(arg_80_0.vars.repeatItems)
	end
	
	for iter_80_0, iter_80_1 in pairs(var_80_1) do
		if iter_80_1.isEquip and iter_80_1:isEquip() then
			local var_80_2 = Account:getEquip(iter_80_1.id)
			
			if not var_80_2 then
				iter_80_1.removed = true
			elseif not var_80_2:checkSell() then
				iter_80_1.can_not_sel = true
			elseif iter_80_1.code ~= var_80_2.code and not var_80_2:isCraftUpgradable() or iter_80_1:getEnhance() ~= var_80_2:getEnhance() or iter_80_1:getResetCount() ~= var_80_2:getResetCount() then
				var_80_2.add_pet_bonus = iter_80_1.add_pet_bonus
				var_80_2.reward_info = iter_80_1.reward_info
				var_80_0[iter_80_0] = var_80_2
			end
		elseif iter_80_1.isUnit and not Account:getUnit(iter_80_1.uid) then
			iter_80_1.removed = true
		end
	end
	
	for iter_80_2, iter_80_3 in pairs(var_80_0) do
		if var_80_1[iter_80_2] then
			var_80_1[iter_80_2] = iter_80_3
		end
	end
	
	return var_80_1
end

function BattleRepeat.getPetRepeatItems(arg_81_0, arg_81_1)
	if not arg_81_0.vars or not arg_81_0.vars.repeatItems then
		return 
	end
	
	return (arg_81_0:_checkEquips(arg_81_1))
end

function BattleRepeat.sortPetRepeatItems(arg_82_0)
	if not arg_82_0.vars or not arg_82_0.vars.repeatItems then
		return 
	end
	
	local function var_82_0(arg_83_0, arg_83_1)
		if not arg_83_0 then
			return false
		end
		
		if not arg_83_1 then
			return true
		end
		
		if arg_83_0.isUnit and not arg_83_1.isUnit then
			return false
		end
		
		if not arg_83_0.isUnit and arg_83_1.isUnit then
			return true
		end
		
		if arg_83_0.isEquip and arg_83_1.isEquip then
			if arg_83_0:isArtifact() and not arg_83_1:isArtifact() then
				return true
			end
			
			if not arg_83_0:isArtifact() and arg_83_1:isArtifact() then
				return false
			end
			
			if arg_83_0:isArtifact() and arg_83_1:isArtifact() then
				return EQUIP.greaterThanGrade(arg_83_0, arg_83_1)
			end
		end
		
		if arg_83_0.isEquip and not arg_83_1.isEquip then
			return false
		end
		
		if not arg_83_0.isEquip and arg_83_1.isEquip then
			return true
		end
		
		if arg_83_0.isMaterial and arg_83_1.isMaterial then
			if arg_83_0.ma_type == "reforge" and arg_83_1.ma_type == "material" then
				return false
			end
			
			if arg_83_0.ma_type == "material" and arg_83_1.ma_type == "reforge" then
				return true
			end
			
			if arg_83_0.ma_type == "material" and not arg_83_1.ma_type == "material" then
				return false
			end
			
			if not arg_83_0.ma_type == "material" and arg_83_1.ma_type == "material" then
				return true
			end
			
			if arg_83_0.ma_type == "xpup" and not arg_83_1.ma_type == "xpup" then
				return false
			end
			
			if not arg_83_0.ma_type == "xpup" and arg_83_1.ma_type == "xpup" then
				return true
			end
			
			if arg_83_0.ma_type == "stone" and not arg_83_1.ma_type == "stone" then
				return false
			end
			
			if not arg_83_0.ma_type == "stone" and arg_83_1.ma_type == "stone" then
				return true
			end
			
			if arg_83_0.ma_type == "essence" and not arg_83_1.ma_type == "essence" then
				return false
			end
			
			if not arg_83_0.ma_type == "essence" and arg_83_1.ma_type == "essence" then
				return true
			end
			
			if arg_83_0.ma_type == "rune" and not arg_83_1.ma_type == "rune" then
				return false
			end
			
			if not arg_83_0.ma_type == "rune" and arg_83_1.ma_type == "rune" then
				return true
			end
			
			if arg_83_0.ma_type == "reforge" and not arg_83_1.ma_type == "reforge" then
				return false
			end
			
			if not arg_83_0.ma_type == "reforge" and arg_83_1.ma_type == "reforge" then
				return true
			end
			
			if arg_83_0.ma_type == "reforge" and arg_83_1.ma_type == "reforge" and arg_83_0.priority and arg_83_1.priority then
				return arg_83_0.priority < arg_83_1.priority
			end
		end
		
		if arg_83_0.isMaterial and not arg_83_1.isMaterial then
			return false
		end
		
		if not arg_83_0.isMaterial and arg_83_1.isMaterial then
			return true
		end
		
		if arg_83_0.isCurrency and not arg_83_1.isCurrency then
			return false
		end
		
		if not arg_83_0.isCurrency and arg_83_1.isCurrency then
			return true
		end
		
		if arg_83_0.isCurrency and arg_83_1.isCurrency and arg_83_0.grade and arg_83_1.grade then
			return arg_83_0.grade < arg_83_1.grade
		end
		
		if arg_83_0.isEquip and arg_83_1.isEquip then
			return EQUIP.greaterThanItemLevel(arg_83_0, arg_83_1)
		end
		
		return nil
	end
	
	table.sort(arg_82_0.vars.repeatItems, var_82_0)
	
	local var_82_1 = {}
	
	for iter_82_0, iter_82_1 in pairs(arg_82_0.vars.repeatItems) do
		table.insert(var_82_1, iter_82_1)
	end
	
	arg_82_0.vars.repeatItems = var_82_1
end

function BattleRepeat.resetPetRepeatItems(arg_84_0)
	if not arg_84_0.vars then
		return 
	end
	
	arg_84_0.vars.repeatItems = {}
end

function BattleRepeat.insertPetRepeatItems(arg_85_0, arg_85_1)
	if not arg_85_0.vars then
		return 
	end
	
	local var_85_0 = arg_85_1 or {}
	
	if not arg_85_0.vars.repeatItems then
		arg_85_0:resetPetRepeatItems()
	end
	
	if var_85_0.equips then
		for iter_85_0, iter_85_1 in pairs(var_85_0.equips) do
			local var_85_1 = Account:getEquip(iter_85_1.id)
			
			if iter_85_1.add_pet_bonus then
				var_85_1.add_pet_bonus = iter_85_1.add_pet_bonus
			end
			
			if iter_85_1.add_bonus then
				var_85_1.add_bonus = iter_85_1.add_bonus
			end
			
			if var_85_1 then
				var_85_1.reward_info = {
					add_pet_bonus = iter_85_1.add_pet_bonus,
					add_bonus = iter_85_1.add_bonus
				}
				
				table.insert(arg_85_0.vars.repeatItems, var_85_1)
			end
		end
	end
	
	if var_85_0.units then
		for iter_85_2, iter_85_3 in pairs(var_85_0.units) do
			iter_85_3.isUnit = true
			
			table.insert(arg_85_0.vars.repeatItems, iter_85_3)
		end
	end
	
	if var_85_0.isCurrency or var_85_0.isMaterial then
		local var_85_2 = false
		
		for iter_85_4, iter_85_5 in pairs(arg_85_0.vars.repeatItems) do
			if iter_85_5.item_code == var_85_0.item_code then
				iter_85_5.count = iter_85_5.count + var_85_0.count
				iter_85_5.reward_info = {
					add_pet_bonus = iter_85_5.reward_info and iter_85_5.reward_info.add_pet_bonus or var_85_0.add_pet_bonus,
					add_bonus = iter_85_5.reward_info and iter_85_5.reward_info.add_bonus or var_85_0.add_bonus
				}
				iter_85_5.add_pet_bonus = iter_85_5.add_pet_bonus or var_85_0.add_pet_bonus
				iter_85_5.add_bonus = iter_85_5.add_bonus or var_85_0.add_bonus
				var_85_2 = true
				
				break
			end
		end
		
		if not var_85_2 then
			if var_85_0.isMaterial and string.starts(var_85_0.item_code, "ma_") then
				local var_85_3, var_85_4, var_85_5 = DB("item_material", var_85_0.item_code, {
					"ma_type",
					"priority",
					"sort"
				})
				
				if var_85_3 and var_85_3 == "token" then
					var_85_0.grade = DB("item_material", var_85_0.item_code, {
						"grade"
					}) or 0
					var_85_0.isMaterial = false
					var_85_0.isCurrency = true
				else
					var_85_4 = var_85_4 or 0
					var_85_0.ma_type = var_85_3
					var_85_0.priority = tonumber(var_85_4)
				end
				
				var_85_0.sort = var_85_5
			end
			
			var_85_0.reward_info = {
				add_pet_bonus = var_85_0.add_pet_bonus,
				add_bonus = var_85_0.add_bonus
			}
			
			table.insert(arg_85_0.vars.repeatItems, var_85_0)
		end
	end
end

function BattleRepeat.getEnterInfo(arg_86_0, arg_86_1)
	local var_86_0
	local var_86_1
	local var_86_2, var_86_3 = Account:getEnterLimitInfo(arg_86_1)
	
	if var_86_2 then
		local var_86_4
		
		var_86_4 = var_86_2 > 0
	end
	
	local var_86_5 = UIUtil:getChargeInfo(arg_86_1)
	local var_86_6 = var_86_5.enterable
	
	if var_86_6 then
		var_86_5.type_enterpoint = nil
	end
	
	if not var_86_2 and to_n(var_86_5.use_enterpoint) == 0 then
		var_86_6 = arg_86_1 ~= nil
	end
	
	if var_86_2 and var_86_3 and var_86_2 <= 0 then
		var_86_6 = false
		var_86_1 = true
	end
	
	if DEBUG.DEBUG_NO_ENTER_LIMIT then
		return true
	end
	
	return var_86_6, var_86_5.type_enterpoint, var_86_1
end

function BattleRepeat.markMaxLevelUnit(arg_87_0, arg_87_1)
	local var_87_0 = arg_87_1 or BattleRepeat.teamInfo
	
	if not var_87_0 then
		return 
	end
	
	for iter_87_0, iter_87_1 in pairs(var_87_0) do
		iter_87_1.levelCheck = not iter_87_1:isMaxLevel()
	end
end

function BattleRepeat.markMaxFavoriteUnit(arg_88_0, arg_88_1)
	local var_88_0 = arg_88_1 or BattleRepeat.teamInfo
	
	if not var_88_0 then
		return 
	end
	
	for iter_88_0, iter_88_1 in pairs(var_88_0) do
		iter_88_1.favoriteMaxCheck = not iter_88_1:isMaxFavoriteLevel()
	end
end

function BattleRepeat.checkUnits(arg_89_0, arg_89_1)
	local var_89_0 = arg_89_1 or BattleRepeat.teamInfo
	
	if not var_89_0 then
		return true
	end
	
	local var_89_1 = arg_89_0:getConfigCheckAllUnit()
	
	for iter_89_0, iter_89_1 in pairs(var_89_0) do
		if iter_89_1.levelCheck and iter_89_1:isMaxLevel() and var_89_1 then
			return false
		end
	end
	
	return true
end

function BattleRepeat.checkFavoriteUnit(arg_90_0, arg_90_1)
	local var_90_0 = arg_90_1 or BattleRepeat.teamInfo
	
	if not var_90_0 then
		return true
	end
	
	local var_90_1 = arg_90_0:getConfigMaxFavoriteUnit()
	
	for iter_90_0, iter_90_1 in pairs(var_90_0) do
		if iter_90_1.favoriteMaxCheck and iter_90_1:isMaxFavoriteLevel() and var_90_1 then
			return false
		end
	end
	
	return true
end

function BattleRepeat.get_urgentMissionCount(arg_91_0)
	local var_91_0 = ConditionContentsManager:getUrgentMissions()
	
	if not var_91_0 then
		return 0
	end
	
	local var_91_1 = 0
	local var_91_2 = Account:getUrgentMissions()
	
	for iter_91_0, iter_91_1 in pairs(var_91_2) do
		local var_91_3 = var_91_0:getRemainTime(iter_91_0) or 0
		
		if iter_91_1.state == URGENT_MISSION_STATE.ACTIVE and var_91_3 > 0 then
			var_91_1 = var_91_1 + 1
		end
	end
	
	return var_91_1
end

function BattleRepeat.set_urgentMissionNotiCount(arg_92_0, arg_92_1)
	if not arg_92_0.vars then
		return 
	end
	
	arg_92_0.vars.urgetnMissionNotiCount = arg_92_1
end

function BattleRepeat.get_urgentMissionNotiCount(arg_93_0)
	if not arg_93_0.vars then
		return 0
	end
	
	return arg_93_0.vars.urgetnMissionNotiCount or 0
end

function BattleRepeat.get_ticketCount(arg_94_0)
	local var_94_0 = 0
	
	if Account:getCoopMissionData() then
		if not Account:getCoopMissionData().ticket_list then
			local var_94_1 = {}
		end
		
		var_94_0 = table.count(Account:getCoopMissionData().ticket_list) or 0
	end
	
	return var_94_0
end

function BattleRepeat.get_coopMissionCount(arg_95_0)
	if not arg_95_0.vars then
		return 0
	end
	
	return arg_95_0.vars.coopCount or 0
end

function BattleRepeat.set_coopMissionCount(arg_96_0, arg_96_1)
	if not arg_96_0.vars then
		return 
	end
	
	arg_96_0.vars.coopCount = arg_96_1
end

function BattleRepeat.reset_coopMissionCount(arg_97_0)
	if not arg_97_0.vars then
		return 
	end
	
	arg_97_0.vars.coopCount = 0
end

function BattleRepeat.get_isEndRepeatPlay(arg_98_0)
	return arg_98_0.isEndRepeatPlay or false
end

function BattleRepeat.set_isEndRepeatPlay(arg_99_0, arg_99_1)
	arg_99_0.isEndRepeatPlay = arg_99_1
end

function BattleRepeat.update_missionCount(arg_100_0, arg_100_1)
	if not get_cocos_refid(arg_100_1) then
		return 
	end
	
	local var_100_0 = BattleRepeat:get_urgentMissionNotiCount()
	local var_100_1 = BattleRepeat:get_urgentMissionCount()
	
	if var_100_0 <= 0 then
		if_set_sprite(arg_100_1, "n_count_time", "img/_notification_num2.png")
		if_set(arg_100_1, "count_time", var_100_1)
	else
		if_set_sprite(arg_100_1, "n_count_time", "img/_notification_num.png")
		if_set(arg_100_1, "count_time", var_100_1)
	end
	
	if var_100_1 <= 0 then
		if_set_visible(arg_100_1, "n_count_time", false)
	else
		if_set_visible(arg_100_1, "n_count_time", true)
		if_set(arg_100_1, "count_time", var_100_1)
	end
	
	if_set_opacity(arg_100_1, "btn_time", var_100_1 > 0 and 255 or 76.5)
	
	local var_100_2 = BattleRepeat:get_coopMissionCount() + BattleRepeat:get_ticketCount()
	
	if var_100_2 <= 0 then
		if_set_visible(arg_100_1, "n_count_expedition", false)
	else
		if_set_visible(arg_100_1, "n_count_expedition", true)
		if_set(arg_100_1, "count_expedition", var_100_2)
	end
	
	if not Account:isSysAchieveCleared("system_124") then
		if_set_opacity(arg_100_1, "btn_expedition", 76.5)
	end
end

function BattleRepeat.getParentPopup(arg_101_0)
	if get_cocos_refid(BackPlayControlBox:getWnd()) then
		return BackPlayControlBox:getWnd()
	elseif get_cocos_refid(BattleTopBar:get_repeateControl()) then
		return BattleTopBar:get_repeateControl()
	elseif get_cocos_refid(BGI.ui_layer) then
		return BGI.ui_layer
	else
		return SceneManager:getRunningPopupScene()
	end
end

function BattleRepeat.addRepeatBattleItems(arg_102_0, arg_102_1, arg_102_2, arg_102_3, arg_102_4, arg_102_5, arg_102_6, arg_102_7, arg_102_8, arg_102_9)
	local var_102_0 = arg_102_1 or {}
	local var_102_1 = arg_102_2 or {}
	local var_102_2 = arg_102_3 or {}
	local var_102_3 = arg_102_4 or {}
	local var_102_4 = arg_102_5 or {}
	local var_102_5 = arg_102_6 or {}
	local var_102_6 = {}
	
	for iter_102_0, iter_102_1 in pairs(var_102_2) do
		local var_102_7, var_102_8 = DB("mission_data", iter_102_1.contents_id, {
			"reward_id1",
			"reward_count1"
		})
		
		if var_102_7 and Account:isDungeonMissionClearedByMissionId(arg_102_9, iter_102_1.contents_id) then
			var_102_6[iter_102_1.contents_id] = {
				reward_id = var_102_7,
				reward_count = var_102_8
			}
		end
	end
	
	for iter_102_2, iter_102_3 in pairs(var_102_3) do
		local var_102_9 = "to_" .. iter_102_3.code
		local var_102_10 = var_102_1[var_102_9]
		local var_102_11 = var_102_0[var_102_9]
		local var_102_12 = iter_102_3.count
		
		for iter_102_4, iter_102_5 in pairs(var_102_6) do
			if iter_102_5.reward_id == var_102_9 then
				local var_102_13 = {
					star_reward = true
				}
				
				BattleRepeat:insertPetRepeatItems({
					isCurrency = true,
					item_code = iter_102_5.reward_id,
					count = iter_102_5.reward_count,
					code = "to_" .. iter_102_3.code,
					reward_info = var_102_13
				})
				
				var_102_12 = var_102_12 - iter_102_5.reward_count
			end
		end
		
		if var_102_12 > 0 then
			local var_102_14 = {
				add_pet_bonus = var_102_10,
				add_bonus = var_102_11
			}
			
			BattleRepeat:insertPetRepeatItems({
				isCurrency = true,
				item_code = var_102_9,
				count = var_102_12,
				code = "to_" .. iter_102_3.code,
				add_pet_bonus = var_102_10,
				reward_info = var_102_14,
				add_bonus = var_102_11
			})
		end
	end
	
	for iter_102_6, iter_102_7 in pairs(var_102_4) do
		local var_102_15 = iter_102_7.code
		local var_102_16 = var_102_1[var_102_15]
		local var_102_17 = (var_102_1.drop_items or {})[var_102_15]
		
		if var_102_17 then
			var_102_16 = (var_102_16 or 0) + var_102_17
		end
		
		local var_102_18 = var_102_0[var_102_15]
		local var_102_19 = {
			add_pet_bonus = var_102_16,
			add_bonus = var_102_18
		}
		
		BattleRepeat:insertPetRepeatItems({
			isMaterial = true,
			show_small_count = true,
			item_code = var_102_15,
			count = iter_102_7.count,
			code = var_102_15,
			add_pet_bonus = var_102_16,
			reward_info = var_102_19,
			add_bonus = var_102_18
		})
	end
	
	local var_102_20 = table.clone(var_102_0)
	
	for iter_102_8, iter_102_9 in pairs(var_102_5) do
		for iter_102_10, iter_102_11 in pairs(var_102_20) do
			if iter_102_10 == iter_102_9.code and var_102_20[iter_102_10] and type(var_102_20[iter_102_10]) == "number" and var_102_20[iter_102_10] > 0 then
				var_102_20[iter_102_10] = var_102_20[iter_102_10] - 1
				iter_102_9.add_bonus = 1
				
				break
			end
		end
		
		local var_102_21 = var_102_1.equips or {}
		local var_102_22
		
		for iter_102_12, iter_102_13 in pairs(var_102_21) do
			if iter_102_13.id == iter_102_9.id then
				iter_102_9.add_pet_bonus = iter_102_13.count
				
				break
			end
		end
	end
	
	if arg_102_7 and not table.empty(arg_102_7) then
		local var_102_23 = arg_102_7
		
		if var_102_23 and var_102_23.rewards then
			if var_102_23.rewards.reward_info and var_102_23.rewards.reward_info.new_items then
				for iter_102_14, iter_102_15 in pairs(var_102_23.rewards.reward_info.new_items) do
					BattleRepeat:insertPetRepeatItems({
						show_small_count = true,
						isMaterial = true,
						item_code = iter_102_15.code,
						count = iter_102_15.diff,
						code = iter_102_15.code
					})
				end
			end
			
			if Account:isCurrencyType(var_102_23.rewards.code) then
				local var_102_24 = var_102_23.rewards.code
				local var_102_25 = to_n(var_102_23.rewards.count)
				
				BattleRepeat:insertPetRepeatItems({
					isCurrency = true,
					item_code = var_102_24,
					count = var_102_25,
					code = var_102_24
				})
			end
		end
	end
	
	BattleRepeat:insertPetRepeatItems({
		equips = var_102_5
	})
	BattleRepeat:insertPetRepeatItems({
		units = arg_102_8
	})
	BattleRepeat:sortPetRepeatItems()
end

function BattleRepeat.canSellItems(arg_103_0)
	if arg_103_0:get_isEndRepeatPlay() or BackPlayManager:isRunning() then
		return true
	end
	
	return false
end

function BattleRepeat.refreshItems(arg_104_0, arg_104_1)
	if not arg_104_1 or table.empty(arg_104_1) then
		return 
	end
	
	local var_104_0 = BattleRepeat:getPetRepeatItems(true)
	
	for iter_104_0, iter_104_1 in pairs(arg_104_1) do
		for iter_104_2, iter_104_3 in pairs(var_104_0) do
			if iter_104_3.id and iter_104_3.id == iter_104_1 then
				var_104_0[iter_104_2] = nil
			end
		end
	end
	
	if not ClearResult.vars or not ClearResult.vars.result or ClearResult.vars.result.lose then
	else
		ClearResult:refreshAfterSellItems(arg_104_1)
	end
end
