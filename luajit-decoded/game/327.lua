UnitSummonResult = {}

function UnitSummonResult.is_new(arg_1_0)
	if not arg_1_0.vars or not arg_1_0.vars.new_codes or not arg_1_0.vars.code then
		return false
	end
	
	return arg_1_0.vars.new_codes[arg_1_0.vars.code] == true
end

function UnitSummonResult.createUnitModel(arg_2_0, arg_2_1)
	if not arg_2_1 then
		return 
	end
	
	local var_2_0 = CACHE:getModel(arg_2_1.db)
	
	var_2_0:setScale(arg_2_1.db.scale * 3)
	var_2_0:setPosition(0, 0)
	var_2_0:loadTexture()
	var_2_0:createShadow()
	
	return var_2_0
end

function UnitSummonResult.loadDlgGachaAll(arg_3_0)
	local var_3_0 = load_dlg("gacha", true, "wnd", function()
		arg_3_0:close()
	end)
	local var_3_1 = load_control("wnd/gacha_result_unit.csb")
	
	var_3_0:addChild(var_3_1)
	
	local var_3_2 = load_control("wnd/gacha_result_artifact.csb")
	
	var_3_0:addChild(var_3_2)
	
	return var_3_0
end

function UnitSummonResult.showResultUI(arg_5_0, arg_5_1)
	if get_cocos_refid(arg_5_0.vars.gacha_layer) then
		arg_5_0.vars.gacha_layer:removeChild(arg_5_0.vars.ui_wnd)
	end
	
	arg_5_0.vars.ui_wnd = arg_5_0:loadDlgGachaAll()
	
	arg_5_0.vars.ui_wnd:getChildByName("n_skip"):setVisible(false)
	arg_5_0.vars.ui_wnd:getChildByName("n_before"):setVisible(false)
	arg_5_0.vars.ui_wnd:getChildByName("n_right_menu"):setVisible(false)
	arg_5_0.vars.ui_wnd:setOpacity(0)
	
	local var_5_0 = arg_5_0.vars.ui_wnd:getChildByName("n_result")
	local var_5_1 = arg_5_0.vars.ui_wnd:getChildByName("n_result_artifact")
	
	if arg_5_0.vars.gacha_type == "character" then
		var_5_0:setVisible(true)
		var_5_1:setVisible(false)
		
		local var_5_2 = var_5_0:getChildByName("n_buttons")
		local var_5_3 = var_5_0:getChildByName("n_buttons_ext")
		
		if_set_visible(var_5_0, "n_buttons_back", false)
		var_5_2:setVisible(false)
		var_5_3:setVisible(true)
		UIUtil:setUnitAllInfo(var_5_0, arg_5_0.vars.unit, {
			use_basic_star = true
		})
		
		local var_5_4 = var_5_0:getChildByName("txt_name")
		
		if_call(var_5_0, "star1", "setPositionX", 10 + var_5_4:getContentSize().width * var_5_4:getScaleX() + var_5_4:getPositionX())
		if_set_visible(var_5_0, "star1", not arg_5_0.vars.is_classchange)
		var_5_0:getChildByName("txt_story"):setString(T(DB("character", arg_5_0.vars.code, "2line"), "text"))
		if_set_visible(arg_5_0.vars.ui_wnd, "n_name_top", not arg_5_0.vars.unit:isSummon())
		
		local var_5_5 = var_5_0:getChildByName("n_more_info")
		local var_5_6 = DB("character", arg_5_0.vars.code, {
			"grade"
		})
		
		WidgetUtils:setupPopup({
			control = var_5_5:getChildByName("btn_more_info"),
			creator = function()
				return UIUtil:getCharacterPopup({
					skill_preview = true,
					use_basic_star = true,
					lv = 1,
					code = arg_5_0.vars.code,
					grade = var_5_6
				})
			end
		})
		if_set_visible(var_5_5, "btn_more_info", false)
		
		local var_5_7 = UnitInfosUtil:getCharacterVoiceName(arg_5_0.vars.code)
		
		if_set_visible(var_5_5, "n_cv", var_5_7)
		if_set(var_5_5, "txt_cv", var_5_7)
		
		local var_5_8 = var_5_0:getChildByName("n_new")
		
		if var_5_8 and arg_5_0.vars.is_new then
			local var_5_9 = SpriteCache:getSprite("img/gacha_new.png")
			
			var_5_8:addChild(var_5_9)
		end
		
		local var_5_10 = var_5_0:getChildByName("n_coin")
		
		if get_cocos_refid(var_5_10) and arg_5_0.vars.dupl_token and to_n(arg_5_0.vars.dupl_token.count) > 0 then
			var_5_10:setVisible(true)
			if_set(var_5_10, "label", T("summon_" .. arg_5_0.vars.dupl_token.code .. "_get"))
			
			local var_5_11 = arg_5_0.vars.dupl_token.code
			
			if string.starts(var_5_11, "to_") then
				var_5_11 = string.sub(var_5_11, 4, -1)
			end
			
			UIUtil:getRewardIcon(to_n(arg_5_0.vars.dupl_token.count), "to_" .. var_5_11, {
				parent = var_5_10:getChildByName("n_reward_item")
			})
		else
			if_set_visible(var_5_0, "n_coin", false)
		end
		
		arg_5_0.vars.gacha_layer:addChild(arg_5_0.vars.ui_wnd, 100)
		UIAction:Add(SEQ(DELAY(arg_5_1), CALL(if_set_visible, var_5_5, "btn_more_info", true), FADE_IN(300), CALL(function()
			UnitSummonResult:newCharacterIntro()
			TutorialGuide:onCharacterResult(arg_5_0.vars.code)
		end)), arg_5_0.vars.ui_wnd, "block")
	else
		var_5_0:setVisible(false)
		var_5_1:setVisible(true)
		
		local var_5_12 = var_5_1:getChildByName("n_buttons")
		local var_5_13 = var_5_1:getChildByName("n_buttons_ext")
		
		if_set_visible(var_5_1, "n_buttons_back", false)
		var_5_12:setVisible(false)
		var_5_13:setVisible(true)
		
		local var_5_14 = var_5_1:getChildByName("n_skill"):getChildByName("cm_tooltipbox")
		local var_5_15 = UIUtil:setTextAndReturnHeight(var_5_14:getChildByName("txt_skill_desc"))
		local var_5_16 = {
			wnd = var_5_1,
			equip = arg_5_0.vars.equip
		}
		
		var_5_16.no_resize = true
		var_5_16.no_resize_name = true
		var_5_16.txt_name = var_5_1:getChildByName("txt_name")
		
		ItemTooltip:updateItemInformation(var_5_16)
		
		local var_5_17 = UIUtil:setTextAndReturnHeight(var_5_14:getChildByName("txt_skill_desc"))
		local var_5_18, var_5_19 = DB("equip_item", arg_5_0.vars.code, {
			"artifact_grade",
			"role"
		})
		local var_5_20 = var_5_1:getChildByName("n_role")
		local var_5_21 = 0
		
		if var_5_19 then
			if_set_sprite(var_5_20, "role", "img/cm_icon_role_" .. var_5_19 .. ".png")
			if_set(var_5_20, "txt_role", T("ui_artifact_detail_sub_role", {
				role = T("ui_hero_role_" .. var_5_19)
			}))
			var_5_20:setVisible(true)
			
			var_5_21 = 42
		else
			var_5_20:setVisible(false)
		end
		
		local var_5_22 = var_5_1:getChildByName("n_more_info")
		
		var_5_22:setPositionY(var_5_22:getPositionY() - var_5_21)
		WidgetUtils:setupPopup({
			control = var_5_22:getChildByName("btn_more_info"),
			creator = function()
				return ItemTooltip:getItemTooltip({
					artifact_popup = true,
					code = arg_5_0.vars.code,
					grade = var_5_18,
					equip = arg_5_0.vars.equip,
					equip_stat = equip.stats
				})
			end
		})
		if_set_visible(var_5_22, "btn_more_info", false)
		
		local var_5_23 = var_5_1:getChildByName("n_new")
		
		if var_5_23 and arg_5_0.vars.is_new then
			local var_5_24 = SpriteCache:getSprite("img/gacha_new.png")
			
			var_5_23:addChild(var_5_24)
		end
		
		arg_5_0.vars.gacha_layer:addChild(arg_5_0.vars.ui_wnd, 100)
		UIAction:Add(SEQ(DELAY(arg_5_1), CALL(if_set_visible, var_5_22, "btn_more_info", true), FADE_IN(300)), arg_5_0.vars.ui_wnd, "block")
	end
end

function UnitSummonResult.newCharacterIntro(arg_9_0)
	if not arg_9_0.vars then
		return 
	end
	
	if arg_9_0.vars.voc_player and arg_9_0.vars.voc_player:tryStop() == false then
		return 
	end
	
	if not arg_9_0.vars.is_new then
		return 
	end
	
	arg_9_0.vars.ui_gacha_story = load_dlg("gacha_story", true, "wnd")
	
	function HANDLER.gacha_story(arg_10_0, arg_10_1)
		if arg_10_1 == "btn_next_nosound" then
			if not get_cocos_refid(arg_9_0.vars.ui_gacha_story) then
				return 
			end
			
			if arg_9_0.vars.voc_player and arg_9_0.vars.voc_player:tryStop() == false then
				return 
			end
			
			arg_9_0.vars.voc_player = nil
			
			arg_9_0.vars.gacha_layer:removeChild(arg_9_0.vars.ui_gacha_story)
			
			arg_9_0.vars.ui_gacha_story = nil
		end
	end
	
	arg_9_0.vars.gacha_layer:addChild(arg_9_0.vars.ui_gacha_story, 100)
	
	local var_9_0, var_9_1, var_9_2, var_9_3 = DB("character", arg_9_0.vars.code, {
		"face_id",
		"model_id",
		"name",
		"gacha_get"
	})
	
	if_set_visible(arg_9_0.vars.ui_gacha_story, "n_portrait", false)
	if_set_visible(arg_9_0.vars.ui_gacha_story, "vignetting", false)
	
	local var_9_4 = arg_9_0.vars.ui_gacha_story:getChildByName("n_talk")
	
	if_set(var_9_4, "txt_name", T(var_9_2))
	if_set(var_9_4, "txt_info", T(var_9_3))
	
	local var_9_5 = arg_9_0.vars.ui_gacha_story:getChildByName("n_cursor")
	
	if get_cocos_refid(var_9_5) then
		local var_9_6 = string.format("event:/voc/character/%s/evt/get", var_9_1)
		
		arg_9_0.vars.voc_player = UIHelper:playTalkVoice(var_9_6, var_9_5, var_9_5:getChildByName("move_updown"))
	end
end

function UnitSummonResult.seqSummonResult(arg_11_0, arg_11_1, arg_11_2)
	if arg_11_2 == "e" then
		arg_11_0.vars.gacha_type = "equip"
		arg_11_0.vars.equip = EQUIP:createByInfo({
			code = "ef501",
			op = {
				{
					"atk",
					10
				}
			}
		})
	elseif arg_11_2 == "c" then
		arg_11_0.vars.gacha_type = "character"
		arg_11_0.vars.unit = Account.units[2]
		arg_11_0.vars.code = Account.units[2].db.code
	end
	
	if arg_11_0.vars.gacha_type == "character" then
		if arg_11_0.vars.result_mode and string.starts(arg_11_0.vars.result_mode, "moonlight") then
			arg_11_0.vars.result.m = CACHE:getEffect("ui_gacha_book_moonlight_summon_base.cfx")
		elseif arg_11_0.vars.result_mode == "special" or arg_11_0.vars.result_mode == "special_fake" then
			arg_11_0.vars.result.m = CACHE:getEffect("ui_gacha_book_special_summon_base.cfx")
		else
			arg_11_0.vars.result.m = CACHE:getEffect("ui_gacha_book_nomal_summon_base.cfx")
		end
		
		local var_11_0 = arg_11_0.vars.result.m:getPrimitiveNode("gacha_summon_bg/circle_pos")
		
		var_11_0:setInheritScale(true)
		var_11_0:setInheritRotation(true)
		arg_11_0.vars.result.m:update(math.random())
		
		if arg_11_0.vars.unit then
			Action:Add(SEQ(DELAY(2050), CALL(function()
				local var_12_0 = arg_11_0:createUnitModel(arg_11_0.vars.unit)
				
				arg_11_0.vars.result.m:getPrimitiveNode("gacha_summon_eff_back"):addChild(var_12_0)
			end)), arg_11_0.vars.gacha_layer)
		end
		
		arg_11_0.vars.result.m:setPosition(DESIGN_WIDTH / 2, DESIGN_HEIGHT / 2)
		arg_11_0.vars.result.m:start()
		
		if arg_11_0.vars.result_mode == "normal" then
			SoundEngine:play("event:/ui/gacha/summon_result_normal")
		else
			SoundEngine:play("event:/ui/gacha/summon_result_special")
		end
		
		if arg_11_0.vars.result_mode and string.starts(arg_11_0.vars.result_mode, "moonlight") then
			SoundEngine:play("event:/ui/gacha/summon_result_moonlight")
		end
		
		arg_11_0.vars.gacha_layer:addChild(arg_11_0.vars.result.m, 50)
		UnitSummonResult:showResultUI(3600)
		arg_11_0:_showCharGet(arg_11_0.vars.code, arg_11_0.vars.ui_wnd:getChildByName("n_banner"), arg_11_0.vars.close_callback, {
			x_offset = 400,
			no_bg = true,
			delay = 3900,
			unit = arg_11_0.vars.unit
		})
	else
		if arg_11_0.vars.result_mode == "special" then
			arg_11_0.vars.result.b = CACHE:getEffect("ui_gacha_arti_special_summon_base.cfx")
			arg_11_0.vars.result.m = CACHE:getEffect("ui_gacha_arti_special_summon_card.cfx")
		else
			arg_11_0.vars.result.b = CACHE:getEffect("ui_gacha_arti_nomal_summon_base.cfx")
			arg_11_0.vars.result.m = CACHE:getEffect("ui_gacha_arti_nomal_summon_card.cfx")
		end
		
		if arg_11_0.vars.equip then
			local var_11_1 = load_control("wnd/artifact_card.csb")
			local var_11_2 = {
				wnd = var_11_1,
				equip = arg_11_0.vars.equip
			}
			
			var_11_2.no_resize = true
			var_11_2.no_resize_name = true
			var_11_2.txt_name = var_11_2.wnd:getChildByName("txt_name")
			
			ItemTooltip:updateItemInformation(var_11_2)
			var_11_1:setAnchorPoint(0.5, 0.5)
			var_11_1:setScale(2.2)
			
			local var_11_3 = arg_11_0.vars.result.m:getPrimitiveNode("ui_gacha_arti_card_front/image_anker")
			
			var_11_3:setInheritRotation(true)
			var_11_3:setVisible(false)
			var_11_3:addChild(var_11_1)
			Action:Add(SEQ(DELAY(3117), CALL(function()
				arg_11_0.vars.result.m:getPrimitiveNode("ui_gacha_arti_card_front/image_anker"):setVisible(true)
			end)), arg_11_0.vars.gacha_layer)
		end
		
		arg_11_0.vars.result.m:setPosition(DESIGN_WIDTH / 2, DESIGN_HEIGHT / 2)
		arg_11_0.vars.result.m:start()
		arg_11_0.vars.result.b:setPosition(DESIGN_WIDTH / 2, DESIGN_HEIGHT / 2)
		arg_11_0.vars.result.b:start()
		
		if arg_11_0.vars.result_mode == "normal" then
			SoundEngine:play("event:/ui/gacha/summon_result_normal")
		else
			SoundEngine:play("event:/ui/gacha/summon_result_special")
		end
		
		SoundEngine:play("event:/ui/gacha/summon_result_artifact")
		arg_11_0.vars.gacha_layer:addChild(arg_11_0.vars.result.m, 55)
		arg_11_0:playBanner(arg_11_0.vars.gacha_layer, {
			delay = 3600,
			z = 53,
			no_bg = true
		})
		arg_11_0.vars.gacha_layer:addChild(arg_11_0.vars.result.b, 50)
		UnitSummonResult:showResultUI(3600)
	end
end

function UnitSummonResult.on_btn_dedi(arg_14_0)
	DevoteTooltip:showDevoteDetail(arg_14_0.vars.unit, arg_14_0.vars.gacha_layer, {
		not_my_unit = true
	})
end

function UnitSummonResult.close(arg_15_0)
	if arg_15_0.vars.voc_player then
		if arg_15_0.vars.voc_player:tryStop() == false then
			return 
		end
		
		arg_15_0.vars.voc_player = nil
	end
	
	arg_15_0.vars.layer:removeChild(arg_15_0.vars.gacha_layer)
	
	local var_15_0 = arg_15_0.vars.layer:getChildByName("block_btn")
	
	if var_15_0 then
		arg_15_0.vars.layer:removeChild(var_15_0)
	end
	
	DevoteTooltip:close()
	BackButtonManager:pop("gacha")
	
	if SceneManager:getCurrentSceneName() ~= "gacha_unit" then
		UIUtil:removeNewUnitEffect()
		
		if UIUtil:isRemainNewUnitEffect() then
			UIUtil:playNewUnitEffect(arg_15_0.vars.layer, arg_15_0.vars.close_callback)
		elseif arg_15_0.vars.close_callback then
			local var_15_1 = arg_15_0.vars.layer:getChildByName("block_btn")
			
			if var_15_1 then
				arg_15_0.vars.layer:removeChild(var_15_1)
			end
			
			arg_15_0.vars.close_callback()
		end
	end
end

function UnitSummonResult.showResultOnly(arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
	arg_16_0.vars = {}
	arg_16_0.vars.layer = arg_16_2 or SceneManager:getRunningPopupScene()
	arg_16_0.vars.result = {}
	arg_16_0.vars.gacha_layer = cc.Layer:create()
	
	local var_16_0 = ccui.Button:create()
	
	var_16_0:setTouchEnabled(true)
	var_16_0:ignoreContentAdaptWithSize(false)
	var_16_0:setContentSize(DESIGN_WIDTH, DESIGN_HEIGHT)
	var_16_0:setPosition(DESIGN_WIDTH / 2, DESIGN_HEIGHT / 2)
	var_16_0:setName("block_btn")
	var_16_0:setLocalZOrder(999999999)
	arg_16_0.vars.gacha_layer:setLocalZOrder(1000000000)
	arg_16_0.vars.layer:addChild(var_16_0)
	arg_16_0.vars.layer:addChild(arg_16_0.vars.gacha_layer)
	
	arg_16_0.vars.close_callback = arg_16_3
	arg_16_0.vars.dupl_token = arg_16_4 and arg_16_4.dupl_token
	arg_16_0.vars.code = arg_16_1
	arg_16_0.vars.is_new = arg_16_4 and arg_16_4.is_new or false
	
	local var_16_1 = DB("character", arg_16_1, "grade")
	
	arg_16_0.vars.unit = UNIT:create({
		exp = 0,
		z = 6,
		code = arg_16_1,
		g = var_16_1
	})
	arg_16_0.vars.gacha_type = "character"
	
	arg_16_0:seqSummonResult()
end

function UnitSummonResult._showCharGet(arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
	arg_17_4 = arg_17_4 or {}
	
	local var_17_0 = arg_17_0:playBanner(arg_17_2, arg_17_4)
	
	arg_17_0.vars.close_callback = arg_17_3
	arg_17_0.vars.gacha_type = "character"
	arg_17_0.vars.code = arg_17_1
	arg_17_0.vars.dupl_token = arg_17_4 and arg_17_4.dupl_token
	arg_17_0.vars.is_classchange = arg_17_4.is_classchange
	
	if arg_17_4.is_new then
		arg_17_0.vars.is_new = arg_17_4.is_new
	end
	
	if not arg_17_4.unit then
		local var_17_1 = DB("character", arg_17_1, "grade")
		
		arg_17_0.vars.unit = UNIT:create({
			exp = 0,
			z = 6,
			code = arg_17_1,
			g = var_17_1
		})
	end
	
	arg_17_0.vars.portrait = UIUtil:getPortraitAni(DB("character", arg_17_0.vars.code, "face_id"))
	
	if arg_17_0.vars.portrait then
		arg_17_0.vars.portrait:setAnchorPoint(0.5, 0)
		arg_17_0.vars.portrait:setPosition(to_n(arg_17_4.x_offset), -100)
		var_17_0:getChildByName("n_portrait"):addChild(arg_17_0.vars.portrait)
	end
	
	if arg_17_4.is_summon then
		SoundEngine:play("event:/ui/gacha/guardian_get")
		
		arg_17_0.vars.is_new = false
		
		local var_17_2 = {}
		
		var_17_2.s0001 = "arkasus"
		var_17_2.s0002 = "zeon"
		var_17_2.s0003 = "cromcrus"
		var_17_2.s0004 = "kazran"
		
		local var_17_3 = var_17_2[arg_17_1]
		
		if var_17_3 then
			arg_17_0.vars.is_new = true
			
			arg_17_0:playVoice("voc/character/" .. var_17_3 .. "/evt/get")
		end
	end
end

function UnitSummonResult.playVoice(arg_18_0, arg_18_1)
	if get_cocos_refid(arg_18_0.played_se) then
		arg_18_0.played_se:stop()
	end
	
	arg_18_0.played_se = SoundEngine:playVoice("event:/" .. arg_18_1)
end

function UnitSummonResult.playBanner(arg_19_0, arg_19_1, arg_19_2)
	local var_19_0 = arg_19_2 or {}
	local var_19_1 = to_n(var_19_0.delay)
	local var_19_2 = arg_19_1 or SceneManager:getDefaultLayer()
	local var_19_3 = load_dlg("gacha_result", true, "wnd")
	
	if not arg_19_0.vars.gacha_layer then
		arg_19_0.vars.gacha_layer = var_19_3
	end
	
	var_19_2:addChild(var_19_3)
	var_19_3:setLocalZOrder(var_19_0.z or 1000000000)
	
	if var_19_0.no_bg then
		if_set_visible(var_19_3, "n_bg", false)
	end
	
	if var_19_0.bg or var_19_0.none_bg then
		local var_19_4 = var_19_3:getChildByName("n_bg")
		
		var_19_4:removeAllChildren()
		
		if var_19_0.none_bg then
		else
			local var_19_5 = cc.Sprite:create(var_19_0.bg)
			
			var_19_5:setPosition(DESIGN_WIDTH / 2, DESIGN_HEIGHT / 2)
			var_19_4:addChild(var_19_5)
			
			local var_19_6 = var_19_5:getContentSize()
			
			var_19_5:setScaleX(VIEW_WIDTH / var_19_6.width)
			var_19_5:setScaleY(VIEW_HEIGHT / var_19_6.height)
		end
	end
	
	if var_19_0.z then
		var_19_3:setLocalZOrder(var_19_0.z)
	end
	
	if var_19_1 > 0 then
		var_19_3:setVisible(false)
		Action:Add(SEQ(DELAY(var_19_1), SHOW(true)), var_19_3, "block")
	end
	
	Action:Add(SEQ(DELAY(var_19_1), LOG(SPAWN(ROTATE(220, -50, 0), MOVE_TO(220, VIEW_BASE_LEFT - 1)))), var_19_3:getChildByName("n_banner_top"), "block")
	Action:Add(SEQ(DELAY(var_19_1), LOG(SPAWN(ROTATE(220, -50, 0), MOVE_TO(220, VIEW_BASE_RIGHT + 1)))), var_19_3:getChildByName("n_banner_bottom"), "block")
	
	return var_19_3
end

function UnitSummonResult.ShowCharGet(arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
	arg_20_4 = arg_20_4 or {}
	arg_20_2 = arg_20_2 or SceneManager:getDefaultLayer()
	arg_20_0.vars = {
		layer = arg_20_2
	}
	
	arg_20_0:_showCharGet(arg_20_1, arg_20_2, arg_20_3, arg_20_4)
	arg_20_0:showResultUI()
end

function UnitSummonResult._test_get(arg_21_0, arg_21_1)
	arg_21_0:ShowCharGet(arg_21_1 or "s0001", nil, nil, {
		is_new = true,
		is_summon = true
	})
end
