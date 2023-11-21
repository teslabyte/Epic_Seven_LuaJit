AmazonPromotion = AmazonPromotion or {}
AmazonPromotion.TAG = "amazon_promotion"
AmazonPromotion.vars = {}

function MsgHandler.get_amazon_promotion_rewards(arg_1_0)
	if not arg_1_0 or arg_1_0.res ~= "ok" then
		return 
	end
	
	AmazonPromotion.vars.promotion_data = arg_1_0.promotion
	AmazonPromotion.vars.current_round_data = arg_1_0.current_round
	
	if AmazonPromotion.vars.onGetRewards then
		AmazonPromotion.vars.onGetRewards(AmazonPromotion.vars.promotion_data)
	end
end

function MsgHandler.req_amazon_promotion_reward(arg_2_0)
	print(AmazonPromotion.TAG, arg_2_0.res)
	
	if arg_2_0.res == "ok" then
		local var_2_0 = AmazonPromotion:getCurrentRoundData()
		
		if var_2_0 then
			var_2_0.is_rewarded = true
		end
		
		SAVE:set("amazon_promotion.last_rewarded_round_id", EventPlatform:getAmazonCurrentRoundID())
	end
	
	if AmazonPromotion.vars.callback_req_reward then
		AmazonPromotion.vars.callback_req_reward(arg_2_0)
	end
end

function onAmazonLogin(arg_3_0)
	print(AmazonPromotion.TAG, "onAmazonLogin", arg_3_0)
	
	local var_3_0 = json.decode(arg_3_0)
	
	if not var_3_0 then
		return 
	end
	
	if AmazonPromotion.vars.callback_login then
		AmazonPromotion.vars.callback_login(var_3_0)
	end
	
	if not AmazonPromotionBase:isOpen() then
		balloon_message(T("msg_need_amazon_prime_popup"), nil, nil, {
			delay = 3000
		})
		
		return 
	end
	
	if var_3_0.result ~= "ok" then
		return 
	end
	
	AmazonPromotion:reqReward(var_3_0.account, var_3_0.access_token)
end

function onAmazonLogout(arg_4_0)
	print(AmazonPromotion.TAG, "onAmazonLogout", arg_4_0)
	
	local var_4_0 = json.decode(arg_4_0)
	
	if not var_4_0 then
		return 
	end
	
	if AmazonPromotion.vars.callback_logout then
		AmazonPromotion.vars.callback_logout(var_4_0)
	end
	
	if var_4_0.result ~= "ok" and var_4_0.result ~= "not login status" then
		return 
	end
	
	print(AmazonPromotion.TAG, "AmazonPromotion.Login")
	
	if not amazon_promotion_login then
		return 
	end
	
	amazon_promotion_login()
end

function AmazonPromotion.isEnable(arg_5_0)
	if Stove:isChina_ip() then
		return false
	end
	
	if IS_ANDROID_BASED_PLATFORM then
		return not ContentDisable:byAlias("amazon_prime_aos_btn")
	end
	
	if PLATFORM == "iphoneos" then
		return not ContentDisable:byAlias("amazon_prime_ios_btn")
	end
	
	return not ContentDisable:byAlias("amazon_prime_aos_btn") or not ContentDisable:byAlias("amazon_prime_ios_btn")
end

function AmazonPromotion.init(arg_6_0)
	if not arg_6_0:isEnable() then
		return 
	end
	
	EventPlatform:updateIndicator()
	PromotionBanner:createPageMarker()
end

function AmazonPromotion.login(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	if not arg_7_0:isEnable() then
		return 
	end
	
	if not arg_7_0.vars then
		return 
	end
	
	arg_7_0.vars.callback_logout = arg_7_1
	arg_7_0.vars.callback_login = arg_7_2
	arg_7_0.vars.callback_req_reward = arg_7_3
	
	if PLATFORM == "win32" then
		AmazonPromotion:reqReward("test_account", "test_token")
		
		return 
	end
	
	print(AmazonPromotion.TAG, "AmazonPromotion.Logout")
	
	if not amazon_promotion_logout then
		return 
	end
	
	amazon_promotion_logout()
end

function AmazonPromotion.reqReward(arg_8_0, arg_8_1, arg_8_2)
	if not arg_8_0.vars then
		return 
	end
	
	local var_8_0 = EventPlatform:getAmazonCurrentPromotionID()
	
	if not var_8_0 then
		return 
	end
	
	local var_8_1 = EventPlatform:getAmazonCurrentOfferID()
	
	if not var_8_1 then
		return 
	end
	
	local var_8_2 = EventPlatform:__getCheatAddSeconds()
	
	print(AmazonPromotion.TAG, "reqReward, " .. arg_8_1)
	query("req_amazon_promotion_reward", {
		token = arg_8_2,
		account = arg_8_1,
		offer_id = var_8_1,
		promotion_id = var_8_0,
		cheat_add_seconds = var_8_2
	})
end

function AmazonPromotion.logout(arg_9_0)
	print(AmazonPromotion.TAG, "AmazonPromotion.Logout")
	
	if not amazon_promotion_logout then
		return 
	end
	
	amazon_promotion_logout()
	
	AmazonPromotion.vars = {}
end

function AmazonPromotion.getRewards(arg_10_0, arg_10_1)
	local var_10_0 = EventPlatform:__getCheatAddSeconds()
	
	arg_10_0.vars.onGetRewards = arg_10_1
	
	query("get_amazon_promotion_rewards", {
		cheat_add_seconds = var_10_0
	})
end

function AmazonPromotion.getCurrentRoundData(arg_11_0)
	if not arg_11_0.vars.current_round_data then
		return 
	end
	
	return arg_11_0.vars.current_round_data
end
