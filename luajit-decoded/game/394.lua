SubStoryFestival = SubStoryFestival or {}

function SubStoryFestival.getContentsDB(arg_1_0)
	local var_1_0 = {
		"substory_reset_cost",
		"substory_reset_token",
		"substory_reset_add_cost",
		"substory_reset_free",
		"substory_reset_limit"
	}
	local var_1_1 = {}
	local var_1_2 = SubstoryManager:findContentsTypeColumn("substory_festival_fm")
	
	if var_1_2 then
		var_1_1 = SubstoryManager:getContentsDB(var_1_2, var_1_0)
	end
	
	return var_1_1
end

function SubStoryFestival.getFestivalID(arg_2_0)
	local var_2_0 = SubstoryManager:getInfo()
	
	if not var_2_0 then
		return 
	end
	
	local var_2_1 = Account:getSubStoryFestivalInfo(var_2_0.id)
	
	if not var_2_1 then
		return 
	end
	
	return string.format("%s_%02d", var_2_0.id, var_2_1.day)
end

function SubStoryFestival.isOpenEvent(arg_3_0)
	local var_3_0 = SubstoryManager:getInfo()
	
	if not var_3_0 then
		return 
	end
	
	local var_3_1 = SubStoryUtil:getEventState(var_3_0.start_time, var_3_0.end_time)
	
	if not var_3_1 then
		return 
	end
	
	return var_3_1 == SUBSTORY_CONSTANTS.STATE_OPEN
end

function SubStoryFestival.hasStateMission(arg_4_0, arg_4_1)
	local var_4_0 = SubstoryManager:getInfo()
	
	if not var_4_0 then
		return 
	end
	
	local var_4_1 = Account:getSubStoryFestivalInfo(var_4_0.id)
	
	for iter_4_0 = 1, 3 do
		if var_4_1["mission_state" .. iter_4_0] == arg_4_1 then
			return true
		end
	end
	
	return false
end

function SubStoryFestival.isFestivalShopDayLimitItemExist(arg_5_0)
	local var_5_0 = SubstoryManager:getShopItemList()
	
	if not var_5_0 or table.empty(var_5_0) then
		return 
	end
	
	local var_5_1 = SubstoryManager:getInfo()
	
	if not var_5_1 then
		return 
	end
	
	local var_5_2 = Account:getSubStoryFestivalInfo(var_5_1.id)
	
	if not var_5_2 or table.empty(var_5_2) then
		return 
	end
	
	local var_5_3 = false
	
	for iter_5_0, iter_5_1 in pairs(var_5_0) do
		if iter_5_1.festival_day and var_5_2.day and (tonumber(iter_5_1.festival_day) or 0) == (tonumber(var_5_2.day) or -1) and iter_5_1.limit_count then
			local var_5_4, var_5_5, var_5_6 = ShopCommon:GetRestCount(iter_5_1, os.time())
			
			if var_5_4 > 0 then
				var_5_3 = true
				
				break
			end
		end
	end
	
	return var_5_3
end

function SubStoryFestival.canReceiveOfficeReward(arg_6_0)
	local var_6_0 = SubstoryManager:getInfo()
	
	if not var_6_0 then
		return 
	end
	
	local var_6_1 = Account:getSubStoryFestivalInfo(var_6_0.id)
	
	if not var_6_1 or table.empty(var_6_1) then
		return 
	end
	
	local var_6_2 = false
	local var_6_3 = tonumber(var_6_1.festival_score) or 0
	local var_6_4 = tonumber(var_6_1.festival_reward) or 0
	
	for iter_6_0 = 1, 99 do
		local var_6_5 = string.format("%s_%02d", var_6_0.id, iter_6_0)
		local var_6_6 = DBT("substory_festival_office", var_6_5, {
			"id",
			"need_point",
			"reward_item",
			"reward_item_value"
		})
		
		if not var_6_6 or table.empty(var_6_6) then
			break
		end
		
		if var_6_3 >= var_6_6.need_point and var_6_4 < var_6_6.need_point then
			var_6_2 = true
			
			break
		end
	end
	
	return var_6_2
end

function SubStoryFestival.onUpdateUI(arg_7_0)
	SubStoryLobby:updateUI()
	SubstoryManager:updateNotifierContentsUI()
	SubstoryFestivalBoard:updateMissionUI()
end

SubStoryFestivalUIUtil = SubStoryFestivalUIUtil or {}

function SubStoryFestivalUIUtil.updateFestivalDateUI(arg_8_0, arg_8_1)
	if not get_cocos_refid(arg_8_1) then
		return 
	end
	
	if not SubstoryManager:isContentsType(SUBSTORY_CONTENTS_TYPE.FESTIVAL_FM) then
		return 
	end
	
	local var_8_0 = arg_8_1:getChildByName("n_season")
	
	if not get_cocos_refid(var_8_0) then
		return 
	end
	
	if_set_visible(var_8_0, nil, true)
	
	local var_8_1 = SubStoryFestival:getFestivalID()
	local var_8_2 = DB("substory_festival", var_8_1, "progress_date_btn")
	
	if_set(var_8_0, "txt_season", T(var_8_2))
end

function SubStoryFestivalUIUtil.updateNotiBalloon(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	if not get_cocos_refid(arg_9_2) then
		return 
	end
	
	if not SubstoryManager:isContentsType(SUBSTORY_CONTENTS_TYPE.FESTIVAL_FM) then
		return 
	end
	
	arg_9_0:updateBoardNotiBalloon(arg_9_1, arg_9_2, arg_9_3)
	arg_9_0:updateShopNotiBalloon(arg_9_1, arg_9_2, arg_9_3)
end

function SubStoryFestivalUIUtil.updateBoardNotiBalloon(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	local var_10_0 = arg_10_2:getChildByName("n_board")
	
	if not get_cocos_refid(var_10_0) then
		return 
	end
	
	local var_10_1 = var_10_0:getChildByName("n_noti")
	local var_10_2 = "festival_b"
	local var_10_3 = SubStoryUtil:getSubstoryConfigData(arg_10_1, var_10_2)
	local var_10_4 = Account:serverTimeDayLocalDetail()
	local var_10_5 = var_10_3 == nil or var_10_4 > to_n(var_10_3)
	local var_10_6 = SubStoryFestival:hasStateMission(SUBSTORY_FESTIVAL_STATE.INACTIVE)
	
	if arg_10_3 or var_10_5 and var_10_6 then
		var_10_1:setOpacity(255)
		var_10_1:setVisible(true)
		UIAction:Add(SEQ(DELAY(5000), FADE_OUT(1000)), var_10_1, "festival.balloon")
		SubStoryUtil:setSubstoryConfigData(arg_10_1, var_10_2, var_10_4)
	else
		var_10_1:setVisible(false)
	end
end

function SubStoryFestivalUIUtil.updateShopNotiBalloon(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	local var_11_0 = arg_11_2:getChildByName("n_shop")
	
	if not get_cocos_refid(var_11_0) then
		return 
	end
	
	local var_11_1 = var_11_0:getChildByName("n_noti")
	local var_11_2 = "festival_s"
	local var_11_3 = SubStoryUtil:getSubstoryConfigData(arg_11_1, var_11_2)
	local var_11_4 = Account:serverTimeDayLocalDetail()
	local var_11_5 = var_11_3 == nil or var_11_4 > to_n(var_11_3)
	local var_11_6 = SubStoryFestival:isFestivalShopDayLimitItemExist()
	
	if arg_11_3 or var_11_5 and var_11_6 then
		var_11_1:setOpacity(255)
		var_11_1:setVisible(true)
		UIAction:Add(SEQ(DELAY(5000), FADE_OUT(1000)), var_11_1, "festival.balloon")
		SubStoryUtil:setSubstoryConfigData(arg_11_1, var_11_2, var_11_4)
	else
		var_11_1:setVisible(false)
	end
end

function SubStoryFestivalUIUtil.updateOfficeRedDot(arg_12_0, arg_12_1)
	if not get_cocos_refid(arg_12_1) then
		return 
	end
	
	local var_12_0 = arg_12_1:getChildByName("n_management")
	
	if not get_cocos_refid(var_12_0) then
		return 
	end
	
	local var_12_1 = SubStoryFestival:canReceiveOfficeReward()
	
	if_set_visible(var_12_0, "noti_icon", var_12_1)
end

function SubStoryFestivalUIUtil.updateBoardRedDot(arg_13_0, arg_13_1)
	if not get_cocos_refid(arg_13_1) then
		return 
	end
	
	if not SubstoryManager:isContentsType(SUBSTORY_CONTENTS_TYPE.FESTIVAL_FM) then
		return 
	end
	
	local var_13_0 = true
	local var_13_1 = SubStoryFestival:hasStateMission(SUBSTORY_FESTIVAL_STATE.INACTIVE)
	local var_13_2 = SubStoryFestival:hasStateMission(SUBSTORY_FESTIVAL_STATE.CLEAR)
	local var_13_3 = var_13_1 or var_13_2
	
	if_set_visible(arg_13_1, "noti_icon", var_13_3)
end
