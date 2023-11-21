GachaPet = {}

function MsgHandler.gacha_pet(arg_1_0)
	GachaPet:open_petGachaResult(arg_1_0)
end

function MsgHandler.gacha_free(arg_2_0)
	GachaPet:open_petGachaResult(arg_2_0)
	GachaPet:close_petChoosePopup()
end

function MsgHandler.gacha_rate_pet(arg_3_0)
	GachaPet:showRateUI(nil, arg_3_0)
end

function HANDLER.gacha_pet(arg_4_0, arg_4_1)
	if arg_4_1 == "btn_recall" then
		GachaPet:req_gachaPet()
	elseif arg_4_1 == "btn_recall_10" then
		GachaPet:req_gachaPet({
			is_recall_10 = true
		})
	elseif arg_4_1 == "btn_close" then
		GachaPet:close_petGachaPopup()
	elseif arg_4_1 == "btn_Help" then
		HelpGuide:open({
			contents_id = "infopet"
		})
	elseif arg_4_1 == "btn_rate" then
		GachaPet:showRateUI()
	end
end

function HANDLER.gacha_info_pet(arg_5_0, arg_5_1)
	if arg_5_1 == "btn_close" then
		Dialog:close("gacha_info_pet")
	end
end

function HANDLER.gacha_pet_get(arg_6_0, arg_6_1)
	if arg_6_1 == "btn_recall" then
		GachaPet:close_petGachaResult()
		GachaPet:req_gachaPet()
	elseif arg_6_1 == "btn_close" then
		GachaPet:close_petGachaResult()
	end
end

function HANDLER.gacha_pet_10(arg_7_0, arg_7_1)
	if arg_7_1 == "btn_back" then
		GachaPet:close_petGachaResult()
	elseif arg_7_1 == "btn_summon_r1" then
		GachaPet:req_gachaPet({
			is_recall_10 = true
		})
	end
end

function HANDLER.gacha_pet_choose_card(arg_8_0, arg_8_1)
	if arg_8_1 == "btn_selection" then
		if arg_8_0.pet_info then
			GachaPet:showConfirmDialog(arg_8_0.pet_info)
		else
			Log.e("cont.pet_info is nill")
		end
	end
end

function HANDLER.gacha_pet_choose(arg_9_0, arg_9_1)
	if arg_9_1 == "btn_close" then
		GachaPet:close_petChoosePopup()
	end
end

function HANDLER.gacha_pet_choose_confirm(arg_10_0, arg_10_1)
	if arg_10_1 == "btn_confirm" then
		query("gacha_free", {
			code = GachaPet.tutorial_petID
		})
		GachaPet:closeConfirmDialog()
	elseif arg_10_1 == "btn_cancel" then
		GachaPet:closeConfirmDialog()
	end
end

function GachaPet.open_petGachaPopup(arg_11_0, arg_11_1)
	if arg_11_0.vars and get_cocos_refid(arg_11_0.vars.petGacha_popup) then
		arg_11_0.vars.petGacha_popup:removeFromParent()
		BackButtonManager:pop("gacha_pet")
	end
	
	if Account:checkPet_gachafree() then
		GachaPet:open_petChoosePopup(arg_11_1)
		
		return 
	end
	
	arg_11_0.vars = {}
	arg_11_1 = arg_11_1 or {}
	arg_11_0.vars.close_callback = arg_11_1.close_callback
	
	local var_11_0 = SceneManager:getRunningNativeScene()
	
	if not get_cocos_refid(arg_11_0.vars.petGacha_popup) then
		arg_11_0.vars.petGacha_popup = load_dlg("gacha_pet", nil, "wnd", function()
			GachaPet:close_petGachaPopup()
		end)
		
		var_11_0:addChild(arg_11_0.vars.petGacha_popup)
	end
	
	local var_11_1 = arg_11_0.vars.petGacha_popup:getChildByName("n_top")
	local var_11_2 = var_11_1:getChildByName("n_icon")
	local var_11_3 = arg_11_0.vars.petGacha_popup:getChildByName("btn_recall"):getChildByName("n_icon")
	local var_11_4 = arg_11_0.vars.petGacha_popup:getChildByName("btn_recall_10"):getChildByName("n_icon")
	
	if_set(var_11_1, "txt_count", Account:getCurrency("petticket"))
	UIUtil:getRewardIcon(nil, "to_petticket", {
		no_bg = true,
		parent = var_11_2
	})
	UIUtil:getRewardIcon(nil, "to_petticket", {
		no_bg = true,
		no_tooltip = true,
		parent = var_11_3
	})
	UIUtil:getRewardIcon(nil, "to_petticket", {
		no_bg = true,
		no_tooltip = true,
		parent = var_11_4
	})
	
	local var_11_5 = arg_11_0.vars.petGacha_popup:getChildByName("txt_title")
	
	if_call(arg_11_0.vars.petGacha_popup, "n_help", "setPositionX", 10 + var_11_5:getContentSize().width * var_11_5:getScaleX() + var_11_5:getPositionX())
	
	local var_11_6 = UIUtil:getPortraitAni("npc1111", {})
	local var_11_7 = Account:getCurrentPetGachaId()
	
	arg_11_0.vars.gacha_id = var_11_7
	
	local var_11_8 = PetUtil:getPatGachaEventTbl(var_11_7)
	
	if var_11_6 then
		if var_11_8 then
			arg_11_0.vars.petGacha_popup:getChildByName("n_pos_limited"):addChild(var_11_6)
			
			if var_11_8.npc_offset then
				local var_11_9 = string.split(var_11_8.npc_offset, ",")
				
				var_11_6:setPosition(var_11_6:getPositionX() + var_11_9[1], var_11_6:getPositionY() + var_11_9[2])
			end
		else
			arg_11_0.vars.petGacha_popup:getChildByName("n_pos"):addChild(var_11_6)
		end
		
		var_11_6:setName("@portrait")
	end
	
	if var_11_8 and var_11_8.main_pet then
		if_set_visible(arg_11_0.vars.petGacha_popup, "n_limited", true)
		if_set_visible(arg_11_0.vars.petGacha_popup, "n_pet_ani", true)
		arg_11_0.vars.petGacha_popup:getChildByName("n_pet_ani"):setVisible(true)
		
		local var_11_10 = var_11_8.main_pet
		local var_11_11 = string.split(var_11_10, ",")
		
		for iter_11_0 = 1, 2 do
			if var_11_11[iter_11_0] then
				local var_11_12 = CACHE:getModel(var_11_11[iter_11_0], nil, "idle", nil, nil)
				
				arg_11_0.vars.petGacha_popup:getChildByName("n_pos_" .. iter_11_0):addChild(var_11_12)
			end
		end
		
		local var_11_13 = arg_11_0.vars.petGacha_popup:getChildByName("n_balloon")
		
		if var_11_8.background then
			if_set_sprite(arg_11_0.vars.petGacha_popup, "pet_gacha_bg", "banner/" .. var_11_8.background .. ".png")
		end
		
		if var_11_8.npc_text then
			if_set(var_11_13, "txt_balloon", T(var_11_8.npc_text))
		end
		
		var_11_13:setVisible(true)
		var_11_13:setOpacity(0)
		UIAction:Add(LOOP(SEQ(FADE_IN(300), DELAY(3000), FADE_OUT(800), DELAY(5000))), var_11_13, "balloon")
	else
		arg_11_0.vars.petGacha_popup:getChildByName("n_pet_ani"):setVisible(false)
	end
	
	local var_11_14 = arg_11_0.vars.petGacha_popup:getChildByName("btn_Help")
	
	arg_11_0:updateFreeDailyGachaUI()
	Analytics:setPopup("gacha_pet")
end

function GachaPet.updateFreeDailyGachaUI(arg_13_0)
	if not get_cocos_refid(arg_13_0.vars.petGacha_popup) then
		return 
	end
	
	local var_13_0 = Account:getLimitCount("pet:gacha_daily_free")
	local var_13_1 = GAME_STATIC_VARIABLE.pet_gacha_limit_count or 1
	
	if_set_visible(arg_13_0.vars.petGacha_popup, "cm_free_tooltip", GachaPet:isFreeDailyGacha())
	if_set(arg_13_0.vars.petGacha_popup, "txt_free", T("pet_free_able", {
		curr = var_13_1 - var_13_0,
		max = var_13_1
	}))
	
	local var_13_2 = "1"
	
	if GachaPet:isFreeDailyGacha() then
		var_13_2 = T("shop_price_free")
	end
	
	local var_13_3 = arg_13_0.vars.petGacha_popup:getChildByName("btn_recall")
	
	if_set(var_13_3, "txt_cost", var_13_2)
	
	local var_13_4 = arg_13_0.vars.petGacha_popup:getChildByName("btn_recall_10")
	local var_13_5 = "10"
	
	if_set(var_13_4, "txt_cost", var_13_5)
end

function GachaPet.isFreeDailyGacha(arg_14_0)
	local var_14_0 = Account:getLimitCount("pet:gacha_daily_free")
	
	if (GAME_STATIC_VARIABLE.pet_gacha_limit_count or 1) - var_14_0 > 0 then
		return true
	end
	
	return false
end

function GachaPet.update_petGachaPopup(arg_15_0)
	if not get_cocos_refid(arg_15_0.vars.petGacha_popup) then
		return 
	end
	
	local var_15_0 = arg_15_0.vars.petGacha_popup:getChildByName("n_top")
	
	if_set(var_15_0, "txt_count", Account:getCurrency("petticket"))
end

function GachaPet.close_petGachaPopup(arg_16_0)
	if not arg_16_0.vars or not get_cocos_refid(arg_16_0.vars.petGacha_popup) then
		return 
	end
	
	BackButtonManager:pop("gacha_pet")
	arg_16_0.vars.petGacha_popup:removeFromParent()
	
	if arg_16_0.vars.close_callback then
		arg_16_0.vars.close_callback()
	end
	
	arg_16_0.vars = nil
	
	Analytics:closePopup()
end

function GachaPet.gachaRateInfoBar(arg_17_0, arg_17_1, arg_17_2)
	local var_17_0 = load_control("wnd/gacha_info_pet_header_bar.csb")
	
	var_17_0:setPosition(0, 20)
	
	for iter_17_0 = 1, 6 do
		if_set_visible(var_17_0, "n_item" .. iter_17_0, false)
	end
	
	local var_17_1 = {
		"d",
		"c",
		"b",
		"a",
		"s"
	}
	local var_17_2 = 1
	
	for iter_17_1, iter_17_2 in pairs(arg_17_2) do
		local var_17_3 = var_17_0:getChildByName("n_item" .. var_17_2)
		
		if var_17_3 then
			if iter_17_1 == "s_rate" then
				if_set(var_17_3, "txt_name", T("ui_pet_dic_special"))
				if_set(var_17_3, "txt_ratio", (iter_17_2 or "-") .. "%")
			elseif iter_17_1 == "n_rate" then
				if_set(var_17_3, "txt_name", T("ui_pet_dic_normal"))
				if_set(var_17_3, "txt_ratio", (iter_17_2 or "-") .. "%")
			elseif iter_17_2.id then
				local var_17_4 = to_n(string.split(iter_17_2.id, "_")[2])
				
				if var_17_1[var_17_4] then
					if_set(var_17_3, "txt_name", T("ui_pet_rate_skill_" .. var_17_1[var_17_4]))
					if_set(var_17_3, "txt_ratio", iter_17_2.rate .. "%")
				end
			end
			
			var_17_3:setVisible(true)
			
			var_17_2 = var_17_2 + 1
		end
	end
	
	if_set_visible(var_17_0, "txt_title", true)
	if_set_visible(var_17_0, "txt_random_shop", false)
	
	if arg_17_1 then
		if_set(var_17_0, "txt_title", T(arg_17_1))
	end
	
	return var_17_0, var_17_2 - 1
end

function GachaPet.showRateUI(arg_18_0, arg_18_1, arg_18_2)
	if not arg_18_0.vars then
		return 
	end
	
	if arg_18_2 then
		arg_18_0.vars.rate_info = arg_18_2
	else
		if not arg_18_0.vars.rate_info then
			query("gacha_rate_pet")
			
			return 
		end
		
		arg_18_2 = arg_18_0.vars.rate_info
	end
	
	arg_18_0.vars.wnd_gacha_rate_info = load_dlg("gacha_info_pet", true, "wnd")
	
	if_set(arg_18_0.vars.wnd_gacha_rate_info, "txt_title", T("ui_pet_rate_title"))
	if_set(arg_18_0.vars.wnd_gacha_rate_info, "txt_bottom", T("pet_rate_desc"))
	
	local var_18_0 = arg_18_0.vars.wnd_gacha_rate_info:getChildByName("scrollview")
	
	var_18_0:removeAllChildren()
	var_18_0:setVisible(true)
	var_18_0:setInnerContainerSize({
		width = 945,
		height = 300
	})
	
	local var_18_1, var_18_2 = arg_18_0:gachaRateInfoBar("ui_pet_rate_look", arg_18_2.view_list_sum)
	
	var_18_1:setContentSize({
		width = 465,
		height = 200
	})
	var_18_0:addChild(var_18_1)
	
	local var_18_3, var_18_4 = arg_18_0:gachaRateInfoBar("ui_pet_rate_skill", arg_18_2.skill_list_sum)
	
	var_18_3:setContentSize({
		width = 465,
		height = 200
	})
	var_18_0:addChild(var_18_3)
	
	local var_18_5 = math.max(var_18_2, var_18_4)
	local var_18_6 = var_18_1:getChildByName("bar")
	local var_18_7 = var_18_1:getChildByName("n_item" .. var_18_5):getPositionY() - 30
	
	var_18_6:setPositionY(var_18_7)
	
	local var_18_8 = var_18_3:getChildByName("bar")
	local var_18_9 = var_18_3:getChildByName("n_item" .. var_18_5):getPositionY() - 30
	
	var_18_8:setPositionY(var_18_9)
	
	local var_18_10 = table.count(arg_18_2.view_list)
	
	for iter_18_0, iter_18_1 in pairs(arg_18_2.view_list) do
		var_18_10 = var_18_10 + table.count(iter_18_1)
	end
	
	local var_18_11 = table.count(arg_18_2.skill_list)
	
	for iter_18_2, iter_18_3 in pairs(arg_18_2.skill_list) do
		var_18_11 = var_18_11 + table.count(iter_18_3)
	end
	
	local var_18_12 = 25 * math.max(var_18_10, var_18_11) + var_18_5 * 40 + 80
	local var_18_13 = var_18_12 - (var_18_5 * 40 + 160)
	
	var_18_1:setPosition(0, var_18_13)
	var_18_3:setPosition(480, var_18_13)
	arg_18_0:gachaRateInfoItem(var_18_0, arg_18_2.view_list, var_18_12 - var_18_5 * 40 - 60, 15)
	arg_18_0:gachaRateInfoItem(var_18_0, arg_18_2.skill_list, var_18_12 - var_18_5 * 40 - 60, 495)
	
	local var_18_14 = var_18_0:getInnerContainerSize()
	
	var_18_0:setInnerContainerSize({
		width = var_18_14.width,
		height = var_18_12
	})
	
	if arg_18_0.vars.wnd_gacha_rate_info then
		Dialog:msgBox(nil, {
			dlg = arg_18_0.vars.wnd_gacha_rate_info
		})
		SoundEngine:play("event:/ui/popup/tap")
	end
end

function GachaPet.gachaRateInfoItem(arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
	local var_19_0 = 0
	
	for iter_19_0, iter_19_1 in pairs(arg_19_2) do
		local var_19_1
		
		if iter_19_0 == "s_rate" then
			var_19_1 = T("ui_pet_dic_special")
		elseif iter_19_0 == "n_rate" then
			var_19_1 = T("ui_pet_dic_normal")
		elseif string.starts(iter_19_0, "sk_lobby_") then
			var_19_1 = T("pet_rate_lobby")
		elseif string.starts(iter_19_0, "sk_battle_1") then
			var_19_1 = T("pet_rate_battle")
		end
		
		if var_19_1 then
			var_19_0 = var_19_0 + 1
			
			local var_19_2 = load_control("wnd/gacha_info_pet_item_bar.csb")
			
			if_set_visible(var_19_2, "n_grade", true)
			if_set_visible(var_19_2, "txt_grade_ratio", false)
			if_set_visible(var_19_2, "n_item", false)
			if_set(var_19_2, "txt_grade_name", var_19_1)
			var_19_2:setPosition(arg_19_4, arg_19_3 - 25 * var_19_0)
			arg_19_1:addChild(var_19_2)
		end
		
		for iter_19_2, iter_19_3 in pairs(iter_19_1) do
			var_19_0 = var_19_0 + 1
			
			local var_19_3 = load_control("wnd/gacha_info_pet_item_bar.csb")
			
			if_set_visible(var_19_3, "n_grade", false)
			if_set_visible(var_19_3, "n_item", true)
			
			if iter_19_3.id and string.starts(iter_19_3.id, "psk") then
				local var_19_4 = var_19_3:getChildByName("txt_item_name")
				
				if var_19_4 then
					set_ellipsis_label(var_19_4, T(DB("pet_skill", iter_19_3.id, "name"), {
						value = ""
					}), 600, 2)
				end
			elseif iter_19_3.code and string.starts(iter_19_3.code, "pet") then
				if_set(var_19_3, "txt_item_name", T(DB("pet_character", iter_19_3.code, "name")))
			end
			
			if_set(var_19_3, "txt_item_ratio", (iter_19_3.rate or iter_19_3.ratio or "-") .. "%")
			var_19_3:setPosition(arg_19_4, arg_19_3 - 25 * var_19_0)
			arg_19_1:addChild(var_19_3)
		end
	end
	
	if var_19_0 < 25 then
		var_19_0 = 25
	end
	
	return 25 * var_19_0
end

function GachaPet.setSingleGachaPetUI(arg_20_0, arg_20_1, arg_20_2)
	arg_20_2 = arg_20_2 or {}
	
	local var_20_0 = arg_20_2.is_new
	local var_20_1 = arg_20_2.show_no_btn
	
	if arg_20_2.detail_popup then
		arg_20_0.vars.petGacha_resultPopup = nil
		arg_20_0.vars.petGacha_resultPopup = load_dlg("gacha_pet_get", true, "wnd")
	else
		if get_cocos_refid(arg_20_0.vars.petGacha_resultPopup) then
			arg_20_0:close_petGachaResult()
		end
		
		arg_20_0.vars.petGacha_resultPopup = load_dlg("gacha_pet_get", true, "wnd", function()
			arg_20_0:close_petGachaResult()
		end)
	end
	
	UIUtil:setPetPreviewInfoUI(arg_20_0.vars.petGacha_resultPopup, arg_20_1)
	
	local var_20_2 = T("pet_info_race", {
		race = T(arg_20_1:getRace())
	}) .. "\n" .. T("pet_info_personal", {
		personal = T(arg_20_1:getPersonality())
	}) .. "\n" .. T(arg_20_1:getDesc())
	
	if_set(arg_20_0.vars.petGacha_resultPopup, "txt_story", var_20_2)
	if_set(arg_20_0.vars.petGacha_resultPopup, "txt_cost", 1)
	SpriteCache:resetSprite(arg_20_0.vars.petGacha_resultPopup:getChildByName("icon_res"), "item/" .. AccountData.token_info.petticket.icon .. ".png")
	
	if var_20_0 then
		if_set_visible(arg_20_0.vars.petGacha_resultPopup, "n_gacha_new", true)
	else
		if_set_visible(arg_20_0.vars.petGacha_resultPopup, "n_gacha_new", false)
	end
	
	arg_20_0.vars.skill_wnds = {}
	
	local var_20_3 = false
	
	if_set_visible(arg_20_0.vars.petGacha_resultPopup, "n_no_btn", var_20_1)
	if_set_visible(arg_20_0.vars.petGacha_resultPopup, "n_recall", not var_20_1)
	
	if not var_20_1 then
		local var_20_4 = load_dlg("gacha_pet_get_item", nil, "wnd")
		
		arg_20_0.vars.petGacha_resultPopup:getChildByName("n_skill"):addChild(var_20_4)
		var_20_4:setPosition(0 + var_20_4:getContentSize().width / 2, 0 - var_20_4:getContentSize().height / 2)
		UIUtil:updatePetSkillItem(var_20_4, arg_20_1, 1)
		
		if arg_20_1:getSkillRank(1) >= 5 then
			var_20_3 = true
			var_20_4.effect = true
		end
		
		arg_20_0.vars.skill_wnds[1] = var_20_4
	else
		for iter_20_0 = 1, 3 do
			if not PetSkill:getValueByIdx(arg_20_1, iter_20_0) then
				break
			end
			
			local var_20_5 = load_dlg("gacha_pet_get_item", arg_20_2.no_eff, "wnd")
			
			arg_20_0.vars.petGacha_resultPopup:getChildByName("n_skill" .. iter_20_0):addChild(var_20_5)
			var_20_5:setPosition(0 + var_20_5:getContentSize().width / 2, 0 - var_20_5:getContentSize().height / 2)
			UIUtil:updatePetSkillItem(var_20_5, arg_20_1, iter_20_0)
			
			if arg_20_1:getSkillRank(iter_20_0) >= 5 then
				var_20_3 = true
				var_20_5.effect = true
			end
			
			arg_20_0.vars.skill_wnds[iter_20_0] = var_20_5
		end
	end
	
	arg_20_0:update_petGachaPopup()
	
	local var_20_6 = SceneManager:getRunningPopupScene()
	
	if not arg_20_2.detail_popup then
		var_20_6:addChild(arg_20_0.vars.petGacha_resultPopup)
		arg_20_0.vars.petGacha_resultPopup:setVisible(false)
	end
	
	if not arg_20_2.no_eff then
		local var_20_7
		local var_20_8
		local var_20_9 = 1350
		
		if arg_20_1:isFeature() then
			var_20_7 = "ui_pet_summon_moonlight.cfx"
			var_20_8 = "ui_pet_get_moonlight.cfx"
			
			SoundEngine:play("event:/ui/pet/ui_pet_get_moonlight")
		elseif var_20_3 then
			var_20_7 = "ui_pet_summon_special.cfx"
			var_20_8 = "ui_pet_get_spcial.cfx"
			
			SoundEngine:play("event:/ui/pet/ui_pet_get_spcial")
		else
			var_20_8 = "ui_pet_get_normal.cfx"
			var_20_9 = 0
		end
		
		UIAction:Add(SEQ(CALL(EffectManager.Play, EffectManager, var_20_7, var_20_6, DESIGN_WIDTH / 2, DESIGN_HEIGHT / 2, 99999), DELAY(var_20_9), FADE_IN(0), CALL(EffectManager.Play, EffectManager, var_20_8, arg_20_0.vars.petGacha_resultPopup, arg_20_0.vars.petGacha_resultPopup:getPositionX(), arg_20_0.vars.petGacha_resultPopup:getPositionY() - 15, 99999), DELAY(1000), CALL(arg_20_0.add_resultSubEffect, arg_20_0, arg_20_1)), arg_20_0.vars.petGacha_resultPopup, "block")
	end
	
	return arg_20_0.vars.petGacha_resultPopup
end

function GachaPet.setMultipleGachaPetUI(arg_22_0, arg_22_1, arg_22_2)
	if table.empty(arg_22_1) then
		return 
	end
	
	local var_22_0
	
	var_22_0 = arg_22_2 or {}
	
	if get_cocos_refid(arg_22_0.vars.petGacha_resultPopup) then
		arg_22_0:close_petGachaResult()
	end
	
	arg_22_0.vars.petGacha_resultPopup = load_dlg("gacha_pet_10", true, "wnd", function()
		arg_22_0:close_petGachaResult()
	end)
	
	local var_22_1 = Account:getCurrency("petticket") >= 10 and Account:getCurrentPetCount() >= #Account.pets + 10
	
	if var_22_1 then
		local var_22_2 = arg_22_0.vars.petGacha_resultPopup:getChildByName("n_balloon")
		
		if get_cocos_refid(var_22_2) then
			if tolua:type(var_22_2:getChildByName("txt")) ~= "ccui.RichText" then
				upgradeLabelToRichLabel(var_22_2, "txt", true)
			end
			
			if_set(var_22_2, "txt", T("ui_pet_gacha_continue"))
			
			local var_22_3 = var_22_2:findChildByName("talk_small_bg")
			local var_22_4 = var_22_2:getChildByName("txt")
			local var_22_5 = var_22_4:getTextBoxSize()
			
			var_22_5.width = var_22_5.width * var_22_4:getScaleX()
			var_22_5.height = var_22_5.height * var_22_4:getScaleY()
			
			local var_22_6 = var_22_3:getContentSize().width
			
			var_22_5.width = var_22_6 > var_22_5.width and var_22_5.width + 35 or var_22_6
			
			var_22_3:setContentSize({
				width = var_22_5.width,
				height = var_22_5.height + 30
			})
		end
	end
	
	if_set_visible(arg_22_0.vars.petGacha_resultPopup, "n_balloon", var_22_1)
	if_set(arg_22_0.vars.petGacha_resultPopup, "cost", 10)
	SpriteCache:resetSprite(arg_22_0.vars.petGacha_resultPopup:getChildByName("icon_res"), "item/" .. AccountData.token_info.petticket.icon .. ".png")
	
	local var_22_7 = arg_22_0.vars.petGacha_resultPopup:getChildByName("n_list")
	local var_22_8 = false
	local var_22_9 = false
	local var_22_10 = {}
	
	if get_cocos_refid(var_22_7) then
		for iter_22_0, iter_22_1 in pairs(arg_22_1) do
			local var_22_11 = iter_22_1.pet
			local var_22_12 = iter_22_1.is_new
			local var_22_13 = UIUtil:updatePetBar(nil, nil, var_22_11, {
				is_exist_preview = true,
				is_fix_skill = false,
				is_new = var_22_12
			})
			
			UIUtil:updatePetBarInfo(var_22_13, nil, var_22_11)
			
			local var_22_14 = var_22_7:getChildByName("n_pos" .. iter_22_0)
			
			table.insert(var_22_10, var_22_14)
			var_22_14:addChild(var_22_13)
			var_22_14:setVisible(false)
			
			local var_22_15 = var_22_11:isFeature()
			
			for iter_22_2 = 1, 3 do
				if not PetSkill:getValueByIdx(var_22_11, iter_22_2) then
					break
				end
				
				if not var_22_15 and var_22_11:getSkillRank(iter_22_2) >= 5 then
					var_22_14.is_high_grade = true
					var_22_8 = true
				end
			end
			
			if var_22_15 then
				var_22_14.is_feature = true
				var_22_9 = true
			end
		end
	end
	
	arg_22_0:update_petGachaPopup()
	
	local var_22_16 = SceneManager:getRunningPopupScene()
	
	var_22_16:addChild(arg_22_0.vars.petGacha_resultPopup)
	
	local var_22_17
	local var_22_18 = 1350
	
	if var_22_9 then
		var_22_17 = "ui_pet_summon_moonlight.cfx"
		
		SoundEngine:play("event:/ui/pet/ui_pet_get_moonlight")
	elseif var_22_8 then
		var_22_17 = "ui_pet_summon_special.cfx"
		
		SoundEngine:play("event:/ui/pet/ui_pet_get_spcial")
	else
		var_22_18 = 0
	end
	
	UIAction:Add(SEQ(CALL(EffectManager.Play, EffectManager, var_22_17, var_22_16, DESIGN_WIDTH / 2, DESIGN_HEIGHT / 2, 99999), DELAY(var_22_18), CALL(function()
		if var_22_18 > 0 then
			return 
		end
		
		SoundEngine:play("event:/effect/ui_pet_get_normal")
	end), CALL(arg_22_0.setEffectPlay, arg_22_0, var_22_10), DELAY(1000)), arg_22_0.vars.petGacha_resultPopup, "block")
end

function GachaPet.setEffectPlay(arg_25_0, arg_25_1)
	if not arg_25_0.vars or not get_cocos_refid(arg_25_0.vars.petGacha_resultPopup) or table.empty(arg_25_1) then
		return 
	end
	
	for iter_25_0, iter_25_1 in pairs(arg_25_1) do
		local var_25_0
		local var_25_1
		local var_25_2 = 1000
		
		if iter_25_1.is_feature then
			var_25_0 = "ui_pet_get_moonlight_10.cfx"
			var_25_1 = "ui_pet_get_moonlight_10_loop.cfx"
		elseif iter_25_1.is_high_grade then
			var_25_0 = "ui_pet_get_spcial_10.cfx"
			var_25_1 = "ui_pet_get_spcial_10_loop.cfx"
		else
			var_25_0 = "ui_pet_get_normal_10.cfx"
		end
		
		local var_25_3 = 0
		local var_25_4 = 0
		local var_25_5 = iter_25_1:getChildByName("item")
		
		if get_cocos_refid(var_25_5) then
			local var_25_6 = var_25_5:getChildByName("bg")
			local var_25_7 = var_25_6:getContentSize()
			local var_25_8 = var_25_7.width / 2 + 7.5 + var_25_6:getPositionX()
			local var_25_9 = var_25_7.height / 2 + 2.5 + var_25_6:getPositionY()
			
			UIAction:Add(SEQ(CALL(EffectManager.Play, EffectManager, var_25_0, var_25_5, var_25_8, var_25_9, 99999), FADE_IN(0), DELAY(var_25_2), CALL(EffectManager.Play, EffectManager, var_25_1, var_25_5, var_25_8, var_25_9, 99999)), iter_25_1, "block")
		end
	end
end

function GachaPet.open_petGachaResult(arg_26_0, arg_26_1, arg_26_2)
	local var_26_0 = arg_26_2 or {}
	
	if not arg_26_0.vars then
		arg_26_0.vars = {}
	end
	
	if not arg_26_1 or table.empty(arg_26_1.pets) then
		return 
	end
	
	local var_26_1 = false
	local var_26_2 = Account:getPetslot_gachafree()
	
	if arg_26_1.slot and var_26_2 ~= arg_26_1.slot.gacha_free then
		var_26_1 = true
		
		Account:setPetslot_gachafree(arg_26_1.slot.gacha_free)
		
		if not TutorialGuide:isClearedTutorial("pet_team") then
			TutorialGuide:_startGuideFromCallback("pet_team")
		end
	end
	
	if arg_26_1.result and arg_26_1.result.petticket then
		Account:addReward(arg_26_1.result)
	end
	
	ConditionContentsManager:dispatch("pet.gacha")
	
	if arg_26_1.limits then
		Account:updateLimits(arg_26_1.limits)
	end
	
	if table.count(arg_26_1.pets) == 1 then
		local var_26_3 = arg_26_1.pets[1]
		local var_26_4, var_26_5 = Account:addPet(var_26_3, var_26_3.code)
		
		var_26_0.is_new = var_26_5
		var_26_0.show_no_btn = var_26_1
		
		arg_26_0:setSingleGachaPetUI(var_26_4, var_26_0)
		PetHouse:updateFreeDailyGachaNoti()
	else
		local var_26_6 = {}
		
		for iter_26_0, iter_26_1 in pairs(arg_26_1.pets) do
			local var_26_7, var_26_8 = Account:addPet(iter_26_1, iter_26_1.code)
			local var_26_9 = {
				pet = var_26_7,
				is_new = var_26_8
			}
			
			table.insert(var_26_6, var_26_9)
		end
		
		arg_26_0:setMultipleGachaPetUI(var_26_6)
	end
	
	arg_26_0:updateFreeDailyGachaUI()
end

function GachaPet.showRewardResult(arg_27_0, arg_27_1, arg_27_2)
	if not arg_27_0.vars then
		arg_27_0.vars = {}
	end
	
	return arg_27_0:setSingleGachaPetUI(arg_27_1, arg_27_2)
end

function GachaPet.add_resultSubEffect(arg_28_0, arg_28_1)
	if not arg_28_1 then
		return 
	end
	
	local var_28_0 = "ui_pet_shine_loop.cfx"
	local var_28_1 = "ui_pet_rank.cfx"
	
	if arg_28_1:isFeature() then
		EffectManager:Play({
			z = 99999,
			y = 0,
			x = 0,
			fn = var_28_0,
			layer = arg_28_0.vars.petGacha_resultPopup:getChildByName("n_pos")
		})
	end
	
	for iter_28_0 = 1, #arg_28_0.vars.skill_wnds do
		if arg_28_0.vars.skill_wnds[iter_28_0].effect then
			local var_28_2 = arg_28_0.vars.skill_wnds[iter_28_0]:getChildByName("grade_icon")
			
			EffectManager:Play({
				z = 99999,
				y = 0,
				x = 0,
				fn = var_28_1,
				layer = var_28_2
			})
		end
	end
end

function GachaPet.open_petChoosePopup(arg_29_0, arg_29_1)
	if arg_29_0.vars and get_cocos_refid(arg_29_0.vars.petchoose_wnd) then
		arg_29_0.vars.petchoose_wnd:removeFromParent()
		BackButtonManager:pop("gacha_pet_choose")
	end
	
	arg_29_0.vars = {}
	arg_29_1 = arg_29_1 or {}
	arg_29_0.vars.close_callback = arg_29_1.close_callback
	
	if not Account:checkPet_gachafree() then
		Log.e("이미 무료 소환 진행했음")
		
		return 
	end
	
	TutorialGuide:procGuide()
	
	arg_29_0.vars.petchoose_wnd = load_dlg("gacha_pet_choose", nil, "wnd", function()
		GachaPet:close_petChoosePopup()
	end)
	
	SceneManager:getRunningNativeScene():addChild(arg_29_0.vars.petchoose_wnd)
	
	local var_29_0 = {}
	local var_29_1 = 3
	
	for iter_29_0 = 1, 99 do
		local var_29_2, var_29_3, var_29_4, var_29_5, var_29_6, var_29_7, var_29_8 = DBN("pet_character", iter_29_0, {
			"id",
			"name",
			"desc",
			"type",
			"grade",
			"model_3",
			"tutorial"
		})
		
		if not var_29_2 then
			break
		end
		
		if var_29_8 then
			local var_29_9 = {
				id = var_29_2,
				name = var_29_3,
				desc = var_29_4,
				type = var_29_5,
				grade = var_29_1,
				model_3 = var_29_7,
				tutorial = var_29_8
			}
			
			table.insert(var_29_0, var_29_9)
		end
	end
	
	local var_29_10 = 1
	
	for iter_29_1 = 1, 3 do
		local var_29_11 = load_dlg("gacha_pet_choose_card", nil, "wnd")
		local var_29_12 = arg_29_0.vars.petchoose_wnd:getChildByName("n_card" .. var_29_10)
		local var_29_13 = var_29_0[iter_29_1]
		
		if not var_29_12 or not var_29_13 then
			break
		end
		
		local var_29_14 = "img/cm_icon_role_pet_" .. var_29_13.type .. ".png"
		
		SpriteCache:resetSprite(var_29_11:getChildByName("role"), var_29_14)
		
		local var_29_15 = {
			lobby = "pet_type_lobby",
			battle = "pet_type_battle"
		}
		
		if_set(var_29_11, "txt_role", T(var_29_15[var_29_13.type]))
		if_set(var_29_11, "txt_name", T(var_29_13.name))
		if_set(var_29_11, "txt_story", T(var_29_13.desc))
		
		for iter_29_2 = 1, 6 do
			if_set_visible(var_29_11, "star" .. iter_29_2, iter_29_2 <= var_29_1)
		end
		
		if_call(var_29_11, "star1", "setPositionX", 10 + var_29_11:getChildByName("txt_name"):getContentSize().width * var_29_11:getChildByName("txt_name"):getScaleX() + var_29_11:getChildByName("txt_name"):getPositionX())
		
		local var_29_16 = CACHE:getModel(var_29_13.model_3, nil, "idle", nil, nil)
		
		var_29_11:getChildByName("n_pos"):addChild(var_29_16)
		
		var_29_11:getChildByName("btn_selection").pet_info = var_29_13
		
		var_29_11:setAnchorPoint(0, 0)
		var_29_11:setPosition(0, 0)
		var_29_12:addChild(var_29_11)
		
		var_29_10 = var_29_10 + 1
	end
end

function GachaPet.req_gachaPet(arg_31_0, arg_31_1)
	if not arg_31_0.vars then
		return 
	end
	
	local var_31_0 = arg_31_1 or {}
	
	if arg_31_0.vars.gacha_id and arg_31_0.vars.gacha_id ~= Account:getCurrentPetGachaId() then
		Dialog:msgBox(T("next_change_pet_gacha"), {
			handler = function()
				GachaPet:close_petGachaPopup()
			end
		})
		
		return 
	end
	
	local var_31_1 = Account:getCurrentPetCount()
	local var_31_2
	local var_31_3 = var_31_0.is_recall_10 and 10 or 1
	
	if var_31_1 < #Account.pets + var_31_3 then
		balloon_message_with_sound("too_many_pet")
		
		return 
	elseif not var_31_0.is_recall_10 and arg_31_0:isFreeDailyGacha() then
		query("gacha_pet", {
			daily_free = true
		})
		
		return 
	elseif var_31_3 > Account:getCurrency("petticket") then
		local function var_31_4()
			query("market_pet")
		end
		
		local var_31_5 = load_dlg("shop_nocurrency", true, "wnd")
		
		UIUtil:getRewardIcon(nil, "to_petticket", {
			no_bg = true,
			show_name = true,
			detail = true,
			parent = var_31_5:getChildByName("n_item_pos")
		})
		Dialog:msgBox(T("ui_pet_summon_now_desc", {
			token = T("to_petticket_name")
		}), {
			yesno = true,
			dlg = var_31_5,
			handler = var_31_4,
			title = T("ui_pet_summon_now_title"),
			txt_shop_comment = T("shop_nocurrency")
		})
		
		return 
	else
		query("gacha_pet", {
			gc = var_31_3
		})
	end
end

function GachaPet.showConfirmDialog(arg_34_0, arg_34_1)
	if get_cocos_refid(arg_34_0.vars.confirm_dlg) then
		return 
	end
	
	arg_34_0.vars.confirm_dlg = load_dlg("gacha_pet_choose_confirm", nil, "wnd", function()
		GachaPet:closeConfirmDialog()
	end)
	
	SceneManager:getRunningNativeScene():addChild(arg_34_0.vars.confirm_dlg)
	
	arg_34_0.tutorial_petID = arg_34_1.id
	
	local var_34_0 = arg_34_0.vars.confirm_dlg:getChildByName("n_pet_icon")
	
	UIUtil:getRewardIcon(nil, arg_34_1.id, {
		lv = 20,
		parent = var_34_0,
		grade = arg_34_1.grade
	})
	if_set(arg_34_0.vars.confirm_dlg, "txt_name", T(arg_34_1.name))
end

function GachaPet.closeConfirmDialog(arg_36_0)
	if not get_cocos_refid(arg_36_0.vars.confirm_dlg) then
		return 
	end
	
	BackButtonManager:pop("gacha_pet_choose_confirm")
	arg_36_0.vars.confirm_dlg:removeFromParent()
	
	arg_36_0.vars.confirm_dlg = nil
end

function GachaPet.close_petChoosePopup(arg_37_0)
	if not get_cocos_refid(arg_37_0.vars.petchoose_wnd) then
		return 
	end
	
	BackButtonManager:pop("gacha_pet_choose")
	
	if arg_37_0.vars.close_callback then
		arg_37_0.vars.close_callback()
	end
	
	arg_37_0.vars.petchoose_wnd:removeFromParent()
	
	arg_37_0.vars.petchoose_wnd = nil
end

function GachaPet.close_petGachaResult(arg_38_0)
	if not arg_38_0.vars or not get_cocos_refid(arg_38_0.vars.petGacha_resultPopup) then
		return 
	end
	
	local var_38_0 = arg_38_0.vars.petGacha_resultPopup:getName()
	
	BackButtonManager:pop(var_38_0)
	arg_38_0.vars.petGacha_resultPopup:removeFromParent()
	
	arg_38_0.vars.petGacha_resultPopup = nil
end

function GachaPet.release(arg_39_0, arg_39_1)
	SceneManager:popScene()
end

function GachaPet.show(arg_40_0)
	PetUIBase:onEnter()
	arg_40_0:procNextMode()
end
