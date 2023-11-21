PetCare = {}

function MsgHandler.care_pet(arg_1_0)
	PetCare:careResult(arg_1_0)
	ConditionContentsManager:dispatch("pet.care")
end

function HANDLER.pet_care_popup(arg_2_0, arg_2_1)
	if arg_2_1 == "btn_ok" then
		PetCare:req_playing()
	elseif arg_2_1 == "btn_cancel" then
		PetCare:close_carePopup()
	elseif arg_2_1 == "btn_playing" or arg_2_1 == "btn_feeding" then
		PetCare:click_playType(arg_2_1)
	end
end

function PetCare.open_carePopup(arg_3_0, arg_3_1, arg_3_2)
	if arg_3_0.vars and get_cocos_refid(arg_3_0.vars.wnd) then
		return 
	end
	
	arg_3_0.vars = {}
	
	local var_3_0
	
	if arg_3_1 then
		var_3_0 = arg_3_1
	else
		local var_3_1 = PetUIBase:getPetBelt()
		
		if var_3_1 then
			var_3_0 = var_3_1:getCurrentItem()
		end
	end
	
	if not var_3_0 then
		return 
	end
	
	if not var_3_0:isFavUpgradeable() then
		balloon_message_with_sound("ui_pet_detail_take_care_max")
		
		return 
	end
	
	arg_3_0.vars.cur_mat = GAME_STATIC_VARIABLE.pet_care_token
	arg_3_0.vars.cur_pet = var_3_0
	arg_3_0.vars.wnd = load_dlg("pet_care_popup", nil, "wnd", function()
		PetCare:close_carePopup(nil, true)
	end)
	
	if_set_visible(arg_3_0.vars.wnd, "txt_type", false)
	if_set_visible(arg_3_0.vars.wnd, "txt_name", false)
	
	local var_3_2 = arg_3_0.vars.wnd:getChildByName("n_playing")
	local var_3_3 = GAME_CONTENT_VARIABLE.pet_care_price or 50
	local var_3_4 = UIUtil:getRewardIcon(var_3_3, GAME_STATIC_VARIABLE.pet_care_token, {
		show_small_count = true,
		show_name = false,
		parent = var_3_2:getChildByName("n_reward_icon")
	})
	
	if_set(var_3_2, "txt", T("text_item_have_count", {
		count = Account:getPropertyCount(GAME_STATIC_VARIABLE.pet_care_token)
	}))
	if_set(var_3_2, "txt_playing", T("stigma_name"))
	
	local var_3_5 = arg_3_0.vars.wnd:getChildByName("n_feeding")
	local var_3_6 = UIUtil:getRewardIcon(tonumber(1), "ma_petfood_f", {
		show_small_count = true,
		show_name = false,
		parent = var_3_5:getChildByName("n_reward_icon")
	})
	
	if_set(var_3_5, "txt", T("text_item_have_count", {
		count = Account:getPropertyCount("ma_petfood_f")
	}))
	if_set(var_3_5, "txt_feeding", T("ma_petfood_f_name"))
	
	if var_3_0:isTodayTakeCare() then
		if_set_visible(var_3_2, "txt_available", true)
		if_set_visible(var_3_2, "txt_none_available", false)
	else
		if_set_visible(var_3_2, "txt_available", false)
		if_set_visible(var_3_2, "txt_none_available", true)
		if_set(var_3_2, "txt_none_available", T("ui_pet_care_popup_limit"))
		if_set_opacity(var_3_4, nil, 76.5)
		if_set_opacity(var_3_2, "txt_playing", 76.5)
		if_set_opacity(var_3_2, "txt", 76.5)
		
		arg_3_0.vars.cur_mat = "ma_petfood_f"
	end
	
	UIUtil:getPetIcon(var_3_0, {
		parent = arg_3_0.vars.wnd:getChildByName("n_pet_icon")
	})
	UIAction:Add(SEQ(DELAY(200), LOOP(SEQ(LOG(FADE_OUT(300)), LOG(FADE_IN(300))))), arg_3_0.vars.wnd:getChildByName("progress_white"), "team_upgrade.blink")
	arg_3_0:click_playType("btn_playing")
	SceneManager:getRunningNativeScene():addChild(arg_3_0.vars.wnd)
	
	arg_3_2 = arg_3_2 or {}
	
	if arg_3_2.callback then
		arg_3_0.vars.callback = arg_3_2.callback
	end
	
	Analytics:setPopup("pet_care")
	
	return true
end

function PetCare.click_playType(arg_5_0, arg_5_1)
	local var_5_0 = arg_5_0.vars.wnd:getChildByName("n_playing")
	local var_5_1 = arg_5_0.vars.wnd:getChildByName("n_feeding")
	local var_5_2 = arg_5_0.vars.wnd:getChildByName("btn_ok")
	local var_5_3 = 0
	local var_5_4 = arg_5_0.vars.cur_pet
	
	if arg_5_1 == "btn_playing" and var_5_4:isTodayTakeCare() then
		if_set_visible(var_5_0, "bg_select", true)
		if_set_visible(var_5_1, "bg_select", false)
		
		arg_5_0.vars.cur_mat = GAME_STATIC_VARIABLE.pet_care_token
		
		if_set(var_5_2, "txt_price", GAME_CONTENT_VARIABLE.pet_care_price or 50)
		SpriteCache:resetSprite(var_5_2:getChildByName("icon_token"), "item/token_stigma.png")
		
		var_5_3 = GAME_STATIC_VARIABLE.pet_care_up
	else
		if_set_visible(var_5_0, "bg_select", false)
		if_set_visible(var_5_1, "bg_select", true)
		
		arg_5_0.vars.cur_mat = "ma_petfood_f"
		
		if_set(var_5_2, "txt_price", 1)
		SpriteCache:resetSprite(var_5_2:getChildByName("icon_token"), "item/ma_petfood_f_1.png")
		
		local var_5_5 = DB("item_material", "ma_petfood_f", {
			"get_xp"
		})
		
		var_5_3 = tonumber(var_5_5)
	end
	
	if var_5_4:getFav() + var_5_3 >= var_5_4:getMaxFav() then
		var_5_3 = var_5_4:getMaxFav() - var_5_4:getFav()
	end
	
	UIUtil:updatePetFavBar(arg_5_0.vars.wnd:getChildByName("progress_bar"), var_5_4)
	UIUtil:updatePetFavText(arg_5_0.vars.wnd:findChildByName("txt_exp"), var_5_4, {
		inc_fav = var_5_3
	})
	UIUtil:updatePetFavBar(arg_5_0.vars.wnd:findChildByName("progress_white"), var_5_4, {
		inc_fav = var_5_3
	})
	if_set(arg_5_0.vars.wnd:getChildByName("n_favorabililty"), "txt", T("ui_pet_detail_favor") .. "+" .. var_5_3)
	
	local var_5_6 = arg_5_0:get_afterUpgradeInfo(var_5_4, var_5_3)
	
	UIUtil:updatePetFavIcon(arg_5_0.vars.wnd:getChildByName("n_pet_love_icon"):getChildByName("icon"), nil, {
		fav_level = var_5_6
	})
	UIUtil:updatePetFavLevel(arg_5_0.vars.wnd:getChildByName("txt_level"), nil, {
		fav_level = var_5_6
	})
end

function PetCare.get_afterUpgradeInfo(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_1:getFav() + arg_6_2
	local var_6_1 = arg_6_1:getFavMaxLevel()
	
	for iter_6_0 = arg_6_1:getFavLevel(), var_6_1 do
		local var_6_2 = "pg_" .. iter_6_0
		local var_6_3 = DB("pet_grade", var_6_2, {
			"affection"
		})
		
		if not var_6_3 or var_6_0 <= var_6_3 then
			return iter_6_0
		end
	end
end

function PetCare.req_playing(arg_7_0)
	local var_7_0 = arg_7_0.vars.cur_mat
	local var_7_1 = GAME_CONTENT_VARIABLE.pet_care_price or 50
	
	if var_7_0 == "ma_petfood_f" then
		var_7_1 = 1
	end
	
	if var_7_1 > Account:getPropertyCount(var_7_0) then
		balloon_message_with_sound("ui_pet_care_popup_lack")
		
		return 
	elseif var_7_0 == GAME_STATIC_VARIABLE.pet_care_token then
		if not arg_7_0.vars.cur_pet:isTodayTakeCare() then
			balloon_message_with_sound("하루한번 돌보기 이미했음")
			
			return 
		end
		
		query("care_pet", {
			today_care = true,
			uid = PetCare.vars.cur_pet:getUID()
		})
	else
		query("care_pet", {
			uid = PetCare.vars.cur_pet:getUID()
		})
	end
end

function PetCare.careResult(arg_8_0, arg_8_1)
	if not arg_8_1 then
		return 
	end
	
	SoundEngine:play("event:/ui/pet/" .. arg_8_0.vars.cur_pet:getRace())
	Account:addReward(arg_8_1.result)
	
	local var_8_0 = arg_8_0.vars.cur_pet:getFav()
	
	arg_8_0.vars.cur_pet:setFav(arg_8_1.fav)
	arg_8_0.vars.cur_pet:updateFavLevel()
	arg_8_0.vars.cur_pet:set_careDay(arg_8_1.care_day)
	
	local var_8_1 = arg_8_0.vars.cur_pet:getFav()
	
	ConditionContentsManager:dispatch("pet.favorability", {
		prev_value = var_8_0,
		value = var_8_1
	})
	
	if PetUIMain.vars and PetUIMain.vars.mode == "Detail" then
		PetDetail:setPetInfos(arg_8_0.vars.cur_pet)
		arg_8_0:active_careEffect()
	end
	
	arg_8_0:close_carePopup(true)
end

function PetCare.active_careEffect(arg_9_0)
	PetDetail:onActivePetCare()
end

function PetCare.close_carePopup(arg_10_0, arg_10_1, arg_10_2)
	if not get_cocos_refid(arg_10_0.vars.wnd) then
		return 
	end
	
	BackButtonManager:pop({
		id = "pet_care_popup",
		dlg = arg_10_0.vars.wnd
	})
	
	if arg_10_0.vars.callback then
		arg_10_0.vars.callback(arg_10_0.vars.cur_pet, arg_10_1, arg_10_2)
	end
	
	arg_10_0.vars.wnd:removeFromParent()
	
	arg_10_0.vars = nil
	
	Analytics:closePopup()
end
