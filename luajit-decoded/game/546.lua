EventPlatform = EventPlatform or {}
EventPlatform.vars = {}

function EventPlatform.getDB(arg_1_0)
	if arg_1_0.vars.db then
		return arg_1_0.vars.db
	end
	
	arg_1_0.vars.db = {}
	
	for iter_1_0 = 1, 999 do
		local var_1_0 = {}
		
		var_1_0.id, var_1_0.event_id, var_1_0.date_start, var_1_0.time_start, var_1_0.date_end, var_1_0.time_end, var_1_0.offer_id, var_1_0.banner = DBN("event_platform", iter_1_0, {
			"id",
			"event_id",
			"date_start",
			"time_start",
			"date_end",
			"time_end",
			"offer_id",
			"banner"
		})
		
		if not var_1_0.id then
			break
		end
		
		table.insert(arg_1_0.vars.db, var_1_0)
	end
	
	return arg_1_0.vars.db
end

function EventPlatform.getAmazonRoundData(arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = AccountData.amazon_promotion[arg_2_1]
	
	if not var_2_0 then
		Log.e("EventPlatform", "amazon_promotion_round_data is nil. event id:", arg_2_1)
		
		return 
	end
	
	local var_2_1 = var_2_0[arg_2_2]
	
	if not var_2_1 then
		Log.e("EventPlatform", "amazon_round_data is nil. round id: ", arg_2_2)
		
		return 
	end
	
	return var_2_1
end

function EventPlatform.getAmazonPromotions(arg_3_0)
	if arg_3_0.vars.amazon_promotions then
		return arg_3_0.vars.amazon_promotions
	end
	
	if not AccountData.amazon_promotion then
		Log.e("EventPlatform", "AccountData.amazon_promotion is nil")
		
		return 
	end
	
	local var_3_0 = {}
	
	arg_3_0.vars.amazon_promotions = {}
	
	local var_3_1 = arg_3_0:getDB()
	
	for iter_3_0, iter_3_1 in pairs(var_3_1) do
		local var_3_2 = arg_3_0:getAmazonRoundData(iter_3_1.event_id, iter_3_1.id)
		
		if not var_3_2 then
			break
		end
		
		local var_3_3 = var_3_2.start_time
		local var_3_4 = var_3_2.end_time
		
		if not arg_3_0.vars.amazon_promotions[iter_3_1.event_id] then
			arg_3_0.vars.amazon_promotions[iter_3_1.event_id] = {
				rounds = {},
				start_time = var_3_3,
				end_time = var_3_4
			}
		end
		
		var_3_0[iter_3_1.event_id] = var_3_0[iter_3_1.event_id] or 0
		var_3_0[iter_3_1.event_id] = var_3_0[iter_3_1.event_id] + 1
		arg_3_0.vars.amazon_promotions[iter_3_1.event_id].rounds[iter_3_1.id] = {
			id = iter_3_1.id,
			round = var_3_0[iter_3_1.event_id],
			start_time = var_3_3,
			end_time = var_3_4,
			offer_id = iter_3_1.offer_id,
			banner = iter_3_1.banner
		}
		arg_3_0.vars.amazon_promotions[iter_3_1.event_id].start_time = math.min(arg_3_0.vars.amazon_promotions[iter_3_1.event_id].start_time, var_3_3)
		arg_3_0.vars.amazon_promotions[iter_3_1.event_id].end_time = math.max(arg_3_0.vars.amazon_promotions[iter_3_1.event_id].end_time, var_3_4)
	end
	
	return arg_3_0.vars.amazon_promotions
end

function EventPlatform.getAmazonCurrentPromotionID(arg_4_0)
	arg_4_0:getAmazonCurrentPromotion()
	
	return arg_4_0.vars.promotion_id
end

function EventPlatform.getAmazonRoundDataByTime(arg_5_0, arg_5_1)
	local var_5_0 = arg_5_0:getAmazonPromotions()
	
	for iter_5_0, iter_5_1 in pairs(var_5_0) do
		for iter_5_2, iter_5_3 in pairs(iter_5_1.rounds) do
			if arg_5_1 >= iter_5_3.start_time and arg_5_1 < iter_5_3.end_time then
				arg_5_0.vars.client_current_round_data = iter_5_3
				
				return iter_5_3
			end
		end
	end
	
	arg_5_0.vars.client_current_round_data = nil
	
	return nil
end

function EventPlatform.getAmazonCurrentPromotion(arg_6_0)
	local var_6_0 = arg_6_0:getAmazonPromotions()
	local var_6_1 = os.time() + arg_6_0:__getCheatAddSeconds()
	
	for iter_6_0, iter_6_1 in pairs(var_6_0) do
		if var_6_1 >= iter_6_1.start_time and var_6_1 < iter_6_1.end_time then
			arg_6_0.vars.promotion_id = iter_6_0
			arg_6_0.vars.promotion = iter_6_1
			
			return arg_6_0.vars.promotion
		end
	end
	
	arg_6_0.vars.promotion_id = nil
	arg_6_0.vars.promotion = nil
	
	return nil
end

function EventPlatform.getAmazonCurrentPromotionRoundNum(arg_7_0)
	local var_7_0 = arg_7_0:getAmazonCurrentPromotion()
	
	if not var_7_0 then
		return 0
	end
	
	return table.count(var_7_0.rounds)
end

function EventPlatform.getAmazonPromotion(arg_8_0, arg_8_1)
	arg_8_1 = arg_8_1 or arg_8_0:getAmazonCurrentPromotionID()
	
	local var_8_0 = arg_8_0:getAmazonPromotions()
	
	if not var_8_0 then
		return 
	end
	
	return var_8_0[arg_8_1]
end

function EventPlatform.getAmazonCurrentRoundData(arg_9_0)
	local var_9_0 = os.time() + arg_9_0:__getCheatAddSeconds()
	
	arg_9_0.vars.amazon_current_round_data = arg_9_0:getAmazonRoundDataByTime(var_9_0)
	
	return arg_9_0.vars.amazon_current_round_data
end

function EventPlatform.getAmazonCurrentRoundID(arg_10_0)
	local var_10_0 = arg_10_0:getAmazonCurrentRoundData()
	
	if not var_10_0 then
		return 
	end
	
	return var_10_0.id
end

function EventPlatform.getAmazonCurrentRoundEndTime(arg_11_0)
	local var_11_0 = arg_11_0:getAmazonCurrentRoundData()
	
	if not var_11_0 then
		return 
	end
	
	return var_11_0.end_time
end

function EventPlatform.getAmazonCurrentBannerSprite(arg_12_0)
	local var_12_0 = arg_12_0:getAmazonCurrentRoundData()
	
	if not var_12_0 then
		return 
	end
	
	return "banner/" .. var_12_0.banner .. ".png"
end

function EventPlatform.getAmazonCurrentRoundRemainTime(arg_13_0)
	local var_13_0 = arg_13_0:getAmazonCurrentRoundEndTime()
	
	if not var_13_0 then
		return 
	end
	
	return var_13_0 - (os.time() + arg_13_0:__getCheatAddSeconds())
end

function EventPlatform.getAmazonCurrentRound(arg_14_0)
	local var_14_0 = arg_14_0:getAmazonCurrentRoundData()
	
	if not var_14_0 then
		return 
	end
	
	return var_14_0.round
end

function EventPlatform.getAmazonCurrentOfferID(arg_15_0)
	local var_15_0 = arg_15_0:getAmazonCurrentRoundData()
	
	if not var_15_0 then
		return 
	end
	
	return var_15_0.offer_id
end

function EventPlatform.isRewardedCurrentRound(arg_16_0)
	return SAVE:get("amazon_promotion.last_rewarded_round_id", 0) == arg_16_0:getAmazonCurrentRoundID()
end

function EventPlatform.updateIndicator(arg_17_0)
	local var_17_0 = os.time() + arg_17_0:__getCheatAddSeconds()
	
	SAVE:set("amazon_promotion.last_open_time", var_17_0)
end

function EventPlatform.isNewRound(arg_18_0)
	local var_18_0 = SAVE:get("amazon_promotion.last_open_time", 0)
	local var_18_1 = arg_18_0:getAmazonRoundDataByTime(var_18_0)
	local var_18_2 = arg_18_0:getAmazonCurrentRoundData()
	
	if not var_18_2 then
		return false
	end
	
	if not var_18_1 then
		return true
	end
	
	return var_18_1.id ~= var_18_2.id
end

function EventPlatform.isRoundRemain3Days(arg_19_0)
	local var_19_0 = arg_19_0:getAmazonCurrentRoundEndTime()
	
	if not var_19_0 then
		return 
	end
	
	local var_19_1 = 259200
	
	if var_19_1 < var_19_0 - (os.time() + arg_19_0:__getCheatAddSeconds()) then
		return false
	end
	
	return var_19_1 < var_19_0 - SAVE:get("amazon_promotion.last_open_time", 0)
end

function EventPlatform.isVisibleAmazonIndicator(arg_20_0)
	if arg_20_0:isRewardedCurrentRound() then
		return false
	end
	
	if arg_20_0:isNewRound() then
		return true
	end
	
	if arg_20_0:isRoundRemain3Days() then
		return true
	end
	
	return false
end

function EventPlatform.__getCheatAddSeconds(arg_21_0)
	if PRODUCTION_MODE then
		return 0
	end
	
	return arg_21_0.cheat_add_seconds or 0
end

function EventPlatform.__addSeconds(arg_22_0, arg_22_1, arg_22_2)
	if PRODUCTION_MODE then
		return 
	end
	
	arg_22_0.cheat_add_seconds = arg_22_0.cheat_add_seconds or 0
	
	if arg_22_2 then
		arg_22_0.cheat_add_seconds = 0
	end
	
	arg_22_0.cheat_add_seconds = arg_22_0.cheat_add_seconds + arg_22_1
	arg_22_0.vars = {}
end

function EventPlatform.__addMinutes(arg_23_0, arg_23_1, arg_23_2)
	arg_23_0:__addSeconds(arg_23_1 * 60, arg_23_2)
end

function EventPlatform.__addHours(arg_24_0, arg_24_1, arg_24_2)
	arg_24_0:__addSeconds(arg_24_1 * 60 * 60, arg_24_2)
end

function EventPlatform.__addDays(arg_25_0, arg_25_1, arg_25_2)
	arg_25_0:__addSeconds(arg_25_1 * 24 * 60 * 60, arg_25_2)
end

function EventPlatform.__addWeeks(arg_26_0, arg_26_1, arg_26_2)
	arg_26_0:__addSeconds(arg_26_1 * 7 * 24 * 60 * 60, arg_26_2)
end

function EventPlatform.__addRemain10seconds(arg_27_0)
	arg_27_0:__addSeconds(arg_27_0:getAmazonCurrentRoundRemainTime() - 10)
end
