function HANDLER.shop_random(arg_1_0, arg_1_1)
	local var_1_0 = arg_1_0:getName()
	
	if var_1_0 == "btn_top_back" then
		ShopRandom:onPushBackButton()
	end
	
	if var_1_0 == "btn_refresh" then
		ShopRandom:onButtonRefresh()
	end
	
	if var_1_0 == "btn_mob" then
		print(getParentWindow(arg_1_0).code)
	end
	
	if var_1_0 == "btn_levelup" then
		ShopRandom:onButtonLevelup()
	end
	
	if var_1_0 == "btn_Help" then
		local var_1_1 = "infosecr"
		
		HelpGuide:open({
			menu = var_1_1
		})
	end
	
	if var_1_0 == "btn_info" then
		ShopRandom:showRandomShopRate()
	end
end

function MsgHandler.random_shop_rate(arg_2_0)
	ShopRandom:showRandomShopRate(arg_2_0)
end

function MsgHandler.random_shop(arg_3_0)
	if DEBUG.test_45045 then
		Log.e("Testing : DEBUG.test_45045")
		
		DEBUG[nil] = "test"
	end
	
	AccountData.random_shop = arg_3_0.list
	
	table.sort(AccountData.random_shop, function(arg_4_0, arg_4_1)
		return to_n(arg_4_0.sort) < to_n(arg_4_1.sort)
	end)
	
	AccountData.rshop_tm = arg_3_0.refresh_time
	
	Account:clearRandomShopLimits()
	
	if arg_3_0.limits then
		Account:updateLimits(arg_3_0.limits)
	end
	
	if arg_3_0.ticketed_limits then
		AccountData.ticketed_limits = arg_3_0.ticketed_limits
	end
	
	local var_3_0 = Account:getRandomShoplevel()
	
	if arg_3_0.rshop_level and var_3_0 ~= arg_3_0.rshop_level then
		ShopRandom:showShopLevelup(var_3_0, arg_3_0.rshop_level)
	end
	
	Account:setRandomShoplevel(arg_3_0.rshop_level)
	Account:updateCurrencies(arg_3_0)
	
	if not ShopRandom.ready then
		if arg_3_0.npc == "lobby" then
			Lobby:toggleBartenderMode(true)
		else
			ShopRandom:show(SceneManager:getRunningPopupScene())
		end
		
		ShopRandom.ready = true
	else
		ShopRandom:onRefresh()
	end
	
	if arg_3_0.midnight and arg_3_0.npc ~= "lobby" then
		ShopRandom.last_refresh_tm = arg_3_0.midnight
	end
	
	ShopRandom:jumpToPercent(0)
	WidgetUtils:checkCloseToolTip()
end

ShopRandom = ShopRandom or {}

copy_functions(ScrollView, ShopRandom)
copy_functions(ShopCommon, ShopRandom)

function ShopRandom.isRefreshable(arg_5_0)
	if not UnlockSystem:isUnlockSystem(UNLOCK_ID.PUB) then
		return false
	end
	
	return to_n(AccountData.rshop_tm) < os.time()
end

function ShopRandom.open(arg_6_0, arg_6_1)
	if ContentDisable:byAlias("market_secret_all") then
		balloon_message(T("content_disable"))
		
		return 
	end
	
	local var_6_0 = {}
	
	var_6_0.lobby = "market_secret_lobby"
	var_6_0.advgob_shop = "market_secret_gobl"
	var_6_0.bmije_shop = "market_secret_huche"
	var_6_0.bmnet_shop = "market_secret_maze_1"
	var_6_0.bmnet_shop2 = "market_secret_maze_2"
	
	if ContentDisable:byAlias(var_6_0[arg_6_1]) then
		balloon_message(T("content_disable"))
		
		return 
	end
	
	arg_6_0.ready = nil
	arg_6_0.npc = arg_6_1
	arg_6_0.talker_key = string.format("random(%s)", arg_6_1 or "")
	
	query("random_shop", {
		npc = arg_6_1
	})
end

function ShopRandom.onAfterUpdate(arg_7_0)
	local var_7_0 = os.time()
	
	if arg_7_0.prevTick == nil then
		arg_7_0.prevTick = var_7_0
	elseif not arg_7_0.ready or arg_7_0.prevTick == var_7_0 then
		return 
	end
	
	arg_7_0.prevTick = var_7_0
	
	arg_7_0:topbarUpdate()
	
	if arg_7_0.npc ~= "lobby" then
		if arg_7_0.last_refresh_tm and os.time() - arg_7_0.last_refresh_tm > 86400 then
			arg_7_0:refresh()
		end
		
		return 
	end
	
	local var_7_1 = to_n(AccountData.rshop_tm) - os.time()
	
	if var_7_1 < 0 then
		arg_7_0:refresh()
		
		return 
	end
	
	local var_7_2 = sec_to_string(math.max(0, var_7_1))
	
	if_set(arg_7_0.wnd, "txt_rest_time", T("pub_reset_time", {
		time = var_7_2
	}))
end

function ShopRandom.refresh(arg_8_0, arg_8_1)
	if arg_8_0.refresh_lock then
		return 
	end
	
	arg_8_0.refresh_lock = true
	arg_8_1 = arg_8_1 or {}
	
	query("random_shop", {
		npc = arg_8_0.npc,
		refresh = arg_8_1.refresh,
		levelup = arg_8_1.levelup
	})
end

function ShopRandom.onRefresh(arg_9_0)
	arg_9_0.refresh_lock = nil
	
	ShopRandom:update()
	ShopRandom:setAniPortrait("action_01")
	SoundEngine:play("event:/ui/inc_equip_inven")
end

function ShopRandom.getRestTime(arg_10_0, arg_10_1, arg_10_2)
	arg_10_2 = arg_10_2 or os.time()
	
	local var_10_0 = AccountData.limits["sh:" .. arg_10_1]
	
	if not var_10_0 or not var_10_0.expire_tm or arg_10_2 > var_10_0.expire_tm then
		return nil
	end
	
	return var_10_0.expire_tm - arg_10_2
end

function ShopRandom.updateSoldOutItems(arg_11_0)
	if not arg_11_0.vars then
		return 
	end
	
	local var_11_0 = SceneManager:getCurrentSceneName()
	
	if var_11_0 ~= "lobby" and var_11_0 ~= "battle" then
		return 
	end
	
	local var_11_1 = "drs:"
	
	if var_11_0 == "lobby" then
		var_11_1 = "rs:"
	end
	
	for iter_11_0, iter_11_1 in pairs(arg_11_0.ScrollViewItems) do
		if get_cocos_refid(iter_11_1.control) then
			local var_11_2 = AccountData.limits[var_11_1 .. iter_11_1.item.id]
			local var_11_3 = var_11_2 and var_11_2.expire_tm > os.time()
			
			if var_11_3 then
				if_set_opacity(iter_11_1.control, "n_base", 76.5)
			else
				if_set_opacity(iter_11_1.control, "n_base", 255)
			end
			
			iter_11_1.item.sold_out = var_11_3
			
			if var_11_3 then
				if_set(iter_11_1.control, "txt_count", "0/1")
			else
				if_set(iter_11_1.control, "txt_count", "1/1")
			end
		end
	end
end

function ShopRandom.isVisible(arg_12_0)
	if get_cocos_refid(arg_12_0.wnd) then
		return arg_12_0.wnd:isVisible()
	end
end

function ShopRandom.show(arg_13_0, arg_13_1, arg_13_2)
	arg_13_2 = arg_13_2 or {}
	
	local var_13_0 = load_dlg("shop_random", true, "wnd")
	
	arg_13_0.wnd = var_13_0
	arg_13_0.vars = {}
	arg_13_0.vars.DB = {}
	
	local var_13_1, var_13_2, var_13_3, var_13_4 = DB("shop_random_list", arg_13_0.npc, {
		"item_material_list",
		"refresh_cost",
		"refresh_interval",
		"talk"
	})
	
	if var_13_1 then
		var_13_1 = string.split(var_13_1, ",")
		
		table.insert(var_13_1, "crystal")
		table.insert(var_13_1, "gold")
	else
		var_13_1 = {
			"crystal",
			"gold"
		}
	end
	
	if arg_13_0.npc == "lobby" then
		BackButtonManager:push({
			check_id = "randomshop",
			back_func = function()
				arg_13_0:onPushBackButton()
			end
		})
		if_set(var_13_0, "txt_top_title", T("randomshop"))
		arg_13_0:HelpbuttonPosition()
	else
		TopBarNew:create(T("battle_random_shop"), var_13_0, function()
			arg_13_0:onPushBackButton()
			BackButtonManager:pop("TopBarNew." .. T("battle_random_shop"))
		end, var_13_1)
		if_set(var_13_0, "txt_top_title", T("battle_random_shop"))
	end
	
	if_set_visible(var_13_0, "TOP_LEFT", arg_13_0.npc == "lobby")
	if_set_visible(var_13_0, "dim", arg_13_0.npc ~= "lobby")
	if_set_visible(var_13_0, "n_dungeon", arg_13_0.npc ~= "lobby")
	if_set_visible(var_13_0, "n_lobby", arg_13_0.npc == "lobby")
	
	local var_13_5 = tonumber(AccountData.rshop_tm or os.time() + 3600) - os.time()
	local var_13_6 = sec_to_string(math.max(0, var_13_5))
	
	if_set(arg_13_0.wnd, "txt_rest_time", T("pub_reset_time", {
		time = var_13_6
	}))
	Scheduler:addSlow(arg_13_0.wnd, arg_13_0.onAfterUpdate, arg_13_0)
	arg_13_0:topbarUpdate()
	
	if var_13_2 then
		if_set(var_13_0.c.n_refresh, "txt_refresh_gem", var_13_2)
	end
	
	if_set_visible(var_13_0, "n_refresh", var_13_2 ~= nil)
	
	arg_13_0.scrollview = var_13_0:getChildByName("scrollview")
	
	arg_13_0:initScrollView(arg_13_0.scrollview, 700, 145)
	arg_13_0:update(400)
	
	local var_13_7 = var_13_0:getChildByName(arg_13_0.npc == "lobby" and "n_lobby" or "n_dungeon")
	
	var_13_7:getChildByName("n_balloon"):setScale(0)
	TutorialGuide:procGuide()
	
	local var_13_8, var_13_9 = UIUtil:getPortraitAni(DB("shop_random_list", arg_13_0.npc, "face_id"), {
		pin_sprite_position_y = true
	})
	
	if var_13_8 then
		var_13_7:getChildByName("n_portrait"):addChild(var_13_8)
		var_13_8:setScale(1)
		var_13_8:setPositionY(var_13_8:getPositionY() + (var_13_9 and -160 or 320))
	end
	
	arg_13_0.vars.portrait = var_13_8
	
	if get_cocos_refid(arg_13_1) then
		arg_13_1:addChild(var_13_0)
	end
	
	arg_13_0.wnd:setOpacity(0)
	UIAction:Add(FADE_IN(400), arg_13_0.wnd, "block")
	UIUtil:playNPCSoundAndTextRandomly(arg_13_0.talker_key .. ".enter", var_13_7, "txt_balloon", 300, arg_13_0.talker_key .. ".idle")
	Analytics:setMode("shop_random")
	TutorialGuide:ifStartGuide("system_016")
	
	return arg_13_0.wnd
end

function ShopRandom.updateShopLevel(arg_16_0)
	if arg_16_0.npc ~= "lobby" then
		return 
	end
	
	local var_16_0 = arg_16_0.wnd:getChildByName("n_lobby")
	
	if get_cocos_refid(var_16_0) then
		local var_16_1 = Account:getRandomShoplevel()
		local var_16_2 = Account:getLevel()
		local var_16_3 = GAME_STATIC_VARIABLE[string.format("shop_random_level_%s_req_rank", var_16_1 + 1)]
		
		if var_16_3 then
			local var_16_4 = var_16_3 <= var_16_2
			
			if_set_visible(var_16_0, "btn_levelup", var_16_4)
			if_set_visible(var_16_0, "n_lv", not var_16_4)
			
			if not var_16_4 then
				if_set(var_16_0, "txt_lv", T("randomshop_level", {
					level = var_16_1
				}))
				if_set(var_16_0, "t_percent", T("random_shop_level_progress", {
					level = var_16_2,
					goal = var_16_3
				}))
				
				local var_16_5 = GAME_STATIC_VARIABLE[string.format("shop_random_level_%s_req_rank", var_16_1)] or 0
				
				if_set_percent(var_16_0, "pogress_bar", (var_16_2 - var_16_5) / (var_16_3 - var_16_5))
			else
				local var_16_6 = var_16_0:getChildByName("btn_levelup")
				
				if get_cocos_refid(var_16_6) then
					local var_16_7 = GAME_STATIC_VARIABLE[string.format("shop_random_level_%s_token", var_16_1 + 1)]
					local var_16_8 = GAME_STATIC_VARIABLE[string.format("shop_random_level_%s_prcie", var_16_1 + 1)]
					
					if_set(var_16_6, "txt_refresh_gem", var_16_8)
					UIUtil:getRewardIcon(nil, var_16_7, {
						no_bg = true,
						scale = 0.67,
						parent = var_16_6
					}):setPosition(var_16_6:getChildByName("icon_res"):getPosition())
					if_set_visible(var_16_6, "icon_res", false)
				end
			end
		else
			if_set(var_16_0, "txt_lv", T("randomshop_level", {
				level = var_16_1
			}))
			if_set(var_16_0, "t_percent", T("random_shop_level_max"))
			if_set_visible(var_16_0, "n_lv", true)
			if_set_visible(var_16_0, "btn_levelup", false)
			if_set_percent(var_16_0, "pogress_bar", 1)
		end
	end
end

function ShopRandom.showShopLevelup(arg_17_0, arg_17_1, arg_17_2)
	arg_17_1 = arg_17_1 or 1
	arg_17_2 = arg_17_2 or 1
	
	local var_17_0 = load_dlg("shop_levelup", true, "wnd")
	
	Dialog:msgBox(T("shop_levelup_desc"), {
		dlg = var_17_0,
		title = T("shop_levelup_title")
	})
	if_set(var_17_0, "txt_brfore", T("random_shop_level", {
		level = arg_17_1
	}))
	if_set(var_17_0, "txt_after", T("random_shop_level", {
		level = arg_17_2
	}))
	if_set(var_17_0, "txt_brfore_disc", T("random_shop_range" .. arg_17_1))
	if_set(var_17_0, "txt_after_disc", T("random_shop_range" .. arg_17_2))
end

function ShopRandom.setAniPortrait(arg_18_0, arg_18_1)
	if Action:Find("portrait") then
		return 
	end
	
	if arg_18_0.vars and get_cocos_refid(arg_18_0.vars.portrait) and arg_18_0.vars.portrait.is_model then
		Action:Add(SEQ(DMOTION(arg_18_1), MOTION("idle", true)), arg_18_0.vars.portrait, "portrait")
	end
end

function ShopRandom.exit(arg_19_0)
	UIAction:Add(SEQ(FADE_OUT(200), SHOW(false), DELAY(250), REMOVE(), DELAY(800)), arg_19_0.wnd, "block")
	
	arg_19_0.ScrollViewItems = nil
	arg_19_0.vars = nil
	arg_19_0.wnd = nil
	
	UIUtil:playNPCSound(arg_19_0.talker_key .. ".leave")
	Analytics:saveCurTabTime()
end

function ShopRandom.update(arg_20_0, arg_20_1)
	if not arg_20_0.vars then
		return 
	end
	
	if AccountData.random_shop ~= nil then
		arg_20_0.List = AccountData.random_shop
		
		arg_20_0:updateList(arg_20_1)
	end
	
	arg_20_0:updateSoldOutItems()
	arg_20_0:updateShopLevel()
	arg_20_0:onAfterUpdate()
end

function ShopRandom.updateList(arg_21_0, arg_21_1)
	if not get_cocos_refid(arg_21_0.wnd) then
		return 
	end
	
	arg_21_0:createScrollViewItems(arg_21_0.List)
	
	arg_21_0.DB = {}
	
	for iter_21_0, iter_21_1 in pairs(arg_21_0.List) do
		arg_21_0.DB[iter_21_1.id] = iter_21_1
	end
	
	for iter_21_2, iter_21_3 in pairs(arg_21_0.ScrollViewItems) do
		local var_21_0 = iter_21_3.control:getPositionY()
		local var_21_1 = -200
		
		iter_21_3.control:setPositionY(var_21_1)
		UIAction:Add(SEQ(DELAY(to_n(arg_21_1) + iter_21_2 * 80), LOG(MOVE_TO(250, 417.5, var_21_0), 200)), iter_21_3.control, "block")
	end
end

function ShopRandom.onDialogTouchDown(arg_22_0, arg_22_1, arg_22_2, arg_22_3)
end

ShopRandom.onDialogTouchMove = ShopRandom.onDialogTouchDown

function ShopRandom.onTouchDown(arg_23_0, arg_23_1, arg_23_2)
end

function ShopRandom.onTouchUp(arg_24_0, arg_24_1, arg_24_2)
end

function ShopRandom.onTouchMove(arg_25_0, arg_25_1, arg_25_2)
	arg_25_0:onDialogTouchDown(nil, arg_25_1, arg_25_2)
end

function ShopRandom.topbarUpdate(arg_26_0, arg_26_1)
	if not arg_26_0.vars then
		return 
	end
end

function ShopRandom.onButtonRefresh(arg_27_0)
	Dialog:msgBox(T("randomshop_refresh_confirm"), {
		yesno = true,
		handler = function()
			arg_27_0:refresh({
				refresh = true
			})
		end
	})
end

function ShopRandom.onButtonLevelup(arg_29_0)
	Dialog:msgBox(T("randomshop_levelup_confirm"), {
		yesno = true,
		handler = function()
			arg_29_0:refresh({
				levelup = true
			})
		end
	})
end

function ShopRandom.getScrollViewItem(arg_31_0, arg_31_1)
	arg_31_1.is_limit_button = true
	
	local var_31_0 = arg_31_0:makeShopItem(arg_31_1, "wnd/shop_random_card.csb", {
		shop_artifact_stone = true
	})
	
	var_31_0:setName("shop_card")
	
	var_31_0.is_random_shop = true
	
	if arg_31_1.icon then
		local var_31_1 = cc.CSLoader:createNode("wnd/mob_icon.csb")
		
		if_set_visible(var_31_1, "n_unit", false)
		if_set_visible(var_31_1, "boss", false)
		if_set_visible(var_31_1, "subboss", false)
		if_set_visible(var_31_1, "txt_small_count", false)
		if_set_sprite(var_31_1, "frame", "img/_hero_s_frame_ally.png")
		if_set_sprite(var_31_1, "face", "face/" .. arg_31_1.icon .. ".png")
		if_set(var_31_1, "txt_b_name", T(arg_31_1.seller))
		var_31_1:setAnchorPoint(0.5, 0.5)
		var_31_0:getChildByName("n_face"):addChild(var_31_1)
	end
	
	local var_31_2, var_31_3 = DB("item_material", arg_31_1.type, {
		"ma_type",
		"ma_type2"
	})
	
	if var_31_2 == "stone" and var_31_3 == "artifact" then
		var_31_0:getChildByName("n_reward_item"):getChildByName("slot"):setScale(0.85)
		var_31_0.c.n_item_pos:setPositionX(var_31_0.c.n_item_pos:getPositionX() + 1)
		var_31_0.c.n_item_pos:setPositionY(var_31_0.c.n_item_pos:getPositionY() - 2)
	end
	
	return var_31_0
end

function ShopRandom.reqBuy(arg_32_0, arg_32_1)
	query("buy", {
		shop = "random",
		item = arg_32_1.id,
		npc = arg_32_0.npc,
		refresh_time = AccountData.rshop_tm,
		type = arg_32_1.type
	})
end

function ShopRandom.onPushBackButton(arg_33_0)
	if arg_33_0.npc == "lobby" then
		Lobby:toggleBartenderMode()
	else
		arg_33_0:exit()
	end
	
	BackButtonManager:pop("RandomShop")
end

function ShopRandom.rateInfoBar(arg_34_0, arg_34_1)
	local var_34_0 = load_control("wnd/gacha_info_header_bar.csb")
	
	var_34_0:setPosition(0, 20)
	
	for iter_34_0 = 1, 6 do
		if_set_visible(var_34_0, "n_item" .. iter_34_0, false)
	end
	
	local var_34_1 = 1
	
	for iter_34_1, iter_34_2 in pairs(arg_34_1) do
		local var_34_2 = var_34_0:getChildByName("n_item" .. var_34_1)
		
		if var_34_2 then
			if iter_34_2.type == "t" then
				if_set(var_34_2, "txt_name", T("shop_random_rate_token"))
			elseif iter_34_2.type == "e" then
				if_set(var_34_2, "txt_name", T("shop_random_rate_equip"))
			elseif iter_34_2.type == "c" then
				if_set(var_34_2, "txt_name", T("shop_random_rate_char"))
			end
			
			if_set(var_34_2, "txt_ratio", iter_34_2.rate .. "%")
			var_34_2:setVisible(true)
			
			var_34_1 = var_34_1 + 1
		end
	end
	
	if_set_visible(var_34_0, "txt_title", false)
	if_set_visible(var_34_0, "txt_random_shop", true)
	if_set(var_34_0, "txt_random_shop", T("shop_random_rate_info"))
	
	return var_34_0, var_34_1 - 1
end

function ShopRandom.rateInfoItem(arg_35_0, arg_35_1, arg_35_2, arg_35_3, arg_35_4, arg_35_5)
	local var_35_0 = 0
	
	for iter_35_0, iter_35_1 in pairs(arg_35_2) do
		local var_35_1
		
		if iter_35_1.type == "t" then
			var_35_1 = T("shop_random_rate_token")
		elseif string.starts(iter_35_1.type, "e") then
			local var_35_2 = string.split(iter_35_1.type, "_")
			
			var_35_1 = T("shop_random_equip_rate", {
				num = var_35_2[2],
				grade = T("item_grade_" .. var_35_2[3])
			})
		elseif iter_35_1.type == "c" then
			var_35_1 = T("shop_random_rate_char")
		end
		
		if var_35_1 then
			var_35_0 = var_35_0 + 1
			
			local var_35_3 = load_control("wnd/gacha_info_item_bar.csb")
			
			if_set_visible(var_35_3, "n_grade", true)
			if_set_visible(var_35_3, "txt_grade_ratio", true)
			if_set_visible(var_35_3, "n_item", false)
			if_set(var_35_3, "txt_grade_name", var_35_1)
			if_set(var_35_3, "txt_grade_ratio", (iter_35_1.rate or "-") .. "%")
			var_35_3:setPosition(arg_35_5, arg_35_4 - 25 * var_35_0)
			arg_35_1:addChild(var_35_3)
		end
		
		for iter_35_2, iter_35_3 in pairs(arg_35_3[iter_35_1.type]) do
			var_35_0 = var_35_0 + 1
			
			local var_35_4 = load_control("wnd/gacha_info_item_bar.csb")
			
			if_set_visible(var_35_4, "n_grade", false)
			if_set_visible(var_35_4, "n_item", true)
			
			if iter_35_1.type == "t" then
				if_set(var_35_4, "txt_item_name", T(DB("item_token", iter_35_3.id, "name")))
			elseif string.starts(iter_35_1.type, "e") then
				if_set(var_35_4, "txt_item_name", T(DB("equip_item", iter_35_3.id, "name")))
			elseif iter_35_1.type == "c" then
				if_set(var_35_4, "txt_item_name", T(DB("character", iter_35_3.id, "name")))
			end
			
			if_set(var_35_4, "txt_item_ratio", (iter_35_3.rate or "-") .. "%")
			var_35_4:setPosition(arg_35_5, arg_35_4 - 25 * var_35_0)
			arg_35_1:addChild(var_35_4)
		end
	end
	
	if var_35_0 < 25 then
		var_35_0 = 25
	end
	
	return 25 * var_35_0
end

function ShopRandom.showRandomShopRate(arg_36_0, arg_36_1)
	if arg_36_0.npc ~= "lobby" then
		return 
	end
	
	if not arg_36_0.vars then
		return 
	end
	
	if not arg_36_1 then
		query("random_shop_rate", {
			npc = arg_36_0.npc
		})
		
		return 
	end
	
	arg_36_0.vars.wnd_rate_info = load_dlg("gacha_info_special", true, "wnd")
	
	if_set(arg_36_0.vars.wnd_rate_info, "txt_title", T("shop_random_rate_title", {
		num = Account:getRandomShoplevel()
	}))
	
	local var_36_0 = arg_36_0.vars.wnd_rate_info:getChildByName("scrollview")
	
	var_36_0:setContentSize(350, 565)
	var_36_0:setInnerContainerSize({
		width = 350,
		height = 300
	})
	
	local var_36_1, var_36_2 = arg_36_0:rateInfoBar(arg_36_1.view_list_sum)
	
	var_36_1:setContentSize({
		width = 350,
		height = 200
	})
	var_36_0:addChild(var_36_1)
	
	local var_36_3 = var_36_1:getChildByName("bar")
	local var_36_4 = var_36_1:getChildByName("n_item" .. var_36_2):getPositionY() - 30
	
	var_36_3:setPositionY(var_36_4)
	
	local var_36_5 = var_36_0:getInnerContainerSize()
	local var_36_6 = table.count(arg_36_1.view_list_sub_sum)
	
	for iter_36_0, iter_36_1 in pairs(arg_36_1.view_list) do
		var_36_6 = var_36_6 + table.count(iter_36_1)
	end
	
	local var_36_7 = 25 * var_36_6 + var_36_2 * 40 + 110
	local var_36_8 = var_36_7 - (var_36_2 * 40 + 250)
	
	arg_36_0:rateInfoItem(var_36_0, arg_36_1.view_list_sub_sum, arg_36_1.view_list, var_36_7 - var_36_2 * 40 - 100, -15)
	var_36_1:setPosition(0, var_36_8)
	var_36_0:setInnerContainerSize({
		width = var_36_5.width,
		height = var_36_7
	})
	
	if arg_36_0.vars.wnd_rate_info then
		Dialog:msgBox(nil, {
			dlg = arg_36_0.vars.wnd_rate_info
		})
		SoundEngine:play("event:/ui/popup/tap")
	end
end

function ShopRandom.HelpbuttonPosition(arg_37_0)
	local var_37_0 = arg_37_0.wnd:getChildByName("txt_top_title")
	local var_37_1 = arg_37_0.wnd:getChildByName("btn_Help")
	
	if var_37_0 then
		local var_37_2 = var_37_0:getContentSize().width * var_37_0:getScaleX() + var_37_0:getPositionX()
		
		if var_37_1 then
			var_37_1:setPositionX(var_37_2 - 120)
		end
	end
end
