HeroRecruit = HeroRecruit or {}
HeroRecruit.vars = {}

local var_0_0 = 200

function HANDLER.hero_recruit(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_close" then
		HeroRecruit:close()
		
		return 
	end
	
	if arg_1_1 == "btn_slot1" then
		HeroRecruit:onBtnDestiny()
		
		return 
	end
	
	if arg_1_1 == "btn_slot2" then
		HeroRecruit:onBtnMoonlightDestiny()
		
		return 
	end
	
	if arg_1_1 == "btn_slot3" then
		HeroRecruit:onBtnClassChange()
		
		return 
	end
end

function HeroRecruit.close(arg_2_0)
	UIAction:Add(SEQ(LOG(FADE_OUT(var_0_0)), REMOVE()), arg_2_0.vars.wnd, "block")
	BackButtonManager:pop(arg_2_0.vars.wnd)
end

function HeroRecruit.open(arg_3_0)
	if not UnlockSystem:isUnlockSystemAndMsg({
		replace_title = "ui_recruit_hero",
		exclude_story = true,
		id = UNLOCK_ID.DESTINY
	}, function()
	end) then
		return 
	end
	
	arg_3_0.vars = {}
	
	local var_3_0 = SceneManager:getRunningPopupScene()
	
	arg_3_0.vars.wnd = load_dlg("hero_recruit", true, "wnd", function()
		arg_3_0:close()
	end)
	
	arg_3_0.vars.wnd:setOpacity(0)
	UIAction:Add(LOG(FADE_IN(var_0_0)), arg_3_0.vars.wnd, "block")
	var_3_0:addChild(arg_3_0.vars.wnd)
	arg_3_0.vars.wnd:bringToFront()
	arg_3_0:initDestinySlot()
	arg_3_0:initMoonDestinySlot()
	arg_3_0:initClassChangeSlot()
	GrowthGuideNavigator:proc()
end

function HeroRecruit.isUnlockSystem(arg_6_0)
	return UnlockSystem:isUnlockSystem(UNLOCK_ID.DESTINY)
end

function HeroRecruit.onBtnDestiny(arg_7_0)
	if not UnlockSystem:isUnlockSystem(UNLOCK_ID.DESTINY) then
		local var_7_0, var_7_1, var_7_2 = UnlockSystem:getSystemEnterData(UNLOCK_ID.DESTINY)
		
		balloon_message_with_sound(var_7_0)
		
		return 
	end
	
	HeroRecruit:close()
	Lobby:showCharacterRewardsSystem(arg_7_0.vars.destiny_char_code)
end

function HeroRecruit.onBtnMoonlightDestiny(arg_8_0)
	if MoonlightDestiny:show() then
		HeroRecruit:close()
	end
end

function HeroRecruit.onBtnClassChange(arg_9_0)
	HeroRecruit:close()
	ClassChange:show()
end

function HeroRecruit.setPortrait(arg_10_0, arg_10_1, arg_10_2)
	if not get_cocos_refid(arg_10_1) then
		return 
	end
	
	if not arg_10_2 then
		return 
	end
	
	local var_10_0 = UIUtil:getPortraitAniByCode(arg_10_2)
	
	if not var_10_0 then
		return 
	end
	
	if_set_visible(arg_10_1, nil, true)
	var_10_0:setAnchorPoint(0.5, 0)
	var_10_0:setScale(0.8)
	arg_10_1:removeAllChildren()
	arg_10_1:addChild(var_10_0)
end

local function var_0_1(arg_11_0, arg_11_1, arg_11_2)
	if not get_cocos_refid(arg_11_0) then
		return 
	end
	
	if not arg_11_1 then
		return 
	end
	
	if not arg_11_2 or arg_11_2 == 0 then
		return 
	end
	
	if_set_visible(arg_11_0, nil, true)
	if_set(arg_11_0, "t_count", arg_11_1 .. "/" .. arg_11_2)
	
	local var_11_0 = arg_11_1 / arg_11_2 * 100
	
	if_set(arg_11_0, "complete", math.round(var_11_0) .. "%")
	if_set_circle_percent(arg_11_0, "progress_bar", var_11_0)
end

function HeroRecruit.moveSlot(arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = arg_12_0.vars.wnd:getChildByName("n_move_slot")
	
	if not get_cocos_refid(var_12_0) then
		return 
	end
	
	local var_12_1 = var_12_0:getChildByName(arg_12_2)
	
	if not get_cocos_refid(var_12_1) then
		return 
	end
	
	arg_12_1:setPosition(var_12_1:getPosition())
end

function HeroRecruit.initDestinySlot(arg_13_0)
	arg_13_0.vars.destiny = {}
	arg_13_0.vars.destiny.n_slot = arg_13_0.vars.wnd:getChildByName("n_slot1")
	arg_13_0.vars.destiny.n_unlock = arg_13_0.vars.destiny.n_slot:getChildByName("n_unlock")
	arg_13_0.vars.destiny.n_portrait = arg_13_0.vars.destiny.n_slot:getChildByName("n_portrait"):getChildByName("n_pos")
	arg_13_0.vars.destiny.n_progress = arg_13_0.vars.destiny.n_slot:getChildByName("n_progress")
	
	if MoonlightDestiny:isCompleteAllSeason() then
		arg_13_0:moveSlot(arg_13_0.vars.destiny.n_slot, "n_move_slot1")
	end
	
	local var_13_0 = Destiny:updateData()
	local var_13_1 = Destiny:isNew()
	
	if_set_visible(arg_13_0.vars.destiny.n_slot, "img_noti", not var_13_1 and var_13_0)
	if_set_visible(arg_13_0.vars.destiny.n_slot, "img_new", var_13_1)
	
	local var_13_2 = not UnlockSystem:isUnlockSystem(UNLOCK_ID.DESTINY)
	
	if_set_visible(arg_13_0.vars.destiny.n_unlock, nil, var_13_2)
	if_set_visible(arg_13_0.vars.destiny.n_portrait, nil, false)
	if_set_visible(arg_13_0.vars.destiny.n_progress, nil, false)
	
	if var_13_2 then
		if_set_color(arg_13_0.vars.destiny.n_slot, "Img_box", cc.c3b(129, 129, 129))
		
		return 
	end
	
	if SceneManager:getCurrentSceneName() == "lobby" and not Lobby:isAlternativeLobby() then
		local var_13_3 = Lobby:getCurrnetDestinyCharacter()
		
		if var_13_3 then
			arg_13_0:setPortrait(arg_13_0.vars.destiny.n_portrait, var_13_3)
			
			arg_13_0.vars.destiny_char_code = var_13_3
		end
	else
		local var_13_4 = Destiny:getRandomCharacter()
		
		if var_13_4 then
			arg_13_0:setPortrait(arg_13_0.vars.destiny.n_portrait, var_13_4.code)
			
			arg_13_0.vars.destiny_char_code = var_13_4.code
		end
	end
	
	var_0_1(arg_13_0.vars.destiny.n_progress, Destiny:getRewardedCount(), Destiny:getListCount())
end

function HeroRecruit.initMoonDestinySlot(arg_14_0)
	arg_14_0.vars.moon_destiny = {}
	arg_14_0.vars.moon_destiny.n_slot = arg_14_0.vars.wnd:getChildByName("n_slot2")
	arg_14_0.vars.moon_destiny.n_unlock = arg_14_0.vars.moon_destiny.n_slot:getChildByName("n_unlock")
	arg_14_0.vars.moon_destiny.n_portrait = arg_14_0.vars.moon_destiny.n_slot:getChildByName("n_portrait"):getChildByName("n_pos")
	
	if MoonlightDestiny:isCompleteAllSeason() then
		if_set_visible(arg_14_0.vars.moon_destiny.n_slot, nil, false)
		
		return 
	end
	
	if_set_visible(arg_14_0.vars.moon_destiny.n_slot, "img_noti", MoonlightDestiny:isEnableRedDot())
	if_set_sprite(arg_14_0.vars.moon_destiny.n_slot, "bg", MoonlightDestiny:getBannerBackgroundImagePath())
	
	local var_14_0 = MoonlightDestiny:getSeasonTitle()
	local var_14_1 = arg_14_0.vars.moon_destiny.n_slot:getChildByName("t_disc")
	
	if get_cocos_refid(var_14_1) then
		if_set(var_14_1, nil, MoonlightDestiny:getRecruitDesc())
		
		if var_14_0 and var_14_0 ~= "" then
			if_set(arg_14_0.vars.moon_destiny.n_slot, "t_season_title", var_14_0)
			
			local var_14_2 = arg_14_0.vars.moon_destiny.n_slot:getChildByName("t_disc_move")
			
			if get_cocos_refid(var_14_2) then
				var_14_1:setPosition(var_14_2:getPosition())
			end
		end
	end
	
	local var_14_3 = not MoonlightDestiny:isUnlockSeason()
	
	if_set_visible(arg_14_0.vars.moon_destiny.n_unlock, nil, var_14_3)
	if_set_visible(arg_14_0.vars.moon_destiny.n_portrait, nil, false)
	
	if var_14_3 then
		if_set(arg_14_0.vars.moon_destiny.n_unlock, "t_disc", MoonlightDestiny:getRecruitUnlockText())
		if_set_color(arg_14_0.vars.moon_destiny.n_slot, "Img_box", cc.c3b(129, 129, 129))
		
		return 
	end
	
	arg_14_0:setPortrait(arg_14_0.vars.moon_destiny.n_portrait, MoonlightDestiny:getSelectCharacterCode())
end

function HeroRecruit.initClassChangeSlot(arg_15_0)
	arg_15_0.vars.change_class = {}
	arg_15_0.vars.change_class.n_slot = arg_15_0.vars.wnd:getChildByName("n_slot3")
	arg_15_0.vars.change_class.n_unlock = arg_15_0.vars.change_class.n_slot:getChildByName("n_unlock")
	arg_15_0.vars.change_class.n_portrait = arg_15_0.vars.change_class.n_slot:getChildByName("n_portrait"):getChildByName("n_pos")
	arg_15_0.vars.change_class.n_progress = arg_15_0.vars.change_class.n_slot:getChildByName("n_progress")
	
	if MoonlightDestiny:isCompleteAllSeason() then
		arg_15_0:moveSlot(arg_15_0.vars.change_class.n_slot, "n_move_slot3")
	end
	
	local var_15_0, var_15_1 = ClassChange:CheckNotification()
	local var_15_2 = ClassChange:isNew()
	
	if_set_visible(arg_15_0.vars.change_class.n_slot, "img_noti", not var_15_2 and var_15_0)
	if_set_visible(arg_15_0.vars.change_class.n_slot, "img_new", var_15_2)
	
	local var_15_3 = not UnlockSystem:isUnlockSystem(UNLOCK_ID.CLASS_CHANGE)
	
	if_set_visible(arg_15_0.vars.change_class.n_unlock, nil, var_15_3)
	if_set_visible(arg_15_0.vars.change_class.n_portrait, nil, false)
	if_set_visible(arg_15_0.vars.change_class.n_progress, nil, false)
	
	if var_15_3 then
		if_set_color(arg_15_0.vars.change_class.n_slot, "Img_box", cc.c3b(129, 129, 129))
		
		return 
	end
	
	arg_15_0:setPortrait(arg_15_0.vars.change_class.n_portrait, ClassChange:getRandomOwnCharacterCode())
	
	local var_15_4, var_15_5 = ClassChange:getCompletedCount()
	
	var_0_1(arg_15_0.vars.change_class.n_progress, var_15_4, var_15_5)
end

function HeroRecruit.isNew(arg_16_0)
	if Destiny:isNew() then
		return true
	end
	
	if ClassChange:isNew() then
		return true
	end
	
	return false
end

function HeroRecruit.isNotification(arg_17_0)
	if MoonlightDestiny:isEnableRedDot() then
		return true
	end
	
	local var_17_0, var_17_1 = ClassChange:CheckNotification()
	
	if var_17_0 then
		return true
	end
	
	if Destiny:updateData() then
		return true
	end
	
	return false
end
