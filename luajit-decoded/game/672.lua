LotaObjectDetailHandler = {}
LotaObjectInteractionHandler = {}
LotaObjectExpireHandler = {}
LotaObjectResponseHandler = {}

function LotaObjectDetailHandler.boss_monster(arg_1_0, arg_1_1)
	LotaNetworkSystem:sendQuery("lota_monster_detail", {
		battle_id = LotaUtil:getBattleId(arg_1_1:getUID())
	})
end

function LotaObjectDetailHandler.elite_monster(arg_2_0, arg_2_1)
	LotaNetworkSystem:sendQuery("lota_monster_detail", {
		battle_id = LotaUtil:getBattleId(arg_2_1:getUID())
	})
end

function LotaObjectDetailHandler.keeper_monster(arg_3_0, arg_3_1)
	LotaNetworkSystem:sendQuery("lota_monster_detail", {
		battle_id = LotaUtil:getBattleId(arg_3_1:getUID())
	})
end

function LotaObjectInteractionHandler.normal_monster(arg_4_0, arg_4_1)
	local var_4_0 = arg_4_1:getLevelID()
	
	if not var_4_0 then
		error("THIS MONSTER NOT HAVE LEVEL ID")
		
		return 
	end
	
	LotaBattleReady:show({
		enter_id = var_4_0,
		tile_id = arg_4_1:getTileId(),
		object_id = arg_4_1:getDBId()
	})
end

function LotaObjectInteractionHandler.boss_monster(arg_5_0, arg_5_1)
	if LotaClanInfo:isAvailableBossBattle(LotaUserData:getFloorKey()) then
		LotaBossReadyUI:openReady({
			boss_room = true,
			tile_id = arg_5_1:getTileId(),
			object_id = arg_5_1:getDBId()
		})
	end
end

function LotaObjectInteractionHandler.elite_monster(arg_6_0, arg_6_1)
	LotaBattleReady:openReady({
		elite_room = true,
		tile_id = arg_6_1:getTileId(),
		object_id = arg_6_1:getDBId()
	})
end

function LotaObjectInteractionHandler.keeper_monster(arg_7_0, arg_7_1)
	LotaBattleReady:openReady({
		elite_room = true,
		tile_id = arg_7_1:getTileId(),
		object_id = arg_7_1:getDBId()
	})
end

function LotaObjectInteractionHandler.legacy(arg_8_0, arg_8_1)
	LotaNetworkSystem:sendQuery("lota_interaction_object", {
		tile_id = arg_8_1:getTileId()
	})
end

function LotaObjectInteractionHandler.boss_portal(arg_9_0, arg_9_1)
	Dialog:msgBox(T("msg_clanheritage_use_boss_portal"), {
		yesno = true,
		handler = function()
			LotaSystem:requestNextFloor()
		end
	})
end

function LotaObjectResponseHandler.legacy(arg_11_0, arg_11_1, arg_11_2)
	print("LotaObjectResponseHandler!!! RES!")
	
	if not arg_11_2.res == "ok" then
		print(arg_11_2.failed_reason)
		
		return 
	end
end

function LotaObjectInteractionHandler.high_legacy(arg_12_0, arg_12_1)
	LotaNetworkSystem:sendQuery("lota_interaction_object", {
		tile_id = arg_12_1:getTileId()
	})
end

function LotaObjectResponseHandler.high_legacy(arg_13_0, arg_13_1, arg_13_2)
	print("high_legacy!!! RES!")
	
	if not arg_13_2.res == "ok" then
		print(arg_13_2.failed_reason)
		
		return 
	end
end

function LotaObjectInteractionHandler.library(arg_14_0, arg_14_1)
	print("LIBRARY SAY : WELCOME!")
	
	if arg_14_1:isActive() then
		LotaNetworkSystem:sendQuery("lota_interaction_object", {
			tile_id = arg_14_1:getTileId()
		})
	end
end

function LotaObjectResponseHandler.library(arg_15_0, arg_15_1, arg_15_2)
	print("LIBRARY SAY : RESPONSE!")
	
	if not arg_15_2.ok then
		print(arg_15_2.failed_reason)
		
		return 
	end
end

function LotaObjectInteractionHandler.event(arg_16_0, arg_16_1)
	if arg_16_1:isActive() then
		LotaNetworkSystem:sendQuery("lota_interaction_object", {
			tile_id = arg_16_1:getTileId()
		})
	end
end

function LotaObjectResponseHandler.event(arg_17_0, arg_17_1, arg_17_2)
	LotaEventSystem:onResponseEventData(arg_17_1:getUID(), arg_17_1:getEventId())
end

function LotaObjectInteractionHandler.portal(arg_18_0, arg_18_1)
	local var_18_0 = LotaClanInfo:getCurrentQuestProgress()
	
	if arg_18_1:isActive() and var_18_0 > 1 then
		LotaPortalUI:init(arg_18_1)
	elseif var_18_0 == 1 then
		balloon_message_with_sound("msg_clanheritage_boss_portal_yet")
	end
end

function LotaObjectInteractionHandler.floating_tile_start(arg_19_0, arg_19_1)
	LotaNetworkSystem:sendQuery("lota_interaction_object", {
		tile_id = arg_19_1:getTileId()
	})
end

function LotaObjectResponseHandler.floating_tile_start(arg_20_0, arg_20_1, arg_20_2)
	LotaSystem:procFloatingTileTravelTo(arg_20_1, arg_20_2)
end

function LotaObjectInteractionHandler.floating_tile_dest(arg_21_0, arg_21_1)
end

function LotaObjectResponseHandler.floating_tile_dest(arg_22_0, arg_22_1, arg_22_2)
end

function LotaObjectResponseHandler.portal(arg_23_0, arg_23_1, arg_23_2)
	local var_23_0
	
	for iter_23_0, iter_23_1 in pairs(arg_23_2.member_move_data) do
		if tostring(iter_23_1.id) == tostring(AccountData.id) then
			var_23_0 = iter_23_1
			
			break
		end
	end
	
	if not var_23_0 then
		return 
	end
	
	local var_23_1 = var_23_0.tm
	local var_23_2 = merge_member_move_data(arg_23_2.member_move_data)
	
	for iter_23_2, iter_23_3 in pairs(var_23_2) do
		if tostring(iter_23_3.id) ~= tostring(AccountData.id) then
			LotaSystem:procMovePath(iter_23_3)
		end
	end
	
	LotaNetworkSystem:updateLastTm(var_23_1)
	LotaPortalUI:close()
	LotaSystem:procJumpTo(var_23_0)
end

function LotaObjectInteractionHandler.goddess(arg_24_0, arg_24_1)
	print("STATUE SAY : ENTER!")
	
	if arg_24_1:isActive() then
		LotaBlessingUI:init(LotaSystem:getUIDialogLayer(), arg_24_1)
	end
end

function LotaObjectResponseHandler.goddess(arg_25_0, arg_25_1, arg_25_2)
	print("STATUE SAY : RESPONSE!")
	
	if not arg_25_2.res == "ok" then
		print(arg_25_2.failed_reason)
		
		return 
	end
	
	LotaMovableRenderer:addEffect(LotaMovableSystem:getPlayerMovable(), "heal_hp_01.cfx")
	LotaUserData:updateRegistration(arg_25_2.user_registration_data)
	LotaBlessingUI:close()
end

function LotaObjectInteractionHandler.treasure_box(arg_26_0, arg_26_1)
	if arg_26_1:isActive() then
		LotaNetworkSystem:sendQuery("lota_interaction_object", {
			tile_id = arg_26_1:getTileId()
		})
	end
end

function LotaObjectResponseHandler.treasure_box(arg_27_0, arg_27_1, arg_27_2)
	local var_27_0, var_27_1 = LotaUtil:makeMsgRewardsParam(arg_27_2, arg_27_1:getRewardTitle(), arg_27_1:getRewardDesc())
	
	if table.count(var_27_0.rewards) > 0 then
		LotaUtil:makeMsgRewards(var_27_0, var_27_1, arg_27_2)
	end
end

function LotaObjectInteractionHandler.production(arg_28_0, arg_28_1)
	if arg_28_1:isActive() then
		LotaNetworkSystem:sendQuery("lota_interaction_object", {
			tile_id = arg_28_1:getTileId()
		})
	end
end

function LotaObjectResponseHandler.production(arg_29_0, arg_29_1, arg_29_2)
	local var_29_0, var_29_1 = LotaUtil:makeMsgRewardsParam(arg_29_2, arg_29_1:getRewardTitle(), arg_29_1:getRewardDesc())
	
	if string.find(arg_29_1:getDBId(), "camping") then
		local var_29_2 = LotaSystem:getUIDialogLayer()
		local var_29_3 = cc.LayerColor:create(cc.c4b(0, 0, 0, 200))
		
		var_29_3:setName("parent_layer")
		var_29_2:addChild(var_29_3)
		var_29_3:setContentSize(VIEW_WIDTH, VIEW_HEIGHT)
		var_29_3:setPositionX(VIEW_BASE_LEFT)
		
		local var_29_4 = ccui.Layout:create()
		
		var_29_4:setPosition(-355, -200)
		var_29_4:setCascadeOpacityEnabled(true)
		var_29_4:setContentSize(710, 400)
		var_29_4:setClippingEnabled(true)
		
		local var_29_5 = CoopReadyBG(var_29_4, "camping2")
		
		var_29_5.layer:setPosition(-265, -350)
		
		local var_29_6 = LotaMovableSystem:getPlayerMovable()
		local var_29_7 = {}
		local var_29_8 = LotaUserData:getRegistration()
		local var_29_9
		
		if table.empty(var_29_8) then
			var_29_7 = {
				UNIT:create({
					code = var_29_6:getLeaderCode()
				})
			}
		else
			var_29_9 = {}
			
			for iter_29_0, iter_29_1 in pairs(var_29_8) do
				table.insert(var_29_9, iter_29_0)
			end
			
			for iter_29_2 = 1, 4 do
				if table.empty(var_29_9) then
					break
				end
				
				local var_29_10 = math.random(1, table.count(var_29_9))
				local var_29_11 = Account:getUnit(tonumber(var_29_9[var_29_10]))
				
				if var_29_11 then
					table.insert(var_29_7, var_29_11)
				end
				
				table.remove(var_29_9, var_29_10)
			end
		end
		
		for iter_29_3 = 1, 4 do
			local var_29_12 = var_29_7[iter_29_3]
			
			if var_29_12 then
				var_29_5:addUnit(iter_29_3, var_29_12)
			end
		end
		
		local var_29_13 = load_dlg("clan_heritage_camp", true, "wnd")
		
		var_29_13:setPositionX(var_29_13:getPositionX() - VIEW_BASE_LEFT)
		var_29_13:findChildByName("n_eff"):addChild(var_29_4)
		var_29_3:addChild(var_29_13)
		var_29_5.layer:setPositionY(-25)
		UIAction:Add(SEQ(DELAY(4500), CALL(function()
			if var_29_0 then
				LotaUtil:makeMsgRewards(var_29_0, var_29_1, arg_29_2)
			end
		end), FADE_OUT(500), REMOVE()), var_29_3, "block")
		var_29_3:bringToFront()
	elseif var_29_0 then
		LotaUtil:makeMsgRewards(var_29_0, var_29_1, arg_29_2)
	end
end

function LotaObjectInteractionHandler.sanctuary(arg_31_0, arg_31_1)
	if arg_31_1:isActive() then
		local var_31_0 = arg_31_1:getSanctuaryTargetRole()
		
		if LotaUserData:getRoleLevelWithoutArtifactByRole(var_31_0) >= LotaUserData:getMaxRoleLevel() then
			balloon_message_with_sound("msg_clanheritage_roleup_max")
			
			return 
		end
		
		LotaNetworkSystem:sendQuery("lota_interaction_object", {
			tile_id = arg_31_1:getTileId()
		})
	end
end

function LotaObjectResponseHandler.sanctuary(arg_32_0, arg_32_1, arg_32_2)
	local var_32_0 = DB("clan_heritage_object_data", arg_32_1:getDBId(), "role")
	local var_32_1 = LotaMovableSystem:getPlayerMovable()
	
	LotaMovableRenderer:addJobLevelUpEffect(var_32_1, var_32_0)
	
	local var_32_2 = LotaSystem:getUILayer()
	
	if not get_cocos_refid(var_32_2) then
		return 
	end
	
	UIAction:Add(SEQ(DELAY(1000), CALL(function()
		local var_33_0 = LotaUtil:makeCompleteDlg(var_32_0)
		
		Dialog:msgBox(T("ui_clanheritage_roleup_popup_title_2"), {
			dlg = var_33_0
		})
	end)), "block")
end
