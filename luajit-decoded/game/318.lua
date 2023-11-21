GachaIntroduceBG = {}

function GachaIntroduceBG.close(arg_1_0, arg_1_1)
	if arg_1_0._active and arg_1_0._active.close and not arg_1_1 then
		arg_1_0._active:close()
		
		arg_1_0._active = nil
	end
	
	arg_1_0:closeActions()
	arg_1_0.BG:close()
end

function GachaIntroduceBG.closeActions(arg_2_0)
	UIAction:Remove("gacha_bg.next_skill")
	UIAction:Remove("gibg_skill.active_check")
	UIAction:Remove("gibg_skill")
end

function GachaIntroduceBG.closeSound(arg_3_0)
	GachaIntroduceBG.Util:setSilent()
	GachaIntroduceBG.Util:setVolume()
end

function GachaIntroduceBG.closeWithSound(arg_4_0, arg_4_1)
	arg_4_0:close(arg_4_1)
	arg_4_0:closeSound()
end

function GachaIntroduceBG.setup(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	if GachaIntroduceBG.Util:checkNotValid() then
		print("REJECT!!!!!")
		
		return 
	end
	
	if not arg_5_0.DB:isActive() then
		arg_5_0.DB:init()
	end
	
	arg_5_0:close()
	GachaIntroduceBG.Util:setSilent()
	
	if not arg_5_0.scheduler or arg_5_0.scheduler.removed then
		arg_5_0.scheduler = Scheduler:add(arg_5_2, function()
			if not get_cocos_refid(arg_5_2) then
				return 
			end
			
			if arg_5_2:getTimeScale() < 0.01 then
				return 
			end
			
			if CharPreviewViewer:isActive() then
				CameraManager:update()
				BattleField:update()
			end
		end)
	end
	
	if arg_5_1 == "pickup" then
		arg_5_0.PickUp:setup(arg_5_2, arg_5_3.nb, arg_5_3.pickup_id, arg_5_3.pickup_data, arg_5_3.gacha_shop_info)
		
		arg_5_0._active = arg_5_0.PickUp
	elseif arg_5_1 == "normal" then
		arg_5_0.Normal:setup(arg_5_2, arg_5_3.nb, arg_5_3.gacha_id, arg_5_3.pickup_char_list, arg_5_3.detail_mode)
		
		arg_5_0._active = arg_5_0.Normal
	elseif arg_5_1 == "substory" then
		arg_5_0.SubStory:setup(arg_5_2, arg_5_3.nb, arg_5_3.gacha_substory, arg_5_3.gacha_data, arg_5_3.pickup_data, arg_5_3.gacha_shop_info, arg_5_3.select_mode)
		
		arg_5_0._active = arg_5_0.SubStory
	elseif arg_5_1 == "story" then
		arg_5_0.Story:setup(arg_5_2, arg_5_3.nb, arg_5_3.story_id, arg_5_3.gacha_shop_info, arg_5_3.gacha_story, arg_5_3.db_gs_ui)
		
		arg_5_0._active = arg_5_0.Story
	elseif arg_5_1 == "start" then
		if not arg_5_0.Start:setup(arg_5_2, arg_5_3.nb, arg_5_3.gacha_shop_info) then
			return 
		end
		
		arg_5_0._active = arg_5_0.Start
	elseif arg_5_1 == "special" then
		arg_5_0.Special:setup(arg_5_2, arg_5_3.nb, arg_5_3.sp_info, arg_5_3.gacha_special, arg_5_3.character_pool)
		
		arg_5_0._active = arg_5_0.Special
	elseif arg_5_1 == "customSpecial" then
		arg_5_0.CustomSpecial:setup(arg_5_2, arg_5_3.nb, arg_5_3.pickup_data, arg_5_3.gacha_shop_info)
		
		arg_5_0._active = arg_5_0.CustomSpecial
	elseif arg_5_1 == "customGroup" then
		arg_5_0.CustomGroup:setup(arg_5_2, arg_5_3.nb, arg_5_3.pickup_data, arg_5_3.gacha_shop_info)
		
		arg_5_0._active = arg_5_0.CustomGroup
	end
	
	arg_5_0._last_mode = arg_5_1
end

function GachaIntroduceBG.onBeforeDraw(arg_7_0)
	if arg_7_0._active and arg_7_0._active.onBeforeDraw then
		arg_7_0._active:onBeforeDraw()
	end
end

GachaIntroduceBG.DB = {}
GachaIntroduceBG.DB.TEST_DB = false

function GachaIntroduceBG.DB.get(arg_8_0, arg_8_1)
	if arg_8_0.data then
		return arg_8_0.data[arg_8_1]
	end
end

function GachaIntroduceBG.DB.isExistCharID(arg_9_0, arg_9_1)
	if arg_9_0.TEST_DB then
		return true
	end
end

function GachaIntroduceBG.DB.getByCharID(arg_10_0, arg_10_1)
	print("CCCCC")
	
	if arg_10_0.data and arg_10_0.char_id_to_id[arg_10_1] then
		local var_10_0 = arg_10_0.char_id_to_id[arg_10_1]
		
		return arg_10_0.data[var_10_0]
	end
	
	if arg_10_0.TEST_DB then
		Log.e("DEBUG DB CREATED")
		print("char_id?", arg_10_1)
		
		return {
			intro_time = 1,
			back2 = "m0001",
			back3 = "m0002",
			front1 = "m0003",
			info_time = 1,
			target_slot_number = "back1",
			front2 = "m0004",
			info_back_img = "gacha/gacha_intro_info_back",
			stage_bg = "forest",
			front3 = "m0005",
			back1 = "m0251",
			id = "NO_THANKS_THIS_IS_DEBUG",
			char_id = arg_10_1
		}
	end
end

function GachaIntroduceBG.DB.addDebugData(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, arg_11_6, arg_11_7, arg_11_8, arg_11_9, arg_11_10, arg_11_11, arg_11_12, arg_11_13)
	local var_11_0 = {
		id = arg_11_1,
		char_id = arg_11_2,
		stage_bg = arg_11_3,
		target_slot_number = arg_11_4,
		intro_time = arg_11_5,
		info_time = arg_11_6,
		info_back_img = arg_11_7,
		back1 = arg_11_8 or "",
		back2 = arg_11_9 or "",
		back3 = arg_11_10 or "",
		front1 = arg_11_11 or "",
		front2 = arg_11_12 or "",
		front3 = arg_11_13 or ""
	}
	
	arg_11_0.data[arg_11_1] = var_11_0
	arg_11_0.char_id_to_id[arg_11_2] = arg_11_1
end

function GachaIntroduceBG.DB.isActive(arg_12_0)
	return arg_12_0.data ~= nil
end

function GachaIntroduceBG.DB.loadDB(arg_13_0)
	for iter_13_0 = 1, 999 do
		local var_13_0 = DBN("char_intro_gacha", iter_13_0, {
			"id"
		})
		
		if not var_13_0 then
			break
		end
		
		local var_13_1 = SLOW_DB_ALL("char_intro_gacha", var_13_0)
		
		var_13_1.char_id = var_13_1.char_id or var_13_1.charID
		arg_13_0.data[var_13_0] = var_13_1
		arg_13_0.char_id_to_id[var_13_1.char_id] = var_13_0
	end
end

function GachaIntroduceBG.DB.init(arg_14_0)
	arg_14_0.data = {}
	arg_14_0.char_id_to_id = {}
	
	if arg_14_0.TEST_DB then
		arg_14_0:addDebugData("intro_c1002", "c1002", "sanctum1", "back1", 1, 1, "gacha/gacha_intro_info_back", "m9201")
		arg_14_0:addDebugData("intro_c1100", "c1100", "lom_seal", "back1", 1, 1, "gacha/gacha_intro_info_back", "m9201")
		arg_14_0:addDebugData("intro_c1066", "c1066", "valley4", "back1", 1, 1, "gacha/gacha_intro_info_back", "m9201")
		arg_14_0:addDebugData("intro_c2019", "c2019", "aespa1", "back1", 1, 1, "gacha/gacha_intro_info_back", "m9201")
		arg_14_0:addDebugData("intro_c2062", "c2062", "forest", "back1", 1, 1, "gacha/gacha_intro_info_back", "m9201")
		arg_14_0:addDebugData("intro_c1062", "c1062", "grw_grassland2", "back1", 1, 1, "gacha/gacha_intro_info_back", "m9201")
		arg_14_0:addDebugData("intro_c1016", "c1016", "stream", "back1", 1, 1, "gacha/gacha_intro_info_back", "m9201")
		arg_14_0:addDebugData("intro_c2065", "c2065", "desert4", "back1", 1, 1, "gacha/gacha_intro_info_back", "m9201")
		arg_14_0:addDebugData("intro_c2099", "c2099", "poe_alert", "back1", 1, 1, "gacha/gacha_intro_info_back", "m9201")
	end
	
	arg_14_0:loadDB()
end

GachaIntroduceBG.Util = {}

function GachaIntroduceBG.Util.checkNotValid(arg_15_0)
	return TransitionScreen:isShow() and SceneManager:getNextSceneName() ~= "gacha_unit"
end

function GachaIntroduceBG.Util.createPoolFromRawList(arg_16_0, arg_16_1)
	local var_16_0 = {}
	
	for iter_16_0, iter_16_1 in pairs(arg_16_1) do
		if GachaIntroduceBG.DB:isExistCharID(iter_16_1.id) then
			table.insert(var_16_0, iter_16_1.id)
		end
	end
	
	local var_16_1 = {}
	
	for iter_16_2 = 1, 10 do
		if #var_16_0 <= 0 then
			break
		end
		
		local var_16_2 = math.random(1, #var_16_0)
		
		table.insert(var_16_1, var_16_0[var_16_2])
		table.remove(var_16_0, var_16_2)
	end
	
	return var_16_1
end

function GachaIntroduceBG.Util.getCharData(arg_17_0, arg_17_1)
	return {
		desc = "테스트테스트테스트",
		info_back_img = "pow_plaza",
		code = arg_17_1,
		name = DB("character", arg_17_1, "name")
	}
end

function GachaIntroduceBG.Util.usePortraitRenderTextureMode(arg_18_0, arg_18_1, arg_18_2)
	local var_18_0 = cc.RenderTexture:create(2048, 2048, cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888)
	
	var_18_0:clear(0, 0, 0, 255)
	var_18_0:setPosition(0, 0)
	
	local var_18_1 = cc.Node:create()
	
	var_18_1:addChild(arg_18_1)
	var_18_0:addChild(var_18_1)
	var_18_1:setVisible(false)
	arg_18_1:setPosition(0, 0)
	var_18_0:setCascadeOpacityEnabled(true)
	arg_18_2:addChild(var_18_0)
	arg_18_2:setVisible(true)
	
	return var_18_0, arg_18_1
end

function GachaIntroduceBG.Util.setupPickupDataUI(arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
	local var_19_0 = arg_19_1.gacha_id
	local var_19_1
	local var_19_2
	local var_19_3
	
	if var_19_0 then
		var_19_1, var_19_2, var_19_3 = DB("gacha_ui", var_19_0, {
			"background",
			"bi_banner",
			"info_txt"
		})
	end
	
	if var_19_1 then
		local var_19_4 = cc.Sprite:create("banner/" .. arg_19_1.background .. ".png")
		
		if var_19_4 then
			local var_19_5 = arg_19_2:getChildByName("n_bg")
			
			var_19_5:removeAllChildren()
			
			if var_19_5 then
				var_19_5:addChild(var_19_4)
			end
		end
	end
	
	if not var_19_2 then
		Log.e("Not exist bi_banner. use default. check gacha_ui bi_banner column.")
		
		var_19_2 = arg_19_3
	end
	
	if var_19_2 then
		if_set_sprite(arg_19_2, "bi", "banner/" .. var_19_2 .. ".png")
	end
	
	if not var_19_3 then
		Log.e("Not exist bi_info_txt. use default. check gacha_ui bi_info_txt column.")
		
		var_19_3 = arg_19_4
	end
	
	if var_19_3 then
		if_set_sprite(arg_19_2, "info_txt", "banner/" .. var_19_3 .. ".png")
	end
end

function GachaIntroduceBG.Util.setupCurrentCharacterToOpeningUI(arg_20_0, arg_20_1, arg_20_2)
	local var_20_0 = arg_20_2
	local var_20_1 = GachaIntroduceBG.Util:getCharData(var_20_0)
	local var_20_2 = UNIT:create({
		code = var_20_0
	})
	local var_20_3 = DB("character", var_20_0, "face_id")
	local var_20_4 = arg_20_1:findChildByName("n_pos1")
	local var_20_5
	local var_20_6
	local var_20_7 = UIUtil:getPortraitAni(var_20_3)
	
	var_20_4:removeAllChildren()
	
	local var_20_8 = false
	
	if var_20_8 then
		var_20_5, var_20_6 = arg_20_0:usePortraitRenderTextureMode(var_20_7, var_20_4)
	else
		var_20_4:addChild(var_20_7)
		
		local var_20_9, var_20_10 = var_20_7:getRawBonePosition("ui_face")
		local var_20_11 = var_20_7:getRealScaleX()
		local var_20_12 = var_20_7:getRealScaleY()
		local var_20_13 = 0
		local var_20_14 = 0
		
		var_20_7:setPosition(var_20_13 - var_20_9 * var_20_11, var_20_14 - var_20_10 * var_20_12)
	end
	
	local var_20_15 = arg_20_1:getChildByName("icon_role") or arg_20_1:getChildByName("role")
	
	var_20_15:setName("role")
	UIUtil:setUnitAllInfo(arg_20_1, var_20_2, {
		ignore_stat_diff = true,
		is_txt_node_children = true,
		no_repos_sphere = true,
		use_basic_star = true
	})
	
	local var_20_16 = arg_20_1:getChildByName("LEFT")
	local var_20_17 = DB("character", var_20_0, "grade")
	
	for iter_20_0 = 1, 5 do
		if_set_visible(arg_20_1, "star" .. iter_20_0, iter_20_0 <= var_20_17)
	end
	
	if_set(arg_20_1, "txt_cha", var_20_2:getName())
	
	local var_20_18 = arg_20_1:findChildByName("n_info")
	local var_20_19 = arg_20_1:getChildByName("txt_role")
	local var_20_20 = arg_20_1:getChildByName("color")
	local var_20_21 = arg_20_1:getChildByName("txt_color")
	
	var_20_19:setAnchorPoint(0, 0.5)
	var_20_21:setAnchorPoint(0, 0.5)
	
	local var_20_22 = var_20_19:getContentSize().width
	local var_20_23 = var_20_20:getContentSize().width
	local var_20_24 = 15 * (5 - var_20_17)
	local var_20_25 = arg_20_1:findChildByName("n_star")
	
	if not var_20_25._origin_x then
		var_20_25._origin_x = var_20_25:getPositionX()
	end
	
	local var_20_26 = var_20_15:getContentSize()
	local var_20_27 = var_20_15:getPositionX()
	
	var_20_19:setPositionX(var_20_26.width / 2 + var_20_27)
	
	local var_20_28 = var_20_19:getContentSize()
	local var_20_29 = var_20_19:getPositionX()
	
	var_20_20:setPositionX(var_20_19:getPositionX() + var_20_22 + 17)
	var_20_21:setPositionX(var_20_20:getPositionX() + var_20_23 / 2)
	
	local var_20_30 = 264
	local var_20_31 = 20
	
	var_20_25:setPositionX(var_20_21:getContentSize().width + var_20_21:getPositionX() - var_20_30 + var_20_31)
	
	local var_20_32 = (var_20_17 - 3) * 12
	
	var_20_18:setPositionX(math.min((arg_20_0.txt_role_origin_size.width - var_20_22) / 2 - 66 - var_20_32, 0))
	
	local var_20_33 = UnitInfosUtil:getCharacterVoiceName(var_20_0)
	
	if_set_visible(arg_20_1, "t_cv", var_20_33)
	if_set(arg_20_1, "t_cv", var_20_33)
	
	local var_20_34 = arg_20_1:findChildByName("n_bg")
	
	var_20_34:setPosition(0, 0)
	var_20_34:removeAllChildren()
	
	return var_20_5, var_20_6
end

function GachaIntroduceBG.Util.createOpeningUI(arg_21_0)
	local var_21_0 = load_dlg("gacha_ending", true, "wnd")
	
	var_21_0:setPosition(0, 0)
	var_21_0:setOpacity(0)
	
	local var_21_1 = var_21_0:getChildByName("txt_role")
	
	if not arg_21_0.txt_role_origin_size then
		arg_21_0.txt_role_origin_size = var_21_1:getContentSize()
	end
	
	return var_21_0
end

function GachaIntroduceBG.Util.settingBIInfo(arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5, arg_22_6)
	local var_22_0 = SpriteCache:getSprite("banner/" .. arg_22_3 .. ".png")
	local var_22_1 = arg_22_2:getChildByName("n_bg")
	
	if var_22_1 then
		if arg_22_6 == "gacha_rare" then
			local var_22_2 = arg_22_2:getChildByName("n_bg")
			
			var_22_2:removeAllChildren()
			EffectManager:Play({
				fn = "uieff_gacha_bg_eff_b.cfx",
				layer = var_22_2
			}):setPositionX(-125)
		else
			var_22_1:addChild(var_22_0)
		end
	end
	
	if_set_sprite(arg_22_1, "bi", "banner/" .. arg_22_4 .. ".png")
	
	if arg_22_5 then
		if_set_sprite(arg_22_1, "info_txt", "banner/" .. arg_22_5 .. ".png")
	end
	
	if_set_visible(arg_22_1, "info_txt", arg_22_5 ~= nil)
end

function GachaIntroduceBG.Util.startBGOnBI(arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5, arg_23_6, arg_23_7, arg_23_8)
	local var_23_0 = arg_23_2:getLocalZOrder()
	
	arg_23_2:setOpacity(0)
	
	if not arg_23_1._dim then
		arg_23_1._dim = cc.LayerColor:create(cc.c4b(0, 0, 0, 255))
		
		arg_23_1._dim:setContentSize(VIEW_WIDTH, VIEW_HEIGHT)
		arg_23_1._dim:setPositionX(VIEW_BASE_LEFT)
		arg_23_1._dim:setOpacity(0)
		arg_23_1._dim:setLocalZOrder(-1)
		arg_23_1:setLocalZOrder(-2)
		arg_23_1:getParent():addChild(arg_23_1._dim)
		NotchManager:addListener(arg_23_1._dim, nil, function(arg_24_0, arg_24_1, arg_24_2)
			arg_23_1._dim:setContentSize(VIEW_WIDTH, VIEW_HEIGHT)
			arg_23_1._dim:setPositionX(VIEW_BASE_LEFT)
		end)
	end
	
	local var_23_1 = TARGET(arg_23_1, SHOW(true))
	
	if arg_23_8 then
		var_23_1 = SEQ(TARGET(arg_23_1._dim, FADE_IN(500)), TARGET(arg_23_1, SHOW(true)), TARGET(arg_23_1._dim, FADE_OUT(500)))
	end
	
	UIAction:Add(SEQ(var_23_1, DELAY(arg_23_6), CALL(function()
		GachaIntroduceBG.BG:close()
		GachaIntroduceBG.BG:begin(arg_23_3, arg_23_4, var_23_0 - 1, function()
			local var_26_0 = GachaIntroduceBG.BG:getLayer()
			local var_26_1 = "FieldFloorLayer"
			local var_26_2 = var_26_0:getChildByName(var_26_1)
			
			UIAction:Add(SEQ(SPAWN(TARGET(var_26_2, FADE_OUT(arg_23_5)), TARGET(arg_23_2, FADE_IN(arg_23_5)), CALL(function()
				SoundEngine:play("event:/ui/new_hero/hero_appearance_end")
			end)), DELAY(3000), TARGET(arg_23_1._dim, FADE_IN(500)), CALL(function()
				BattleAction:RemoveAll()
				arg_23_7()
			end), DELAY(500), TARGET(arg_23_1._dim, FADE_OUT(500))), arg_23_3, "gacha_bg.next_skill")
		end)
	end), DELAY(500), CALL(function()
		GachaIntroduceBG.BG:startSkillBySelfData()
	end), TARGET(arg_23_1._dim, FADE_IN(500)), TARGET(arg_23_1, SHOW(false)), TARGET(arg_23_1._dim, RLOG(FADE_OUT(500)))), arg_23_3, "gacha_bg.next_skill")
end

function GachaIntroduceBG.Util.defaultImplNextPickup(arg_30_0, arg_30_1, arg_30_2, arg_30_3, arg_30_4)
	local var_30_0 = table.count(arg_30_1.vars.pickup_char_list)
	local var_30_1 = arg_30_1.vars.pickup_char_list_idx
	
	arg_30_1.vars.require_bi, arg_30_1.vars.pickup_char_list_idx, arg_30_1.vars.current_pickup_code = GachaIntroduceBG.Util:nextPickup(arg_30_1.vars.pickup_char_list, var_30_1, arg_30_4)
	
	local var_30_2 = arg_30_1.vars.pickup_char_list_idx
	local var_30_3 = false
	
	if var_30_2 < var_30_1 then
	end
	
	if arg_30_3 ~= nil then
		arg_30_1.vars.require_bi = arg_30_3
	end
	
	arg_30_1:setupCurrentCharacterToOpeningUI()
	
	local var_30_4 = 1000
	
	if arg_30_1.vars.require_bi then
		GachaIntroduceBG.Util:startBGOnBI(arg_30_1.vars.bi, arg_30_1.vars.opening_ui, arg_30_1.vars.n_pickup, arg_30_1.vars.current_pickup_code, var_30_4, arg_30_2 or 3000, function()
			arg_30_1:nextPickup()
		end, var_30_3)
	else
		GachaIntroduceBG.Util:startBG(arg_30_1.vars.bi, arg_30_1.vars.opening_ui, arg_30_1.vars.n_pickup, arg_30_1.vars.current_pickup_code, var_30_4, function()
			arg_30_1:nextPickup()
		end)
	end
end

function GachaIntroduceBG.Util.startBG(arg_33_0, arg_33_1, arg_33_2, arg_33_3, arg_33_4, arg_33_5, arg_33_6)
	local var_33_0 = arg_33_2:getLocalZOrder()
	
	arg_33_2:setOpacity(0)
	UIAction:Add(SEQ(CALL(function()
		GachaIntroduceBG.BG:close()
	end), CALL(function()
		GachaIntroduceBG.BG:begin(arg_33_3, arg_33_4, var_33_0 - 1, function()
			local var_36_0 = GachaIntroduceBG.BG:getLayer()
			local var_36_1 = "FieldFloorLayer"
			local var_36_2 = var_36_0:getChildByName(var_36_1)
			
			UIAction:Add(SEQ(SPAWN(TARGET(arg_33_2, FADE_IN(arg_33_5)), TARGET(var_36_2, FADE_OUT(arg_33_5)), CALL(function()
				SoundEngine:play("event:/ui/new_hero/hero_appearance_end")
			end)), DELAY(3000), TARGET(arg_33_1._dim, FADE_IN(500)), CALL(function()
				BattleAction:RemoveAll()
				arg_33_6()
			end), DELAY(500), TARGET(arg_33_1._dim, FADE_OUT(500))), arg_33_3, "gacha_bg.next_skill")
		end)
	end), CALL(function()
		GachaIntroduceBG.BG:startSkillBySelfData()
	end)), "gacha_bg.next_skill")
end

function GachaIntroduceBG.Util.nextPickup(arg_40_0, arg_40_1, arg_40_2, arg_40_3)
	local var_40_0 = table.count(arg_40_1)
	local var_40_1 = false
	
	if var_40_0 <= arg_40_2 or arg_40_2 == 0 then
		var_40_1 = true
		
		if arg_40_3 and var_40_0 <= arg_40_2 then
			var_40_1 = false
		end
		
		arg_40_2 = 1
	else
		var_40_1 = false
		arg_40_2 = arg_40_2 + 1
	end
	
	local var_40_2 = arg_40_1[arg_40_2]
	
	return var_40_1, arg_40_2, var_40_2
end

function GachaIntroduceBG.Util.setPortraitInfoData(arg_41_0, arg_41_1, arg_41_2, arg_41_3)
	local var_41_0
	local var_41_1 = 1
	local var_41_2 = 1
	
	if arg_41_3 then
		var_41_0 = string.split(arg_41_3, ";")
		var_41_1 = tonumber(var_41_0[1])
		
		if var_41_1 == 0 then
			var_41_1 = 1
		end
		
		var_41_2 = 1
		
		if var_41_0[4] then
			var_41_2 = tonumber(var_41_0[4])
		end
		
		local var_41_3 = to_n(var_41_0[5])
		
		if arg_41_1 and var_41_0[6] then
			local var_41_4 = var_41_0[6]
			
			arg_41_1:setSkin(var_41_4)
		end
		
		arg_41_1:setRotation(var_41_3)
	end
	
	arg_41_1:setAnchorPoint(0.5, 0.5)
	
	if arg_41_3 then
		local var_41_5, var_41_6 = arg_41_1:getPosition()
		local var_41_7 = var_41_5 + tonumber(var_41_0[2])
		local var_41_8 = var_41_6 + tonumber(var_41_0[3])
		
		arg_41_1:setPosition(var_41_7, var_41_8)
		arg_41_1:setScale(var_41_1)
		arg_41_2:setScaleX(arg_41_2:getScale() * var_41_2)
	else
		arg_41_1:setScale(1)
	end
end

function GIBG_SHOW_RANDOM_LIST()
	local var_42_0 = Account:getGachaRandList()
	
	table.print(var_42_0)
end

function GIBGRUN_LIST(arg_43_0)
	local var_43_0 = GachaUnit.vars.ui_wnd:getChildByName("n_before"):getChildByName("n_pickup_pos")
	
	var_43_0:removeAllChildren()
	GachaIntroduceBG:setup("normal", var_43_0, {
		gacha_id = "gacha_moonlight",
		detail_mode = "moonlight",
		pickup_char_list = string.split(arg_43_0, ",")
	})
end

function GIBGRUN(arg_44_0)
	local var_44_0 = GachaUnit.vars.ui_wnd:getChildByName("n_before"):getChildByName("n_pickup_pos")
	
	var_44_0:removeAllChildren()
	GachaIntroduceBG:setup("normal", var_44_0, {
		gacha_id = "gacha_moonlight",
		detail_mode = "moonlight",
		pickup_char_list = {
			arg_44_0
		}
	})
end

GachaIntroduceBG.Normal = {}

function GachaIntroduceBG.Normal.setup(arg_45_0, arg_45_1, arg_45_2, arg_45_3, arg_45_4, arg_45_5)
	arg_45_0.vars = {}
	arg_45_0.vars.pickup_char_list = arg_45_4
	arg_45_0.vars.n_pickup = arg_45_1
	arg_45_0.vars.pickup_char_list_idx = 0
	arg_45_0.vars.current_pickup_code = nil
	
	arg_45_0:setupBI(arg_45_1, arg_45_2, arg_45_3, arg_45_5)
	arg_45_0:createOpeningUI(arg_45_1)
	arg_45_0:nextPickup()
end

function GachaIntroduceBG.Normal.setupBI(arg_46_0, arg_46_1, arg_46_2, arg_46_3, arg_46_4)
	local var_46_0 = "wnd/gacha_covenant.csb"
	local var_46_1 = arg_46_3
	
	if DB("gacha_ui", var_46_1, "id") == nil then
		var_46_1 = DB("gacha_ui_list", arg_46_3, "gacha_ui_id")
		
		if var_46_1 == nil then
			Log.e("not exist gacha id. check.")
		end
	end
	
	local var_46_2, var_46_3, var_46_4, var_46_5, var_46_6, var_46_7, var_46_8, var_46_9, var_46_10 = DB("gacha_ui", var_46_1, {
		"ui_type",
		"background",
		"bi_banner",
		"info_txt",
		"right_data",
		"right_character",
		"left_data",
		"left_character",
		"grow_tint"
	})
	
	if var_46_2 == "select" then
		var_46_0 = "wnd/gacha_select.csb"
	elseif arg_46_3 == "gacha_rare" then
		var_46_0 = "wnd/gacha_rare.csb"
	end
	
	if not var_46_7 and not var_46_9 then
		var_46_7 = "npc1026"
		var_46_9 = "npc1027"
	end
	
	local var_46_11 = load_control(var_46_0, true)
	
	arg_46_1:addChild(var_46_11)
	
	arg_46_0.vars.bi = var_46_11:findChildByName("n_standby")
	
	GachaIntroduceBG.Util:settingBIInfo(arg_46_0.vars.bi, var_46_11, var_46_3, var_46_4, var_46_5, arg_46_3)
	
	local var_46_12
	local var_46_13
	
	if var_46_7 then
		var_46_12 = UIUtil:getPortraitAni(var_46_7)
	else
		var_46_12 = UIUtil:getPortraitAni(var_46_7)
	end
	
	if var_46_9 then
		var_46_13 = UIUtil:getPortraitAni(var_46_9)
	end
	
	if var_46_12 then
		local var_46_14 = arg_46_0.vars.bi:getChildByName("n_pos1")
		
		UIUtil:setPortraitPositionByFaceBone(var_46_12)
		GachaIntroduceBG.Util:setPortraitInfoData(var_46_12, var_46_14, var_46_6)
		var_46_14:addChild(var_46_12)
	end
	
	if var_46_13 then
		local var_46_15 = arg_46_0.vars.bi:getChildByName("n_pos2")
		
		UIUtil:setPortraitPositionByFaceBone(var_46_13)
		GachaIntroduceBG.Util:setPortraitInfoData(var_46_13, var_46_15, var_46_8)
		var_46_15:addChild(var_46_13)
	end
	
	if arg_46_3 == "gacha_rare" then
		local var_46_16 = var_46_11:getChildByName("n_standby")
		local var_46_17 = var_46_16:findChildByName("front_bg")
		
		if var_46_17 then
			var_46_17:removeFromParent()
		end
		
		local var_46_18 = EffectManager:Play({
			fn = "uieff_gacha_bg_eff_f.cfx",
			layer = var_46_16
		})
		
		if var_46_18 then
			var_46_18:setName("front_bg")
			var_46_18:setPosition(515, 320)
			var_46_18:setLocalZOrder(1)
			var_46_11:getChildByName("bi"):setLocalZOrder(2)
		else
			Log.e("Not find uieff_gacha_bg_eff_f.cfx")
		end
	end
	
	if var_46_2 == "select" and var_46_10 then
		if_set_color(arg_46_0.vars.bi, "n_grow", tocolor(var_46_10))
	end
end

function GachaIntroduceBG.Util.setSilent(arg_47_0)
	SoundEngine:setVolumeBattle(0)
	SoundEngine:setVolumeVoice(0)
	
	local var_47_0 = SoundEngine:getCollectSound()
	
	for iter_47_0, iter_47_1 in pairs(var_47_0) do
		iter_47_1.sound:setVolume(0)
	end
end

function GachaIntroduceBG.Util.setVolume(arg_48_0)
	SoundEngine:setVolumeBattle(SAVE:getOptionData("sound.vol_battle", 1))
	SoundEngine:setVolumeVoice(SAVE:getOptionData("sound.vol_voice", 1))
end

function GachaIntroduceBG.Normal.nextPickup(arg_49_0)
	GachaIntroduceBG.Util:defaultImplNextPickup(arg_49_0)
end

function GachaIntroduceBG.Normal.close(arg_50_0)
	if not arg_50_0.vars then
		return 
	end
	
	if get_cocos_refid(arg_50_0.vars.opening_ui) then
		arg_50_0.vars.opening_ui:removeFromParent()
		
		arg_50_0.vars.opening_ui = nil
	end
	
	arg_50_0.vars = nil
end

function GachaIntroduceBG.Normal.onBeforeDraw(arg_51_0)
	if arg_51_0.vars and get_cocos_refid(arg_51_0.vars.texture) then
		local var_51_0 = cc.Director:getInstance():getDeltaTime()
		
		arg_51_0.vars.pickup_portrait:update(var_51_0)
		arg_51_0.vars.texture:beginWithClear(0, 0, 0, 0)
		arg_51_0.vars.pickup_portrait:visit()
		arg_51_0.vars.texture:endToLua()
	end
end

function GachaIntroduceBG.Normal.setupCurrentCharacterToOpeningUI(arg_52_0)
	arg_52_0.vars.texture, arg_52_0.vars.pickup_portrait = GachaIntroduceBG.Util:setupCurrentCharacterToOpeningUI(arg_52_0.vars.opening_ui, arg_52_0.vars.current_pickup_code)
end

function GachaIntroduceBG.Normal.createOpeningUI(arg_53_0, arg_53_1)
	arg_53_0.vars.opening_ui = GachaIntroduceBG.Util:createOpeningUI()
	
	arg_53_0.vars.opening_ui:setLocalZOrder(-99999)
	arg_53_1:addChild(arg_53_0.vars.opening_ui)
end

GachaIntroduceBG.SubStory = {}

function GachaIntroduceBG.SubStory.setup(arg_54_0, arg_54_1, arg_54_2, arg_54_3, arg_54_4, arg_54_5, arg_54_6, arg_54_7, arg_54_8)
	arg_54_0.vars = {}
	
	if not arg_54_7 and arg_54_5 and arg_54_5.ceiling_character then
		arg_54_8 = {
			arg_54_5.ceiling_character
		}
	end
	
	arg_54_0.vars.n_pickup = arg_54_1
	arg_54_0.vars.pickup_char_list = arg_54_8
	arg_54_0.vars.pickup_char_list_idx = 0
	arg_54_0.vars.current_pickup_code = nil
	
	arg_54_0:setupBI(arg_54_1, arg_54_2, arg_54_3, arg_54_4, arg_54_5, arg_54_6, arg_54_7)
	
	if arg_54_8 then
		if not arg_54_0.vars.do_like_pickup then
			arg_54_0:createOpeningUI(arg_54_1)
		end
		
		arg_54_0:nextPickup(arg_54_1)
	end
end

function GachaIntroduceBG.SubStory.createOpeningUI(arg_55_0, arg_55_1)
	arg_55_0.vars.opening_ui = GachaIntroduceBG.Util:createOpeningUI()
	
	arg_55_0.vars.opening_ui:setLocalZOrder(-99999)
	arg_55_1:addChild(arg_55_0.vars.opening_ui)
end

function GachaIntroduceBG.SubStory.onBeforeDraw(arg_56_0)
	if arg_56_0.vars and get_cocos_refid(arg_56_0.vars.texture) then
		local var_56_0 = cc.Director:getInstance():getDeltaTime()
		
		arg_56_0.vars.pickup_portrait:update(var_56_0)
		arg_56_0.vars.texture:beginWithClear(0, 0, 0, 0)
		arg_56_0.vars.pickup_portrait:visit()
		arg_56_0.vars.texture:endToLua()
	end
end

function GachaIntroduceBG.SubStory.setupCurrentCharacterToOpeningUI(arg_57_0)
	arg_57_0.vars.texture, arg_57_0.vars.pickup_portrait = GachaIntroduceBG.Util:setupCurrentCharacterToOpeningUI(arg_57_0.vars.opening_ui, arg_57_0.vars.current_pickup_code)
end

function GachaIntroduceBG.SubStory.nextPickup(arg_58_0, arg_58_1)
	if not arg_58_0.vars.do_like_pickup then
		GachaIntroduceBG.Util:defaultImplNextPickup(arg_58_0)
	else
		local var_58_0 = 3000
		local var_58_1 = 500
		
		print("self.vars.char_id?", arg_58_0.vars.char_id)
		UIAction:Add(SEQ(DELAY(var_58_0 - 500), CALL(function()
			local var_59_0 = arg_58_0.vars.n_pickup:getLocalZOrder()
			
			GachaIntroduceBG.BG:begin(arg_58_1, arg_58_0.vars.char_id, var_59_0 - 1, function()
				arg_58_0:openingSequence()
			end)
		end), DELAY(500), CALL(function()
			GachaIntroduceBG.BG:startSkillBySelfData()
		end), RLOG(FADE_OUT(var_58_1))), arg_58_0.vars.bi, "gacha_event_list")
	end
end

function GachaIntroduceBG.SubStory.openingSequence(arg_62_0)
	arg_62_0.vars.bi:setOpacity(0)
	
	local var_62_0 = 500
	local var_62_1 = 500
	local var_62_2 = 8000
	
	UIAction:Add(SEQ(CALL(function()
		SoundEngine:play("event:/ui/new_hero/hero_appearance_end")
	end), LOG(FADE_IN(var_62_0)), DELAY(var_62_2), CALL(function()
		GachaIntroduceBG.BG:startSkillBySelfData()
	end), RLOG(FADE_OUT(var_62_1))), arg_62_0.vars.bi, "gacha_event_list")
end

function GachaIntroduceBG.SubStory.setupBI(arg_65_0, arg_65_1, arg_65_2, arg_65_3, arg_65_4, arg_65_5, arg_65_6, arg_65_7)
	local var_65_0
	
	if arg_65_7 then
		var_65_0 = load_control("wnd/" .. (arg_65_5.ui_file or "gacha_story_pickup") .. ".csb", true)
	else
		var_65_0 = load_control("wnd/gacha_pickup_b.csb", true)
	end
	
	arg_65_0.vars.bi = var_65_0:findChildByName("n_standby")
	
	if not arg_65_0.vars.bi then
		arg_65_0.vars.bi = var_65_0
	end
	
	arg_65_0.vars.is_pickup_mode = not arg_65_7
	
	arg_65_1:addChild(var_65_0)
	if_set_visible(var_65_0, "n_btn_pickup_info_close", false)
	if_set_visible(var_65_0, "n_pickup_infolist", false)
	if_set_visible(var_65_0, "bg_deco", false)
	if_set_visible(var_65_0, "img_pickup_info", false)
	if_set_visible(var_65_0, "n_info_left", false)
	if_set_visible(var_65_0, "n_portrait_l", false)
	if_set_visible(var_65_0, "n_info_right", false)
	if_set_visible(var_65_0, "n_portrait_r", false)
	if_set_visible(var_65_0, "n_title_img", false)
	if_set_visible(var_65_0, "n_hero_portrait_custom", false)
	if_set_visible(var_65_0, "n_selected_info_custom", false)
	if_set_visible(arg_65_2, "n_pickup", true)
	GachaUnit:setBiblikaNodeVisible(false)
	GachaUnit:setBiblioNodeVisible(false)
	
	if arg_65_7 then
		if_set_visible(arg_65_2, "n_btn_summon_2", false)
		
		local var_65_1 = {}
		
		var_65_1.background, var_65_1.left_character, var_65_1.left_data, var_65_1.right_character, var_65_1.right_data = DB("gacha_ui", "gacha_substory", {
			"background",
			"left_character",
			"left_data",
			"right_character",
			"right_data"
		})
		
		if var_65_1.background then
			local var_65_2 = SpriteCache:getSprite("banner/" .. var_65_1.background .. ".png")
			local var_65_3 = var_65_0:getChildByName("n_bg")
			
			if var_65_3 then
				var_65_3:addChild(var_65_2)
			end
		end
		
		local var_65_4, var_65_5, var_65_6 = DB("gacha_ui", arg_65_3.id, {
			"background",
			"bi_banner",
			"info_txt"
		})
		
		GachaIntroduceBG.Util:settingBIInfo(arg_65_0.vars.bi, var_65_0, var_65_4, var_65_5, var_65_6)
		
		if var_65_1.left_character then
			if_set_visible(var_65_0, "n_pos2", true)
			GachaUnit:setPickupPortrait(var_65_0:getChildByName("n_pos2"), var_65_1.left_character, var_65_1.left_data)
		end
		
		if var_65_1.right_character then
			if_set_visible(var_65_0, "n_pos1", true)
			GachaUnit:setPickupPortrait(var_65_0:getChildByName("n_pos1"), var_65_1.right_character, var_65_1.right_data)
		end
	else
		local var_65_7 = {
			title_data = "1;0;0",
			right_character = arg_65_3.right_character,
			artifact = arg_65_3.artifact
		}
		
		GachaUnit:setTitle(var_65_0, "gacha_substory", arg_65_5, var_65_7)
		
		arg_65_0.vars.do_like_pickup = true
		arg_65_0.vars.n_pickup = var_65_0
		arg_65_0.vars.char_id = arg_65_3.right_character
		
		if arg_65_5.background then
			local var_65_8 = SpriteCache:getSprite("banner/" .. arg_65_5.background .. ".png")
			local var_65_9 = var_65_0:getChildByName("n_bg")
			
			if var_65_9 then
				var_65_9:addChild(var_65_8)
			end
		end
		
		if_set_visible(var_65_0, "n_pos1", false)
		if_set_visible(var_65_0, "n_pos2", false)
		GachaUnit:updatePickupCharacterUI(arg_65_2, var_65_0, arg_65_6, arg_65_5, {
			ignore_left = true
		})
		
		if arg_65_5.ceiling_character then
			GachaUnit:setRecommendTag(arg_65_2, arg_65_5.ceiling_character)
		end
		
		GachaUnit:updateGachaTempInventoryCount()
		if_set_visible(arg_65_2, "n_btn_rate", true)
		if_set_visible(var_65_0, "n_btn_pickup_info", true)
		if_set_visible(arg_65_1, "n_btn", false)
		if_set_visible(arg_65_2, "n_btn_summon_2", true)
		
		local var_65_10 = arg_65_2:getChildByName("n_btn_summon_2")
		
		if get_cocos_refid(var_65_10) and var_65_10:isVisible() then
			if_set_visible(var_65_10, "cm_free_tooltip", false)
			if_set_visible(var_65_10, "cm_free_tooltip2", false)
			
			local var_65_11 = var_65_10:getChildByName("btn_summon_1")
			
			if_set_visible(var_65_11, "cm_icon_gacha", false)
			if_set(var_65_11, "txt_summon", T("ui_gacha_summon_1_btn"))
			if_set(var_65_11, "cost", arg_65_4.price)
			if_set_sprite(var_65_11, "icon_res", "item/" .. DB("item_token", arg_65_4.token, {
				"icon"
			}) .. ".png")
			
			local var_65_12 = var_65_10:getChildByName("btn_summon_10")
			
			if_set(var_65_12, "txt_summon", T("ui_gacha_summon_10_btn"))
			if_set(var_65_12, "cost", arg_65_4.price * 10)
			if_set_sprite(var_65_12, "icon_res", "item/" .. DB("item_token", arg_65_4.token, {
				"icon"
			}) .. ".png")
		else
			local var_65_13 = arg_65_2:getChildByName("btn_summon")
			
			if get_cocos_refid(var_65_13) then
				var_65_13:setVisible(true)
			end
			
			if_set_visible(var_65_13, "cm_free_tooltip", false)
			if_set_visible(var_65_13, "cm_icon_gacha", false)
			if_set(var_65_13, "txt_summon", T(arg_65_4.name))
			if_set(var_65_13, "cost", arg_65_4.price)
			if_set_sprite(var_65_13, "icon_res", "item/" .. DB("item_token", arg_65_4.token, {
				"icon"
			}) .. ".png")
		end
		
		if_set_visible(var_65_0, "n_date_limited", false)
		
		local var_65_14 = var_65_0:getChildByName("n_date")
		
		if get_cocos_refid(var_65_14) then
			var_65_14:setVisible(true)
			
			if var_65_14 and arg_65_5.start_time and arg_65_5.end_time then
				var_65_14:setVisible(true)
				if_set(var_65_14, "disc", T("time_slash_period_y_m_d_time", timeToStringDef({
					preceding_with_zeros = true,
					start_time = arg_65_5.start_time,
					end_time = arg_65_5.end_time
				})))
				
				local var_65_15 = var_65_14:findChildByName("t_limited")
				local var_65_16 = var_65_14:findChildByName("title")
				
				if get_cocos_refid(var_65_15) and get_cocos_refid(var_65_16) and var_65_15:getStringNumLines() == 4 then
					var_65_16._origin_pos_y = var_65_16._origin_pos_y or var_65_16:getPositionY()
					
					var_65_16:setPositionY(var_65_16._origin_pos_y + 10)
				end
				
				if to_n(arg_65_5.end_time) - os.time() > (GAME_STATIC_VARIABLE.summon_expire_info_time or 86400) then
					if_set_color(var_65_14, "disc", tocolor("#c89b60"))
				else
					if_set_color(var_65_14, "disc", tocolor("#6bc11b"))
				end
			else
				var_65_14:setVisible(false)
			end
			
			GachaUnit:updatePickupInfoUIListview(arg_65_2, arg_65_5.pickup_gacha_list)
		end
	end
	
	GachaUnit:showRightMenu(false)
end

function GachaIntroduceBG.SubStory.close(arg_66_0)
	UIAction:Remove("gacha_bg.next_skill")
end

GachaIntroduceBG.Story = {}

function GachaIntroduceBG.Story.setup(arg_67_0, arg_67_1, arg_67_2, arg_67_3, arg_67_4, arg_67_5, arg_67_6, arg_67_7)
	arg_67_0.vars = {}
	
	local var_67_0
	local var_67_1 = Account:getGachaRandList()
	
	if var_67_1 and var_67_1[arg_67_3] then
		local var_67_2 = var_67_1[arg_67_3]
		
		var_67_0 = string.split(var_67_2, ",")
	end
	
	arg_67_7 = var_67_0
	arg_67_0.vars.n_pickup = arg_67_1
	arg_67_0.vars.pickup_char_list = arg_67_7
	arg_67_0.vars.pickup_char_list_idx = 0
	arg_67_0.vars.current_pickup_code = nil
	
	local var_67_3 = arg_67_0.vars.pickup_char_list and table.count(arg_67_0.vars.pickup_char_list) > 0
	
	if var_67_3 then
		arg_67_0:createOpeningUI(arg_67_1)
	end
	
	arg_67_0:setupBI(arg_67_1, arg_67_2, arg_67_3, arg_67_4, arg_67_5, arg_67_6)
	
	if var_67_3 then
		arg_67_0:nextPickup()
	end
end

function GachaIntroduceBG.Story.createOpeningUI(arg_68_0, arg_68_1)
	arg_68_0.vars.opening_ui = GachaIntroduceBG.Util:createOpeningUI()
	
	arg_68_0.vars.opening_ui:setLocalZOrder(-99999)
	arg_68_1:addChild(arg_68_0.vars.opening_ui)
end

function GachaIntroduceBG.Story.setupBI(arg_69_0, arg_69_1, arg_69_2, arg_69_3, arg_69_4, arg_69_5, arg_69_6)
	GachaUnit:setBiblikaNodeVisible(false)
	GachaUnit:setBiblioNodeVisible(false)
	
	local var_69_0 = os.time()
	local var_69_1
	
	if arg_69_3 == "gacha_story_ep999" then
		var_69_1 = load_control("wnd/gacha_dash_luckyweek.csb", true)
	elseif arg_69_3 == "gacha_spdash" then
		var_69_1 = load_control("wnd/gacha_dash_luckyweek.csb", true)
	else
		var_69_1 = load_control("wnd/gacha_dash_story.csb", true)
	end
	
	arg_69_0.vars.bi = var_69_1:findChildByName("n_standby")
	
	GachaIntroduceBG.Util:setupPickupDataUI(arg_69_5, arg_69_0.vars.bi)
	
	local var_69_2 = SpriteCache:getSprite("banner/" .. arg_69_5.background .. ".png")
	local var_69_3 = var_69_1:getChildByName("n_bg")
	
	if var_69_3 and var_69_2 then
		var_69_3:addChild(var_69_2)
	end
	
	local var_69_4 = var_69_1:getChildByName("n_btn")
	local var_69_5 = Account:getTicketedLimit("gl:" .. arg_69_5.gacha_id)
	
	if var_69_5 then
		if to_n(var_69_5.count) >= to_n(var_69_5.max_c) or var_69_0 > to_n(var_69_5.buyable_tm) then
			error("invalid tl_gacha_story data. do you check")
		end
		
		if_set_visible(var_69_4, "n_btn_summon", true)
		if_set_visible(var_69_4, "btn_summon", true)
		if_set_visible(var_69_4, "n_btn_buy", false)
		
		local var_69_6 = var_69_4:getChildByName("n_btn_summon")
		local var_69_7 = var_69_4:getChildByName("btn_summon")
		
		if_set(var_69_7, "txt_summon", T(arg_69_4.gacha[arg_69_5.gacha_id].name))
		
		local var_69_8 = var_69_7:getChildByName("n_counter")
		local var_69_9 = to_n(var_69_5.max_c) - to_n(var_69_5.count)
		
		if_set(var_69_8, "cost", var_69_9 .. "/" .. to_n(var_69_5.max_c))
	elseif arg_69_5 then
		local var_69_10 = Account:getTicketedLimit("ip:" .. arg_69_5.shop_id)
		
		if arg_69_3 ~= "gacha_story_ep999" and arg_69_3 ~= "gacha_spdash" and (not var_69_10 or not AccountData.shop or not AccountData.shop.promotion or var_69_0 < to_n(arg_69_5.start_time) or var_69_0 > to_n(arg_69_5.end_time)) then
			error("invalid gacha_story/story_id. do you use this function by GachaUnit.enterGachaStory? ")
		end
		
		local var_69_11
		
		for iter_69_0, iter_69_1 in pairs(AccountData.shop.promotion) do
			if iter_69_1.id == arg_69_5.shop_id then
				var_69_11 = iter_69_1
				
				break
			end
		end
		
		if not var_69_11 then
			error("invalid gacha_story/shop_item. do you use this function by GachaUnit.enterGachaStory? ")
		end
		
		if_set_visible(var_69_4, "n_btn_summon", false)
		if_set_visible(var_69_4, "btn_summon", false)
		if_set_visible(var_69_4, "n_btn_buy", true)
		
		local var_69_12 = var_69_4:getChildByName("n_btn_buy")
		
		ShopCommon:UpdatePayIcon(var_69_12:getChildByName("btn_buy"), var_69_11)
		
		if arg_69_3 == "gacha_story_ep999" or arg_69_3 == "gacha_spdash" then
			if_set(var_69_12:getChildByName("btn_buy"), "txt_buy", T("event_package_buy_availability", {
				count = string.format("(%d/%d)", 1, 1)
			}))
		elseif var_69_10 then
			local var_69_13 = to_n(var_69_10.max_c) - to_n(var_69_10.count)
			local var_69_14 = to_n(var_69_10.max_c)
			
			if_set(var_69_12:getChildByName("btn_buy"), "txt_buy", T("event_package_buy_availability", {
				count = string.format("(%d/%d)", var_69_13, var_69_14)
			}))
		end
	else
		error("not exist gacha_story and tl_gacha_story. do you use this function by GachaUnit.enterGachaStory? ")
		
		return 
	end
	
	local var_69_15 = var_69_1:getChildByName("n_bi")
	
	if arg_69_6.bi_img then
		if_set_sprite(var_69_15, "bi", "banner/" .. arg_69_6.bi_img .. ".png")
		GachaUnit:setDataUI(var_69_15, arg_69_6.bi_data)
	end
	
	for iter_69_2 = 1, 4 do
		local var_69_16 = var_69_1:getChildByName("n_pos" .. iter_69_2)
		local var_69_17 = arg_69_6["char" .. iter_69_2 .. "_id"]
		
		if get_cocos_refid(var_69_16) and var_69_17 then
			local var_69_18 = DB("character", var_69_17, "face_id")
			
			if var_69_18 then
				local var_69_19 = UIUtil:getPortraitAni(var_69_18)
				
				if var_69_19 then
					var_69_16:addChild(var_69_19)
					UIUtil:setPortraitPositionByFaceBone(var_69_19)
					GachaIntroduceBG.Util:setPortraitInfoData(var_69_19, var_69_16, arg_69_6["char" .. iter_69_2 .. "_data"])
				end
			end
		end
	end
	
	local var_69_20 = var_69_1:getChildByName("n_info")
	
	if arg_69_6.title then
		if_set(var_69_20, "txt_info", T(arg_69_6.title))
	end
	
	GachaUnit:setDataPopupStoryInfo(arg_69_3, DB("gacha_story_ui", arg_69_3, "ui_info_text_popup_title"))
	
	for iter_69_3 = 1, 4 do
		if arg_69_6["text_" .. iter_69_3] then
			if_set(var_69_20, "disc" .. iter_69_3, T(arg_69_6["text_" .. iter_69_3]))
		end
	end
	
	if arg_69_6.grow_tint then
		if_set_color(var_69_1, "n_grow", tocolor(arg_69_6.grow_tint))
	end
	
	arg_69_1:addChild(var_69_1)
end

function GachaIntroduceBG.Story.onBeforeDraw(arg_70_0)
	if arg_70_0.vars and get_cocos_refid(arg_70_0.vars.texture) then
		local var_70_0 = cc.Director:getInstance():getDeltaTime()
		
		arg_70_0.vars.pickup_portrait:update(var_70_0)
		arg_70_0.vars.texture:beginWithClear(0, 0, 0, 0)
		arg_70_0.vars.pickup_portrait:visit()
		arg_70_0.vars.texture:endToLua()
	end
end

function GachaIntroduceBG.Story.setupCurrentCharacterToOpeningUI(arg_71_0)
	arg_71_0.vars.texture, arg_71_0.vars.pickup_portrait = GachaIntroduceBG.Util:setupCurrentCharacterToOpeningUI(arg_71_0.vars.opening_ui, arg_71_0.vars.current_pickup_code)
end

function GachaIntroduceBG.Story.nextPickup(arg_72_0)
	GachaIntroduceBG.Util:defaultImplNextPickup(arg_72_0, 3000)
end

function GachaIntroduceBG.Story.close(arg_73_0)
	UIAction:Remove("gacha_bg.next_skill")
end

GachaIntroduceBG.Start = {}

function GachaIntroduceBG.Start.setup(arg_74_0, arg_74_1, arg_74_2, arg_74_3)
	arg_74_0.vars = {}
	
	local var_74_0
	local var_74_1 = Account:getGachaRandList()
	local var_74_2 = "gacha_start"
	
	if var_74_1 and var_74_1[var_74_2] then
		local var_74_3 = var_74_1[var_74_2]
		
		var_74_0 = string.split(var_74_3, ",")
	end
	
	local var_74_4 = var_74_0
	
	arg_74_0.vars.n_pickup = arg_74_1
	arg_74_0.vars.pickup_char_list = var_74_4
	arg_74_0.vars.pickup_char_list_idx = 0
	arg_74_0.vars.current_pickup_code = nil
	
	if not arg_74_0:setupBI(arg_74_1, arg_74_2, arg_74_3) then
		arg_74_0.vars = nil
		
		return false
	end
	
	local var_74_5 = arg_74_0.vars.pickup_char_list and table.count(arg_74_0.vars.pickup_char_list) > 0
	
	if var_74_5 then
		arg_74_0:createOpeningUI(arg_74_1)
	end
	
	if var_74_5 then
		arg_74_0:nextPickup()
	end
	
	return true
end

function GachaIntroduceBG.Start.createOpeningUI(arg_75_0, arg_75_1)
	arg_75_0.vars.opening_ui = GachaIntroduceBG.Util:createOpeningUI()
	
	arg_75_0.vars.opening_ui:setLocalZOrder(-99999)
	arg_75_1:addChild(arg_75_0.vars.opening_ui)
end

function GachaIntroduceBG.Start.setupBI(arg_76_0, arg_76_1, arg_76_2, arg_76_3)
	local var_76_0 = os.time()
	local var_76_1 = load_control("wnd/gacha_dash.csb", true)
	local var_76_2 = var_76_1:getChildByName("n_btn")
	
	arg_76_0.vars.bi = var_76_1:getChildByName("n_standby")
	
	local var_76_3 = arg_76_3.gacha_start
	local var_76_4 = Account:getTicketedLimit("gl:gacha_start")
	
	if var_76_4 then
		if to_n(var_76_4.count) >= to_n(var_76_4.max_c) or var_76_0 > to_n(var_76_4.buyable_tm) then
			GachaUnit:enterGachaRare()
			
			return false
		end
		
		if_set_visible(var_76_2, "btn_summon", true)
		if_set_visible(var_76_2, "n_btn_buy", false)
		
		local var_76_5 = var_76_2:getChildByName("btn_summon")
		
		if_set(var_76_5, "txt_summon", T(arg_76_3.gacha.gacha_start.name))
		
		local var_76_6 = var_76_5:getChildByName("n_counter")
		local var_76_7 = to_n(var_76_4.max_c) - to_n(var_76_4.count)
		
		if_set(var_76_6, "cost", var_76_7 .. "/" .. to_n(var_76_4.max_c))
	elseif var_76_3 then
		local var_76_8 = Account:getTicketedLimit("ip:" .. var_76_3.shop_id)
		
		if not var_76_8 or not AccountData.shop or not AccountData.shop.promotion or var_76_0 < to_n(var_76_3.start_time) or var_76_0 > to_n(var_76_3.end_time) then
			GachaUnit:enterGachaRare()
			
			return false
		end
		
		local var_76_9
		
		for iter_76_0, iter_76_1 in pairs(AccountData.shop.promotion) do
			if iter_76_1.id == var_76_3.shop_id then
				var_76_9 = iter_76_1
				
				break
			end
		end
		
		if not var_76_9 then
			GachaUnit:enterGachaRare()
			
			return false
		end
		
		if_set_visible(var_76_2, "btn_summon", false)
		if_set_visible(var_76_2, "n_btn_buy", true)
		
		local var_76_10 = var_76_2:getChildByName("n_btn_buy")
		
		ShopCommon:UpdatePayIcon(var_76_10:getChildByName("btn_buy"), var_76_9)
		if_set(var_76_10, "t_period", T("sell_period_v2", timeToStringDef({
			preceding_with_zeros = true,
			start_time = var_76_8.usable_tm,
			end_time = var_76_8.buyable_tm
		})))
		
		if to_n(var_76_8.buyable_tm) - os.time() > (GAME_STATIC_VARIABLE.summon_expire_info_time or 86400) then
			if_set_color(var_76_10, "t_period", tocolor("#c89b60"))
		else
			if_set_color(var_76_10, "t_period", tocolor("#6bc11b"))
		end
		
		local var_76_11 = to_n(var_76_8.max_c) - to_n(var_76_8.count)
		local var_76_12 = to_n(var_76_8.max_c)
		
		if_set(var_76_10:getChildByName("btn_buy"), "txt_buy", T("event_package_buy_availability", {
			count = string.format("(%d/%d)", var_76_11, var_76_12)
		}))
	else
		GachaUnit:enterGachaRare()
		
		return false
	end
	
	if var_76_3.background then
		local var_76_13 = SpriteCache:getSprite("banner/" .. var_76_3.background .. ".png")
		local var_76_14 = var_76_1:getChildByName("n_bg")
		
		if var_76_14 and var_76_13 then
			var_76_14:addChild(var_76_13)
		end
	end
	
	if_set_sprite(var_76_1, "bi", "banner/pk_gacha_start_bi.png")
	if_set_sprite(var_76_1, "info_txt", "banner/gacha_info_start.png")
	if_set_color(var_76_1, "n_grow", tocolor("#0e1c21"))
	
	local var_76_15 = UIUtil:getPortraitAni(DB("character", "c1005", "face_id"))
	
	if var_76_15 then
		var_76_15:setSkin("smile")
		var_76_1:getChildByName("n_pos1"):addChild(var_76_15)
		UIUtil:setPortraitPositionByFaceBone(var_76_15)
	end
	
	local var_76_16 = UIUtil:getPortraitAni(DB("character", "c1001", "face_id"))
	
	if var_76_16 then
		var_76_16:setSkin("smile")
		var_76_1:getChildByName("n_pos2"):addChild(var_76_16)
		UIUtil:setPortraitPositionByFaceBone(var_76_16)
	end
	
	arg_76_1:addChild(var_76_1)
	
	return true
end

function GachaIntroduceBG.Start.onBeforeDraw(arg_77_0)
	if arg_77_0.vars and get_cocos_refid(arg_77_0.vars.texture) then
		local var_77_0 = cc.Director:getInstance():getDeltaTime()
		
		arg_77_0.vars.pickup_portrait:update(var_77_0)
		arg_77_0.vars.texture:beginWithClear(0, 0, 0, 0)
		arg_77_0.vars.pickup_portrait:visit()
		arg_77_0.vars.texture:endToLua()
	end
end

function GachaIntroduceBG.Start.setupCurrentCharacterToOpeningUI(arg_78_0)
	arg_78_0.vars.texture, arg_78_0.vars.pickup_portrait = GachaIntroduceBG.Util:setupCurrentCharacterToOpeningUI(arg_78_0.vars.opening_ui, arg_78_0.vars.current_pickup_code)
end

function GachaIntroduceBG.Start.nextPickup(arg_79_0)
	GachaIntroduceBG.Util:defaultImplNextPickup(arg_79_0, 3000)
end

function GachaIntroduceBG.Start.close(arg_80_0)
	UIAction:Remove("gacha_bg.next_skill")
end

GachaIntroduceBG.Special = {}

function GachaIntroduceBG.Special.setup(arg_81_0, arg_81_1, arg_81_2, arg_81_3, arg_81_4, arg_81_5)
	arg_81_0.vars = {}
	
	local var_81_0 = arg_81_3
	
	arg_81_0.vars.n_pickup = arg_81_1
	arg_81_5 = arg_81_5 or {
		var_81_0.ceiling_character,
		var_81_0.ceiling_character_cm4
	}
	
	arg_81_0:setupBI(arg_81_1, arg_81_2, arg_81_3, arg_81_4)
	arg_81_0:updateSelectedList(arg_81_5)
end

function GachaIntroduceBG.Special.updateSelectedList(arg_82_0, arg_82_1)
	arg_82_0.vars.pickup_char_list = arg_82_1
	arg_82_0.vars.pickup_char_list_idx = 0
	arg_82_0.vars.current_pickup_code = nil
	
	if arg_82_0.vars.opening_ui then
		if arg_82_0.vars.bi and arg_82_0.vars.bi._dim then
			arg_82_0.vars.bi._dim:setOpacity(0)
		end
		
		GachaIntroduceBG:closeWithSound(true)
		
		if get_cocos_refid(arg_82_0.vars.opening_ui) then
			arg_82_0.vars.opening_ui:removeFromParent()
		end
		
		arg_82_0.vars.opening_ui = nil
	end
	
	arg_82_0:createOpeningUI(arg_82_0.vars.n_pickup)
	
	if arg_82_0.vars.pickup_char_list and table.count(arg_82_0.vars.pickup_char_list) > 0 then
		arg_82_0:nextPickup()
	end
end

function GachaIntroduceBG.Special.setupBI(arg_83_0, arg_83_1, arg_83_2, arg_83_3, arg_83_4)
	local var_83_0 = load_control("wnd/gacha_special.csb", true)
	
	arg_83_0.vars.bi = var_83_0:findChildByName("n_standby")
	
	arg_83_1:addChild(var_83_0)
	
	local var_83_1 = CACHE:getEffect("ui_new_training_bg.cfx")
	
	var_83_1:setPosition(0, 0)
	var_83_1:setScale(VIEW_WIDTH_RATIO)
	var_83_1:start()
	var_83_0:getChildByName("n_bg"):addChild(var_83_1, 10)
	if_set_visible(var_83_0, "n_btn_special_info", true)
	if_set_visible(var_83_0, "n_btn_special_info_close", false)
	GachaUnit:updateSpecialInfo(false)
	GachaUnit:updateSpecialGachaSelected(to_n(arg_83_3.gs_grade or 5))
	if_set_visible(arg_83_0.vars.ui_wnd, "n_special_notice", false)
	
	local var_83_2 = arg_83_2:getChildByName("n_btn_summon_2")
	
	if get_cocos_refid(var_83_2) and var_83_2:isVisible() then
		if_set_visible(var_83_2, "cm_free_tooltip", false)
		if_set_visible(var_83_2, "cm_free_tooltip2", false)
		
		local var_83_3 = var_83_2:getChildByName("btn_summon_1")
		
		if_set_visible(var_83_3, "cm_icon_gacha", false)
		if_set(var_83_3, "txt_summon", T("ui_gacha_summon_1_btn"))
		if_set(var_83_3, "cost", arg_83_4.price)
		if_set_sprite(var_83_3, "icon_res", "item/" .. DB("item_token", arg_83_4.token, {
			"icon"
		}) .. ".png")
		
		local var_83_4 = var_83_2:getChildByName("btn_summon_10")
		
		if_set(var_83_4, "txt_summon", T("ui_gacha_summon_10_btn"))
		if_set(var_83_4, "cost", arg_83_4.price * 10)
		if_set_sprite(var_83_4, "icon_res", "item/" .. DB("item_token", arg_83_4.token, {
			"icon"
		}) .. ".png")
		
		local var_83_5 = UnlockSystem:isUnlockSystem(UNLOCK_ID.GACHA_SPECIAL)
		
		if_set_visible(var_83_2, "icon_locked_summon_1", not var_83_5)
		if_set_visible(var_83_2, "icon_locked_summon_10", not var_83_5)
	else
		local var_83_6 = arg_83_2:getChildByName("btn_summon")
		
		if_set_visible(arg_83_2, "n_btn_summon_2", false)
		
		if get_cocos_refid(var_83_6) then
			var_83_6:setVisible(true)
		end
		
		if_set_visible(var_83_6, "cm_free_tooltip", false)
		if_set_visible(var_83_6, "cm_icon_gacha", false)
		if_set(var_83_6, "txt_summon", T(arg_83_4.name))
		if_set(var_83_6, "cost", arg_83_4.price)
		if_set_sprite(var_83_6, "icon_res", "item/" .. DB("item_token", arg_83_4.token, {
			"icon"
		}) .. ".png")
	end
	
	local var_83_7 = arg_83_2:getChildByName("bi")
	local var_83_8 = DB("gacha_ui_list", arg_83_4.id, "gacha_ui_id")
	local var_83_9 = DB("gacha_ui", var_83_8, "bi_banner")
	
	if_set_sprite(var_83_7, nil, "banner/" .. var_83_9 .. ".png")
end

function GachaIntroduceBG.Special.onBeforeDraw(arg_84_0)
	if arg_84_0.vars and get_cocos_refid(arg_84_0.vars.texture) then
		local var_84_0 = cc.Director:getInstance():getDeltaTime()
		
		arg_84_0.vars.pickup_portrait:update(var_84_0)
		arg_84_0.vars.texture:beginWithClear(0, 0, 0, 0)
		arg_84_0.vars.pickup_portrait:visit()
		arg_84_0.vars.texture:endToLua()
	end
end

function GachaIntroduceBG.Special.setupCurrentCharacterToOpeningUI(arg_85_0)
	arg_85_0.vars.texture, arg_85_0.vars.pickup_portrait = GachaIntroduceBG.Util:setupCurrentCharacterToOpeningUI(arg_85_0.vars.opening_ui, arg_85_0.vars.current_pickup_code)
end

function GachaIntroduceBG.Special.createOpeningUI(arg_86_0, arg_86_1)
	arg_86_0.vars.opening_ui = GachaIntroduceBG.Util:createOpeningUI()
	
	arg_86_0.vars.opening_ui:setLocalZOrder(-99999)
	arg_86_1:addChild(arg_86_0.vars.opening_ui)
end

function GachaIntroduceBG.Special.nextPickup(arg_87_0)
	GachaIntroduceBG.Util:defaultImplNextPickup(arg_87_0, 3000, nil)
end

function GachaIntroduceBG.Special.close(arg_88_0)
end

GachaIntroduceBG.CustomSpecial = {}

function GachaIntroduceBG.CustomSpecial.setup(arg_89_0, arg_89_1, arg_89_2, arg_89_3, arg_89_4, arg_89_5)
	arg_89_0.vars = {}
	arg_89_5 = {}
	
	if arg_89_4 and arg_89_4.gacha_customspecial and arg_89_4.gacha_customspecial.select_list then
		local var_89_0 = {}
		local var_89_1 = arg_89_4.gacha_customspecial
		local var_89_2 = {
			var_89_1.select_list[1],
			var_89_1.select_list[2]
		}
		
		for iter_89_0, iter_89_1 in ipairs(var_89_2) do
			if iter_89_1 and iter_89_1 ~= "" then
				table.insert(var_89_0, iter_89_1)
			end
		end
		
		arg_89_5 = var_89_0
	else
		arg_89_5 = {}
	end
	
	arg_89_0.vars.n_pickup = arg_89_1
	arg_89_0.vars.pickup_char_list = table.clone(arg_89_5)
	arg_89_0.vars.pickup_char_list_idx = 0
	arg_89_0.vars.current_pickup_code = nil
	
	arg_89_0:createOpeningUI(arg_89_1)
	arg_89_0:setupBI(arg_89_1, arg_89_2, arg_89_3, arg_89_4)
	print("self.vars.pickup_char_list?", arg_89_0.vars.pickup_char_list, table.count(arg_89_0.vars.pickup_char_list))
	
	if arg_89_0.vars.pickup_char_list and table.count(arg_89_0.vars.pickup_char_list) > 0 then
		arg_89_0:nextPickup()
	end
end

function GachaIntroduceBG.CustomSpecial.updateSelectedList(arg_90_0, arg_90_1)
	local var_90_0 = {}
	
	if not arg_90_1 or not arg_90_1.select_list then
		return 
	end
	
	local var_90_1 = {
		arg_90_1.select_list[1],
		arg_90_1.select_list[2]
	}
	
	for iter_90_0, iter_90_1 in ipairs(var_90_1) do
		if iter_90_1 and iter_90_1 ~= "" then
			table.insert(var_90_0, iter_90_1)
		end
	end
	
	if arg_90_0.vars.pickup_char_list and table.count(arg_90_0.vars.pickup_char_list) > 0 then
		local var_90_2 = false
		
		if table.count(arg_90_0.vars.pickup_char_list) ~= table.count(var_90_0) then
			var_90_2 = true
		else
			for iter_90_2 = 1, table.count(arg_90_0.vars.pickup_char_list) do
				if arg_90_0.vars.pickup_char_list[iter_90_2] ~= var_90_0[iter_90_2] then
					var_90_2 = true
					
					break
				end
			end
		end
		
		if not var_90_2 then
			return 
		end
	end
	
	arg_90_0.vars.pickup_char_list = var_90_0
	arg_90_0.vars.pickup_char_list_idx = 0
	arg_90_0.vars.current_pickup_code = nil
	
	if arg_90_0.vars.opening_ui then
		GachaIntroduceBG:closeWithSound(true)
		
		if arg_90_0.vars.bi and arg_90_0.vars.bi._dim then
			arg_90_0.vars.bi._dim:setOpacity(0)
		end
		
		arg_90_0.vars.opening_ui:removeFromParent()
		
		arg_90_0.vars.opening_ui = nil
	end
	
	arg_90_0:createOpeningUI(arg_90_0.vars.n_pickup)
	
	if arg_90_0.vars.pickup_char_list and table.count(arg_90_0.vars.pickup_char_list) > 0 then
		arg_90_0:nextPickup()
	end
end

function GachaIntroduceBG.CustomSpecial.setupBI(arg_91_0, arg_91_1, arg_91_2, arg_91_3, arg_91_4)
	local var_91_0 = os.time()
	local var_91_1 = load_control("wnd/" .. (arg_91_3.ui_file or "gacha_pickup_group") .. ".csb", true)
	
	arg_91_1:addChild(var_91_1)
	
	arg_91_0.vars.bi = var_91_1:findChildByName("n_standby")
	
	if_set_visible(var_91_1, "n_btn_pickup_info", true)
	if_set_visible(var_91_1, "n_btn_pickup_info_close", false)
	if_set_visible(var_91_1, "n_pickup_infolist", false)
	if_set_visible(var_91_1, "bg_deco", false)
	if_set_visible(var_91_1, "img_pickup_info", false)
	
	if arg_91_3.background then
		if_set_sprite(var_91_1, "img_pickup_bg", "banner/" .. arg_91_3.background .. ".png")
	end
	
	if_set_visible(var_91_1, "n_info_left", false)
	if_set_visible(var_91_1, "n_portrait_l", false)
	if_set_visible(var_91_1, "n_info_right", false)
	if_set_visible(var_91_1, "n_portrait_r", false)
	if_set_visible(var_91_1, "n_title_img", false)
	if_set_visible(var_91_1, "n_hero_portrait_custom", false)
	if_set_visible(var_91_1, "n_selected_info_custom", false)
	GachaUnit:updateMileageGroup("to_gpmileage2")
	
	local var_91_2 = arg_91_4.gacha.gacha_customspecial
	local var_91_3 = arg_91_2:getChildByName("n_btn_summon_2")
	
	if get_cocos_refid(var_91_3) and var_91_3:isVisible() then
		if_set_visible(var_91_3, "cm_free_tooltip", false)
		if_set_visible(var_91_3, "cm_free_tooltip2", false)
		
		local var_91_4 = var_91_3:getChildByName("btn_summon_1")
		
		if_set_visible(var_91_4, "cm_icon_gacha", false)
		if_set(var_91_4, "txt_summon", T("ui_gacha_summon_1_btn"))
		if_set(var_91_4, "cost", var_91_2.price)
		if_set_sprite(var_91_4, "icon_res", "item/" .. DB("item_token", var_91_2.token, {
			"icon"
		}) .. ".png")
		
		local var_91_5 = var_91_3:getChildByName("btn_summon_10")
		
		if_set(var_91_5, "txt_summon", T("ui_gacha_summon_10_btn"))
		if_set(var_91_5, "cost", var_91_2.price * 10)
		if_set_sprite(var_91_5, "icon_res", "item/" .. DB("item_token", var_91_2.token, {
			"icon"
		}) .. ".png")
	else
		local var_91_6 = arg_91_2:getChildByName("btn_summon")
		
		if get_cocos_refid(var_91_6) then
			var_91_6:setVisible(true)
		end
		
		if_set_visible(var_91_6, "cm_free_tooltip", false)
		if_set_visible(var_91_6, "cm_icon_gacha", false)
		if_set(var_91_6, "txt_summon", T(var_91_2.name))
		if_set(var_91_6, "cost", var_91_2.price)
		if_set_sprite(var_91_6, "icon_res", "item/" .. DB("item_token", var_91_2.token, {
			"icon"
		}) .. ".png")
	end
	
	local var_91_7 = var_91_1:getChildByName("btn_popup_info")
	
	if_set(var_91_7, "t_custom_info", T("ui_ct_gachaspecial_alret"))
	var_91_7:setName("btn_popup_info:customspecial")
	if_set(var_91_1, "n_priord_time", T("time_slash_period_y_m_d_time", timeToStringDef({
		preceding_with_zeros = true,
		start_time = arg_91_3.start_time,
		end_time = arg_91_3.end_time
	})))
	
	if to_n(arg_91_3.end_time) - var_91_0 > (GAME_STATIC_VARIABLE.summon_expire_info_time or 86400) then
		if_set_color(var_91_1, "n_priord_time", tocolor("#c89b60"))
	else
		if_set_color(var_91_1, "n_priord_time", tocolor("#6bc11b"))
	end
	
	if_set_visible(var_91_1, "n_hero_time_info", not GachaUnit:isGachaCustomSpecialSecondHalf() and to_n(arg_91_3.half_time) < to_n(arg_91_3.end_time))
	
	local var_91_8 = var_91_1:getChildByName("n_hero_time_info")
	
	if_set(var_91_8, "t_hero_time", T("ui_ct_gachaspecial_next_period_title"))
	GachaIntroduceBG.Util:setupPickupDataUI(arg_91_3, var_91_1)
end

function GachaIntroduceBG.CustomSpecial.onBeforeDraw(arg_92_0)
end

function GachaIntroduceBG.CustomSpecial.createOpeningUI(arg_93_0, arg_93_1)
	arg_93_0.vars.opening_ui = GachaIntroduceBG.Util:createOpeningUI()
	
	arg_93_0.vars.opening_ui:setLocalZOrder(-99999)
	arg_93_1:addChild(arg_93_0.vars.opening_ui)
end

function GachaIntroduceBG.CustomSpecial.setupCurrentCharacterToOpeningUI(arg_94_0, arg_94_1)
	arg_94_0.vars.texture, arg_94_0.vars.pickup_portrait = GachaIntroduceBG.Util:setupCurrentCharacterToOpeningUI(arg_94_0.vars.opening_ui, arg_94_0.vars.current_pickup_code)
end

function GachaIntroduceBG.CustomSpecial.nextPickup(arg_95_0)
	GachaIntroduceBG.Util:defaultImplNextPickup(arg_95_0)
end

function GachaIntroduceBG.CustomSpecial.close(arg_96_0)
end

GachaIntroduceBG.CustomGroup = {}

function GachaIntroduceBG.CustomGroup.setup(arg_97_0, arg_97_1, arg_97_2, arg_97_3, arg_97_4, arg_97_5)
	arg_97_0.vars = {}
	
	local var_97_0 = arg_97_3
	
	if var_97_0 and var_97_0.select_list then
		arg_97_5 = arg_97_5 or var_97_0.select_list
	else
		arg_97_5 = GachaIntroduceBG.Util:createPoolFromRawList(arg_97_3.raw_list)
	end
	
	arg_97_0.vars.n_pickup = arg_97_1
	arg_97_0.vars.pickup_char_list = arg_97_5
	arg_97_0.vars.pickup_char_list_idx = 0
	arg_97_0.vars.current_pickup_code = nil
	
	arg_97_0:createOpeningUI(arg_97_1)
	arg_97_0:setupBI(arg_97_1, arg_97_2, arg_97_3, arg_97_4)
	
	if var_97_0.select_list then
		arg_97_0:nextPickup()
	end
end

function GachaIntroduceBG.CustomGroup.setupBI(arg_98_0, arg_98_1, arg_98_2, arg_98_3, arg_98_4)
	local var_98_0 = load_control("wnd/" .. (arg_98_3.ui_file or "gacha_pickup_group") .. ".csb", true)
	
	arg_98_1:addChild(var_98_0)
	
	arg_98_0.vars.n_pickup_ui = var_98_0
	arg_98_0.vars.bi = var_98_0:findChildByName("n_standby")
	
	if_set_visible(var_98_0, "n_btn_pickup_info", true)
	if_set_visible(var_98_0, "n_btn_pickup_info_close", false)
	if_set_visible(var_98_0, "n_pickup_infolist", false)
	if_set_visible(var_98_0, "bg_deco", false)
	if_set_visible(var_98_0, "img_pickup_info", false)
	
	if arg_98_3.background then
		if_set_sprite(var_98_0, "img_pickup_bg", "banner/" .. arg_98_3.background .. ".png")
	end
	
	if_set_visible(var_98_0, "n_info_left", false)
	if_set_visible(var_98_0, "n_portrait_l", false)
	if_set_visible(var_98_0, "n_info_right", false)
	if_set_visible(var_98_0, "n_portrait_r", false)
	if_set_visible(var_98_0, "n_title_img", false)
	if_set_visible(var_98_0, "n_hero_portrait_custom", false)
	if_set_visible(var_98_0, "n_selected_info_custom", false)
	GachaUnit:updateMileageGroup("to_gpmileage1")
	arg_98_0:updateUI(var_98_0, arg_98_2, arg_98_3, arg_98_4)
end

function GachaIntroduceBG.CustomGroup.updateUIByGroupSelected(arg_99_0, arg_99_1, arg_99_2, arg_99_3)
	arg_99_0:updateUI(arg_99_0.vars.n_pickup_ui, arg_99_1, arg_99_2, arg_99_3)
	
	local var_99_0 = {}
	
	if arg_99_2 and arg_99_2.select_list then
		var_99_0 = arg_99_2.select_list
	end
	
	local var_99_1 = false
	
	if table.count(var_99_0) ~= table.count(arg_99_0.vars.pickup_char_list) then
		var_99_1 = true
	end
	
	if not var_99_1 then
		for iter_99_0, iter_99_1 in pairs(arg_99_0.vars.pickup_char_list) do
			if not var_99_0[iter_99_0] or var_99_0[iter_99_0] ~= iter_99_1 then
				var_99_1 = true
				
				break
			end
		end
	end
	
	if var_99_1 then
		arg_99_0.vars.pickup_char_list = var_99_0
		arg_99_0.vars.pickup_char_list_idx = 0
		arg_99_0.vars.current_pickup_code = nil
		
		if arg_99_0.vars.opening_ui then
			GachaIntroduceBG:closeWithSound(true)
			
			if arg_99_0.vars.bi and arg_99_0.vars.bi._dim then
				arg_99_0.vars.bi._dim:setOpacity(0)
			end
			
			arg_99_0.vars.opening_ui:removeFromParent()
			
			arg_99_0.vars.opening_ui = nil
		end
		
		if table.count(arg_99_0.vars.pickup_char_list) > 0 then
			arg_99_0:createOpeningUI(arg_99_0.vars.n_pickup)
			arg_99_0:nextPickup()
		end
	end
end

function GachaIntroduceBG.CustomGroup.updateUI(arg_100_0, arg_100_1, arg_100_2, arg_100_3, arg_100_4)
	local var_100_0 = arg_100_4.gacha.gacha_customgroup
	local var_100_1 = arg_100_2:getChildByName("n_btn_summon_2")
	
	if get_cocos_refid(var_100_1) and var_100_1:isVisible() then
		if_set_visible(var_100_1, "cm_free_tooltip", false)
		if_set_visible(var_100_1, "cm_free_tooltip2", false)
		
		local var_100_2 = var_100_1:getChildByName("btn_summon_1")
		
		if_set_visible(var_100_2, "cm_icon_gacha", false)
		if_set(var_100_2, "txt_summon", T("ui_gacha_summon_1_btn"))
		if_set(var_100_2, "cost", var_100_0.price)
		if_set_sprite(var_100_2, "icon_res", "item/" .. DB("item_token", var_100_0.token, {
			"icon"
		}) .. ".png")
		
		local var_100_3 = var_100_1:getChildByName("btn_summon_10")
		
		if_set(var_100_3, "txt_summon", T("ui_gacha_summon_10_btn"))
		if_set(var_100_3, "cost", var_100_0.price * 10)
		if_set_sprite(var_100_3, "icon_res", "item/" .. DB("item_token", var_100_0.token, {
			"icon"
		}) .. ".png")
		
		local var_100_4 = GachaUnit:isUnlockCustomGroup() and GachaUnit:checkGachaCustomGroupSelectCompleted()
		
		if_set_visible(var_100_1, "icon_locked_summon_1", not var_100_4)
		if_set_visible(var_100_1, "icon_locked_summon_10", not var_100_4)
	else
		local var_100_5 = arg_100_2:getChildByName("btn_summon")
		
		if get_cocos_refid(var_100_5) then
			var_100_5:setVisible(true)
		end
		
		if_set_visible(var_100_5, "cm_free_tooltip", false)
		if_set_visible(var_100_5, "cm_icon_gacha", false)
		if_set(var_100_5, "txt_summon", T(var_100_0.name))
		if_set(var_100_5, "cost", var_100_0.price)
		if_set_sprite(var_100_5, "icon_res", "item/" .. DB("item_token", var_100_0.token, {
			"icon"
		}) .. ".png")
	end
	
	local var_100_6 = arg_100_1:getChildByName("n_date")
	
	if get_cocos_refid(var_100_6) then
		var_100_6:setVisible(true)
		
		if to_n(arg_100_3.summon_count) > 0 then
			if_set_visible(var_100_6, "btn_select_target", false)
			if_set_visible(var_100_6, "icon_locked_select", false)
			
			local var_100_7 = arg_100_1:getChildByName("n_selected_info_custom")
			local var_100_8 = var_100_7:getChildByName("selected_02")
			local var_100_9 = var_100_7:getChildByName("selected_02_move")
			
			var_100_8:setPositionY(var_100_9:getPositionY())
		else
			if_set(var_100_6:getChildByName("btn_select_target"), "label", T("ui_gacha_customgroup_select_btn"))
			if_set_visible(var_100_6, "btn_select_target", true)
		end
		
		local var_100_10 = DB("item_token", "to_gpmileage1", {
			"name"
		})
		local var_100_11 = arg_100_1:getChildByName("btn_popup_info")
		
		if var_100_11 then
			if_set(var_100_11, "t_group_info", T("gacha_customgroup_info_title"))
			var_100_11:setName("btn_popup_info:customgroup")
		end
	end
	
	GachaIntroduceBG.Util:setupPickupDataUI(arg_100_3, arg_100_1)
	
	local var_100_12 = arg_100_3 and arg_100_3.select_list
	
	if_set_visible(arg_100_1, "bi", not var_100_12)
	if_set_visible(arg_100_1, "info_txt", not var_100_12)
end

function GachaIntroduceBG.CustomGroup.onBeforeDraw(arg_101_0)
end

function GachaIntroduceBG.CustomGroup.createOpeningUI(arg_102_0, arg_102_1)
	arg_102_0.vars.opening_ui = GachaIntroduceBG.Util:createOpeningUI()
	
	arg_102_0.vars.opening_ui:setLocalZOrder(-99999)
	arg_102_1:addChild(arg_102_0.vars.opening_ui)
end

function GachaIntroduceBG.CustomGroup.setupCurrentCharacterToOpeningUI(arg_103_0)
	arg_103_0.vars.texture, arg_103_0.vars.pickup_portrait = GachaIntroduceBG.Util:setupCurrentCharacterToOpeningUI(arg_103_0.vars.opening_ui, arg_103_0.vars.current_pickup_code)
end

function GachaIntroduceBG.CustomGroup.nextPickup(arg_104_0)
	GachaIntroduceBG.Util:defaultImplNextPickup(arg_104_0, 3000)
end

function GachaIntroduceBG.CustomGroup.close(arg_105_0)
end

GachaIntroduceBG.PickUp = {}

function GachaIntroduceBG.PickUp.setup(arg_106_0, arg_106_1, arg_106_2, arg_106_3, arg_106_4, arg_106_5)
	arg_106_0.vars = {}
	
	local var_106_0 = arg_106_4.right_character
	
	arg_106_0:setupOpeningUI(arg_106_1, arg_106_2, arg_106_3, arg_106_4, arg_106_5)
	
	local var_106_1 = 3000
	local var_106_2 = 500
	
	UIAction:Add(SEQ(DELAY(var_106_1 - 500), CALL(function()
		local var_107_0 = arg_106_0.vars.n_pickup:getLocalZOrder()
		
		GachaIntroduceBG.BG:begin(arg_106_1, var_106_0, var_107_0 - 1, function()
			arg_106_0:openingSequence()
		end)
	end), DELAY(500), CALL(function()
		GachaIntroduceBG.BG:startSkillBySelfData()
	end), RLOG(FADE_OUT(var_106_2))), arg_106_0.vars.bi, "gacha_event_list")
end

function GachaIntroduceBG.PickUp.openingSequence(arg_110_0)
	arg_110_0.vars.bi:setOpacity(0)
	
	local var_110_0 = 500
	local var_110_1 = 500
	local var_110_2 = 8000
	
	UIAction:Add(SEQ(CALL(function()
		SoundEngine:play("event:/ui/new_hero/hero_appearance_end")
	end), LOG(FADE_IN(var_110_0)), DELAY(var_110_2), CALL(function()
		GachaIntroduceBG.BG:startSkillBySelfData()
	end), RLOG(FADE_OUT(var_110_1))), arg_110_0.vars.bi, "gacha_event_list")
end

function GachaIntroduceBG.PickUp.close(arg_113_0)
	UIAction:Remove("gacha_event_list")
end

function GachaIntroduceBG.PickUp.setupOpeningUI(arg_114_0, arg_114_1, arg_114_2, arg_114_3, arg_114_4, arg_114_5)
	local var_114_0 = load_control("wnd/" .. (arg_114_4.ui_file or "gacha_pickup_no_date") .. ".csb", true)
	
	if not get_cocos_refid(arg_114_1) then
		return 
	end
	
	arg_114_1:addChild(var_114_0)
	
	arg_114_0.vars.bi = var_114_0:getChildByName("n_standby")
	
	GachaUnit:setTitle(var_114_0, arg_114_3, arg_114_4)
	if_set_visible(var_114_0, "n_btn_pickup_info", true)
	if_set_visible(var_114_0, "n_btn_pickup_info_close", false)
	
	local var_114_1 = SpriteCache:getSprite("banner/" .. arg_114_4.background .. ".png")
	local var_114_2 = var_114_0:getChildByName("n_bg")
	
	if var_114_2 and var_114_1 then
		var_114_2:addChild(var_114_1)
	else
		Log.e("Not Exist Background : ", arg_114_4.background)
	end
	
	if_set_sprite(var_114_0, "img_pickup_bg", "banner/" .. arg_114_4.background .. ".png")
	if_set_visible(var_114_0, "n_info_left", false)
	if_set_visible(var_114_0, "n_portrait_l", false)
	if_set_visible(var_114_0, "n_info_right", false)
	if_set_visible(var_114_0, "n_portrait_r", false)
	if_set_visible(var_114_0, "n_title_img", false)
	GachaUnit:updatePickupCharacterUI(arg_114_2, var_114_0, arg_114_5, arg_114_4)
	
	if arg_114_4.ceiling_character then
		GachaUnit:setRecommendTag(arg_114_2, arg_114_4.ceiling_character)
	end
	
	if_set_visible(var_114_0, "btn_popup_info", arg_114_4.limit ~= nil)
	GachaUnit:updatePickupInfoUIListview(arg_114_2, arg_114_4.pickup_gacha_list)
	
	arg_114_0.vars.n_pickup = var_114_0
end

function GachaIntroduceBG.PickUp.getPickupNode(arg_115_0)
	return arg_115_0.vars.n_pickup
end

GachaIntroduceBG.BG = {}

function GachaIntroduceBG.BG.begin(arg_116_0, arg_116_1, arg_116_2, arg_116_3, arg_116_4)
	if not get_cocos_refid(arg_116_1) then
		return 
	end
	
	if GachaIntroduceBG.Util:checkNotValid() then
		print("REJECT!!!!!")
		
		return 
	end
	
	GachaIntroduceBG.Util:setSilent()
	SoundEngine:collectStart()
	
	arg_116_0.vars = {}
	arg_116_0.vars.layer = arg_116_1
	arg_116_0.vars.char_id = arg_116_2
	
	local var_116_0 = cc.Node:create()
	
	arg_116_0.vars.parent_node = var_116_0
	
	arg_116_1:addChild(var_116_0)
	var_116_0:setLocalZOrder(arg_116_3)
	
	local var_116_1
	local var_116_2 = cc.Scheduler:create()
	
	var_116_0:setScheduler(var_116_2)
	CocosSchedulerManager:addScheduler(var_116_2, "gacha")
	CocosSchedulerManager:useCustomSchForPoll("gacha")
	
	local var_116_3 = CocosSchedulerManager:getCurrentSchForPoll()
	local var_116_4
	
	local function var_116_5(arg_117_0)
		if not CocosSchedulerManager:isUseCustomSchForPoll() then
			return 
		end
		
		if tolua.type(arg_117_0) ~= "yuna2d.SimplePostProcessLayer" then
			arg_117_0:setScheduler(var_116_3)
		end
		
		var_116_4(arg_117_0)
		
		if not arg_117_0._addChild then
			arg_117_0._addChild = arg_117_0.addChild
		end
		
		function arg_117_0.addChild(arg_118_0, arg_118_1)
			if not CocosSchedulerManager:isUseCustomSchForPoll() then
				return 
			end
			
			var_116_5(arg_118_1)
			
			if arg_118_1.body then
				var_116_5(arg_118_1.body)
			end
			
			arg_118_0:_addChild(arg_118_1)
		end
	end
	
	function var_116_4(arg_119_0)
		for iter_119_0, iter_119_1 in pairs(arg_119_0:getChildren()) do
			var_116_5(iter_119_1)
			
			if iter_119_1.body then
				var_116_5(iter_119_1.body)
			end
		end
	end
	
	var_116_5(var_116_0)
	BattleAction:Resume()
	Action:Resume()
	
	if var_116_3 then
		var_116_3:setTimeScale(BATTLE_TIME_SCALE_X2)
	end
	
	local var_116_6 = GachaIntroduceBG.DB:getByCharID(arg_116_0.vars.char_id)
	
	var_116_6.player1 = var_116_6.char_id
	var_116_6.bg = var_116_6.stage_bg
	var_116_6.skill_number = to_n(var_116_6.skill_number)
	var_116_6.player_slot_number = 1
	
	CharPreviewViewer:Init(var_116_0, var_116_6.bg)
	
	local var_116_7 = {}
	local var_116_8 = {}
	
	for iter_116_0 = 1, 4 do
		local var_116_9 = "player" .. iter_116_0
		local var_116_10 = "skin" .. iter_116_0
		
		if var_116_6[var_116_9] ~= "" then
			var_116_7[iter_116_0] = var_116_6[var_116_9]
			var_116_8[iter_116_0] = var_116_6[var_116_10]
		end
	end
	
	local var_116_11 = {}
	local var_116_12 = {}
	
	for iter_116_1 = 1, 3 do
		local var_116_13 = "front" .. iter_116_1
		local var_116_14 = "back" .. iter_116_1
		
		var_116_11[iter_116_1] = var_116_6[var_116_13]
		var_116_12[iter_116_1] = var_116_6[var_116_14]
	end
	
	local var_116_15 = {
		var_116_11[1],
		var_116_11[2],
		var_116_11[3],
		var_116_12[1],
		var_116_12[2],
		var_116_12[3]
	}
	
	CharPreviewViewer:MakeTeamForStory(var_116_7, FRIEND, var_116_8)
	CharPreviewViewer:MakeTeam(var_116_15, ENEMY)
	CharPreviewViewer:MakeLayouts()
	BGIManager:getBGI().ppeffect_layer:setPositionX(-175)
	
	local var_116_16 = 0
	
	if string.find(var_116_6.target_slot_number, "back") then
		var_116_16 = 3
	end
	
	arg_116_0.vars.data = var_116_6
	arg_116_0.vars.enemy_index = var_116_16
	arg_116_0.vars.parent_node = var_116_0
	arg_116_0.vars.seq_callback = arg_116_4
end

function GachaIntroduceBG.BG.getLayer(arg_120_0)
	return arg_120_0.vars.parent_node
end

function GachaIntroduceBG.BG.startSkillBySelfData(arg_121_0)
	if not arg_121_0.vars then
		return 
	end
	
	arg_121_0:startSkill(arg_121_0.vars.parent_node, arg_121_0.vars.data, arg_121_0.vars.enemy_index, arg_121_0.vars.seq_callback)
end

function GachaIntroduceBG.BG.startSkill(arg_122_0, arg_122_1, arg_122_2, arg_122_3, arg_122_4)
	if GachaIntroduceBG.Util:checkNotValid() then
		print("REJECT!!!!!")
		
		return 
	end
	
	local var_122_0 = to_n(string.sub(arg_122_2.target_slot_number, -1, -1))
	
	GachaIntroduceBG.Util:setVolume()
	CharPreviewViewer:UseSkill(arg_122_2.skill_number, true, arg_122_2.player_slot_number, arg_122_3 + var_122_0)
	print("UIAction:Add?!", get_cocos_refid(arg_122_1))
	UIAction:Add(SEQ(COND_LOOP(DELAY(10), function()
		if not Battle:isPlayingBattleAction() then
			return true
		end
	end), DELAY(450), CALL(function()
		if arg_122_4 then
			arg_122_4()
		else
			arg_122_0:startSkill(arg_122_0.vars.parent_node, arg_122_0.vars.data, arg_122_0.vars.enemy_index)
		end
	end)), arg_122_1, "gibg_skill.active_check")
end

function GachaIntroduceBG.BG.close(arg_125_0)
	if arg_125_0.vars then
		print("self.vars.parent_node ?", get_cocos_refid(arg_125_0.vars.parent_node))
		print("self.vars.getCurrentSchForPoll ?", CocosSchedulerManager:getCurrentSchForPoll(), get_cocos_refid(CocosSchedulerManager:getCurrentSchForPoll()))
	end
	
	if arg_125_0.vars and get_cocos_refid(arg_125_0.vars.parent_node) then
		arg_125_0.vars.parent_node:removeAllChildren()
		arg_125_0.vars.parent_node:removeFromParent()
	end
	
	StageStateManager:reset()
	CameraManager:resetDefault()
	ShakeManager:resetDefault()
	CocosSchedulerManager:removeCustomSchForPoll()
	
	if arg_125_0.vars then
		UIAction:Remove("gibg_skill.active_check")
		UIAction:Remove("gibg_skill")
		BattleAction:RemoveAll()
		BattleAction:Resume()
		CharPreviewViewer:Destroy()
		
		local var_125_0 = CocosSchedulerManager:getCurrentSchForPoll()
		
		if var_125_0 then
			var_125_0:setTimeScale(BATTLE_TIME_SCALE_X0)
		end
		
		arg_125_0.vars = nil
	end
end
