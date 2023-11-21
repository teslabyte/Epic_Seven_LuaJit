UIUtil = {}

local var_0_0 = false
local var_0_1

function getStatName(arg_1_0)
	if not arg_1_0 then
		debug_message("invalid stat name")
		
		return "????"
	end
	
	local var_1_0 = string.gsub(arg_1_0, "_rate", "")
	
	return (T("ui_hero_stats_" .. var_1_0))
end

function getStatNameCRLF(arg_2_0)
	if not arg_2_0 then
		debug_message("invalid stat name")
		
		return "????"
	end
	
	local var_2_0 = string.gsub(arg_2_0, "_rate", "")
	
	return (T("ui_hero_stats_memory_" .. var_2_0))
end

function UIUtil.numberDigitToCharOffset(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	if type(arg_3_1) ~= "number" and type(arg_3_1) ~= "string" then
		return 
	end
	
	if not arg_3_2 or not arg_3_3 then
		return 
	end
	
	return string.len(tostring(arg_3_1)) == arg_3_2 and arg_3_3 or nil
end

function UIUtil.numberDigitsToCharOffsets(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	if type(arg_4_1) ~= "number" and type(arg_4_1) ~= "string" then
		return 
	end
	
	if not arg_4_2 or not arg_4_3 then
		return 
	end
	
	if #arg_4_2 ~= #arg_4_3 then
		Log.e("#expect_digits is not same #expect_offsets")
		
		return nil
	end
	
	local var_4_0 = {}
	
	for iter_4_0 = 1, #arg_4_2 do
		var_4_0[arg_4_2[iter_4_0]] = arg_4_3[iter_4_0]
	end
	
	local var_4_1 = string.len(tostring(arg_4_1))
	
	return var_4_0[var_4_1], var_4_1
end

function UIUtil.getSpecialIllust(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	local var_5_0 = SLOW_DB_ALL("dic_data_illust_special", arg_5_1)
	
	var_5_0 = arg_5_2 or var_5_0
	var_5_0 = var_5_0 or {}
	
	if not var_5_0.id and not arg_5_2 then
		Log.e("not exist db", arg_5_1 .. ":")
		
		return 
	end
	
	local var_5_1 = totable(var_5_0.bg).eff
	local var_5_2 = CACHE:getEffect(var_5_1, var_5_0._folder or "effect")
	local var_5_3 = {
		effect = var_5_2,
		fn = var_5_1
	}
	
	var_5_2:setPosition(DESIGN_WIDTH / 2, DESIGN_HEIGHT / 2)
	
	local var_5_4 = "control_object"
	
	for iter_5_0 = 1, 99 do
		local var_5_5 = var_5_4 .. "_" .. tostring(iter_5_0)
		
		if not var_5_0[var_5_5] then
			break
		end
		
		local var_5_6 = totable(var_5_0[var_5_5], "=", ";")
		local var_5_7 = false
		
		if var_5_6.type == "cha" then
			var_5_7 = Account:getCollectionUnit(var_5_6.cha_id) ~= nil
		end
		
		if arg_5_3 then
			var_5_7 = true
		end
		
		local var_5_8 = var_5_5 .. "_on"
		
		if var_5_0.__override_on_bone then
			if var_5_0.__override_on_bone[iter_5_0] and var_5_7 then
				var_5_8 = var_5_0.__override_on_bone[iter_5_0]
			elseif var_5_0.__override_off_bone[iter_5_0] and not var_5_7 then
				var_5_8 = var_5_0.__override_off_bone[iter_5_0]
			end
		end
		
		local var_5_9 = var_5_2:getPrimitiveNode("uieff_illust_vae2aa1_f/" .. var_5_8)
		
		if not var_5_9 then
			Log.e("BONE GET FAILED. NAME  " .. tostring(var_5_8))
			
			return 
		end
		
		local var_5_10
		local var_5_11
		local var_5_12 = false
		
		if var_5_7 then
			local var_5_13 = var_5_5 .. "_on"
			local var_5_14 = totable(var_5_0[var_5_13], "=", ";")
			local var_5_15, var_5_16, var_5_17, var_5_18 = DB("character", var_5_14.cha_id, {
				"model_id",
				"skin",
				"atlas",
				"model_opt"
			})
			
			var_5_10 = CACHE:getModel(var_5_15, var_5_16, nil, var_5_17, var_5_18)
			
			var_5_10:setAnimation(0, var_5_14.ani or "", true)
			
			local var_5_19 = var_5_5 .. "_off"
			
			if var_5_0[var_5_19] then
				local var_5_20 = totable(var_5_0[var_5_19], "=", ";")
				local var_5_21 = string.replace(var_5_20.eff, ".cfx", "") .. "_shdow"
				
				var_5_11 = CACHE:getEffect(var_5_21, "effect")
			end
			
			if var_5_14.cha_id == "c1139" or var_5_14.cha_id == "c1138" then
				var_5_12 = true
			end
		else
			local var_5_22 = var_5_5 .. "_off"
			
			if var_5_0[var_5_22] then
				local var_5_23 = totable(var_5_0[var_5_22], "=", ";")
				
				var_5_10 = CACHE:getEffect(var_5_23.eff, "effect")
			end
		end
		
		local function var_5_24(arg_6_0, arg_6_1)
			var_5_9:attach(arg_6_0)
			
			if var_5_12 and not arg_6_1 then
				arg_6_0:setScaleX(-1)
			end
			
			if arg_6_0.start_loop then
				arg_6_0:start_loop()
			elseif arg_6_0.start then
				arg_6_0:start()
			end
			
			arg_6_0:update(math.random())
		end
		
		if var_5_11 then
			var_5_24(var_5_11, true)
		end
		
		if var_5_10 then
			var_5_24(var_5_10)
		else
			Log.e("CHK CHKC CHK CHK ON TWO", var_5_5)
		end
	end
	
	return var_5_2, var_5_3
end

function UIUtil.getPortrait(arg_7_0, arg_7_1)
	local var_7_0
	
	if type(arg_7_1) == "table" then
		var_7_0 = arg_7_1.db.face_id
	else
		var_7_0 = DB("character", arg_7_1, "face_id")
	end
	
	local var_7_1 = cc.Sprite:create("face/" .. var_7_0 .. "_fu.png")
	
	if not var_7_1 then
		return cc.Sprite:create("face/20101_fu.png")
	end
	
	return var_7_1
end

function UIUtil.exceptionPortraitAni(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	arg_8_3 = arg_8_3 or {}
	
	if arg_8_2 == "npc1035" then
		local var_8_0 = CACHE:getEffect("npc_priest_red_pati.particle")
		
		var_8_0:setPositionY(var_8_0:getPositionY() + 17)
		var_8_0:setScale(0.45)
		var_8_0:start()
		arg_8_1:getBoneNode("bone118"):attach(var_8_0)
		
		local var_8_1 = CACHE:getEffect("npc_priest_blue_pati.particle")
		
		var_8_1:setPositionY(var_8_1:getPositionY() + 17)
		var_8_1:setScale(0.45)
		var_8_1:start()
		arg_8_1:getBoneNode("bone115"):attach(var_8_1)
		
		local var_8_2 = CACHE:getEffect("npc_priest_bg_pati.particle")
		
		;(arg_8_3.layer or SceneManager:getRunningNativeScene()):addChild(var_8_2)
		var_8_2:setPosition(DESIGN_WIDTH / 2, DESIGN_HEIGHT / 2)
		var_8_2:start()
	end
end

function UIUtil.closePopups(arg_9_0)
	if UIOption:isShow() then
		UIOption:close()
	end
	
	if Postbox:isShow() then
		Postbox:close()
	end
	
	if CollectionController:isShow() then
		CollectionMainUI:close()
	end
	
	if DungeonHome:isVisible() then
		DungeonHome:close()
	end
	
	if SubStoryEntrance:isVisible() then
		SubStoryEntrance:close()
	end
	
	if EpisodeAdinUI:isShow() then
		EpisodeAdinUI:close()
	end
end

function UIUtil.changeButtonState(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	if not get_cocos_refid(arg_10_1) then
		return 
	end
	
	if arg_10_2 then
		arg_10_1:setOpacity(255)
	else
		arg_10_1:setOpacity(76.5)
	end
	
	arg_10_1.active_flag = arg_10_2
	arg_10_1.deactive_reason = arg_10_3
	
	return arg_10_1
end

function UIUtil.getPortraitAniByLeaderCode(arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = DB("character", arg_11_1, "face_id")
	
	return arg_11_0:getPortraitAni(var_11_0 or arg_11_1, arg_11_2)
end

UIUtil.getPortraitAniByCode = UIUtil.getPortraitAniByLeaderCode

function UIUtil.setPortraitPositionByFaceBone(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	arg_12_2 = arg_12_2 or 0
	arg_12_3 = arg_12_3 or 0
	
	if not arg_12_1.getRawBonePosition then
		arg_12_1:setPosition(arg_12_2, arg_12_3)
		
		return 
	end
	
	local var_12_0, var_12_1 = arg_12_1:getRawBonePosition("ui_face")
	local var_12_2 = arg_12_1:getRealScaleX()
	local var_12_3 = arg_12_1:getRealScaleY()
	
	arg_12_1:setPosition(arg_12_2 - var_12_0 * var_12_2, arg_12_3 - var_12_1 * var_12_3)
end

function UIUtil.getPortraitAni(arg_13_0, arg_13_1, arg_13_2)
	if type(arg_13_1) == "table" then
		arg_13_1 = arg_13_1.db.face_id
	end
	
	arg_13_2 = arg_13_2 or {}
	
	local var_13_0
	local var_13_1 = ur.Model:create("portrait/" .. arg_13_1 .. ".scsp", "portrait/" .. arg_13_1 .. ".atlas", 1)
	
	if not var_13_1.is_err then
		var_13_1:setAnimation(0, "idle", true)
		
		if not arg_13_2.is_static_state then
			var_13_1:update(math.random())
		end
		
		if arg_13_2.parent_pos_y then
			var_13_1:setPosition(0, 0 - arg_13_2.parent_pos_y)
		else
			var_13_1:setPosition(0, 0)
		end
		
		var_13_1:setScale(1)
		var_13_1:setSkin("normal")
		
		var_13_0 = true
		
		arg_13_0:exceptionPortraitAni(var_13_1, arg_13_1, arg_13_2)
		Scheduler:addSlow(var_13_1, function()
			if var_13_1:isVisible(true) then
				set_high_fps_tick()
			end
		end, arg_13_0)
		
		return var_13_1, var_13_0
	else
		local var_13_2 = cc.Sprite:create("face/" .. arg_13_1 .. "_fu.png")
		
		if not var_13_2 then
			if arg_13_1 ~= "none.png" then
				var_13_2 = cc.Sprite:create("face/20101_fu.png")
			else
				var_13_2 = cc.Sprite:create("face/none.png")
			end
		end
		
		local var_13_3 = var_13_2:getContentSize()
		
		if not arg_13_2.pin_sprite_position_y then
			var_13_2:setPositionY(0 - var_13_3.height / 2 * 0.8)
		end
		
		return var_13_2, var_13_0
	end
end

function UIUtil.isRemainNewUnitEffect(arg_15_0, arg_15_1)
	if not arg_15_0.first_get_units then
		return false
	end
	
	return #arg_15_0.first_get_units > 0
end

function UIUtil.removeNewUnitEffect(arg_16_0)
	if not arg_16_0.first_get_units then
		return false
	end
	
	table.remove(arg_16_0.first_get_units, 1)
end

function UIUtil.resetNewUnit(arg_17_0)
	arg_17_0.first_get_units = {}
end

function UIUtil.openReview(arg_18_0, arg_18_1, arg_18_2)
	local var_18_0 = load_dlg("hero_detail_vote", true, "wnd")
	
	if_set_visible(var_18_0, "txt_rating_count", false)
	if_set_visible(var_18_0, "txt_rating", false)
	
	local var_18_1 = IS_PUBLISHER_STOVE and not ContentDisable:byAlias("eq_arti_statistics")
	
	if_set_visible(var_18_0, "btn_equip_arti", var_18_1)
	
	local var_18_2 = var_18_0:findChildByName("n_review")
	
	var_18_2:setPositionX(var_18_2:getPositionX() + 221)
	if_set_visible(var_18_0, "n_bg", true)
	Review:open({
		back_btn_hide = false,
		set_pos_x = 0,
		renew = true,
		no_portrait = true,
		code = arg_18_1,
		layer = var_18_2
	})
	Review:setLeft(var_18_0, arg_18_1, nil, {
		txt_story_name = "txt_story"
	})
	Review:setPortrait(var_18_0, arg_18_1)
	arg_18_2:addChild(var_18_0)
	
	if not var_18_2.origin_pos_x then
		var_18_2.origin_pos_x = var_18_2:getPositionX()
	end
	
	NotchManager:addListener(var_18_2, nil, function(arg_19_0, arg_19_1, arg_19_2)
		if get_cocos_refid(arg_19_0) and arg_19_0.origin_pos_x then
			arg_19_0:setPositionX(arg_19_0.origin_pos_x)
		end
	end)
	
	return var_18_0
end

function UIUtil.playNewUnitEffect(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	if arg_20_3 and #arg_20_3 > 0 then
		arg_20_0.first_get_units = {}
		
		for iter_20_0, iter_20_1 in pairs(arg_20_3) do
			table.insert(arg_20_0.first_get_units, {
				code = iter_20_1.code
			})
		end
	end
	
	arg_20_0.first_get_units = arg_20_0.first_get_units or {}
	
	if UIUtil:isRemainNewUnitEffect() then
		local var_20_0 = arg_20_0.first_get_units[1].code
		local var_20_1 = DB("character", var_20_0, "type")
		
		if var_20_0 then
			local var_20_2 = 4000
			
			if var_20_1 == "summon" then
				var_20_2 = 800
			end
			
			UIAction:Add(SEQ(CALL(function()
				if var_20_1 == "summon" or var_20_1 == "devotion" then
					UnitSummonResult:ShowCharGet(var_20_0, arg_20_1, arg_20_2, {
						is_summon = true
					})
				else
					UnitSummonResult:showResultOnly(var_20_0, arg_20_1, arg_20_2)
				end
			end), DELAY(var_20_2)), arg_20_0, "block")
		end
	end
end

function UIUtil.updateGachaUnitBar(arg_22_0, arg_22_1, arg_22_2)
	if not arg_22_2 then
		arg_22_2 = load_control("wnd/gacha_unit_bar.csb")
		
		if_set_visible(arg_22_2, "cm_icon_tmp_inven", false)
		if_set_visible(arg_22_2, "n_obtain_token", false)
	end
	
	local var_22_0 = arg_22_2:getChildByName("name")
	
	if var_22_0 == nil then
		return arg_22_2
	end
	
	if_set(var_22_0, nil, T(arg_22_1.db.name))
	if_set_visible(arg_22_2, "selected", false)
	if_set_visible(arg_22_2, "icon_alert", false)
	if_set_visible(arg_22_2, "icon_check", false)
	if_set_visible(arg_22_2, "main_bg", false)
	SpriteCache:resetSprite(arg_22_2:getChildByName("frame"), "img/gacha_10frame_" .. (arg_22_1.db.color or "") .. ".png")
	SpriteCache:resetSprite(arg_22_2:getChildByName("color_bg"), "img/gacha_10bg_" .. (arg_22_1.db.color or "") .. ".png")
	SpriteCache:resetSprite(arg_22_2:getChildByName("face_l"), "face/" .. (arg_22_1.db.face_id or "") .. "_l.png")
	SpriteCache:resetSprite(arg_22_2:getChildByName("element"), UIUtil:getColorIcon(arg_22_1))
	SpriteCache:resetSprite(arg_22_2:getChildByName("role"), "img/cm_icon_role_" .. arg_22_1.db.role .. ".png")
	
	for iter_22_0 = 1, 6 do
		if_set_visible(arg_22_2, "star" .. iter_22_0, iter_22_0 <= arg_22_1.inst.grade)
	end
	
	return arg_22_2
end

function UIUtil.updateIconLevel(arg_23_0, arg_23_1, arg_23_2, arg_23_3)
	local var_23_0 = arg_23_3 or {}
	
	if_set_visible(arg_23_1, "99", false)
	if_set_sprite(arg_23_1, "l2", "img/itxt_num" .. math.floor(arg_23_2 / 10) .. "_b.png")
	if_set_sprite(arg_23_1, "l1", "img/itxt_num" .. arg_23_2 % 10 .. "_b.png")
	
	if var_23_0.is_extention then
		local var_23_1 = tonumber(string.len(arg_23_2)) or 1
		
		if_set_visible(arg_23_1, "l2", var_23_1 == 2)
		if_set_visible(arg_23_1:getChildByName("l2"), "l+", var_23_1 == 2)
		if_set_visible(getChildByPath(arg_23_1:getChildByName("l1"), "l+"), nil, var_23_1 == 1)
		
		local var_23_2 = arg_23_1:getChildByName("up_bg_normal")
		
		if get_cocos_refid(var_23_2) and (not var_23_0.is_artifact or not var_23_0.detail) and (not var_23_0.is_enhancer or not var_23_0.is_center) then
			local var_23_3 = var_23_2:getContentSize()
			
			if var_23_1 == 2 then
				var_23_2:setContentSize(44, var_23_3.height)
				arg_23_1:getChildByName("l1"):setPositionX(-15)
			else
				var_23_2:setContentSize(39, var_23_3.height)
			end
		end
		
		if var_23_0.is_enhancer then
			if var_23_0.is_center then
				if var_23_1 == 2 then
					arg_23_1:getChildByName("l1"):setPositionX(67)
				else
					arg_23_1:getChildByName("l1"):setPositionX(61)
				end
			elseif var_23_0.is_artifact and get_cocos_refid(var_23_2) then
				local var_23_4 = var_23_2:getContentSize()
				
				if var_23_1 == 2 then
					var_23_2:setContentSize(44, var_23_4.height)
					arg_23_1:getChildByName("l1"):setPositionX(61)
				else
					var_23_2:setContentSize(39, var_23_4.height)
					arg_23_1:getChildByName("l1"):setPositionX(49)
				end
			end
		elseif var_23_0.is_artifact then
			if var_23_1 == 2 then
				arg_23_1:getChildByName("l1"):setPositionX(-12)
			else
				arg_23_1:getChildByName("l1"):setPositionX(-18)
			end
		end
	end
end

function UIUtil.updateUnitBar(arg_24_0, arg_24_1, arg_24_2, arg_24_3)
	arg_24_3 = arg_24_3 or {}
	
	local var_24_0 = arg_24_3.wnd
	local var_24_1 = arg_24_3.lv
	local var_24_2 = arg_24_3.max_lv
	local var_24_3 = arg_24_3.force_update
	local var_24_4 = arg_24_3.gray_face
	local var_24_5 = arg_24_3.show_fav
	local var_24_6 = arg_24_3.show_devote
	local var_24_7 = arg_24_3.stat_opts
	local var_24_8 = GrowthBoost:isRegistered(arg_24_2)
	local var_24_9 = arg_24_2:getLv()
	local var_24_10 = arg_24_2:getMaxLevel()
	local var_24_11 = arg_24_2:getTotalSkillLevel()
	local var_24_12 = arg_24_2:getZodiacGrade()
	local var_24_13 = arg_24_2.inst.grade
	local var_24_14
	
	if var_24_8 and not arg_24_3.ignore_growth_boost then
		local var_24_15 = arg_24_2:clone()
		
		GrowthBoost:apply(var_24_15)
		
		var_24_9 = var_24_15:getLv()
		var_24_10 = var_24_15:getMaxLevel()
		var_24_11 = var_24_15:getTotalSkillLevel()
		
		local var_24_16 = var_24_15:getZodiacGrade()
		
		var_24_13 = var_24_15.inst.grade
		var_24_1 = var_24_9
		var_24_2 = var_24_10
		
		if var_24_7 then
			if var_24_7.id == "unit_power" then
				var_24_14 = var_24_15:getPoint()
			else
				var_24_14 = var_24_15:getStatus()[var_24_7.id]
			end
		end
	end
	
	var_24_0 = var_24_0 or load_control("wnd/unit_bar.csb")
	
	if var_24_3 or not var_24_0.n_name then
		var_24_0.n_name = var_24_0:getChildByName("n_name")
		var_24_0.n_lv = var_24_0:getChildByName("n_lv")
		var_24_0.detail = var_24_0:getChildByName("detail")
		
		if var_24_0.item ~= arg_24_2 then
			if var_24_0.detail.origin_position_x then
				var_24_0.n_lv:setScaleX(var_24_0.n_lv.origin_scale_x)
				var_24_0.detail:setPositionX(var_24_0.detail.origin_position_x)
			end
			
			var_24_0.n_lv.origin_scale_x = nil
			var_24_0.detail.origin_position_x = nil
		end
		
		var_24_0.item = arg_24_2
		
		local var_24_17 = var_24_0:getChildByName("name")
		
		if var_24_17 == nil then
			return var_24_0
		end
		
		if not var_24_0.o_name_scale then
			var_24_0.o_name_scale = var_24_17:getScaleX()
		end
		
		var_24_17:setString(T(arg_24_2.db.name))
		
		local var_24_18 = var_24_17:getContentSize().width
		local var_24_19 = var_24_17:getPositionX()
		local var_24_20 = 1
		local var_24_21 = 170
		
		if arg_24_2:getUID() == Account:getMainUnitId() then
			var_24_21 = var_24_21 - 60
		end
		
		if var_24_21 < var_24_18 then
			var_24_20 = var_24_21 / var_24_18
		end
		
		var_24_17:setScaleX(var_24_20 * var_24_0.o_name_scale)
		
		var_24_1 = var_24_1 or var_24_9
		var_24_2 = var_24_2 or var_24_10
		
		if var_24_4 then
			SpriteCache:resetSprite(var_24_0:getChildByName("face"), "face/" .. (arg_24_2.db.face_id or "") .. "_l.png?grayscale=1")
		else
			SpriteCache:resetSprite(var_24_0:getChildByName("face"), "face/" .. (arg_24_2.db.face_id or "") .. "_l.png")
		end
		
		SpriteCache:resetSprite(var_24_0:getChildByName("role"), "img/cm_icon_role_" .. arg_24_2.db.role .. ".png")
		SpriteCache:resetSprite(var_24_0:getChildByName("element"), UIUtil:getColorIcon(arg_24_2))
		
		var_24_0.add = var_24_0:getChildByName("add")
		
		if var_24_0.add then
			var_24_0.add:setVisible(false)
		end
	end
	
	if var_24_0.n_name then
		local var_24_22 = var_24_0.n_name:getChildByName("main_bg")
		
		if var_24_22 then
			if arg_24_2:getUID() == Account:getMainUnitId() then
				local var_24_23 = var_24_0:getChildByName("name")
				
				var_24_22:setVisible(true)
				var_24_22:setPositionX(var_24_23:getContentSize().width * var_24_23:getScaleX() + 6)
			else
				var_24_22:setVisible(false)
			end
		end
	end
	
	local var_24_24 = arg_24_2:getHPRatio()
	local var_24_25 = arg_24_2:getAutomatonHPRatio()
	local var_24_26 = arg_24_1 == "Bistro" or not arg_24_1
	
	arg_24_0:updateEatingEndTime(var_24_0, arg_24_2)
	
	local var_24_27
	
	if string.starts(arg_24_1 or "", "Ready") then
		local var_24_28 = string.split(arg_24_1, ":")
		
		arg_24_1 = var_24_28[1]
		var_24_27 = var_24_28[2]
	end
	
	local var_24_29 = var_24_27 and Account:isMazeUsedUnit(var_24_27, arg_24_2:getUID())
	local var_24_30 = var_24_26 and var_24_24 ~= 1 and not arg_24_2:isEating()
	local var_24_31 = var_24_26 and arg_24_2:isEating()
	local var_24_32 = arg_24_1 == "clan_pvp_ready" and ClanWar:isInDeadUnits(arg_24_2)
	local var_24_33 = arg_24_1 == "ArenaNet" and ArenaNetReady:isInPickUnitList(arg_24_2)
	local var_24_34 = arg_24_1 == "ArenaNet" and ArenaNetReady:isInDuplicateClass(arg_24_2, true)
	local var_24_35 = arg_24_1 == "ArenaNet" and (ArenaNetReady:isInPreBanUnitList(arg_24_2) or ArenaNetReady:isInAccumulatePreBanUnitList(arg_24_2))
	local var_24_36 = arg_24_1 == "ArenaNet" and ArenaService:isInGlobalBanArtifact(arg_24_2)
	local var_24_37 = arg_24_1 == "ArenaNet" and ArenaService:isInGlobalBanUnit(arg_24_2)
	local var_24_38 = arg_24_1 == "ArenaNet" and ArenaService:isInGlobalBanExclusive(arg_24_2)
	local var_24_39 = arg_24_1 == "ArenaNet" and arg_24_2:isLockWorldArena()
	local var_24_40 = (SceneManager:getCurrentSceneName() == "pvp_team" or arg_24_1 == "clan_pvp_defence") and arg_24_2:isLockArenaAndClan()
	local var_24_41 = arg_24_1 == "growth_boost" and GrowthBoost:isUnregisterable(arg_24_2)
	local var_24_42 = arg_24_1 == "Automaton" and var_24_25 <= 0
	local var_24_43 = (arg_24_1 == "LotaReady" or arg_24_1 == "LotaInformation" or arg_24_1 == "LotaRegistration" or arg_24_1 == "LotaBlessing") and not LotaUserData:isUsableUnit(arg_24_2, true)
	
	if (arg_24_1 == "LotaRegistrationBelt" or arg_24_1 == "LotaRegistration") and LotaUserData:isUnregisteredCurrentDay(arg_24_2.db.code) then
		var_24_43 = true
	end
	
	var_24_0.n_sick = var_24_0:getChildByName("unit_bar_sick")
	var_24_0.n_eat = var_24_0:getChildByName("unit_bar_eat")
	
	if var_24_0.n_sick then
		var_24_0.n_sick:setVisible(var_24_30 or var_24_32 or var_24_42 or var_24_43 or var_24_29)
	end
	
	if var_24_0.n_eat then
		var_24_0.n_eat:setVisible(var_24_31)
	end
	
	if (var_24_30 or var_24_32 or var_24_42 or var_24_43 or var_24_29) and not var_24_0.n_sick then
		var_24_0.n_sick = cc.CSLoader:createNode("wnd/unit_bar_sick.csb")
		
		var_24_0.n_sick:setName("unit_bar_sick")
		var_24_0:getChildByName("n_hp"):addChild(var_24_0.n_sick)
		if_set_visible(var_24_0.n_sick, "sick_img", true)
	elseif not var_24_30 and not var_24_32 and not var_24_42 and not var_24_43 and not var_24_29 and var_24_0.n_sick then
		var_24_0.n_sick:removeFromParent()
		
		var_24_0.n_sick = nil
	end
	
	if var_24_31 and not var_24_0.n_eat then
		var_24_0.n_eat = cc.CSLoader:createNode("wnd/unit_bar_eat.csb")
		
		var_24_0.n_eat:setName("unit_bar_eat")
		var_24_0:getChildByName("n_hp"):addChild(var_24_0.n_eat)
	end
	
	if var_24_0.n_name then
		var_24_0.n_name:setOpacity(255)
		var_24_0.n_name:setVisible(not var_24_30 and not var_24_31 and not var_24_32 and not var_24_42 and not var_24_43 and not var_24_29 and not var_24_33 and not var_24_34 and not var_24_35 and not var_24_36 and not var_24_37 and not var_24_38)
	end
	
	if_set_visible(var_24_0, "resurrection", false)
	if_set(var_24_0.n_sick, "txt_resurrection", T("automtn_need_heal"))
	if_set_visible(var_24_0.n_sick, "txt_resurrection", var_24_42)
	if_set_visible(var_24_0.n_sick, "resurrection_img", var_24_42)
	if_set_visible(var_24_0, "n_blessing", var_24_8)
	
	if arg_24_1 == "LotaReady" or arg_24_1 == "LotaInformation" or arg_24_1 == "LotaRegistration" or arg_24_1 == "LotaRegistrationBelt" or arg_24_1 == "LotaBlessing" then
		if not var_24_43 then
			if var_24_0.n_sick then
				var_24_0.n_sick:removeFromParent()
				
				var_24_0.n_sick = nil
			end
		elseif var_24_43 then
			if_set_visible(var_24_0.n_sick, "sick_img", false)
			
			if var_24_0.n_name then
				var_24_0.n_name:setVisible(false)
			end
			
			local var_24_44 = var_24_0.n_sick
			
			if_set_visible(var_24_44, "do_not_use_img", true)
			if_set_visible(var_24_44, "txt_do_not_use", true)
			if_set(var_24_44, "txt_do_not_use", T("ui_clanheritage_hero_penalty"))
			if_set_visible(var_24_44, "sick_img", false)
		end
	end
	
	if arg_24_1 == "Automaton" then
		if not var_24_42 then
			if var_24_0.n_sick then
				var_24_0.n_sick:removeFromParent()
				
				var_24_0.n_sick = nil
			end
		elseif var_24_42 then
			if_set_visible(var_24_0.n_sick, "sick_img", false)
			
			if var_24_0.n_name then
				var_24_0.n_name:setVisible(false)
			end
		end
	end
	
	if var_24_26 and var_24_24 ~= 1 then
		local var_24_45
		
		if var_24_31 then
			var_24_45 = var_24_0.n_eat
		end
		
		if var_24_30 then
			var_24_45 = var_24_0.n_sick
		end
		
		local var_24_46 = var_24_45:getChildByName("hp_clip")
		
		if var_24_46 then
			var_24_46:setVisible(var_24_24 ~= 1)
			var_24_46:setContentSize({
				height = 110,
				width = var_24_0:getContentSize().width
			})
		end
		
		if var_24_30 then
			if_set_visible(var_24_0, "role", false)
			if_set(var_24_45, "txt_sick", T(arg_24_2.db.name))
		end
	end
	
	if var_24_32 then
		local var_24_47 = var_24_0.n_sick
		
		if_set_visible(var_24_0, "role", false)
		if_set_visible(var_24_0, "add", false)
		if_set(var_24_47, "txt_sick", T(arg_24_2.db.name))
	else
		if_set_visible(var_24_0, "role", true)
	end
	
	if var_24_29 then
		local var_24_48 = var_24_0.n_sick
		
		if_set_visible(var_24_48, "sick_img", false)
		if_set_visible(var_24_48, "do_not_use_img", true)
		if_set_visible(var_24_48, "txt_do_not_use", true)
		if_set(var_24_48, "txt_do_not_use", T("ui_dungeon_challenge_hero_penalty"))
		if_set_visible(var_24_48, "sick_img", false)
		if_set_visible(var_24_0, "add", false)
	end
	
	if arg_24_1 == "Automaton" and var_24_42 then
		if_set_visible(var_24_0, "add", false)
	end
	
	if var_24_33 then
		if_set_color(var_24_0, "n_unit", cc.c3b(80, 80, 80))
		if_set_visible(var_24_0, "n_state", true)
		if_set_visible(var_24_0, "n_selected", true)
		if_set_visible(var_24_0, "n_banned", false)
		if_set_visible(var_24_0, "n_banned_bg", false)
		if_set_visible(var_24_0, "n_moonlight_destiny", false)
	elseif var_24_35 or var_24_36 or var_24_37 or var_24_38 then
		if_set_color(var_24_0, "n_unit", cc.c3b(80, 80, 80))
		if_set_visible(var_24_0, "n_state", true)
		if_set_visible(var_24_0, "n_selected", false)
		if_set_visible(var_24_0, "n_banned", true)
		if_set_visible(var_24_0, "n_banned_bg", true)
		if_set_visible(var_24_0, "n_moonlight_destiny", false)
		
		if var_24_35 or var_24_37 then
			if_set(var_24_0, "txt_banned", T("pvp_rta_global_banned_hero"))
		elseif var_24_38 then
			if_set(var_24_0, "txt_banned", T("pvp_rta_global_banned_exc"))
		else
			if_set(var_24_0, "txt_banned", T("pvp_rta_global_banned_arti"))
		end
		
		local var_24_49 = var_24_0:getChildByName("txt_banned")
		local var_24_50 = var_24_49:getContentSize().width
		local var_24_51 = var_24_50 > 280 and 280 / var_24_50 or 1
		
		var_24_49:setScaleX(var_24_51 * var_24_0.o_name_scale)
	elseif var_24_34 then
		if_set_color(var_24_0, "n_unit", cc.c3b(80, 80, 80))
		if_set_visible(var_24_0, "n_state", true)
		if_set_visible(var_24_0, "n_selected", false)
		if_set_visible(var_24_0, "n_banned", true)
		if_set_visible(var_24_0, "n_banned_bg", true)
		if_set_visible(var_24_0, "n_moonlight_destiny", false)
		if_set(var_24_0, "txt_banned", T("pvp_rta_cannot_selectable_hero"))
		
		local var_24_52 = var_24_0:getChildByName("txt_banned")
		local var_24_53 = var_24_52:getContentSize().width
		local var_24_54 = var_24_53 > 280 and 280 / var_24_53 or 1
		
		var_24_52:setScaleX(var_24_54 * var_24_0.o_name_scale)
	elseif var_24_39 or var_24_40 then
		if_set_color(var_24_0, "n_unit", cc.c3b(80, 80, 80))
		if_set_visible(var_24_0, "n_state", true)
		if_set_visible(var_24_0, "n_selected", false)
		if_set_visible(var_24_0, "n_banned", false)
		if_set_visible(var_24_0, "n_banned_bg", true)
		if_set_visible(var_24_0, "n_moonlight_destiny", true)
		
		local var_24_55 = var_24_0:getChildByName("txt_moonlight_destiny")
		
		if get_cocos_refid(var_24_55) then
			if not var_24_0.txt_moonlight_destiny_scale then
				var_24_0.txt_moonlight_destiny_scale = var_24_55:getScaleX()
			end
			
			if var_24_39 then
				if_set(var_24_0, "txt_moonlight_destiny", T("character_arena_cannot_dispatch"))
			else
				if_set(var_24_0, "txt_moonlight_destiny", T("character_arena2_cannot_dispatch"))
			end
			
			local var_24_56 = var_24_55:getContentSize().width
			local var_24_57 = 1
			local var_24_58 = 235
			
			if var_24_58 < var_24_56 then
				var_24_57 = var_24_58 / var_24_56
			end
			
			var_24_55:setScaleX(var_24_57)
		end
	elseif var_24_41 then
		if_set_color(var_24_0, "n_unit", cc.c3b(80, 80, 80))
		if_set_visible(var_24_0, "n_state", true)
		if_set_visible(var_24_0, "n_selected", false)
		if_set_visible(var_24_0, "n_banned", false)
		if_set_visible(var_24_0, "n_banned_bg", false)
		if_set_visible(var_24_0, "n_moonlight_destiny", false)
	else
		if_set_color(var_24_0, "n_unit", cc.c3b(255, 255, 255))
		if_set_visible(var_24_0, "n_state", false)
		if_set_visible(var_24_0, "n_selected", false)
		if_set_visible(var_24_0, "n_banned", false)
		if_set_visible(var_24_0, "n_banned_bg", false)
		if_set_visible(var_24_0, "n_moonlight_destiny", false)
	end
	
	if arg_24_2:getSPName() == "mp" then
		local var_24_59 = var_24_0:getChildByName("mp")
		
		if var_24_59 then
			var_24_59:setPercent(arg_24_2:getMPRatio() * 100)
		end
	end
	
	if_set_visible(var_24_0, "n_mp", arg_24_2:getSPName() == "mp" and var_24_26)
	if_set_visible(var_24_0, "lock", arg_24_2:isLocked())
	
	if arg_24_1 == "SubTask" then
		if_set_visible(var_24_0.n_name, "role", false)
		if_set_visible(var_24_0, "lock", false)
		if_set_visible(var_24_0, "team", false)
	else
		if_set_visible(var_24_0, "team", arg_24_2:isInNormalTeam() or arg_24_2.isDoingSubTask and arg_24_2:isDoingSubTask())
	end
	
	local var_24_60 = arg_24_2.exclusive_noti and arg_24_2:exclusive_noti() and UnitDetailEquip:isHaveExclusiveEquip(arg_24_2)
	local var_24_61 = false
	
	if arg_24_1 == "Detail" or arg_24_1 == "Main" or arg_24_1 == "Ready" or arg_24_1 == "Automaton" or arg_24_1 == "clan_pvp_ready" or arg_24_1 == "clan_pvp_defence" then
		var_24_61 = arg_24_2:skillPointNoti()
	end
	
	if var_24_61 and SAVE:getKeep(NOTI_UNIT_SKILL_UPGRADE .. arg_24_2.inst.uid) then
		var_24_61 = false
	end
	
	if var_24_60 and SAVE:getKeep(NOTI_UNIT_EXCLUSIVE_EQUIP .. arg_24_2.inst.uid) then
		var_24_60 = false
	end
	
	if_set_visible(var_24_0, "check", (var_24_60 or var_24_61 or arg_24_2:isMerEnhanceProceeding()) and arg_24_1 ~= "Bistro" and arg_24_1 ~= "SubTask")
	
	if arg_24_1 == "SubTask" then
		arg_24_0:updateUnitBarSubTask(var_24_0, arg_24_2)
	else
		var_24_0.skip_subtask = true
	end
	
	local var_24_62 = 0
	
	if var_24_1 and not var_24_5 and not var_24_6 and not var_24_7 then
		if arg_24_1 == "SubTask" then
			var_24_2 = var_24_2 or 999999
			
			if var_24_8 then
				local var_24_63 = arg_24_2:getLv()
				local var_24_64 = arg_24_2:getMaxLevel()
				
				if_set_visible(var_24_0, "subtask_max", var_24_2 <= var_24_63)
			else
				if_set_visible(var_24_0, "subtask_max", var_24_2 <= var_24_1)
			end
			
			var_24_2 = nil
		else
			if_set_visible(var_24_0, "subtask_max", false)
		end
		
		local var_24_65
		local var_24_66
		
		var_24_62, var_24_66 = arg_24_0:setLevel(var_24_0, var_24_1, var_24_2, 6)
		
		if var_24_66 then
			var_24_0.detail:setPositionX(20)
		elseif var_24_62 > 2 then
			var_24_0.detail:setPositionX((var_24_62 - 2) * 12)
		else
			var_24_0.detail:setPositionX(0)
		end
	end
	
	if_set_visible(var_24_0.detail, "n_lv", not var_24_5 and not var_24_6 and not var_24_7)
	
	local var_24_67 = var_24_0:getChildByName("n_love")
	
	if_set_visible(var_24_67, nil, var_24_5)
	
	if var_24_5 then
		var_24_0.detail:setPositionX(11)
		arg_24_0:setFavoriteDetail(var_24_0, arg_24_2)
	end
	
	local var_24_68 = var_24_0:getChildByName("t_stat")
	
	if_set_visible(var_24_68, nil, var_24_7)
	
	if get_cocos_refid(var_24_68) and var_24_7 then
		if var_24_14 == nil then
			if var_24_7.id == "unit_power" then
				var_24_14 = arg_24_2:getPoint() or 0
			else
				var_24_14 = arg_24_2:getStatus()[var_24_7.id] or 0
			end
		end
		
		if var_24_7.unit_bar_opt == "percent" then
			if_set(var_24_68, nil, string.format("%d%%", math.percent(var_24_14)))
		else
			if_set(var_24_68, nil, var_24_14)
		end
		
		local var_24_69 = var_24_68:getContentSize().width * var_24_68:getScaleX()
		
		var_24_0.detail:setPositionX(var_24_68:getPositionX() + var_24_69 - 28)
	end
	
	local var_24_70 = var_24_0:getChildByName("n_skillup")
	
	if var_24_70 then
		var_24_70:setVisible(var_24_11 ~= 0)
		
		if var_24_11 > 0 then
			if_set(var_24_0, "skill_up", "+" .. var_24_11)
			var_24_70:setPositionX(var_24_13 * 16)
		end
	end
	
	UIUtil:setStarsByUnit(var_24_0, arg_24_2)
	
	var_24_0.zodiac = arg_24_2.inst.zodiac
	
	arg_24_0:setDevoteLevelDetail(var_24_0, arg_24_2, var_24_6)
	
	local var_24_71 = table.isInclude({
		"Sell",
		"Enhance",
		"Promote",
		"Storage"
	}, arg_24_1)
	local var_24_72 = var_24_0:getChildByName("n_dedi")
	
	if get_cocos_refid(var_24_72) then
		if var_24_71 then
			var_24_72:removeChildByName("@devote_spr")
			
			if not var_24_6 then
				local var_24_73, var_24_74 = arg_24_2:getDevoteSkill()
				
				if to_n(var_24_74) > 0 then
					local var_24_75 = arg_24_0:getDevoteSprite(arg_24_2)
					
					if get_cocos_refid(var_24_75) then
						var_24_75:setName("@devote_spr")
						var_24_75:setAnchorPoint(1, 0.5)
						var_24_72:addChild(var_24_75)
					end
				end
			end
		end
		
		if_set_visible(var_24_0, "n_dedi", var_24_71)
	end
	
	if_set_visible(var_24_0, "n_favorites", not var_24_71 and arg_24_1 ~= "SubTask" and arg_24_2:isFavoriteUnit())
	
	local var_24_76 = var_24_0:findChildByName("detail")
	
	if var_24_0.n_lv.origin_scale_x then
		var_24_0.n_lv:setScaleX(var_24_0.n_lv.origin_scale_x)
		var_24_76:setPositionX(var_24_76.origin_position_x)
	end
	
	local var_24_77 = var_24_13 > 5
	local var_24_78 = var_24_11 > 0
	
	if var_24_77 and var_24_78 and var_24_71 then
		var_24_0.n_lv.origin_scale_x = var_24_0.n_lv.origin_scale_x or var_24_0.n_lv:getScaleX()
		var_24_76.origin_position_x = var_24_76.origin_position_x or var_24_76:getPositionX()
		
		if var_24_62 == 5 then
			var_24_0.n_lv:setScaleX(var_24_0.n_lv.origin_scale_x * 0.9)
			var_24_76:setPositionX(var_24_76.origin_position_x - 10)
		elseif var_24_62 == 6 then
			var_24_0.n_lv:setScaleX(var_24_0.n_lv.origin_scale_x * 0.75)
			var_24_76:setPositionX(var_24_76.origin_position_x - 20)
		end
	end
	
	return var_24_0
end

function UIUtil.getDevoteSprite(arg_25_0, arg_25_1, arg_25_2)
	if arg_25_2 then
		local var_25_0, var_25_1 = arg_25_1:getDevoteSkill()
		
		if to_n(var_25_1) == 0 then
			return SpriteCache:getSprite("img/hero_dedi_a_none.png"), "img/hero_dedi_a_none.png"
		end
	end
	
	local var_25_2, var_25_3 = arg_25_1:getDevoteGrade()
	
	var_25_2 = var_25_2 or ""
	
	local var_25_4 = string.lower(var_25_2)
	
	return SpriteCache:getSprite(string.format("img/hero_dedi_a_%s.png", var_25_4)), string.format("img/hero_dedi_a_%s.png", var_25_4)
end

UIUtil.GREY = cc.c3b(180, 180, 180)
UIUtil.DARK_GREY = cc.c3b(80, 80, 80)
UIUtil.WHITE = cc.c3b(255, 255, 255)
UIUtil.BLUE = cc.c3b(160, 160, 255)
UIUtil.RED = cc.c3b(255, 20, 20)
UIUtil.ORANGE = cc.c3b(250, 80, 80)

function UIUtil.removeSubTaskEventListener(arg_26_0, arg_26_1)
	if not get_cocos_refid(arg_26_1) then
		return 
	end
	
	local var_26_0 = arg_26_1:findChildByName("n_subtask")
	
	if not var_26_0 then
		return 
	end
	
	local var_26_1 = var_26_0:findChildByName("icon_skill")
	
	if not var_26_1 then
		return 
	end
	
	if var_26_0.n_tasking then
		var_26_0.n_tasking = nil
	end
	
	var_26_1:removeAllChildren()
	
	var_26_1._TOUCH_LISTENER = nil
	
	return arg_26_1
end

function UIUtil.removeSubTaskEventListenerForBar(arg_27_0, arg_27_1)
	if not get_cocos_refid(arg_27_1) then
		return 
	end
	
	local var_27_0 = arg_27_1:getChildByName("n_subtask_skill")
	local var_27_1 = arg_27_1:getChildByName("n_icon_subtask_skill")
	
	if arg_27_1.n_tasking then
		arg_27_1.n_tasking = nil
	end
	
	if var_27_0 then
		local var_27_2 = var_27_0:findChildByName("icon_skill")
		
		if var_27_2._TOUCH_LISTENER then
			var_27_2._TOUCH_LISTENER:removeFromParent()
			
			var_27_2._TOUCH_LISTENER = nil
		end
	end
	
	if var_27_1 then
		local var_27_3 = var_27_1:findChildByName("icon_skill")
		
		if var_27_3._TOUCH_LISTENER then
			var_27_3._TOUCH_LISTENER:removeFromParent()
			
			var_27_3._TOUCH_LISTENER = nil
		end
	end
	
	return arg_27_1
end

function UIUtil.updateSubTaskSkillInfo(arg_28_0, arg_28_1, arg_28_2, arg_28_3)
	if not arg_28_1 then
		return 
	end
	
	local var_28_0 = arg_28_2:isDoingSubTask()
	
	if_set_visible(arg_28_1, "n_tasking", var_28_0 == true)
	
	local var_28_1 = arg_28_2:getSubTaskMissionSkill() or {}
	
	if not var_28_1 then
		if_set_visible(arg_28_1, "n_subtask_skill", false)
		if_set_visible(arg_28_1, "n_icon_subtask_skill", false)
		
		return 
	end
	
	if not arg_28_1.n_tasking then
		arg_28_1.n_tasking = arg_28_1:getChildByName("n_tasking")
		arg_28_1.n_subtask_skill = arg_28_1:getChildByName("n_subtask_skill")
		arg_28_1.n_icon_subtask_skill = arg_28_1:getChildByName("n_icon_subtask_skill")
		
		if arg_28_1.n_icon_subtask_skill then
			if var_28_1.icon then
				if_set_sprite(arg_28_1.n_icon_subtask_skill, "icon_skill", "skill/" .. var_28_1.icon)
				WidgetUtils:setupTooltip({
					delay = 0,
					control = arg_28_1.n_icon_subtask_skill:getChildByName("icon_skill"),
					creator = function()
						return UIUtil:getSubtaskSkillTooltip(arg_28_2)
					end
				})
			else
				if_set_visible(arg_28_1.n_icon_subtask_skill, "icon_skill", false)
			end
		end
		
		if arg_28_1.n_subtask_skill then
			if var_28_1.icon then
				if_set_sprite(arg_28_1.n_subtask_skill, "icon_skill", "skill/" .. var_28_1.icon)
				WidgetUtils:setupTooltip({
					delay = 0,
					control = arg_28_1.n_subtask_skill:getChildByName("icon_skill"),
					creator = function()
						return UIUtil:getSubtaskSkillTooltip(arg_28_2)
					end
				})
				if_set_visible(arg_28_1.n_subtask_skill, "icon_skill", true)
			else
				if_set_visible(arg_28_1.n_subtask_skill, "icon_skill", false)
			end
			
			if_set_visible(arg_28_1.n_subtask_skill, "icon_checked", false)
			if_set_visible(arg_28_1.n_subtask_skill, "icon_time", false)
			if_set_visible(arg_28_1.n_subtask_skill, "icon_resource", false)
			if_set_visible(arg_28_1.n_subtask_skill, "icon_condition", false)
			
			if var_28_1.effect_type == "time_reduce" then
				if_set_visible(arg_28_1.n_subtask_skill, "icon_time", true)
			elseif var_28_1.effect_type == "success_rate" then
				if_set_visible(arg_28_1.n_subtask_skill, "icon_condition", true)
			end
			
			if var_28_1.effect_value then
				local var_28_2 = arg_28_1.n_subtask_skill:getChildByName("txt_count")
				
				if var_28_2 then
					if var_28_1.effect_type == "time_reduce" then
						if_set(arg_28_1.n_subtask_skill, "txt_count", "-" .. var_28_1.effect_value * 100 .. "%")
						var_28_2:setTextColor(arg_28_0.WHITE)
					else
						if_set(arg_28_1.n_subtask_skill, "txt_count", "+" .. var_28_1.effect_value * 100 .. "%")
						var_28_2:setTextColor(cc.c3b(100, 203, 0))
					end
				end
			end
		end
	end
	
	if arg_28_1.n_subtask_skill and get_cocos_refid(arg_28_1.n_subtask_skill) and arg_28_1.n_subtask_skill:isVisible() then
		arg_28_0:setLevel(arg_28_1.n_subtask_skill, arg_28_2:getLv(), arg_28_2:getMaxLevel(), 5)
		
		if var_28_1.id then
			local var_28_3 = arg_28_2:getSubTaskSkillPoint()
			
			if_set_visible(arg_28_1.n_subtask_skill, "n_info", true)
			
			if var_28_3 > 0 then
				if_set_opacity(arg_28_1.n_subtask_skill, "n_info", 255)
			else
				if_set_opacity(arg_28_1.n_subtask_skill, "n_info", 100)
			end
		else
			if_set_visible(arg_28_1.n_subtask_skill, "n_info", false)
		end
	end
	
	if_set_visible(arg_28_1, "n_subtask_skill", var_28_0 == false)
end

function UIUtil.updateUnitBarSubTask(arg_31_0, arg_31_1, arg_31_2)
	if not arg_31_1.subtask then
		arg_31_1:getChildByName("detail"):setOpacity(0)
		
		arg_31_1.subtask = cc.CSLoader:createNode("wnd/unit_bar_subtask.csb")
		
		local var_31_0 = arg_31_1:getChildByName("n_name")
		
		var_31_0:removeFromParent()
		arg_31_1.subtask:addChild(var_31_0)
		var_31_0:setPositionX(50)
		if_set_visible(var_31_0, "role", false)
		if_set(arg_31_1.subtask, "txt_t_status", T("ui_unit_subtask_busy"))
		arg_31_1:addChild(arg_31_1.subtask)
	end
	
	arg_31_0:removeSubTaskEventListenerForBar(arg_31_1.subtask)
	arg_31_0:updateSubTaskSkillInfo(arg_31_1.subtask, arg_31_2, true)
	
	return arg_31_1
end

function UIUtil.updateEatingEndTime(arg_32_0, arg_32_1, arg_32_2, arg_32_3)
	arg_32_3 = arg_32_3 or {}
	
	local var_32_0 = arg_32_2:getRestEatingEndTime()
	
	if not var_32_0 then
		return 0
	end
	
	local var_32_1 = math.floor(var_32_0 / 60)
	local var_32_2 = var_32_0 % 60
	
	if arg_32_3.short then
		if_set(arg_32_1, "txt_eat_time", sec_to_string(var_32_0))
	else
		if_set(arg_32_1, "txt_eat_time", T("eat_time", {
			min = var_32_1,
			sec = var_32_2
		}))
	end
	
	return var_32_0
end

function UIUtil.updateSubtaskEndTime(arg_33_0, arg_33_1, arg_33_2)
	local var_33_0 = arg_33_2:getRestSubtaskEndTime()
	
	if not var_33_0 then
		return 
	end
	
	if var_33_0 > 0 then
		local var_33_1 = math.floor(var_33_0 / 60)
		local var_33_2 = var_33_0 % 60
		
		if_set(arg_33_1, "txt_eat_time", sec_to_full_string(var_33_0))
	else
		if_set(arg_33_1, "txt_eat_time", T("complete_text"))
	end
	
	return var_33_0
end

local function var_0_2(arg_34_0)
	local var_34_0 = CACHE:getEffect(arg_34_0)
	
	var_34_0:setAnimation(0, "list", true)
	var_34_0:setPosition(0, 30)
	var_34_0:setScale(0.8)
	
	return var_34_0
end

local function var_0_3(...)
	local var_35_0 = {
		...
	}
	
	for iter_35_0, iter_35_1 in pairs(var_35_0) do
		if iter_35_1 then
			iter_35_1:removeFromParent()
		end
	end
end

function UIUtil.updateUnitBarColor(arg_36_0, arg_36_1, arg_36_2, arg_36_3, arg_36_4, arg_36_5, arg_36_6)
	local var_36_0 = arg_36_1:getChildByName("list_tag_memory")
	local var_36_1 = arg_36_1:getChildByName("list_tag_exp")
	local var_36_2 = arg_36_1:getChildByName("list_tag_buff_story")
	local var_36_3 = not (arg_36_3 ~= "Promote" and arg_36_3 ~= "Enhance" and arg_36_3 ~= "Sell" and arg_36_3 ~= "Storage") and arg_36_2:getUsableCodeList(arg_36_5, arg_36_3) and arg_36_0.DARK_GREY or arg_36_0.WHITE
	
	if arg_36_3 == "Storage" and Storage:isTakeOutMode() then
		var_36_3 = arg_36_0.DARK_GREY
	end
	
	arg_36_1:setColor(var_36_3)
	
	if arg_36_5 and (arg_36_3 == "Enhance" or arg_36_3 == "Promote" or arg_36_3 == "Upgrade") then
		if arg_36_5:isDevotionUpgradable(arg_36_2) then
			SpriteCache:resetSprite(arg_36_1:getChildByName("bg"), "img/hero_bg_sametype.png")
			
			if not var_36_0 then
				local var_36_4 = var_0_2("list_tag_memory")
				
				arg_36_1:addChild(var_36_4)
				var_36_4:setColor(var_36_3)
				var_0_3(var_36_1, var_36_2)
			end
			
			return 
		elseif arg_36_2.db.type == "xpup" then
			SpriteCache:resetSprite(arg_36_1:getChildByName("bg"), "img/hero_bg_selected.png")
			
			if not var_36_1 then
				local var_36_5 = var_0_2("list_tag_exp")
				
				arg_36_1:addChild(var_36_5)
				var_0_3(var_36_0, var_36_2)
			end
			
			return 
		end
	else
		var_0_3(var_36_1, var_36_0)
	end
	
	if arg_36_3 == "MultiPromote" then
		local var_36_6 = arg_36_0.DARK_GREY
		
		if arg_36_5 and arg_36_5:getGrade() == arg_36_2:getGrade() then
			var_36_6 = arg_36_0.WHITE
		end
		
		arg_36_1:setColor(var_36_6)
	end
	
	if arg_36_3 == "Substory" then
		if arg_36_6 and arg_36_6[arg_36_2.db.code] then
			if not var_36_2 then
				local var_36_7 = var_0_2("list_tag_buff_story")
				
				arg_36_1:addChild(var_36_7)
			end
		else
			var_0_3(var_36_2)
		end
	end
	
	if var_36_0 then
		arg_36_1:removeChild(var_36_0)
	end
	
	if var_36_1 then
		arg_36_1:removeChild(var_36_1)
	end
	
	if var_36_2 then
		arg_36_1:removeChild(var_36_2)
	end
	
	local var_36_8 = arg_36_3 == "Bistro" or not arg_36_3
	
	if arg_36_4 and arg_36_3 ~= "Bistro" and arg_36_3 ~= "Promote" and arg_36_3 ~= "Enhance" and not arg_36_2:isEating() and not arg_36_2:isGetInjured() then
		if_set_sprite(arg_36_1, "bg", "img/hero_bg_selected.png")
	elseif var_36_8 and arg_36_2:isEating() then
	elseif var_36_8 and arg_36_2:isGetInjured() then
	else
		if_set_sprite(arg_36_1, "bg", "img/hero_bg_normal.png")
	end
	
	if arg_36_3 == "worldboss" and arg_36_2.isExclude then
		arg_36_1:setColor(arg_36_0.DARK_GREY)
		if_set_visible(arg_36_1, "add", false)
	end
	
	if arg_36_3 == "LotaBlessing" and LotaUserData:isUsableUnit(arg_36_2) then
		arg_36_1:setColor(arg_36_0.DARK_GREY)
	end
	
	if arg_36_3 == "LotaRegistrationBelt" and (LotaUserData:isExistRegistrationByCode(arg_36_2.db.code) or LotaUserData:isExistRegistrationByGroup(arg_36_2.db.set_group)) then
		arg_36_1:setColor(arg_36_0.DARK_GREY)
	end
	
	local var_36_9
	
	if string.starts(arg_36_3 or "", "Ready") then
		local var_36_10 = string.split(arg_36_3, ":")[2]
		
		if Account:isMazeUsedUnit(var_36_10, arg_36_2:getUID()) then
			if_set_visible(arg_36_1, "add", false)
			if_set_sprite(arg_36_1, "bg", "img/hero_bg_normal.png")
		end
	end
end

function UIUtil.setStars(arg_37_0, arg_37_1, arg_37_2, arg_37_3, arg_37_4, arg_37_5, arg_37_6)
	arg_37_6 = arg_37_6 or "star"
	arg_37_4 = to_n(arg_37_4)
	arg_37_3 = to_n(arg_37_3)
	arg_37_2 = to_n(arg_37_2)
	
	for iter_37_0 = 1, 6 do
		if_set_visible(arg_37_1, arg_37_6 .. iter_37_0, iter_37_0 <= arg_37_2)
	end
	
	for iter_37_1 = 1, 6 do
		local var_37_0 = ""
		
		if arg_37_5 then
			if iter_37_1 > arg_37_2 - arg_37_4 then
				var_37_0 = "_p"
			elseif iter_37_1 > arg_37_2 - arg_37_3 then
				var_37_0 = "_j"
			end
		elseif iter_37_1 <= arg_37_4 then
			var_37_0 = "_p"
		elseif iter_37_1 <= arg_37_3 then
			var_37_0 = "_j"
		end
		
		SpriteCache:resetSprite(arg_37_1:getChildByName(arg_37_6 .. iter_37_1), "img/cm_icon_star" .. var_37_0 .. ".png")
	end
end

function UIUtil.setStarsByUnit(arg_38_0, arg_38_1, arg_38_2, arg_38_3, arg_38_4)
	if not arg_38_2 then
		return 
	end
	
	local var_38_0 = arg_38_2:getGrade()
	local var_38_1 = arg_38_2:getZodiacGrade()
	local var_38_2 = arg_38_2:getAwakeGrade()
	
	if arg_38_2:isGrowthBoostRegistered() then
		var_38_0 = arg_38_2:getGrowthBoostGrade()
		var_38_1 = arg_38_2:getGrowthBoostZodiac()
	end
	
	UIUtil:setStars(arg_38_1, var_38_0, var_38_1, var_38_2, arg_38_3, arg_38_4)
end

function UIUtil.setStoryBuffIcon(arg_39_0, arg_39_1, arg_39_2)
	for iter_39_0 = 1, 4 do
		if_set_visible(arg_39_1, "story_fx" .. iter_39_0, false)
	end
end

function UIUtil.getRelationColorIcon(arg_40_0, arg_40_1)
	local var_40_0
	local var_40_1
	
	if arg_40_1 == "rival" then
		var_40_0 = "img/cm_icon_storymap_rival.png"
		var_40_1 = cc.c3b(237, 67, 67)
	elseif arg_40_1 == "grudge" then
		var_40_0 = "img/cm_icon_storymap_revenge.png"
		var_40_1 = cc.c3b(213, 131, 255)
	elseif arg_40_1 == "love" then
		var_40_0 = "img/cm_icon_storymap_love.png"
		var_40_1 = cc.c3b(255, 155, 193)
	elseif arg_40_1 == "trust" then
		var_40_0 = "img/cm_icon_storymap_trust.png"
		var_40_1 = cc.c3b(107, 208, 255)
	elseif arg_40_1 == "longing" then
		var_40_0 = "img/cm_icon_storymap_longing.png"
		var_40_1 = cc.c3b(209, 251, 41)
	elseif arg_40_1 == "locked" then
		var_40_0 = "img/cm_icon_storymap_off.png"
		var_40_1 = cc.c3b(191, 191, 191)
	end
	
	return var_40_1, var_40_0
end

function UIUtil.setSpriteNumber(arg_41_0, arg_41_1, arg_41_2, arg_41_3, arg_41_4, arg_41_5, arg_41_6, arg_41_7, arg_41_8)
	local var_41_0 = 0
	local var_41_1 = tostring(arg_41_3)
	local var_41_2 = math.min(arg_41_5, string.len(var_41_1))
	local var_41_3 = arg_41_5 - var_41_2
	
	for iter_41_0 = 1, var_41_2 do
		local var_41_4 = iter_41_0
		
		if arg_41_8 then
			var_41_4 = iter_41_0 + var_41_3
		end
		
		local var_41_5 = arg_41_1:getChildByName(arg_41_2 .. var_41_4)
		
		if var_41_5 then
			var_41_5:setVisible(true)
			
			var_41_0 = var_41_0 + 1
			
			if arg_41_7 then
				SpriteCache:resetSprite(var_41_5, arg_41_4 .. string.sub(var_41_1, 0 + iter_41_0, 0 + iter_41_0) .. ".png")
			else
				SpriteCache:resetSprite(var_41_5, arg_41_4 .. string.sub(var_41_1, 0 - iter_41_0, 0 - iter_41_0) .. ".png")
			end
		end
	end
	
	if arg_41_6 then
		for iter_41_1 = var_41_2 + 1, arg_41_5 do
			local var_41_6 = arg_41_1:getChildByName(arg_41_2 .. iter_41_1)
			
			if var_41_6 then
				SpriteCache:resetSprite(var_41_6, arg_41_4 .. "0.png")
			end
		end
		
		var_41_0 = arg_41_5
	elseif arg_41_8 then
		for iter_41_2 = arg_41_5, 1, -1 do
			if_set_visible(arg_41_1, arg_41_2 .. iter_41_2, var_41_3 < iter_41_2)
		end
	else
		if_set_visible(arg_41_1, arg_41_2 .. tostring(var_41_2 + 1), false)
	end
	
	return var_41_0
end

function UIUtil.warpping_setLevel(arg_42_0, arg_42_1, arg_42_2, arg_42_3, arg_42_4, arg_42_5)
	arg_42_5 = arg_42_5 or {}
	
	return arg_42_0:setLevel(arg_42_1, arg_42_2, arg_42_3, arg_42_4, arg_42_5.fill_zero, arg_42_5.img_path, arg_42_5.offset_per_char, arg_42_5.is_reward, arg_42_5.show_max_lv, arg_42_5.force_offset, arg_42_5.is_clan_level)
end

function UIUtil.setLevel(arg_43_0, arg_43_1, arg_43_2, arg_43_3, arg_43_4, arg_43_5, arg_43_6, arg_43_7, arg_43_8, arg_43_9, arg_43_10, arg_43_11)
	arg_43_6 = arg_43_6 or "img/hero_lv_"
	
	local var_43_0 = 0
	local var_43_1 = arg_43_3 == arg_43_2
	
	arg_43_1 = arg_43_1:getChildByName("n_lv") or arg_43_1
	
	local var_43_2 = arg_43_1:getChildByName("max")
	
	if var_43_2 then
		var_43_2:setVisible(var_43_1 == true)
	end
	
	local var_43_3 = not var_43_2 or not var_43_1
	
	if_set_visible(arg_43_1, "l1", var_43_3)
	if_set_visible(arg_43_1, "lv_slash", var_43_3)
	
	if var_43_3 then
		var_43_0 = arg_43_0:setSpriteNumber(arg_43_1, "l", arg_43_2, arg_43_6, arg_43_4, arg_43_5, arg_43_8)
	end
	
	local var_43_4 = arg_43_1:getChildByName("n_lv_base") or arg_43_1:getChildByName("n_lv_num")
	
	if arg_43_7 then
		if var_43_4 and not var_43_4.origin_x then
			var_43_4.origin_x = var_43_4:getPositionX()
		end
		
		if var_43_4 and arg_43_10 then
			var_43_4:setPositionX(-arg_43_7)
		elseif var_43_4 then
			var_43_4:setPositionX(0 - (arg_43_4 - string.len(tostring(arg_43_2))) * arg_43_7)
		end
	elseif var_43_4 and var_43_4.origin_x then
		var_43_4:setPositionX(var_43_4.origin_x)
		
		var_43_4.origin_x = nil
	end
	
	local var_43_5 = arg_43_1:getChildByName("lv_slash")
	
	if arg_43_9 and get_cocos_refid(var_43_5) and arg_43_3 then
		if_set_visible(arg_43_1, "lv_slash", true)
		arg_43_0:setSpriteNumber(arg_43_1, "ml", arg_43_3, arg_43_6, arg_43_4, arg_43_5, arg_43_8, true)
		
		if var_43_1 and get_cocos_refid(var_43_2) then
			if not var_43_5.originPosX then
				var_43_5.originPosX = var_43_5:getPositionX()
				
				var_43_5:setPositionX(var_43_2:getPositionX())
			end
		elseif var_43_5.originPosX then
			var_43_5:setPositionX(var_43_5.originPosX)
			
			var_43_5.originPosX = nil
		end
	end
	
	if arg_43_11 and arg_43_2 and arg_43_2 <= 9 then
		local var_43_6 = arg_43_1:getChildByName("n_lv_num")
		
		if get_cocos_refid(var_43_6) then
			if not var_43_6.originX then
				var_43_6.originX = var_43_6:getPositionX()
			end
			
			var_43_6:setPositionX(var_43_6.originX - 18)
		end
	end
	
	return var_43_0, var_43_1
end

function UIUtil.makeNavigatorAni(arg_44_0, arg_44_1)
	arg_44_1 = arg_44_1 or {}
	
	local var_44_0 = cc.Node:create()
	local var_44_1 = cc.Node:create()
	local var_44_2 = SpriteCache:getSprite("img/navi_back.png")
	local var_44_3 = var_44_2:getContentSize()
	local var_44_4 = CACHE:getEffect("guide_arrow.scsp")
	
	var_44_1:setContentSize(var_44_3)
	var_44_2:setLocalZOrder(-1)
	var_44_4:setScaleFactor(1)
	var_44_1:setAnchorPoint(0, 0)
	var_44_2:setAnchorPoint(0.5, 0.5)
	var_44_4:setAnchorPoint(0.5, 0)
	var_44_1:addChild(var_44_4)
	var_44_2:setPosition(0, var_44_3.height / 2)
	var_44_1:setName("arrow")
	var_44_2:setName("back")
	var_44_4:setName("ani")
	var_44_1:setCascadeOpacityEnabled(true)
	var_44_2:setCascadeOpacityEnabled(true)
	var_44_4:setCascadeOpacityEnabled(true)
	var_44_0:setCascadeOpacityEnabled(true)
	var_44_4:setAnimation(0, arg_44_1.ani or "idle_stage", true)
	var_44_1:addChild(var_44_2)
	var_44_0:addChild(var_44_1)
	var_44_0:setScale(arg_44_1.scale or 1.7)
	
	return var_44_0
end

function UIUtil.makeNavigatorSprite(arg_45_0)
	return (cc.Sprite:create("img/map_noti_quest.png"))
end

function UIUtil.setRewardLevelDetail(arg_46_0, arg_46_1, arg_46_2, arg_46_3)
	if arg_46_3 and arg_46_3.hide_max then
		arg_46_2 = nil
	end
	
	UIUtil:setLevel(arg_46_1, arg_46_2, -1, 3, false, "img/item_", false, true)
	if_set_visible(arg_46_1, "n_lv", not arg_46_3.hide_level)
end

function UIUtil.setLevelDetail(arg_47_0, arg_47_1, arg_47_2, arg_47_3, arg_47_4)
	if arg_47_4 and arg_47_4.hide_max then
		arg_47_3 = nil
	end
	
	if arg_47_4 and arg_47_4.hide_level then
		return 
	end
	
	UIUtil:setLevel(arg_47_1, arg_47_2, arg_47_3, 2)
	UIUtil:setSpriteNumber(arg_47_1, "ml", arg_47_3, "img/hero_lv_", 2)
	
	if arg_47_2 == arg_47_3 then
		arg_47_1:getChildByName("n_lv_num"):setPositionX(30)
		
		if arg_47_3 < 10 then
			if_set_visible(arg_47_1, "lv_slash", false)
			if_set_visible(arg_47_1, "ml1", false)
		else
			if_set_visible(arg_47_1, "lv_slash", true)
			if_set_visible(arg_47_1, "ml1", true)
		end
	else
		if arg_47_2 < 10 then
			arg_47_1:getChildByName("n_lv_num"):setPositionX(-20)
		else
			arg_47_1:getChildByName("n_lv_num"):setPositionX(0)
		end
		
		if_set_visible(arg_47_1, "lv_slash", true)
	end
	
	if arg_47_4 and (arg_47_4.hide_max or arg_47_4.hide_ml_when_max_level and arg_47_2 == arg_47_3) then
		if_set_visible(arg_47_1, "lv_slash", false)
		if_set_visible(arg_47_1, "ml1", false)
	end
end

function UIUtil.setFavoriteDetail(arg_48_0, arg_48_1, arg_48_2)
	if not get_cocos_refid(arg_48_1) then
		return 
	end
	
	local var_48_0, var_48_1 = arg_48_2:getFavLevel()
	local var_48_2 = arg_48_1:getChildByName("n_love")
	
	if not get_cocos_refid(var_48_2) then
		return 
	end
	
	local var_48_3 = string.format("img/hero_love_icon_%d.png", var_48_0 > 7 and 3 or var_48_0 > 4 and 2 or 1)
	
	if_set_sprite(var_48_2, "icon", var_48_3)
	if_set(var_48_2, "t_lv", var_48_0)
	if_set(var_48_2, "t_title", T("ui_text_character_intimacy"))
	if_set(var_48_2, "t_disc", T("inttl_" .. var_48_0))
	
	local var_48_4 = arg_48_1:getChildByName("@progress")
	
	if get_cocos_refid(var_48_4) then
		var_48_4:removeFromParent()
	end
	
	local var_48_5 = var_48_2:getChildByName("progress")
	
	if not get_cocos_refid(var_48_5) then
		return 
	end
	
	local var_48_6 = WidgetUtils:createCircleProgress("img/hero_love_progress.png")
	
	var_48_6:setScale(var_48_5:getScale())
	var_48_6:setOpacity(var_48_5:getOpacity())
	var_48_5:setVisible(false)
	var_48_6:setReverseDirection(false)
	var_48_6:setPercentage(var_48_1 * 100)
	var_48_6:setName("@progress")
	var_48_2:addChild(var_48_6)
end

function UIUtil.setDevoteLevelDetail(arg_49_0, arg_49_1, arg_49_2, arg_49_3)
	local var_49_0 = arg_49_1:getChildByName("n_h_dedi")
	
	if not get_cocos_refid(var_49_0) then
		return 
	end
	
	if_set_visible(var_49_0, nil, arg_49_3)
	
	if not arg_49_3 then
		return 
	end
	
	arg_49_1.detail:setPositionX(11)
	
	local var_49_1 = "@devote_spr"
	
	var_49_0:removeChildByName(var_49_1)
	
	local var_49_2 = arg_49_0:getDevoteSprite(arg_49_2, true)
	
	if not get_cocos_refid(var_49_2) then
		return 
	end
	
	var_49_0:addChild(var_49_2)
	var_49_2:setName(var_49_1)
	var_49_2:setAnchorPoint(0.5, 0.5)
end

local function var_0_4(arg_50_0, arg_50_1, arg_50_2)
	arg_50_1 = arg_50_0:getDevote() ~= 0 and arg_50_1 or nil
	
	local var_50_0 = {
		C = 154,
		A = 154,
		SS = 164,
		D = 154,
		SSS = 184,
		S = 154,
		B = 154
	}
	local var_50_1 = arg_50_2:getChildByName("icon_arr")
	local var_50_2 = arg_50_2:getChildByName("t_locked")
	
	if var_50_1 and var_50_0[arg_50_1] then
		var_50_1:setPositionX(var_50_0[arg_50_1])
	elseif var_50_1 and var_50_2 then
		local var_50_3 = var_50_2:getContentSize()
		local var_50_4 = var_50_2:getScaleX()
		local var_50_5 = var_50_1:getContentSize()
		
		var_50_1:setPositionX(var_50_2:getPositionX() + var_50_3.width * var_50_4 + var_50_5.width)
	end
end

local function var_0_5(arg_51_0, arg_51_1, arg_51_2)
	local var_51_0 = {
		SSS = -12,
		SS = -6
	}
	
	if not var_51_0[arg_51_2] then
		return 
	end
	
	if not arg_51_0 or not arg_51_1 then
		return 
	end
	
	arg_51_0.origin_pos = arg_51_0:getPositionX()
	arg_51_1.origin_pos = arg_51_1:getPositionX()
	
	arg_51_0:setPositionX(var_51_0[arg_51_2] + arg_51_0.origin_pos)
	arg_51_1:setPositionX(var_51_0[arg_51_2] + arg_51_1.origin_pos - 1)
end

function UIUtil.setDevoteDetailFitString(arg_52_0, arg_52_1, arg_52_2)
	local var_52_0 = arg_52_1:getChildByName("t_skill")
	
	if get_cocos_refid(var_52_0) then
		local var_52_1 = string.lower(arg_52_2 or "")
		
		if var_52_1 == "sss" then
		elseif var_52_1 == "ss" then
			var_52_0:setPositionX(65)
		elseif string.match(var_52_1, "[a-ds]") then
			var_52_0:setPositionX(42)
		end
	end
end

local function var_0_6(arg_53_0, arg_53_1)
	local var_53_0 = arg_53_1:getDevoteSkill()
	local var_53_1 = UNIT.is_percentage_stat(var_53_0) and "%%" or "+"
	local var_53_2 = T("ui_unit_detail_memocheck", {
		type = getStatNameCRLF(var_53_0),
		add = var_53_1
	})
	
	if_set(arg_53_0, "t_lock", var_53_2)
end

function UIUtil.setDevoteDetail(arg_54_0, arg_54_1, arg_54_2, arg_54_3, arg_54_4)
	arg_54_4 = arg_54_4 or {}
	
	if not get_cocos_refid(arg_54_1) then
		return 
	end
	
	local var_54_0 = arg_54_1:getChildByName(arg_54_3 or "n_dedi")
	
	if not get_cocos_refid(var_54_0) then
		return 
	end
	
	local var_54_1, var_54_2 = DB("character", arg_54_2.db.code, {
		"devotion_skill",
		"devotion_skill_slot"
	})
	local var_54_3 = var_54_1 and var_54_2 and true or false
	
	if_set_visible(var_54_0, "icon", var_54_3)
	if_set_visible(var_54_0, "grade", var_54_3)
	if_set_visible(var_54_0, "t_skill", var_54_3)
	if_set_visible(var_54_0, "t_locked", var_54_3)
	if_set_visible(var_54_0, "icon_lock", var_54_3)
	if_set_visible(var_54_0, "t_lock", var_54_3)
	if_set_visible(var_54_0, "icon_arr", var_54_3)
	
	if not var_54_3 then
		return 
	end
	
	local var_54_4, var_54_5 = arg_54_2:getDevoteSkill(arg_54_4)
	
	if_set_visible(var_54_0, "t_locked", var_54_5 == 0)
	if_set_visible(var_54_0, "icon_lock", var_54_5 == 0)
	
	local var_54_6, var_54_7 = arg_54_2:getDevoteGrade(arg_54_4.devote)
	local var_54_8 = var_54_0:findChildByName("grade")
	local var_54_9 = var_54_0:findChildByName("icon")
	
	if var_54_8 and var_54_9 and var_54_8.origin_pos and var_54_9.origin_pos then
		var_54_8:setPositionX(var_54_8.origin_pos)
		var_54_9:setPositionX(var_54_9.origin_pos)
		print("딴딴딴딴 ", var_54_9.origin_pos, var_54_8.origin_pos)
	end
	
	if var_54_5 == 0 then
		if_set_visible(var_54_0, "grade", false)
	else
		if_set_visible(var_54_0, "grade", true)
		
		local var_54_10 = string.format("img/hero_dedi_a_%s.png", string.lower(var_54_6 or ""))
		
		if_set_sprite(var_54_0, "grade", var_54_10)
		
		if arg_54_4.fit_sprite then
			var_0_5(var_54_8, var_54_9, var_54_6)
		end
	end
	
	local var_54_11 = arg_54_2:getDevoteColor(var_54_6)
	local var_54_12 = string.split(var_54_2, ";")
	local var_54_13 = ""
	
	for iter_54_0, iter_54_1 in pairs(var_54_12) do
		var_54_13 = var_54_13 .. (iter_54_1 or "")
	end
	
	local var_54_14 = string.format("img/hero_dedi_p_%s.png", var_54_13)
	
	if_set_sprite(var_54_0, "icon", var_54_14)
	
	if var_54_5 == 0 then
		if_set_color(var_54_0, "icon", cc.c3b(255, 255, 255))
		if_set_opacity(var_54_0, "icon", 77)
	else
		if_set_color(var_54_0, "icon", var_54_11)
		if_set_opacity(var_54_0, "icon", 255)
	end
	
	if var_54_5 == 0 then
		if_set_visible(var_54_0, "t_skill", false)
	else
		if_set_visible(var_54_0, "t_skill", true)
		
		local var_54_15 = getStatName(var_54_4) .. " + " .. to_var_str(var_54_5, var_54_4, 1)
		
		if_set(var_54_0, "t_skill", var_54_15)
		if_set_color(var_54_0, "t_skill", var_54_11)
		
		if arg_54_4.fit_string then
			arg_54_0:setDevoteDetailFitString(var_54_0, var_54_6)
		end
	end
	
	if var_54_5 == 0 then
		if_set_visible(var_54_0, "t_lock", true)
		
		if arg_54_4.view_next_level or arg_54_4.not_my_unit then
			var_0_6(var_54_0, arg_54_2)
		else
			if_set(var_54_0, "t_lock", T("ui_unit_detail_memorilock_single"))
		end
	else
		if_set_visible(var_54_0, "t_lock", false)
	end
	
	if not arg_54_4.not_my_unit then
		var_0_4(arg_54_2, var_54_6, var_54_0)
	end
end

function UIUtil.toVarStrEx(arg_55_0, arg_55_1, arg_55_2, arg_55_3, arg_55_4)
	arg_55_3 = arg_55_3 or 0
	
	local var_55_0 = arg_55_4 and "" or "%%"
	
	if UNIT.is_percentage_stat(arg_55_2) then
		arg_55_1 = (arg_55_1 or 0) * 100
		
		local var_55_1 = arg_55_1 - math.floor(arg_55_1)
		
		if math.floor(arg_55_1) == math.ceil(arg_55_1) or var_55_1 * 10 < 1 then
			arg_55_1 = string.format("%d" .. var_55_0, arg_55_1)
		else
			arg_55_1 = string.format("%." .. arg_55_3 .. "f" .. var_55_0, arg_55_1)
		end
	else
		arg_55_1 = math.floor(arg_55_1)
	end
	
	return comma_value(arg_55_1)
end

function UIUtil.setDevoteDetail_new(arg_56_0, arg_56_1, arg_56_2, arg_56_3)
	arg_56_3 = arg_56_3 or {}
	
	if not get_cocos_refid(arg_56_1) then
		return 
	end
	
	local var_56_0, var_56_1 = DB("character", arg_56_2.db.code, {
		"devotion_skill",
		"devotion_skill_slot"
	})
	local var_56_2 = arg_56_1
	
	if arg_56_3.target then
		var_56_2 = arg_56_1:getChildByName(arg_56_3.target)
		
		if not var_56_2 then
			return 
		end
	end
	
	local var_56_3 = var_56_0 and var_56_1 and true or false
	
	if_set_visible(var_56_2, "icon", var_56_3)
	if_set_visible(var_56_2, "grade", var_56_3)
	if_set_visible(var_56_2, "t_skill", var_56_3)
	if_set_visible(var_56_2, "t_locked", var_56_3)
	if_set_visible(var_56_2, "icon_lock", var_56_3)
	if_set_visible(var_56_2, "t_lock", var_56_3)
	if_set_visible(var_56_2, "icon_arr", var_56_3)
	if_set_visible(var_56_2, "btn_dedi2", var_56_3)
	
	if not var_56_3 then
		return 
	end
	
	local var_56_4, var_56_5, var_56_6 = arg_56_2:getDevoteSkill(arg_56_3)
	
	if_set_visible(var_56_2, "t_locked", var_56_5 == 0)
	if_set_visible(var_56_2, "icon_lock", var_56_5 == 0)
	
	local var_56_7, var_56_8 = arg_56_2:getDevoteGrade(arg_56_3.devote)
	local var_56_9 = var_56_2:findChildByName("grade")
	local var_56_10 = var_56_2:findChildByName("icon")
	
	if var_56_6 then
		local var_56_11 = "img/hero_dedi_type2.png"
		
		if_set_sprite(var_56_10, nil, var_56_11)
	else
		local var_56_12 = string.split(var_56_1, ";")
		local var_56_13 = ""
		
		for iter_56_0, iter_56_1 in pairs(var_56_12) do
			var_56_13 = var_56_13 .. (iter_56_1 or "")
		end
		
		local var_56_14 = string.format("img/hero_dedi_p_%s.png", var_56_13)
		
		if_set_sprite(var_56_10, nil, var_56_14)
	end
	
	if var_56_5 == 0 then
		if_set_visible(var_56_2, "grade", false)
	else
		if_set_visible(var_56_2, "grade", true)
		
		local var_56_15 = string.format("img/hero_dedi_a_%s.png", string.lower(var_56_7 or ""))
		
		if_set_sprite(var_56_2, "grade", var_56_15)
		
		if arg_56_3.fit_sprite then
			var_0_5(var_56_9, var_56_10, var_56_7)
		end
	end
	
	local var_56_16 = arg_56_2:getDevoteColor(var_56_7)
	
	SpriteCache:resetSprite(var_56_2:getChildByName("icon_stat"), "img/cm_icon_stat_" .. string.gsub(var_56_4, "_rate", "") .. ".png")
	if_set_visible(var_56_2, "bg_current", arg_56_3.bg_current)
	
	if var_56_5 == 0 then
		if_set_color(var_56_10, nil, cc.c3b(255, 255, 255))
		if_set_opacity(var_56_10, nil, 77)
		if_set_color(var_56_2, "icon_stat", cc.c3b(255, 255, 255))
		if_set_opacity(var_56_2, "icon_stat", 77)
	else
		if_set_color(var_56_10, nil, var_56_16)
		if_set_opacity(var_56_10, nil, 255)
		if_set_color(var_56_2, "icon_stat", var_56_16)
		if_set_opacity(var_56_2, "icon_stat", 255)
	end
	
	if var_56_5 == 0 then
		if_set_visible(var_56_2, "t_skill", false)
	else
		if_set_visible(var_56_2, "t_skill", true)
		
		local var_56_17 = (arg_56_3.is_skill_text_CRLF and getStatNameCRLF(var_56_4) or getStatName(var_56_4)) .. " + " .. arg_56_0:toVarStrEx(var_56_5, var_56_4, 1)
		
		if_set(var_56_2, "t_skill", var_56_17)
		if_set_color(var_56_2, "t_skill", var_56_16)
		
		if arg_56_3.fit_string then
			arg_56_0:setDevoteDetailFitString(var_56_2, var_56_7)
		end
	end
	
	if var_56_5 == 0 then
		if_set_visible(var_56_2, "t_lock", true)
		
		if arg_56_3.view_next_level or arg_56_3.not_my_unit then
			var_0_6(var_56_2, arg_56_2)
		else
			if_set(var_56_2, "t_lock", T("ui_unit_detail_memorilock_single"))
		end
	else
		if_set_visible(var_56_2, "t_lock", false)
	end
	
	return true
end

function UIUtil.set_devoteItemOpacity(arg_57_0, arg_57_1, arg_57_2, arg_57_3)
	if not arg_57_1 or not arg_57_2 then
		return 
	end
	
	local var_57_0 = arg_57_1:getChildByName("n_type1")
	local var_57_1 = arg_57_1:getChildByName("n_type2")
	
	if not var_57_0 or not var_57_1 then
		return 
	end
	
	if arg_57_3.not_my_unit then
		if_set_opacity(var_57_0, nil, 255)
		if_set_opacity(var_57_1, nil, 255)
		
		return 
	end
	
	local var_57_2, var_57_3, var_57_4 = arg_57_2:getDevoteSkill(arg_57_3)
	
	if arg_57_2:getDevote() <= 0 then
		if_set_opacity(var_57_0, nil, 76.5)
		if_set_opacity(var_57_1, nil, 76.5)
		
		return 
	end
	
	if var_57_4 then
		if_set_opacity(var_57_0, nil, 76.5)
		if_set_opacity(var_57_1, nil, 255)
	else
		if_set_opacity(var_57_0, nil, 255)
		if_set_opacity(var_57_1, nil, 76.5)
	end
end

function UIUtil.updateClanMemberInfo(arg_58_0, arg_58_1, arg_58_2, arg_58_3)
	arg_58_3 = arg_58_3 or {}
	arg_58_2.user_info = arg_58_2.user_info or {}
	
	local var_58_0 = arg_58_2.user_info.id == Account:getUserId()
	
	if_set(arg_58_1, "nickname", arg_58_2.user_info.name or arg_58_2.name)
	
	local var_58_1 = arg_58_1:findChildByName("txt_contribute")
	
	if not arg_58_3.no_contri then
		if_set(var_58_1, nil, T("clan_member_contribute", {
			value = comma_value(arg_58_2.contribution_score),
			value_week = comma_value(arg_58_2.week_contribution_score)
		}))
	end
	
	if var_58_1 then
		var_58_1:setVisible(arg_58_3.no_contri == nil)
	end
	
	if arg_58_2.user_info.login_tm or arg_58_2.login_tm then
		local var_58_2 = T("time_before", {
			time = sec_to_string(os.time() - (arg_58_2.user_info.login_tm or arg_58_2.login_tm), nil, {
				login_tm = true
			})
		})
		
		if_set(arg_58_1, "last_time", var_58_2)
		if_set_scale_fit_width(arg_58_1, "last_time", 92)
	end
	
	if_set_visible(arg_58_1, "icon_leader1", arg_58_2.grade == CLAN_GRADE.master)
	if_set_visible(arg_58_1, "icon_leader2", arg_58_2.grade == CLAN_GRADE.executives)
	
	local var_58_3 = arg_58_2.user_info.level or arg_58_2.level
	
	UIUtil:setLevel(arg_58_1:getChildByName("n_lv"), var_58_3, MAX_ACCOUNT_LEVEL, 2)
	
	if arg_58_2.user_info and arg_58_2.user_info.leader_code or arg_58_2.leader_code then
		UIUtil:getRewardIcon(nil, arg_58_2.leader_code or arg_58_2.user_info.leader_code, {
			no_popup = true,
			no_grade = true,
			parent = arg_58_1:getChildByName("n_face"),
			scale = arg_58_3.leader_scale or 0.8,
			border_code = arg_58_2.border_code or (arg_58_2.user_info or {}).border_code
		})
	end
	
	local var_58_4 = var_58_0 and (Clan:getAttenInfo() or {}).is_t_atten_checked
	
	if_set_visible(arg_58_1, "icon_attendance", var_58_4 or arg_58_2.is_attendance)
	
	local var_58_5 = arg_58_1:getChildByName("talk_small_bg")
	
	if get_cocos_refid(var_58_5) then
		local var_58_6 = var_58_5:getChildByName("disc")
		
		if var_58_6 then
			local var_58_7 = arg_58_2.intro_msg or T("input_default_msg_clan_member_intro")
			local var_58_8 = arg_58_3.width_size or 980
			
			var_58_6.origin_scale_x = var_58_6.origin_scale_x or var_58_6:getScaleX()
			
			UIUserData:call(var_58_6, string.format("SINGLE_WSCALE(%d)", var_58_8 * var_58_6.origin_scale_x))
			if_set(var_58_6, nil, var_58_7)
			set_width_from_node(var_58_5, var_58_6, {
				add = 40
			})
		end
	end
end

function UIUtil.updateClanInfo(arg_59_0, arg_59_1, arg_59_2, arg_59_3)
	arg_59_3 = arg_59_3 or {}
	
	if_set(arg_59_1, "clan_name", arg_59_2.name)
	
	if arg_59_2.week_id == Account:serverTimeWeekLocalDetail() then
		if_set(arg_59_1, "point_contribute", comma_value(arg_59_2.contribution_score))
		if_set(arg_59_1, "point_supply", comma_value(arg_59_2.week_support_count))
		if_set(arg_59_1, "txt_weeksupply_v", comma_value(arg_59_2.week_support_count))
		if_set(arg_59_1, "week_contribution", T("txt_week_contribution", {
			value = arg_59_2.contribution_score or 0
		}))
		if_set(arg_59_1, "txt_weeklyfeat _v", comma_value(arg_59_2.contribution_score))
	else
		if_set(arg_59_1, "point_contribute", 0)
		if_set(arg_59_1, "point_supply", 0)
		if_set(arg_59_1, "txt_weeksupply_v", 0)
		if_set(arg_59_1, "week_contribution", T("txt_week_contribution", {
			value = 0
		}))
		if_set(arg_59_1, "txt_weeklyfeat _v", 0)
	end
	
	local var_59_0, var_59_1 = DB("clan_level", tostring(arg_59_2.level), {
		"exp",
		"max_member"
	})
	local var_59_2 = var_59_1
	
	if_set(arg_59_1, "txt_member_count", T("clan_member_count", {
		count = arg_59_2.member_count,
		max = var_59_2
	}))
	if_set(arg_59_1, "txt_member_only_count", T("clan_member_only_count", {
		count = arg_59_2.member_count
	}))
	
	if arg_59_2.rank_limit and arg_59_2.rank_limit > 0 then
		if_set(arg_59_1, "txt_rank_limit", T("clan_rank_limit", {
			rank = arg_59_2.rank_limit
		}))
	else
		if_set(arg_59_1, "txt_rank_limit", T("no_clan_rank_limit"))
	end
	
	local var_59_3 = arg_59_2.exp or 0
	
	if_set(arg_59_1, "txt_exp", T("txt_exp", {
		exp = comma_value(arg_59_2.exp),
		max = comma_value(var_59_0)
	}))
	
	if not arg_59_3.no_progress then
		if_set_percent(arg_59_1, "progress", var_59_3 / var_59_0)
	end
	
	local var_59_4 = {}
	
	table.insert(var_59_4, "visible_public")
	table.insert(var_59_4, "visible_private")
	
	local var_59_5 = {}
	
	table.insert(var_59_5, "join_auto")
	table.insert(var_59_5, "join_hands")
	table.insert(var_59_5, "join_hidden")
	
	if arg_59_1:getChildByName("n_lv") then
		UIUtil:warpping_setLevel(arg_59_1:getChildByName("n_lv"), arg_59_2.level, CLAN_MAX_LEVEL, 2, {
			is_clan_level = true
		})
	end
	
	if_set(arg_59_1, "txt_join_type", T(var_59_5[arg_59_2.join_type]))
	if_set(arg_59_1, "txt_visible_type", T(var_59_4[arg_59_2.visible_type]))
	if_set(arg_59_1, "support_score", T("ui_cm_preview_clan_week_support", {
		value = comma_value(arg_59_2.acc_support_count) or 0
	}))
	
	if Account:getClanId() then
		if_set(arg_59_1, "txt_clan_gold", comma_value(Clan:getCurrency("clangold")))
		if_set(arg_59_1, "txt_clan_brave", comma_value(Clan:getCurrency("clanbrave")))
	end
	
	if not arg_59_3.no_emblem_update then
		UIUtil:updateClanEmblem(arg_59_1, arg_59_2)
	end
	
	local var_59_6 = arg_59_1:getChildByName("n_clan_gold")
	local var_59_7 = arg_59_1:getChildByName("n_clan_brave")
	
	if var_59_6 then
		UIUtil:getRewardIcon(nil, "ct_clangold", {
			no_bg = true,
			scale = 0.7,
			parent = var_59_6
		})
	end
	
	if var_59_7 then
		UIUtil:getRewardIcon(nil, "ct_clanbrave", {
			no_bg = true,
			scale = 0.7,
			parent = var_59_7
		})
	end
	
	local var_59_8 = arg_59_1:getChildByName("n_lv")
	local var_59_9 = arg_59_2.level or 99
	
	if arg_59_3.offset_x and get_cocos_refid(var_59_8) and var_59_9 < 10 then
		if not var_59_8.originX then
			var_59_8.originX = var_59_8:getPositionX()
		end
		
		var_59_8:setPositionX(var_59_8.originX + arg_59_3.offset_x)
	end
end

function UIUtil.updateClanEmblem(arg_60_0, arg_60_1, arg_60_2, arg_60_3)
	if not arg_60_1 then
		return 
	end
	
	if not arg_60_2 then
		return 
	end
	
	arg_60_3 = arg_60_3 or {}
	
	local var_60_0 = arg_60_2.emblem or arg_60_3.var_name and arg_60_2[arg_60_3.var_name]
	
	if_set_visible(arg_60_1, "emblem", var_60_0 ~= nil)
	
	if var_60_0 then
		local var_60_1 = ClanUtil:getEmblemID(arg_60_2, arg_60_3)
		local var_60_2 = DB("clan_emblem", tostring(var_60_1), "emblem")
		
		if var_60_2 then
			if_set_sprite(arg_60_1, "emblem", "emblem/" .. var_60_2 .. ".png")
		end
		
		local var_60_3 = ClanEmblemBG:isOpenSystem()
		
		if_set_visible(arg_60_1, "emblem_bg", var_60_3)
		
		if var_60_3 then
			local var_60_4 = GAME_STATIC_VARIABLE.emblem_bg_default_id
			
			if var_60_0 > 100000 then
				var_60_4 = ClanUtil:getEmblemBGID(arg_60_2, arg_60_3)
			end
			
			local var_60_5 = DB("clan_emblem", tostring(var_60_4), "emblem")
			
			if var_60_5 then
				if_set_sprite(arg_60_1, "emblem_bg", "emblem/" .. var_60_5 .. ".png")
			end
		end
	end
end

function UIUtil.setLimitBreakGauge(arg_61_0, arg_61_1, arg_61_2, arg_61_3)
	if not arg_61_1 then
		return 
	end
	
	if_set_visible(arg_61_1, nil, not arg_61_3)
	
	local function var_61_0(arg_62_0, arg_62_1, arg_62_2)
		if not arg_62_0 then
			return 
		end
		
		if_set_visible(arg_62_0, "gauge_bar", arg_62_1 <= arg_62_2)
	end
	
	for iter_61_0 = 1, 5 do
		local var_61_1 = arg_61_1:getChildByName("gauge_" .. iter_61_0)
		
		var_61_0(var_61_1, iter_61_0, arg_61_2)
	end
end

function UIUtil.updateEquipBar(arg_63_0, arg_63_1, arg_63_2, arg_63_3)
	arg_63_3 = arg_63_3 or {}
	
	if not arg_63_1 then
		if arg_63_2:isArtifact() then
			arg_63_1 = cc.CSLoader:createNode("wnd/artifact_bar.csb")
		elseif arg_63_2:isExclusive() then
			arg_63_1 = cc.CSLoader:createNode("wnd/private_bar.csb")
		else
			arg_63_1 = cc.CSLoader:createNode("wnd/item_bar.csb")
		end
	end
	
	local var_63_0 = arg_63_1:getChildByName("item_name")
	
	if get_cocos_refid(var_63_0) then
		if_set(var_63_0, nil, arg_63_2:getName())
		
		if arg_63_2:isArtifact() or arg_63_2:isExclusive() then
			UIUserData:call(var_63_0, "SINGLE_WSCALE(214)")
		else
			UIUserData:call(var_63_0, "MULTI_SCALE(2)")
		end
	end
	
	local var_63_1 = arg_63_2
	local var_63_2
	
	if arg_63_2.isEnhancer and arg_63_2:isMaterialStone() then
		var_63_1 = nil
		var_63_2 = true
	elseif arg_63_2.isEnhancer and arg_63_2:isEquip() then
		var_63_1 = arg_63_2:getEquip()
	end
	
	if arg_63_2:isArtifact() then
		arg_63_0:getRewardIcon(arg_63_2:getRewardIconCountValue(), arg_63_2.code, {
			scale = 1,
			tooltip_delay = 300,
			parent = arg_63_1:getChildByName("item_pos"),
			equip = var_63_1,
			grade = arg_63_2.grade,
			no_tooltip = arg_63_3.no_tooltip,
			show_count = var_63_2,
			equip_belt = arg_63_3.equip_belt
		})
		if_set_visible(arg_63_1, "icon_job", arg_63_2.db.role ~= nil)
		
		if arg_63_2.db.role then
			if_set_sprite(arg_63_1, "icon_job", "img/cm_icon_role_" .. arg_63_2.db.role .. ".png")
		end
	else
		arg_63_0:getRewardIcon(arg_63_2:getRewardIconCountValue(), arg_63_2.code, {
			scale = 1,
			tooltip_delay = 300,
			parent = arg_63_1:getChildByName("item_pos"),
			equip = var_63_1,
			no_grade = arg_63_3.no_grade,
			no_tooltip = arg_63_3.no_tooltip,
			show_count = var_63_2
		})
	end
	
	local var_63_3, var_63_4, var_63_5, var_63_6 = arg_63_2:getMainStat()
	
	if_set_visible(arg_63_1, "eq_selected", false)
	if_set_visible(arg_63_1, "locked", arg_63_2.lock)
	
	if arg_63_2:isStone() and not arg_63_2:isArtifact() then
		if_set(arg_63_1, "txt_main_stat", comma_value(arg_63_2.db.get_xp))
		if_set_sprite(arg_63_1, "main_icon", "img/cm_icon_stat_exp.png")
		if_set_visible(arg_63_1, "n_material", true)
		if_set_visible(arg_63_1, "n_value", false)
	elseif arg_63_3.show_detail then
		local var_63_7 = arg_63_1:getChildByName("n_value")
		local var_63_8 = UnitEquipUtil:getOptionsSumTable(arg_63_2.equip or arg_63_2)
		local var_63_9 = {}
		
		for iter_63_0 = 1, table.count(var_63_8 or {}) do
			local var_63_10 = table.clone(var_63_8[iter_63_0])
			
			if UNIT.is_percentage_stat(var_63_10[1]) then
				var_63_10[2] = to_var_str(var_63_10[2], var_63_10[1])
			else
				var_63_10[2] = comma_value(math.floor(var_63_10[2]))
			end
			
			table.insert(var_63_9, var_63_10)
		end
		
		if_set_visible(arg_63_1, "n_material", false)
		if_set_visible(var_63_7, nil, true)
		SpriteCache:resetSprite(var_63_7:getChildByName("main_icon"), "img/cm_icon_stat_" .. string.gsub(var_63_4, "_rate", "") .. ".png")
		
		local var_63_11 = var_63_7:getChildByName("txt_main_stat")
		
		if get_cocos_refid(var_63_11) then
			if_set(var_63_11, nil, to_var_str(var_63_3, var_63_4))
			UIUserData:call(var_63_11, "SINGLE_WSCALE(55)", {
				origin_scale_x = 0.49
			})
		end
		
		for iter_63_1 = 1, 4 do
			if_set_visible(var_63_7, "n_type" .. iter_63_1, var_63_9[iter_63_1])
			
			if var_63_9[iter_63_1] then
				SpriteCache:resetSprite(var_63_7:getChildByName("icon_type" .. iter_63_1), "img/cm_icon_stat_" .. string.gsub(var_63_9[iter_63_1][1], "_rate", "") .. ".png")
				
				local var_63_12 = var_63_7:getChildByName("txt_stat" .. iter_63_1)
				
				if get_cocos_refid(var_63_12) then
					if_set(var_63_12, nil, var_63_9[iter_63_1][2])
					UIUserData:call(var_63_12, "SINGLE_WSCALE(40)", {
						origin_scale_x = 0.74
					})
				end
			end
		end
	else
		if_set_visible(arg_63_1, "n_material", true)
		if_set_visible(arg_63_1, "n_value", false)
		if_set(arg_63_1, "txt_main_stat", to_var_str(var_63_3, var_63_4))
		
		local var_63_13 = arg_63_1:getChildByName("main_icon")
		
		if var_63_13 then
			SpriteCache:resetSprite(var_63_13, "img/cm_icon_stat_" .. string.gsub(var_63_4, "_rate", "") .. ".png")
		end
		
		if arg_63_2:isArtifact() then
			local var_63_14 = arg_63_2:getSkillLevel() + 1
			local var_63_15 = arg_63_2:getMaxSkillLevel() + 1
			
			arg_63_0:setLimitBreakGauge(arg_63_1:getChildByName("n_limit_break"), arg_63_2:getDupPoint(), arg_63_2:isStone())
			
			local var_63_16 = not arg_63_3.no_equip and arg_63_2.parent
			
			if_set_visible(arg_63_1, "icon_equip", var_63_16)
			
			if arg_63_3.disable_slv or arg_63_2:isStone() then
				if_set_visible(arg_63_1, "n_lv", false)
			else
				if_set_visible(arg_63_1, "n_lv", true)
				arg_63_0:warpping_setLevel(arg_63_1:getChildByName("n_lv"), var_63_14, var_63_15, 2, {
					force_offset = true,
					show_max_lv = true,
					offset_per_char = arg_63_0:numberDigitToCharOffset(var_63_14, 1, 12)
				})
			end
			
			local var_63_17
			
			if string.starts(arg_63_2.code, "ma_") then
				var_63_17 = cc.Sprite:create("item/" .. (DB("item_material", arg_63_2.code, "thumbnail") or "") .. ".jpg")
			else
				var_63_17 = cc.Sprite:create("item_arti/" .. (DB("equip_item", arg_63_2.code, "thumbnail") or "") .. ".jpg")
			end
			
			var_63_17 = var_63_17 or cc.Layer:create()
			
			var_63_17:setAnchorPoint(0, 0)
			arg_63_1:getChildByName("n_img_frame"):addChild(var_63_17)
			
			if arg_63_3.gacha_grade then
				if_set_visible(arg_63_1, "n_artifact_stars", true)
				
				local var_63_18 = arg_63_1:getChildByName("n_artifact_stars")
				
				if_set_visible(var_63_18, "star" .. arg_63_2.grade + 1, false)
			else
				if_set_visible(arg_63_1, "n_artifact_stars", false)
			end
			
			if arg_63_3.job_icon_offset_y then
				local var_63_19 = arg_63_1:getChildByName("icon_job")
				
				if get_cocos_refid(var_63_19) then
					var_63_19:setPositionY(var_63_19:getPositionY() + arg_63_3.job_icon_offset_y)
				end
			end
		end
	end
	
	if var_63_5 then
		if_set(arg_63_1, "txt_main_stat2", to_var_str(var_63_3, var_63_6))
		
		local var_63_20 = arg_63_1:getChildByName("main_icon2")
		
		if var_63_20 then
			SpriteCache:resetSprite(var_63_20, "img/cm_icon_stat_" .. string.gsub(var_63_6, "_rate", "") .. ".png")
		end
	end
	
	arg_63_1.equip = arg_63_2
	
	return arg_63_1
end

function UIUtil.updateUnkownArtifactBar(arg_64_0, arg_64_1, arg_64_2)
	local var_64_0 = arg_64_1 or {}
	local var_64_1 = arg_64_2 or {}
	local var_64_2 = var_64_0.code or "ef101"
	local var_64_3 = cc.CSLoader:createNode("wnd/artifact_bar.csb")
	local var_64_4 = arg_64_0:getRewardIcon(nil, var_64_2, {
		no_tooltip = true,
		show_count = false,
		scale = 1,
		no_grade = true,
		parent = var_64_3:getChildByName("item_pos")
	})
	local var_64_5 = var_64_1.arti_unkown_icon or "icon_unknown_art1"
	local var_64_6 = var_64_1.bonus_artifact_unknown_thunbnail or "unknown_art1_l"
	
	if_set_sprite(var_64_4, "icon", "item_arti/" .. var_64_5 .. ".png")
	if_set_visible(var_64_3, "icon_job", false)
	if_set_visible(var_64_3, "eq_selected", false)
	if_set_visible(var_64_3, "item_name", false)
	if_set_visible(var_64_3, "icon_equip", false)
	if_set_visible(var_64_3, "n_limit_break", false)
	if_set_visible(var_64_3, "n_lv", false)
	if_set_visible(var_64_3, "n_artifact_stars", false)
	
	local var_64_7
	local var_64_8 = cc.Sprite:create("item_arti/" .. var_64_6 .. ".jpg") or cc.Layer:create()
	
	var_64_8:setAnchorPoint(0, 0)
	var_64_3:getChildByName("n_img_frame"):addChild(var_64_8)
	
	var_64_3.equip = var_64_0
	
	WidgetUtils:setupPopup({
		control = var_64_3,
		creator = function()
			balloon_message_with_sound("before_schedule_open")
		end
	})
	
	return var_64_3
end

function UIUtil.removeTag(arg_66_0, arg_66_1)
	local var_66_0 = ""
	local var_66_1 = 1
	local var_66_2 = string.len(arg_66_1)
	
	while var_66_1 <= var_66_2 do
		local var_66_3 = string.find(arg_66_1, "<", var_66_1)
		
		if var_66_3 then
			local var_66_4 = ""
			
			if var_66_1 ~= var_66_3 then
				var_66_4 = string.sub(arg_66_1, var_66_1, var_66_3 - 1)
			end
			
			var_66_1 = string.find(arg_66_1, ">", var_66_3) + 1
			var_66_0 = var_66_0 .. var_66_4
		else
			if var_66_1 < var_66_2 then
				var_66_0 = var_66_0 .. string.sub(arg_66_1, var_66_1, var_66_2)
			end
			
			break
		end
	end
	
	return var_66_0
end

function UIUtil.getSkillDetail(arg_67_0, arg_67_1, arg_67_2, arg_67_3)
	local var_67_0 = arg_67_3.skill_id
	local var_67_1
	
	if not var_67_0 then
		if type(arg_67_2) == "string" then
			var_67_0 = arg_67_2
			var_67_1 = var_67_0
			arg_67_2 = arg_67_1:getSkillIndex(var_67_0)
		else
			var_67_0 = arg_67_1:getSkillByIndex(arg_67_2)
			
			local var_67_2 = arg_67_1:getSkillBundle():slot(arg_67_2)
			
			var_67_1 = var_67_2 and var_67_2:getSkillId() or var_67_0
			
			if arg_67_3.show_random_set and var_67_2 and var_67_2:getSkillId() then
				local var_67_3 = var_67_2:getOriginSkillId()
				local var_67_4 = DB("skill", var_67_3, "skill_type")
				
				if var_67_4 == "random" or var_67_4 == "turn_self_random" then
					var_67_1 = var_67_3
				end
			end
		end
	else
		var_67_1 = var_67_0
	end
	
	if not var_67_0 then
		return 
	end
	
	local var_67_5 = arg_67_3.skill_lv
	
	if var_67_5 == nil and arg_67_1 then
		var_67_5 = arg_67_1:getSkillLevelByIndex(arg_67_2)
	end
	
	var_67_5 = var_67_5 or 0
	arg_67_3 = arg_67_3 or {}
	
	local var_67_6 = {}
	local var_67_7 = {}
	
	if arg_67_1 then
		local var_67_8, var_67_9 = arg_67_1:getReferSkillIndex(var_67_1)
		
		var_67_6 = arg_67_1:getRuneSkillBonusByIndex(var_67_8, var_67_9)
		
		if not arg_67_3.ignore_exclusive_bonus then
			var_67_7 = arg_67_1:getExclusiveEffect(var_67_8)
		end
	end
	
	local var_67_10, var_67_11, var_67_12, var_67_13, var_67_14, var_67_15, var_67_16, var_67_17, var_67_18, var_67_19, var_67_20, var_67_21, var_67_22, var_67_23, var_67_24 = UNIT.getSkillDB(var_67_5, var_67_0, {
		"name",
		"sk_passive",
		"sk_description",
		"point_require",
		"point_gain",
		"turn_cool",
		"pow",
		"sk_eff_value1",
		"sk_eff_value2",
		"soul_gain",
		"soul_req",
		"soulburn_skill",
		"isshowcooltime",
		"showcooltimeskill",
		"showcooltimeskill_de"
	}, var_67_6, var_67_7)
	local var_67_25
	
	if var_67_21 then
		var_67_25 = DB("skill", var_67_21, "soul_req")
	end
	
	if var_67_1 ~= var_67_0 then
		var_67_10 = DB("skill", var_67_1, "name")
	end
	
	var_67_24 = var_67_7.showcooltimeskill_de or var_67_24
	
	local var_67_26
	
	if (arg_67_3.show_soul or var_67_21) and arg_67_1 and arg_67_1:isSoulEnabled(var_67_0) then
		var_67_26 = true
	else
		var_67_21 = nil
		var_67_25 = nil
	end
	
	local var_67_27 = arg_67_3.wnd or load_control("wnd/skill_detail.csb")
	
	var_67_27.unit = arg_67_1
	var_67_27.skill_idx = arg_67_2
	var_67_27.skill_id = var_67_0
	var_67_27.skill_lv = var_67_5
	
	local var_67_28 = var_67_27:getChildByName("icon_pos")
	
	if var_67_27.icon then
		var_67_27.icon:removeFromParent()
	end
	
	var_67_27.icon = arg_67_0:getSkillIcon(arg_67_1, var_67_1, arg_67_3)
	
	var_67_28:addChild(var_67_27.icon)
	
	if not var_67_26 then
		if_set_visible(var_67_27.icon, "soul1", false)
	end
	
	if_set(var_67_27, "txt_name", T(var_67_10))
	set_scale_fit_width(var_67_27:findChildByName("txt_name"), 244)
	
	local var_67_29 = TooltipUtil:getSkillTooltipText(var_67_0, var_67_5, var_67_6, var_67_7)
	local var_67_30 = var_67_27:getChildByName("txt_desc")
	
	if get_cocos_refid(var_67_30) then
		if var_67_30.setTextAreaSize then
			if var_67_29 and string.find(var_67_29, "<#") ~= nil then
				var_67_30 = upgradeLabelToRichLabel(var_67_27, "txt_desc")
				
				if_set(var_67_30, nil, var_67_29)
			else
				UIUtil:setTextAndReturnHeight(var_67_30, var_67_29)
			end
		else
			if_set(var_67_30, nil, var_67_29)
		end
	end
	
	var_67_30:setLineSpacing(1.7)
	
	local var_67_31 = var_67_27:getChildByName("n_cool")
	
	if var_67_31 then
		local var_67_32 = "sk_cool"
		local var_67_33
		
		if var_67_11 then
			var_67_33 = UNIT.getCSDB(arg_67_1, var_67_11, {
				"cs_cooltime"
			})
		end
		
		if var_67_11 and (var_67_24 or var_67_33 and to_n(var_67_33) > 0) then
			if var_67_22 == "y" then
				if var_67_24 then
					var_67_32 = var_67_24
				end
				
				if_set(var_67_31, "txt_cool", T(var_67_32, {
					turn = var_67_33
				}))
				
				local var_67_34 = var_67_31:getChildByName("txt_cool")
				
				if get_cocos_refid(var_67_34) and var_67_34.getLineCount and var_67_34:getLineCount() >= 2 and not var_67_34.line_modified then
					var_67_34:setPositionY(var_67_34:getPositionY() + 9)
					
					var_67_34.line_modified = true
					
					local var_67_35 = var_67_31:getChildByName("cool_icon")
					
					if get_cocos_refid(var_67_35) then
						var_67_35:setPositionY(var_67_35:getPositionY() + 9)
					end
				end
			else
				var_67_31:setVisible(false)
			end
		elseif var_67_15 and to_n(var_67_15) > 0 then
			if_set(var_67_31, "txt_cool", T(var_67_32, {
				turn = var_67_15
			}))
		else
			var_67_31:setVisible(false)
		end
	end
	
	local var_67_36 = var_67_27:getChildByName("n_head")
	
	if var_67_36 then
		var_67_19 = to_n(var_67_19)
		
		if_set_visible(var_67_36, "soul", var_67_19 > 0)
		
		local var_67_37 = var_67_36:getChildByName("txt_soul_gain")
		
		if var_67_19 > 0 then
			var_67_37:setVisible(true)
			if_set(var_67_37, nil, T("sk_soul_gain", {
				cost = var_67_19
			}))
		else
			var_67_37:setVisible(false)
		end
	end
	
	if var_67_26 and to_n(var_67_19) == 0 and to_n(var_67_15) == 0 then
		if_set_visible(var_67_27, "n_coolline", false)
	end
	
	local var_67_38 = var_67_27:getChildByName("n_soul")
	
	if var_67_38 then
		if var_67_26 and var_67_21 then
			local var_67_39 = var_67_27:getChildByName("txt_soul_desc")
			
			if get_cocos_refid(var_67_39) then
				local var_67_40 = T(UNIT.getSkillDB(var_67_5, var_67_21, "sk_description"))
				
				if var_67_39.user_data_params then
					if_set(var_67_39, nil, var_67_40)
				else
					UIUtil:setTextAndReturnHeight(var_67_39, var_67_40)
				end
			end
			
			local var_67_41 = var_67_38:getChildByName("txt_soul_cost")
			
			var_67_41:setString(T("sk_soul_cost", {
				cost = var_67_25
			}))
			set_scale_fit_width(var_67_41, 110)
			var_67_38:setPositionY((610 - var_67_30:getTextBoxSize().height) * var_67_30:getScaleY())
		else
			var_67_38:setVisible(false)
		end
	end
	
	local var_67_42 = 0
	
	for iter_67_0 = 1, 10 do
		local var_67_43 = DB("skill", var_67_0, "sk_lv_eff" .. iter_67_0)
		
		if not var_67_43 and iter_67_0 == 1 then
			arg_67_3.hide_stat = true
			
			break
		end
		
		if not var_67_43 then
			if_set_visible(var_67_27, tostring(iter_67_0), false)
		else
			if_set_visible(var_67_27, tostring(iter_67_0), true)
			
			local var_67_44 = DB("skill", var_67_0, "sk_passive")
			
			if var_67_44 then
				if var_67_43 == "*ps_up" then
					var_67_42 = var_67_42 + 1
					
					if_set(var_67_27, "data" .. iter_67_0, T(DB("cs", tostring(var_67_44) .. var_67_42, "cs_lvup_de")))
				else
					if_set(var_67_27, "data" .. iter_67_0, T(DB("cslv", tostring(var_67_43), "cslv_text")))
				end
			else
				if_set(var_67_27, "data" .. iter_67_0, T(DB("sklv", tostring(var_67_43), "sklv_text")))
			end
			
			if var_67_5 < iter_67_0 then
				if_set_color(var_67_27, "p" .. iter_67_0, arg_67_0.DARK_GREY)
				if_set_color(var_67_27, "data" .. iter_67_0, arg_67_0.DARK_GREY)
			else
				if_set_color(var_67_27, "p" .. iter_67_0, arg_67_0.WHITE)
				if_set_color(var_67_27, "data" .. iter_67_0, arg_67_0.WHITE)
			end
		end
	end
	
	local var_67_45 = var_67_27:getChildByName("txt_cost")
	
	var_67_45:setVisible(false)
	arg_67_0:setSkillResText(var_67_45, arg_67_1, var_67_13, var_67_14, true)
	if_set_visible(var_67_27, "n_before", arg_67_3.detail_before ~= nil)
	if_set_visible(var_67_27, "n_after", arg_67_3.detail_after ~= nil)
	
	return var_67_27
end

function UIUtil.arrangeNotifyContentNumLines(arg_68_0, arg_68_1, arg_68_2)
	arg_68_1 = math.min(2, arg_68_1)
	
	while arg_68_1 + arg_68_2 > 4 do
		if arg_68_1 < arg_68_2 then
			arg_68_2 = arg_68_2 - 1
		else
			arg_68_1 = arg_68_1 - 1
		end
	end
	
	return arg_68_1, arg_68_2
end

function UIUtil.setNotifyTextControl(arg_69_0, arg_69_1, arg_69_2, arg_69_3)
	local var_69_0 = arg_69_1:getChildByName("txt_title")
	local var_69_1 = arg_69_1:getChildByName("txt_desc")
	local var_69_2 = string.find(arg_69_3, "<#") ~= nil
	
	if var_69_1 and var_69_2 then
		var_69_1 = upgradeLabelToRichLabel(var_69_1, nil, true)
		var_69_1.origin_size = var_69_1.origin_size or var_69_1:getContentSize()
		
		var_69_1:setContentSize({
			width = var_69_1.origin_size.width * 0.97,
			height = var_69_1.origin_size.height
		})
	end
	
	if_set(var_69_0, nil, arg_69_2)
	if_set(var_69_1, nil, arg_69_3)
	
	local var_69_3, var_69_4 = UIUtil:arrangeNotifyContentNumLines(var_69_0:getStringNumLines(), var_69_1:getStringNumLines())
	
	UIUtil:conditionNotifyControlLineTextTransForm(var_69_0, var_69_1, var_69_3, var_69_4, arg_69_2, arg_69_3)
end

function UIUtil.conditionNotifyControlLineTextTransForm(arg_70_0, arg_70_1, arg_70_2, arg_70_3, arg_70_4, arg_70_5, arg_70_6)
	arg_70_1._origin_scale_x = arg_70_1._origin_scale_x or arg_70_1:getScaleX()
	arg_70_1._origin_text_size = arg_70_1._origin_text_size or arg_70_1:getTextBoxSize()
	arg_70_2._origin_scale_x = arg_70_2._origin_scale_x or arg_70_2:getScaleX()
	arg_70_2._origin_text_size = arg_70_2._origin_text_size or arg_70_2:getTextBoxSize()
	
	set_scale_fit_width_multi_line(arg_70_1, arg_70_3, 60)
	set_scale_fit_width_multi_line(arg_70_2, arg_70_4, 80)
	
	local function var_70_0(arg_71_0, arg_71_1)
		if arg_71_0._origin_scale_x * arg_71_1 < arg_71_0:getScaleX() then
			return 
		end
		
		arg_71_0:setContentSize({
			width = arg_71_0._origin_text_size.width / arg_71_1,
			height = arg_71_0:getTextBoxSize().height
		})
		arg_71_0:setScaleX(arg_71_0._origin_scale_x * arg_71_1)
		
		if tolua.type(arg_71_0) == "ccui.RichText" then
			arg_70_2:formatText()
		end
	end
	
	var_70_0(arg_70_1, 0.8)
	var_70_0(arg_70_2, 0.8)
	set_ellipsis_multi_label(arg_70_1, arg_70_5, arg_70_3)
	set_ellipsis_multi_label(arg_70_2, arg_70_6, arg_70_4)
	
	if arg_70_3 == 1 and arg_70_4 == 1 then
		arg_70_1:setPositionY(74)
		arg_70_2:setPositionY(67)
	elseif arg_70_3 == 1 and arg_70_4 == 2 then
		arg_70_1:setPositionY(83)
		arg_70_2:setPositionY(76)
	elseif arg_70_3 == 1 and arg_70_4 == 3 then
		arg_70_1:setPositionY(90)
		arg_70_2:setPositionY(89)
	elseif arg_70_3 == 2 and arg_70_4 == 1 then
		arg_70_1:setPositionY(61)
		arg_70_2:setPositionY(55)
	elseif arg_70_3 == 2 and arg_70_4 == 2 then
		arg_70_1:setPositionY(70)
		arg_70_2:setPositionY(69)
	elseif arg_70_3 == 3 and arg_70_4 == 1 then
		arg_70_1:setPositionY(50)
		arg_70_2:setPositionY(45)
	end
end

function UIUtil.setSkillResText(arg_72_0, arg_72_1, arg_72_2, arg_72_3, arg_72_4, arg_72_5)
	if not arg_72_2 then
		return ""
	end
	
	local var_72_0 = {
		chase_2_land = "추격 - 연계 지상",
		chase_2_fly = "추격 - 연계 공중",
		coop_2 = "협공 - 연계",
		multi_1 = "확산 - 시작",
		chase_1 = "추격 - 시작",
		multi_2 = "확산 - 연계",
		coop_1 = "협공 - 시작",
		bp = T("stat_name_fight"),
		mp = T("stat_name_mana"),
		cp = T("stat_name_focus"),
		rp = T("stat_name_revenge"),
		soul = T("stat_name_soul")
	}
	local var_72_1
	
	if type(arg_72_3) == "string" then
		local var_72_2 = string.split(arg_72_3, ";")
		
		arg_72_3 = tonumber(var_72_2[1])
		var_72_1 = tonumber(var_72_2[3])
	end
	
	if arg_72_2:getSPName() == "none" then
		arg_72_1:setVisible(false)
	elseif arg_72_3 and arg_72_3 > 0 then
		local var_72_3
		
		arg_72_1:setVisible(true)
		
		local var_72_4 = arg_72_2:getSP()
		
		if arg_72_5 or arg_72_3 <= var_72_4 then
			local var_72_5 = ""
			
			if var_72_1 then
				var_72_3 = T("sk_source_maxcost", {
					res = var_72_0[arg_72_2:getSPName()],
					max_num = var_72_1,
					num = var_72_4
				})
			else
				var_72_3 = T("sk_source_cost", {
					res = var_72_0[arg_72_2:getSPName()],
					num = arg_72_3
				})
			end
			
			if arg_72_2.db.type == "summon" and arg_72_2:getSPName() == "soul" then
				var_72_3 = T("sk_soul_cost", {
					cost = arg_72_3
				})
			end
			
			arg_72_1:setTextColor(cc.c3b(77, 167, 255))
		else
			var_72_3 = T("sk_source_lack", {
				res = var_72_0[arg_72_2:getSPName()],
				num = arg_72_4
			})
			
			arg_72_1:setTextColor(cc.c3b(255, 0, 0))
		end
		
		arg_72_1:setString(var_72_3)
	elseif arg_72_4 then
		local var_72_6 = T("sk_source_gain", {
			res = var_72_0[arg_72_2:getSPName()],
			num = arg_72_4
		})
		
		arg_72_1:setString(var_72_6)
		arg_72_1:setVisible(true)
		arg_72_1:setTextColor(cc.c3b(255, 120, 0))
	else
		arg_72_1:setVisible(false)
	end
end

function UIUtil.getDeviceIcon(arg_73_0, arg_73_1, arg_73_2)
	local var_73_0 = arg_73_2 or {}
	local var_73_1 = cc.CSLoader:createNode("wnd/device_icon.csb")
	local var_73_2
	
	if var_73_0.isInventory then
		var_73_2 = var_73_1:getChildByName("n_info_normal")
	else
		var_73_2 = var_73_1:getChildByName("n_info_small")
	end
	
	var_73_2:setVisible(true)
	
	local var_73_3 = var_73_0.level or 1
	local var_73_4, var_73_5, var_73_6, var_73_7, var_73_8 = DB("level_automaton_device", var_73_0.id, {
		"category",
		"category_sub",
		"character",
		"max_lv",
		"grade_" .. var_73_3
	})
	
	if not var_73_0.category then
		var_73_0.category = var_73_4
	end
	
	if not var_73_0.category_sub then
		var_73_0.category_sub = var_73_5
	end
	
	var_73_7 = var_73_7 or 1
	
	if var_73_0.grade then
		var_73_8 = var_73_0.grade
	end
	
	if not var_73_8 or var_73_8 > 5 then
		var_73_8 = 1
	end
	
	if not var_73_0.grade then
		var_73_0.grade = var_73_8
	end
	
	if var_73_4 == "hero" and var_73_6 then
		if_set_visible(var_73_1, "device_icon", false)
		if_set_visible(var_73_1, "face", true)
		if_set_sprite(var_73_1, "face", "face/" .. var_73_6 .. "_s.png")
	else
		local var_73_9 = DB("skill", arg_73_1, {
			"sk_icon"
		}) or "404"
		
		SpriteCache:resetSprite(var_73_1:getChildByName("device_icon"), "device/" .. var_73_9 .. ".png")
		if_set_visible(var_73_1, "device_icon", true)
		
		if not var_73_0.no_category_sub then
			if var_73_4 == "job" and var_73_0.category_sub then
				var_73_2:setVisible(true)
				if_set_visible(var_73_2, "role", true)
				if_set_sprite(var_73_2, "role", "img/cm_icon_role_" .. var_73_0.category_sub .. ".png")
			elseif var_73_4 == "attribute" then
				var_73_2:setVisible(true)
				if_set_visible(var_73_2, "element", true)
				
				local var_73_10 = var_73_0.category_sub
				
				if var_73_10 == "moonlight" then
					var_73_10 = "lightdark"
				end
				
				if_set_sprite(var_73_2, "element", "img/cm_icon_pro" .. var_73_10 .. ".png")
			end
		end
	end
	
	if not var_73_0.hide_level and var_73_7 > 1 then
		if_set_visible(var_73_2, "n_level", true)
		
		local var_73_11 = "hero_lv_bar"
		
		if var_73_3 > 0 then
			if var_73_3 == var_73_7 then
				if_set_color(var_73_2, "n_level", tocolor("#ff6f57"))
			end
			
			var_73_11 = "hero_lv_" .. var_73_3
		end
		
		local var_73_12 = cc.Sprite:create("img/" .. var_73_11 .. ".png")
		
		var_73_2:getChildByName("n_num"):addChild(var_73_12)
		var_73_12:setPosition(0, 0)
		var_73_12:setAnchorPoint(0.5, 0.5)
	end
	
	if_set_sprite(var_73_1, "frame", string.format("device/device_frame_%02d.png", var_73_8))
	
	if not var_73_0.no_tooltip then
		local function var_73_13()
			return UIUtil:getDevicetoolTip(arg_73_1, var_73_0)
		end
		
		if var_73_0.tooltip_opts and var_73_0.tooltip_opts.creator then
			var_73_13 = var_73_0.tooltip_opts.creator
		end
		
		WidgetUtils:setupTooltip({
			control = var_73_1,
			creator = var_73_13,
			delay = var_73_0.delay or 0,
			style = var_73_0.style,
			call_by_show = var_73_0.tooltip_opts and var_73_0.tooltip_opts.call_by_show
		})
	end
	
	return var_73_1
end

function UIUtil.getDevicetoolTip(arg_75_0, arg_75_1, arg_75_2)
	local var_75_0 = arg_75_2 or {}
	local var_75_1 = var_75_0.level or 0
	local var_75_2 = var_75_0.max_lv or 0
	local var_75_3 = var_75_0.category or "common"
	
	if not var_75_0.type then
		local var_75_4 = "cs"
	end
	
	local var_75_5 = var_75_0.grade or 1
	local var_75_6 = var_75_0.result_tooltip
	local var_75_7 = var_75_0.category and var_75_0.category == "hero"
	local var_75_8 = var_75_1 ~= 0 and var_75_1 == var_75_2
	local var_75_9, var_75_10, var_75_11, var_75_12, var_75_13, var_75_14 = DB("skill", arg_75_1, {
		"sk_icon",
		"name",
		"sk_passive",
		"point_require",
		"point_gain",
		"soulburn_skill"
	})
	local var_75_15 = var_75_0.wnd or load_dlg("device_tooltip", true, "wnd")
	local var_75_16 = TooltipUtil:getSkillTooltipText(arg_75_1, var_75_1)
	
	if var_75_3 == "hero" and var_75_0.character and (not var_75_0.character or not var_75_0.hero_skill_name or not var_75_0.hero_skill_desc) then
		var_75_10, var_75_16 = DB("level_automaton_device", var_75_0.id, {
			"hero_skill_name",
			"hero_skill_desc"
		})
		var_75_16 = T(var_75_16)
	end
	
	if_set(var_75_15, "txt_name", T(var_75_10))
	if_set(var_75_15, "t_none", T("automtn_device_unacquired"))
	if_set_visible(var_75_15, "t_none", false)
	
	local var_75_17 = var_75_15:getChildByName("txt_name")
	local var_75_18 = var_75_15:getChildByName("n_disc")
	
	if var_75_6 and var_75_17 then
		local var_75_19 = var_75_17:getStringNumLines()
		local var_75_20 = math.min(var_75_19, 4)
		local var_75_21 = var_75_15:getChildByName("n_disc" .. var_75_20)
		
		if var_75_21 then
			var_75_21:setVisible(true)
			
			var_75_18 = var_75_21
		end
	end
	
	if_set(var_75_18, "txt_device_info", var_75_16)
	if_set_visible(var_75_15, "n_top_info", true)
	
	if var_75_7 or var_75_2 == 1 then
		if var_75_1 == 0 then
			if_set_visible(var_75_15, "t_none", true)
			if_set_visible(var_75_15, "n_lv", false)
			if_set_visible(var_75_15, "n_lv_max", false)
		else
			if_set_visible(var_75_15, "n_top_info", false)
		end
	elseif var_75_2 ~= 1 or not var_75_7 then
		if var_75_1 == 0 then
			if_set_visible(var_75_15, "t_none", true)
			if_set_visible(var_75_15, "n_lv", false)
			if_set_visible(var_75_15, "n_lv_max", false)
		else
			if_set_visible(var_75_15, "n_lv", not var_75_8)
			if_set_visible(var_75_15, "n_lv_max", var_75_8)
			
			if not var_75_8 then
				local var_75_22 = var_75_15:getChildByName("n_lv_num")
				
				UIUtil:setSpriteNumber(var_75_22, "l", var_75_1, "img/hero_lv_", 1)
				UIUtil:setSpriteNumber(var_75_22, "ml", var_75_2, "img/hero_lv_", 1)
			else
				local var_75_23 = var_75_15:getChildByName("n_lv_max")
				
				UIUtil:setSpriteNumber(var_75_23, "ml", var_75_2, "img/hero_lv_", 1)
			end
		end
	end
	
	if_set_visible(var_75_18, "kind_icon_public", false)
	if_set_visible(var_75_18, "kind_icon_pro", false)
	if_set_visible(var_75_18, "kind_icon_jop", false)
	if_set_visible(var_75_18, "kind_icon_hero", false)
	
	local var_75_24 = {
		all = "icon_menu_all.png",
		knight = "icon_menu_roleknight.png",
		share = "icon_menu_roleshare.png",
		manauser = "icon_menu_rolremanauser.png",
		assassin = "icon_menu_roleassassin.png",
		warrior = "icon_menu_warrior.png",
		ranger = "icon_menu_ranger.png",
		mage = "icon_menu_rolemage.png"
	}
	local var_75_25 = var_75_0.category_sub or var_75_0.category
	
	if_set(var_75_18, "txt_kind", T("automtn_category_" .. var_75_25))
	
	if var_75_3 == "common" then
		if_set_visible(var_75_18, "kind_icon_public", true)
	elseif var_75_3 == "attribute" then
		if_set_visible(var_75_18, "kind_icon_pro", true)
		
		if var_75_25 == "moonlight" then
			var_75_25 = "lightdark"
		end
		
		if_set_sprite(var_75_18, "kind_icon_pro", "img/cm_icon_pro" .. var_75_25 .. ".png")
	elseif var_75_3 == "job" then
		if_set_visible(var_75_18, "kind_icon_job", true)
		if_set_sprite(var_75_18, "kind_icon_job", "img/" .. var_75_24[var_75_25])
	elseif var_75_3 == "hero" then
		if_set_visible(var_75_18, "kind_icon_hero", true)
	elseif var_75_3 == "monster" then
		if_set_visible(var_75_18, "kind_icon_public", true)
		if_set_sprite(var_75_18, "kind_icon_public", "img/icon_menu_monster_device.png")
		if_set_visible(var_75_15, "n_top_info", false)
	end
	
	local var_75_26 = cc.Sprite:create("img/_itembg_device_" .. var_75_5 .. ".png")
	
	var_75_15:getChildByName("n_grade"):addChild(var_75_26)
	var_75_15:getChildByName("txt_grade"):setTextColor(UIUtil:getGradeColor(nil, var_75_5 or 1))
	if_set(var_75_15, "txt_grade", T("automtn_device_grade_" .. var_75_5))
	
	local var_75_27 = var_75_0
	
	var_75_27.no_tooltip = true
	var_75_27.no_category_sub = true
	var_75_27.hide_level = true
	
	local var_75_28 = UIUtil:getDeviceIcon(arg_75_1, var_75_27)
	
	var_75_15:getChildByName("n_device_icon"):addChild(var_75_28)
	var_75_28:setAnchorPoint(0.5, 0.5)
	
	local var_75_29 = var_75_18:getChildByName("txt_device_info")
	local var_75_30 = var_75_15:getChildByName("txt_name")
	local var_75_31 = 18
	local var_75_32 = 0
	
	if var_75_30:getStringNumLines() >= 2 then
		local var_75_33 = var_75_18:getPositionY()
		local var_75_34 = var_75_30:getWorldPosition()
		local var_75_35 = var_75_30:getTextBoxSize().height
		local var_75_36 = var_75_18:getParent()
		
		if var_75_36 then
			local var_75_37 = var_75_36:convertToNodeSpace({
				x = var_75_34.x,
				y = var_75_34.y - var_75_35 - 15
			})
			
			var_75_18:setPositionY(var_75_37.y)
		end
		
		var_75_32 = var_75_33 - var_75_18:getPositionY()
	end
	
	local var_75_38 = var_75_29:getContentSize()
	local var_75_39 = var_75_29:getStringNumLines()
	local var_75_40 = var_75_15:getChildByName("frame")
	local var_75_41 = var_75_40:getContentSize()
	local var_75_42 = var_75_41.height
	local var_75_43 = var_75_38.height + var_75_39 * 20 + var_75_32
	
	if not var_75_6 then
		var_75_40:setContentSize({
			width = var_75_41.width,
			height = var_75_43
		})
		var_75_40:setPositionY(var_75_40:getPositionY() + (var_75_42 - var_75_43))
		var_75_40:setAnchorPoint(0, 0)
	else
		var_75_40:setAnchorPoint(0, 1)
	end
	
	return var_75_15
end

function UIUtil.getAwakeSkillPopup(arg_76_0, arg_76_1, arg_76_2)
	if not arg_76_1 then
		return 
	end
	
	local var_76_0 = "ca_" .. arg_76_1.db.code .. "_3"
	local var_76_1 = DB("char_awake", var_76_0, "skill_up")
	
	if not var_76_1 then
		return 
	end
	
	arg_76_2 = arg_76_2 or {}
	
	local var_76_2 = load_control("wnd/skill_detail_potential.csb")
	
	if_set(var_76_2, "txt_name", T(DB("skill", var_76_1, "name")))
	if_set_visible(var_76_2, "txt_cost", false)
	if_set_visible(var_76_2, "txt_soul_gain", false)
	if_set_visible(var_76_2, "n_coolline", false)
	
	local var_76_3 = var_76_2:getChildByName("icon_pos")
	
	if get_cocos_refid(var_76_3) then
		local var_76_4 = UIUtil:getSkillIcon(nil, var_76_1, {
			no_tooltip = true
		})
		
		var_76_3:addChild(var_76_4)
	end
	
	UIUtil:setAwakeSkillScrollview(var_76_2, arg_76_1, arg_76_2)
	
	if arg_76_2.show_effs then
		local var_76_5 = var_76_2:getChildByName("n_effs")
		
		if arg_76_2.show_effs == "left" then
			var_76_5 = var_76_2:getChildByName("n_effs_zodiac")
		end
		
		local var_76_6 = {}
		
		var_76_6[1], var_76_6[2], var_76_6[3], var_76_6[4] = DB("skill", var_76_1, {
			"sk_eff_explain1",
			"sk_eff_explain2",
			"sk_eff_explain3",
			"sk_eff_explain4"
		})
		
		arg_76_0:attachEffectsTooltip(var_76_5, var_76_6, true)
	end
	
	return var_76_2
end

function UIUtil.setAwakeSkillScrollview(arg_77_0, arg_77_1, arg_77_2, arg_77_3)
	if not get_cocos_refid(arg_77_1) or not arg_77_2 then
		return 
	end
	
	local var_77_0 = arg_77_1:getChildByName("scrollview_potentail")
	
	if not get_cocos_refid(var_77_0) then
		return 
	end
	
	arg_77_3 = arg_77_3 or {}
	
	local var_77_1 = "ca_" .. arg_77_2.db.code .. "_3"
	local var_77_2 = arg_77_2:getPresentDevote()
	
	if not arg_77_3.force_active and table.empty(arg_77_2:getAwakeSkill()) then
		var_77_2 = -1
	end
	
	if arg_77_3.dict_mode then
		var_77_2 = 999
	end
	
	if get_cocos_refid(var_77_0) then
		var_77_0:removeAllChildren()
		
		local var_77_3 = arg_77_3.min or 0
		local var_77_4 = arg_77_3.max or 7
		local var_77_5 = 28
		
		for iter_77_0 = var_77_4, var_77_3, -1 do
			local var_77_6 = var_77_1
			local var_77_7 = "none"
			
			if iter_77_0 > 0 then
				var_77_7 = string.lower(DB("devotion_skill_grade", tostring(iter_77_0), "grade") or "")
				var_77_6 = var_77_6 .. "_" .. iter_77_0
			end
			
			local var_77_8 = DB("char_awake", var_77_6, "desc")
			
			if var_77_8 then
				local var_77_9 = load_control("wnd/skill_detail_potential_item.csb")
				local var_77_10 = 46
				local var_77_11 = var_77_9:getChildByName("txt_skill")
				
				if get_cocos_refid(var_77_11) then
					var_77_11:setString(T(var_77_8))
					
					var_77_10 = var_77_10 + var_77_11:getTextBoxSize().height
				end
				
				if_set_position_y(var_77_9, "n_potential_skill", 0)
				if_set_sprite(var_77_9, "grade_icon", "img/hero_dedi_a_" .. var_77_7 .. ".png")
				if_set_visible(var_77_9, "bg_current", false)
				
				if var_77_2 < iter_77_0 then
					if_set_color(var_77_9, nil, cc.c3b(128, 128, 128))
				end
				
				var_77_5 = var_77_5 + var_77_10
				
				var_77_0:addChild(var_77_9)
				var_77_9:setPositionY(var_77_5)
			end
		end
		
		var_77_0:setInnerContainerSize({
			width = var_77_0:getInnerContainerSize().width,
			height = var_77_5
		})
		
		local var_77_12 = arg_77_3.align or "top"
		local var_77_13 = var_77_0:getContentSize().height - var_77_5
		
		if var_77_13 > 0 then
			if var_77_12 == "top" then
				local var_77_14 = var_77_0:getChildren()
				
				for iter_77_1, iter_77_2 in pairs(var_77_14) do
					iter_77_2:setPositionY(iter_77_2:getPositionY() + var_77_13)
				end
			elseif var_77_12 == "center" then
				local var_77_15 = var_77_0:getChildren()
				
				for iter_77_3, iter_77_4 in pairs(var_77_15) do
					iter_77_4:setPositionY(iter_77_4:getPositionY() + var_77_13 / 2)
				end
			elseif var_77_12 == "bottom" then
			end
			
			var_77_0:setTouchEnabled(false)
			var_77_0:setScrollBarEnabled(false)
		end
	end
end

function UIUtil.getSkillIcon(arg_78_0, arg_78_1, arg_78_2, arg_78_3)
	arg_78_3 = arg_78_3 and table.clone(arg_78_3)
	arg_78_3 = arg_78_3 or {}
	
	if type(arg_78_2) == "number" then
		arg_78_2 = arg_78_1:getSkillByIndex(arg_78_2)
	end
	
	arg_78_2 = arg_78_3.skill_id or arg_78_2
	
	local var_78_0 = arg_78_3.skill_lv
	
	if not var_78_0 and arg_78_1 then
		var_78_0 = arg_78_1:getSkillLevel(arg_78_2)
	end
	
	if not arg_78_2 and not arg_78_3.ignore_check then
		return arg_78_0:_getSkillIcon(arg_78_1, "", 0, arg_78_3), false
	end
	
	local var_78_1 = arg_78_0:_getSkillIcon(arg_78_1, arg_78_2, var_78_0 or 0, arg_78_3)
	local var_78_2 = arg_78_1 and arg_78_1:isSkillEnabled(arg_78_2)
	local var_78_3, var_78_4 = DB("skill", arg_78_2, {
		"sk_show",
		"sk_passive"
	})
	
	if var_78_3 ~= "y" then
		var_78_2 = false
	end
	
	local var_78_5 = var_78_4 ~= nil
	local var_78_6 = string.ends(arg_78_2, "u") or string.ends(arg_78_2, "us")
	
	if_set_visible(var_78_1, "upgrade", not var_78_5 and var_78_6)
	if_set_visible(var_78_1, "upgrade_passive", var_78_5 and var_78_6)
	
	local var_78_7 = {}
	
	if arg_78_1 then
		var_78_7 = arg_78_1:getExclusiveEffect(arg_78_1:getReferSkillIndex(arg_78_2))
	end
	
	if_set_visible(var_78_1, "exclusive", var_78_7.effect ~= nil)
	
	if var_78_7.effect ~= nil and var_78_5 then
		if var_78_6 then
			if_set_sprite(var_78_1, "exclusive", "skill/frame_skillup_enchant_passive.png")
		else
			if_set_sprite(var_78_1, "exclusive", "skill/frame_skillenchant_passive.png")
		end
	end
	
	if arg_78_3.notMyUnit and var_78_5 then
		if var_78_6 then
			if_set_sprite(var_78_1, "exclusive", "skill/frame_skillup_enchant_passive.png")
		else
			if_set_sprite(var_78_1, "exclusive", "skill/frame_skillenchant_passive.png")
		end
	end
	
	if arg_78_3.show_exclusive_target then
		if_set_visible(var_78_1, "n_skill_num", true)
		if_set_sprite(var_78_1, "img_skill_num_roma", "img/itxt_num" .. arg_78_3.show_exclusive_target .. "_roma_b")
	end
	
	if arg_78_3.is_locked then
		if_set_color(var_78_1, nil, cc.c3b(136, 136, 136))
	end
	
	return var_78_1, var_78_2
end

function UIUtil._getSkillIcon(arg_79_0, arg_79_1, arg_79_2, arg_79_3, arg_79_4)
	arg_79_4 = arg_79_4 or {}
	
	local var_79_0
	
	if arg_79_4.hud_skill == true then
		var_79_0 = cc.CSLoader:createNode("wnd/hud_skill.csb")
	else
		var_79_0 = cc.CSLoader:createNode("wnd/skill_icon.csb")
	end
	
	local var_79_1, var_79_2, var_79_3, var_79_4, var_79_5, var_79_6 = DB("skill", arg_79_2, {
		"sk_icon",
		"name",
		"sk_passive",
		"point_require",
		"point_gain",
		"soulburn_skill"
	})
	local var_79_7
	
	if var_79_6 then
		var_79_7 = DB("skill", var_79_6, "soul_req")
	end
	
	var_79_1 = var_79_1 or ""
	
	if var_79_1 ~= "" then
		SpriteCache:resetSprite(var_79_0:getChildByName("icon"), "skill/" .. var_79_1 .. ".png")
	end
	
	local var_79_8 = arg_79_3 >= 1
	
	if_set_visible(var_79_0, "up", var_79_8)
	
	if var_79_8 then
		if_set(var_79_0, "txt_up", "+" .. arg_79_3)
	end
	
	if arg_79_1 and not arg_79_1:isSoulEnabled(arg_79_2) then
		if_set_visible(var_79_0, "soul1", false)
	else
		if_set_visible(var_79_0, "soul" .. math.floor(to_n(var_79_7) / GAME_STATIC_VARIABLE.max_soul_point) + 1, false)
	end
	
	if arg_79_4 and arg_79_4.name and arg_79_1 then
		if_set(var_79_0, "txt_name", T(var_79_2))
		arg_79_0:setSkillResText(var_79_0:getChildByName("txt_cost"), arg_79_1, var_79_4, var_79_5, true)
	end
	
	var_79_0:setAnchorPoint(0.5, 0.5)
	
	if not arg_79_4.no_tooltip then
		local function var_79_9()
			local var_80_0 = arg_79_4.tooltip_opts or {}
			
			var_80_0.is_locked = arg_79_4.is_locked
			var_80_0.exclusive_skill = arg_79_4.exclusive_skill
			var_80_0.exclusive_tooltip = arg_79_4.exclusive_tooltip
			var_80_0.show_exclusive_target = arg_79_4.show_exclusive_target
			
			local var_80_1 = UIUtil:getSkillTooltip(arg_79_1, arg_79_2, var_80_0)
			
			if arg_79_4.diff_skill then
				local var_80_2 = table.clone(var_80_0)
				
				var_80_2.show_effs = nil
				
				local var_80_3 = UIUtil:getSkillTooltip(arg_79_4.diff_skill.unit, arg_79_4.diff_skill.skill_id, var_80_2)
				
				var_80_3:setName("diff_skill")
				var_80_3:setPositionX(var_80_1:getPositionX() - var_80_3:getContentSize().width + 30)
				var_80_3:setPositionY(var_80_1:getPositionY())
				
				local var_80_4 = var_80_3:getChildByName("img_arrow")
				
				var_80_4:setPositionY(var_80_1:getPositionY() + var_80_1:getContentSize().height / 2)
				var_80_4:setPositionX(var_80_1:getPositionX() + var_80_1:getContentSize().width - 60)
				if_set_visible(var_80_4, nil, true)
				var_80_1:addChild(var_80_3)
			end
			
			return var_80_1
		end
		
		if arg_79_4.tooltip_opts and arg_79_4.tooltip_opts.creator then
			var_79_9 = arg_79_4.tooltip_opts.creator
		end
		
		WidgetUtils:setupTooltip({
			control = var_79_0,
			creator = var_79_9,
			delay = arg_79_4.delay,
			style = arg_79_4.style,
			call_by_show = arg_79_4.tooltip_opts and arg_79_4.tooltip_opts.call_by_show,
			opts = arg_79_4.tooltip_opts
		})
	end
	
	return var_79_0
end

function UIUtil.getColorName(arg_81_0, arg_81_1)
	return T("color_" .. arg_81_1, "???")
end

function UIUtil.setUnitSimpleInfo(arg_82_0, arg_82_1, arg_82_2, arg_82_3)
	arg_82_3 = arg_82_3 or {}
	
	local var_82_0 = arg_82_3.pre or ""
	local var_82_1 = arg_82_1:getChildByName("txt_name")
	local var_82_2 = get_word_wrapped_name(var_82_1, arg_82_2:getName())
	
	if_set(var_82_1, nil, var_82_2)
	
	local var_82_3 = arg_82_1:getChildByName("color")
	local var_82_4 = arg_82_1:getChildByName("role")
	local var_82_5 = arg_82_1:getChildByName("icon_zodiac")
	local var_82_6 = arg_82_1:getChildByName("txt_color")
	local var_82_7 = arg_82_1:getChildByName("txt_role")
	local var_82_8 = arg_82_1:getChildByName("txt_zodiac")
	
	UIUtil:setFavoriteDetail(arg_82_1, arg_82_2)
	
	if arg_82_2.db.type == "summon" then
		if_set_visible(arg_82_1, "role", false)
		if_set_visible(arg_82_1, "txt_role", false)
	end
	
	if_set(arg_82_1, var_82_0 .. "txt_lv", arg_82_2:getLv())
	SpriteCache:resetSprite(var_82_3, UIUtil:getColorIcon(arg_82_2))
	SpriteCache:resetSprite(var_82_4, "img/cm_icon_role_" .. arg_82_2.db.role .. ".png")
	SpriteCache:resetSprite(var_82_5, "img/cm_icon_zodiac_" .. string.split(arg_82_2.db.zodiac, "_")[1] .. ".png")
	
	local var_82_9 = ""
	local var_82_10 = DB("character", arg_82_2.inst.code, "role") or " "
	local var_82_11 = false
	
	if arg_82_2.db and arg_82_2.db.moonlight then
		var_82_11 = true
	end
	
	if var_82_6 then
		var_82_6:setString(var_82_9 .. arg_82_0:getColorName(arg_82_2.db.color))
	end
	
	if var_82_7 then
		var_82_7:setString(T("ui_hero_role_" .. var_82_10))
	end
	
	if var_82_8 then
		local var_82_12 = DB("zodiac_sphere_2", arg_82_2.db.zodiac, "name")
		
		var_82_8:setString(T(var_82_12))
	end
	
	if arg_82_3.is_txt_node_children then
		if var_82_7 and var_82_4 and var_82_6 and not arg_82_3.no_repos_sphere then
			var_82_4:setPositionX(var_82_6:getPositionX() + var_82_6:getContentSize().width)
			var_82_7:setPositionX(var_82_4:getPositionX() + 35)
		end
		
		if var_82_8 and var_82_5 and var_82_7 and not arg_82_3.no_repos_sphere then
			var_82_5:setPositionX(var_82_7:getPositionX() + var_82_7:getContentSize().width)
			var_82_8:setPositionX(var_82_5:getPositionX() + 35)
		end
	else
		local var_82_13 = 5
		
		if var_82_3 and var_82_6 then
			local var_82_14 = 0
			
			if not var_82_11 then
				var_82_14 = -3
			end
			
			var_82_6:setPositionX(var_82_3:getPositionX() + var_82_3:getContentSize().width * var_82_3:getScaleX() + var_82_14)
		end
		
		if var_82_7 and var_82_4 and var_82_6 and not arg_82_3.no_repos_sphere then
			var_82_4:setPositionX(var_82_6:getPositionX() + var_82_6:getContentSize().width * var_82_6:getScaleX() + var_82_13)
			var_82_7:setPositionX(var_82_4:getPositionX() + var_82_4:getContentSize().width * var_82_4:getScaleX())
		end
		
		if var_82_5 and var_82_7 and not arg_82_3.no_repos_sphere then
			var_82_5:setPositionX(var_82_7:getPositionX() + var_82_7:getContentSize().width * var_82_7:getScaleX() + var_82_13)
			var_82_8:setPositionX(var_82_5:getPositionX() + var_82_5:getContentSize().width * var_82_5:getScaleX())
		end
	end
end

function UIUtil.setSubtaskSkill(arg_83_0, arg_83_1, arg_83_2, arg_83_3)
	arg_83_3 = arg_83_3 or {}
	
	if_set_visible(arg_83_1, "bg_subtask", false)
	
	local var_83_0 = arg_83_2:getSubTaskSkillIcon()
	local var_83_1 = arg_83_1:getChildByName("n_icon_subtask_skill")
	
	if var_83_0 and var_83_1 then
		if_set_visible(arg_83_1, "n_icon_subtask_skill", true)
		if_set_sprite(var_83_1, "icon_skill", "skill/" .. var_83_0)
		if_set_visible(var_83_1, "lock_subtask", false)
		
		if not arg_83_3.no_tooltip and arg_83_3.tooltip_creator then
			WidgetUtils:setupTooltip({
				control = var_83_1:getChildByName("icon_skill"),
				creator = arg_83_3.tooltip_creator,
				delay = arg_83_3.tooltip_delay
			})
		end
	else
		if_set_visible(arg_83_1, "n_icon_subtask_skill", false)
	end
end

function UIUtil.setDiffTextAndArrow(arg_84_0, arg_84_1, arg_84_2, arg_84_3, arg_84_4, arg_84_5)
	local var_84_0 = arg_84_4 or 0
	local var_84_1 = math.normalize(var_84_0, 1)
	local var_84_2 = math.abs(var_84_0)
	
	if not get_cocos_refid(arg_84_1) then
		return 
	end
	
	local var_84_3 = arg_84_1:getChildByName(arg_84_2)
	local var_84_4 = arg_84_1:getChildByName(arg_84_3)
	
	if_set_diff(arg_84_1, arg_84_2, var_84_2, arg_84_5)
	if_set_visible(arg_84_1, arg_84_3, var_84_2 > 0)
	
	if var_84_1 > 0 then
		if get_cocos_refid(var_84_3) then
			var_84_3:setTextColor(tocolor("#FF7800"))
		end
		
		if get_cocos_refid(var_84_4) then
			var_84_4:setColor(tocolor("#FF7800"))
			var_84_4:setRotation(0)
		end
	else
		if get_cocos_refid(var_84_3) then
			var_84_3:setTextColor(tocolor("#2586E9"))
		end
		
		if get_cocos_refid(var_84_4) then
			var_84_4:setColor(tocolor("#2586E9"))
			var_84_4:setRotation(180)
		end
	end
end

function UIUtil.setUnitAllInfo(arg_85_0, arg_85_1, arg_85_2, arg_85_3)
	arg_85_3 = arg_85_3 or {}
	
	local var_85_0 = arg_85_3.pre or ""
	
	if_set_visible(arg_85_1, var_85_0 .. "txt_str_value", arg_85_2 ~= nil)
	if_set_visible(arg_85_1, var_85_0 .. "txt_level_value", arg_85_2 ~= nil)
	if_set_visible(arg_85_1, var_85_0 .. "txt_exp", arg_85_2 ~= nil)
	if_set_visible(arg_85_1, var_85_0 .. "txt_stat01", arg_85_2 ~= nil)
	if_set_visible(arg_85_1, var_85_0 .. "txt_stat05", arg_85_2 ~= nil)
	if_set_visible(arg_85_1, var_85_0 .. "txt_stat06", arg_85_2 ~= nil)
	if_set_visible(arg_85_1, var_85_0 .. "diff_txt_stat01", arg_85_2 ~= nil)
	if_set_visible(arg_85_1, var_85_0 .. "diff_txt_stat05", arg_85_2 ~= nil)
	if_set_visible(arg_85_1, var_85_0 .. "diff_txt_stat06", arg_85_2 ~= nil)
	if_set_visible(arg_85_1, var_85_0 .. "exp_gauge", arg_85_2 ~= nil)
	arg_85_0:setUnitSimpleInfo(arg_85_1, arg_85_2, arg_85_3)
	
	if arg_85_2 == nil then
		for iter_85_0 = 1, 6 do
			if_set_visible(arg_85_1, var_85_0 .. "star0" .. iter_85_0, false)
		end
		
		for iter_85_1 = 1, 3 do
			if_set_visible(arg_85_1, var_85_0 .. "icon_skill0" .. iter_85_1, false)
		end
		
		arg_85_0.skill_tooltips = {}
		
		return 
	end
	
	local var_85_1 = arg_85_2:getStat()
	local var_85_2 = arg_85_2:getStatus()
	
	if arg_85_3.base then
		local var_85_3 = arg_85_2:getBaseStat()
		
		var_85_2 = arg_85_2:getCharacterStatus()
	end
	
	if_set(arg_85_1, var_85_0 .. "txt_stat00", comma_value(arg_85_2:getPoint(var_85_2)))
	if_set(arg_85_1, var_85_0 .. "txt_stat13", arg_85_2:getMaxLevel())
	if_set(arg_85_1, var_85_0 .. "txt_stat11", "0")
	
	local var_85_4, var_85_5 = arg_85_2:getExpString()
	
	if arg_85_3 and arg_85_3.exp_percent then
		var_85_4 = "exp " .. math.floor(var_85_5 * 100) .. "%"
	end
	
	if_set(arg_85_1, var_85_0 .. "txt_exp", var_85_4)
	
	arg_85_3.exp_gauge_min = arg_85_3.exp_gauge_min or 1
	arg_85_3.exp_gauge_max = arg_85_3.exp_gauge_max or 380
	
	local var_85_6 = arg_85_1:getChildByName(var_85_0 .. "exp_gauge")
	
	if var_85_6 and var_85_6.setPercent and not arg_85_3.ignore_gauge then
		var_85_6:setPercent(100 * var_85_5)
	end
	
	if_set(arg_85_1, "txt_element", T("hero_ele_" .. arg_85_2.db.color))
	if_set(arg_85_1, "txt_chara_info", T(DB("character", arg_85_2.inst.code, "2line")))
	
	local var_85_7
	
	if arg_85_3.ignore_stat_diff then
		var_85_7 = 0
	end
	
	if_set(arg_85_1, "label_bp", T("unit_power"))
	if_set(arg_85_1, "txt_name_stat01", getStatName("att"))
	if_set(arg_85_1, "txt_name_stat02", getStatName("acc"))
	if_set(arg_85_1, "txt_name_stat03", getStatName("cri"))
	if_set(arg_85_1, "txt_name_stat04", getStatName("cri_dmg"))
	if_set(arg_85_1, "txt_name_stat05", getStatName("max_hp"))
	if_set(arg_85_1, "txt_name_stat06", getStatName("def"))
	if_set(arg_85_1, "txt_name_stat07", getStatName("speed"))
	if_set(arg_85_1, "txt_name_stat08", getStatName("res"))
	if_set(arg_85_1, "txt_name_stat09", getStatName("coop"))
	if_set_visible(arg_85_1, "txt_name_stat10", false)
	if_set(arg_85_1, var_85_0 .. "txt_stat01", var_85_2.att)
	if_set(arg_85_1, var_85_0 .. "txt_stat02", var_85_2.acc, false, "ratioExpand")
	if_set(arg_85_1, var_85_0 .. "txt_stat03", var_85_2.cri, false, "ratioExpand")
	if_set(arg_85_1, var_85_0 .. "txt_stat04", var_85_2.cri_dmg, false, "ratioExpand")
	
	if FORMULA.isMoreThanStatLimit("cri", var_85_2.cri) then
		if_set_color(arg_85_1, var_85_0 .. "txt_stat03", arg_85_0.ORANGE)
	else
		if_set_color(arg_85_1, var_85_0 .. "txt_stat03", arg_85_0.WHITE)
	end
	
	if FORMULA.isMoreThanStatLimit("cri_dmg", var_85_2.cri_dmg) then
		if_set_color(arg_85_1, var_85_0 .. "txt_stat04", arg_85_0.ORANGE)
	else
		if_set_color(arg_85_1, var_85_0 .. "txt_stat04", arg_85_0.WHITE)
	end
	
	if FORMULA.isMoreThanStatLimit("coop", var_85_2.coop) then
		if_set_color(arg_85_1, var_85_0 .. "txt_stat09", arg_85_0.ORANGE)
	else
		if_set_color(arg_85_1, var_85_0 .. "txt_stat09", arg_85_0.WHITE)
	end
	
	if_set(arg_85_1, var_85_0 .. "txt_stat05", var_85_2.max_hp)
	if_set(arg_85_1, var_85_0 .. "txt_stat06", var_85_2.def)
	if_set(arg_85_1, var_85_0 .. "txt_stat07", var_85_2.speed)
	if_set(arg_85_1, var_85_0 .. "txt_stat08", var_85_2.res, false, "ratioExpand")
	if_set(arg_85_1, var_85_0 .. "txt_stat09", var_85_2.coop, false, "ratioExpand")
	if_set_visible(arg_85_1, "txt_stat10", false)
	if_set(arg_85_1, var_85_0 .. "txt_str_value", arg_85_2:getPoint(var_85_2))
	UIUtil:setDiffTextAndArrow(arg_85_1, var_85_0 .. "diff_txt_stat01", "diff_arrow_01", var_85_7 or arg_85_2:getDiff("att"))
	UIUtil:setDiffTextAndArrow(arg_85_1, var_85_0 .. "diff_txt_stat02", "diff_arrow_02", var_85_7 or arg_85_2:getDiff("acc"), "ratioExpand")
	UIUtil:setDiffTextAndArrow(arg_85_1, var_85_0 .. "diff_txt_stat03", "diff_arrow_03", var_85_7 or arg_85_2:getDiff("cri"), "ratioExpand")
	UIUtil:setDiffTextAndArrow(arg_85_1, var_85_0 .. "diff_txt_stat04", "diff_arrow_04", var_85_7 or arg_85_2:getDiff("cri_dmg"), "ratioExpand")
	UIUtil:setDiffTextAndArrow(arg_85_1, var_85_0 .. "diff_txt_stat05", "diff_arrow_05", var_85_7 or arg_85_2:getDiff("max_hp"))
	UIUtil:setDiffTextAndArrow(arg_85_1, var_85_0 .. "diff_txt_stat06", "diff_arrow_06", var_85_7 or arg_85_2:getDiff("def"))
	UIUtil:setDiffTextAndArrow(arg_85_1, var_85_0 .. "diff_txt_stat07", "diff_arrow_07", var_85_7 or arg_85_2:getDiff("speed"))
	UIUtil:setDiffTextAndArrow(arg_85_1, var_85_0 .. "diff_txt_stat08", "diff_arrow_08", var_85_7 or arg_85_2:getDiff("res"), "ratioExpand")
	UIUtil:setDiffTextAndArrow(arg_85_1, var_85_0 .. "diff_txt_stat09", "diff_arrow_09", var_85_7 or arg_85_2:getDiff("coop"), "ratioExpand")
	if_set_visible(arg_85_1, "diff_txt_stat10", false)
	if_set_visible(arg_85_1, "btn_locked", arg_85_2:isLocked())
	if_set_visible(arg_85_1, "btn_lock", not arg_85_2:isLocked())
	if_set(arg_85_1, "txt_max_lv", arg_85_2:getMaxLevel())
	
	if arg_85_1:getChildByName(var_85_0 .. "star1") then
		if arg_85_3.hide_star then
			for iter_85_2 = 1, 6 do
				if_set_visible(arg_85_1, var_85_0 .. "star" .. iter_85_2, false)
			end
		elseif arg_85_3.use_basic_star then
			for iter_85_3 = 1, 6 do
				if_set_visible(arg_85_1, var_85_0 .. "star" .. iter_85_3, iter_85_3 <= arg_85_2:getGrade())
			end
		else
			UIUtil:setStarsByUnit(arg_85_1, arg_85_2, arg_85_3.reverse_upgrade_star, var_85_0 .. "star")
		end
	end
	
	local var_85_8 = 1
	
	arg_85_2:eachSetItemApply(function(arg_86_0)
		SpriteCache:resetSprite(arg_85_1:getChildByName("icon_set" .. var_85_8), EQUIP:getSetItemIconPath(arg_86_0))
		if_set(arg_85_1, "txt_set" .. var_85_8, T(DB("item_set", arg_86_0, "name")))
		if_set_opacity(arg_85_1, "txt_set" .. var_85_8, 255)
		if_set_opacity(arg_85_1, "icon_set" .. var_85_8, 255)
		if_set_visible(arg_85_1, "icon_set" .. var_85_8, true)
		
		var_85_8 = var_85_8 + 1
	end)
	
	for iter_85_4 = var_85_8, 3 do
		if get_cocos_refid(arg_85_1) and get_cocos_refid(arg_85_1:getChildByName("txt_set" .. iter_85_4)) then
			SpriteCache:resetSprite(arg_85_1:getChildByName("icon_set" .. iter_85_4), "img/cm_icon_etcbp.png")
			if_set(arg_85_1, "txt_set" .. iter_85_4, T("no_set"))
			if_set_opacity(arg_85_1, "txt_set" .. iter_85_4, 100)
			if_set_opacity(arg_85_1, "icon_set" .. iter_85_4, 100)
		else
			if_set_visible(arg_85_1, "icon_set" .. iter_85_4, false)
		end
	end
end

function UIUtil.getColorIcon(arg_87_0, arg_87_1)
	local var_87_0 = "img/cm_icon_pro"
	
	if arg_87_1.db.moonlight then
		var_87_0 = var_87_0 .. "m"
	end
	
	return var_87_0 .. arg_87_1.db.color .. ".png"
end

function UIUtil.getSkillEffectTip(arg_88_0, arg_88_1, arg_88_2, arg_88_3)
	local var_88_0 = tonumber(arg_88_3) or 8
	
	arg_88_2 = arg_88_2 or 1
	
	local var_88_1 = string.split(arg_88_1, ",")
	
	if arg_88_2 > table.count(var_88_1) then
		arg_88_2 = table.count(var_88_1)
	end
	
	local var_88_2 = SLOW_DB_ALL("skill_effectexplain", tostring(var_88_1[arg_88_2]))
	
	if table.empty(var_88_2) then
		return 
	end
	
	local var_88_3 = cc.CSLoader:createNode("wnd/skill_eff.csb")
	
	if var_88_2.icon then
		if_set_sprite(var_88_3, "icon", "buff/" .. var_88_2.icon .. ".png")
	else
		var_88_3:getChildByName("n_head"):setPositionX(0)
	end
	
	if_set_visible(var_88_3, "icon", var_88_2.icon ~= nil)
	
	local var_88_4 = var_88_3:getChildByName("bg")
	local var_88_5 = var_88_3:getChildByName("txt_name")
	local var_88_6 = var_88_3:getChildByName("txt_desc")
	
	UIUserData:call(var_88_5, "MULTI_SCALE(2,70)")
	if_set(var_88_5, nil, T(var_88_2.name))
	var_88_6:ignoreContentAdaptWithSize(false)
	UIUserData:call(var_88_6, string.format("MULTI_SCALE(%d)", var_88_0))
	if_set(var_88_6, nil, T(var_88_2.effect))
	set_height_from_node(var_88_4, var_88_6, {
		add = 75
	})
	
	if var_88_2.type == "debuff" then
		var_88_4:setColor(cc.c3b(115, 27, 27))
		var_88_5:enableOutline(cc.c3b(115, 31, 30), 1)
		var_88_6:setTextColor(cc.c3b(255, 129, 119))
		var_88_6:enableOutline(cc.c3b(115, 31, 30), 1)
	elseif var_88_2.type == "common" then
		var_88_4:setColor(cc.c3b(61, 34, 34))
		var_88_5:enableOutline(cc.c3b(60, 43, 35), 1)
		var_88_6:setTextColor(cc.c3b(196, 151, 97))
		var_88_6:enableOutline(cc.c3b(60, 43, 35), 1)
	end
	
	return var_88_3
end

function UIUtil.attachEffectsTooltip(arg_89_0, arg_89_1, arg_89_2, arg_89_3)
	local function var_89_0(arg_90_0)
		local var_90_0 = 0
		local var_90_1 = 0
		local var_90_2
		
		for iter_90_0, iter_90_1 in pairs(arg_90_0) do
			local var_90_3 = iter_90_1:getChildByName("txt_desc")
			
			if get_cocos_refid(var_90_3) then
				local var_90_4 = var_90_3:getScaleX()
				
				if var_90_4 - var_90_0 > 0.001 then
					var_90_0 = var_90_4
					var_90_2 = iter_90_1
				elseif math.abs(var_90_4 - var_90_0) < 0.001 then
					local var_90_5 = var_90_3:getStringNumLines()
					
					if var_90_1 < var_90_5 then
						var_90_1 = var_90_5
						var_90_2 = iter_90_1
					end
				end
			end
		end
		
		return var_90_2
	end
	
	local function var_89_1(arg_91_0, arg_91_1)
		if not arg_91_1 then
			if_set_visible(arg_91_0, "icon", false)
			if_set_position_x(arg_91_0, "n_head", 0)
			
			return 
		end
		
		if_set_visible(arg_91_0, "icon", true)
		if_set_sprite(arg_91_0, "icon", "buff/" .. arg_91_1 .. ".png")
	end
	
	local function var_89_2(arg_92_0, arg_92_1)
		if_set(arg_92_0, "txt_name", arg_92_1)
	end
	
	local function var_89_3(arg_93_0, arg_93_1)
		local var_93_0 = arg_93_0:getChildByName("txt_name")
		
		if not get_cocos_refid(var_93_0) then
			return 
		end
		
		local var_93_1 = arg_93_0:getChildByName("txt_desc")
		
		if not get_cocos_refid(var_93_1) then
			return 
		end
		
		if arg_93_1 == "debuff" then
			if_set_color(arg_93_0, "bg", cc.c3b(115, 27, 27))
			var_93_0:enableOutline(cc.c3b(115, 31, 30), 1)
			var_93_1:setTextColor(cc.c3b(255, 129, 119))
			var_93_1:enableOutline(cc.c3b(115, 31, 30), 1)
		elseif arg_93_1 == "common" then
			if_set_color(arg_93_0, "bg", cc.c3b(61, 34, 34))
			var_93_0:enableOutline(cc.c3b(60, 43, 35), 1)
			var_93_1:setTextColor(cc.c3b(196, 151, 97))
			var_93_1:enableOutline(cc.c3b(60, 43, 35), 1)
		end
	end
	
	local function var_89_4(arg_94_0, arg_94_1, arg_94_2)
		arg_94_2 = arg_94_2 or {}
		
		local var_94_0 = arg_94_0:getChildByName("txt_desc")
		
		if not get_cocos_refid(var_94_0) then
			return 
		end
		
		var_94_0:ignoreContentAdaptWithSize(false)
		
		if arg_94_2.limit_line then
			UIUserData:call(var_94_0, string.format("MULTI_SCALE(%d, 5)", arg_94_2.limit_line))
		end
		
		if_set(var_94_0, nil, arg_94_1)
		
		local var_94_1 = arg_94_0:getChildByName("bg")
		
		if not get_cocos_refid(var_94_1) then
			return 
		end
		
		set_height_from_node(var_94_1, var_94_0, {
			add = 75
		})
		
		arg_94_0.desc = arg_94_1
		arg_94_0.desc_num_lines = var_94_0:getStringNumLines()
		arg_94_0.height = var_94_1:getContentSize().height * var_94_1:getScaleY()
		arg_94_0.width = var_94_1:getContentSize().width * var_94_1:getScaleX()
	end
	
	local function var_89_5(arg_95_0)
		if not arg_95_0 then
			return 0
		end
		
		local var_95_0 = 0
		
		for iter_95_0, iter_95_1 in pairs(arg_95_0) do
			var_95_0 = var_95_0 + iter_95_1.height
		end
		
		return var_95_0
	end
	
	local var_89_6 = {}
	
	for iter_89_0, iter_89_1 in pairs(arg_89_2) do
		if iter_89_1 then
			local var_89_7 = SLOW_DB_ALL("skill_effectexplain", tostring(iter_89_1))
			
			if var_89_7 then
				local var_89_8 = load_control("wnd/skill_eff.csb")
				
				if get_cocos_refid(var_89_8) then
					var_89_1(var_89_8, var_89_7.icon)
					var_89_3(var_89_8, var_89_7.type)
					var_89_2(var_89_8, T(var_89_7.name))
					var_89_4(var_89_8, T(var_89_7.effect))
					table.push(var_89_6, var_89_8)
				end
			end
		end
	end
	
	local var_89_9 = 20
	
	while VIEW_HEIGHT < var_89_5(var_89_6) do
		var_89_9 = var_89_9 - 1
		
		if var_89_9 == 0 then
			break
		end
		
		local var_89_10 = var_89_0(var_89_6)
		
		if get_cocos_refid(var_89_10) then
			var_89_4(var_89_10, var_89_10.desc, {
				limit_line = var_89_10.desc_num_lines - 1
			})
		end
	end
	
	arg_89_1.height = 0
	
	if arg_89_3 then
		arg_89_1.width = 0
	end
	
	for iter_89_2, iter_89_3 in pairs(var_89_6) do
		iter_89_3:setAnchorPoint(arg_89_3 and 0 or 1, 1)
		iter_89_3:setPosition(arg_89_3 and 20 or 0, -arg_89_1.height - 5)
		arg_89_1:addChild(iter_89_3)
		
		arg_89_1.height = arg_89_1.height + var_89_6[iter_89_2].height
		
		if arg_89_3 then
			arg_89_1.width = math.max(arg_89_1.width, var_89_6[iter_89_2].width)
		end
	end
end

function UIUtil.getSkillTooltip(arg_96_0, arg_96_1, arg_96_2, arg_96_3)
	arg_96_3 = arg_96_3 or {}
	
	local var_96_0
	
	if arg_96_3.exclusive_tooltip and arg_96_3.exclusive_skill then
		var_96_0 = load_dlg("skill_private", true, "wnd")
		
		local var_96_1, var_96_2 = DB("skill", arg_96_2, {
			"sk_icon",
			"name"
		})
		local var_96_3 = cc.CSLoader:createNode("wnd/skill_icon.csb")
		
		SpriteCache:resetSprite(var_96_3:getChildByName("icon"), "skill/" .. var_96_1 .. ".png")
		var_96_3:setAnchorPoint(0.5, 0.5)
		if_set_visible(var_96_3, "soul1", false)
		if_set_visible(var_96_3, "up", false)
		if_set_visible(var_96_3, "upgrade", false)
		if_set_visible(var_96_3, "upgrade_passive", false)
		
		if arg_96_3.show_exclusive_target then
			if_set_visible(var_96_3, "n_skill_num", true)
			if_set_sprite(var_96_3, "img_skill_num_roma", "img/itxt_num" .. arg_96_3.show_exclusive_target .. "_roma_b")
		end
		
		var_96_0:getChildByName("n_skill_icon"):addChild(var_96_3)
		
		local var_96_4 = DB("skill_equip", arg_96_3.exclusive_skill, {
			"exc_desc"
		})
		
		if_set(var_96_0, "txt_skill_name", T(var_96_2))
		if_set(var_96_0, "txt_skill_desc", T(var_96_4))
		
		local var_96_5 = var_96_0:getChildByName("txt_skill_desc"):getStringNumLines()
		local var_96_6 = 0
		
		if var_96_5 >= 4 then
			var_96_6 = 25 * (var_96_5 - 3)
		end
		
		local var_96_7 = var_96_0:getChildByName("bg")
		local var_96_8 = var_96_7:getContentSize()
		
		var_96_7:setContentSize({
			width = var_96_8.width,
			height = var_96_8.height + var_96_6
		})
	else
		var_96_0 = arg_96_0:getSkillDetail(arg_96_1, arg_96_2, arg_96_3)
	end
	
	local var_96_9 = var_96_0:getChildren()
	local var_96_10 = {}
	
	for iter_96_0, iter_96_1 in pairs(var_96_9) do
		var_96_10[iter_96_1:getName()] = iter_96_1
	end
	
	local var_96_11 = 23
	
	if arg_96_1 and (arg_96_1:isSummon() or arg_96_1:isSpecialUnit()) then
		arg_96_3.hide_stat = true
	end
	
	if var_96_10.n_etc_data then
		if arg_96_3.is_locked then
			local var_96_12 = var_96_10.n_etc_data:getChildByName("txt")
			local var_96_13 = -60
			local var_96_14 = 40
			
			if get_cocos_refid(var_96_12) then
				var_96_14 = var_96_14 + var_96_12:getTextBoxSize().height * var_96_12:getScaleY()
			end
			
			var_96_11 = var_96_11 + var_96_14
			
			var_96_10.n_etc_data:setPositionY(var_96_11 + var_96_13)
			var_96_10.n_etc_data:setVisible(true)
		else
			var_96_10.n_etc_data:setVisible(false)
		end
	end
	
	if var_96_10.n_up then
		if not arg_96_3.hide_stat then
			local var_96_15 = 40
			
			for iter_96_2 = 1, 8 do
				if var_96_10.n_up:getChildByName(iter_96_2):isVisible() then
					var_96_15 = var_96_15 + 23
				end
			end
			
			var_96_11 = var_96_11 + var_96_15
			
			var_96_10.n_up:setPositionY(var_96_11)
			var_96_10.n_up:setVisible(true)
		else
			var_96_10.n_up:setVisible(false)
		end
	end
	
	if var_96_10.n_combo then
		if not arg_96_3.hide_combo then
			if var_96_10.n_combo:isVisible() then
				var_96_11 = var_96_11 + 70
				
				var_96_10.n_combo:setPositionY(var_96_11)
			end
		else
			var_96_10.n_combo:setVisible(false)
		end
	end
	
	if var_96_10.n_soul then
		var_96_10.n_soul:setPositionY(var_96_11)
		
		if var_96_10.n_soul:isVisible() then
			local var_96_16 = var_96_10.n_soul:getChildByName("txt_soul_desc")
			
			var_96_11 = var_96_11 + var_96_16:getTextBoxSize().height * var_96_16:getScaleY() + 10
			
			var_96_10.n_soul:setPositionY(var_96_11)
			
			var_96_11 = var_96_11 + 50
		end
	end
	
	if var_96_10.n_head then
		local var_96_17 = var_96_10.n_head:getChildByName("txt_desc")
		
		var_96_17:getTextBoxSize()
		
		var_96_11 = var_96_11 + (var_96_17:getStringNumLines() * 21 + 10)
		
		var_96_10.n_head:setPositionY(var_96_11)
		
		var_96_11 = var_96_11 + 100
	end
	
	local var_96_18 = {}
	
	if arg_96_1 and var_96_0.skill_id then
		var_96_18 = arg_96_1:getExclusiveEffect(arg_96_1:getReferSkillIndex(var_96_0.skill_id))
	end
	
	local var_96_19 = var_96_0:getChildByName("wnd")
	local var_96_20 = var_96_0:getChildByName("n_effs")
	
	if var_96_19 then
		local var_96_21 = var_96_19:getContentSize()
		
		var_96_19:setContentSize(var_96_21.width, var_96_11 + 64)
		var_96_0:setContentSize(var_96_21.width, var_96_11 + 64)
		
		if var_96_20 then
			var_96_20:setPositionY(var_96_11)
		end
		
		local var_96_22 = var_96_0:getChildByName("n_flags")
		
		if var_96_22 then
			var_96_22:setPositionY(var_96_11)
		end
	end
	
	var_96_0.skill_tooltip_height = var_96_11
	
	if arg_96_3.show_effs then
		if arg_96_3.show_effs == "left" then
			var_96_20:setPositionX(0)
		end
		
		local var_96_23 = {}
		
		if var_96_18.skill_desc and not table.empty(var_96_18.explain) then
			var_96_23 = var_96_18.explain
		else
			var_96_23[1], var_96_23[2], var_96_23[3], var_96_23[4] = DB("skill", var_96_0.skill_id, {
				"sk_eff_explain1",
				"sk_eff_explain2",
				"sk_eff_explain3",
				"sk_eff_explain4"
			})
		end
		
		arg_96_0:attachEffectsTooltip(var_96_20, var_96_23, arg_96_3.show_effs == "right")
	end
	
	return var_96_0
end

function MsgHandler.inc_unit_inven(arg_97_0)
	local var_97_0 = AccountData.unit_inven
	
	Account:updateCurrencies(arg_97_0)
	TopBarNew:topbarUpdate(true)
	
	if arg_97_0.unit_inven then
		AccountData.unit_inven = arg_97_0.unit_inven
		
		Dialog:msgBoxLevelUp({
			text = T("ui_hero_inventory_expand_de"),
			title = T("ui_hero_inventory_expand_tl"),
			after_score = AccountData.unit_inven,
			before_score = var_97_0
		})
	end
	
	if (SceneManager:getCurrentSceneName() == "unit_ui" or UnitMain:isValid()) and arg_97_0.unit_inven then
		local var_97_1 = UnitMain:getHeroBelt()
		
		if var_97_1:isValid() then
			var_97_1:updateHeroCount()
		end
	end
	
	if HeroBelt:isValid() then
		HeroBelt:updateHeroCount()
	end
	
	if UnitUnfold:isValid() then
		UnitUnfold:updateHeroCount()
	end
end

function MsgHandler.inc_equip_inven(arg_98_0)
	local var_98_0 = AccountData.equip_inven
	
	AccountData.equip_inven = arg_98_0.equip_inven
	
	Account:addReward(arg_98_0.rewards)
	Inventory:updateItemInvenCount()
	TopBarNew:topbarUpdate(true)
	SceneManager:dispatchGameEvent("inc_equip_inven", arg_98_0)
	
	if arg_98_0.equip_inven and UnitEquip:isEquipBeltVisible() then
		UnitEquip:getEquipBelt():UpdateEquipListCounter()
	end
	
	if arg_98_0.equip_inven and EquipBelt:isVisible() then
		EquipBelt:UpdateEquipListCounter()
	end
	
	if EquipStorageMain and EquipStorageMain.vars then
		EquipStorageMain:updateIncInventoryCount()
	end
	
	Dialog:msgBoxLevelUp({
		text = T("ui_equip_inventory_expand_de"),
		title = T("ui_equip_inventory_expand_tl"),
		after_score = arg_98_0.equip_inven,
		before_score = var_98_0
	})
	SoundEngine:play("event:/ui/inc_equip_inven")
end

function MsgHandler.inc_artifact_inven(arg_99_0)
	local var_99_0 = AccountData.artifact_inven
	
	AccountData.artifact_inven = arg_99_0.artifact_inven
	
	Account:addReward(arg_99_0.rewards)
	Inventory:updateItemInvenCount()
	TopBarNew:topbarUpdate(true)
	SceneManager:dispatchGameEvent("inc_artifact_inven", arg_99_0)
	
	if arg_99_0.artifact_inven and UnitEquip:isEquipBeltVisible() then
		UnitEquip:getEquipBelt():UpdateEquipListCounter()
	end
	
	if arg_99_0.artifact_inven and EquipBelt:isVisible() then
		EquipBelt:UpdateEquipListCounter()
	end
	
	Dialog:msgBoxLevelUp({
		text = T("ui_artifact_inventory_expand_de"),
		title = T("ui_artifact_inventory_expand_tl"),
		after_score = arg_99_0.artifact_inven,
		before_score = var_99_0
	})
	SoundEngine:play("event:/ui/inc_equip_inven")
end

function MsgHandler.inc_pet_inven(arg_100_0)
	Account:updateCurrencies(arg_100_0)
	TopBarNew:topbarUpdate(true)
	
	if arg_100_0.pet_inven then
		AccountData.pet_inven = arg_100_0.pet_inven
		
		balloon_message_with_sound("inc_pet_inven", {}, "ui/inc_unit_inven")
	end
	
	local var_100_0 = UIUtil:getPetBelts()
	
	for iter_100_0, iter_100_1 in pairs(var_100_0) do
		if iter_100_1:isValid() then
			iter_100_1:updatePetCount()
		end
	end
end

function UIUtil.addPetBelt(arg_101_0, arg_101_1, arg_101_2)
	if not arg_101_1 or not arg_101_2 then
		return 
	end
	
	arg_101_0.pet_belts = arg_101_0.pet_belts or {}
	arg_101_0.pet_belts[arg_101_1] = arg_101_2
end

function UIUtil.deletePetBelt(arg_102_0, arg_102_1)
	if table.empty(arg_102_0.pet_belts) or not arg_102_1 then
		return 
	end
	
	if arg_102_0.pet_belts[arg_102_1] then
		arg_102_0.pet_belts[arg_102_1] = nil
	end
end

function UIUtil.getPetBelts(arg_103_0)
	return arg_103_0.pet_belts or {}
end

function UIUtil.showIncHeroInvenDialog(arg_104_0)
	if Account:getMaxHeroCount() <= Account:getCurrentHeroCount() then
		balloon_message_with_sound("max_hero_inven")
		
		return 
	end
	
	local var_104_0 = (Account:getMaxHeroCount() - Account:getCurrentHeroCount()) / 5
	local var_104_1 = 0
	
	for iter_104_0 = 1, Account:getMaxHeroCount() do
		if Account:getIncHeroInvenCost(var_104_1) > Account:getCurrency("crystal") then
			break
		end
		
		var_104_1 = iter_104_0
	end
	
	if var_104_1 < 1 then
		balloon_message_with_sound("no_crystal")
		
		return 
	end
	
	local var_104_2 = {
		slider_pos = 1,
		min = 1,
		yesno = true,
		slider_handler = function(arg_105_0, arg_105_1, arg_105_2)
			if_set(arg_105_0, "txt_title", T("req_hero_inven"))
			if_set(arg_105_0, "txt_add_count", "+" .. comma_value(arg_105_1 * 5))
			if_set(arg_105_0, "text", T("limit_character", {
				count = arg_105_1 * 5
			}))
			if_set(arg_105_0, "txt_slide", arg_105_1 * 5 + Account:getCurrentHeroCount() .. "/" .. 5 * var_104_0 + Account:getCurrentHeroCount())
			
			arg_105_0.need_crystal = Account:getIncHeroInvenCost(arg_105_1)
			
			if_set(arg_105_0, "txt_rest", comma_value(arg_105_0.need_crystal))
			UIUtil:changeButtonState(arg_105_0.c.btn_yes, Account:getCurrency("crystal") >= arg_105_0.need_crystal, true)
		end,
		token = GAME_STATIC_VARIABLE.inven_hero_add_token,
		max = var_104_0,
		handler = function(arg_106_0, arg_106_1, arg_106_2)
			if not arg_104_0:checkCurrencyDialog("crystal", to_n(arg_106_0.need_crystal)) then
				return 
			end
			
			local var_106_0 = arg_106_0.slider:getPercent()
			
			if var_106_0 > 0 then
				query("inc_unit_inven", {
					value = var_106_0
				})
			end
		end
	}
	local var_104_3 = Dialog:msgBoxSlider(var_104_2)
end

function UIUtil.showIncPetInvenDialog(arg_107_0)
	if Account:getMaxPetCount() <= Account:getCurrentPetCount() then
		balloon_message_with_sound("max_pet_inven")
		
		return 
	end
	
	local var_107_0 = (Account:getMaxPetCount() - Account:getCurrentPetCount()) / 5
	local var_107_1 = 0
	
	for iter_107_0 = 1, Account:getMaxPetCount() do
		if Account:getIncPetInvenCost(var_107_1) > Account:getCurrency("crystal") then
			break
		end
		
		var_107_1 = iter_107_0
	end
	
	if var_107_1 < 1 then
		balloon_message_with_sound("no_crystal")
		
		return 
	end
	
	local var_107_2 = {
		slider_pos = 1,
		min = 1,
		yesno = true,
		slider_handler = function(arg_108_0, arg_108_1, arg_108_2)
			if_set(arg_108_0, "txt_title", T("req_pet_inven"))
			if_set(arg_108_0, "txt_add_count", "+" .. comma_value(arg_108_1 * 5))
			if_set(arg_108_0, "text", T("limit_pet", {
				count = arg_108_1 * 5
			}))
			if_set(arg_108_0, "txt_slide", arg_108_1 * 5 + Account:getCurrentPetCount() .. "/" .. 5 * var_107_0 + Account:getCurrentPetCount())
			
			arg_108_0.need_crystal = Account:getIncPetInvenCost(arg_108_1)
			
			if_set(arg_108_0, "txt_rest", comma_value(arg_108_0.need_crystal))
			UIUtil:changeButtonState(arg_108_0.c.btn_yes, Account:getCurrency("crystal") >= arg_108_0.need_crystal, true)
		end,
		token = GAME_STATIC_VARIABLE.inven_pet_add_token,
		max = var_107_0,
		handler = function(arg_109_0, arg_109_1, arg_109_2)
			if not arg_107_0:checkCurrencyDialog("crystal", to_n(arg_109_0.need_crystal)) then
				return 
			end
			
			query("inc_pet_inven", {
				value = arg_109_0.slider:getPercent()
			})
		end
	}
	local var_107_3 = Dialog:msgBoxSlider(var_107_2)
end

function UIUtil.showIncEquipInvenDialog(arg_110_0)
	if Account:getMaxEquipCount() <= Account:getCurrentEquipCount() then
		balloon_message_with_sound("max_equip_inven")
		
		return 
	end
	
	local var_110_0 = (Account:getMaxEquipCount() - Account:getCurrentEquipCount()) / 5
	local var_110_1 = 0
	
	for iter_110_0 = 1, Account:getMaxEquipCount() do
		if Account:getIncEquipInvenCost(var_110_1) > Account:getCurrency("crystal") then
			break
		end
		
		var_110_1 = iter_110_0
	end
	
	if var_110_1 == 0 then
		balloon_message_with_sound("no_crystal")
		
		return 
	end
	
	local var_110_2 = {
		slider_pos = 1,
		min = 1,
		yesno = true,
		slider_handler = function(arg_111_0, arg_111_1, arg_111_2)
			if_set(arg_111_0, "txt_title", T("req_equip_inven"))
			if_set(arg_111_0, "txt_add_count", "+" .. comma_value(arg_111_1 * 5))
			if_set(arg_111_0, "text", T("limit_equip", {
				count = arg_111_1 * 5
			}))
			if_set(arg_111_0, "txt_slide", arg_111_1 * 5 + Account:getCurrentEquipCount() .. "/" .. 5 * var_110_0 + Account:getCurrentEquipCount())
			
			arg_111_0.need_crystal = Account:getIncEquipInvenCost(arg_111_1)
			
			if_set(arg_111_0, "txt_rest", comma_value(arg_111_0.need_crystal))
			if_set(arg_111_0, T("need_crystal", {
				count = arg_111_0.need_crystal
			}))
			UIUtil:changeButtonState(arg_111_0.c.btn_yes, Account:getCurrency("crystal") >= arg_111_0.need_crystal, true)
		end,
		token = GAME_STATIC_VARIABLE.inven_equip_add_token,
		max = var_110_0,
		handler = function(arg_112_0, arg_112_1, arg_112_2)
			if not arg_110_0:checkCurrencyDialog("crystal", to_n(arg_112_0.need_crystal)) then
				return 
			end
			
			query("inc_equip_inven", {
				value = arg_112_0.slider:getPercent()
			})
		end
	}
	
	Dialog:msgBoxSlider(var_110_2)
end

function UIUtil.showIncEquipStorageDialog(arg_113_0)
	if GAME_CONTENT_VARIABLE.inven_storage_box_max <= Account:getEquipStorageMaxCount() then
		balloon_message_with_sound("storage_noti")
		
		return 
	end
	
	local var_113_0 = (GAME_CONTENT_VARIABLE.inven_storage_box_max - Account:getEquipStorageMaxCount()) / 5
	local var_113_1 = 0
	
	for iter_113_0 = 1, GAME_CONTENT_VARIABLE.inven_storage_box_max do
		if var_113_1 * GAME_CONTENT_VARIABLE.inven_storage_box_add_price > Account:getCurrency("crystal") then
			break
		end
		
		var_113_1 = iter_113_0
	end
	
	if var_113_1 == 0 then
		balloon_message_with_sound("no_crystal")
		
		return 
	end
	
	local var_113_2 = {
		slider_pos = 1,
		min = 1,
		yesno = true,
		slider_handler = function(arg_114_0, arg_114_1, arg_114_2)
			if_set(arg_114_0, "txt_title", T("storage_add_title"))
			if_set(arg_114_0, "txt_add_count", "+" .. comma_value(arg_114_1 * 5))
			if_set(arg_114_0, "text", T("storage_add_desc", {
				count = arg_114_1 * 5
			}))
			if_set(arg_114_0, "txt_slide", arg_114_1 * 5 + Account:getEquipStorageMaxCount() .. "/" .. 5 * var_113_0 + Account:getEquipStorageMaxCount())
			
			arg_114_0.need_crystal = Account:getIncEquipInvenCost(arg_114_1)
			
			if_set(arg_114_0, "txt_rest", comma_value(arg_114_0.need_crystal))
			if_set(arg_114_0, T("need_crystal", {
				count = arg_114_0.need_crystal
			}))
			UIUtil:changeButtonState(arg_114_0.c.btn_yes, Account:getCurrency("crystal") >= arg_114_0.need_crystal, true)
		end,
		token = GAME_CONTENT_VARIABLE.inven_storage_box_add_token,
		max = var_113_0,
		handler = function(arg_115_0, arg_115_1, arg_115_2)
			if not arg_113_0:checkCurrencyDialog("crystal", to_n(arg_115_0.need_crystal)) then
				return 
			end
			
			query("inc_equip_storage_inven", {
				value = arg_115_0.slider:getPercent()
			})
		end
	}
	
	Dialog:msgBoxSlider(var_113_2)
end

function UIUtil.showIncArtiEquipInvenDialog(arg_116_0)
	if Account:getMaxArtifactCount() <= Account:getCurrentArtifactCount() then
		balloon_message_with_sound("max_equip_inven")
		
		return 
	end
	
	local var_116_0 = (Account:getMaxArtifactCount() - Account:getCurrentArtifactCount()) / 5
	local var_116_1 = 0
	
	for iter_116_0 = 1, Account:getMaxArtifactCount() do
		if Account:getIncArtiEquipInvenCost(var_116_1) > Account:getCurrency("crystal") then
			break
		end
		
		var_116_1 = iter_116_0
	end
	
	if var_116_1 == 0 then
		balloon_message_with_sound("no_crystal")
		
		return 
	end
	
	local var_116_2 = {
		slider_pos = 1,
		min = 1,
		yesno = true,
		slider_handler = function(arg_117_0, arg_117_1, arg_117_2)
			if_set(arg_117_0, "txt_title", T("req_artifact_inven"))
			if_set(arg_117_0, "txt_add_count", "+" .. comma_value(arg_117_1 * 5))
			if_set(arg_117_0, "text", T("limit_artifact", {
				count = arg_117_1 * 5
			}))
			if_set(arg_117_0, "txt_slide", arg_117_1 * 5 + Account:getCurrentArtifactCount() .. "/" .. 5 * var_116_0 + Account:getCurrentArtifactCount())
			
			arg_117_0.need_crystal = Account:getIncArtiEquipInvenCost(arg_117_1)
			
			if_set(arg_117_0, "txt_rest", comma_value(arg_117_0.need_crystal))
			if_set(arg_117_0, T("need_crystal", {
				count = arg_117_0.need_crystal
			}))
			UIUtil:changeButtonState(arg_117_0.c.btn_yes, Account:getCurrency("crystal") >= arg_117_0.need_crystal, true)
		end,
		token = GAME_CONTENT_VARIABLE.inven_artifact_add_token,
		max = var_116_0,
		handler = function(arg_118_0, arg_118_1, arg_118_2)
			if not arg_116_0:checkCurrencyDialog("crystal", to_n(arg_118_0.need_crystal)) then
				return 
			end
			
			query("inc_artifact_inven", {
				value = arg_118_0.slider:getPercent()
			})
		end
	}
	
	Dialog:msgBoxSlider(var_116_2)
end

function UIUtil.getMapMissionReward(arg_119_0, arg_119_1, arg_119_2, arg_119_3)
	arg_119_3 = arg_119_3 or {}
	
	return arg_119_0:getMissionReward(DB("level_enter", arg_119_1, "mission" .. arg_119_2), arg_119_3)
end

function UIUtil.getMissionReward(arg_120_0, arg_120_1, arg_120_2)
	arg_120_2 = arg_120_2 or {}
	
	local var_120_0, var_120_1 = DB("mission_data", arg_120_1, {
		"reward_id1",
		"reward_count1"
	})
	
	return (arg_120_0:getRewardIcon(var_120_1, var_120_0))
end

function UIUtil.getRewardTitle(arg_121_0, arg_121_1)
	local var_121_0
	
	if string.starts(arg_121_1, "to_") then
		return T(DB("item_token", arg_121_1, "desc_category"))
	elseif string.starts(arg_121_1, "ct_") then
		return T(DB("item_clantoken", arg_121_1, "desc_category"))
	elseif string.starts(arg_121_1, "e") then
		return T(DB("equip_item", arg_121_1, "desc_category"))
	elseif string.starts(arg_121_1, "ma_") then
		return T(DB("item_material", arg_121_1, "desc_category"))
	else
		return T("desc_category_" .. arg_121_1)
	end
end

function UIUtil.getTokenName(arg_122_0, arg_122_1)
	if string.starts(arg_122_1, "to_") then
		return T(DB("item_token", arg_122_1, "name"))
	end
	
	return ""
end

function UIUtil.getIconPath(arg_123_0, arg_123_1)
	local var_123_0
	
	if string.starts(arg_123_1, "e") and arg_123_1 ~= "exclusive" then
		var_123_0 = DB("item_equip", arg_123_1, "icon")
	elseif Account:isCurrencyType(arg_123_1) then
		var_123_0 = DB("item_token", "to_" .. arg_123_1, "icon")
	elseif string.starts(arg_123_1, "sp_") then
		var_123_0 = DB("item_special", arg_123_1, "icon")
	elseif string.starts(arg_123_1, "ma_") then
		var_123_0 = DB("item_material", arg_123_1, "icon")
	elseif string.starts(arg_123_1, "ct_") then
		var_123_0 = DB("item_clan", arg_123_1, "icon")
	end
	
	return "item/" .. (var_123_0 or "") .. ".png"
end

function UIUtil.getItemIcon(arg_124_0, arg_124_1)
	local var_124_0 = arg_124_1.equip
	local var_124_1 = arg_124_1.code
	local var_124_2 = arg_124_1.grade
	local var_124_3 = arg_124_1.name
	local var_124_4 = arg_124_1.count
	
	if not var_124_1 and var_124_0 then
		var_124_1 = var_124_0.code
	end
	
	local var_124_5
	local var_124_6 = string.starts(var_124_1, "e")
	local var_124_7 = var_124_6 and (arg_124_1.equip and arg_124_1.equip:isArtifact() or DB("equip_item", var_124_1, "type") == "artifact")
	local var_124_8
	
	if var_124_7 then
		var_124_8 = cc.CSLoader:createNode("wnd/item_art_icon.csb")
		
		if_set_visible(var_124_8, "cm_icon_tmp_inven", false)
		var_124_8:getChildByName("n_root"):setScale(0.7)
	else
		var_124_8 = cc.CSLoader:createNode("wnd/reward_icon.csb")
	end
	
	if var_124_6 then
		local var_124_9, var_124_10, var_124_11, var_124_12, var_124_13 = DB("equip_item", arg_124_1.code, {
			"icon",
			"grade_min",
			"grade_max",
			"type",
			"name"
		})
		
		if arg_124_1.grade_rate then
			local var_124_14
			
			var_124_10, var_124_14 = DB("item_equip_grade_rate", arg_124_1.grade_rate, {
				"min",
				"max"
			})
		end
		
		var_124_2 = var_124_2 or var_124_10
		
		local var_124_15 = "item/" .. var_124_9 .. ".png"
		local var_124_16 = EQUIP.getGradeTitle(var_124_1, var_124_2, var_124_12)
		
		if arg_124_1.equip then
			local var_124_17 = arg_124_1.equip:getName()
		else
			local var_124_18 = EQUIP.getName(nil, nil, equip_name, arg_124_1.set_fx)
		end
		
		if var_124_7 then
			if_set_visible(var_124_8, "n_stars", arg_124_1.no_grade ~= true)
			if_set_visible(var_124_8, "star" .. var_124_2 + 1, false)
			
			local var_124_19 = var_124_8:getChildByName("n_stars")
			
			if var_124_19 then
				var_124_19:setPositionX((6 - var_124_2) * 9)
			end
		end
	elseif string.starts(arg_124_1.code, "ma_") then
		local var_124_20
		
		var_124_20, var_124_3, type = DB("item_material", arg_124_1.code, {
			"icon",
			"name",
			"desc_category"
		})
		
		local var_124_21 = "item/" .. var_124_20 .. ".png"
	elseif string.starts(arg_124_1.code, "to_") then
		local var_124_22
		
		var_124_22, var_124_3, type = DB("item_token", arg_124_1.code, {
			"icon",
			"name",
			"desc_category"
		})
		
		local var_124_23 = "item/" .. var_124_22 .. ".png"
	elseif string.starts(arg_124_1.code, "ct_") then
		local var_124_24
		
		var_124_24, var_124_3, type = DB("item_clantoken", arg_124_1.code, {
			"icon",
			"name",
			"desc_category"
		})
		
		local var_124_25 = "item/" .. var_124_24 .. ".png"
	elseif string.starts(arg_124_1.code, "sp_") then
		local var_124_26
		
		var_124_26, var_124_3, type = DB("item_special", arg_124_1.code, {
			"icon",
			"name",
			"desc_category"
		})
		
		local var_124_27 = "item/" .. var_124_26 .. ".png"
	end
	
	if false then
	end
	
	local var_124_28
	
	var_124_28 = var_124_2 or 1
	
	if not arg_124_1.no_tooltip then
		WidgetUtils:setupTooltip({
			control = var_124_8,
			creator = function()
				return ItemTooltip:getItemTooltip({
					code = arg_124_1.code,
					grade = arg_124_1.grade,
					equip = arg_124_1.equip,
					set_fx = arg_124_1.set_fx,
					count = arg_124_1.count,
					enhance = arg_124_1.enhance,
					equip_stat = arg_124_1.equip_stat,
					faction = arg_124_1.faction,
					faction_category = arg_124_1.faction_category,
					icon_scale = arg_124_1.icon_scale,
					set_drop = arg_124_1.set_drop,
					grade_rate = arg_124_1.grade_rate
				})
			end,
			delay = arg_124_1.tooltip_delay
		})
	end
	
	local var_124_29 = arg_124_1.txt_type or var_124_8:getChildByName("txt_type")
	local var_124_30 = arg_124_1.txt_name or var_124_8:getChildByName("txt_name")
	
	if arg_124_1.txt_name then
		if_set_visible(var_124_8, "txt_name", false)
	end
	
	if arg_124_1.txt_type then
		if_set_visible(var_124_8, "txt_type", false)
	end
	
	if arg_124_1.show_name then
		if var_124_29 then
			var_124_29:setString(T(type))
		end
		
		if var_124_30 then
			var_124_30:setString(T(var_124_3))
		end
	end
	
	if_set_visible(var_124_8, "up_bg_normal", false)
	if_set_visible(var_124_8, "up_bg_max", false)
	if_set_visible(var_124_8, "up", false)
	
	if arg_124_1.equip then
		local var_124_31 = var_124_8:getChildByName("n_up")
		
		if arg_124_1.up_cont then
			var_124_31 = arg_124_1.up_cont
		end
		
		local var_124_32 = 15
		local var_124_33 = arg_124_1.equip:getEnhance() or 0
		
		if var_124_7 then
			var_124_32 = 30
		end
		
		if var_124_33 > 0 then
			var_124_31:setVisible(true)
			if_set_visible(var_124_31, "up_bg_normal", var_124_33 ~= var_124_32)
			if_set_visible(var_124_31, "up_bg_max", var_124_33 == var_124_32)
			
			if var_124_31:getChildByName("n_num") then
				arg_124_0:updateIconLevel(var_124_31, var_124_33, {
					is_extention = true,
					is_artifact = var_124_7,
					detail = arg_124_1.detail,
					is_enhancer = arg_124_1.is_enhancer
				})
			else
				Log.e("#36405 확인이 필요한 csd 파일입니다! by godteams", var_124_8:getName())
				if_set(var_124_31, "txt_up", "+" .. arg_124_1.equip:getEnhance())
			end
		else
			var_124_31:setVisible(false)
			if_set_visible(var_124_8, "n_up", false)
		end
		
		if_set_visible(var_124_8, "locked", arg_124_1.equip.lock)
	else
		if_set_visible(var_124_8, "locked", false)
		if_set_visible(var_124_8, "up", false)
	end
	
	arg_124_0:_setIconOpts(var_124_8, arg_124_1)
	
	return var_124_8
end

function UIUtil._setIconOpts(arg_126_0, arg_126_1, arg_126_2)
	local var_126_0 = arg_126_2.dlg_name or ".reward_icon"
	
	arg_126_1:setName(var_126_0)
	arg_126_1:setAnchorPoint(0.5, 0.5)
	
	if arg_126_2.parent then
		local var_126_1 = arg_126_2.parent
		
		if arg_126_2.target then
			var_126_1 = arg_126_2.parent:getChildByName(arg_126_2.target)
		end
		
		local var_126_2 = var_126_1:getChildByName(arg_126_1:getName())
		
		if var_126_2 then
			var_126_2:removeFromParent()
		end
		
		var_126_1:addChild(arg_126_1)
	end
	
	if arg_126_2.zero then
		arg_126_1:setAnchorPoint(0, 0)
	end
	
	if arg_126_2.x then
		arg_126_1:setPositionX(arg_126_2.x)
	end
	
	if arg_126_2.y then
		arg_126_1:setPositionY(arg_126_2.y)
	end
	
	if arg_126_2.no_bg then
		if_set_visible(arg_126_1, "bg", false)
	end
	
	if arg_126_2.effect then
		arg_126_0:regIconSpotEffect(arg_126_1, arg_126_2.effect_delay)
	end
	
	if arg_126_2.ax and arg_126_2.ay then
		arg_126_1:setAnchorPoint(arg_126_2.ax, arg_126_2.ay)
	end
end

function UIUtil.getCacheRewardIcon(arg_127_0, arg_127_1, arg_127_2, arg_127_3, arg_127_4, arg_127_5)
	if arg_127_1.reward_cache_opts then
		local var_127_0 = true
		
		for iter_127_0, iter_127_1 in pairs(arg_127_5) do
			if arg_127_5[iter_127_0] ~= arg_127_1.reward_cache_opts[iter_127_0] then
				var_127_0 = false
				
				break
			end
		end
		
		if var_127_0 then
			return arg_127_1
		end
	end
	
	arg_127_1.reward_cache_opts = arg_127_5
	
	return arg_127_0:getRewardIcon(arg_127_2, arg_127_3, arg_127_4)
end

function UIUtil.getLightIcon(arg_128_0, arg_128_1, arg_128_2, arg_128_3)
	local var_128_0 = cc.Node:create()
	
	var_128_0:setName("light_icon")
	var_128_0:setCascadeOpacityEnabled(true)
	var_128_0:setCascadeColorEnabled(true)
	
	local var_128_1 = SpriteCache:getSprite("img/_hero_s_bg_ally.png")
	
	var_128_1:setName("frame_bg")
	var_128_1:setScale(0.69)
	var_128_0:addChild(var_128_1)
	
	local var_128_2, var_128_3 = DB("character", arg_128_1, {
		"id",
		"face_id"
	})
	local var_128_4 = SpriteCache:getSprite("face/" .. var_128_3 .. "_s.png")
	
	if var_128_4 then
		var_128_4:setName("unit_icon")
		var_128_4:setScale(0.69)
		var_128_0:addChild(var_128_4)
	end
	
	local var_128_5, var_128_6 = DB("item_material", arg_128_2, {
		"icon",
		"frame_effect"
	})
	
	var_128_5 = var_128_5 or "border/icon_border_base"
	
	local var_128_7 = SpriteCache:getSprite("item/" .. var_128_5 .. ".png")
	
	if var_128_7 then
		var_128_7:setName("frame_icon")
		var_128_7:setScale(0.69)
		var_128_0:addChild(var_128_7)
		if_set_effect(var_128_7, nil, var_128_6)
	end
	
	var_128_0:setScale(arg_128_3 or 1)
	
	return var_128_0
end

function UIUtil.isUserLanguageMBCS(arg_129_0)
	local var_129_0 = getUserLanguage()
	local var_129_1 = {
		"ko",
		"ja",
		"th",
		"zht",
		"zhs"
	}
	
	return table.isInclude(var_129_1, var_129_0)
end

IconUtil = {}

function IconUtil.setIcon(arg_130_0)
	if not get_cocos_refid(arg_130_0) then
		return 
	end
	
	IconUtil.icon = arg_130_0
	
	return IconUtil
end

function IconUtil.getIcon()
	if not get_cocos_refid(IconUtil.icon) then
		return 
	end
	
	return IconUtil.icon
end

function IconUtil.done()
	IconUtil.icon = nil
end

function IconUtil.addStar(arg_133_0, arg_133_1)
	if not arg_133_0 then
		return IconUtil
	end
	
	if_set_visible(IconUtil.getIcon(), "icon_starmap1", arg_133_0)
	
	if arg_133_1 then
		if_set_color(IconUtil.getIcon(), "icon_starmap1", arg_133_1)
	end
	
	return IconUtil
end

function IconUtil.addGoldBox(arg_134_0, arg_134_1, arg_134_2)
	if arg_134_1 then
		if_set_color(IconUtil.getIcon(), "icon_maze_reward", arg_134_1)
	end
	
	local var_134_0 = cc.Node:create()
	
	var_134_0:setName("n_icon_maze_reward")
	IconUtil.getIcon():addChild(var_134_0)
	
	local var_134_1 = IconUtil.getIcon():getChildByName("icon_maze_reward")
	
	if not var_134_1 then
		return IconUtil
	end
	
	var_134_1:ejectFromParent()
	var_134_0:addChild(var_134_1)
	var_134_0:setCascadeOpacityEnabled(false)
	IconUtil.getIcon():setOpacity(not arg_134_2 and 255 or 76.5)
	IconUtil.getIcon():getChildByName("n_first_reward"):setCascadeOpacityEnabled(false)
	
	if not IconUtil.getIcon():getChildByName("icon_checked"):isVisible() then
		if_set_visible(IconUtil.getIcon():getChildByName("n_first_reward"), "icon_checked", arg_134_2)
	end
	
	if_set_visible(var_134_1, nil, arg_134_0)
	
	return IconUtil
end

function IconUtil.addFirstReward(arg_135_0, arg_135_1, arg_135_2)
	if not arg_135_0 then
		return IconUtil
	end
	
	if_set_visible(IconUtil.getIcon(), "icon_etc_first_reward", arg_135_0)
	
	if arg_135_1 then
		if_set_color(IconUtil.getIcon(), "icon_etc_first_reward", arg_135_1)
	end
	
	if not get_cocos_refid(IconUtil.getIcon():getChildByName("first_reward")) then
		if not arg_135_2 then
			local var_135_0 = IconUtil.getIcon():getContentSize()
			
			EffectManager:Play({
				fn = "ui_limited_reward.cfx",
				pivot_z = 99998,
				layer = IconUtil.getIcon(),
				pivot_x = var_135_0.width / 2,
				pivot_y = var_135_0.height / 2
			}):setName("first_reward")
		else
			if_set_visible(IconUtil.getIcon():getChildByName("n_first_reward"), "icon_checked", true)
		end
	end
	
	return IconUtil
end

function IconUtil.addCheckIcon(arg_136_0)
	if not arg_136_0 then
		return IconUtil
	end
	
	IconUtil.getIcon():getChildByName("n_first_reward"):setCascadeColorEnabled(false)
	if_set_color(IconUtil.getIcon(), nil, arg_136_0 == true and tocolor("#888888") or tocolor("#ffffff"))
	if_set_visible(IconUtil.getIcon(), "icon_checked", arg_136_0)
	
	return IconUtil
end

RewardInfo = {}

function RewardInfo.getData()
	local var_137_0 = {}
	
	for iter_137_0 = 1, 999 do
		local var_137_1, var_137_2, var_137_3, var_137_4, var_137_5, var_137_6 = DBN("item_reward_order", iter_137_0, {
			"id",
			"title",
			"icon",
			"scale",
			"checked_icon",
			"sort"
		})
		
		if not var_137_1 then
			break
		end
		
		if var_137_1 then
			var_137_0[var_137_1] = {
				id = var_137_1,
				title = var_137_2,
				icon = var_137_3,
				scale = var_137_4,
				checked_icon = var_137_5,
				sort = var_137_6
			}
		end
	end
	
	return var_137_0
end

function RewardInfo.addRewardInfoNode(arg_138_0, arg_138_1, arg_138_2)
	if not get_cocos_refid(arg_138_0) then
		return 
	end
	
	arg_138_1 = arg_138_1 or {}
	
	if table.count(arg_138_1.reward_info or {}) == 0 then
		return 
	end
	
	local var_138_0 = arg_138_0:getChildByName("n_reward_detail_tooltip")
	
	if not var_138_0 then
		return 
	end
	
	local var_138_1 = load_dlg("reward_detail_tooltip", true, "wnd")
	
	if_set_visible(var_138_1, "t_info", false)
	if_set_visible(var_138_1, "icon", false)
	if_set_visible(var_138_1, "icon_checked", false)
	
	var_138_1.scrollview = {}
	
	copy_functions(ScrollView, var_138_1.scrollview)
	
	local var_138_2 = var_138_1:getChildByName("info")
	
	function var_138_1.scrollview.getScrollViewItem(arg_139_0, arg_139_1)
		local var_139_0 = load_dlg("reward_detail_tooltip_item", true, "wnd")
		local var_139_1 = var_139_0:getChildByName("t_info")
		
		var_139_1:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
		var_139_1:setPositionY(var_139_1:getPositionY())
		if_set_sprite(var_139_0, "icon", "img/" .. arg_139_1.icon .. ".png")
		var_139_0:getChildByName("icon"):setScale(arg_139_1.scale)
		if_set_visible(var_139_0, "icon_checked", arg_139_1.clear or arg_139_1.checked_icon and arg_139_1.checked_icon == "y")
		if_set(var_139_1, nil, T(arg_139_1.title))
		
		return var_139_0
	end
	
	if DEBUG.ct_reward_info then
		for iter_138_0, iter_138_1 in pairs(DEBUG.ct_reward_info) do
			arg_138_1.reward_info[iter_138_0] = iter_138_1
		end
	end
	
	local var_138_3 = RewardInfo.getData()
	local var_138_4 = {}
	
	for iter_138_2, iter_138_3 in pairs(arg_138_1.reward_info) do
		table.push(var_138_4, var_138_3[iter_138_2])
	end
	
	table.sort(var_138_4, function(arg_140_0, arg_140_1)
		return arg_140_0.sort < arg_140_1.sort
	end)
	var_138_1.scrollview:initScrollView(var_138_1:getChildByName("info"), 212, 61, {
		fit_height = true
	})
	var_138_1:getChildByName("frame"):setContentSize(290, 83 + 61 * table.count(var_138_4))
	var_138_1.scrollview:setSize(290, 61 * table.count(var_138_4))
	var_138_1.scrollview:createScrollViewItems(var_138_4)
	var_138_2:setPositionY(var_138_2:getPositionY() + (table.count(var_138_4) - 1) * 61)
	var_138_2:setTouchEnabled(false)
	var_138_0:addChild(var_138_1)
	var_138_1:setPosition(0, 5)
	var_138_1:setAnchorPoint(1, 1)
	
	local var_138_5 = 2
	local var_138_6 = 0
	local var_138_7 = arg_138_0:getName()
	
	if var_138_7 == "util.character.popup" then
		var_138_5 = 230
		var_138_6 = 15
	elseif var_138_7 == "artifact_tooltip" then
		var_138_6 = 53
	end
	
	local var_138_8 = DB("character", arg_138_1.code, {
		"name"
	})
	local var_138_9 = string.starts(arg_138_1.code, "e")
	
	if arg_138_1.grade and arg_138_1.grade > 1 and not var_138_8 and var_138_9 then
		var_138_5 = var_138_5 - 4
		var_138_6 = var_138_6 + 5
	elseif not var_138_9 and not var_138_8 then
		var_138_5 = var_138_5 + 1
		var_138_6 = var_138_6 + 2
	elseif var_138_8 then
		var_138_5 = var_138_5 - 1
		var_138_6 = var_138_6 - 2
	end
	
	var_138_0:setPosition(var_138_5 - 5, var_138_6 + arg_138_0:getContentSize().height - var_138_1:getChildByName("frame"):getContentSize().height + 73)
	if_set_visible(var_138_0, nil, true)
end

function UIUtil.resizeGetRewardIconName(arg_141_0, arg_141_1, arg_141_2)
	arg_141_2 = arg_141_2 or {}
	
	local var_141_0 = arg_141_2.txt_name_width or 183
	
	arg_141_0:setTextAndReturnHeight(arg_141_1, nil, var_141_0)
	
	if not arg_141_0:isUserLanguageMBCS() then
		arg_141_1:ignoreContentAdaptWithSize(false)
		if_set_scale_fit_width_long_word(arg_141_1, nil, arg_141_1:getString(), var_141_0 / arg_141_1:getScale())
		arg_141_1:ignoreContentAdaptWithSize(true)
	end
	
	if string.find(arg_141_1:getString(), "\n") then
		return 
	end
	
	local var_141_1 = arg_141_1:getStringNumLines()
	local var_141_2 = 2
	
	if var_141_1 <= var_141_2 then
		return 
	end
	
	local var_141_3 = 100
	local var_141_4 = arg_141_1:getAutoRenderSize().width / var_141_2
	
	arg_141_1:setTextAreaSize({
		height = 0,
		width = var_141_4 + var_141_3
	})
	
	local var_141_5 = arg_141_1:getStringNumLines()
	
	for iter_141_0 = 1, 40 do
		if var_141_5 <= var_141_2 then
			break
		end
		
		var_141_3 = var_141_3 + (var_141_2 < var_141_5 and 1 or -1) * 5
		
		arg_141_1:setTextAreaSize({
			height = 0,
			width = var_141_4 + var_141_3
		})
		
		var_141_5 = arg_141_1:getStringNumLines()
	end
	
	set_scale_fit_width(arg_141_1, var_141_0)
end

function UIUtil.getFragmentUnitRewardIcon(arg_142_0, arg_142_1, arg_142_2)
	if_set_visible(arg_142_1, "icon", false)
	
	local var_142_0 = DB("item_material", arg_142_2, {
		"devotion_target"
	})
	local var_142_1 = DB("character", var_142_0, {
		"moonlight"
	}) == "y"
	local var_142_2 = SpriteCache:getSprite(var_142_1 and "img/memory_piece_moonlight.png" or "img/memory_piece_common.png")
	
	if get_cocos_refid(var_142_2) then
		var_142_2:setAnchorPoint(0.5, 0.5)
		var_142_2:setPosition(43.2, 43.2)
		var_142_2:setScale(0.7)
		var_142_2:setCascadeColorEnabled(true)
		var_142_2:setCascadeOpacityEnabled(true)
		arg_142_1:addChild(var_142_2)
		var_142_2:sendToBack()
	end
	
	local var_142_3 = "face/" .. var_142_0 .. "_s.png"
	local var_142_4 = cc.Sprite:create(var_142_3)
	
	if get_cocos_refid(var_142_4) then
		local var_142_5 = cc.GLProgramCache:getInstance():getGLProgram("sprite_mask")
		local var_142_6 = cc.Director:getInstance():getTextureCache():addImage("face/memory_piece_mask.png")
		
		if var_142_5 and var_142_6 then
			local var_142_7 = cc.GLProgramState:create(var_142_5)
			
			var_142_7:setUniformTexture("u_TexMask", var_142_6)
			var_142_4:setDefaultGLProgramState(var_142_7)
			var_142_4:setGLProgramState(nil)
		end
		
		var_142_4:setAnchorPoint(0.5, 0.5)
		var_142_4:setPosition(43.2, 43.2)
		var_142_4:setScale(0.7)
		var_142_4:setCascadeColorEnabled(true)
		var_142_4:setCascadeOpacityEnabled(true)
		arg_142_1:addChild(var_142_4)
		var_142_4:sendToBack()
	end
end

function UIUtil.getFragmentEtcRewardIcon(arg_143_0, arg_143_1, arg_143_2)
	local var_143_0 = arg_143_1:getChildByName("icon")
	
	if get_cocos_refid(var_143_0) then
		if_set_sprite(var_143_0, nil, "img/_hero_s_frame_ally.png")
		var_143_0:setName("fragment_icon")
		var_143_0:setAnchorPoint(0.5, 0.5)
		var_143_0:setPosition(43, 43)
		var_143_0:setScale(0.7)
		var_143_0:sendToBack()
	end
	
	local var_143_1 = SpriteCache:getSprite("img/_itembg_cir_2.png")
	
	if get_cocos_refid(var_143_1) then
		var_143_1:setAnchorPoint(0.5, 0.5)
		var_143_1:setPosition(43, 45)
		var_143_1:setScale(0.82)
		var_143_1:setCascadeColorEnabled(true)
		var_143_1:setCascadeOpacityEnabled(true)
		
		local var_143_2 = SpriteCache:getSprite("item/icon_" .. arg_143_2 .. ".png")
		
		if get_cocos_refid(var_143_2) then
			var_143_2:setAnchorPoint(0.5, 0.5)
			var_143_2:setPosition(47, 47)
			var_143_2:setScale(0.83)
			var_143_2:setCascadeOpacityEnabled(true)
			var_143_2:setCascadeColorEnabled(true)
			var_143_1:addChild(var_143_2)
			var_143_2:sendToBack()
		end
		
		arg_143_1:addChild(var_143_1)
		var_143_1:sendToBack()
	end
end

function UIUtil.getFragmentRewardIcon(arg_144_0, arg_144_1, arg_144_2)
	if DB("item_material", arg_144_2, "ma_type2") == "char" then
		arg_144_0:getFragmentUnitRewardIcon(arg_144_1, arg_144_2)
	else
		arg_144_0:getFragmentEtcRewardIcon(arg_144_1, arg_144_2)
	end
end

function UIUtil.getRewardIcon(arg_145_0, arg_145_1, arg_145_2, arg_145_3)
	arg_145_3 = arg_145_3 or {}
	arg_145_3.code = arg_145_3.code or arg_145_2
	
	if arg_145_3.equip then
		arg_145_3.code = arg_145_3.equip.code
		arg_145_3.set_fx = arg_145_3.equip.set_fx
	end
	
	if type(arg_145_1) ~= "number" then
		arg_145_1 = 0
	end
	
	if arg_145_0:isSDModelItem(arg_145_3.code) then
		return arg_145_0:getSDModelIcon(arg_145_3)
	end
	
	local var_145_0 = string.starts(arg_145_3.code, "e")
	local var_145_1 = var_145_0 and (arg_145_3.equip and arg_145_3.equip:isArtifact() or DB("equip_item", arg_145_3.code, "type") == "artifact")
	local var_145_2 = var_145_0 and (arg_145_3.equip and arg_145_3.equip:isExclusive() or DB("equip_item", arg_145_3.code, "type") == "exclusive")
	local var_145_3 = arg_145_3.type == "character"
	local var_145_4 = string.starts(arg_145_3.code, "pet")
	local var_145_5 = string.starts(arg_145_3.code, "ma_")
	local var_145_6 = DB("item_material", arg_145_3.code, "ma_type")
	local var_145_7 = var_145_5 and (var_145_6 == "skin" or var_145_6 == "skin_temp")
	local var_145_8 = false
	local var_145_9 = string.starts(arg_145_3.code, "as_")
	local var_145_10 = DB("clan_heritage_object_data", arg_145_3.code, "id") ~= nil
	local var_145_11 = arg_145_3.code
	local var_145_12 = arg_145_3.add_bonus and arg_145_3.add_bonus > 0
	local var_145_13 = arg_145_3.add_pet_bonus and arg_145_3.add_pet_bonus > 0
	local var_145_14 = arg_145_3.lota_arti_bonus and arg_145_3.lota_arti_bonus > 0
	local var_145_15 = false
	local var_145_16 = false
	local var_145_17 = false
	local var_145_18 = var_145_5 and var_145_6 == "fragment"
	
	if var_145_6 then
		var_145_15 = var_145_6 == "ext_drop"
		var_145_16 = var_145_6 == "xpup"
	end
	
	if not var_145_0 and not var_145_1 and not var_145_3 and DB("character", arg_145_2, "id") then
		var_145_3 = true
	end
	
	local var_145_19 = false
	local var_145_20 = false
	
	if var_145_3 then
		local var_145_21 = DB("character", arg_145_2, "type")
		
		var_145_19 = arg_145_3.is_npc or var_145_21 == "npc"
		var_145_20 = arg_145_3.is_summon or var_145_21 == "summon"
	end
	
	if var_145_10 then
		local var_145_22 = DB("clan_heritage_object_data", arg_145_3.code, "map_icon_before")
		local var_145_23 = DB("character", var_145_22, "id")
		
		if var_145_23 ~= nil then
			var_145_3 = true
			arg_145_3.code = var_145_23
		end
	end
	
	if var_145_7 and var_145_6 == "skin_temp" then
		var_145_8 = true
	end
	
	local var_145_24
	
	if arg_145_3.mob_icon2 == true then
		var_145_24 = cc.CSLoader:createNode("wnd/mob_icon2.csb")
		
		var_145_24:setPosition(0, 0)
	elseif var_145_3 then
		var_145_24 = cc.CSLoader:createNode("wnd/mob_icon.csb")
		
		var_145_24:setPosition(0, 0)
	elseif var_145_4 then
		var_145_24 = cc.CSLoader:createNode("wnd/pet_icon.csb")
		
		var_145_24:setPosition(0, 0)
	elseif var_145_1 then
		var_145_24 = cc.CSLoader:createNode("wnd/item_art_icon.csb")
		
		if_set_visible(var_145_24, "cm_icon_tmp_inven", false)
	else
		var_145_24 = cc.CSLoader:createNode("wnd/reward_icon.csb")
	end
	
	local var_145_25 = arg_145_3.dlg_name or ".reward_icon"
	
	var_145_24:setName(var_145_25)
	var_145_24:setAnchorPoint(0.5, 0.5)
	
	if arg_145_3.scale then
		if var_145_3 then
			var_145_24:setScale(arg_145_3.scale * (arg_145_3.hero_multiply_scale or 1))
		elseif var_145_1 then
			var_145_24:setScale(arg_145_3.scale * (arg_145_3.artifact_multiply_scale or 1))
		elseif var_145_4 then
			var_145_24:setScale(arg_145_3.scale * (arg_145_3.pet_multiply_scale or 1))
		else
			var_145_24:setScale(arg_145_3.scale * (arg_145_3.multiply_scale or 1))
		end
	elseif var_145_3 and arg_145_3.hero_multiply_scale then
		var_145_24:setScale(var_145_24:getScale() * arg_145_3.hero_multiply_scale)
	elseif var_145_1 then
		if arg_145_3.artifact_multiply_scale then
			var_145_24:setScale(var_145_24:getScale() * arg_145_3.artifact_multiply_scale)
		else
			var_145_24:setScale(0.8)
		end
	elseif arg_145_3.multiply_scale then
		var_145_24:setScale(var_145_24:getScale() * arg_145_3.multiply_scale)
	end
	
	if arg_145_3.parent then
		local var_145_26 = arg_145_3.parent
		
		if arg_145_3.target then
			var_145_26 = arg_145_3.parent:getChildByName(arg_145_3.target)
		end
		
		local var_145_27 = var_145_26:getChildByName(var_145_24:getName())
		
		if var_145_27 and not arg_145_3.no_remove_prev_icon then
			var_145_27:removeFromParent()
		end
		
		var_145_26:addChild(var_145_24)
	end
	
	local var_145_28
	local var_145_29
	local var_145_30
	local var_145_31
	local var_145_32
	local var_145_33
	local var_145_34
	local var_145_35
	local var_145_36
	local var_145_37
	local var_145_38
	local var_145_39
	local var_145_40
	local var_145_41
	local var_145_42
	local var_145_43
	local var_145_44
	local var_145_45
	local var_145_46
	local var_145_47
	local var_145_48
	local var_145_49
	
	arg_145_3.grade = arg_145_3.g or arg_145_3.grade
	
	local var_145_50 = 1
	
	if var_145_0 then
		local var_145_51, var_145_52, var_145_53, var_145_54, var_145_55, var_145_56, var_145_57
		
		var_145_28, var_145_30, var_145_51, var_145_32, var_145_52, var_145_53, var_145_42, var_145_54, var_145_55, var_145_56, var_145_57 = DB("equip_item", arg_145_3.code, {
			"icon",
			"type",
			"stone",
			"name",
			"unique_type",
			"tier",
			"item_level",
			"artifact_grade",
			"pick_max",
			"pick_min",
			"role"
		})
		
		local var_145_58 = arg_145_3.grade_rate
		
		if not var_145_28 then
			if_set(var_145_24, "txt_small_count", arg_145_3.code)
			
			return var_145_24
		end
		
		if arg_145_3.grade then
			var_145_29 = arg_145_3.grade
		end
		
		var_145_29 = var_145_29 or 1
		
		if var_145_58 then
			var_145_36, var_145_37 = DB("item_equip_grade_rate", var_145_58, {
				"min",
				"max"
			})
		else
			var_145_36 = var_145_29
			var_145_37 = var_145_29
		end
		
		if arg_145_3.grade_max then
			var_145_29 = var_145_37
		else
			var_145_29 = var_145_36
		end
		
		if var_145_1 then
			var_145_28 = "item_arti/" .. var_145_28 .. ".png"
			var_145_29 = var_145_54
		else
			var_145_28 = "item/" .. var_145_28 .. ".png"
		end
		
		var_145_30 = EQUIP.getGradeTitle(arg_145_3.code, var_145_29, var_145_30, var_145_51)
		
		if arg_145_3.equip then
			var_145_32 = arg_145_3.equip:getName()
		else
			var_145_32 = EQUIP.getName(nil, nil, var_145_32, arg_145_3.set_fx)
		end
		
		var_145_24.grade = var_145_29
		
		if var_145_1 then
			if_set_visible(var_145_24, "n_stars", arg_145_3.no_grade ~= true)
			if_set_visible(var_145_24, "star" .. var_145_29 + 1, false)
			
			local var_145_59 = var_145_24:getChildByName("n_stars")
			
			if var_145_59 then
				var_145_59:setPositionX((6 - var_145_29) * 9)
			end
			
			local var_145_60 = var_145_24:getChildByName("icon_equip")
			
			if get_cocos_refid(var_145_60) then
				var_145_60:setScale(1 / calcWorldScaleX(var_145_60))
			end
			
			local var_145_61 = var_145_24:getChildByName("icon_new")
			
			if get_cocos_refid(var_145_61) then
				var_145_61:setScale(1 / calcWorldScaleX(var_145_61))
			end
			
			local var_145_62 = var_145_24:getChildByName("role")
			
			if arg_145_3.role and var_145_57 and get_cocos_refid(var_145_62) then
				if_set_visible(var_145_62, nil, true)
				SpriteCache:resetSprite(var_145_62, "img/cm_icon_role_" .. var_145_57 .. ".png")
			else
				if_set_visible(var_145_62, nil, false)
			end
		elseif var_145_42 then
			UIUtil:setRewardLevelDetail(var_145_24, var_145_42, arg_145_3)
		end
		
		if_set_visible(var_145_24, "tier", false)
	elseif var_145_5 then
		local var_145_63, var_145_64, var_145_65, var_145_66
		
		var_145_63, var_145_64, var_145_32, var_145_30, var_145_65, var_145_45, var_145_46, var_145_47, var_145_66 = DB("item_material", arg_145_3.code, {
			"icon",
			"drop_icon",
			"name",
			"desc_category",
			"grade",
			"ma_type",
			"ma_type2",
			"badge",
			"icon_frame_not_use"
		})
		var_145_32 = T(var_145_32)
		var_145_30 = T(var_145_30)
		
		local var_145_67 = "item/"
		
		if var_145_45 == "profile" then
			var_145_67 = "profile/" .. var_145_46 .. "/"
			
			if var_145_46 == "bg" or var_145_46 == "badge" then
				arg_145_1 = 0
				var_145_50 = 0.9
				arg_145_3.no_bg = true
				arg_145_3.use_drop_icon = var_145_46 == "bg"
			end
		end
		
		if arg_145_3.use_drop_icon then
			var_145_28 = var_145_67 .. (var_145_64 or "") .. ".png"
		else
			var_145_28 = var_145_67 .. (var_145_63 or "") .. ".png"
		end
		
		if var_145_45 == "skin" or var_145_45 == "skin_temp" then
			var_145_28 = var_145_63 .. "_s.png"
		end
		
		if var_145_45 == "change" or var_145_45 == "alchemypoint" then
			local var_145_68 = string.split(var_145_46, ";")
			
			if var_145_68 then
				local var_145_69 = var_145_68[2]
				
				if var_145_45 == "alchemypoint" then
					var_145_69 = "set_" .. var_145_69
				end
				
				arg_145_3.set_fx = var_145_69
			end
		end
		
		var_145_17 = var_145_66 and true or false
		var_145_29 = var_145_65 or 1
	elseif string.starts(arg_145_3.code, "to_") then
		var_145_28, var_145_32, var_145_30, var_145_29 = DB("item_token", arg_145_3.code, {
			"icon",
			"name",
			"desc_category",
			"grade"
		})
		var_145_32 = T(var_145_32)
		var_145_30 = T(var_145_30)
		var_145_28 = "item/" .. (var_145_28 or "") .. ".png"
	elseif string.starts(arg_145_3.code, "sp_") then
		var_145_28, var_145_32, var_145_30, var_145_47, var_145_29 = DB("item_special", arg_145_3.code, {
			"icon",
			"name",
			"desc_category",
			"badge",
			"grade"
		})
		var_145_29 = var_145_29 or 1
		var_145_32 = T(var_145_32)
		var_145_30 = T(var_145_30)
		var_145_28 = "item/" .. (var_145_28 or "") .. ".png"
	elseif string.starts(arg_145_3.code, "ct_") then
		var_145_28, var_145_32, var_145_30 = DB("item_clantoken", arg_145_3.code, {
			"icon",
			"name",
			"desc_category"
		})
		var_145_32 = T(var_145_32)
		var_145_30 = T(var_145_30)
		var_145_28 = "item/" .. (var_145_28 or "") .. ".png"
	elseif string.starts(arg_145_3.code, "cm_") then
		var_145_28, var_145_32, var_145_30 = DB("clan_material", arg_145_3.code, {
			"icon",
			"name",
			"desc_category",
			"grade",
			"ma_type",
			"ma_type2"
		})
		var_145_32 = T(var_145_32)
		var_145_30 = T(var_145_30)
		var_145_28 = "item/" .. (var_145_28 or "") .. ".png"
	elseif var_145_3 then
	elseif var_145_4 then
		var_145_29 = var_145_29 or arg_145_3.grade or DB("pet_character", arg_145_3.code, "grade") or 1
	elseif arg_145_3.faction then
		var_145_28 = "emblem/fa_em_" .. arg_145_3.faction .. ".png"
		var_145_30 = arg_145_3.faction_category
		var_145_32 = T(arg_145_3.faction .. "_tl")
	elseif arg_145_3.clan_week_mission then
		var_145_28 = "item/" .. arg_145_3.img .. ".png"
		var_145_30 = arg_145_3.faction_category
		var_145_32 = T(arg_145_3.clan_week_mission)
	elseif arg_145_3.custom then
		var_145_28 = "item/" .. arg_145_3.img .. ".png"
		var_145_32 = T(arg_145_3.custom)
		var_145_30 = T(arg_145_3.category)
	elseif arg_145_3.custom_v2 then
		var_145_28 = "item/" .. arg_145_3.img .. ".png"
		var_145_32 = T(arg_145_3.custom_v2)
		var_145_30 = T(arg_145_3.custom_v2_category)
	elseif var_145_9 then
		var_145_28, var_145_32, var_145_30 = DB("account_skill", arg_145_3.code, {
			"icon",
			"name",
			"desc_category"
		})
		var_145_28 = "item/" .. var_145_28 .. ".png"
		var_145_32 = T(var_145_32)
		var_145_30 = T(var_145_30)
	elseif var_145_10 and not var_145_3 then
		var_145_28, var_145_32, var_145_30, var_145_29 = DB("clan_heritage_object_data", arg_145_3.code, {
			"icon",
			"name",
			"category",
			"grade"
		})
		var_145_28 = var_145_28 or ""
		var_145_28 = "item/" .. var_145_28 .. ".png"
		var_145_32 = T(var_145_32)
		var_145_30 = T(var_145_30)
	elseif var_145_4 then
	elseif arg_145_3 and arg_145_3.is_food then
		var_145_28 = ""
	else
		balloon_message("no item icon:" .. arg_145_3.code)
		
		var_145_28 = ""
	end
	
	if_set_visible(var_145_24, "up_bg_normal", false)
	if_set_visible(var_145_24, "up_bg_max", false)
	if_set_visible(var_145_24, "up", false)
	
	if arg_145_3.equip then
		var_145_29 = arg_145_3.equip.grade
		
		local var_145_70 = 15
		local var_145_71 = arg_145_3.equip:getEnhance() or 0
		
		if var_145_1 then
			var_145_70 = 30
		end
		
		local var_145_72 = var_145_24:getChildByName("n_up")
		
		if get_cocos_refid(arg_145_3.up_cont) then
			var_145_72:setVisible(false)
			
			var_145_72 = arg_145_3.up_cont
		end
		
		if var_145_71 > 0 then
			if_set_visible(var_145_72, "up_bg_normal", var_145_71 ~= var_145_70)
			if_set_visible(var_145_72, "up_bg_max", var_145_71 == var_145_70)
			var_145_72:setVisible(true)
			
			if var_145_72:getChildByName("n_num") then
				arg_145_0:updateIconLevel(var_145_72, var_145_71, {
					is_extention = true,
					is_artifact = var_145_1,
					detail = arg_145_3.detail,
					is_enhancer = arg_145_3.is_enhancer
				})
			else
				Log.e("#36405 확인이 필요한 csd 파일입니다! by godteams", var_145_24:getName())
				UIUtil:resetImageNumber(var_145_72:getChildByName("n_up_v"), "+" .. arg_145_3.equip:getEnhance(), {
					align = "center"
				})
			end
		else
			var_145_72:setVisible(false)
			if_set_visible(var_145_24, "n_up", false)
		end
		
		if_set_visible(var_145_24, "locked", arg_145_3.equip.lock)
	else
		var_145_29 = var_145_29 or 1
		
		if_set_visible(var_145_24, "locked", false)
		if_set_visible(var_145_24, "n_up", false)
	end
	
	if var_145_45 == "bgpack" and var_145_5 then
		arg_145_3.no_bg = true
	elseif var_145_45 and var_145_45 == "subcus" then
		arg_145_3.no_bg = true
	elseif var_145_16 then
		arg_145_3.no_bg = true
	elseif var_145_18 then
		arg_145_3.no_bg = true
	end
	
	if_set_visible(var_145_24, "tier", var_145_0 and var_145_42 == nil)
	if_set_visible(var_145_24, "bg", arg_145_3.no_frame ~= true)
	if_set_visible(var_145_24, "set", arg_145_3.set_fx ~= nil)
	
	if arg_145_3.set_fx then
		replaceSprite(var_145_24, "set", EQUIP:getSetItemIconPath(arg_145_3.set_fx))
	end
	
	arg_145_3.grade = arg_145_3.grade or var_145_29
	var_145_24.code = arg_145_3.code
	var_145_24.grade = arg_145_3.grade
	
	if var_145_3 then
		if var_145_16 then
			if_set_visible(var_145_24, "bg", false)
			if_set_sprite(var_145_24, "face", "item/" .. DB("item_material", arg_145_2, {
				"icon"
			}) .. ".png")
			if_set_visible(var_145_24, "subboss", false)
			if_set_visible(var_145_24, "n_unit", false)
			if_set_visible(var_145_24, "boss", false)
			if_set_visible(var_145_24, "txt_r_name", false)
			if_set_visible(var_145_24, "txt_r_type", false)
			if_set(var_145_24, "txt_small_count", "x" .. arg_145_1)
			if_set(var_145_24, "txt_small_count", arg_145_1 and arg_145_1 > 0)
			
			if not arg_145_3.no_popup and not var_145_19 and arg_145_3.code ~= "m0000" then
				WidgetUtils:setupTooltip({
					control = var_145_24,
					creator = function()
						local var_146_0 = DB("item_material", arg_145_3.code, {
							"grade"
						})
						
						return ItemTooltip:getItemTooltip({
							code = arg_145_2,
							grade = var_146_0
						})
					end,
					delay = arg_145_3.popup_delay,
					content_size = arg_145_3.content_size
				})
			else
				if_set_visible(var_145_24, "btn_mob", false)
			end
		else
			local var_145_73, var_145_74, var_145_75, var_145_76, var_145_77, var_145_78, var_145_79, var_145_80, var_145_81 = DB("character", arg_145_3.code, {
				"face_id",
				"name",
				"monster_tier",
				"ch_attribute",
				"role",
				"grade",
				"type",
				"desc_category",
				"moonlight"
			})
			
			var_145_30 = var_145_80
			
			if arg_145_3 and not arg_145_3.no_db_grade then
				arg_145_3.grade = var_145_78
			end
			
			if arg_145_3.lv then
				if arg_145_3.lv > 99 then
					if_set_visible(var_145_24, "99", true)
					if_set_visible(var_145_24, "l1", false)
				else
					if_set_visible(var_145_24, "99", false)
					if_set_sprite(var_145_24, "l2", "img/itxt_num" .. math.floor(arg_145_3.lv / 10) .. "_b.png")
					if_set_sprite(var_145_24, "l1", "img/itxt_num" .. arg_145_3.lv % 10 .. "_b.png")
				end
				
				if arg_145_3.blind then
					if_set_sprite(var_145_24, "color", "img/game_hud_bar_none.png")
				else
					if_set_sprite(var_145_24, "color", "img/game_hud_bar_" .. var_145_76 .. ".png")
				end
			else
				if_set_visible(var_145_24, "n_lv", false)
				if_set_visible(var_145_24, "color", false)
				if_set_visible(var_145_24, "bg_color", false)
			end
			
			if var_145_10 then
				arg_145_3.monster = true
				arg_145_3.right_hero_name = true
				arg_145_3.right_hero_type = true
				arg_145_3.lv = DB("level_enter_drops", var_145_11, "lv1")
				arg_145_3.hide_star = true
				arg_145_3.grade = 1
				var_145_30 = DB("clan_heritage_object_data", var_145_11, "category")
				
				local var_145_82 = LotaUtil:getMonsterTypeNameHashMap()
				local var_145_83, var_145_84 = DB("clan_heritage_object_data", var_145_11, {
					"type_2",
					"monster_level"
				})
				local var_145_85 = var_145_24:findChildByName("n_heritage_mob")
				local var_145_86 = var_145_82[var_145_83]
				
				if_set_visible(var_145_85, nil, true)
				
				local var_145_87 = var_145_85:getChildByName("lv")
				local var_145_88 = UIUtil:numberDigitToCharOffset(var_145_84, 1, 62)
				local var_145_89 = UIUtil:setLevel(var_145_87, var_145_84, nil, 2, nil, nil, var_145_88)
				
				if_set_visible(var_145_85, "grade_icon", var_145_83 ~= "normal_monster")
				
				local var_145_90 = 0
				
				if var_145_83 ~= "normal_monster" then
					SpriteCache:resetSprite(var_145_85:findChildByName("grade_icon"), "img/" .. var_145_86)
					
					var_145_90 = 12 - var_145_89 * 6
				else
					var_145_90 = 3 - var_145_89 * 6
				end
				
				var_145_87:setPositionX(var_145_87:getPositionX() + var_145_90)
			end
			
			var_145_73 = var_145_73 or arg_145_3.face
			var_145_75 = arg_145_3.tier or var_145_75
			var_145_79 = arg_145_3.character_type or var_145_79
			
			if_set_visible(var_145_24, "subboss", var_145_75 == "subboss")
			if_set_visible(var_145_24, "boss", var_145_75 == "boss")
			if_set_visible(var_145_24, "n_souls", arg_145_3.soul)
			
			if arg_145_3.monster then
				if_set_visible(var_145_24, "n_stars", false)
			end
			
			if arg_145_3.hide_lv then
				if_set_visible(var_145_24, "n_lv", false)
				if_set_visible(var_145_24, "color", false)
				if_set_visible(var_145_24, "bg_color", false)
			end
			
			if arg_145_3.show_color_right then
				arg_145_3.show_color = true
				
				var_145_24:getChildByName("role"):setPosition(88, 84)
			end
			
			local var_145_91 = "img/cm_icon_pro"
			
			if var_145_81 then
				var_145_91 = var_145_91 .. "m"
			end
			
			if arg_145_3.leader_role then
				SpriteCache:resetSprite(var_145_24:getChildByName("role"), "img/cm_icon_role_main.png")
			elseif arg_145_3.role then
				SpriteCache:resetSprite(var_145_24:getChildByName("role"), "img/cm_icon_role_" .. var_145_77 .. "_b.png")
			elseif arg_145_3.show_color then
				SpriteCache:resetSprite(var_145_24:getChildByName("role"), var_145_91 .. var_145_76 .. ".png")
				var_145_24:getChildByName("role"):setScale(1)
			elseif arg_145_3.show_color_with_role then
				arg_145_3.role = true
				arg_145_3.show_color = true
				
				if_set_visible(var_145_24, "color", arg_145_3.show_color)
				SpriteCache:resetSprite(var_145_24:getChildByName("role"), "img/cm_icon_role_" .. var_145_77 .. "_b.png")
				SpriteCache:resetSprite(var_145_24:getChildByName("color"), var_145_91 .. var_145_76 .. ".png")
			end
			
			if_set_visible(var_145_24, "role", arg_145_3.role or arg_145_3.leader_role or arg_145_3.show_color)
			
			if arg_145_3.blind then
				SpriteCache:resetSprite(var_145_24:getChildByName("face"), "img/_hero_s_blind.png")
			else
				SpriteCache:resetSprite(var_145_24:getChildByName("face"), "face/" .. var_145_73 .. "_s.png")
			end
			
			if var_145_79 == "monster" and var_145_75 ~= "boss" then
				if_set_sprite(var_145_24, "frame", "img/_hero_s_frame_enemy.png")
			else
				if_set_sprite(var_145_24, "frame", "img/_hero_s_frame_ally.png")
			end
			
			if arg_145_3.face_question then
				if_set_sprite(var_145_24, "frame_bg", "img/cm_hero_cirbg_none.png")
				if_set_sprite(var_145_24, "face", "face/m0000_s.png")
			elseif var_145_79 == "monster" or arg_145_3.is_enemy then
				if_set_sprite(var_145_24, "frame_bg", "img/_hero_s_bg_enemy.png")
			else
				if_set_sprite(var_145_24, "frame_bg", "img/_hero_s_bg_ally.png")
			end
			
			if arg_145_3.souls then
				if_set_visible(var_145_24, "n_stars", false)
				if_set_visible(var_145_24, "soul" .. to_n(arg_145_3.souls) + 1, false)
				var_145_24:getChildByName("n_souls"):setPositionX((8 - arg_145_3.souls) * 5)
			elseif var_145_19 then
				if_set_visible(var_145_24, "n_stars", false)
			elseif var_145_20 then
				if_set_visible(var_145_24, "n_stars", false)
			elseif arg_145_3.no_grade then
				if_set_visible(var_145_24, "n_stars", false)
			else
				for iter_145_0 = arg_145_3.grade + 1, 6 do
					if_set_visible(var_145_24, "star" .. iter_145_0, false)
				end
				
				if arg_145_3.zodiac then
					for iter_145_1 = 1, arg_145_3.zodiac do
						SpriteCache:resetSprite(var_145_24:getChildByName("star" .. iter_145_1), "img/cm_icon_star_j.png")
					end
				end
				
				if arg_145_3.awake then
					for iter_145_2 = 1, arg_145_3.awake do
						SpriteCache:resetSprite(var_145_24:getChildByName("star" .. iter_145_2), "img/cm_icon_star_p.png")
					end
				end
				
				var_145_24:getChildByName("n_stars"):setPositionX(72 + (arg_145_3.grade - 1) * 6 - (arg_145_3.grade - 1) * 11)
			end
			
			if arg_145_3 and arg_145_3.star_scale then
				var_145_24:getChildByName("n_stars"):setScale(arg_145_3.star_scale)
			end
			
			local var_145_92 = arg_145_3.txt_type or var_145_24:getChildByName("txt_r_type")
			local var_145_93 = arg_145_3.txt_name or var_145_24:getChildByName("txt_r_name")
			
			if not arg_145_3.no_hero_name and (arg_145_3.detail or arg_145_3.name) then
				if arg_145_3.right_hero_name then
					if arg_145_3.right_hero_type and var_145_30 then
						if_set(var_145_92, nil, T(var_145_30))
					end
					
					if_set(var_145_93, nil, T(var_145_74))
					
					if not arg_145_3.no_resize_name and get_cocos_refid(var_145_93) then
						local var_145_94 = arg_145_0:setTextAndReturnHeight(var_145_93, nil, 180)
						
						if arg_145_3.right_hero_type then
							var_145_93:setPositionY(61)
							var_145_93:setAnchorPoint(0, 1)
						else
							var_145_93:setPositionY(48)
							var_145_93:setAnchorPoint(0, 0.5)
						end
					end
				else
					if_set(var_145_24, "name", T(var_145_74))
				end
			end
			
			if not arg_145_3.no_popup and not var_145_19 and arg_145_3.code ~= "m0000" then
				WidgetUtils:setupPopup({
					control = var_145_24,
					creator = function()
						if not arg_145_3.lv then
							local var_147_0 = DB("character", arg_145_3.code, {
								"grade"
							})
							local var_147_1 = UIUtil:getCharacterPopup({
								lv = 1,
								code = arg_145_3.code,
								grade = arg_145_3.grade,
								hide_star = arg_145_3.hide_star,
								skill_preview = arg_145_3.skill_preview,
								use_basic_star = arg_145_3.use_basic_star,
								z = arg_145_3.zodiac,
								awake = arg_145_3.awake,
								s = arg_145_3.s,
								no_power = arg_145_3.no_power,
								no_devote = arg_145_3.no_devote,
								off_power_detail = arg_145_3.off_power_detail
							})
							
							RewardInfo.addRewardInfoNode(var_147_1, arg_145_3)
							
							return var_147_1
						else
							local var_147_2 = UIUtil:getCharacterPopup({
								code = arg_145_3.code,
								grade = arg_145_3.grade,
								lv = arg_145_3.lv,
								hide_star = arg_145_3.hide_star,
								skill_preview = arg_145_3.skill_preview,
								use_basic_star = arg_145_3.use_basic_star,
								z = arg_145_3.zodiac,
								awake = arg_145_3.awake,
								s = arg_145_3.s,
								no_power = arg_145_3.no_power,
								no_devote = arg_145_3.no_devote,
								off_power_detail = arg_145_3.off_power_detail
							})
							
							RewardInfo.addRewardInfoNode(var_147_2, arg_145_3)
							
							return var_147_2
						end
					end,
					delay = arg_145_3.popup_delay,
					content_size = arg_145_3.content_size
				})
			else
				if_set_visible(var_145_24, "btn_mob", false)
			end
			
			if arg_145_3.use_share_popup then
				WidgetUtils:setupPopup({
					control = var_145_24,
					creator = function()
						return ShareUnitPopup:open(arg_145_3.unit, arg_145_3.share_equips, {
							is_chat = arg_145_3.is_chat,
							user_name = arg_145_3.user_name,
							leader_code = arg_145_3.share_leader_code,
							border_code = arg_145_3.share_border_code,
							growth_boost = arg_145_3.growth_boost,
							gb_level = arg_145_3.gb_level
						})
					end,
					delay = arg_145_3.popup_delay,
					content_size = arg_145_3.content_size
				})
			end
			
			if arg_145_3.border_code and not arg_145_3.blind then
				local var_145_95, var_145_96 = DB("item_material", arg_145_3.border_code, {
					"icon",
					"frame_effect"
				})
				
				if var_145_95 then
					if_set_sprite(var_145_24, "frame", "item/" .. var_145_95 .. ".png")
					if_set_effect(var_145_24, "frame", var_145_96)
				end
			end
			
			local var_145_97 = var_145_24:getChildByName("txt_small_count")
			
			if get_cocos_refid(var_145_97) then
				if_set(var_145_24, "txt_small_count", "x" .. to_n(arg_145_1))
				var_145_97:setVisible(not arg_145_3.no_count and arg_145_1 > 1)
			end
		end
	elseif var_145_4 then
		local var_145_98 = "face_" .. var_145_29
		local var_145_99 = arg_145_3.txt_name or var_145_24:getChildByName("txt_name")
		local var_145_100, var_145_101, var_145_102, var_145_103, var_145_104 = DB("pet_character", arg_145_3.code, {
			"type",
			"name",
			var_145_98,
			"feature",
			"desc_category"
		})
		
		var_145_30 = var_145_104
		
		if arg_145_3.no_role then
			if_set_visible(var_145_24, "role", false)
		else
			local var_145_105 = var_145_24:getChildByName("role")
			local var_145_106 = var_145_103 == "y" and "_s.png" or ".png"
			local var_145_107 = "img/cm_icon_role_pet_" .. var_145_100 .. var_145_106
			
			SpriteCache:resetSprite(var_145_105, var_145_107)
		end
		
		SpriteCache:resetSprite(var_145_24:getChildByName("face"), "face/" .. var_145_102 .. "_s.png")
		
		if arg_145_3.no_grade then
			if_set_visible(var_145_24, "n_stars", false)
		else
			for iter_145_3 = var_145_29 + 1, 6 do
				if_set_visible(var_145_24, "star" .. iter_145_3, false)
			end
			
			var_145_24:getChildByName("n_stars"):setPositionX(72 + (var_145_29 - 1) * 6 - (var_145_29 - 1) * 11)
		end
		
		if arg_145_3.star_scale then
			var_145_24:getChildByName("n_stars"):setScale(arg_145_3.star_scale)
		end
		
		local var_145_108 = arg_145_3.txt_type or var_145_24:getChildByName("txt_r_type")
		local var_145_109 = arg_145_3.txt_name or var_145_24:getChildByName("txt_r_name")
		
		if (arg_145_3.detail or arg_145_3.name or arg_145_3.show_name) and not arg_145_3.no_hero_name and (arg_145_3.detail or arg_145_3.name) then
			if arg_145_3.right_hero_name then
				if arg_145_3.right_hero_type and var_145_30 then
					if_set(var_145_108, nil, T(var_145_30))
				end
				
				if_set(var_145_109, nil, T(var_145_101))
				
				if not arg_145_3.no_resize_name and get_cocos_refid(var_145_109) then
					local var_145_110 = arg_145_0:setTextAndReturnHeight(var_145_109, nil, 180)
					
					if arg_145_3.right_hero_type then
						var_145_109:setPositionY(61)
						var_145_109:setAnchorPoint(0, 1)
					else
						var_145_109:setPositionY(48)
						var_145_109:setAnchorPoint(0, 0.5)
					end
				end
			elseif get_cocos_refid(var_145_99) then
				var_145_99:setString(T(var_145_101))
			end
		end
		
		if arg_145_3.lv then
			if arg_145_3.lv > 99 then
				if_set_visible(var_145_24, "99", true)
				if_set_visible(var_145_24, "l1", false)
			else
				if_set_visible(var_145_24, "99", false)
				if_set_sprite(var_145_24, "l2", "img/itxt_num" .. math.floor(arg_145_3.lv / 10) .. "_b.png")
				if_set_sprite(var_145_24, "l1", "img/itxt_num" .. arg_145_3.lv % 10 .. "_b.png")
			end
		else
			if_set_visible(var_145_24, "n_lv", false)
			if_set_visible(var_145_24, "color", false)
			if_set_visible(var_145_24, "bg_color", false)
		end
	else
		if arg_145_1 and not arg_145_3.no_count and arg_145_1 > 0 and not var_145_0 then
			if_set(var_145_24, "c", arg_145_1)
		end
		
		if_set_visible(var_145_24, "c", arg_145_1 ~= nil)
		SpriteCache:resetSprite(var_145_24:getChildByName("icon"), var_145_28)
		
		if arg_145_3.icon_scale then
			local var_145_111 = var_145_24:getChildByName("icon")
			
			if get_cocos_refid(var_145_111) then
				var_145_111:setScale(var_145_111:getScale() * arg_145_3.icon_scale)
			end
		end
		
		local var_145_112 = var_145_24:getChildByName("txt_small_count")
		local var_145_113 = var_145_24:getChildByName("txt_big_count")
		local var_145_114 = arg_145_3.txt_type or var_145_24:getChildByName("txt_type")
		local var_145_115 = arg_145_3.txt_name or var_145_24:getChildByName("txt_name")
		
		if var_145_0 then
			local var_145_116
			local var_145_117 = var_145_1 and "img/cm_item_arti_bg0" or var_145_2 and "img/_itembg_private" or "img/_itembg_equip_"
			
			if var_145_2 then
				SpriteCache:resetSprite(var_145_24:getChildByName("bg"), var_145_117)
			else
				SpriteCache:resetSprite(var_145_24:getChildByName("bg"), var_145_117 .. var_145_29)
			end
		elseif var_145_5 then
			if var_145_45 == "border" then
				SpriteCache:resetSprite(var_145_24:getChildByName("bg"), "img/_hero_s_bg_las.png")
				var_145_24:getChildByName("bg"):setScale(var_145_24:getChildByName("bg"):getScale() * 0.75)
				var_145_24:getChildByName("icon"):setScale(var_145_24:getChildByName("icon"):getScale() * 0.6)
			elseif var_145_45 == "stone" and var_145_46 == "artifact" then
				if arg_145_3.equip_belt then
					SpriteCache:resetSprite(var_145_24:getChildByName("bg"), "img/cm_item_arti_bg0" .. var_145_29 .. ".png")
					var_145_24:getChildByName("bg"):setScale(var_145_24:getChildByName("bg"):getScale() * 1)
					var_145_24:getChildByName("icon"):setScale(var_145_24:getChildByName("icon"):getScale() * 1)
				elseif arg_145_3.shop_artifact_stone then
					SpriteCache:resetSprite(var_145_24:getChildByName("bg"), "img/cm_item_arti_bg0" .. var_145_29 .. ".png")
					var_145_24:getChildByName("bg"):setScale(var_145_24:getChildByName("bg"):getScale() * 0.87)
					var_145_24:getChildByName("icon"):setScale(var_145_24:getChildByName("icon"):getScale() * 0.85)
				else
					SpriteCache:resetSprite(var_145_24:getChildByName("bg"), "img/cm_item_arti_bg0" .. var_145_29 .. ".png")
					var_145_24:getChildByName("bg"):setScale(var_145_24:getChildByName("bg"):getScale() * 0.79)
					var_145_24:getChildByName("icon"):setScale(var_145_24:getChildByName("icon"):getScale() * 0.75)
				end
			elseif var_145_7 then
				var_145_24:getChildByName("icon"):setScale(var_145_24:getChildByName("icon"):getScale() * 0.75)
				var_145_24:getChildByName("bg"):setScale(var_145_24:getChildByName("bg"):getScale() * 0.75)
				
				local var_145_118 = UIUtil:getSkinGradeBorder(var_145_29)
				local var_145_119 = UIUtil:getSkinGradeBG(var_145_29)
				local var_145_120 = cc.Sprite:create("item/border/" .. var_145_118 .. ".png")
				
				if get_cocos_refid(var_145_120) then
					var_145_120:setPosition(var_145_24:getChildByName("icon"):getPosition())
					var_145_120:setScale(var_145_24:getChildByName("icon"):getScale())
					
					local var_145_121 = var_145_24:getChildByName("icon"):getAnchorPoint()
					
					var_145_120:setAnchorPoint(var_145_121.x, var_145_121.y)
					var_145_24:getChildByName("icon"):getParent():addChild(var_145_120)
				end
				
				SpriteCache:resetSprite(var_145_24:getChildByName("bg"), "img/" .. var_145_119 .. ".png")
			elseif var_145_45 == "emoji" then
				local var_145_122 = EmojiManager:getAllEmojis()[arg_145_3.code]
				
				if var_145_122 then
					SpriteCache:resetSprite(var_145_24:getChildByName("icon"), "item/emoticon/icon_" .. var_145_122.rta_res .. ".png")
					var_145_24:getChildByName("icon"):setScale(var_145_24:getChildByName("icon"):getScale())
					if_set_visible(var_145_24, "bg", false)
				end
			else
				SpriteCache:resetSprite(var_145_24:getChildByName("bg"), "img/_itembg_stuff_" .. var_145_29)
			end
			
			if string.find(arg_145_3.code, "ma_petfood_e") or string.find(arg_145_3.code, "ma_petpoint") then
				local var_145_123 = var_145_24:getChildByName("bg")
				
				SpriteCache:resetSprite(var_145_123, "img/_pet_s_bg")
				
				if arg_145_3.isInventory then
					local var_145_124 = var_145_24:getChildByName("icon")
					
					var_145_123:setScale(var_145_123:getScale() * 0.73)
					var_145_123:setPositionY(var_145_123:getPositionY() + 3)
					var_145_124:setScale(var_145_124:getScale() * 0.73)
					var_145_124:setPositionY(var_145_124:getPositionY() + 3)
				elseif arg_145_3.is_tooltip_icon then
					local var_145_125 = var_145_24:getChildByName("icon")
					
					var_145_123:setScale(var_145_123:getScale() * 0.77)
					var_145_125:setScale(var_145_125:getScale() * 0.77)
				else
					local var_145_126 = var_145_24:getChildByName("icon")
					
					var_145_123:setScale(var_145_123:getScale() * 0.88)
					var_145_126:setScale(var_145_126:getScale() * 0.88)
				end
			end
			
			if var_145_45 == "alchemypoint" and var_145_46 then
				local var_145_127 = "set_" .. string.split(var_145_46, ";")[2]
				
				if_set_visible(var_145_24, "set", true)
				replaceSprite(var_145_24, "set", EQUIP:getSetItemIconPath(var_145_127))
			end
			
			if var_145_17 then
				if_set_visible(var_145_24, "frame", false)
				if_set_visible(var_145_24, "bg", false)
			end
		else
			SpriteCache:resetSprite(var_145_24:getChildByName("bg"), "img/_itembg_stuff_" .. var_145_29)
		end
		
		local var_145_128 = var_145_24:getChildByName("_item_bonus")
		local var_145_129 = var_145_24:getChildByName("_item_bonus_pet")
		
		if get_cocos_refid(var_145_128) then
			var_145_128:setVisible(var_145_12 and not var_145_13)
		end
		
		if get_cocos_refid(var_145_129) then
			var_145_129:setVisible(var_145_13)
		end
		
		if var_145_14 then
			if_set_visible(var_145_24, "_item_bonus_legacy", true)
		end
		
		if arg_145_3.txt_name then
			if_set_visible(var_145_24, "txt_name", false)
		end
		
		if arg_145_3.txt_type or arg_145_3.hide_type then
			if_set_visible(var_145_24, "txt_type", false)
		end
		
		if get_cocos_refid(var_145_115) and not arg_145_3.no_name then
			if arg_145_3.detail or arg_145_3.show_name then
				if arg_145_1 and not arg_145_3.show_name then
					local var_145_130 = "+"
					
					if arg_145_3.is_cost then
						var_145_130 = ""
					end
					
					if get_cocos_refid(var_145_113) then
						var_145_113:setString(var_145_130 .. comma_value(arg_145_1))
					end
				else
					if var_145_32 then
						var_145_115:setString(var_145_32)
						
						if arg_145_3.txt_scale then
							var_145_115:setScale(var_145_115:getScale() * arg_145_3.txt_scale)
						end
						
						if arg_145_3.bonus_count then
							local var_145_131 = var_145_24:getChildByName("txt_bonus")
							
							var_145_131:setString(" (+" .. arg_145_3.bonus_count .. " " .. T("msg_bonus_rewawrd") .. ")")
							var_145_131:setPositionX(var_145_131:getPositionX() + var_145_115:getContentSize().width)
							var_145_131:setVisible(true)
						end
					end
					
					if get_cocos_refid(var_145_114) then
						if not var_145_0 then
							if var_145_7 then
								var_145_114:setTextColor(UIUtil:getGradeColor(nil, var_145_29))
							else
								var_145_114:setTextColor(cc.c3b(169, 114, 74))
							end
							
							if var_145_15 then
								local var_145_132 = DB("item_material", arg_145_3.code, "ma_type2")
								local var_145_133, var_145_134 = DB("item_ext", var_145_132, {
									"rank_min",
									"rank_max"
								})
								
								if var_145_133 == var_145_134 then
									var_145_114:setString(T("ext_rank_name_" .. var_145_134))
								else
									var_145_114:setString(T("ext_rank_name_" .. var_145_133) .. " - " .. T("ext_rank_name_" .. var_145_134))
								end
								
								var_145_114:setTextColor(UIUtil:getGradeColor(nil, var_145_29))
							else
								var_145_114:setString(var_145_30)
							end
						elseif not arg_145_3.equip_stat and var_145_36 and var_145_37 then
							if var_145_36 == var_145_37 and not var_145_2 and arg_145_3.show_equip_type then
								var_145_114:setString(var_145_30)
								var_145_114:setTextColor(UIUtil:getGradeColor(nil, var_145_36))
							elseif var_145_36 == var_145_37 and not var_145_2 then
								var_145_114:setString(T("ui_item_grade", {
									grade = EQUIP:getGradeText(var_145_36)
								}))
								var_145_114:setTextColor(UIUtil:getGradeColor(nil, var_145_36))
							elseif var_145_2 then
								var_145_114:setString(T("item_type_exclusive"))
								var_145_114:setTextColor(cc.c3b(165, 92, 255))
							else
								var_145_114:setString(T("ui_item_grade", {
									grade = EQUIP:getGradeText(var_145_36) .. "-" .. EQUIP:getGradeText(var_145_37)
								}))
								var_145_114:setTextColor(UIUtil:getGradeColor(nil, var_145_29))
							end
						else
							var_145_114:setString(var_145_30)
							var_145_114:setTextColor(UIUtil:getGradeColor(nil, var_145_29))
							
							if var_145_2 then
								var_145_114:setTextColor(cc.c3b(165, 92, 255))
							end
							
							local var_145_135 = var_145_114:getContentSize()
							local var_145_136 = 238
							
							if var_145_136 < var_145_135.width then
								local var_145_137 = math.ceil(var_145_135.width / var_145_136)
								
								var_145_114:setTextAreaSize({
									width = var_145_136,
									height = var_145_135.height * var_145_137
								})
							end
						end
						
						if arg_145_3.txt_scale then
							var_145_114:setScale(var_145_114:getScale() * arg_145_3.txt_scale)
						end
					end
				end
				
				if get_cocos_refid(var_145_113) and get_cocos_refid(var_145_112) then
					var_145_113:setVisible(arg_145_3.show_small_count ~= true and arg_145_1 ~= nil)
					
					local var_145_138 = not var_145_0 and (arg_145_3.show_small_count == true and arg_145_1 > 0 or arg_145_1 > 1 and not arg_145_3.no_count)
					
					if var_145_45 == "bgpack" then
						var_145_138 = false
						arg_145_3.no_bg = true
					end
					
					if var_145_138 then
						var_145_112:setString(comma_value(arg_145_1))
					end
					
					var_145_112:setVisible(var_145_138)
				end
				
				if get_cocos_refid(var_145_114) then
					var_145_114:setVisible(not arg_145_3.hide_type and (arg_145_3.count == nil or arg_145_3.show_name))
				end
				
				var_145_115:setVisible(arg_145_1 == nil or arg_145_3.show_name)
			else
				if get_cocos_refid(var_145_112) then
					if arg_145_1 and (arg_145_1 > 1 or arg_145_3.show_count) then
						local var_145_139 = comma_value(arg_145_1)
						
						if var_145_1 then
							var_145_139 = "x" .. var_145_139
						end
						
						var_145_112:setString(var_145_139)
					end
					
					var_145_112:setVisible((not var_145_0 or arg_145_3.show_equip_count) and arg_145_1 ~= nil and (arg_145_1 > 1 or arg_145_3.show_count) and not arg_145_3.no_count)
					
					if var_145_12 or var_145_13 then
						var_145_112:setColor(cc.c3b(255, 120, 0))
					end
					
					if_set_visible(var_145_113, nil, false)
					var_145_114:setVisible(false)
					var_145_115:setVisible(false)
				end
				
				if arg_145_1 and (arg_145_1 > 1 or arg_145_3.show_count) and var_145_1 and arg_145_3.use_gCount then
					local var_145_140 = comma_value(arg_145_1)
					
					if var_145_1 then
						var_145_140 = "x" .. var_145_140
					end
					
					if_set(var_145_24, "txt_g_count", var_145_140)
					if_set_visible(var_145_112, nil, false)
					if_set_visible(var_145_113, nil, false)
				end
			end
			
			if not arg_145_3.no_resize_name then
				arg_145_0:resizeGetRewardIconName(var_145_115, arg_145_3)
				if_set_position_y(var_145_24, "n_names", 12)
			end
			
			if var_145_18 then
				arg_145_0:getFragmentRewardIcon(var_145_24, arg_145_3.code)
			end
			
			if var_145_16 then
				if_set_sprite(var_145_24, "icon", "img/_hero_s_frame_ally.png")
				
				local var_145_141 = SpriteCache:getSprite("img/_itembg_cir_2.png")
				local var_145_142 = SpriteCache:getSprite("item/icon_" .. arg_145_2 .. ".png")
				
				var_145_141:setAnchorPoint(0.5, 0.5)
				var_145_141:setPosition(41.2, 43.2)
				var_145_141:setScale(0.805)
				var_145_142:setAnchorPoint(0.5, 0.5)
				var_145_142:setPosition(48, 48)
				var_145_142:setScale(0.8)
				var_145_142:setCascadeOpacityEnabled(true)
				var_145_141:setCascadeOpacityEnabled(true)
				var_145_142:setCascadeColorEnabled(true)
				var_145_141:setCascadeColorEnabled(true)
				var_145_141:addChild(var_145_142)
				var_145_24:addChild(var_145_141)
				
				local var_145_143 = var_145_24:getChildByName("icon")
				
				var_145_143:setName("penguin_icon")
				var_145_143:setLocalZOrder(9999)
				var_145_143:setScale(0.7)
				
				if arg_145_1 then
					var_145_24:getChildByName("txt_small_count"):bringToFront()
				end
			end
		end
		
		arg_145_3.txt_name = nil
		arg_145_3.txt_type = nil
		
		if var_145_1 and not arg_145_3.equip then
			arg_145_3.equip = EQUIP:createByInfo({
				grade = 1,
				exp = 0,
				code = arg_145_3.code
			})
		end
		
		if var_145_7 and not var_145_8 then
			arg_145_3.no_tooltip = true
		end
		
		local var_145_144 = Material_Tooltip:isPopupExist(arg_145_3.code)
		
		if not arg_145_3.no_tooltip and not arg_145_3.no_detail_popup and var_145_144 and (string.starts(arg_145_3.code, "to_") or string.starts(arg_145_3.code, "ma_")) then
			WidgetUtils:setupTooltipAndPopup({
				control = var_145_24,
				creator = function(arg_149_0)
					local var_149_0
					
					if arg_149_0 then
						var_149_0 = Material_Tooltip:getMaterialTooltip(var_145_24, arg_145_3.code, arg_145_3)
					else
						var_149_0 = ItemTooltip:getItemTooltip({
							code = arg_145_3.code,
							grade = arg_145_3.grade,
							equip = arg_145_3.equip,
							set_fx = arg_145_3.set_fx,
							enhance = arg_145_3.enhance,
							equip_stat = arg_145_3.equip_stat,
							faction = arg_145_3.faction,
							faction_category = arg_145_3.faction_category,
							icon_scale = arg_145_3.icon_scale,
							custom = arg_145_3.custom,
							custom_v2 = arg_145_3.custom_v2,
							custom_v2_category = arg_145_3.custom_v2_category,
							custom_v2_desc = arg_145_3.custom_v2_desc,
							img = arg_145_3.img,
							set_drop = arg_145_3.set_drop,
							grade_rate = arg_145_3.grade_rate,
							grade_max = arg_145_3.grade_max,
							show_equip_type = arg_145_3.show_equip_type,
							use_badge = arg_145_3.use_badge
						})
					end
					
					RewardInfo.addRewardInfoNode(var_149_0, arg_145_3)
					
					return var_149_0
				end,
				delay = arg_145_3.tooltip_delay,
				tooltip_callback = arg_145_3.tooltip_callback,
				event_name = arg_145_3.code
			})
		elseif not arg_145_3.no_tooltip and var_145_10 then
			WidgetUtils:setupTooltip({
				control = var_145_24,
				creator = function()
					local var_150_0 = ItemTooltip:getItemTooltip({
						grade = 1,
						code = arg_145_3.code,
						equip = arg_145_3.equip,
						set_fx = arg_145_3.set_fx,
						enhance = arg_145_3.enhance,
						equip_stat = arg_145_3.equip_stat,
						faction = arg_145_3.faction,
						faction_category = arg_145_3.faction_category,
						icon_scale = arg_145_3.icon_scale,
						custom = arg_145_3.custom,
						img = arg_145_3.img,
						set_drop = arg_145_3.set_drop,
						grade_rate = arg_145_3.grade_rate,
						grade_max = arg_145_3.grade_max,
						show_equip_type = arg_145_3.show_equip_type,
						use_badge = arg_145_3.use_badge
					})
					
					RewardInfo.addRewardInfoNode(var_150_0, arg_145_3)
					
					return var_150_0
				end,
				delay = arg_145_3.tooltip_delay,
				tooltip_callback = arg_145_3.tooltip_callback
			})
		elseif not arg_145_3.no_tooltip then
			WidgetUtils:setupTooltip({
				control = var_145_24,
				creator = function()
					local var_151_0 = ItemTooltip:getItemTooltip({
						code = arg_145_3.code,
						grade = arg_145_3.grade,
						equip = arg_145_3.equip,
						set_fx = arg_145_3.set_fx,
						enhance = arg_145_3.enhance,
						equip_stat = arg_145_3.equip_stat,
						faction = arg_145_3.faction,
						faction_category = arg_145_3.faction_category,
						icon_scale = arg_145_3.icon_scale or var_145_50,
						custom = arg_145_3.custom,
						custom_v2 = arg_145_3.custom_v2,
						custom_v2_category = arg_145_3.custom_v2_category,
						custom_v2_desc = arg_145_3.custom_v2_desc,
						img = arg_145_3.img,
						set_drop = arg_145_3.set_drop,
						grade_rate = arg_145_3.grade_rate,
						grade_max = arg_145_3.grade_max,
						show_equip_type = arg_145_3.show_equip_type,
						use_badge = arg_145_3.use_badge,
						no_detail_popup = arg_145_3.no_detail_popup,
						show_all_exc_skills = arg_145_3.show_all_exc_skills,
						no_bg = arg_145_3.no_bg,
						use_drop_icon = arg_145_3.use_drop_icon
					})
					
					RewardInfo.addRewardInfoNode(var_151_0, arg_145_3)
					
					return var_151_0
				end,
				delay = arg_145_3.tooltip_delay,
				tooltip_callback = arg_145_3.tooltip_callback
			})
		end
		
		if arg_145_3.touch_callback then
			WidgetUtils:simpleTouchCallback(var_145_24, arg_145_3.touch_callback, nil)
		end
	end
	
	if arg_145_3.zero then
		var_145_24:setAnchorPoint(0, 0)
	end
	
	if arg_145_3.x then
		var_145_24:setPositionX(arg_145_3.x)
	end
	
	if arg_145_3.y then
		var_145_24:setPositionY(arg_145_3.y)
	end
	
	if arg_145_3.no_bg then
		if_set_visible(var_145_24, "bg", false)
	end
	
	if arg_145_3.effect then
		arg_145_0:regIconSpotEffect(var_145_24, arg_145_3.effect_delay)
	end
	
	if arg_145_3.ax and arg_145_3.ay then
		var_145_24:setAnchorPoint(arg_145_3.ax, arg_145_3.ay)
	end
	
	if arg_145_3.touch_block then
		arg_145_0:setModal(var_145_24)
	end
	
	if var_145_2 then
		if_set_visible(var_145_24, "tier", false)
	end
	
	if arg_145_3.use_badge or var_145_47 then
		UIUtil:setItemBadge(var_145_24, arg_145_2)
	end
	
	if var_145_13 then
		local var_145_145 = var_145_24:getChildByName("icon")
		local var_145_146 = var_145_145:getContentSize().width / 2
		local var_145_147 = var_145_145:getContentSize().height / 2
		
		EffectManager:Play({
			fn = "ui_itemset_pet_eff_on.cfx",
			layer = var_145_145,
			x = var_145_146,
			y = var_145_147
		})
		EffectManager:Play({
			loop = true,
			fn = "ui_itemset_pet_eff_loop.cfx",
			delay = 1000,
			layer = var_145_145,
			x = var_145_146,
			y = var_145_147
		})
	end
	
	if not arg_145_3.no_popup and var_145_7 and not var_145_8 then
		WidgetUtils:setupPopup({
			control = var_145_24,
			creator = function()
				return UIUtil:getSkinPreviewPopup(arg_145_3.code)
			end,
			delay = arg_145_3.popup_delay
		})
	end
	
	if not arg_145_3.no_popup and var_145_4 then
		WidgetUtils:setupPopup({
			control = var_145_24,
			creator = function()
				if arg_145_3.pet_detail then
					return UIUtil:getPetDetailPopup({
						pet = arg_145_3.pet
					})
				else
					return UIUtil:getPetPreviewPopup({
						lv = 1,
						is_fix_skill = true,
						code = arg_145_3.code,
						grade = arg_145_3.grade,
						hide_star = arg_145_3.hide_star
					})
				end
			end,
			delay = arg_145_3.popup_delay
		})
	else
		if_set_visible(var_145_24, "btn_mob", false)
	end
	
	return var_145_24
end

function UIUtil.getItemDisplayInfo(arg_154_0, arg_154_1)
	local var_154_0 = string.split(arg_154_1, "_")[1]
	local var_154_1 = {
		code = arg_154_1
	}
	local var_154_2
	
	if string.starts(arg_154_1, "e") then
		var_154_1.type, var_154_1.title, var_154_1.desc = DB("equip_item", var_154_1.code, {
			"type",
			"name",
			"desc"
		})
		
		if var_154_1.type ~= "artifact" then
			var_154_1.category = "equip"
		else
			var_154_1.artifact_grade = DB("equip_item", var_154_1.code, {
				"artifact_grade"
			})
			var_154_1.category = "artifact"
		end
	elseif var_154_0 == "ma" then
		var_154_1.type = "material"
		var_154_2 = "item_material"
	elseif var_154_0 == "sp" then
		var_154_1.type = "special"
		var_154_2 = "item_special"
	elseif var_154_0 == "ct" then
		var_154_1.type = "clantoken"
		var_154_2 = "item_clantoken"
	elseif var_154_0 == "to" then
		var_154_1.type = "token"
		var_154_2 = "item_token"
	elseif DB("character", arg_154_1, "name") then
		var_154_1.type = "character"
		var_154_1.category = "character"
		var_154_1.title = DB("character", arg_154_1, "name")
	else
		var_154_1 = nil
		var_154_2 = nil
	end
	
	if var_154_2 and not var_154_1.title then
		var_154_1.title, var_154_1.desc, var_154_1.desc_text = DB(var_154_2, arg_154_1, {
			"name",
			"desc_category",
			"desc"
		})
	end
	
	if var_154_1 and not var_154_1.category then
		var_154_1.category = "other"
	end
	
	return var_154_1
end

function UIUtil.getUserIcon(arg_155_0, arg_155_1, arg_155_2)
	if not arg_155_1 then
		return 
	end
	
	arg_155_2 = arg_155_2 or {}
	
	if type(arg_155_1) == "string" then
		arg_155_1 = UNIT:create({
			code = arg_155_1
		})
	end
	
	if not arg_155_1 then
		Log.e("Err: wrong unit icon id : ", arg_155_1)
		
		arg_155_1 = UNIT:create({
			code = "c1001"
		})
	end
	
	local var_155_0
	
	if not arg_155_2.no_role then
		if arg_155_2.role ~= nil then
			var_155_0 = arg_155_2.role
		else
			var_155_0 = true
		end
	end
	
	local var_155_1
	
	if arg_155_2.no_db_grade ~= nil then
		var_155_1 = arg_155_2.no_db_grade
	else
		var_155_1 = true
	end
	
	local var_155_2
	
	if arg_155_2.no_popup ~= nil then
		var_155_2 = arg_155_2.no_popup
	else
		var_155_2 = true
	end
	
	if arg_155_2.use_popup then
		var_155_2 = nil
	end
	
	local var_155_3
	
	if not arg_155_2.no_grade then
		var_155_3 = arg_155_2.grade or arg_155_1:getGrade()
	end
	
	if arg_155_2.base_grade then
		var_155_3 = arg_155_1:getBaseGrade()
	end
	
	local var_155_4
	
	if not arg_155_2.no_lv then
		var_155_4 = arg_155_2.lv or arg_155_1:getLv()
	end
	
	local var_155_5
	
	if not arg_155_2.no_zodiac then
		var_155_5 = arg_155_2.zodiac or arg_155_1:getZodiacGrade()
	end
	
	local var_155_6
	
	if not arg_155_2.no_awake then
		var_155_6 = arg_155_2.awake or arg_155_1:getAwakeGrade()
	end
	
	return UIUtil:getRewardIcon("c", arg_155_1:getDisplayCode(), {
		parent = arg_155_2.parent,
		name = arg_155_2.name,
		scale = arg_155_2.scale or 1,
		no_popup = var_155_2,
		role = var_155_0,
		no_db_grade = var_155_1,
		no_grade = arg_155_2.no_grade,
		leader_role = arg_155_2.leader_role,
		grade = var_155_3,
		lv = var_155_4,
		border_code = arg_155_2.border_code,
		zodiac = var_155_5,
		awake = var_155_6,
		tier = arg_155_2.tier,
		unit = arg_155_2.unit and arg_155_1,
		is_enemy = arg_155_2.is_enemy,
		character_type = arg_155_2.character_type,
		mob_icon2 = arg_155_2.mob_icon2,
		blind = arg_155_2.blind,
		content_size = arg_155_2.content_size,
		s = arg_155_2.s,
		no_power = arg_155_2.no_power,
		no_devote = arg_155_2.no_devote
	})
end

function UIUtil.getPetIcon(arg_156_0, arg_156_1, arg_156_2)
	if not arg_156_1 then
		return 
	end
	
	arg_156_2 = arg_156_2 or {}
	
	if type(arg_156_1) == "string" then
		arg_156_1 = PET:create({
			code = arg_156_1
		})
	end
	
	local var_156_0
	
	if not arg_156_2.no_role then
		if arg_156_2.role ~= nil then
			var_156_0 = arg_156_2.role
		else
			var_156_0 = true
		end
	end
	
	local var_156_1
	
	if not arg_156_2.no_grade then
		var_156_1 = arg_156_2.grade or arg_156_1:getGrade()
	end
	
	if arg_156_2.base_grade then
		var_156_1 = arg_156_1:getBaseGrade()
	end
	
	local var_156_2
	
	if not arg_156_2.no_lv then
		var_156_2 = arg_156_2.lv or arg_156_1:getLv()
	end
	
	return UIUtil:getRewardIcon(nil, arg_156_1.db.code, {
		parent = arg_156_2.parent,
		name = arg_156_2.name,
		scale = arg_156_2.scale or 1,
		role = var_156_0,
		no_grade = arg_156_2.no_grade,
		grade = var_156_1,
		star_scale = arg_156_2.star_scale,
		lv = var_156_2
	})
end

function UIUtil.getSDModelIcon(arg_157_0, arg_157_1)
	arg_157_1 = arg_157_1 or {}
	
	local var_157_0 = cc.CSLoader:createNode("wnd/reward_icon.csb")
	
	var_157_0:setName("sd_model_icon")
	var_157_0:setAnchorPoint(0.5, 0.5)
	
	if arg_157_1.zero then
		var_157_0:setAnchorPoint(0, 0)
	end
	
	for iter_157_0, iter_157_1 in pairs(var_157_0:getChildren() or {}) do
		if get_cocos_refid(iter_157_1) then
			iter_157_1:setVisible(false)
		end
	end
	
	local var_157_1 = cc.CSLoader:createNode("wnd/mob_icon.csb")
	
	var_157_1:setPosition(0, 0)
	var_157_1:setAnchorPoint(0, 0)
	
	local var_157_2 = var_157_0:getChildByName("n_unit_icon")
	
	var_157_2:setPosition(-3, 0)
	var_157_2:setScale(1)
	var_157_2:setVisible(true)
	var_157_2:addChild(var_157_1)
	
	if arg_157_1.parent then
		local var_157_3 = arg_157_1.parent
		
		if arg_157_1.target then
			var_157_3 = arg_157_1.parent:getChildByName(arg_157_1.target)
		end
		
		local var_157_4 = var_157_3:getChildByName(var_157_0:getName())
		
		if var_157_4 and not arg_157_1.no_remove_prev_icon then
			var_157_4:removeFromParent()
		end
		
		var_157_3:addChild(var_157_0)
	end
	
	local var_157_5 = DBT("item_material", arg_157_1.code, {
		"name",
		"ma_type",
		"ma_type2",
		"hide_own",
		"badge",
		"icon",
		"drop_icon",
		"desc_category",
		"desc"
	})
	
	if not var_157_5 then
		return nil
	end
	
	local var_157_6 = var_157_5.name
	local var_157_7 = var_157_5.desc_category
	local var_157_8
	
	if arg_157_1.use_drop_icon then
		var_157_8 = (var_157_5.drop_icon or "") .. ".png"
	else
		var_157_8 = (var_157_5.icon or "") .. ".png"
	end
	
	local var_157_9 = DB("profile_sd_character", arg_157_1.code, {
		"char_id"
	})
	local var_157_10 = var_157_9 == nil and true or false
	
	var_157_9 = var_157_9 or "c1001"
	
	local var_157_11, var_157_12, var_157_13, var_157_14, var_157_15, var_157_16 = DB("character", var_157_9, {
		"face_id",
		"monster_tier",
		"ch_attribute",
		"role",
		"grade",
		"moonlight"
	})
	
	if arg_157_1.lv then
		if arg_157_1.lv > 99 then
			if_set_visible(var_157_1, "99", true)
			if_set_visible(var_157_1, "l1", false)
		else
			if_set_visible(var_157_1, "99", false)
			if_set_sprite(var_157_1, "l2", "img/itxt_num" .. math.floor(arg_157_1.lv / 10) .. "_b.png")
			if_set_sprite(var_157_1, "l1", "img/itxt_num" .. arg_157_1.lv % 10 .. "_b.png")
		end
		
		if arg_157_1.blind then
			if_set_sprite(var_157_1, "color", "img/game_hud_bar_none.png")
		else
			if_set_sprite(var_157_1, "color", "img/game_hud_bar_" .. var_157_13 .. ".png")
		end
	else
		if_set_visible(var_157_1, "n_lv", false)
		if_set_visible(var_157_1, "color", false)
		if_set_visible(var_157_1, "bg_color", false)
	end
	
	if_set_visible(var_157_1, "txt_b_name", false)
	if_set_visible(var_157_1, "txt_small_count", false)
	if_set_visible(var_157_1, "subboss", false)
	if_set_visible(var_157_1, "boss", false)
	if_set_visible(var_157_1, "name", false)
	
	local var_157_17
	
	var_157_17 = var_157_11 or arg_157_1.face
	
	local var_157_18
	
	var_157_18 = arg_157_1.tier or var_157_18
	
	if_set_visible(var_157_1, "n_souls", arg_157_1.soul)
	
	if arg_157_1.souls then
		if_set_visible(var_157_1, "n_stars", false)
		if_set_visible(var_157_1, "soul" .. to_n(arg_157_1.souls) + 1, false)
		var_157_1:getChildByName("n_souls"):setPositionX((8 - arg_157_1.souls) * 5)
	end
	
	if arg_157_1.hide_lv then
		if_set_visible(var_157_1, "n_lv", false)
		if_set_visible(var_157_1, "color", false)
		if_set_visible(var_157_1, "bg_color", false)
	end
	
	local var_157_19 = "img/cm_icon_pro"
	
	if var_157_16 then
		var_157_19 = var_157_19 .. "m"
	end
	
	if arg_157_1.leader_role then
		SpriteCache:resetSprite(var_157_1:getChildByName("role"), "img/cm_icon_role_main.png")
	elseif arg_157_1.role then
		SpriteCache:resetSprite(var_157_1:getChildByName("role"), "img/cm_icon_role_" .. var_157_14 .. "_b.png")
	elseif arg_157_1.show_color then
		SpriteCache:resetSprite(var_157_1:getChildByName("role"), var_157_19 .. var_157_13 .. ".png")
		var_157_1:getChildByName("role"):setScale(1)
	elseif arg_157_1.show_color_with_role then
		arg_157_1.role = true
		arg_157_1.show_color = true
		
		if_set_visible(var_157_1, "color", arg_157_1.show_color)
		SpriteCache:resetSprite(var_157_1:getChildByName("role"), "img/cm_icon_role_" .. var_157_14 .. "_b.png")
		SpriteCache:resetSprite(var_157_1:getChildByName("color"), var_157_19 .. var_157_13 .. ".png")
	end
	
	if_set_visible(var_157_1, "role", arg_157_1.role or arg_157_1.leader_role or arg_157_1.show_color)
	
	if arg_157_1.blind then
		SpriteCache:resetSprite(var_157_1:getChildByName("face"), "img/_hero_s_blind.png")
	else
		if_set_sprite(var_157_1, "face", var_157_8)
	end
	
	if_set_sprite(var_157_1, "frame", "img/_hero_s_frame_ally.png")
	
	if not arg_157_1.show_grade then
		if_set_visible(var_157_1, "n_stars", false)
	else
		if_set_visible(var_157_1, "n_stars", true)
		
		for iter_157_2 = var_157_15 + 1, 6 do
			if_set_visible(var_157_1, "star" .. iter_157_2, false)
		end
		
		if arg_157_1.zodiac then
			for iter_157_3 = 1, arg_157_1.zodiac do
				SpriteCache:resetSprite(var_157_1:getChildByName("star" .. iter_157_3), "img/cm_icon_star_j.png")
			end
		end
		
		if arg_157_1.awake then
			for iter_157_4 = 1, arg_157_1.awake do
				SpriteCache:resetSprite(var_157_1:getChildByName("star" .. iter_157_4), "img/cm_icon_star_p.png")
			end
		end
		
		var_157_1:getChildByName("n_stars"):setPositionX(72 + (var_157_15 - 1) * 6 - (var_157_15 - 1) * 11)
	end
	
	if arg_157_1 and arg_157_1.star_scale then
		var_157_1:getChildByName("n_stars"):setScale(arg_157_1.star_scale)
	end
	
	if not arg_157_1.no_hero_name and (arg_157_1.detail or arg_157_1.name) then
		local var_157_20 = var_157_0:getChildByName("n_names")
		
		if get_cocos_refid(var_157_20) then
			var_157_20:setVisible(true)
			var_157_20:setPositionY(12)
			
			if arg_157_1.right_hero_type and var_157_7 then
				local var_157_21 = var_157_20:getChildByName("txt_type")
				
				if arg_157_1.txt_scale then
					var_157_21:setScale(var_157_21:getScale() * arg_157_1.txt_scale)
				end
				
				var_157_21:setTextColor(cc.c3b(169, 114, 74))
				if_set(var_157_21, nil, T(var_157_7))
			end
			
			if arg_157_1.right_hero_name and var_157_6 then
				local var_157_22 = var_157_20:getChildByName("txt_name")
				
				if arg_157_1.txt_scale then
					var_157_22:setScale(var_157_22:getScale() * arg_157_1.txt_scale)
				end
				
				if_set(var_157_22, nil, T(var_157_6))
				arg_157_0:resizeGetRewardIconName(var_157_22, arg_157_1)
			end
		end
	end
	
	if var_157_10 then
		if_set_visible(var_157_1, "n_lv", false)
		if_set_visible(var_157_1, "color", false)
		if_set_visible(var_157_1, "bg_color", false)
		if_set_visible(var_157_1, "role", false)
		if_set_visible(var_157_1, "n_stars", false)
	end
	
	if not arg_157_1.no_popup then
		WidgetUtils:setupTooltip({
			control = var_157_1,
			creator = function()
				return ItemTooltip:getItemTooltip({
					grade = 1,
					right_hero_name = true,
					right_hero_type = true,
					code = arg_157_1.code
				})
			end,
			delay = arg_157_1.popup_delay,
			content_size = {
				width = 50,
				height = 50
			}
		})
	end
	
	return var_157_0
end

function UIUtil.updateToggleUI(arg_159_0, arg_159_1, arg_159_2)
	if not get_cocos_refid(arg_159_1) then
		return 
	end
	
	local var_159_0 = getChildByPath(arg_159_1, "../label_on")
	local var_159_1 = getChildByPath(arg_159_1, "../label_off")
	local var_159_2 = cc.c3b(255, 189, 99)
	local var_159_3 = cc.c3b(148, 148, 148)
	
	arg_159_1:setPercent(arg_159_2 and arg_159_1:getMaxPercent() or 0)
	if_set_text_color(var_159_0, nil, arg_159_2 and var_159_2 or var_159_3)
	if_set_text_color(var_159_1, nil, arg_159_2 and var_159_3 or var_159_2)
end

function UIUtil.initSliderToggle(arg_160_0, arg_160_1, arg_160_2, arg_160_3)
	if not arg_160_2 then
		return 
	end
	
	if not get_cocos_refid(arg_160_1) then
		return 
	end
	
	local var_160_0 = arg_160_1:getChildByName("Slider_btn")
	
	if not get_cocos_refid(var_160_0) then
		return 
	end
	
	var_160_0:addEventListener(function(arg_161_0, arg_161_1)
		if UIAction:Find("block") then
			return 
		end
		
		if arg_161_1 ~= 2 then
			return 
		end
		
		arg_160_0:updateToggleUI(arg_161_0, arg_160_2())
	end)
	arg_160_0:updateToggleUI(var_160_0, arg_160_3)
end

function UIUtil.initProgress(arg_162_0, arg_162_1, arg_162_2)
	arg_162_2 = arg_162_2 or {}
	arg_162_2.per = arg_162_2.per or 0
	
	local var_162_0 = arg_162_1:getChildByName("slider")
	
	var_162_0:addEventListener(Dialog.defaultSliderEventHandler)
	
	function var_162_0.handler(arg_163_0, arg_163_1, arg_163_2)
		if arg_163_2 == 0 then
			UIUtil:equalizeProgress(arg_162_1, {
				per = var_162_0:getPercent()
			})
			arg_162_2.handler(arg_162_1, var_162_0:getPercent(), false)
		end
		
		if arg_163_2 == 2 and arg_162_2.handler then
			arg_162_2.handler(arg_162_1, var_162_0:getPercent(), true)
		end
	end
	
	arg_162_0:equalizeProgress(arg_162_1, arg_162_2)
end

function UIUtil.equalizeProgress(arg_164_0, arg_164_1, arg_164_2)
	arg_164_2 = arg_164_2 or {}
	arg_164_2.per = arg_164_2.per or 0
	
	if arg_164_2.enable == nil then
		arg_164_2.enable = true
	end
	
	local var_164_0 = arg_164_1:getChildByName("progress")
	
	if get_cocos_refid(var_164_0) then
		var_164_0:setPercent(arg_164_2.per)
	end
	
	local var_164_1 = arg_164_1:getChildByName("slider")
	
	if get_cocos_refid(var_164_1) then
		if arg_164_2.reset then
			var_164_1:setPercent(arg_164_2.per)
		end
		
		var_164_1:loadProgressBarTexture(arg_164_2.enable and "img/_slider_inbar.png" or "img/_slider_inbar_d.png")
		if_set_enabled(var_164_1, nil, arg_164_2.enable)
	end
	
	local var_164_2 = arg_164_1:getChildByName("txt_per")
	
	if get_cocos_refid(var_164_2) then
		if_set(var_164_2, nil, arg_164_2.per .. "%")
		if_set_opacity(var_164_2, nil, arg_164_2.enable and 255 or 51)
	end
	
	local var_164_3 = arg_164_1:getChildByName("t_count")
	
	if get_cocos_refid(var_164_3) and arg_164_2.max then
		if_set(var_164_3, nil, arg_164_2.per .. "/" .. arg_164_2.max .. T("ui_msg_piece"))
	end
end

function UIUtil.playGetExpEffect(arg_165_0, arg_165_1, arg_165_2, arg_165_3, arg_165_4, arg_165_5, arg_165_6)
	arg_165_6 = arg_165_6 or {}
	
	local var_165_0 = arg_165_1:getChildByName("progress_new")
	local var_165_1 = arg_165_1:getChildByName("exp_gauge")
	local var_165_2 = arg_165_1:getChildByName("add_exp_pos")
	local var_165_3 = arg_165_6.levelupParent or arg_165_1:getChildByName("levelup_eff_pos")
	local var_165_4 = 0
	local var_165_5 = 0
	
	if arg_165_6 then
		var_165_4 = arg_165_6.delay or 0
		var_165_5 = arg_165_6.text_delay or 0
	end
	
	local var_165_6, var_165_7 = arg_165_2:getExpString()
	
	if arg_165_5 then
		arg_165_3 = 0
	end
	
	if var_165_0 then
		local var_165_8 = "block"
		
		if arg_165_6.no_new_exp_progress_block then
			var_165_8 = nil
		end
		
		var_165_1:setPercent((arg_165_3 or 0) * 100)
		var_165_0:setPercent((var_165_7 or 50) * 100)
		UIAction:Add(SEQ(DELAY(var_165_4 + 200), LOG(PROGRESS(1000, arg_165_3, var_165_7))), var_165_1, var_165_8)
	end
	
	if not var_165_2 and not var_165_3 then
		return 
	end
	
	if var_165_2 and arg_165_4 then
		local var_165_9 = SpriteCache:getSprite("img/game_eff_exp.png")
		
		var_165_9:setScale(1.1)
		var_165_9:setAnchorPoint(0, 0)
		
		local var_165_10 = var_165_9:getContentSize()
		
		var_165_9:setPosition(5, 38)
		var_165_2:addChild(var_165_9)
		
		local var_165_11 = UISpriteNumber:create("game_eff_exp_", 0.6)
		
		var_165_11:setPosition(25, 31)
		var_165_11:setScale(1.15)
		var_165_2:addChild(var_165_11)
		
		local var_165_12 = 500
		
		var_165_11:setValue(math.floor(0), math.floor(arg_165_4))
		var_165_2:setVisible(false)
		UIAction:Add(SEQ(DELAY(var_165_4 + var_165_5), SHOW(true), TARGET(var_165_11, PROGRESS(var_165_12, 0, 1)), DELAY(1100), FADE_OUT(200), SHOW(false)), var_165_2)
	end
	
	if arg_165_5 then
		UIAction:Add(SEQ(DELAY(var_165_4 + var_165_5), CALL(function()
			EffectManager:Play({
				fn = "ui_dispatch_levelup.cfx",
				layer = var_165_3
			})
		end, arg_165_0)), var_165_3)
	end
end

function test_preview_popup(arg_167_0)
	local var_167_0 = {}
	
	var_167_0.monster = true
	var_167_0.code = arg_167_0 or "wolf_f_s"
	var_167_0.grade = 1
	var_167_0.tier = "subboss"
	var_167_0.lv = 12
	var_167_0.hide_star = true
	var_167_0.scale = 0.85
	var_167_0.no_db_grade = true
	
	SceneManager:getRunningPopupScene():addChild(UIUtil:getCharacterPopup(var_167_0))
end

function UIUtil.getGachaCharacterPopup(arg_168_0, arg_168_1)
	arg_168_1 = arg_168_1 or {}
	
	local var_168_0 = {
		d = 7,
		z = 6,
		awake = 6,
		use_basic_star = true,
		lv = 1
	}
	
	table.merge(var_168_0, arg_168_1)
	
	return UIUtil:getCharacterPopup(var_168_0)
end

function UIUtil.getCharacterPopup(arg_169_0, arg_169_1)
	arg_169_1 = arg_169_1 or {}
	
	local var_169_0 = arg_169_1.dlg or load_dlg("reward_unit_detail", true, "wnd")
	local var_169_1, var_169_2, var_169_3 = DB("character", arg_169_1.code, {
		"face_id",
		"subtask_mission_skill",
		"type"
	})
	local var_169_4, var_169_5 = DB("character_attribute_change", arg_169_1.code, {
		"skill_tree",
		"attr_change_unlock_value"
	})
	
	var_169_0:setName("util.character.popup")
	
	local var_169_6 = UNIT:create({
		code = arg_169_1.code,
		lv = arg_169_1.lv,
		g = arg_169_1.grade or 1,
		z = arg_169_1.z,
		s = arg_169_1.s,
		d = arg_169_1.d,
		awake = arg_169_1.awake
	})
	
	if EpisodeAdin:isAdinCode(arg_169_1.code) and Account:getUnitByCode(arg_169_1.code) and arg_169_1.show_adin_ui then
		var_169_6 = Account:getAdin()
	end
	
	if DEBUG.OLD_PROMOTION_RULE and var_169_6:isPromotionUnit() then
		var_169_6:setExp(math.huge)
	end
	
	UIUtil:setUnitAllInfo(var_169_0, var_169_6, {
		ignore_stat_diff = true,
		move_zodiac_pos = true,
		hide_star = arg_169_1.hide_star,
		use_basic_star = arg_169_1.use_basic_star
	})
	UIUtil:setUnitSkillInfo(var_169_0, var_169_6, {
		tooltip_opts = {
			show_effs = "right"
		},
		doNotReverseSkill = arg_169_1.doNotReverseSkill
	})
	
	local var_169_7 = {
		hide_level = arg_169_1.hide_level
	}
	
	if var_169_3 == "monster" then
		var_169_7.hide_max = true
	end
	
	UIUtil:setLevelDetail(var_169_0, var_169_6:getLv(), var_169_6:getMaxLevel(), var_169_7)
	if_set_visible(var_169_0, "n_detail_info", not var_169_6:isSummon())
	
	local var_169_8 = var_169_0:getChildByName("n_dedi")
	
	if get_cocos_refid(var_169_8) then
		if var_169_6:isHaveDevote() then
			var_169_8:setVisible(true)
			if_set_visible(var_169_8, nil, not arg_169_1.no_devote)
			UIUtil:setDevoteDetail_new(var_169_0, var_169_6, {
				target = "n_dedi",
				not_my_unit = true,
				devote = arg_169_1.devote
			})
			
			local var_169_9 = var_169_8:getChildByName("btn_dedi")
			
			if get_cocos_refid(var_169_9) then
				var_169_9:setVisible(true)
				var_169_9:addTouchEventListener(function(arg_170_0, arg_170_1)
					if arg_170_1 ~= 2 then
						return 
					end
					
					if UIAction:Find("tooltip_close") then
						return 
					end
					
					DevoteTooltip:showDevoteDetail(var_169_6, SceneManager:getRunningPopupScene(), {
						not_my_unit = true,
						force_front_show = true
					})
				end)
			end
			
			local var_169_10 = var_169_8:getChildByName("btn_dedi2")
			
			if get_cocos_refid(var_169_10) then
				var_169_10:setVisible(true)
				var_169_10:addTouchEventListener(function(arg_171_0, arg_171_1)
					if arg_171_1 ~= 2 then
						return 
					end
					
					if UIAction:Find("tooltip_close") then
						return 
					end
					
					DevoteTooltip:showDevoteDetail(var_169_6, SceneManager:getRunningPopupScene(), {
						not_my_unit = true,
						force_front_show = true
					})
				end)
			end
			
			local var_169_11 = var_169_8:getChildByName("t_locked")
			local var_169_12 = var_169_8:getChildByName("icon_arr")
			
			if var_169_11 and var_169_12 then
				local var_169_13 = var_169_12:getPositionX()
				local var_169_14 = var_169_11:getContentSize().width - var_169_13 + 7.5
				
				if var_169_14 > 0 then
					var_169_12:setPositionX(var_169_13 + var_169_14)
				end
			end
		else
			var_169_8:setVisible(false)
		end
	end
	
	local var_169_15 = var_169_0:getChildByName("n_immune")
	
	if get_cocos_refid(var_169_15) then
		local var_169_16 = var_169_6.db.tier
		
		if var_169_16 == "boss" or var_169_16 == "subboss" or var_169_16 == "elite" then
			var_169_15:setVisible(true)
			
			local var_169_17 = var_169_15:getChildByName("btn_immune")
			local var_169_18 = var_169_15:getChildByName("n_immunes")
			local var_169_19 = var_169_15:getChildByName("n_icon_immune")
			local var_169_20 = var_169_15:getChildByName("icon_open")
			local var_169_21 = var_169_15:getChildByName("icon_close")
			local var_169_22 = var_169_15:getChildByName("res_frame")
			local var_169_23 = var_169_15:getChildByName("n_im_info")
			local var_169_24 = var_169_15:getChildByName("n_txt_immune")
			
			if get_cocos_refid(var_169_17) then
				var_169_20:setVisible(true)
				var_169_17:setVisible(true)
				var_169_17:addTouchEventListener(function(arg_172_0, arg_172_1)
					if arg_172_1 ~= 2 then
						return 
					end
					
					var_169_18:setVisible(not var_169_18:isVisible())
					var_169_20:setVisible(not var_169_18:isVisible())
					var_169_21:setVisible(var_169_18:isVisible())
					
					if not var_169_18.info then
						local function var_172_0(arg_173_0, arg_173_1)
							local var_173_0 = {}
							
							for iter_173_0, iter_173_1 in pairs(arg_173_0) do
								if string.len(iter_173_1) > 0 then
									var_173_0[(arg_173_1 or "") .. iter_173_1] = true
								end
							end
							
							return var_173_0
						end
						
						local function var_172_1(arg_174_0)
							local var_174_0 = {}
							
							for iter_174_0, iter_174_1 in pairs(arg_174_0) do
								table.insert(var_174_0, iter_174_0)
							end
							
							return var_174_0
						end
						
						local function var_172_2(arg_175_0, arg_175_1)
							local var_175_0 = {}
							
							for iter_175_0, iter_175_1 in pairs(arg_175_0 or {}) do
								if table.isInclude(arg_175_1 or {}, iter_175_1) then
									table.insert(var_175_0, iter_175_0)
								end
							end
							
							for iter_175_2 = #var_175_0, 1, -1 do
								table.remove(arg_175_0, var_175_0[iter_175_2])
							end
							
							return arg_175_0
						end
						
						local var_172_3 = DB("character", arg_169_1.code, {
							"skill_immune"
						})
						local var_172_4 = DB("skill", var_172_3, {
							"sk_passive"
						})
						local var_172_5 = DB("cs", var_172_4, "cs_immune_hide")
						local var_172_6 = {
							DB("cs", var_172_4, {
								"cs_eff1",
								"cs_eff_value1",
								"cs_eff2",
								"cs_eff_value2",
								"cs_eff3",
								"cs_eff_value3",
								"cs_eff4",
								"cs_eff_value4",
								"cs_eff5",
								"cs_eff_value5",
								"cs_eff6",
								"cs_eff_value6"
							})
						}
						local var_172_7 = {}
						local var_172_8 = {}
						
						if var_172_5 ~= "y" then
							for iter_172_0, iter_172_1 in pairs(var_172_6 or {}) do
								if iter_172_1 == "CSP_DEBUFF_BLOCK" then
									local var_172_9, var_172_10, var_172_11 = DB("skill_immune_group", var_172_6[iter_172_0 + 1], {
										"cs",
										"eff",
										"hide"
									})
									local var_172_12 = string.split(var_172_9 or "", ",")
									local var_172_13 = string.split(var_172_10 or "", ",")
									local var_172_14 = string.split(var_172_11 or "", ",")
									
									table.merge(var_172_8, var_172_0(var_172_2(var_172_12, var_172_14)))
									table.merge(var_172_7, var_172_0(var_172_2(var_172_13, var_172_14), "immune_"))
								elseif iter_172_1 == "CSP_IMMUNE" then
									local var_172_15 = string.split(var_172_6[iter_172_0 + 1] or "", ",")
									
									table.merge(var_172_7, var_172_0(var_172_15, "immune_"))
								elseif iter_172_1 == "CSP_IMMUNE_CS" then
									local var_172_16 = string.split(var_172_6[iter_172_0 + 1] or "", ",") or {}
									
									table.merge(var_172_8, var_172_0(var_172_16))
								end
							end
							
							var_172_8 = var_172_1(var_172_8)
							var_172_7 = var_172_1(var_172_7)
						end
						
						local var_172_17 = 153
						local var_172_18 = -82
						
						var_169_19:setVisible(true)
						var_169_19:removeAllChildren()
						
						local var_172_19 = 0
						
						for iter_172_2, iter_172_3 in pairs(var_172_8 or {}) do
							if iter_172_2 > 1 then
								var_172_17 = var_172_17 + 28
								var_172_18 = var_172_18 + 28
								var_172_19 = var_172_19 - 28
							end
							
							local var_172_20 = getStateBanner(iter_172_3)
							
							var_169_19:addChild(var_172_20)
							var_172_20:setPositionY(var_172_19)
						end
						
						var_169_24:setVisible(false)
						
						if not table.empty(var_172_7) then
							var_169_24:setVisible(true)
							
							var_172_17 = var_172_17 + 45
							var_172_18 = var_172_18 + 45
						end
						
						local var_172_21 = ""
						
						for iter_172_4, iter_172_5 in pairs(var_172_7) do
							if iter_172_4 > 1 then
								var_172_21 = var_172_21 .. "\n"
								var_172_17 = var_172_17 + 22
								var_172_18 = var_172_18 + 22
							end
							
							if string.find(T(iter_172_5:lower()), "\n") then
								var_172_17 = var_172_17 + 22
								var_172_18 = var_172_18 + 22
							end
							
							var_172_21 = var_172_21 .. T(iter_172_5:lower())
						end
						
						var_169_22:setContentSize({
							width = var_169_22:getContentSize().width,
							height = var_172_17
						})
						var_169_23:setPositionY(var_172_18)
						
						if table.empty(var_172_8) and table.empty(var_172_7) then
							var_169_24:setVisible(true)
							var_169_24:setPositionY(0)
							if_set(var_169_24, "t_immune_eff", T("ui_preview_immune_none"))
						else
							var_169_24:setPositionY(var_172_19 - 33)
							if_set(var_169_24, "t_immune_eff", var_172_21)
						end
					end
				end)
			end
		end
	end
	
	if var_169_4 and var_169_5 then
		local var_169_25 = var_169_0:getChildByName("n_adin")
		
		if get_cocos_refid(var_169_25) and arg_169_1.show_adin_ui then
			var_169_25:setVisible(true)
			
			local var_169_26 = var_169_25:getChildByName("btn_prochange")
			local var_169_27 = var_169_25:getChildByName("btn_skill")
			local var_169_28 = Account:getUnitByCode(arg_169_1.code)
			local var_169_29 = UnitExtension:isAttributeUnlocked(arg_169_1.code)
			local var_169_30 = var_169_29 and not var_169_28 and UnitExtension:isChangeableTarget(arg_169_1.code)
			local var_169_31
			local var_169_32 = Account:getAdin()
			
			if not var_169_32 and Account:isAdinOnCollection() then
				var_169_30 = false
				var_169_31 = {
					"waitingroom"
				}
			elseif var_169_32 and BackPlayManager:isRunning() and BackPlayManager:isInBackPlayTeam(var_169_32:getUID()) then
				var_169_30 = false
				var_169_31 = {
					"bgbattle"
				}
			end
			
			local var_169_33 = DB("dic_data", arg_169_1.code, {
				"item_id"
			}) ~= nil
			
			local function var_169_34()
				if not var_169_29 then
					return 
				end
				
				local var_176_0 = (var_169_28 and var_169_28:getSTreeTotalPoint() or UnitExtension:getSTreeTotalPoint(arg_169_1.code)) / 30
				
				if_set_percent(var_169_25, "progress_bar", var_176_0)
				if_set_color(var_169_25, "progress_bar", var_176_0 >= 1 and cc.c3b(107, 193, 27) or cc.c3b(146, 109, 62))
				if_set(var_169_25, "t_percent", math.floor(var_176_0 * 100) .. "%")
			end
			
			if get_cocos_refid(var_169_26) then
				if var_169_28 then
					var_169_26:setVisible(false)
				elseif var_169_30 then
					var_169_26:setOpacity(255)
					var_169_26:addTouchEventListener(function(arg_177_0, arg_177_1)
						if arg_177_1 ~= 2 then
							return 
						end
						
						if UIAction:Find("tooltip_close") then
							return 
						end
						
						UnitExtensionUI:show(arg_169_1.code, SceneManager:getRunningPopupScene(), {
							force_front_show = true
						})
					end)
				else
					var_169_26:setOpacity(76.5)
					var_169_26:addTouchEventListener(function(arg_178_0, arg_178_1)
						if arg_178_1 ~= 2 then
							return 
						end
						
						if var_169_31 then
							Dialog:msgUnitLock(var_169_31)
							
							return 
						end
						
						balloon_message_with_sound("msg_cannot_change_attr")
					end)
				end
				
				if_set_sprite(var_169_26, "icon_pro", "img/cm_icon_pro" .. var_169_4 .. ".png")
			end
			
			if get_cocos_refid(var_169_27) then
				if_set(var_169_27, "label", var_169_29 == true and T("ui_reward_unit_detail_btn_skill_tree") or T("ui_reward_unit_detail_btn_skill_tree_preview"))
				
				if var_169_33 then
					var_169_27:setOpacity(255)
					
					if var_169_28 then
						var_169_27:addTouchEventListener(function(arg_179_0, arg_179_1)
							if arg_179_1 ~= 2 then
								return 
							end
							
							if UIAction:Find("tooltip_close") then
								return 
							end
							
							UnitZodiac:onCreate({
								force_front_show = true,
								parent = SceneManager:getRunningPopupScene(),
								unit = var_169_28,
								on_leave = var_169_34
							})
							UnitZodiac:onEnter(nil, {
								enter_mode = "Rune"
							})
						end)
					else
						var_169_27:addTouchEventListener(function(arg_180_0, arg_180_1)
							if arg_180_1 ~= 2 then
								return 
							end
							
							if UIAction:Find("tooltip_close") then
								return 
							end
							
							var_169_6.inst.stree = UnitExtension:getSkillTree(arg_169_1.code)
							
							UnitZodiac:beginDictMode(SceneManager:getRunningPopupScene(), var_169_6, true, nil, true)
						end)
					end
				else
					var_169_27:setOpacity(76.5)
					var_169_27:addTouchEventListener(function(arg_181_0, arg_181_1)
						if arg_181_1 ~= 2 then
							return 
						end
						
						if UIAction:Find("tooltip_close") then
							return 
						end
						
						balloon_message_with_sound("msg_cannot_change_attr")
					end)
				end
			end
			
			if_set_visible(var_169_25, "n_skill_tree", var_169_33)
			if_set_visible(var_169_25, "progress_bg", var_169_29)
			if_set_visible(var_169_25, "t_skill_tree", var_169_29)
			var_169_34()
		end
		
		if arg_169_1.show_adin_ui and EpisodeAdin:isAdinCode(arg_169_1.code) then
			arg_169_1.no_power = true
		end
		
		arg_169_1.skill_preview = false
	end
	
	local var_169_35 = var_169_0:getChildByName("txt_name")
	
	if_call(var_169_0, "star1", "setPositionX", 10 + var_169_35:getContentSize().width * var_169_35:getScaleX() + var_169_35:getPositionX())
	
	local var_169_36 = var_169_0:getChildByName("LEFT"):getChildByName("txt_story")
	
	if get_cocos_refid(var_169_36) then
		var_169_36:setString(T(DB("character", arg_169_1.code, "2line"), "text"))
	end
	
	if DEBUG.OLD_PROMOTION_RULE then
		if_set_visible(var_169_0, "detail", not var_169_6:isPromotionUnit() and not var_169_6:isExpUnit())
	else
		if_set_visible(var_169_0, "detail", not var_169_6:isExpUnit())
	end
	
	if DEBUG.OLD_PROMOTION_RULE then
		if_set_visible(var_169_0, "n_skills", not var_169_6:isPromotionUnit() and not var_169_6:isExpUnit())
	else
		if_set_visible(var_169_0, "n_skills", not var_169_6:isExpUnit())
	end
	
	if DEBUG.OLD_PROMOTION_RULE and var_169_6:isPromotionUnit() then
		var_169_0:getChildByName("n_stats"):setPositionY(200)
		if_set(var_169_0, "desc", TooltipUtil:getSkillTooltipText(var_169_6:getSkillByIndex(1), 1))
	end
	
	if arg_169_1.no_power then
		if_set_visible(var_169_0, "n_stats", false)
	else
		if_set_visible(var_169_0, "n_stats", var_169_6:isOrganizable())
	end
	
	local var_169_37 = var_169_0:getChildByName("CENTER")
	local var_169_38
	
	if not arg_169_1.custom_portrait then
		local var_169_39 = UIUtil:getPortraitAni(var_169_1, {
			pin_sprite_position_y = true,
			parent_pos_y = var_169_37:getChildByName("portrait"):getPositionY()
		})
		
		if var_169_39 then
			var_169_39:setScale(0.8)
			var_169_37:getChildByName("portrait"):addChild(var_169_39)
		end
	else
		local var_169_40 = arg_169_1.custom_portrait
		
		var_169_37:getChildByName("portrait"):addChild(var_169_40)
	end
	
	if SceneManager:getCurrentSceneName() == "battle" then
		arg_169_1.skill_preview = false
	end
	
	if arg_169_1.skill_preview then
		local var_169_41 = DB("dic_data", arg_169_1.code, "skill_preview")
		local var_169_42 = var_169_0:getChildByName("btn_skill_preview")
		
		if var_169_41 and get_cocos_refid(var_169_42) then
			var_169_42:setVisible(true)
			var_169_42:addTouchEventListener(function(arg_182_0, arg_182_1)
				if arg_182_1 ~= 2 then
					return 
				end
				
				if ContentDisable:checkDisableUnitByAlias("preview_skills", arg_169_1.code) then
					balloon_message_with_sound("skill_preview_lock_info")
					
					return 
				end
				
				startSkillPreview(arg_169_1.code)
			end)
			if_set_visible(var_169_0, "n_grow_panel", true)
		elseif get_cocos_refid(var_169_42) then
			var_169_42:setVisible(false)
			if_set_visible(var_169_0, "n_grow_panel", false)
		end
	else
		if_set_visible(var_169_0, "btn_skill_preview", false)
		if_set_visible(var_169_0, "n_grow_panel", false)
	end
	
	if not arg_169_1.skill_preview and arg_169_1.review_preview then
		local var_169_43 = var_169_0:getChildByName("btn_rate")
		
		if get_cocos_refid(var_169_43) then
			var_169_43:setVisible(true)
			var_169_43:addTouchEventListener(function(arg_183_0, arg_183_1)
				if arg_183_1 ~= 2 then
					return 
				end
				
				if NetWaiting:isWaiting() == false then
					ReviewPreviewPopup:open(arg_169_1.code)
				end
			end)
			if_set_visible(var_169_0, "n_grow_panel", true)
		end
	else
		if_set_visible(var_169_0, "btn_rate", false)
	end
	
	if arg_169_1.off_power_detail == true then
		if_set_visible(var_169_0, "n_dedi", false)
		if_set_visible(var_169_0, "n_stats", false)
	end
	
	;(function()
		if IS_PUBLISHER_ZLONG and get_cocos_refid(var_169_0) then
			local var_184_0 = var_169_0:getChildByName("btn_rate")
			
			if get_cocos_refid(var_184_0) and var_184_0:isVisible() then
				var_184_0:setVisible(false)
				if_set_visible(var_169_0, "n_grow_panel", false)
			end
		end
	end)()
	
	return var_169_0
end

function UIUtil.getSubtaskConditionTooltip(arg_185_0, arg_185_1)
	arg_185_1 = arg_185_1 or {}
	
	local var_185_0 = arg_185_1.dlg or load_dlg("subtask_condition_detail", true, "wnd")
	local var_185_1, var_185_2 = DB("subtask_mission_condition", arg_185_1.condition, {
		"name",
		"desc"
	})
	local var_185_3 = T(var_185_2)
	
	if_set(var_185_0, "name", T(var_185_1))
	if_set_sprite(var_185_0, "icon", "emblem/" .. arg_185_1.condition .. ".png")
	
	local var_185_4 = var_185_0:getChildByName("disc")
	local var_185_5 = arg_185_0:setTextAndReturnHeight(var_185_4, var_185_3) + 160
	local var_185_6
	
	if arg_185_1.cond_data then
		for iter_185_0, iter_185_1 in pairs(arg_185_1.cond_data) do
			for iter_185_2, iter_185_3 in pairs(iter_185_1) do
				if iter_185_3.condition == arg_185_1.condition then
					var_185_6 = iter_185_1
					
					break
				end
			end
		end
	end
	
	if_set_visible(var_185_0, "active", false)
	
	if var_185_6 then
		local var_185_7 = var_185_0:getChildByName("active")
		
		for iter_185_4 = 1, 4 do
			if_set_visible(var_185_7, "card" .. iter_185_4, false)
		end
		
		local var_185_8 = 0
		
		for iter_185_5, iter_185_6 in pairs(var_185_6) do
			if iter_185_6.condition == arg_185_1.condition then
				var_185_8 = var_185_8 + 1
				
				local var_185_9 = var_185_7:getChildByName("card" .. var_185_8)
				
				var_185_9:setVisible(true)
				var_185_9:setPositionY(var_185_9:getPositionY() - (var_185_8 - 1) * 35)
				UIUtil:setSubtaskSkill(var_185_9, iter_185_6.unit, {
					resize = true
				})
				
				local var_185_10 = var_185_9:getChildByName("name")
				
				if_set(var_185_9, "name", iter_185_6.unit:getName())
				if_set_visible(var_185_9, "icon_check", var_185_8 == 1)
				
				local var_185_11 = var_185_9:getChildByName("bg_subtask")
				
				if var_185_11 then
					var_185_10:setPositionX(var_185_11:getPositionX() + var_185_11:getContentSize().width * var_185_11:getScaleX() + 10)
				end
			end
		end
		
		if var_185_8 > 0 then
			var_185_5 = var_185_5 + 108
			
			var_185_7:setPositionY(337 - var_185_5 + 108)
			
			var_185_5 = var_185_5 + (var_185_8 - 1) * 35
			
			if_set_visible(var_185_0, "active", true)
		end
	end
	
	local var_185_12 = var_185_0:getChildByName("wnd")
	
	if var_185_12 then
		local var_185_13 = var_185_12:getContentSize()
		
		var_185_12:setContentSize(var_185_13.width, var_185_5)
	end
	
	return var_185_0
end

function UIUtil.setSubTaskStatInfo(arg_186_0, arg_186_1, arg_186_2)
	local var_186_0 = DBT("character", arg_186_2.db.code, {
		"ch_command",
		"ch_attractive",
		"ch_politics"
	})
	
	if_set(arg_186_1, "txt_stat1_count", var_186_0.ch_command or 0)
	if_set(arg_186_1, "txt_stat2_count", var_186_0.ch_attractive or 0)
	if_set(arg_186_1, "txt_stat3_count", var_186_0.ch_politics or 0)
end

function UIUtil.setSubTaskSkillInfo(arg_187_0, arg_187_1, arg_187_2, arg_187_3)
	arg_187_3 = arg_187_3 or {}
	
	local var_187_0 = arg_187_2:getSubTaskMissionSkill()
	
	if var_187_0 then
		local var_187_1 = arg_187_1:getChildByName("n_specialty")
		
		if not arg_187_3.no_stat then
			arg_187_0:setSubTaskStatInfo(var_187_1, arg_187_2)
		end
		
		local var_187_2 = var_187_1:getChildByName("n_icon_specialty")
		
		if get_cocos_refid(var_187_2) then
			if_set_sprite(var_187_2, "icon", "skill/" .. var_187_0.icon)
		end
		
		WidgetUtils:setupTooltip({
			delay = 0,
			control = var_187_2:getChildByName("icon"),
			creator = function()
				return UIUtil:getSubtaskSkillTooltip(arg_187_2)
			end
		})
		if_set(var_187_1, "txt_name", T(var_187_0.name))
		if_set(var_187_1, "txt_disc", T(var_187_0.desc))
	else
		if_set_visible(arg_187_1, "n_specialty", false)
	end
end

function UIUtil.getSubtaskSkillTooltip(arg_189_0, arg_189_1, arg_189_2)
	arg_189_2 = arg_189_2 or {}
	
	local var_189_0 = arg_189_2.dlg or load_dlg("subtask_skill_detail", true, "wnd")
	local var_189_1 = arg_189_1:getSubTaskMissionSkill()
	local var_189_2 = Account:getRelationUnit(arg_189_1.db.code)
	
	if_set(var_189_0, "txt_skill_name", T(var_189_1.name))
	if_set_sprite(var_189_0, "icon_skill", "skill/" .. var_189_1.icon)
	
	local var_189_3 = var_189_0:getChildByName("txt_story")
	local var_189_4 = arg_189_0:setTextAndReturnHeight(var_189_3, T(var_189_1.desc))
	local var_189_5 = var_189_3:getStringNumLines()
	local var_189_6 = var_189_4 + 170
	
	if_set_visible(var_189_0, "lock_subtask", false)
	if_set_visible(var_189_0, "n_lock", false)
	if_set_visible(var_189_0, "n_active", false)
	if_set_visible(var_189_0, "n_apply", true)
	if_set_visible(var_189_0, "n_effect", true)
	
	local var_189_7 = var_189_0:getChildByName("n_apply")
	local var_189_8 = ""
	
	if var_189_1.relate_type == "all" then
		var_189_8 = T("sms_tooltip_all")
	elseif var_189_1.relate_type == "category" then
		var_189_8 = T("sms_tooltip_ctg", {
			category = T("sm_ctg_" .. var_189_1.relate_type_detail)
		})
	elseif var_189_1.relate_type == "type" then
		var_189_8 = T("sms_tooltip_type", {
			type = T("sm_type_" .. var_189_1.relate_type_detail)
		})
	elseif var_189_1.relate_type == "condition" then
		local var_189_9 = DB("subtask_mission_condition", var_189_1.relate_type_detail, {
			"name"
		})
		
		var_189_8 = T("sms_tooltip_cndt", {
			condition = T(var_189_9)
		})
	end
	
	if_set(var_189_7, "txt_apply_name", var_189_8)
	
	local var_189_10 = var_189_6 + 95
	local var_189_11 = var_189_0:getChildByName("n_effect")
	local var_189_12 = ""
	
	if var_189_1.effect_type == "reward_bonus" then
		var_189_12 = T("sms_tooltip_eff_rwrd", {
			value = tostring(var_189_1.effect_value * 100)
		})
	elseif var_189_1.effect_type == "gold_bonus" then
		var_189_12 = T("sms_tooltip_eff_gold", {
			value = tostring(var_189_1.effect_value * 100)
		})
	elseif var_189_1.effect_type == "exp_bonus" then
		var_189_12 = T("sms_tooltip_eff_exp", {
			value = tostring(var_189_1.effect_value * 100)
		})
	elseif var_189_1.effect_type == "time_reduce" then
		var_189_12 = T("sms_tooltip_eff_time", {
			value = tostring(var_189_1.effect_value * 100)
		})
	end
	
	if_set(var_189_11, "txt_effect", var_189_12)
	
	local var_189_13 = var_189_10 + 125
	
	if arg_189_2.condition then
		if_set_visible(var_189_0, "n_active", true)
		
		local var_189_14 = var_189_0:getChildByName("n_active")
		
		var_189_13 = var_189_13 + 90
		
		var_189_14:setPositionY(288 - var_189_13)
		
		local var_189_15 = DB("subtask_mission_condition", arg_189_2.condition, {
			"name"
		})
		
		if_set(var_189_14, "txt", T(var_189_15))
		if_set_sprite(var_189_14, "icon", "emblem/" .. arg_189_2.condition .. ".png")
	end
	
	local var_189_16 = var_189_0:getChildByName("wnd")
	local var_189_18
	
	if var_189_16 then
		local var_189_17 = var_189_16:getContentSize()
		
		var_189_16:setContentSize(var_189_17.width, var_189_13)
		var_189_0:setContentSize(var_189_17.width, var_189_13)
		
		var_189_18 = var_189_13 - var_189_16:getPositionY()
		
		local var_189_19 = var_189_0:getChildren()
		
		for iter_189_0, iter_189_1 in pairs(var_189_19) do
			local var_189_20 = iter_189_1:getPositionY()
			
			iter_189_1:setPositionY(iter_189_1:getPositionY() + var_189_18)
		end
	end
	
	if var_189_5 > 3 then
		local var_189_21 = var_189_0:getChildByName("n_apply")
		local var_189_22 = var_189_0:getChildByName("n_effect")
		
		var_189_21:setPositionY(var_189_21:getPositionY() - var_189_5 * 15)
		var_189_22:setPositionY(var_189_22:getPositionY() - var_189_5 * 15)
	end
	
	return var_189_0
end

function UIUtil.strToC3b(arg_190_0, arg_190_1)
	local var_190_0 = tonumber(string.sub(arg_190_1, 1, 2), 16)
	local var_190_1 = tonumber(string.sub(arg_190_1, 3, 4), 16)
	local var_190_2 = tonumber(string.sub(arg_190_1, 5, 6), 16)
	
	return cc.c3b(var_190_0, var_190_1, var_190_2)
end

function UIUtil.getSkinPreviewPopup(arg_191_0, arg_191_1)
	return UnitSkin:createForOne(arg_191_1)
end

function UIUtil.setTextAndReturnHeight(arg_192_0, arg_192_1, arg_192_2, arg_192_3, arg_192_4)
	if not get_cocos_refid(arg_192_1) then
		return 
	end
	
	arg_192_1:setTextAreaSize({
		width = arg_192_3 or arg_192_1:getContentSize().width,
		height = to_n(arg_192_4)
	})
	arg_192_1:ignoreContentAdaptWithSize(true)
	
	if arg_192_2 then
		if_set(arg_192_1, nil, arg_192_2)
	end
	
	return arg_192_1:getContentSize().height * arg_192_1:getScaleY()
end

function UIUtil.setAutoTextArea(arg_193_0, arg_193_1)
	if not get_cocos_refid(arg_193_1) then
		return 
	end
	
	arg_193_1:setTextAreaSize({
		height = 0,
		width = arg_193_1:getContentSize().width
	})
	
	local var_193_0 = arg_193_1:isIgnoreContentAdaptWithSize()
	
	arg_193_1:ignoreContentAdaptWithSize(true)
	arg_193_1:ignoreContentAdaptWithSize(var_193_0)
end

function UIUtil.setRewardIcon(arg_194_0, arg_194_1, arg_194_2, arg_194_3)
	if not arg_194_1 then
		return 
	end
	
	local var_194_0 = UIUtil:getRewardIcon(arg_194_1, arg_194_2, arg_194_3)
	
	if not string.starts(arg_194_1, "c") then
		arg_194_0:regIconSpotEffect(var_194_0, arg_194_3.delay)
	end
	
	return var_194_0
end

function UIUtil.regIconSpotEffect(arg_195_0, arg_195_1, arg_195_2)
	local var_195_0 = CACHE:getEffect("item_spot.scsp")
	
	var_195_0:setScale(1.9)
	
	local var_195_1, var_195_2 = arg_195_1:getPosition()
	
	var_195_0:setPosition(SceneManager:convertToSceneSpace(arg_195_1, {
		x = 45,
		y = 40
	}))
	var_195_0:setVisible(false)
	UIAction:Add(SEQ(DELAY(arg_195_2 or 0), SHOW(true), DMOTION("animation"), REMOVE()), var_195_0, "block")
	
	local var_195_3 = getParentWindow(arg_195_1)
	
	if var_195_3 then
		var_195_3:addChild(var_195_0)
	end
end

function UIUtil.regIconSpotPlayEffect(arg_196_0, arg_196_1, arg_196_2)
	local var_196_0 = CACHE:getEffect("item_spot.scsp")
	
	var_196_0:setScale(1.9)
	var_196_0:setAnchorPoint(0, 0)
	var_196_0:setPosition(arg_196_1:getContentSize().width / 2, arg_196_1:getContentSize().height / 2)
	
	local var_196_1, var_196_2 = arg_196_1:getPosition()
	
	if get_cocos_refid(arg_196_1:getChildByName("penguin_icon")) then
		local var_196_3 = arg_196_1:getChildByName("penguin_icon"):getLocalZOrder()
		
		var_196_0:setLocalZOrder(var_196_3 + 1)
	end
	
	var_196_0:setVisible(false)
	UIAction:Add(SEQ(DELAY(arg_196_2 or 0), SHOW(true), DMOTION("animation"), REMOVE()), var_196_0, "block")
	
	if getParentWindow(arg_196_1) then
		arg_196_1:addChild(var_196_0)
	end
end

function UIUtil.getChargeInfo(arg_197_0, arg_197_1, arg_197_2)
	arg_197_2 = arg_197_2 or {}
	
	local var_197_0 = {}
	local var_197_1, var_197_2, var_197_3, var_197_4 = DB("level_enter", arg_197_1, {
		"type_enterpoint",
		"use_enterpoint",
		"enter_limit",
		"contents_type"
	})
	
	var_197_0.use_enterpoint = var_197_2
	var_197_0.type_enterpoint = var_197_1
	
	local var_197_5 = DB("item_token", var_197_1, {
		"type"
	})
	
	if var_197_5 == nil then
		var_197_0.cur_enterpoint = Account:getItemCount(var_197_1)
		
		if not var_197_3 then
			Log.e("no_enter", "limit_mateiral")
			
			var_197_0.enterable = false
			
			return var_197_0
		end
	else
		var_197_0.cur_enterpoint = Account:getCurrency(var_197_5)
	end
	
	if var_197_4 == "crehunt" then
		local var_197_6 = Account:getCrehuntDifficultyByEnterID(arg_197_1)
		
		if DungeonCreviceUtil:isFirstEnter(var_197_6) then
			arg_197_2.replace_enterpoint = GAME_CONTENT_VARIABLE.crevicehunt_stamina_first or 30
		end
	end
	
	if arg_197_2.replace_enterpoint then
		var_197_0.use_enterpoint = arg_197_2.replace_enterpoint
	end
	
	var_197_0.enterable = var_197_0.cur_enterpoint >= var_197_0.use_enterpoint
	
	return var_197_0
end

function UIUtil.setButtonEnterInfo(arg_198_0, arg_198_1, arg_198_2, arg_198_3)
	arg_198_3 = arg_198_3 or {}
	
	local var_198_0
	
	if not get_cocos_refid(arg_198_1) then
		return 
	end
	
	if arg_198_1:getChildByName("n_counter") == nil then
		return 
	end
	
	local var_198_1, var_198_2 = Account:getEnterLimitInfo(arg_198_2)
	
	if var_198_1 then
		if_set(arg_198_1, "cost", var_198_1 .. "/" .. var_198_2)
		if_set_visible(arg_198_1, "icon_res", false)
		
		local var_198_3
		
		var_198_3 = var_198_1 > 0
	end
	
	local var_198_4 = UIUtil:getChargeInfo(arg_198_2, arg_198_3)
	local var_198_5 = var_198_4.enterable
	local var_198_6 = arg_198_1:getChildByName("n_token")
	
	if_set_visible(arg_198_1, "icon_res", arg_198_3.use_icon_res)
	
	if get_cocos_refid(var_198_6) then
		UIUtil:getRewardIcon(nil, var_198_4.type_enterpoint, {
			no_bg = true,
			no_tooltip = true,
			parent = var_198_6
		})
	end
	
	if var_198_4.use_enterpoint and var_198_4.cur_enterpoint and to_n(var_198_4.use_enterpoint) >= 0 then
		if_set(arg_198_1, "cost", var_198_4.use_enterpoint .. "/" .. var_198_4.cur_enterpoint)
		
		if var_198_5 then
			var_198_4.type_enterpoint = nil
		end
	end
	
	if not var_198_1 and to_n(var_198_4.use_enterpoint) == 0 and not arg_198_3.force_show_enter_point then
		local var_198_7 = arg_198_1:getChildByName("label")
		
		if var_198_7 and get_cocos_refid(var_198_7) and not var_198_7.move_pos then
			var_198_7.move_pos = true
			
			arg_198_1:getChildByName("label"):setPositionX(var_198_7:getPositionX() - 50)
		end
		
		if_set_visible(arg_198_1, "n_counter", false)
		if_call(arg_198_1, "txt_go", "setPositionX", 140)
		
		var_198_5 = arg_198_2 ~= nil
	end
	
	if DEBUG.DEBUG_NO_ENTER_LIMIT then
		return true
	end
	
	if arg_198_3.practice_mode then
		if_set_visible(arg_198_1, "n_counter", false)
		if_set_visible(arg_198_1, "label", false)
		if_set_visible(arg_198_1, "label_practice", true)
	elseif arg_198_3.automaton_free_enter then
		if_set_visible(arg_198_1, "n_counter", true)
		if_set_visible(arg_198_1, "label", true)
		if_set_visible(arg_198_1, "label_practice", false)
		if_set(arg_198_1, "cost", "0/" .. var_198_4.cur_enterpoint)
	elseif DungeonHell:isChallengeRetryMode(arg_198_3.next_floor or arg_198_2) then
		if_set_visible(arg_198_1, "n_counter", false)
		if_set_visible(arg_198_1, "label", false)
		if_set_visible(arg_198_1, "label_practice", true)
	else
		if_set_visible(arg_198_1, "label", true)
		if_set_visible(arg_198_1, "label_practice", false)
	end
	
	return var_198_5, var_198_4.type_enterpoint
end

function UIUtil.getStateIconPath(arg_199_0, arg_199_1, arg_199_2, arg_199_3)
	arg_199_3 = arg_199_3 or {}
	
	local var_199_0 = DB("cs", tostring(arg_199_1), "cs_icon")
	
	if var_199_0 == nil then
		return nil
	end
	
	local var_199_1 = string.split(var_199_0, ",")
	
	if #var_199_1 > 1 then
		if arg_199_2 then
			local var_199_2 = arg_199_2.states:find(arg_199_1)
			local var_199_3 = 1
			
			if var_199_2:isAntiSkillDamage() then
				var_199_3 = math.min(var_199_2.value, #var_199_1)
			else
				var_199_3 = math.min(var_199_2.stack_count, #var_199_1)
			end
			
			var_199_0 = var_199_1[var_199_3]
		elseif arg_199_3.stack_count then
			var_199_0 = var_199_1[arg_199_3.stack_count]
		else
			var_199_0 = var_199_1[1]
		end
	end
	
	return "buff/" .. var_199_0 .. ".png", var_199_0
end

function UIUtil.getStateIcon(arg_200_0, arg_200_1, arg_200_2, arg_200_3)
	local var_200_0 = arg_200_0:getStateIconPath(arg_200_1, arg_200_2, arg_200_3)
	
	if not var_200_0 then
		return nil
	end
	
	local var_200_1 = SpriteCache:getSprite(var_200_0) or SpriteCache:getSprite("img/404.png")
	local var_200_2 = 1
	
	if arg_200_2 then
		local var_200_3 = arg_200_2.states:find(arg_200_1)
		
		if var_200_3 then
			var_200_2 = var_200_3.stack_count
		end
	elseif arg_200_3 and arg_200_3.stack_count then
		var_200_2 = arg_200_3.stack_count
	end
	
	local var_200_4 = DB("cs", arg_200_1, "cs_effectexplain")
	
	if var_200_4 then
		WidgetUtils:setupTooltip({
			delay = 100,
			control = var_200_1,
			creator = function()
				return UIUtil:getSkillEffectTip(var_200_4, var_200_2)
			end
		})
	end
	
	return var_200_1
end

function UIUtil.setUnitSkillInfo(arg_202_0, arg_202_1, arg_202_2, arg_202_3)
	local var_202_0 = arg_202_3 or {}
	local var_202_1 = not (arg_202_1:getName() ~= "util.character.popup" and arg_202_1:getName() ~= "dict_unit_detail") and -1 or 1
	local var_202_2 = 0
	local var_202_3 = 0
	local var_202_4 = 0
	local var_202_5 = 1
	local var_202_6 = {}
	local var_202_7 = DB("character", arg_202_2.inst.code, "skill_show_monster") == "y"
	local var_202_8 = arg_202_1:getChildByName("skill_icons_" .. (arg_202_2:getType() == "monster" and "mob" or "hero"))
	
	if get_cocos_refid(var_202_8) then
		var_202_8:setVisible(true)
		
		arg_202_1 = var_202_8
	end
	
	local var_202_9 = var_202_1 < 0 and not var_202_7
	local var_202_10 = var_202_1 * (var_202_9 and -1 or 1)
	
	if var_202_0.doNotReverseSkill then
		var_202_9 = false
	end
	
	for iter_202_0 = 1, 10 do
		local var_202_11 = arg_202_2:getSkillByIndex(iter_202_0)
		
		if var_202_11 then
			local var_202_12, var_202_13 = UIUtil:getSkillIcon(arg_202_2, var_202_11, merge_table({
				skill_lv = arg_202_2:getSkillLevelByIndex(iter_202_0)
			}, var_202_0))
			local var_202_14, var_202_15 = DB("skill", var_202_11, {
				"pre_cool",
				"turn_cool"
			})
			
			var_202_12.skill_id = var_202_11
			var_202_12.turn_cool = to_n(var_202_15)
			var_202_12.pre_cool = to_n(var_202_14)
			
			if var_202_13 then
				table.insert(var_202_6, var_202_12)
			end
		end
	end
	
	if var_202_7 and var_202_10 < 0 then
		local var_202_16
		local var_202_17 = 0
		
		for iter_202_1 = #var_202_6, 1, -1 do
			local var_202_18 = var_202_6[iter_202_1]
			
			if var_202_17 < to_n(var_202_18.turn_cool) then
				var_202_17 = var_202_18.turn_cool
				var_202_16 = iter_202_1
			end
		end
		
		if var_202_16 then
			local var_202_19 = table.remove(var_202_6, var_202_16)
			
			table.insert(var_202_6, 1, var_202_19)
		end
	end
	
	for iter_202_2 = 1, 10 do
		local var_202_20 = var_202_6[iter_202_2]
		local var_202_21 = iter_202_2
		
		if var_202_9 then
			var_202_21 = 4 - iter_202_2 + 6 * math.floor((iter_202_2 - 1) / 3)
		end
		
		local var_202_22 = arg_202_1:getChildByName("skill" .. var_202_21) or arg_202_1:getChildByName("icon_skill0" .. var_202_21)
		
		if get_cocos_refid(var_202_22) then
			var_202_22:removeAllChildren()
			
			if var_202_20 then
				var_202_22:setVisible(true)
				
				if iter_202_2 < 4 then
					var_202_2 = var_202_2 + 1
				elseif iter_202_2 < 7 then
					var_202_3 = var_202_3 + 1
				else
					var_202_4 = var_202_4 + 1
				end
				
				var_202_20:setName("skill" .. var_202_21)
				var_202_22:addChild(var_202_20)
			else
				var_202_22:setVisible(false)
			end
		end
	end
	
	if not var_202_0.no_change_pos then
		local var_202_23 = var_202_4 > 0
		local var_202_24 = arg_202_1:getChildByName("n_skillline1")
		local var_202_25 = arg_202_1:getChildByName("n_skillline2")
		local var_202_26 = arg_202_1:getChildByName("n_skillline3")
		local var_202_27 = (3 - var_202_2) * 38 * var_202_10
		local var_202_28 = (3 - var_202_3) * 38 * var_202_10
		local var_202_29 = (3 - var_202_4) * 38 * var_202_10
		
		if get_cocos_refid(var_202_24) then
			var_202_24:setPositionX(var_202_27)
			var_202_24:setPositionY(var_202_23 and 28 or 0)
		end
		
		if get_cocos_refid(var_202_25) then
			var_202_25:setPositionX(var_202_28)
			var_202_25:setPositionY(var_202_23 and 28 or 0)
		end
		
		if get_cocos_refid(var_202_26) then
			var_202_26:setPositionX(var_202_29)
		end
	end
	
	local var_202_30 = arg_202_1:getChildByName("btn_potential")
	
	if get_cocos_refid(var_202_30) then
		if not table.empty(arg_202_2:getAwakeSkill(6)) then
			if get_cocos_refid(var_202_30._TOUCH_LISTENER) then
				var_202_30._TOUCH_LISTENER:removeFromParent()
				
				var_202_30._TOUCH_LISTENER = nil
			end
			
			WidgetUtils:setupPopup({
				control = var_202_30,
				creator = function()
					local var_203_0 = UIUtil:getAwakeSkillPopup(arg_202_2, {
						show_effs = "right",
						dict_mode = var_202_0.dict_mode
					})
					local var_203_1 = var_202_30:getContentSize()
					local var_203_2 = SceneManager:convertToSceneSpace(var_202_30, {
						y = 0,
						x = var_203_1.width
					})
					
					var_203_0:setPosition(var_203_2.x, DESIGN_HEIGHT / 2)
					var_203_0:setAnchorPoint(0, 0.5)
					
					return var_203_0
				end
			})
			var_202_30:setVisible(true)
		else
			var_202_30:setVisible(false)
		end
	end
end

function UIUtil.getSkillByUIIdx(arg_204_0, arg_204_1, arg_204_2)
	if arg_204_2 == 5 then
		return arg_204_1:getPassiveSkill()
	else
		return arg_204_1:getSkillByIndex(arg_204_2)
	end
end

function UIUtil.getCircleClipNode(arg_205_0, arg_205_1, arg_205_2)
	local var_205_0 = cc.ClippingNode:create()
	local var_205_1 = SpriteCache:getSprite(arg_205_1)
	local var_205_2 = UIUtil:getCircleStencil(arg_205_2, var_205_1:getContentSize().width, var_205_1:getContentSize().height)
	
	var_205_0:setStencil(var_205_2)
	var_205_0:addChild(var_205_1)
	
	return var_205_0
end

function UIUtil.getCircleStencil(arg_206_0, arg_206_1, arg_206_2, arg_206_3)
	arg_206_1 = arg_206_1 or 1
	
	local var_206_0 = cc.DrawNode:create()
	local var_206_1 = arg_206_2 / 2
	local var_206_2 = arg_206_3 / 2
	local var_206_3 = {}
	
	table.insert(var_206_3, cc.p(0, 0))
	
	local var_206_4 = {
		[0] = cc.p(0, var_206_2),
		cc.p(var_206_1, var_206_2),
		cc.p(var_206_1, 0),
		cc.p(var_206_1, -var_206_2),
		cc.p(0, -var_206_2),
		cc.p(-var_206_1, -var_206_2),
		cc.p(-var_206_1, 0),
		(cc.p(-var_206_1, var_206_2))
	}
	local var_206_5 = 0
	
	for iter_206_0 = 0, 7 do
		if arg_206_1 > iter_206_0 * 0.125 then
			var_206_5 = iter_206_0
			
			table.insert(var_206_3, var_206_4[iter_206_0])
		end
	end
	
	local var_206_6 = math.sin(math.rad(arg_206_1 * 360))
	local var_206_7 = math.cos(math.rad(arg_206_1 * 360))
	local var_206_8 = 0
	local var_206_9 = 0
	
	if arg_206_1 > 0.125 and arg_206_1 < 0.375 or arg_206_1 > 0.625 and arg_206_1 < 0.875 then
		var_206_8 = var_206_7 * var_206_2 / (var_206_6 * var_206_1) * var_206_4[var_206_5].x
		var_206_9 = var_206_4[var_206_5].x
	else
		var_206_8 = var_206_4[var_206_5].y
		var_206_9 = var_206_6 * var_206_1 / (var_206_7 * var_206_2) * var_206_4[var_206_5].y
	end
	
	table.insert(var_206_3, cc.p(var_206_9, var_206_8))
	
	local var_206_10 = cc.c3b(255, 255, 255)
	
	var_206_0:drawPolygon(var_206_3, #var_206_3, var_206_10, 0, var_206_10)
	
	return var_206_0
end

function UIUtil.showTalkBalloon(arg_207_0, arg_207_1, arg_207_2)
	local var_207_0 = cc.CSLoader:createNode("wnd/mini_talk.csb")
	local var_207_1 = arg_207_2.x
	local var_207_2 = arg_207_2.y
	
	if arg_207_2.model then
		local var_207_3, var_207_4 = arg_207_2.model:getBonePosition("top")
		local var_207_5, var_207_6 = arg_207_2.model:getBonePosition("root")
		local var_207_7 = 170 + (var_207_4 - var_207_6) * 1.7
		local var_207_8 = SceneManager:convertToSceneSpace(arg_207_2.model, {
			x = 0,
			y = var_207_7
		})
		
		var_207_1 = math.floor(var_207_8.x)
		var_207_2 = math.floor(var_207_8.y)
	end
	
	local var_207_9 = var_207_0:getChildByName("txt")
	
	var_207_9:setTouchEnabled(false)
	
	local var_207_10 = var_207_9:getContentSize()
	local var_207_11 = var_207_0:getChildByName("n_base")
	local var_207_12 = var_207_0:getChildByName("n_face")
	local var_207_13 = var_207_11:getChildByName("bg")
	
	UIUtil:updateTextWrapMode(var_207_9, arg_207_1, 30)
	
	if arg_207_2.width then
		local var_207_14 = var_207_13:getContentSize()
		local var_207_15 = 0.85
		
		var_207_13:setContentSize(arg_207_2.width, var_207_14.height)
		var_207_9:setContentSize(arg_207_2.width * var_207_15, var_207_10.height)
		
		local var_207_16 = arg_207_2.offset_x or not (not arg_207_2.code and not arg_207_2.face_id) and 24 or 0
		
		var_207_9:setPositionX(var_207_16 + arg_207_2.width * 1.2 * var_207_9:getScaleX() * 0.5)
	end
	
	if arg_207_2.auto_height then
		local var_207_17 = var_207_13:getContentSize()
		local var_207_18 = math.abs(arg_207_0:setTextAndReturnHeight(var_207_9, arg_207_1))
		
		var_207_13:setContentSize(var_207_17.width, 75 + var_207_18 / var_207_9:getScaleY() * 0.9 * var_207_13:getScaleY())
		var_207_9:setPositionY(55 + (arg_207_2.offset_y or 0))
	end
	
	local var_207_19 = false
	
	if arg_207_2.reverse == nil and var_207_1 > DESIGN_WIDTH / 2 or arg_207_2.reverse then
		var_207_19 = not var_207_19
		
		var_207_11:setScaleX(-var_207_11:getScaleX())
		var_207_12:setScaleX(-var_207_12:getScaleX())
		var_207_9:setScaleX(0 - var_207_9:getScaleX())
	end
	
	if arg_207_2.reverse_y then
		var_207_11:setScaleY(-1)
		var_207_12:setScaleY(-1)
		var_207_9:setScaleY(0 - var_207_9:getScaleY())
		var_207_9:setPositionY(var_207_9:getPositionY() - var_207_9:getContentSize().height * var_207_9:getScaleY())
	end
	
	if arg_207_2.code then
		local var_207_20, var_207_21 = DB("character", arg_207_2.code, {
			"name",
			"face_id"
		})
		
		if_set_sprite(var_207_0, "face", "face/" .. var_207_21 .. "_s.png")
		
		if not arg_207_2.name then
			arg_207_2.name = T(var_207_20)
		end
	elseif arg_207_2.face_id then
		if_set_sprite(var_207_0, "face", "face/" .. arg_207_2.face_id .. "_s.png")
	else
		if_set_visible(var_207_0, "n_face", false)
	end
	
	if arg_207_2.border_code then
		local var_207_22, var_207_23 = DB("item_material", arg_207_2.border_code, {
			"icon",
			"frame_effect"
		})
		
		if var_207_22 then
			local var_207_24 = var_207_0:getChildByName("frame")
			
			if get_cocos_refid(var_207_24) then
				SpriteCache:resetSprite(var_207_24, "item/" .. var_207_22 .. ".png")
				var_207_24:setScale(0.68)
				if_set_effect(var_207_24, nil, var_207_23)
			end
		end
	end
	
	if_set_visible(var_207_0, "n_name_left", false)
	if_set_visible(var_207_0, "n_name_right", false)
	
	if arg_207_2.name then
		local var_207_25
		
		if var_207_19 then
			var_207_25 = var_207_0:getChildByName("n_name_right")
		else
			var_207_25 = var_207_0:getChildByName("n_name_left")
		end
		
		if_set(var_207_25, "name", arg_207_2.name)
		if_set_visible(var_207_0, "glow", true)
		var_207_25:setVisible(true)
	end
	
	var_207_9:setString("")
	
	if var_207_1 and var_207_2 then
		var_207_0:setPosition(var_207_1, var_207_2)
	end
	
	arg_207_2.layer:addChild(var_207_0)
	
	local var_207_26 = arg_207_2.scale or 1
	local var_207_27 = (arg_207_2.default_delay or 3000) + utf8len(arg_207_1) * 20
	
	var_207_0:setScale(0)
	
	if not arg_207_2.skip_action then
		if arg_207_2.no_fade_out then
			UIAction:Add(SEQ(LOG(SCALE(150, 0, var_207_26 * 1.1)), DELAY(50), RLOG(SCALE(80, var_207_26 * 1.1, var_207_26)), TARGET(var_207_9, SOUND_TEXT(arg_207_1, true))), var_207_0, "talk_balloon")
		else
			UIAction:Add(SEQ(LOG(SCALE(150, 0, var_207_26 * 1.1)), DELAY(50), RLOG(SCALE(80, var_207_26 * 1.1, var_207_26)), TARGET(var_207_9, SOUND_TEXT(arg_207_1, true)), DELAY(var_207_27), FADE_OUT(300)), var_207_0, "talk_balloon")
		end
	else
		var_207_0:setScale(var_207_26)
		var_207_9:setString(arg_207_1)
	end
	
	if arg_207_2.hide_balloon then
		if_set_visible(var_207_11, "bg", false)
	end
	
	if arg_207_2.touch_callback then
		local var_207_28 = var_207_11:getChildByName("btn_face")
		
		if get_cocos_refid(var_207_28) then
			var_207_28:addTouchEventListener(arg_207_2.touch_callback)
		end
		
		local var_207_29 = var_207_11:getChildByName("bg")
		
		if get_cocos_refid(var_207_29) then
			local var_207_30 = var_207_29:getContentSize()
			local var_207_31 = ccui.Button:create()
			
			var_207_31:setTouchEnabled(true)
			var_207_31:ignoreContentAdaptWithSize(false)
			var_207_31:setContentSize(var_207_30.width, var_207_30.height)
			var_207_31:setPosition(var_207_30.width / 2, var_207_30.height / 2)
			var_207_31:addTouchEventListener(arg_207_2.touch_callback)
			var_207_29:addChild(var_207_31)
		end
	else
		if_set_visible(var_207_11, "btn_face", false)
	end
	
	return var_207_0
end

function UIUtil.showTalkBalloon2(arg_208_0, arg_208_1, arg_208_2)
	local var_208_0 = arg_208_2 or {}
	local var_208_1 = cc.CSLoader:createNode("wnd/mini_talk2.csb")
	local var_208_2 = var_208_0.x
	local var_208_3 = var_208_0.y
	
	if var_208_0.model then
		local var_208_4, var_208_5 = var_208_0.model:getBonePosition("top")
		local var_208_6, var_208_7 = var_208_0.model:getBonePosition("root")
		local var_208_8 = 170 + (var_208_5 - var_208_7) * 1.7
		local var_208_9 = SceneManager:convertToSceneSpace(var_208_0.model, {
			x = 0,
			y = var_208_8
		})
		
		var_208_2 = math.floor(var_208_9.x)
		var_208_3 = math.floor(var_208_9.y)
	end
	
	if var_208_2 and var_208_3 then
		var_208_1:setPosition(var_208_2, var_208_3)
	end
	
	if var_208_0.layer then
		var_208_0.layer:addChild(var_208_1)
	end
	
	local var_208_10 = var_208_0.reverse == nil and var_208_2 > DESIGN_WIDTH / 2 or var_208_0.reverse
	local var_208_11 = var_208_1:getChildByName("n_base")
	local var_208_12 = var_208_1:getChildByName("n_face")
	local var_208_13 = var_208_10 and var_208_1:getChildByName("n_name_left") or var_208_1:getChildByName("n_name_right")
	local var_208_14 = var_208_1:getChildByName("n_no_talk")
	local var_208_15 = var_208_13:getChildByName("name")
	local var_208_16 = var_208_13:getChildByName("bar")
	local var_208_17 = var_208_13:getChildByName("txt")
	local var_208_18 = var_208_13:getChildByName("bg")
	
	if_set_visible(var_208_1, var_208_10 and "n_name_right" or "n_name_left", false)
	var_208_17:setTouchEnabled(false)
	
	if not var_208_10 then
		var_208_12:setScaleX(-var_208_12:getScaleX())
	end
	
	local var_208_19 = var_208_0.long_word_num or 30
	
	UIUtil:updateTextWrapMode(var_208_17, arg_208_1, var_208_19)
	
	if var_208_0.width then
		local var_208_20 = var_208_18:getContentSize()
		local var_208_21 = var_208_17:getContentSize()
		local var_208_22 = 0.85
		local var_208_23 = var_208_20.width - var_208_0.width
		
		var_208_18:setContentSize(var_208_0.width, var_208_20.height)
		var_208_17:setContentSize(var_208_0.width * var_208_22, var_208_21.height)
		
		if var_208_10 then
			var_208_17:setPositionX(var_208_17:getPositionX() - var_208_23)
			var_208_16:setPositionX(var_208_16:getPositionX() + var_208_23)
		end
	end
	
	if var_208_0.auto_height then
		local var_208_24 = 75 + math.abs(arg_208_0:setTextAndReturnHeight(var_208_17, arg_208_1)) / var_208_17:getScaleY() * 0.9 * var_208_18:getScaleY()
		local var_208_25 = 5
		local var_208_26 = var_208_24 - var_208_18:getContentSize().height + var_208_25
		
		var_208_18:setContentSize(var_208_18:getContentSize().width, var_208_24)
		var_208_17:setPositionY(55 + (var_208_0.offset_y or 0))
		var_208_16:setPositionY(var_208_16:getPositionY() + var_208_26)
	end
	
	if var_208_0.code then
		local var_208_27, var_208_28 = DB("character", var_208_0.code, {
			"name",
			"face_id"
		})
		
		if_set_sprite(var_208_1, "face", "face/" .. var_208_28 .. "_s.png")
		
		if not var_208_0.name then
			var_208_0.name = T(var_208_27)
		end
	elseif var_208_0.face_id then
		if_set_sprite(var_208_1, "face", "face/" .. var_208_0.face_id .. "_s.png")
	else
		if_set_visible(var_208_1, "n_face", false)
	end
	
	if_set_visible(var_208_13, "bar", var_208_0.name)
	
	if var_208_0.name then
		if var_208_0.hide_balloon then
			local var_208_29 = var_208_14:getChildByName("talk_small_bg")
			local var_208_30 = var_208_29:getChildByName("name")
			local var_208_31 = var_208_29:getChildByName("arrow_b")
			
			if get_cocos_refid(var_208_29) and get_cocos_refid(var_208_30) and get_cocos_refid(var_208_31) then
				UIUserData:parse(var_208_29)
				UIUserData:parse(var_208_30)
				UIUserData:parse(var_208_31)
				var_208_30:setString(var_208_0.name)
				UIUserData:procAfterLoadDlg()
			end
		else
			if_set(var_208_16, "name", var_208_0.name)
		end
		
		local var_208_32 = var_208_15:getContentSize().width
		local var_208_33 = var_208_16:getContentSize().width * 0.7
		
		if var_208_33 < var_208_32 then
			var_208_16:setContentSize(var_208_16:getContentSize().width * (var_208_32 / var_208_33), var_208_16:getContentSize().height)
		end
	end
	
	var_208_14:setVisible(var_208_0.hide_balloon)
	var_208_13:setVisible(not var_208_0.hide_balloon)
	
	local var_208_34 = var_208_0.scale or 1
	local var_208_35 = (var_208_0.default_delay or 3000) + utf8len(arg_208_1) * 20
	
	var_208_1:setScale(0)
	var_208_17:setString("")
	
	if not var_208_0.skip_action then
		if var_208_0.no_fade_out then
			UIAction:Add(SEQ(LOG(SCALE(150, 0, var_208_34 * 1.1)), DELAY(50), RLOG(SCALE(80, var_208_34 * 1.1, var_208_34)), TARGET(var_208_17, SOUND_TEXT(arg_208_1, true))), var_208_1, "talk_balloon")
		else
			UIAction:Add(SEQ(LOG(SCALE(150, 0, var_208_34 * 1.1)), DELAY(50), RLOG(SCALE(80, var_208_34 * 1.1, var_208_34)), TARGET(var_208_17, SOUND_TEXT(arg_208_1, true)), DELAY(var_208_35), FADE_OUT(300)), var_208_1, "talk_balloon")
		end
	else
		var_208_1:setScale(var_208_34)
		var_208_17:setString(arg_208_1)
	end
	
	if var_208_0.touch_callback then
		local var_208_36 = var_208_11:getChildByName("btn_face")
		
		if get_cocos_refid(var_208_36) then
			var_208_36:addTouchEventListener(var_208_0.touch_callback)
		end
		
		local var_208_37 = var_208_13:getChildByName("bg")
		
		if get_cocos_refid(var_208_37) then
			local var_208_38 = var_208_37:getContentSize()
			local var_208_39 = ccui.Button:create()
			
			var_208_39:setTouchEnabled(true)
			var_208_39:ignoreContentAdaptWithSize(false)
			var_208_39:setContentSize(var_208_38.width, var_208_38.height)
			var_208_39:setPosition(var_208_38.width / 2, var_208_38.height / 2)
			var_208_39:addTouchEventListener(var_208_0.touch_callback)
			var_208_37:addChild(var_208_39)
		end
	else
		if_set_visible(var_208_11, "btn_face", false)
	end
	
	return var_208_1
end

function UIUtil.getHPBar(arg_209_0, arg_209_1, arg_209_2, arg_209_3, arg_209_4, arg_209_5, arg_209_6, arg_209_7, arg_209_8, arg_209_9)
	local var_209_0
	local var_209_1
	
	if arg_209_5 then
		var_209_0 = load_control("wnd/hp_bar_norm.csb")
		
		var_209_0:setAnchorPoint(0, 0)
		var_209_0:getChildByName("hp"):setScaleX(arg_209_1:getHPRatio())
		var_209_0:getChildByName("sp"):setScaleX(arg_209_1:getSPRatio())
		HPBar:updateMarks(var_209_0, arg_209_1)
		HPBar:resetMarks(var_209_0, arg_209_1)
		
		if arg_209_2 then
			arg_209_2:addChild(var_209_0)
		end
		
		var_209_1 = "img/game_hud_bar_norm_n.png"
	else
		var_209_0 = HPBar:create(arg_209_1, {
			layer = arg_209_2,
			full_hp = arg_209_4,
			show_story_buff = arg_209_6,
			guest = arg_209_1.guest,
			show_healing = arg_209_7,
			is_automaton = arg_209_8,
			is_used_unit = arg_209_9
		}).control
		var_209_1 = "img/game_hud_bar_bg_n.png"
		
		var_209_0:setAnchorPoint(0, 0.7)
	end
	
	if arg_209_3 then
		local var_209_2, var_209_3 = arg_209_3:getPosition()
		local var_209_4 = var_209_2 + arg_209_3:getContentSize().width * arg_209_3:getScaleX() + 4
		
		var_209_0:setPosition(var_209_4, var_209_3 - 4)
	end
	
	if arg_209_1:getSPName() ~= "mp" then
		if_set_sprite(var_209_0, "frame", var_209_1)
		if_set_visible(var_209_0, "n_spmark")
	end
	
	return var_209_0
end

local function var_0_7(arg_210_0)
	local var_210_0 = arg_210_0:getCapInsetsNormalRenderer()
	
	arg_210_0:loadTextureNormal("img/_btn_blue.png")
	arg_210_0:loadTexturePressed("img/_btn_blue_p.png")
	arg_210_0:loadTextureDisabled("img/_btn_blue_p.png")
	arg_210_0:setCapInsets(var_210_0)
end

local function var_0_8(arg_211_0)
	local var_211_0 = arg_211_0:getCapInsetsNormalRenderer()
	
	arg_211_0:loadTextureNormal("img/_btn_gold.png")
	arg_211_0:loadTexturePressed("img/_btn_gold_p.png")
	arg_211_0:loadTextureDisabled("img/_btn_gold_p.png")
	arg_211_0:setCapInsets(var_211_0)
end

local function var_0_9(arg_212_0)
	local var_212_0 = arg_212_0:getCapInsetsNormalRenderer()
	
	arg_212_0:loadTextureNormal("img/_btn_green.png")
	arg_212_0:loadTexturePressed("img/_btn_green_p.png")
	arg_212_0:loadTextureDisabled("img/_btn_green_p.png")
	arg_212_0:setCapInsets(var_212_0)
end

function UIUtil.setColorRewardButtonState(arg_213_0, arg_213_1, arg_213_2, arg_213_3, arg_213_4)
	arg_213_4 = arg_213_4 or {}
	
	local var_213_0 = arg_213_2
	local var_213_1 = not arg_213_4.give and not arg_213_4.hidden and arg_213_1 ~= 2 and arg_213_1 ~= "received" and arg_213_1 ~= "clear" and arg_213_1 ~= 1
	
	if_set_visible(arg_213_3, "cm_icon_etcarrow2", var_213_1)
	if_set_visible(arg_213_2, "n_complet", arg_213_1 == 2)
	
	if not arg_213_4.no_btn_hide then
		arg_213_3:setVisible(arg_213_1 ~= 2)
	end
	
	local var_213_2 = arg_213_3:getChildByName("btn_label")
	
	if arg_213_1 == 0 or arg_213_1 == "active" then
		if_set_visible(arg_213_2, "icon_check", false)
		if_set_color(arg_213_2, "progress", cc.c3b(146, 109, 62))
		if_set_color(arg_213_2, "txt_title", cc.c3b(146, 109, 62))
		
		if not arg_213_4.no_btn_text then
			if arg_213_4.give then
				if get_cocos_refid(var_213_2) then
					var_213_2:setString(T("give_text"))
					
					arg_213_4.add_x_active = arg_213_4.add_x_active or 12
					var_213_2.first_pos_x = var_213_2.first_pos_x or var_213_2:getPositionX()
					
					var_213_2:setPositionX(var_213_2.first_pos_x + arg_213_4.add_x_active)
				end
				
				var_0_7(arg_213_3)
			elseif arg_213_4.battle then
				if get_cocos_refid(var_213_2) then
					var_213_2:setString(arg_213_4.active_text or T("condition_battle_text"))
					
					arg_213_4.add_x_active = arg_213_4.add_x_active or 5
					var_213_2.first_pos_x = var_213_2.first_pos_x or var_213_2:getPositionX()
					
					var_213_2:setPositionX(var_213_2.first_pos_x + arg_213_4.add_x_active)
				end
				
				var_0_7(arg_213_3)
				
				if var_213_1 then
					if_set_color(arg_213_2, "cm_icon_etcarrow2", cc.c3b(51, 122, 155))
				end
			elseif arg_213_4.hidden then
				if get_cocos_refid(var_213_2) then
					var_213_2:setString(arg_213_4.active_text or T("sub_ach_hint_btn"))
					
					arg_213_4.add_x_active = arg_213_4.add_x_active or 12
					var_213_2.first_pos_x = var_213_2.first_pos_x or var_213_2:getPositionX()
					
					var_213_2:setPositionX(var_213_2.first_pos_x + arg_213_4.add_x_active)
				end
				
				var_0_7(arg_213_3)
				
				if var_213_1 then
					if_set_color(arg_213_2, "cm_icon_etcarrow2", cc.c3b(51, 122, 155))
				end
			else
				if get_cocos_refid(var_213_2) then
					var_213_2:setPositionX(var_213_2.first_pos_x or var_213_2:getPositionX())
					var_213_2:setString(T("go"))
				end
				
				var_0_8(arg_213_3)
			end
		end
		
		arg_213_3:setColor(cc.c3b(255, 255, 255))
		arg_213_3:setOpacity(255)
	elseif arg_213_1 == 1 or arg_213_1 == "clear" then
		if_set_visible(arg_213_2, "icon_check", true)
		if_set_color(arg_213_2, "progress", cc.c3b(107, 193, 27))
		if_set_color(arg_213_2, "txt_title", cc.c3b(107, 193, 27))
		var_0_9(arg_213_3)
		
		if not arg_213_4.no_btn_text and get_cocos_refid(var_213_2) then
			var_213_2:setString(T("take_text"))
		end
		
		if get_cocos_refid(var_213_2) then
			arg_213_4.add_x_clear = arg_213_4.add_x_clear or 12
			var_213_2.first_pos_x = var_213_2.first_pos_x or var_213_2:getPositionX()
			
			var_213_2:setPositionX(var_213_2.first_pos_x + arg_213_4.add_x_clear)
		end
		
		arg_213_3:setColor(cc.c3b(255, 255, 255))
		arg_213_3:setOpacity(255)
	elseif arg_213_1 == 2 or arg_213_1 == "received" then
		if_set_visible(arg_213_2, "icon_check", true)
		if_set_color(arg_213_2, "progress", cc.c3b(107, 193, 27))
		if_set_color(arg_213_2, "txt_title", cc.c3b(107, 193, 27))
		var_0_8(arg_213_3)
		
		if not arg_213_4.no_btn_text and get_cocos_refid(var_213_2) then
			var_213_2:setString(T("complete_text"))
		end
	else
		if_set_visible(arg_213_2, "icon_check", false)
		if_set_color(arg_213_2, "progress", cc.c3b(107, 193, 27))
		if_set_color(arg_213_2, "txt_title", cc.c3b(255, 120, 0))
		var_0_8(arg_213_3)
	end
end

function UIUtil.showSubstoryAchievementBalloon(arg_214_0, arg_214_1, arg_214_2)
	local var_214_0 = string.split(string.trim(arg_214_2), "=")
	local var_214_1 = var_214_0[1]
	local var_214_2 = string.trim(var_214_0[2])
	local var_214_3 = string.split(var_214_2, ";")
	local var_214_4 = SubstoryManager:getInfo()
	
	local function var_214_5(arg_215_0, arg_215_1, arg_215_2, arg_215_3)
		arg_214_1:setVisible(true)
		
		local var_215_0 = arg_214_1:findChildByName("talk_bg_count")
		local var_215_1 = var_215_0:findChildByName("txt_disc")
		local var_215_2 = var_215_0:findChildByName("txt_title")
		local var_215_3 = var_215_0:findChildByName("btn_limit")
		
		var_215_0:setVisible(true)
		if_set_visible(arg_214_1, "talk_bg_quest", false)
		if_set_visible(arg_214_1, "talk_bg", false)
		
		local var_215_4 = arg_215_2 or 0
		
		if_set(var_215_2, nil, T(arg_215_0))
		if_set(var_215_1, nil, arg_215_1)
		
		local var_215_5 = (var_215_1:getStringNumLines() - 1) * 20
		
		var_215_2.origin_position_y = var_215_2.origin_position_y or var_215_2:getPositionY()
		
		var_215_2:setPositionY(var_215_2.origin_position_y + var_215_5)
		
		var_215_0.origin_size = var_215_0.origin_size or var_215_0:getContentSize()
		
		local var_215_6 = 0
		
		if (var_215_2:getStringNumLines() or 0) >= 2 then
			var_215_6 = 17
		end
		
		if var_215_3 and not var_215_3.origin_size then
			var_215_3.origin_size = var_215_3:getContentSize()
			
			var_215_3:setContentSize(var_215_3.origin_size.width, var_215_3.origin_size.height + var_215_6)
		end
		
		var_215_0:setContentSize(var_215_0.origin_size.width, var_215_0.origin_size.height + var_215_5 + var_215_6)
		if_set_percent(var_215_0, "pogress_bar", var_215_4 / arg_215_3)
		if_set(var_215_0, "t_percent", var_215_4 .. "/" .. arg_215_3)
		
		return true
	end
	
	if var_214_1 == "festival_misson" and var_214_4 then
		for iter_214_0, iter_214_1 in pairs(var_214_3 or {}) do
			local var_214_6 = Account:getSubStoryFestivalMissionInfo(var_214_4.id, iter_214_1) or {}
			
			if (var_214_6.state or SUBSTORY_FESTIVAL_STATE.INACTIVE) == SUBSTORY_FESTIVAL_STATE.ACTIVE then
				local var_214_7, var_214_8 = DB("substory_festival_mission", iter_214_1, {
					"mission_desc",
					"value"
				})
				local var_214_9 = totable(var_214_8).count
				
				return var_214_5("fm_board_btn", T(var_214_7, {
					count = var_214_9
				}), var_214_6.score or 0, var_214_9)
			end
		end
	end
	
	if var_214_1 == "subachieve" and var_214_4 then
		for iter_214_2, iter_214_3 in pairs(var_214_3 or {}) do
			local var_214_10 = Account:getSubStoryAchievement(iter_214_3) or {
				state = SUBSTORY_ACHIEVE_STATE.ACTIVE
			}
			
			if var_214_10.state == SUBSTORY_ACHIEVE_STATE.ACTIVE then
				local var_214_11, var_214_12, var_214_13, var_214_14 = DB("substory_achievement", iter_214_3, {
					"name",
					"desc",
					"value",
					"unlock_state_id"
				})
				
				if var_214_14 == nil or ConditionContentsState:isClearedByStateID(var_214_14) then
					local var_214_15 = totable(var_214_13).count
					
					return var_214_5(var_214_11, T(var_214_12), var_214_10.score1 or 0, var_214_15)
				end
			end
		end
	end
	
	if var_214_1 == "substory_custom_mission" and var_214_4 then
		for iter_214_4, iter_214_5 in pairs(var_214_3 or {}) do
			if SubStoryCustom:isActiveMission(iter_214_5) then
				local var_214_16, var_214_17, var_214_18, var_214_19, var_214_20 = DB("substory_custom_mission", iter_214_5, {
					"name",
					"desc",
					"value",
					"unlock_state_id",
					"content_type"
				})
				
				if var_214_19 == nil or ConditionContentsState:isClearedByStateID(var_214_19) then
					if var_214_20 == SUBSTORY_CONTENTS_TYPE.INFERENCE then
						var_214_16 = "inference_case_title"
					end
					
					local var_214_21 = totable(var_214_18).count
					local var_214_22 = SubStoryCustom:getMissionInfo(iter_214_5)
					
					return var_214_5(var_214_16, T(var_214_17), var_214_22.score1 or 0, var_214_21)
				end
			end
		end
	end
	
	return false
end

function UIUtil.playUnlockCategoryEffect(arg_216_0, arg_216_1, arg_216_2, arg_216_3, arg_216_4)
	set_high_fps_tick(5000)
	
	local var_216_0 = 0
	local var_216_1 = 100
	local var_216_2 = 2500
	local var_216_3 = ConditionContentsManager:getAchievement()
	local var_216_4 = {}
	
	for iter_216_0, iter_216_1 in pairs(arg_216_1) do
		if get_cocos_refid(iter_216_1.control) then
			local var_216_5 = SceneManager:convertToSceneSpace(iter_216_1.control, {
				x = 0,
				y = 0
			})
			local var_216_6
			
			if iter_216_1.item.is_unlock_eff and not Account:getConfigData(iter_216_1.item.unlock_condition) then
				if var_216_5.y <= 0 then
					local var_216_7 = iter_216_1.item.sort / #arg_216_1
					
					arg_216_2:jumpToPercentVertical(100 * var_216_7)
					
					var_216_6 = var_216_7
					var_216_5 = SceneManager:convertToSceneSpace(iter_216_1.control, {
						x = 0,
						y = 0
					})
				end
				
				table.insert(var_216_4, {
					control = iter_216_1.control,
					item = iter_216_1.item,
					pos = var_216_5,
					move_per = var_216_6
				})
			end
		end
	end
	
	arg_216_2:jumpToPercentVertical(0)
	
	for iter_216_2, iter_216_3 in pairs(var_216_4) do
		if iter_216_3.move_per then
			UIAction:Add(SEQ(DELAY(var_216_1 + var_216_2 * var_216_0), CALL(function()
				arg_216_2:scrollToPercentVertical(100 * iter_216_3.move_per, 2, true)
			end), DELAY(350), CALL(function()
				iter_216_3.control:removeChildByName("_img_lock")
			end), CALL(UIUtil.playCategoryEffect, arg_216_0, iter_216_3.item.unlock_condition, iter_216_3.control, iter_216_3.pos.x + 10, iter_216_3.pos.y, arg_216_3, {
				scale = 0.88
			})), arg_216_0, "block")
		else
			UIAction:Add(SEQ(DELAY(var_216_1 + var_216_2 * var_216_0), CALL(function()
				iter_216_3.control:removeChildByName("_img_lock")
			end), CALL(UIUtil.playCategoryEffect, arg_216_0, iter_216_3.item.unlock_condition, iter_216_3.control, iter_216_3.pos.x + 10, iter_216_3.pos.y, arg_216_3, {
				scale = 0.88
			})), arg_216_0, "block")
		end
		
		var_216_0 = var_216_0 + 1
	end
	
	if var_216_0 > 0 then
		local var_216_8 = ccui.Button:create()
		
		var_216_8:setTouchEnabled(true)
		var_216_8:ignoreContentAdaptWithSize(false)
		var_216_8:setContentSize(DESIGN_WIDTH, DESIGN_HEIGHT)
		var_216_8:setLocalZOrder(999999)
		var_216_8:setPosition(DESIGN_WIDTH / 2, DESIGN_HEIGHT / 2)
		arg_216_3:addChild(var_216_8)
		UIAction:Add(SEQ(DELAY(var_216_1 + var_216_2 * var_216_0), CALL(function()
			arg_216_3:removeChild(var_216_8)
		end), CALL(function()
			SAVE:sendQueryServerConfig()
		end)), arg_216_0, "block")
	end
end

function UIUtil.playCategoryEffect(arg_222_0, arg_222_1, arg_222_2, arg_222_3, arg_222_4, arg_222_5, arg_222_6)
	arg_222_6 = arg_222_6 or {}
	
	local var_222_0 = arg_222_2:convertToWorldSpace({
		x = 0,
		y = 0
	})
	
	EffectManager:Play({
		z = 99998,
		fn = "ui_category_unlock.cfx",
		layer = arg_222_5,
		x = arg_222_3 + arg_222_2:getContentSize().width / 2,
		y = arg_222_4 + arg_222_2:getContentSize().height / 2,
		scale = arg_222_6.scale
	})
	SAVE:setTempConfigData("unlock_eff." .. arg_222_1, true)
end

function UIUtil.setMsgCheckEnterMapErr(arg_223_0, arg_223_1, arg_223_2)
	local var_223_0
	local var_223_1
	
	if arg_223_2.map_ids then
		var_223_0 = T(DB("level_enter", arg_223_2.map_ids[1], "name"))
	end
	
	local var_223_2 = DB("level_enter", arg_223_1, "req_map_msg") and T()
	
	if arg_223_2.substory_time then
		var_223_2 = T("req_prev_time", {
			time = sec_to_full_string(arg_223_2.substory_time[1])
		})
	end
	
	if string.starts(arg_223_1, "wrd_") and var_223_0 then
		var_223_2 = var_223_2 or T("req_prev_map_wrd", {
			enter = var_223_0
		})
	elseif var_223_0 then
		var_223_2 = var_223_2 or T("req_prev_map", {
			enter = var_223_0
		})
	end
	
	if arg_223_2.substory_achieve then
		local var_223_3 = DB("substory_achievement", arg_223_2.substory_achieve[1], "name")
		
		var_223_2 = var_223_2 or T("req_prev_achieve", {
			achieve = T(var_223_3)
		})
	end
	
	if arg_223_2.substory_custom_misison then
		local var_223_4 = DB("substory_custom_mission", arg_223_2.substory_custom_misison[1], "name")
		
		var_223_2 = var_223_2 or T("req_prev_custom_mission", {
			custom_mission = T(var_223_4)
		})
	end
	
	if arg_223_2.substory_quest then
		local var_223_5 = DB("substory_quest", arg_223_2.substory_quest[1], "name")
		
		var_223_2 = var_223_2 or T("req_prev_quest", {
			quest = T(var_223_5)
		})
	end
	
	if arg_223_2.story_view then
		var_223_2 = var_223_2 or T("req_view_story", {
			story_id = T(arg_223_2.story_view[1])
		})
	end
	
	if arg_223_2.subcus then
		var_223_2 = var_223_2 or T("need_token")
	end
	
	var_223_2 = var_223_2 or var_223_2 or "no_msg"
	
	return var_223_2
end

function UIUtil.changeBtnUnlockState(arg_224_0, arg_224_1, arg_224_2, arg_224_3, arg_224_4, arg_224_5)
	arg_224_5 = arg_224_5 or {}
	
	local var_224_0 = 255
	local var_224_1
	
	if not arg_224_3 then
		var_224_0 = var_224_0 * (tonumber(arg_224_5.lock_opacity) or 0.6)
		var_224_1 = SpriteCache:getSprite(arg_224_2 or "img/cm_icon_etclock.png")
		
		var_224_1:setName("_img_lock")
		arg_224_4:addChild(var_224_1)
		
		local var_224_2 = {
			x = 0,
			y = 0
		}
		
		if not arg_224_5.no_world_space then
			var_224_2 = arg_224_1:convertToWorldSpace({
				x = 0,
				y = 0
			})
		end
		
		if arg_224_5 and arg_224_5.variable_scale then
			local var_224_3 = arg_224_1:getContentSize().width / 130
			local var_224_4 = arg_224_1:getContentSize().height / 130
			
			var_224_1:setScaleX(var_224_3 * 1.8)
			var_224_1:setScaleY(var_224_4 * 1.8)
		elseif arg_224_5 and arg_224_5.scale then
			var_224_1:setScale(arg_224_5.scale)
		else
			var_224_1:setScale(1.8)
		end
		
		var_224_1:setPosition(var_224_2.x + arg_224_1:getContentSize().width / 2, var_224_2.y + arg_224_1:getContentSize().height / 2)
		
		if arg_224_5 and arg_224_5.pos_x then
			var_224_1:setPositionX(arg_224_5.pos_x)
		end
		
		if arg_224_5 and arg_224_5.pos_y then
			var_224_1:setPositionY(arg_224_5.pos_y)
		end
		
		if arg_224_5 and arg_224_5.pos_add_x then
			var_224_1:setPositionX(var_224_1:getPositionX() + arg_224_5.pos_add_x)
		end
		
		if arg_224_5 and arg_224_5.pos_add_y then
			var_224_1:setPositionY(var_224_1:getPositionY() + arg_224_5.pos_add_y)
		end
	end
	
	if arg_224_5.opacity_full then
		var_224_0 = 255
	end
	
	arg_224_1:setOpacity(var_224_0)
	
	if arg_224_5 and arg_224_5.z_order then
		var_224_1:setLocalZOrder(arg_224_5.z_order)
	end
	
	return var_224_1
end

function UIUtil.onSceneChange(arg_225_0)
	TutorialGuide:clearGuide()
	Dialog:closeShowRareDrop()
end

function UIUtil.getScreenTransNode(arg_226_0)
	local var_226_0 = cc.Node:create()
	local var_226_1 = cc.Sprite:create("img/_white_s.png")
	
	var_226_1:setColor(cc.c3b(0, 0, 0))
	var_226_1:setScaleX(VIEW_WIDTH / var_226_1:getContentSize().width)
	var_226_1:setScaleY(DESIGN_HEIGHT / var_226_1:getContentSize().height)
	
	local var_226_2 = cc.Sprite:create("img/transscreen_side.png")
	
	var_226_2:setAnchorPoint(1, 0.5)
	var_226_2:setScaleX(VIEW_WIDTH / 2 / var_226_2:getContentSize().width)
	var_226_2:setPosition(-(VIEW_WIDTH / 2), 0)
	var_226_0:addChild(var_226_2)
	
	local var_226_3 = cc.Sprite:create("img/transscreen_side.png")
	
	var_226_3:setAnchorPoint(1, 0.5)
	var_226_3:setPosition(VIEW_WIDTH / 2, 0)
	var_226_3:setScaleX(VIEW_WIDTH / 2 / var_226_3:getContentSize().width)
	var_226_3:setRotation(180)
	var_226_0:addChild(var_226_3)
	var_226_0:addChild(var_226_1)
	var_226_0:setVisible(false)
	
	return var_226_0
end

local var_0_10

function UIUtil.getGradeColor(arg_227_0, arg_227_1, arg_227_2)
	if var_0_10 == nil then
		var_0_10 = {
			cc.c3b(136, 136, 136),
			cc.c3b(94, 158, 59),
			cc.c3b(91, 144, 241),
			cc.c3b(216, 89, 224),
			cc.c3b(254, 69, 49),
			cc.c3b(255, 221, 60)
		}
	end
	
	arg_227_2 = arg_227_2 or (arg_227_1 or {}).grade
	
	if not arg_227_2 then
		return cc.c3b(255, 221, 60)
	end
	
	return var_0_10[arg_227_2]
end

local var_0_11 = 100

function UIUtil.checkUnitInven(arg_228_0, arg_228_1, arg_228_2)
	local var_228_0 = arg_228_2 or {}
	local var_228_1 = table.count(Account.units)
	
	for iter_228_0, iter_228_1 in pairs(Account.units) do
		if iter_228_1:isExpUnit() then
			var_228_1 = var_228_1 - 1
		end
	end
	
	if var_228_0.is_only_repeat and (BattleRepeat:isPlayingRepeatPlay() or BackPlayManager:isRunning()) then
		if var_228_1 + to_n(arg_228_1) < Account:getCurrentHeroCount() + var_0_11 then
			return true
		end
	elseif var_228_1 + to_n(arg_228_1) < Account:getCurrentHeroCount() then
		return true
	end
	
	if var_228_0.no_dialog then
		return false
	end
	
	local var_228_2 = load_dlg("msgbox_sel", true, "wnd")
	
	if not get_cocos_refid(var_228_2) then
		return false
	end
	
	local var_228_3 = SceneManager:getCurrentSceneName() == "battle" and not Battle:isEnded()
	local var_228_4 = var_228_3 and T("too_many_hero_dungeon") or T("too_many_hero")
	
	var_228_2:getChildByName("btn_clean"):setVisible(not var_228_3)
	
	if var_228_3 then
		local var_228_5 = var_228_2:getChildByName("btn_cancel")
		local var_228_6 = var_228_2:getChildByName("btn_expand")
		local var_228_7 = var_228_5:getContentSize().width
		local var_228_8 = var_228_6:getContentSize().width
		local var_228_9 = var_228_2:getContentSize().width / 2
		
		var_228_5:setPositionX(var_228_9 - var_228_7)
		var_228_6:setPositionX(var_228_9)
	end
	
	if_set(var_228_2, "txt_disc", var_228_4)
	
	local var_228_10 = Account:getMaxHeroCount() <= Account:getCurrentHeroCount()
	
	if var_228_10 then
		if_set_opacity(var_228_2, "btn_expand", 76.5)
	end
	
	Dialog:msgBox(var_228_4, {
		yesno = true,
		dlg = var_228_2,
		handler = function(arg_229_0, arg_229_1)
			local var_229_0 = getParentWindow(arg_229_0)
			
			if arg_229_1 == "btn_clean" then
				if SceneManager:getCurrentSceneName() == "battle" and InBattleEsc:isShow() then
					resume()
				end
				
				if UnitMain:isValid() then
					if Postbox:isShow() then
						Postbox:close()
					end
					
					return 
				end
				
				if not (MusicBoxUI:isShow() or SubStoryEntrance:isVisible() or DungeonHome:isVisible()) and UnitMain:isUsablePopupScene(SceneManager:getCurrentSceneName()) then
					UnitMain:beginPopupMode()
					
					return "skip_animation"
				else
					SceneManager:nextScene("unit_ui", {
						mode = "Detail"
					})
				end
			elseif arg_229_1 == "btn_expand" then
				if var_228_10 then
					balloon_message_with_sound("inven_extend_max")
					
					return "dont_close"
				else
					UIUtil:showIncHeroInvenDialog()
				end
			end
		end
	})
	
	return false
end

function UIUtil.checkTotalInven(arg_230_0, arg_230_1)
	if arg_230_0:checkEquipInven(arg_230_1) and arg_230_0:checkArtifactInven(arg_230_1) then
		return true
	end
	
	return false
end

function UIUtil.checkEquipInven(arg_231_0, arg_231_1)
	local var_231_0 = arg_231_1 or {}
	
	if var_231_0.is_only_repeat and (BattleRepeat:isPlayingRepeatPlay() or BackPlayManager:isRunning()) then
		if Account:getFreeEquipCount() < Account:getCurrentEquipCount() + var_0_11 then
			return true
		end
	elseif Account:getFreeEquipCount() < Account:getCurrentEquipCount() then
		return true
	end
	
	if var_231_0.no_dialog then
		return false
	end
	
	local var_231_1 = load_dlg("msgbox_sel", true, "wnd")
	
	if not get_cocos_refid(var_231_1) then
		return false
	end
	
	local var_231_2 = SceneManager:getCurrentSceneName() == "battle" and not Battle:isEnded()
	local var_231_3 = var_231_2 and T("too_many_equip_dungeon") or T("too_many_equip")
	
	if_set(var_231_1, "txt_disc", var_231_3)
	
	local var_231_4 = Account:getMaxEquipCount() <= Account:getCurrentEquipCount()
	
	if var_231_4 then
		if_set_opacity(var_231_1, "btn_expand", 76.5)
	end
	
	var_231_1:getChildByName("btn_clean"):setVisible(not var_231_2)
	
	if var_231_2 then
		local var_231_5 = var_231_1:getChildByName("btn_cancel")
		local var_231_6 = var_231_1:getChildByName("btn_expand")
		local var_231_7 = var_231_5:getContentSize().width
		local var_231_8 = var_231_6:getContentSize().width
		local var_231_9 = var_231_1:getContentSize().width / 2
		
		var_231_5:setPositionX(var_231_9 - var_231_7)
		var_231_6:setPositionX(var_231_9)
	end
	
	Dialog:msgBox(var_231_3, {
		yesno = true,
		dlg = var_231_1,
		handler = function(arg_232_0, arg_232_1)
			local var_232_0 = getParentWindow(arg_232_0)
			
			if arg_232_1 == "btn_clean" then
				if SceneManager:getCurrentSceneName() == "battle" then
					if InBattleEsc:isShow() or PAUSED then
						resume()
					end
					
					ClearResult:backPlayMissionResult(function()
						Inventory:open(nil)
						Inventory:selectMainTab(2)
					end)
				elseif GachaTempInventory:isOpen() or ShopPopupShop:isOpen() then
					Dialog:closeAll()
					Inventory:open(nil)
				else
					Inventory:open(nil)
					Inventory:selectMainTab(2)
				end
			elseif arg_232_1 == "btn_expand" then
				if var_231_4 then
					balloon_message_with_sound("inven_extend_max")
					
					return "dont_close"
				else
					UIUtil:showIncEquipInvenDialog()
				end
			end
		end
	})
	
	return false
end

function UIUtil.checkArtifactInven(arg_234_0, arg_234_1)
	local var_234_0 = arg_234_1 or {}
	
	if var_234_0.is_only_repeat and (BattleRepeat:isPlayingRepeatPlay() or BackPlayManager:isRunning()) then
		if Account:getFreeArtifactCount() < Account:getCurrentArtifactCount() + var_0_11 then
			return true
		end
	elseif Account:getFreeArtifactCount() < Account:getCurrentArtifactCount() then
		return true
	end
	
	if var_234_0.no_dialog then
		return false
	end
	
	local var_234_1 = load_dlg("msgbox_sel", true, "wnd")
	
	if not get_cocos_refid(var_234_1) then
		return false
	end
	
	local var_234_2 = SceneManager:getCurrentSceneName() == "battle" and not Battle:isEnded()
	local var_234_3 = T("too_many_artifact")
	
	if_set(var_234_1, "txt_disc", var_234_3)
	
	local var_234_4 = Account:getMaxArtifactCount() <= Account:getCurrentArtifactCount()
	
	if var_234_4 then
		if_set_opacity(var_234_1, "btn_expand", 76.5)
	end
	
	var_234_1:getChildByName("btn_clean"):setVisible(not var_234_2)
	
	if var_234_2 then
		local var_234_5 = var_234_1:getChildByName("btn_cancel")
		local var_234_6 = var_234_1:getChildByName("btn_expand")
		local var_234_7 = var_234_5:getContentSize().width
		local var_234_8 = var_234_6:getContentSize().width
		local var_234_9 = var_234_1:getContentSize().width / 2
		
		var_234_5:setPositionX(var_234_9 - var_234_7)
		var_234_6:setPositionX(var_234_9)
	end
	
	Dialog:msgBox(var_234_3, {
		yesno = true,
		dlg = var_234_1,
		handler = function(arg_235_0, arg_235_1)
			local var_235_0 = getParentWindow(arg_235_0)
			
			if arg_235_1 == "btn_clean" then
				if SceneManager:getCurrentSceneName() == "battle" then
					if InBattleEsc:isShow() then
						resume()
					end
					
					ClearResult:backPlayMissionResult(function()
						Inventory:open(nil)
						Inventory:selectMainTab(3)
					end)
				elseif GachaTempInventory:isOpen() then
					Dialog:closeAll()
					Inventory:open(nil)
				else
					Inventory:open(nil)
					Inventory:selectMainTab(3)
				end
			elseif arg_235_1 == "btn_expand" then
				if var_234_4 then
					balloon_message_with_sound("inven_extend_max")
					
					return "dont_close"
				else
					UIUtil:showIncArtiEquipInvenDialog()
				end
			end
		end
	})
	
	return false
end

function UIUtil.playNPCSound(arg_237_0, arg_237_1, arg_237_2, arg_237_3)
	local var_237_0 = arg_237_0:getNPCBallonMaxTextId(arg_237_1)
	
	for iter_237_0 = 1, var_237_0 + 1 do
		local var_237_1 = math.random(1, var_237_0)
		local var_237_2, var_237_3 = DB("npc_balloon", arg_237_1, {
			"sound_effect_" .. var_237_1,
			"text_id_" .. var_237_1
		})
		
		if var_237_2 then
			print("sound, id?", var_237_2, var_237_1)
			
			if arg_237_3 then
				UIAction:Add(SEQ(DELAY(arg_237_2 or 0), CALL(function()
					local var_238_0 = SoundEngine:play("event:/" .. var_237_2)
					
					arg_237_3(var_238_0)
				end)), arg_237_0)
			else
				UIAction:Add(SEQ(DELAY(arg_237_2 or 0), SOUND("event:/" .. var_237_2)), arg_237_0)
			end
			
			return var_237_3
		end
		
		if var_237_3 then
			return var_237_3
		end
	end
end

UIUtil.NPC_BALLON_MAX_TEXT_ID_COUNT = 6

function UIUtil.getNPCBallonMaxTextId(arg_239_0, arg_239_1)
	local var_239_0 = 4
	
	for iter_239_0 = 1, arg_239_0.NPC_BALLON_MAX_TEXT_ID_COUNT do
		if DB("npc_balloon", arg_239_1, "text_id_" .. iter_239_0) then
			var_239_0 = iter_239_0
		else
			break
		end
	end
	
	return var_239_0
end

function UIUtil.getNPCText(arg_240_0, arg_240_1)
	local var_240_0 = arg_240_0:getNPCBallonMaxTextId(arg_240_1)
	
	for iter_240_0 = 1, var_240_0 + 1 do
		local var_240_1 = math.random(1, var_240_0)
		local var_240_2 = DB("npc_balloon", arg_240_1, "text_id_" .. var_240_1)
		
		if var_240_2 then
			return var_240_2
		end
	end
end

function UIUtil.playNPCSoundRandomly(arg_241_0, arg_241_1, arg_241_2)
	print("sound playing: ", arg_241_1)
	
	arg_241_2 = arg_241_2 or 0
	
	local var_241_0 = arg_241_0:getNPCBallonMaxTextId(arg_241_1)
	local var_241_1 = math.random(1, var_241_0)
	local var_241_2 = DB("npc_balloon", arg_241_1, {
		"sound_effect_" .. var_241_1
	})
	
	if var_241_2 then
		UIAction:Add(SEQ(DELAY(arg_241_2), SOUND("event:/" .. var_241_2)), arg_241_0)
	end
end

function UIUtil.setPortraitFace(arg_242_0, arg_242_1, arg_242_2)
	if arg_242_1 and get_cocos_refid(arg_242_1) and arg_242_1.is_model and arg_242_2 then
		local var_242_0 = StoryFace:getFaceAni(arg_242_2)
		
		if var_242_0 then
			arg_242_1:setSkin(var_242_0)
		end
	end
end

function UIUtil.playNPCSoundAndTextCustom(arg_243_0, arg_243_1, arg_243_2, arg_243_3, arg_243_4, arg_243_5)
	arg_243_4 = arg_243_4 or 0
	
	local var_243_0 = {}
	local var_243_1
	
	for iter_243_0 = 1, arg_243_0.NPC_BALLON_MAX_TEXT_ID_COUNT do
		local var_243_2, var_243_3, var_243_4 = DB("npc_balloon", arg_243_1, {
			"sound_effect_" .. iter_243_0,
			"text_id_" .. iter_243_0,
			"face_" .. iter_243_0
		})
		
		if var_243_3 then
			table.insert(var_243_0, {
				sound = var_243_2,
				text = var_243_3,
				face = var_243_4
			})
		end
	end
	
	local var_243_5 = table.count(var_243_0)
	
	if var_243_5 > 0 then
		local var_243_6 = var_243_0[math.random(1, var_243_5)]
	end
	
	var_0_1 = 1
	
	local var_243_7 = var_243_0[var_0_1]
	
	if not var_243_7 then
		if not PRODUCTION_MODE then
			balloon_message_with_sound("npc_balloon 테이블의 " .. arg_243_1 .. " 에 해당하는 text_id 를 찾지못했습니다.")
		end
		
		return 
	end
	
	UIAction:Remove("NPC_TEXT_CUSTOM_IN")
	arg_243_0:playNPCIdleBallonTextCustom(arg_243_1, arg_243_2, arg_243_3, var_243_5, arg_243_5)
	
	if var_243_7.sound then
		UIAction:Add(SEQ(DELAY(arg_243_4), SOUND("event:/" .. var_243_7.sound)), arg_243_0)
	end
end

function UIUtil.showBalloonInSpineIllust(arg_244_0, arg_244_1, arg_244_2, arg_244_3, arg_244_4, arg_244_5, arg_244_6, arg_244_7)
	local var_244_0 = arg_244_1:getChildByName("txt_balloon")
	local var_244_1 = arg_244_1:getChildByName("balloon_bg")
	local var_244_2 = 1
	local var_244_3 = arg_244_4 or 0
	
	if arg_244_6 then
		arg_244_2 = UIUtil:playNPCSound(arg_244_2, var_244_3, arg_244_7)
	else
		arg_244_2 = UIUtil:getNPCText(arg_244_2)
	end
	
	if not arg_244_2 then
		return 
	end
	
	arg_244_2 = T(arg_244_2)
	
	UIUserData:call(var_244_1, "AUTOSIZE_HEIGHT(../txt_balloon, 1, 80)")
	UIUtil:updateTextWrapMode(var_244_0, arg_244_2, 20)
	if_set(var_244_0, nil, "")
	
	local var_244_4 = 3000
	
	arg_244_5 = arg_244_5 or 0
	
	arg_244_1:setScale(0)
	arg_244_1:setOpacity(255)
	UIAction:Add(SEQ(DELAY(var_244_3), LOG(SCALE(150, 0, var_244_2 * 1.1)), DELAY(50), RLOG(SCALE(80, var_244_2 * 1.1, var_244_2)), TARGET(var_244_0, SOUND_TEXT(arg_244_2, true)), DELAY(var_244_4), FADE_OUT(300), DELAY(arg_244_5)), arg_244_1, arg_244_3)
end

function UIUtil.playNPCSoundAndTextRandomly(arg_245_0, arg_245_1, arg_245_2, arg_245_3, arg_245_4, arg_245_5, arg_245_6)
	arg_245_4 = arg_245_4 or 0
	
	local var_245_0 = {}
	local var_245_1
	
	for iter_245_0 = 1, arg_245_0.NPC_BALLON_MAX_TEXT_ID_COUNT do
		local var_245_2, var_245_3, var_245_4 = DB("npc_balloon", arg_245_1, {
			"sound_effect_" .. iter_245_0,
			"text_id_" .. iter_245_0,
			"face_" .. iter_245_0
		})
		
		if var_245_3 then
			table.insert(var_245_0, {
				sound = var_245_2,
				text = var_245_3,
				face = var_245_4
			})
		end
	end
	
	local var_245_5 = table.count(var_245_0)
	
	if var_245_5 > 0 then
		var_245_1 = var_245_0[math.random(1, var_245_5)]
	end
	
	if not var_245_1 then
		if not PRODUCTION_MODE then
			balloon_message_with_sound("npc_balloon 테이블의 " .. arg_245_1 .. " 에 해당하는 text_id 를 찾지못했습니다.")
		end
		
		return 
	end
	
	if var_0_0 then
		UIAction:Add(SEQ(CALL(function()
			UIAction:Remove("BALLOON_ANIMATION")
			UIAction:Remove("BALLOON_IDLE_ANIMATION")
			
			var_0_0 = false
		end), SCALE_TO(300, 0), CALL(function()
			UIAction:Add(SEQ(SPAWN(CALL(function()
				if_set(arg_245_2, arg_245_3, T(var_245_1.text))
				
				var_0_0 = true
			end), CALL(function()
				arg_245_0:setPortraitFace(arg_245_6, var_245_1.face)
			end)), SCALE_TO(175, 1), DELAY(4000), CALL(function()
				var_0_0 = false
			end), SCALE_TO(175, 0), CALL(function()
				if arg_245_5 then
					arg_245_0:playNPCIdleBallonText(arg_245_5, arg_245_2, var_245_5, arg_245_3, nil, arg_245_6)
				end
			end)), arg_245_2:getChildByName(arg_245_3):getParent(), "BALLOON_ANIMATION")
		end)), arg_245_2:getChildByName(arg_245_3):getParent())
	else
		UIAction:Remove("BALLOON_IDLE_ANIMATION")
		UIAction:Add(SEQ(SPAWN(CALL(function()
			if_set(arg_245_2, arg_245_3, T(var_245_1.text))
			
			var_0_0 = true
		end), CALL(function()
			arg_245_0:setPortraitFace(arg_245_6, var_245_1.face)
		end)), SCALE_TO(175, 1), DELAY(4000), CALL(function()
			var_0_0 = false
		end), SCALE_TO(175, 0), CALL(function()
			if arg_245_5 then
				arg_245_0:playNPCIdleBallonText(arg_245_5, arg_245_2, var_245_5, arg_245_3, nil, arg_245_6)
			end
		end)), arg_245_2:getChildByName(arg_245_3):getParent(), "BALLOON_ANIMATION")
	end
	
	if var_245_1.sound then
		UIAction:Add(SEQ(DELAY(arg_245_4), SOUND("event:/" .. var_245_1.sound)), arg_245_0)
	end
end

function UIUtil.playNPCIdleBallonTextCustom(arg_256_0, arg_256_1, arg_256_2, arg_256_3, arg_256_4, arg_256_5)
	if not arg_256_1 or not get_cocos_refid(arg_256_2) or not get_cocos_refid(arg_256_3) then
		return 
	end
	
	local var_256_0 = arg_256_2
	local var_256_1 = arg_256_3
	local var_256_2 = var_256_0:getParent()
	local var_256_3 = var_256_0.origin_y or var_256_0:getPositionY()
	local var_256_4 = var_256_2:getContentSize().height
	local var_256_5 = 600
	local var_256_6 = 10000
	
	if not var_256_0.origin_y then
		var_256_0.origin_y = var_256_0:getPositionY()
	end
	
	var_256_0:setPositionY(var_256_3)
	var_256_1:setPositionY(var_256_3 - var_256_4)
	
	local function var_256_7(arg_257_0)
		if not get_cocos_refid(arg_257_0) then
			return 
		end
		
		UIAction:Remove(arg_257_0:getName() .. "move_up")
		UIAction:Add(MOVE_TO(var_256_5, nil, arg_257_0:getPositionY() + var_256_4), arg_257_0, arg_257_0:getName() .. "move_up")
	end
	
	local function var_256_8(arg_258_0)
		if not get_cocos_refid(arg_258_0) then
			return 
		end
		
		local var_258_0 = arg_256_0:getNPCBallonMaxTextId(arg_256_1)
		local var_258_1 = math.random(1, arg_256_4 or var_258_0)
		
		if var_0_1 then
			var_258_1 = var_0_1
			var_0_1 = var_0_1 + 1
			
			if var_0_1 > arg_256_4 then
				var_0_1 = 1
			end
		end
		
		local var_258_2, var_258_3, var_258_4 = DB("npc_balloon", arg_256_1, {
			"sound_effect_" .. var_258_1,
			"text_id_" .. var_258_1,
			"face_" .. var_258_1
		})
		
		if_set(arg_258_0, nil, T(var_258_3))
	end
	
	var_256_8(var_256_0)
	
	local var_256_9 = 0
	
	UIAction:Add(SEQ(LOOP(SEQ(DELAY(var_256_6), CALL(function()
		if var_256_9 >= 1 then
			var_256_0:setPositionY(var_256_3 - var_256_4)
			var_256_1:setPositionY(var_256_3)
			
			local var_259_0
			
			var_256_1, var_256_0 = var_256_0, var_256_1
		end
		
		var_256_7(var_256_0)
		var_256_7(var_256_1)
		var_256_8(var_256_1)
	end), DELAY(var_256_5 + 1000), CALL(function()
		var_256_9 = var_256_9 + 1
	end)))), var_256_2, "NPC_TEXT_CUSTOM_IN")
end

function UIUtil.playNPCIdleBallonText(arg_261_0, arg_261_1, arg_261_2, arg_261_3, arg_261_4, arg_261_5, arg_261_6)
	arg_261_5 = arg_261_5 or 0
	
	local var_261_0 = arg_261_0:getNPCBallonMaxTextId(arg_261_1)
	local var_261_1 = math.random(1, arg_261_3 or var_261_0)
	local var_261_2, var_261_3, var_261_4 = DB("npc_balloon", arg_261_1, {
		"sound_effect_" .. var_261_1,
		"text_id_" .. var_261_1,
		"face_" .. var_261_1
	})
	
	if not var_0_0 then
		UIAction:Add(SEQ(DELAY(10000), SPAWN(CALL(function()
			if_set(arg_261_2, arg_261_4, T(var_261_3))
			
			if var_261_2 then
				UIAction:Add(SEQ(DELAY(arg_261_5), SOUND("event:/" .. var_261_2)), arg_261_0)
			end
			
			var_0_0 = true
		end), CALL(function()
			arg_261_0:setPortraitFace(arg_261_6, var_261_4)
		end)), SCALE_TO(175, 1), DELAY(4000), CALL(function()
			var_0_0 = false
		end), SCALE_TO(175, 0), CALL(function()
			arg_261_0:playNPCIdleBallonText(arg_261_1, arg_261_2, arg_261_3, arg_261_4, arg_261_5, arg_261_6)
		end)), arg_261_2:getChildByName(arg_261_4):getParent(), "BALLOON_IDLE_ANIMATION")
	end
end

function UIUtil.IsNight(arg_266_0)
	if DEBUG.DAYTIME then
		return false
	end
	
	if DEBUG.NIGHTTIME then
		return true
	end
	
	local var_266_0 = os.date("*t").hour
	
	return var_266_0 >= 19 or var_266_0 < 6
end

function UIUtil.setScrollViewText(arg_267_0, arg_267_1, arg_267_2, arg_267_3)
	return set_scrollview_text(arg_267_1, arg_267_2, true, arg_267_3)
end

function UIUtil.resetImageNumber(arg_268_0, arg_268_1, arg_268_2, arg_268_3)
	arg_268_1:removeAllChildren()
	
	arg_268_2 = tostring(arg_268_2)
	arg_268_2 = string.gsub(arg_268_2, ",", "")
	
	local var_268_0 = string.len(arg_268_2)
	local var_268_1 = 0
	
	if arg_268_3 and arg_268_3.align == "center" then
		var_268_1 = 0 - 9 * var_268_0 / 2 - 3
	elseif arg_268_3 and arg_268_3.align == "right" then
		var_268_1 = 9 * var_268_0 / 2 + 3
	end
	
	for iter_268_0 = 1, var_268_0 do
		local var_268_2 = string.sub(arg_268_2, iter_268_0, iter_268_0)
		
		if var_268_2 == "+" then
			var_268_2 = "plus"
		end
		
		if var_268_2 == "%" then
			var_268_2 = "percent"
		end
		
		local var_268_3 = SpriteCache:getSprite("img/itxt_num" .. var_268_2 .. ".png")
		
		if var_268_3 then
			var_268_3:setAnchorPoint(0, 0.5)
			var_268_3:setPositionX(var_268_1 + (iter_268_0 - 1) * 9)
			arg_268_1:addChild(var_268_3)
		end
	end
end

function UIUtil.resetPositionSeqLabels(arg_269_0, arg_269_1, arg_269_2, arg_269_3, arg_269_4)
	arg_269_4 = arg_269_4 or 0
	
	local var_269_0 = arg_269_1:getChildByName(arg_269_2)
	local var_269_1 = arg_269_1:getChildByName(arg_269_3)
	
	if not var_269_0 or not var_269_1 then
		return 
	end
	
	local var_269_2, var_269_3 = var_269_0:getPosition()
	local var_269_4 = var_269_0:getContentSize()
	
	var_269_1:setPositionX(var_269_2 + var_269_4.width * var_269_0:getScaleX() + arg_269_4)
end

function UIUtil.playEquipSetEffect(arg_270_0, arg_270_1, arg_270_2, arg_270_3)
	if not arg_270_3.set_fx then
		return 
	end
	
	local function var_270_0(arg_271_0, arg_271_1, arg_271_2)
		local var_271_0 = arg_271_1:getEquipPositionIndex()
		local var_271_1 = arg_271_0:getChildByName("n_item" .. var_271_0)
		
		EffectManager:Play({
			fn = arg_271_2,
			layer = var_271_1
		})
	end
	
	local var_270_1 = arg_270_3:getSetItemTotalCount()
	local var_270_2 = {}
	
	for iter_270_0, iter_270_1 in pairs(arg_270_2.equips) do
		if iter_270_1 ~= arg_270_3 and iter_270_1.set_fx == arg_270_3.set_fx then
			var_270_2[#var_270_2 + 1] = iter_270_1
			
			if #var_270_2 == var_270_1 then
				var_270_2 = {}
			end
		end
	end
	
	var_270_2[#var_270_2 + 1] = arg_270_3
	
	if var_270_1 <= #var_270_2 then
		for iter_270_2, iter_270_3 in pairs(var_270_2) do
			UIAction:Add(SEQ(DELAY(200), CALL(var_270_0, arg_270_1, iter_270_3, "ui_itemset_eff_on.cfx")), arg_270_0, "block")
		end
	end
end

function UIUtil.slideOpen(arg_272_0, arg_272_1, arg_272_2, arg_272_3, arg_272_4, arg_272_5, arg_272_6)
	local var_272_0, var_272_1 = arg_272_2:getPosition()
	local var_272_2 = var_272_1
	local var_272_3
	local var_272_4 = NONE()
	local var_272_5 = arg_272_4 and -VIEW_HEIGHT or VIEW_HEIGHT
	
	if arg_272_3 then
		arg_272_1:setOpacity(0)
		
		var_272_3 = FADE_IN(arg_272_5 or 250)
		var_272_2 = var_272_1
		
		arg_272_2:setPositionY(var_272_1 + var_272_5)
	else
		var_272_3 = FADE_OUT(arg_272_5 or 250)
		var_272_4 = REMOVE()
		var_272_2 = var_272_1 + var_272_5
		
		SoundEngine:play("event:/ui/top_bar/quick_menu_off")
	end
	
	UIAction:Add(SEQ(SPAWN(var_272_3, TARGET(arg_272_2, SPAWN(LOG(MOVE_TO(250, var_272_0, var_272_2))))), var_272_4, arg_272_6), arg_272_1, "block")
end

function UIUtil.playExpNumber(arg_273_0, arg_273_1)
	local var_273_0 = arg_273_1.layer
	
	if arg_273_1.child then
		var_273_0 = var_273_0:getChildByName(arg_273_1.child)
	end
	
	local var_273_1 = var_273_0:getChildByName("exp_eff")
	
	if not get_cocos_refid(var_273_1) then
		var_273_1 = cc.CSLoader:createNode("wnd/exp_eff.csb")
		
		var_273_1:setName("exp_eff")
		arg_273_1.layer:addChild(var_273_1)
	end
	
	var_273_1:setPosition(to_n(arg_273_1.x), to_n(arg_273_1.y))
	
	local var_273_2 = to_n(arg_273_1.delay)
	
	var_273_1:setVisible(false)
	
	arg_273_1.dist_exp = math.floor(arg_273_1.dist_exp or 0) or 0
	
	local var_273_3 = NONE()
	local var_273_4 = ""
	
	if arg_273_1.dist_exp > 0 then
		var_273_4 = "dist_exp"
		
		if arg_273_1.exp_under_line then
			var_273_4 = "dist_exp_result"
		end
		
		var_273_3 = LOG(TARGET(var_273_1:getChildByName(var_273_4), INC_NUMBER(arg_273_1.tm or 800, arg_273_1.dist_exp, nil, 0)))
	end
	
	if_set_visible(var_273_1, "dist_exp", var_273_4 == "dist_exp")
	if_set_visible(var_273_1, "dist_exp_result", var_273_4 == "dist_exp_result")
	
	if arg_273_1.dist_exp > 0 then
		local var_273_5 = var_273_1:getChildByName(var_273_4)
		
		if get_cocos_refid(var_273_5) then
			if_set(var_273_1, var_273_4, arg_273_1.dist_exp)
			if_set(var_273_1, "add_exp", math.floor(arg_273_1.add_exp))
			
			local var_273_6 = var_273_1:getChildByName("add_exp")
			
			if get_cocos_refid(var_273_6) and var_273_4 == "dist_exp" then
				local var_273_7 = var_273_6:getScaleX() * var_273_0:getScaleX()
				
				var_273_5:setPositionX(var_273_6:getContentSize().width * var_273_7 + var_273_6:getPositionX() + 16)
			end
		end
	end
	
	UIAction:Add(SEQ(DELAY(var_273_2), SHOW(true), SPAWN(LOG(TARGET(var_273_1:getChildByName("add_exp"), INC_NUMBER(arg_273_1.tm or 800, arg_273_1.add_exp, nil, arg_273_1.from_exp))), var_273_3)), var_273_1)
end

function UIUtil.closePopupModes(arg_274_0, arg_274_1)
	local var_274_0 = (arg_274_1 or {}).caller
	
	if MusicBoxUI:isShow() then
		MusicBoxUI:close()
	end
	
	if SceneManager:getCurrentSceneName() == "lobby" and (Lobby:isBartenderMode() or Lobby:isGuerrillaMode()) then
		Lobby:toggleBartenderMode(true)
	end
	
	if Bistro:isVisible() then
		Bistro:close()
	end
	
	if Destiny:isVisible() then
		Destiny:close(true)
	end
	
	if DungeonHome:isVisible() then
		DungeonHome:close()
	end
	
	if SeasonPassBase:isVisible() then
		SeasonPassBase:close()
	end
	
	if SubStoryEntrance:isVisible() and (not var_274_0 or var_274_0 ~= "btn_setting") then
		SubStoryEntrance:setBackType("close")
		SubStoryEntrance:setForceBackLobby(nil)
		SubStoryEntrance:close()
	end
	
	if CustomLobbySettingMain.UI:isActive() then
		CustomLobbySettingMain:onButtonClose()
	end
	
	if CustomLobbySettingMain.Illust:isActive() then
		CustomLobbySettingMain.Illust:onButtonClose()
	end
	
	if CustomLobbyChoose:isActive() then
		CustomLobbyChoose:close()
	end
end

function UIUtil.hideChilds(arg_275_0, arg_275_1, arg_275_2)
	arg_275_2 = arg_275_2 or {}
	
	local var_275_0 = arg_275_1:getChildren()
	local var_275_1 = {}
	
	for iter_275_0, iter_275_1 in pairs(var_275_0) do
		if iter_275_1:isVisible(true) and not table.find(arg_275_2, iter_275_1) then
			table.push(var_275_1, iter_275_1)
			iter_275_1:setVisible(false)
		end
	end
	
	return var_275_1
end

function UIUtil.showChilds(arg_276_0, arg_276_1)
	if arg_276_1 then
		for iter_276_0, iter_276_1 in pairs(arg_276_1) do
			if get_cocos_refid(iter_276_1) then
				iter_276_1:setVisible(true)
			end
		end
	end
end

function UIUtil.getTextWidthAndPos(arg_277_0, arg_277_1, arg_277_2)
	if arg_277_2 then
		arg_277_1 = arg_277_1:getChildByName(arg_277_2)
	end
	
	return arg_277_1:getContentSize().width * arg_277_1:getScaleX(), arg_277_1:getPositionX()
end

function UIUtil.alignControl(arg_278_0, arg_278_1, arg_278_2, arg_278_3, arg_278_4)
	arg_278_4 = arg_278_4 or 10
	
	local var_278_0, var_278_1 = arg_278_0:getTextWidthAndPos(arg_278_1, arg_278_2)
	
	if_call(arg_278_1, arg_278_3, "setPositionX", arg_278_4 + var_278_0 + var_278_1)
	
	return var_278_0, var_278_1
end

function UIUtil.setModal(arg_279_0, arg_279_1)
	local var_279_0 = ccui.Button:create()
	
	var_279_0:setTouchEnabled(true)
	var_279_0:ignoreContentAdaptWithSize(false)
	var_279_0:setLocalZOrder(-1)
	var_279_0:setContentSize(arg_279_1:getContentSize())
	var_279_0:setAnchorPoint(0, 0)
	var_279_0:setPosition(0, 0)
	arg_279_1:addChild(var_279_0)
end

local function var_0_12(arg_280_0, arg_280_1, arg_280_2)
	arg_280_2 = arg_280_2 or {}
	
	local var_280_0 = math.max(0, arg_280_1 - os.time())
	
	if arg_280_2.on_update then
		arg_280_2.on_update(arg_280_0, var_280_0)
	end
	
	if var_280_0 == 0 and arg_280_2.on_finish then
		arg_280_2.on_finish(arg_280_0)
	end
end

function UIUtil.stopAutoCounter(arg_281_0, arg_281_1)
	if arg_281_1._auto_counter_tag then
		Scheduler:remove(arg_281_1._auto_counter_tag)
	end
end

function UIUtil.startAutoCounter(arg_282_0, arg_282_1, arg_282_2, arg_282_3)
	if arg_282_1._auto_counter_tag then
		Scheduler:remove(arg_282_1._auto_counter_tag)
	end
	
	arg_282_1._auto_counter_tag = Scheduler:addSlow(arg_282_1, var_0_12, arg_282_1, arg_282_2, arg_282_3)
end

function UIUtil.checkCurrencyDialog(arg_283_0, arg_283_1, arg_283_2, arg_283_3)
	arg_283_3 = arg_283_3 or {}
	
	if string.starts(arg_283_1, "to_") then
		arg_283_1 = string.sub(arg_283_1, 4, -1)
	end
	
	local var_283_0
	
	if Account:isCurrencyType(arg_283_1) then
		var_283_0 = Account:getCurrency(arg_283_1)
	elseif Account:isMaterialCurrencyType(arg_283_1) then
		var_283_0 = Account:getItemCount(arg_283_1)
	end
	
	if arg_283_2 and var_283_0 and arg_283_2 <= var_283_0 then
		return true
	end
	
	if not Shop:getTokenCategory(arg_283_1) then
		if DB("item_material", arg_283_1, "ma_type") == "cp" then
			Dialog:msgBox(T("no_" .. arg_283_1 .. ".desc"), {
				title = T("buy.no_ma_cp.title")
			})
		else
			balloon_message_with_sound("need_token")
		end
		
		return 
	end
	
	local var_283_1 = T(DB("item_token", "to_" .. arg_283_1, "name"))
	local var_283_2 = "buy_stamina_title"
	local var_283_3 = "buy_token_desc2"
	
	if arg_283_3.is_battle_go then
		var_283_2 = "lack_token"
		var_283_3 = "buy_token_desc"
	end
	
	if arg_283_1 == "ticketspecial" then
		var_283_3 = "get_ticketspecial_desc"
	elseif arg_283_1 == "ticketwind35" or arg_283_1 == "ticketfire35" or arg_283_1 == "ticketice35" or arg_283_1 == "ticketwind45" or arg_283_1 == "ticketfire45" or arg_283_1 == "ticketice45" then
		local var_283_4 = DB("item_token", "to_" .. arg_283_1, {
			"name"
		})
		
		var_283_3 = "get_ticketattribute_desc"
	end
	
	local var_283_5 = Dialog:msgBox(PROC_KR(T(var_283_3, {
		token = var_283_1
	})), {
		yesno = true,
		title = T(var_283_2, {
			token = var_283_1
		}),
		dlg = load_dlg("shop_nocurrency", true, "wnd"),
		handler = function()
			SanctuaryCraftUpgrade:onLeave()
			UnitEquipUpgrade:close()
			InventoryPopupDetail:Close()
			Inventory:close()
			
			if arg_283_1 == "ticketwind35" or arg_283_1 == "ticketfire35" or arg_283_1 == "ticketice35" or arg_283_1 == "ticketwind45" or arg_283_1 == "ticketfire45" or arg_283_1 == "ticketice45" then
				UnlockSystem:isUnlockSystemAndMsg({
					exclude_story = true,
					id = UNLOCK_ID.CLAN
				}, function()
					SceneManager:nextScene("clan")
					SoundEngine:play("event:/ui/whoosh_a")
				end)
			else
				Shop:openTokenShop(arg_283_1, arg_283_3)
			end
		end
	})
	
	if arg_283_1 == "ticketspecial" then
		if_set(var_283_5, "txt_shop_comment", T("get_ticketspecial_desc2"))
	elseif arg_283_1 == "ticketwind35" or arg_283_1 == "ticketfire35" or arg_283_1 == "ticketice35" or arg_283_1 == "ticketwind45" or arg_283_1 == "ticketfire45" or arg_283_1 == "ticketice45" then
		if_set(var_283_5, "txt_shop_comment", T("get_ticketattribute_desc2"))
	end
	
	UIUtil:getRewardIcon(nil, "to_" .. arg_283_1, {
		show_name = true,
		parent = var_283_5.c.n_item_pos
	})
end

local var_0_13 = {
	{
		32,
		32,
		false
	},
	{
		48,
		57,
		true
	},
	{
		33,
		64,
		false
	},
	{
		91,
		96,
		false
	},
	{
		123,
		126,
		false
	},
	{
		65,
		90,
		true
	},
	{
		97,
		122,
		true
	},
	{
		192,
		214,
		true
	},
	{
		215,
		215,
		false
	},
	{
		216,
		246,
		true
	},
	{
		247,
		247,
		false
	},
	{
		248,
		255,
		true
	},
	{
		256,
		591,
		true
	},
	{
		12352,
		12447,
		true
	},
	{
		12448,
		12543,
		true
	},
	{
		13312,
		19903,
		true
	},
	{
		19968,
		40959,
		true
	},
	{
		3584,
		3711,
		true
	},
	{
		44032,
		55215,
		true
	},
	{
		12592,
		12687,
		false
	},
	{
		65040,
		65276,
		false
	},
	{
		65281,
		65504,
		false
	}
}

_allow_char_codes = {}

function _allow_char_codes.allow_ascii(arg_286_0)
	return arg_286_0 >= 32 and arg_286_0 <= 126
end

function _allow_char_codes.allow_jamo(arg_287_0)
	return arg_287_0 >= 12592 and arg_287_0 <= 12687
end

function UIUtil.getInvalidCharacter(arg_288_0, arg_288_1, arg_288_2, arg_288_3)
	arg_288_3 = arg_288_3 or {}
	
	local var_288_0
	
	for iter_288_0 in arg_288_1:gmatch("[%z\x01-\x7F\xC2-\xF4][\x80-\xBF]*") do
		local var_288_1 = utf8codepoint(iter_288_0)
		local var_288_2
		
		for iter_288_1, iter_288_2 in pairs(var_0_13) do
			if arg_288_3.allow_ascii and _allow_char_codes.allow_ascii(var_288_1) then
				var_288_2 = true
				
				break
			end
			
			if arg_288_3.allow_jamo and _allow_char_codes.allow_jamo(var_288_1) then
				var_288_2 = true
				
				break
			end
			
			if var_288_1 >= iter_288_2[1] and var_288_1 <= iter_288_2[2] then
				var_288_2 = arg_288_2 or iter_288_2[3]
				
				break
			end
		end
		
		if not var_288_2 then
			return iter_288_0, var_288_1
		end
	end
end

function UIUtil.checkInvalidCharacter(arg_289_0, arg_289_1, arg_289_2, arg_289_3)
	arg_289_3 = arg_289_3 or {}
	
	local var_289_0, var_289_1 = UIUtil:getInvalidCharacter(arg_289_1, arg_289_2, arg_289_3)
	
	if var_289_0 then
		if arg_289_3.msgbox then
			Dialog:msgBox(T("cant_use_character"), {
				title = T("invalid_character")
			})
		else
			balloon_message_with_sound("invalid_input_word")
		end
		
		return true
	end
end

function UIUtil.translateServerText(arg_290_0, arg_290_1)
	local function var_290_0(arg_291_0)
		arg_291_0 = arg_291_0 or ""
		
		if string.starts(arg_291_0, "TID@@") then
			local var_291_0 = string.split(arg_291_0, "@@")
			
			if #var_291_0 > 2 then
				arg_291_0 = var_291_0[2]
				
				table.remove(var_291_0, 1)
				table.remove(var_291_0, 1)
				
				local var_291_1 = {}
				
				for iter_291_0, iter_291_1 in pairs(var_291_0) do
					local var_291_2 = string.split(iter_291_1, "=")
					
					if string.starts(var_291_2[2], "'") and string.ends(var_291_2[2], "'") then
						var_291_1[var_291_2[1]] = string.sub(var_291_2[2], 2, -2)
					else
						var_291_1[var_291_2[1]] = T(var_291_2[2])
					end
				end
				
				arg_291_0 = T(arg_291_0, var_291_1)
			end
		else
			arg_291_0 = T(arg_291_0)
		end
		
		return arg_291_0
	end
	
	arg_290_1 = arg_290_0:translateByLang(arg_290_1)
	
	return var_290_0(arg_290_1)
end

function UIUtil.getUserLanguageValue(arg_292_0, arg_292_1)
	if not arg_292_1 then
		return ""
	end
	
	if type(arg_292_1) ~= "table" then
		return ""
	end
	
	local var_292_0 = getUserLanguage()
	local var_292_1 = getenv("app.pubid")
	
	if var_292_1 then
		local var_292_2 = var_292_0 .. "_" .. var_292_1 or ""
		
		if arg_292_1[var_292_2] then
			return arg_292_1[var_292_2]
		end
	end
	
	if arg_292_1[var_292_0] then
		return arg_292_1[var_292_0]
	end
	
	return ""
end

function UIUtil.translateByLang(arg_293_0, arg_293_1)
	if string.empty(arg_293_1) then
		return ""
	end
	
	arg_293_1 = string.trim(arg_293_1)
	
	if string.match(arg_293_1, "^%d+[^%d]+") then
		return arg_293_1
	end
	
	local var_293_0 = json.decode(arg_293_1)
	
	if not var_293_0 then
		return arg_293_1
	end
	
	return arg_293_0:getUserLanguageValue(var_293_0)
end

function UIUtil.wannaBuyStamina(arg_294_0, arg_294_1)
	local var_294_0 = GAME_STATIC_VARIABLE.buy_stamina_cost or 10
	local var_294_1 = GAME_STATIC_VARIABLE.buy_stamina_count or 60
	local var_294_2 = GAME_STATIC_VARIABLE.buy_stamina_id or "currency_4"
	local var_294_3 = GAME_STATIC_VARIABLE.buy_stamina_cost_light or 1
	local var_294_4 = GAME_STATIC_VARIABLE.buy_stamina_count_light or 70
	local var_294_5 = GAME_STATIC_VARIABLE.buy_stamina_id_light or "currency_9"
	local var_294_6 = Account:getCurrency("crystal") or 0
	local var_294_7 = Account:getCurrency("light") or 0
	
	if not GAME_STATIC_VARIABLE.buy_stamina_cost then
		local var_294_8 = 10
	end
	
	if not GAME_STATIC_VARIABLE.buy_stamina_count then
		local var_294_9 = 60
	end
	
	if var_294_6 < var_294_0 and var_294_7 < var_294_3 then
		if arg_294_1 and arg_294_1 == "battle.ready" then
			if not UIUtil:checkCurrencyDialog("stamina", nil, {
				is_battle_go = true
			}) then
				return 
			end
		elseif not UIUtil:checkCurrencyDialog("stamina") then
			return 
		end
	end
	
	local var_294_10 = T(DB("item_token", "to_stamina", "name"))
	local var_294_11 = T(DB("item_token", "to_crystal", "name"))
	local var_294_12 = T(DB("item_token", "to_light", "name"))
	local var_294_13 = {
		CRYSTAL = 2,
		LIGHT = 1
	}
	local var_294_14 = load_dlg("pvp_config_buy", true, "wnd")
	
	if_set_visible(var_294_14, "n_1/1", false)
	if_set_visible(var_294_14, "n_1", true)
	if_set_visible(var_294_14, "n_2", true)
	if_set_visible(var_294_14, "n_time", false)
	if_set_visible(var_294_14, "n_time_01", false)
	if_set_visible(var_294_14, "n_time_02", false)
	
	var_294_14.select_buy = var_294_13.LIGHT
	
	if var_294_7 < var_294_3 and var_294_0 <= var_294_6 then
		var_294_14.select_buy = var_294_13.CRYSTAL
	end
	
	local var_294_15 = var_294_14:getChildByName("n_1")
	
	if_set_visible(var_294_15, "select", var_294_14.select_buy == var_294_13.LIGHT)
	UIUtil:getRewardIcon(var_294_3, "to_light", {
		no_tooltip = true,
		show_count = true,
		parent = var_294_15:getChildByName("n_item_before")
	})
	UIUtil:getRewardIcon(var_294_4, "to_stamina", {
		no_tooltip = true,
		show_count = true,
		parent = var_294_15:getChildByName("n_item_after")
	})
	if_set(var_294_15, "txt_have", T("have", {
		name = var_294_12,
		count = var_294_7
	}))
	
	if var_294_7 < var_294_3 then
		if_set_opacity(var_294_14, "n_1", 80)
	else
		if_set_opacity(var_294_14, "n_1", 255)
	end
	
	local var_294_16 = var_294_14:getChildByName("n_2")
	
	if_set_visible(var_294_16, "select", var_294_14.select_buy == var_294_13.CRYSTAL)
	UIUtil:getRewardIcon(var_294_0, "to_crystal", {
		no_tooltip = true,
		show_count = true,
		parent = var_294_16:getChildByName("n_item_before")
	})
	UIUtil:getRewardIcon(var_294_1, "to_stamina", {
		no_tooltip = true,
		show_count = true,
		parent = var_294_16:getChildByName("n_item_after")
	})
	if_set(var_294_16, "txt_have", T("have", {
		name = var_294_11,
		count = var_294_6
	}))
	
	if var_294_6 < var_294_0 then
		if_set_opacity(var_294_14, "n_2", 80)
	else
		if_set_opacity(var_294_14, "n_2", 255)
	end
	
	if arg_294_1 == nil then
		arg_294_1 = "battle.ready"
	end
	
	local var_294_17 = "lack_token"
	local var_294_18 = "ready_buy_stamina.desc"
	
	if arg_294_1 == "topbar" then
		var_294_17 = "buy_stamina_title"
		var_294_18 = "buy_stamina_desc"
	elseif BackPlayManager:isRunning() then
		var_294_18 = "buy_stamina_bgbattle_desc"
	end
	
	if_set(var_294_14, "txt_title", T(var_294_17, {
		token = var_294_10
	}))
	if_set(var_294_14, "text_disc", T(var_294_18))
	Dialog:msgBox(T(var_294_18), {
		yesno = true,
		dlg = var_294_14,
		handler = function(arg_295_0, arg_295_1, arg_295_2)
			if arg_295_1 == "btn_buy" then
				if arg_295_0.select_buy == 1 then
					query("buy", {
						shop = "normal",
						item = var_294_5,
						caller = arg_294_1
					})
				else
					query("buy", {
						shop = "normal",
						item = var_294_2,
						caller = arg_294_1
					})
				end
			elseif arg_295_1 == "btn_n1" then
				if var_294_7 >= var_294_3 then
					arg_295_0.select_buy = var_294_13.LIGHT
					
					if_set_visible(var_294_15, "select", true)
					if_set_visible(var_294_16, "select", false)
				end
				
				return "dont_close"
			elseif arg_295_1 == "btn_n2" then
				if var_294_6 >= var_294_0 then
					arg_295_0.select_buy = var_294_13.CRYSTAL
					
					if_set_visible(var_294_15, "select", false)
					if_set_visible(var_294_16, "select", true)
				end
				
				return "dont_close"
			end
		end,
		title = T(var_294_17, {
			token = var_294_10
		})
	})
end

local function var_0_14(arg_296_0, arg_296_1)
	if not arg_296_0 or not arg_296_1 then
		return 
	end
	
	local var_296_0
	
	if AccountData.limits then
		local var_296_1 = os.time()
		local var_296_2 = AccountData.limits["sh:" .. arg_296_0]
		
		if var_296_2 and arg_296_1 <= var_296_2.count then
			local var_296_3 = to_n(var_296_2.expire_tm)
			
			if var_296_1 <= var_296_3 then
				var_296_0 = var_296_3 - var_296_1
			end
		end
	end
	
	return var_296_0
end

local function var_0_15(arg_297_0, arg_297_1)
	if not arg_297_1 then
		return 
	end
	
	if arg_297_0 == "battle.ready" then
		if not UIUtil:checkCurrencyDialog(arg_297_1, nil, {
			is_battle_go = true
		}) then
			return true
		end
	elseif arg_297_0 == "topbar" then
		local var_297_0 = Shop:getTokenCategory(arg_297_1)
		
		if var_297_0 then
			SceneManager:reserveResetSceneFlow()
			Shop:open("normal", var_297_0)
		end
		
		return true
	elseif not UIUtil:checkCurrencyDialog(arg_297_1) then
		return true
	end
	
	return false
end

function UIUtil.wannaBuyPvpkey(arg_298_0, arg_298_1)
	local var_298_0 = GAME_STATIC_VARIABLE.buy_pvpkey_cost_fp or 100
	local var_298_1 = GAME_STATIC_VARIABLE.buy_pvpkey_count_fp or 5
	local var_298_2 = GAME_STATIC_VARIABLE.buy_pvpkey_id_fp or "friendship_3"
	local var_298_3 = GAME_STATIC_VARIABLE.buy_pvpkey_period_fp or "day"
	local var_298_4 = GAME_STATIC_VARIABLE.buy_pvpkey_buy_fp or 1
	local var_298_5 = GAME_STATIC_VARIABLE.buy_pvpkey_cost or 30
	local var_298_6 = GAME_STATIC_VARIABLE.buy_pvpkey_count or 5
	local var_298_7 = GAME_STATIC_VARIABLE.buy_pvpkey_id or "currency_5"
	local var_298_8 = Account:getCurrency("crystal") or 0
	local var_298_9 = Account:getCurrency("friendpoint") or 0
	local var_298_10 = var_298_8 < var_298_5
	
	if var_298_10 and var_298_9 < var_298_0 and not UIUtil:checkCurrencyDialog("pvpkey") then
		return 
	end
	
	local var_298_11, var_298_12 = DB("item_token", "to_pvpkey", {
		"name",
		"icon"
	})
	local var_298_13, var_298_14 = DB("item_token", "to_crystal", {
		"name",
		"icon"
	})
	local var_298_15, var_298_16 = DB("item_token", "to_friendpoint", {
		"name",
		"icon"
	})
	local var_298_17 = {
		CRYSTAL = 2,
		FRIENDPOINT = 1
	}
	local var_298_18 = load_dlg("pvp_config_buy", true, "wnd")
	
	if_set_visible(var_298_18, "n_1/1", false)
	if_set_visible(var_298_18, "n_time", false)
	if_set_visible(var_298_18, "n_time_01", false)
	if_set_visible(var_298_18, "n_time_02", false)
	if_set_visible(var_298_18, "n_1", true)
	if_set_visible(var_298_18, "n_2", true)
	
	var_298_18.select_buy = var_298_17.FRIENDPOINT
	
	local var_298_19
	local var_298_20 = var_0_14(var_298_2, 1)
	
	if var_298_20 and var_298_10 and not UIUtil:checkCurrencyDialog("pvpkey") then
		return 
	end
	
	if var_298_20 or var_298_9 < var_298_0 and var_298_5 <= var_298_8 then
		var_298_18.select_buy = var_298_17.CRYSTAL
	end
	
	local var_298_21 = var_298_18:getChildByName("n_time_01")
	local var_298_22 = var_298_18:getChildByName("n_1")
	
	if var_298_20 then
		var_298_21:setVisible(true)
		var_298_22:setVisible(false)
		if_set_sprite(var_298_21, "icon_menu", "item/" .. var_298_16 .. ".png")
		if_set(var_298_21, "txt_friendship", T(var_298_15))
		if_set(var_298_21, "txt_infor", T("shop_period_" .. var_298_3, "shop_period_" .. var_298_3 .. "(#count#)", {
			count = var_298_4
		}))
		if_set(var_298_21, "txt_time", T("time_reset_shop2", {
			time = sec_to_string(var_298_20)
		}))
	else
		var_298_21:setVisible(false)
		var_298_22:setVisible(true)
		if_set_visible(var_298_22, "select", var_298_18.select_buy == var_298_17.FRIENDPOINT)
		UIUtil:getRewardIcon(var_298_0, "to_friendpoint", {
			no_tooltip = true,
			show_count = true,
			parent = var_298_22:getChildByName("n_item_before")
		})
		UIUtil:getRewardIcon(var_298_1, "to_pvpkey", {
			no_tooltip = true,
			show_count = true,
			parent = var_298_22:getChildByName("n_item_after")
		})
		if_set(var_298_22, "txt_have", T("have", {
			name = T(var_298_15),
			count = var_298_9
		}))
		
		if var_298_9 < var_298_0 then
			if_set_opacity(var_298_18, "n_1", 80)
		else
			if_set_opacity(var_298_18, "n_1", 255)
		end
	end
	
	local var_298_23 = var_298_18:getChildByName("n_2")
	
	if_set_visible(var_298_23, "select", var_298_18.select_buy == var_298_17.CRYSTAL)
	UIUtil:getRewardIcon(var_298_5, "to_crystal", {
		no_tooltip = true,
		show_count = true,
		parent = var_298_23:getChildByName("n_item_before")
	})
	UIUtil:getRewardIcon(var_298_6, "to_pvpkey", {
		no_tooltip = true,
		show_count = true,
		parent = var_298_23:getChildByName("n_item_after")
	})
	if_set(var_298_23, "txt_have", T("have", {
		name = T(var_298_13),
		count = var_298_8
	}))
	
	if var_298_10 then
		if_set_opacity(var_298_18, "n_2", 80)
	else
		if_set_opacity(var_298_18, "n_2", 255)
	end
	
	if arg_298_1 == nil then
		arg_298_1 = "battle.ready"
	end
	
	if_set(var_298_18, "txt_title", T("buy_pvpkey_title"))
	if_set(var_298_18, "text_disc", T("buy_pvpkey_desc"))
	Dialog:msgBox(nil, {
		yesno = true,
		dlg = var_298_18,
		handler = function(arg_299_0, arg_299_1, arg_299_2)
			if arg_299_1 == "btn_buy" then
				if arg_299_0.select_buy == 1 then
					query("buy", {
						shop = "normal",
						item = var_298_2,
						caller = arg_298_1
					})
				else
					query("buy", {
						shop = "normal",
						item = var_298_7,
						caller = arg_298_1
					})
				end
			elseif arg_299_1 == "btn_n1" then
				if var_298_9 >= var_298_0 then
					arg_299_0.select_buy = var_298_17.FRIENDPOINT
					
					if_set_visible(var_298_22, "select", true)
					if_set_visible(var_298_23, "select", false)
				end
				
				return "dont_close"
			elseif arg_299_1 == "btn_n2" then
				if var_298_8 >= var_298_5 then
					arg_299_0.select_buy = var_298_17.CRYSTAL
					
					if_set_visible(var_298_22, "select", false)
					if_set_visible(var_298_23, "select", true)
				end
				
				return "dont_close"
			end
		end
	})
end

function UIUtil.wannaBuyMazekey(arg_300_0, arg_300_1)
	local var_300_0 = GAME_CONTENT_VARIABLE.buy_mazekey_cost_light or 3
	local var_300_1 = GAME_CONTENT_VARIABLE.buy_mazekey_count_light or 1
	local var_300_2 = GAME_CONTENT_VARIABLE.buy_mazekey_id_light or "dungeon_10"
	local var_300_3 = GAME_CONTENT_VARIABLE.buy_mazekey_period_light or "day"
	local var_300_4 = GAME_CONTENT_VARIABLE.buy_mazekey_buy_light or 1
	local var_300_5 = Account:getCurrency("light") or 0
	local var_300_6
	local var_300_7 = var_0_14(var_300_2, var_300_4)
	local var_300_8 = false
	
	if var_300_7 or var_300_5 < var_300_0 then
		var_300_8 = true
	end
	
	local var_300_9 = GAME_CONTENT_VARIABLE.buy_mazekey_cost_crystal or 120
	local var_300_10 = GAME_CONTENT_VARIABLE.buy_mazekey_count_crystal or 1
	local var_300_11 = GAME_CONTENT_VARIABLE.buy_mazekey_id_crystal or "dungeon_8"
	local var_300_12 = GAME_CONTENT_VARIABLE.buy_mazekey_period_crystal or "day"
	local var_300_13 = GAME_CONTENT_VARIABLE.buy_mazekey_buy_crystal or 1
	local var_300_14 = Account:getCurrency("crystal") or 0
	local var_300_15
	local var_300_16 = var_0_14(var_300_11, var_300_13)
	local var_300_17 = false
	
	if var_300_16 or var_300_14 < var_300_9 then
		var_300_17 = true
	end
	
	if var_300_8 and var_300_17 and var_0_15(arg_300_1, "mazekey") then
		return 
	end
	
	local var_300_18 = DB("item_token", "to_mazekey", {
		"name"
	})
	local var_300_19, var_300_20 = DB("item_token", "to_light", {
		"name",
		"icon"
	})
	local var_300_21, var_300_22 = DB("item_token", "to_crystal", {
		"name",
		"icon"
	})
	local var_300_23 = {
		CRYSTAL = 2,
		LIGHT = 1
	}
	local var_300_24 = load_dlg("pvp_config_buy", true, "wnd")
	
	if_set_visible(var_300_24, "n_1/1", false)
	if_set_visible(var_300_24, "n_1", true)
	if_set_visible(var_300_24, "n_2", true)
	if_set_visible(var_300_24, "n_time", false)
	if_set_visible(var_300_24, "bar2_l", true)
	
	var_300_24.select_buy = var_300_23.LIGHT
	
	if var_300_7 or var_300_5 < var_300_0 and var_300_9 <= var_300_14 then
		var_300_24.select_buy = var_300_23.CRYSTAL
	end
	
	if_set_visible(var_300_24, "n_time_01", false)
	
	local var_300_25 = var_300_24:getChildByName("n_1")
	local var_300_26 = var_300_24:getChildByName("n_time_01")
	
	if var_300_7 then
		var_300_26:setVisible(true)
		var_300_25:setVisible(false)
		if_set_sprite(var_300_26, "icon_menu", "item/" .. var_300_20 .. ".png")
		if_set(var_300_26, "txt_friendship", T(var_300_19))
		if_set(var_300_26, "txt_infor", T("shop_period_" .. var_300_3, "shop_period_" .. var_300_3 .. "(#count#)", {
			count = var_300_4
		}))
		if_set(var_300_26, "txt_time", T("time_reset_shop2", {
			time = sec_to_string(var_300_7)
		}))
	else
		var_300_26:setVisible(false)
		var_300_25:setVisible(true)
		if_set_visible(var_300_25, "select", var_300_24.select_buy == var_300_23.LIGHT)
		UIUtil:getRewardIcon(var_300_0, "to_light", {
			no_tooltip = true,
			show_count = true,
			parent = var_300_25:getChildByName("n_item_before")
		})
		UIUtil:getRewardIcon(var_300_1, "to_mazekey", {
			no_tooltip = true,
			show_count = true,
			parent = var_300_25:getChildByName("n_item_after")
		})
		if_set(var_300_25, "txt_have", T("have", {
			name = T(var_300_19),
			count = var_300_5
		}))
		
		if var_300_7 or var_300_5 < var_300_0 then
			if_set_opacity(var_300_24, "n_1", 80)
		else
			if_set_opacity(var_300_24, "n_1", 255)
		end
	end
	
	if_set_visible(var_300_24, "n_time_02", false)
	
	local var_300_27 = var_300_24:getChildByName("n_2")
	local var_300_28 = var_300_24:getChildByName("n_time_02")
	
	if var_300_16 then
		var_300_28:setVisible(true)
		var_300_27:setVisible(false)
		if_set_sprite(var_300_28, "icon_menu", "item/" .. var_300_22 .. ".png")
		if_set(var_300_28, "txt_friendship", T(var_300_21))
		if_set(var_300_28, "txt_infor", T("shop_period_" .. var_300_12, "shop_period_" .. var_300_12 .. "(#count#)", {
			count = var_300_13
		}))
		if_set(var_300_28, "txt_time", T("time_reset_shop2", {
			time = sec_to_string(var_300_16)
		}))
	else
		var_300_28:setVisible(false)
		var_300_27:setVisible(true)
		if_set_visible(var_300_27, "select", var_300_24.select_buy == var_300_23.CRYSTAL)
		UIUtil:getRewardIcon(var_300_9, "to_crystal", {
			no_tooltip = true,
			show_count = true,
			parent = var_300_27:getChildByName("n_item_before")
		})
		UIUtil:getRewardIcon(var_300_10, "to_mazekey", {
			no_tooltip = true,
			show_count = true,
			parent = var_300_27:getChildByName("n_item_after")
		})
		if_set(var_300_27, "txt_have", T("have", {
			name = T(var_300_21),
			count = var_300_14
		}))
		
		if var_300_16 or var_300_14 < var_300_9 then
			if_set_opacity(var_300_24, "n_2", 80)
		else
			if_set_opacity(var_300_24, "n_2", 255)
		end
	end
	
	if arg_300_1 == nil then
		arg_300_1 = "battle.ready"
	end
	
	local var_300_29 = "buy_mazekey_title"
	local var_300_30 = "buy_mazekey_desc"
	
	if_set(var_300_24, "txt_title", T(var_300_29))
	if_set(var_300_24, "text_disc", T(var_300_30))
	Dialog:msgBox(T(var_300_30), {
		yesno = true,
		dlg = var_300_24,
		handler = function(arg_301_0, arg_301_1, arg_301_2)
			if arg_301_1 == "btn_buy" then
				if arg_301_0.select_buy == var_300_23.LIGHT then
					query("buy", {
						shop = "normal",
						item = var_300_2,
						caller = arg_300_1
					})
				else
					query("buy", {
						shop = "normal",
						item = var_300_11,
						caller = arg_300_1
					})
				end
			elseif arg_301_1 == "btn_n1" then
				if not var_300_7 and var_300_5 >= var_300_0 then
					arg_301_0.select_buy = var_300_23.LIGHT
					
					if_set_visible(var_300_25, "select", true)
					if_set_visible(var_300_27, "select", false)
				end
				
				return "dont_close"
			elseif arg_301_1 == "btn_n2" then
				if not var_300_16 and var_300_14 >= var_300_9 then
					arg_301_0.select_buy = var_300_23.CRYSTAL
					
					if_set_visible(var_300_25, "select", false)
					if_set_visible(var_300_27, "select", true)
				end
				
				return "dont_close"
			end
		end,
		title = T(var_300_29, {
			token = T(var_300_18)
		})
	})
end

function UIUtil.wannaBuyMazekey2(arg_302_0, arg_302_1)
	local var_302_0 = GAME_CONTENT_VARIABLE.buy_mazekey2_cost_mazekey or 3
	local var_302_1 = GAME_CONTENT_VARIABLE.buy_mazekey2_count_mazekey or 1
	local var_302_2 = GAME_CONTENT_VARIABLE.buy_mazekey2_id_mazekey or "dungeon_9"
	local var_302_3 = GAME_CONTENT_VARIABLE.buy_mazekey2_buy_mazekey or 10
	local var_302_4 = Account:getCurrency("mazekey") or 0
	local var_302_5
	local var_302_6 = var_0_14(var_302_2, var_302_3)
	local var_302_7 = false
	
	if var_302_6 or var_302_4 < var_302_0 then
		var_302_7 = true
	end
	
	if var_302_7 and var_0_15(arg_302_1, "mazekey2") then
		return 
	end
	
	local var_302_8 = DB("item_token", "to_mazekey2", {
		"name"
	})
	local var_302_9 = DB("item_token", "to_mazekey", {
		"name"
	})
	local var_302_10 = load_dlg("pvp_config_buy", true, "wnd")
	
	if_set_visible(var_302_10, "n_1/1", true)
	if_set_visible(var_302_10, "n_1", false)
	if_set_visible(var_302_10, "n_2", false)
	if_set_visible(var_302_10, "n_time", false)
	if_set_visible(var_302_10, "n_time_01", false)
	if_set_visible(var_302_10, "n_time_02", false)
	if_set_visible(var_302_10, "bar2_l", false)
	
	local var_302_11 = var_302_10:getChildByName("n_1/1")
	
	if_set_visible(var_302_11, "select", true)
	UIUtil:getRewardIcon(var_302_0, "to_mazekey", {
		no_tooltip = true,
		show_count = true,
		parent = var_302_11:getChildByName("n_item_before")
	})
	UIUtil:getRewardIcon(var_302_1, "to_mazekey2", {
		no_tooltip = true,
		show_count = true,
		parent = var_302_11:getChildByName("n_item_after")
	})
	if_set(var_302_11, "txt_have", T("have", {
		name = T(var_302_9),
		count = var_302_4
	}))
	
	if arg_302_1 == nil then
		arg_302_1 = "battle.ready"
	end
	
	local var_302_12 = "buy_mazekey2_title"
	local var_302_13 = "buy_mazekey2_desc"
	
	if_set(var_302_10, "txt_title", T(var_302_12))
	if_set(var_302_10, "text_disc", T(var_302_13))
	Dialog:msgBox(T(var_302_13), {
		yesno = true,
		dlg = var_302_10,
		handler = function(arg_303_0, arg_303_1, arg_303_2)
			if arg_303_1 == "btn_buy" then
				query("buy", {
					shop = "normal",
					item = var_302_2,
					caller = arg_302_1
				})
			elseif arg_303_1 == "btn_n1/1" then
				if not var_302_6 and var_302_4 >= var_302_0 then
					if_set_visible(var_302_11, "select", true)
				end
				
				return "dont_close"
			end
		end,
		title = T(var_302_12, {
			token = T(var_302_8)
		})
	})
end

function UIUtil.wannaBuyAbysskey(arg_304_0, arg_304_1)
	local var_304_0 = GAME_STATIC_VARIABLE.buy_abysskey_cost_light or 1
	local var_304_1 = GAME_STATIC_VARIABLE.buy_abysskey_count_light or 2
	local var_304_2 = GAME_STATIC_VARIABLE.buy_abysskey_id_light or "currency_10"
	local var_304_3 = Account:getCurrency("light") or 0
	local var_304_4
	local var_304_5 = var_0_14(var_304_2, 1)
	local var_304_6 = false
	
	if var_304_5 or var_304_3 < var_304_0 then
		var_304_6 = true
	end
	
	if var_304_6 and var_0_15(arg_304_1, "abysskey") then
		return 
	end
	
	local var_304_7 = DB("item_token", "to_abysskey", "name")
	local var_304_8 = DB("item_token", "to_light", "name")
	local var_304_9 = load_dlg("pvp_config_buy", true, "wnd")
	
	if_set_visible(var_304_9, "n_1/1", true)
	if_set_visible(var_304_9, "n_1", false)
	if_set_visible(var_304_9, "n_2", false)
	if_set_visible(var_304_9, "n_time", false)
	if_set_visible(var_304_9, "n_time_01", false)
	if_set_visible(var_304_9, "n_time_02", false)
	if_set_visible(var_304_9, "bar2_l", false)
	
	local var_304_10 = var_304_9:getChildByName("n_1/1")
	
	if_set_visible(var_304_10, "select", true)
	UIUtil:getRewardIcon(var_304_0, "to_light", {
		no_tooltip = true,
		show_count = true,
		parent = var_304_10:getChildByName("n_item_before")
	})
	UIUtil:getRewardIcon(var_304_1, "to_abysskey", {
		no_tooltip = true,
		show_count = true,
		parent = var_304_10:getChildByName("n_item_after")
	})
	if_set(var_304_10, "txt_have", T("have", {
		name = T(var_304_8),
		count = var_304_3
	}))
	
	if arg_304_1 == nil then
		arg_304_1 = "battle.ready"
	end
	
	local var_304_11 = "buy_abysskey_title"
	local var_304_12 = "buy_abysskey_desc"
	
	if_set(var_304_9, "txt_title", T(var_304_11))
	if_set(var_304_9, "text_disc", T(var_304_12))
	Dialog:msgBox(T(var_304_12), {
		yesno = true,
		dlg = var_304_9,
		handler = function(arg_305_0, arg_305_1, arg_305_2)
			if arg_305_1 == "btn_buy" then
				query("buy", {
					shop = "normal",
					item = var_304_2,
					caller = arg_304_1
				})
			elseif arg_305_1 == "btn_n1/1" then
				if not var_304_5 and var_304_3 >= var_304_0 then
					if_set_visible(var_304_10, "select", true)
				end
				
				return "dont_close"
			end
		end,
		title = T(var_304_11, {
			token = T(var_304_7)
		})
	})
end

function UIUtil.addNoise(arg_306_0, arg_306_1)
	arg_306_1:setOpacity(255 * (1 - 0.07 * math.random()))
	arg_306_1:setColor(cc.c3b(255 * (1 - 0.07 * math.random()), 255 * (1 - 0.07 * math.random()), 255 * (1 - 0.07 * math.random())))
end

local var_0_16 = {}

function UIUtil.checkBtnTouchPos(arg_307_0, arg_307_1, arg_307_2, arg_307_3)
	if arg_307_2 < 0 or arg_307_3 < 0 then
		return 
	end
	
	if arg_307_2 == 0 and arg_307_3 == 0 then
		return 
	end
	
	local var_307_0 = getParentWindow(arg_307_1):getName()
	local var_307_1 = var_0_16[var_307_0]
	
	if not var_307_1 then
		var_307_1 = {}
		var_0_16[var_307_0] = var_307_1
	end
	
	local var_307_2 = string.format("%f+%f", arg_307_2, arg_307_3)
	
	var_307_1[var_307_2] = to_n(var_307_1[var_307_2]) + 1
	
	if var_307_1[var_307_2] >= 5 then
		query("convic", {
			reason = "stouch",
			convic = 2
		})
	end
end

function UIUtil.getTrialHallPanel(arg_308_0, arg_308_1, arg_308_2)
	if table.count(arg_308_1) <= 0 then
		return 
	end
	
	local var_308_0 = load_control("wnd/trial_ability.csb")
	local var_308_1 = 0
	local var_308_2 = {
		x = 0,
		y = 0
	}
	local var_308_3 = 0
	
	for iter_308_0, iter_308_1 in pairs(arg_308_1) do
		local var_308_4, var_308_5, var_308_6 = DB("cs", iter_308_1, {
			"boss_cs_icon_small",
			"boss_cs_icon_big",
			"boss_cs_description"
		})
		
		var_308_1 = var_308_1 + 1
		
		local var_308_7 = var_308_0:getChildByName("n_ability" .. var_308_1)
		
		if get_cocos_refid(var_308_7) then
			local var_308_8 = load_control("wnd/trial_node_text_tip.csb")
			
			var_308_7:addChild(var_308_8)
			
			local var_308_9 = TooltipUtil:getCSTooltipText(T(var_308_6), iter_308_1)
			
			if_set_sprite(var_308_8, "icon", "buff/" .. var_308_4 .. ".png")
			if_set(var_308_8, "txt", var_308_9)
			
			local var_308_10 = var_308_8:getChildByName("txt")
			local var_308_11 = 0
			
			if get_cocos_refid(var_308_10) then
				var_308_11 = 24 * var_308_10:getStringNumLines()
				
				var_308_10:setContentSize(var_308_10:getContentSize().width, var_308_11)
				
				var_308_11 = var_308_11 + 14
				var_308_11 = var_308_11 * var_308_10:getScaleY()
				
				var_308_10:setColor(arg_308_2 and cc.c3b(101, 190, 255) or cc.c3b(255, 129, 119))
			end
			
			if var_308_1 == 1 then
				var_308_2.x = var_308_7:getPositionX()
				var_308_2.y = var_308_7:getPositionY()
			end
			
			var_308_7:setPosition(var_308_2.x, var_308_2.y)
			
			var_308_3 = var_308_3 + var_308_11
			var_308_2.y = var_308_2.y - var_308_11
		end
	end
	
	local var_308_12 = var_308_0:getChildByName("bg")
	local var_308_13 = 0
	
	if get_cocos_refid(var_308_12) then
		var_308_13 = var_308_12:getContentSize().height + var_308_3
		
		var_308_12:setContentSize(var_308_12:getContentSize().width, var_308_13)
	end
	
	if_set_color(var_308_0, "bg", arg_308_2 and cc.c3b(27, 67, 104) or cc.c3b(115, 27, 27))
	
	return var_308_0, var_308_13
end

function UIUtil._getItemInfo(arg_309_0, arg_309_1, arg_309_2)
	local var_309_0
	local var_309_1
	local var_309_2
	
	if DB("character", arg_309_1, "id") then
		var_309_0, var_309_1 = DB("character", arg_309_1, {
			"type",
			"grade"
		})
	elseif DB("equip_item", arg_309_1, "id") then
		local var_309_3, var_309_4 = DB("equip_item", arg_309_1, {
			"type",
			"tier"
		})
		
		var_309_0 = var_309_3
		var_309_2 = var_309_4
		var_309_1 = DB("item_equip_grade_rate", arg_309_2, "max")
		
		if not var_309_1 then
			var_309_1 = DB("item_equip_grade_rate", {
				"default",
				"max"
			})
		end
	elseif DB("item_material", arg_309_1, "id") then
		var_309_0, var_309_1, var_309_2 = DB("item_material", arg_309_1, {
			"ma_type",
			"grade",
			"priority"
		})
	elseif DB("item_token", arg_309_1, "id") then
		var_309_0, var_309_1 = DB("item_token", arg_309_1, {
			"type",
			"grade"
		})
	elseif DB("item_special", arg_309_1, "id") then
		var_309_0, var_309_1 = DB("item_special", arg_309_1, {
			"type",
			"grade"
		})
	end
	
	return var_309_0, to_n(var_309_1), to_n(var_309_2)
end

function UIUtil.getDisplayKeyItems(arg_310_0, arg_310_1)
	local var_310_0 = {}
	local var_310_1 = {}
	
	for iter_310_0, iter_310_1 in pairs(arg_310_1) do
		local var_310_2, var_310_3, var_310_4 = arg_310_0:_getItemInfo(iter_310_1[1], iter_310_1[4])
		
		if not table.isInclude(var_310_0, var_310_2) then
			table.insert(var_310_0, var_310_2)
			table.insert(var_310_1, iter_310_1)
		end
	end
	
	return var_310_1
end

function UIUtil.getItemDisplayPoint(arg_311_0, arg_311_1, arg_311_2, arg_311_3)
	local var_311_0 = arg_311_1[1]
	local var_311_1 = arg_311_1[4]
	local var_311_2, var_311_3, var_311_4 = arg_311_0:_getItemInfo(var_311_0, var_311_1)
	
	arg_311_2 = arg_311_2 or "default"
	
	if arg_311_3 then
		arg_311_2 = string.format("%s_%s", arg_311_2, arg_311_3)
	end
	
	for iter_311_0 = 1, 100 do
		local var_311_5, var_311_6 = DB("reward_display_order", tostring(iter_311_0), {
			"id",
			"type"
		})
		
		if not var_311_5 then
			break
		end
		
		if var_311_6 == arg_311_2 then
			local var_311_7, var_311_8, var_311_9, var_311_10, var_311_11, var_311_12 = DB("reward_display_order", tostring(iter_311_0), {
				var_311_2,
				"default",
				"grade_add",
				"tier_add",
				"grade_limit",
				"tier_limit"
			})
			
			var_311_9 = var_311_9 or 1000
			var_311_10 = var_311_10 or 100
			
			local var_311_13 = 0
			
			if var_311_3 >= to_n(var_311_11) then
				var_311_13 = to_n(var_311_9) * var_311_3
			end
			
			local var_311_14 = 0
			
			if var_311_4 >= to_n(var_311_12) then
				var_311_14 = to_n(var_311_10) * var_311_4
			end
			
			return to_n(var_311_7 or var_311_8) + var_311_13 + var_311_14
		end
	end
	
	return 0
end

function UIUtil.getSkinGradeBorder(arg_312_0, arg_312_1)
	arg_312_1 = arg_312_1 or 1
	
	return ({
		"icon_border_skin1",
		"icon_border_skin2",
		"icon_border_skin3",
		"icon_border_skin4",
		"icon_border_skin5"
	})[arg_312_1]
end

function UIUtil.getSkinGradeBG(arg_313_0, arg_313_1)
	arg_313_1 = arg_313_1 or 1
	
	return ({
		"_hero_s_bg_skin1",
		"_hero_s_bg_skin2",
		"_hero_s_bg_skin3",
		"_hero_s_bg_skin4",
		"_hero_s_bg_skin5"
	})[arg_313_1]
end

function UIUtil.sortDisplayItems(arg_314_0, arg_314_1, arg_314_2, arg_314_3)
	local var_314_0, var_314_1 = DB("level_enter", arg_314_2, {
		"type",
		"contents_type"
	})
	
	local function var_314_2(arg_315_0)
		return arg_314_0:getItemDisplayPoint(arg_315_0, var_314_1 or var_314_0, arg_314_3)
	end
	
	table.sort(arg_314_1, function(arg_316_0, arg_316_1)
		if arg_316_0.already or arg_316_0.is_half or arg_316_0.mission_clear then
			return false
		elseif arg_316_1.already or arg_316_1.is_half or arg_316_1.mission_clear then
			return true
		end
		
		local var_316_0 = var_314_2(arg_316_0)
		local var_316_1 = var_314_2(arg_316_1)
		
		if arg_316_0.golden or arg_316_0.first_reward or arg_316_0.star_reward then
			var_316_0 = var_316_0 + 100000
		end
		
		if arg_316_1.golden or arg_316_1.first_reward or arg_316_1.star_reward then
			var_316_1 = var_316_1 + 100000
		end
		
		return var_316_1 < var_316_0
	end)
	
	local var_314_3 = false
	
	if var_314_3 then
		for iter_314_0, iter_314_1 in pairs(arg_314_1) do
			print("error:", iter_314_1[1], var_314_2(iter_314_1))
		end
	end
	
	return arg_314_1
end

function UIUtil.updateTextWrapMode(arg_317_0, arg_317_1, arg_317_2, arg_317_3)
	if not get_cocos_refid(arg_317_1) then
		return 
	end
	
	local var_317_0 = tolua.type(arg_317_1)
	local var_317_1 = var_317_0 == "cc.Label"
	local var_317_2 = var_317_0 == "ccui.Text"
	local var_317_3 = var_317_0 == "ccui.RichText"
	
	if not var_317_1 and not var_317_2 and not var_317_3 then
		return 
	end
	
	if var_317_3 then
		arg_317_2 = string.gsub(arg_317_2, "%b<>", "")
	end
	
	local function var_317_4(arg_318_0)
		local var_318_0 = string.split(arg_318_0, "[%s-]", false)
		local var_318_1 = false
		
		if get_instant_text_width then
			local var_318_2 = "font/daum.ttf"
			local var_318_3 = 24
			
			if var_317_1 then
				local var_318_4 = arg_317_1:getTTFConfig()
				
				var_318_2 = var_318_4.fontFilePath
				var_318_3 = var_318_4.fontSize
			else
				var_318_2 = arg_317_1:getFontName()
				var_318_3 = arg_317_1:getFontSize()
			end
			
			local var_318_5 = arg_317_1:getContentSize().width
			
			for iter_318_0, iter_318_1 in pairs(var_318_0) do
				if var_318_5 <= get_instant_text_width(iter_318_1, var_318_2, var_318_3) then
					var_318_1 = true
					
					break
				end
			end
		else
			arg_317_3 = arg_317_3 or 13
			
			for iter_318_2, iter_318_3 in pairs(var_318_0) do
				if arg_317_3 < iter_318_3:len() then
					var_318_1 = true
					
					break
				end
			end
		end
		
		return var_318_1
	end
	
	arg_317_1:setLineBreakWithoutSpace(var_317_4(arg_317_2))
end

function UIUtil.isHideItem(arg_319_0, arg_319_1)
	if not arg_319_1 then
		return 
	end
	
	local var_319_0 = Account:isJPN() and "jpn" or "global"
	
	return DB("item_hide_filter", arg_319_1, var_319_0) == "y"
end

function UIUtil.getFlagIcon(arg_320_0, arg_320_1, arg_320_2)
	if arg_320_1 then
		if arg_320_1 == "CN" then
			arg_320_1 = "flg_default"
		else
			arg_320_1 = "flg_" .. tostring(arg_320_1)
		end
	else
		arg_320_1 = "flg_default"
	end
	
	if arg_320_2.parent then
		SpriteCache:resetSprite(arg_320_2.parent, "flg/" .. arg_320_1 .. ".png")
	end
	
	return arg_320_1
end

function UIUtil.setOffsetInfo(arg_321_0, arg_321_1, arg_321_2)
	if get_cocos_refid(arg_321_1) then
		local var_321_0 = {}
		
		if type(arg_321_2) == "string" then
			var_321_0 = totable(arg_321_2 or "")
		elseif type(arg_321_2) == "table" then
			var_321_0 = arg_321_2
		end
		
		local var_321_1 = var_321_0.flip == "true"
		local var_321_2 = var_321_0.offset_x or 0
		local var_321_3 = var_321_0.offset_y or 0
		local var_321_4 = var_321_0.scale
		
		arg_321_1:setPosition(arg_321_1:getPositionX() + var_321_2, arg_321_1:getPositionY() + var_321_3)
		
		if var_321_4 then
			arg_321_1:setScale(var_321_4)
		end
		
		if var_321_1 then
			arg_321_1:setScaleX(-arg_321_1:getScaleX())
		end
	end
end

function UIUtil.isChangeSeasonLabelPosition(arg_322_0)
	local var_322_0 = getUserLanguage()
	
	if var_322_0 == "fr" or var_322_0 == "pt" or var_322_0 == "es" or var_322_0 == "de" or var_322_0 == "th" then
		return true
	end
	
	return false
end

function UIUtil.tip(arg_323_0, arg_323_1, arg_323_2)
	local function var_323_0(arg_324_0)
		if not arg_324_0 then
			return 
		end
		
		if not arg_324_0.msg_doc then
			return 
		end
		
		if arg_324_0.msg_doc.type or arg_324_0.msg_doc.style then
			return 
		end
		
		return arg_324_0.msg_doc.sender
	end
	
	local function var_323_1(arg_325_0)
		if not arg_325_0 then
			return true
		end
		
		if not arg_325_0.msg_doc then
			return true
		end
		
		local var_325_0 = arg_325_0.msg_doc.type or arg_325_0.msg_doc.style
		
		if var_325_0 ~= "notice" and var_325_0 ~= "replay" then
			return true
		end
		
		return false
	end
	
	local function var_323_2(arg_326_0)
		if not arg_326_0 then
			return 
		end
		
		if not arg_326_0.msg_doc then
			return 
		end
		
		return arg_326_0.msg_doc.sender and arg_326_0.msg_doc.sender.clan_id or arg_326_0.channel_id
	end
	
	local function var_323_3(arg_327_0)
		if not arg_327_0 then
			return 
		end
		
		if not arg_327_0.msg_doc then
			return 
		end
		
		if (arg_327_0.msg_doc.type or arg_327_0.msg_doc.style) == "replay" then
			return "img/icon_menu_replay.png"
		end
		
		if arg_327_0.noti_keyword ~= nil then
			return "img/icon_menu_alarm.png"
		end
		
		local var_327_0 = arg_327_0.section
		
		if var_327_0 == "clan" then
			return "img/icon_menu_knightage.png"
		end
		
		if var_327_0 ~= "public" and Account:getClanId() == var_323_2(arg_327_0) then
			return "img/icon_menu_knightage.png"
		end
		
		return "img/icon_menu_talk.png"
	end
	
	if not get_cocos_refid(arg_323_1) then
		return 
	end
	
	local var_323_4 = arg_323_2.text
	local var_323_5 = arg_323_2.opts or {}
	local var_323_6 = var_323_0(var_323_5)
	local var_323_7 = var_323_1(var_323_5)
	local var_323_8 = arg_323_1:getChildByName("t_tip")
	local var_323_9 = arg_323_1:getChildByName("_bg")
	
	UIAction:Remove(var_323_9)
	UIAction:Add(SEQ(DELAY(30), CALL(function()
		UIUserData:call(var_323_9, "AUTOSIZE_WIDTH(../t_tip, 1, 54)")
	end)), var_323_9, "tip_bg")
	
	local var_323_10 = tostring(var_323_4)
	local var_323_11 = string.replace(var_323_10, "\n", " ")
	
	if var_323_7 then
		var_323_8:ignoreContentAdaptWithSize(true)
		
		var_323_8._origin_size = var_323_8._origin_size or var_323_8:getContentSize()
		
		var_323_8:setContentSize(var_323_8._origin_size)
		
		var_323_11 = get_ellipsis_label(var_323_8, var_323_11, 720, 10)
		
		var_323_8:ignoreContentAdaptWithSize(false)
	end
	
	local var_323_12 = var_323_5.noti_keyword
	
	if var_323_12 then
		var_323_11 = string.gsub(var_323_11, var_323_12, "<#337ac3>" .. var_323_12 .. "</>", 1)
	end
	
	if var_323_6 and var_323_6.name then
		var_323_11 = "<#337ac3>" .. var_323_6.name .. "</>:" .. var_323_11
	end
	
	local var_323_13 = upgradeLabelToRichLabel(arg_323_1, "t_tip", true)
	
	var_323_13:ignoreContentAdaptWithSize(true)
	if_set_color(var_323_11, nil, tocolor(var_323_12 and "#603d2a" or "#ffffff"))
	if_set_color(var_323_9, nil, tocolor(var_323_12 and "#ffdc62" or "#ffffff"))
	if_set_color(arg_323_1, "arrow_t", tocolor(var_323_12 and "#ffdc62" or "#ffffff"))
	if_set(var_323_13, nil, var_323_11)
	
	local var_323_14 = var_323_3(var_323_5)
	
	if_set_sprite(arg_323_1, "icon_category", var_323_14)
	
	local var_323_15
	
	if var_323_5.delay then
		var_323_15 = DELAY(math.random(1000, 4000))
	else
		var_323_15 = NONE()
	end
	
	local var_323_16 = math.max(2000, math.min(3500, utf8len(var_323_11) * 150))
	
	arg_323_1:setOpacity(255)
	arg_323_1:setScale(0)
	UIAction:Remove(arg_323_1)
	UIAction:Add(SEQ(var_323_15, SHOW(true), SCALE(100, 0, 1.1), DELAY(30), SCALE(60, 1.1, 1), DELAY(var_323_16), OPACITY(180, 1, 0), SHOW(false)), arg_323_1, "tip")
end

function UIUtil.tipEmoji(arg_329_0, arg_329_1, arg_329_2)
	local function var_329_0(arg_330_0)
		if not arg_330_0 then
			return 
		end
		
		if not arg_330_0.msg_doc then
			return 
		end
		
		if arg_330_0.msg_doc.type or arg_330_0.msg_doc.style then
			return 
		end
		
		return arg_330_0.msg_doc.sender
	end
	
	local function var_329_1(arg_331_0)
		if not arg_331_0 then
			return 
		end
		
		if not arg_331_0.msg_doc then
			return 
		end
		
		return arg_331_0.msg_doc.sender and arg_331_0.msg_doc.sender.clan_id or arg_331_0.channel_id
	end
	
	local function var_329_2(arg_332_0)
		if not arg_332_0 then
			return 
		end
		
		if not arg_332_0.msg_doc then
			return 
		end
		
		local var_332_0 = arg_332_0.section
		
		if var_332_0 == "clan" then
			return "img/icon_menu_knightage.png"
		end
		
		if var_332_0 ~= "public" and Account:getClanId() == var_329_1(arg_332_0) then
			return "img/icon_menu_knightage.png"
		end
		
		return "img/icon_menu_talk.png"
	end
	
	if not get_cocos_refid(arg_329_1) then
		return 
	end
	
	local var_329_3 = arg_329_2.emoji
	local var_329_4 = arg_329_2.opts or {}
	local var_329_5 = var_329_0(var_329_4)
	local var_329_6 = var_329_5 and var_329_5.name or ""
	local var_329_7 = arg_329_1:getChildByName("t_tip")
	
	if get_cocos_refid(var_329_7) then
		local var_329_8 = var_329_7:getScaleY()
		
		var_329_7:setScaleX(var_329_8)
		UIUserData:call(var_329_7, "SINGLE_WSCALE(143)")
		var_329_7:ignoreContentAdaptWithSize(true)
		if_set(var_329_7, nil, var_329_6 .. ":")
		
		local var_329_9 = var_329_7:getChildByName("icon_category")
		
		if get_cocos_refid(var_329_9) then
			local var_329_10 = var_329_2(var_329_4)
			
			if_set_sprite(var_329_9, nil, var_329_10)
			
			local var_329_11 = var_329_9:getScaleX()
			
			var_329_9:setScaleX(var_329_11 * var_329_8 / var_329_7:getScaleX())
		end
	end
	
	local var_329_12 = arg_329_1:getChildByName("n_emoji")
	
	if get_cocos_refid(var_329_12) then
		var_329_12:removeAllChildren()
		
		local var_329_13 = "emoticon_chat/" .. var_329_3 .. ".png"
		local var_329_14 = cc.Sprite:create()
		
		SpriteCache:resetSprite(var_329_14, var_329_13)
		var_329_12:addChild(var_329_14)
	end
	
	local var_329_15
	
	if var_329_4.delay then
		var_329_15 = DELAY(math.random(1000, 4000))
	else
		var_329_15 = NONE()
	end
	
	local var_329_16 = 3000
	
	arg_329_1:setOpacity(255)
	arg_329_1:setScale(0)
	UIAction:Remove(arg_329_1)
	UIAction:Add(SEQ(var_329_15, SHOW(true), SCALE(100, 0, 1.1), DELAY(30), SCALE(60, 1.1, 1), DELAY(var_329_16), OPACITY(180, 1, 0), SHOW(false)), arg_329_1, "tip")
end

function UIUtil.getSetItemNameList(arg_333_0)
	local var_333_0 = {}
	
	for iter_333_0 = 1, 99 do
		local var_333_1 = DBN("item_set", iter_333_0, {
			"id"
		})
		
		if not var_333_1 then
			break
		end
		
		table.insert(var_333_0, var_333_1)
	end
	
	return var_333_0
end

function UIUtil.getSetItemListExtention(arg_334_0, arg_334_1)
	local var_334_0 = arg_334_1 or false
	local var_334_1 = {
		"all",
		"set_att",
		"set_def",
		"set_max_hp",
		"set_speed",
		"set_cri",
		"set_cri_dmg",
		"set_acc",
		"set_res",
		"set_vampire",
		"set_counter",
		"set_coop",
		"set_immune",
		"set_rage",
		"set_penetrate",
		"set_revenge",
		"set_scar",
		"set_shield",
		"set_torrent"
	}
	
	if var_334_0 then
		return var_334_1
	else
		table.remove(var_334_1, 1)
		
		return var_334_1
	end
end

function UIUtil.getMainStatListByParts(arg_335_0, arg_335_1, arg_335_2)
	if not arg_335_1 then
		return 
	end
	
	local var_335_0 = {
		neck = {
			"all",
			"att",
			"def",
			"max_hp",
			"att_rate",
			"def_rate",
			"max_hp_rate",
			"cri",
			"cri_dmg"
		},
		ring = {
			"all",
			"att",
			"def",
			"max_hp",
			"att_rate",
			"def_rate",
			"max_hp_rate",
			"acc",
			"res"
		},
		boot = {
			"all",
			"att",
			"def",
			"max_hp",
			"att_rate",
			"def_rate",
			"max_hp_rate",
			"speed"
		}
	}
	
	if arg_335_2 then
		return var_335_0[arg_335_1]
	else
		table.remove(var_335_0[arg_335_1], 1)
		
		return var_335_0[arg_335_1]
	end
end

function UIUtil.getSetItemSortList(arg_336_0)
	local var_336_0 = {}
	
	for iter_336_0 = 1, 99 do
		local var_336_1, var_336_2 = DBN("item_set", iter_336_0, {
			"id",
			"sort"
		})
		
		if not var_336_1 then
			break
		end
		
		var_336_0[var_336_1] = var_336_2
	end
	
	return var_336_0
end

function UIUtil.getSkinList(arg_337_0, arg_337_1)
	local var_337_0 = {}
	local var_337_1 = DB("character", arg_337_1, "skin_group")
	local var_337_2 = {}
	
	for iter_337_0 = 1, GAME_STATIC_VARIABLE.max_skin_count or 3 do
		table.insert(var_337_2, string.format("skin%02d", iter_337_0))
		table.insert(var_337_2, string.format("skin%02d_ma", iter_337_0))
	end
	
	local var_337_3 = DBT("character_skin", var_337_1, var_337_2) or {}
	
	for iter_337_1 = 1, GAME_STATIC_VARIABLE.max_skin_count or 3 do
		local var_337_4 = var_337_3[string.format("skin%02d", iter_337_1)]
		
		if not var_337_4 then
			break
		end
		
		if Account:isPublishedSkin(var_337_4) then
			local var_337_5 = var_337_3[string.format("skin%02d_ma", iter_337_1)]
			
			table.insert(var_337_0, {
				code = var_337_4,
				material = var_337_5
			})
		end
	end
	
	local var_337_6 = DB("character_skin", var_337_1, "default") or arg_337_1
	
	if is_mer_series(var_337_6) then
		var_337_6 = change_mer_code()
	end
	
	table.insert(var_337_0, {
		code = var_337_6
	})
	
	return var_337_0
end

function UIUtil.isExistSkin(arg_338_0, arg_338_1)
	if not arg_338_1 then
		return false
	end
	
	return table.count(arg_338_0:getSkinList(arg_338_1) or {}) > 1
end

function UIUtil.setUpEquipCraftResultDlg(arg_339_0, arg_339_1, arg_339_2, arg_339_3)
	arg_339_2:setAnchorPoint(0.5, 0.5)
	arg_339_2:setPosition(0, 0)
	arg_339_1:getChildByName("n_pos_detail"):addChild(arg_339_2)
	ItemTooltip:updateItemInformation({
		detail = true,
		wnd = arg_339_2,
		equip = arg_339_3
	})
	
	local var_339_0 = arg_339_2:getChildByName("txt_set_info")
	
	if get_cocos_refid(var_339_0) then
		local var_339_1 = var_339_0:getStringNumLines()
		
		if var_339_1 and var_339_1 >= 4 then
			local var_339_2 = arg_339_1:getChildByName("cm_tooltipbox")
			local var_339_3 = arg_339_1:getChildByName("block")
			local var_339_4 = arg_339_1:getChildByName("n_btn")
			
			if get_cocos_refid(var_339_2) and get_cocos_refid(var_339_3) and get_cocos_refid(var_339_4) then
				local var_339_5 = var_339_2:getContentSize()
				local var_339_6 = var_339_3:getContentSize()
				
				var_339_2:setContentSize({
					width = var_339_5.width,
					height = var_339_5.height + 20
				})
				var_339_3:setContentSize({
					width = var_339_6.width,
					height = var_339_6.height + 20
				})
				
				local var_339_7 = var_339_4:getPositionY()
				
				var_339_4:setPositionY(var_339_7 - 20)
			end
		end
	end
end

function UIUtil.playEquipCraftEffect(arg_340_0, arg_340_1, arg_340_2, arg_340_3, arg_340_4)
	local var_340_0, var_340_1 = arg_340_2:getChildByName("bg_item"):getPosition()
	local var_340_2 = arg_340_1:getChildByName("bg_item")
	local var_340_3 = arg_340_1:getChildByName("n_etc")
	local var_340_4 = arg_340_1:getChildByName("n_stats")
	local var_340_5 = arg_340_1:getChildByName("n_names")
	local var_340_6 = arg_340_1:getChildByName("n_btn")
	
	if_set(arg_340_1, "txt", T("ui_equip_craft_result_title"))
	var_340_2:setPosition(150, 292)
	var_340_2:setOpacity(0)
	var_340_3:setOpacity(0)
	var_340_4:setOpacity(0)
	var_340_6:setOpacity(0)
	var_340_5:setVisible(false)
	
	local var_340_7 = 2000
	local var_340_8 = 300
	local var_340_9 = 200
	local var_340_10 = var_340_7 + var_340_9
	local var_340_11 = 200
	
	UIAction:Add(SEQ(DELAY(var_340_7), FADE_IN(var_340_9), MOVE_TO(var_340_8, var_340_0, var_340_1)), var_340_2, "block")
	UIAction:Add(SEQ(DELAY(var_340_10), FADE_IN(var_340_11)), var_340_3, "block")
	UIAction:Add(SEQ(DELAY(var_340_10), FADE_IN(var_340_11)), var_340_4, "block")
	UIAction:Add(SEQ(DELAY(var_340_10), FADE_IN(var_340_11)), var_340_6, "block")
	UIAction:Add(SEQ(DELAY(var_340_10 + var_340_8), FADE_IN(var_340_11)), var_340_5, "block")
	EffectManager:Play({
		pivot_x = 629,
		fn = "ui_itembuild_b.cfx",
		pivot_y = 365,
		pivot_z = 99998,
		layer = arg_340_1:getChildByName("n_eff_back")
	})
	EffectManager:Play({
		scaleY = 1.1,
		pivot_x = 629,
		fn = "ui_itembuild_f.cfx",
		pivot_y = 390,
		pivot_z = 99998,
		layer = arg_340_1:getChildByName("n_eff_front")
	})
	UIAction:Add(SEQ(DELAY(var_340_10 + var_340_8), CALL(arg_340_3, arg_340_4)), arg_340_4, "block")
end

function UIUtil.playBurningEquipCraftEffect(arg_341_0, arg_341_1, arg_341_2, arg_341_3, arg_341_4)
	local var_341_0, var_341_1 = arg_341_2:getChildByName("bg_item"):getPosition()
	local var_341_2 = arg_341_1:getChildByName("bg_item")
	local var_341_3 = arg_341_1:getChildByName("n_etc")
	local var_341_4 = arg_341_1:getChildByName("n_stats")
	local var_341_5 = arg_341_1:getChildByName("n_names")
	local var_341_6 = arg_341_1:getChildByName("n_btn")
	
	if_set(arg_341_1, "txt", T("burn_equip_title"))
	var_341_2:setPosition(150, 292)
	var_341_2:setOpacity(0)
	var_341_3:setOpacity(0)
	var_341_4:setOpacity(0)
	var_341_6:setOpacity(0)
	var_341_5:setVisible(false)
	
	local var_341_7 = 2100
	local var_341_8 = 400
	local var_341_9 = 300
	local var_341_10 = var_341_7 + var_341_9
	local var_341_11 = 300
	
	UIAction:Add(SEQ(DELAY(var_341_7), FADE_IN(var_341_9), MOVE_TO(var_341_8, var_341_0, var_341_1)), var_341_2, "block")
	UIAction:Add(SEQ(DELAY(var_341_10), FADE_IN(var_341_11)), var_341_3, "block")
	UIAction:Add(SEQ(DELAY(var_341_10), FADE_IN(var_341_11)), var_341_4, "block")
	UIAction:Add(SEQ(DELAY(var_341_10), FADE_IN(var_341_11)), var_341_6, "block")
	UIAction:Add(SEQ(DELAY(var_341_10 + var_341_8), FADE_IN(var_341_11)), var_341_5, "block")
	EffectManager:Play({
		z = 99999,
		fn = "eff_burning_equip.cfx",
		layer = SceneManager:getRunningNativeScene(),
		x = DESIGN_WIDTH / 2,
		y = DESIGN_HEIGHT / 2
	})
	UIAction:Add(SEQ(DELAY(var_341_10 + var_341_8), CALL(arg_341_3, arg_341_4)), arg_341_4, "block")
end

function UIUtil.playResultStatEffect(arg_342_0, arg_342_1)
	local var_342_0 = CACHE:getEffect("itemupgrade_statup")
	local var_342_1 = arg_342_1:getChildByName("txt_main_stat")
	local var_342_2, var_342_3 = var_342_1:getPosition()
	
	var_342_0:setScaleY(2)
	var_342_0:setPosition(var_342_2 - 20, var_342_3)
	var_342_0:setLocalZOrder(2000)
	var_342_1:getParent():addChild(var_342_0)
	UIAction:AddSync(SEQ(DMOTION("animation"), REMOVE()), var_342_0)
	
	for iter_342_0 = 1, 4 do
		local var_342_4 = arg_342_1:getChildByName("txt_sub_stat" .. iter_342_0)
		
		if var_342_4:isVisible() then
			local var_342_5, var_342_6 = var_342_4:getPosition()
			local var_342_7 = CACHE:getEffect("itemupgrade_statup")
			
			var_342_7:setScaleX(0.5)
			var_342_7:setPosition(var_342_5, var_342_6)
			var_342_7:setLocalZOrder(2000)
			var_342_4:getParent():addChild(var_342_7)
			UIAction:AddSync(SEQ(DMOTION("animation"), REMOVE()), var_342_7)
		end
	end
end

function UIUtil.setItemBadge(arg_343_0, arg_343_1, arg_343_2)
	if not get_cocos_refid(arg_343_1) then
		return 
	end
	
	if not arg_343_2 then
		return 
	end
	
	local var_343_0 = DB("item_special", arg_343_2, {
		"badge"
	}) or DB("item_material", arg_343_2, {
		"badge"
	})
	
	if not var_343_0 then
		return 
	end
	
	local var_343_1 = var_343_0 ~= nil and "item/icon_" .. var_343_0 .. ".png" or nil
	
	if not var_343_1 then
		return 
	end
	
	local var_343_2 = arg_343_1:getChildByName("n_set_icon")
	
	if not get_cocos_refid(var_343_2) then
		return 
	end
	
	if_set_sprite(var_343_2, "icon", var_343_1)
	if_set_visible(var_343_2, nil, var_343_1)
end

function UIUtil.setUpgradeInfo(arg_344_0, arg_344_1, arg_344_2)
	local var_344_0 = arg_344_2.unit
	local var_344_1 = arg_344_2.price
	local var_344_2 = arg_344_2.exp
	local var_344_3 = arg_344_2.origin_unit
	local var_344_4 = var_344_0:getExpString(var_344_2)
	
	if_set(arg_344_1, "cost", comma_value(var_344_1))
	UIUtil:setUnitAllInfo(arg_344_1, var_344_0, {
		pre = "up_",
		base = true,
		reverse_upgrade_star = arg_344_2.reverse_upgrade_star
	})
	UIUtil:setUnitAllInfo(arg_344_1, var_344_3, {
		base = true
	})
	
	if DEBUG.OLD_PROMOTION_RULE then
		if_set_visible(arg_344_1, "n_exp_bar", not var_344_0:isMaxLevel() and not var_344_0:isPromotionUnit())
	end
	
	if not var_344_0:isMaxLevel() then
		if_set(arg_344_1, "label_up", "+" .. var_344_0.inst.lv - var_344_0.inst.lv)
		
		if var_344_0.inst.lv > var_344_0.inst.lv then
			arg_344_1:getChildByName("up_exp_gauge"):setPercent(100)
		end
	end
	
	if_set_visible(arg_344_1, "upgrade", not var_344_0:isMaxLevel())
	
	local var_344_5 = cc.c4b(255, 120, 0)
	local var_344_6 = cc.c4b(60, 120, 220)
	
	if_set_visible(arg_344_1, "n_upgrade", var_344_0:isMaxLevel() and var_344_0:getGrade() < 6)
	
	local var_344_7 = var_344_3.inst.lv < 60 or var_344_3:getGrade() < 6 or Account:getSameUnitCount(var_344_3) > 1
	
	if DEBUG.OLD_PROMOTION_RULE and var_344_0:isPromotionUnit() then
		var_344_7 = var_344_0:isMaxLevel()
	end
	
	if_set_visible(arg_344_1, "n_buttons", var_344_7)
	if_set_visible(arg_344_1, "n_slots", var_344_7)
	if_set(arg_344_1, "txt_exp", "exp " .. var_344_4)
	
	for iter_344_0 = 0, 13 do
		local var_344_8 = arg_344_1:getChildByName("img_stat_up_" .. string.format("%02d", iter_344_0))
		local var_344_9 = arg_344_1:getChildByName(string.format("txt_stat%02d", iter_344_0))
		local var_344_10 = arg_344_1:getChildByName(string.format("up_txt_stat%02d", iter_344_0))
		
		if var_344_9 and var_344_10 then
			if var_344_9:getString() ~= var_344_10:getString() then
				local var_344_11 = to_n(string.gsub(string.gsub(string.gsub(var_344_9:getString(), ",", ""), "%%", ""), "+", ""))
				local var_344_12 = to_n(string.gsub(string.gsub(string.gsub(var_344_10:getString(), ",", ""), "%%", ""), "+", ""))
				local var_344_13 = var_344_5
				
				if var_344_12 < var_344_11 then
					var_344_13 = var_344_6
				end
				
				var_344_8:setVisible(true)
				var_344_10:setVisible(true)
				var_344_8:setColor(var_344_13)
				var_344_10:setTextColor(var_344_13)
				
				if iter_344_0 == 10 then
					var_344_8:setVisible(false)
					var_344_10:setVisible(false)
				end
			else
				if_set_visible(arg_344_1, "img_stat_up_" .. string.format("%02d", iter_344_0), false)
				var_344_10:setVisible(false)
			end
		end
	end
	
	if_set_visible(arg_344_1, "arrow_lv", var_344_0:getLv() ~= var_344_3:getLv())
	if_set_visible(arg_344_1, "n_lv_up", var_344_0:getLv() ~= var_344_3:getLv())
	UIUtil:setLevel(arg_344_1:getChildByName("n_lv"), var_344_0:getLv(), nil, 2)
	
	if var_344_0:getLv() ~= var_344_3:getLv() then
		UIUtil:setLevel(arg_344_1:getChildByName("n_lv_up"), var_344_0:getLv(), nil, 2)
	end
	
	if_set_visible(arg_344_1, "node_upgrade", var_344_0:getPoint(var_344_3:getCharacterStatus()) ~= var_344_0:getPoint(var_344_0:getCharacterStatus()))
	
	if arg_344_2.mode == "Promote" then
		if_set(arg_344_1, "txt_enhance", T("promote"))
	else
		if_set(arg_344_1, "txt_enhance", T("enhance"))
	end
	
	local var_344_14, var_344_15 = var_344_0:getDevoteSkill()
	
	if not var_344_15 then
		if_set_visible(arg_344_1, "n_dedi_stat", false)
		if_set_visible(arg_344_1, "n_dedi_stat_up", false)
	elseif to_n(var_344_15) >= 0 then
		if_set_visible(arg_344_1, "n_dedi_stat", true)
		UIUtil:setDevoteDetail_new(arg_344_1, var_344_0, {
			target = "n_dedi_stat"
		})
		
		local var_344_16, var_344_17 = var_344_3:getDevoteSkill()
		
		if var_344_17 == 0 or var_344_15 == var_344_17 then
			if_set_visible(arg_344_1, "n_dedi_stat_up", false)
		else
			if_set_visible(arg_344_1, "n_dedi_stat_up", true)
			UIUtil:setDevoteDetail_new(arg_344_1, var_344_3, {
				target = "n_dedi_stat_up"
			})
		end
		
		local var_344_18, var_344_19 = var_344_0:getDevoteGrade()
	end
end

function UIUtil.showPresentWnd(arg_345_0, arg_345_1, arg_345_2, arg_345_3, arg_345_4)
	local var_345_0 = Dialog:open("wnd/destiny_present", arg_345_0)
	
	SceneManager:getRunningPopupScene():addChild(var_345_0)
	UIUtil:getRewardIcon(arg_345_4, arg_345_3, {
		show_name = true,
		detail = true,
		parent = var_345_0:getChildByName("n_item")
	})
	UIUtil:getRewardIcon(nil, arg_345_3, {
		no_frame = true,
		scale = 0.6,
		parent = var_345_0:getChildByName("n_pay_token")
	})
	if_set(var_345_0, "txt_price", comma_value(arg_345_4))
	if_set(var_345_0, "txt_item_hoiding", T("text_item_have_count", {
		count = comma_value(Account:getPropertyCount(arg_345_3) or 0)
	}))
	if_set(var_345_0, "txt_title", T("ui_shop_chapter_present_title"))
	if_set(var_345_0, "txt_disc", T("ui_shop_chapter_present_desc"))
	
	local var_345_1 = var_345_0:getChildByName("btn_present")
	
	var_345_1.give_code = arg_345_3
	var_345_1.give_count = arg_345_4
	var_345_1.contents_id = arg_345_1
	var_345_1.contents_type = arg_345_2
end

function UIUtil.getSetIDByAlias(arg_346_0, arg_346_1)
	return ({
		rage = "set_rage",
		def = "set_def",
		cnt = "set_counter",
		scar = "set_scar",
		coop = "set_coop",
		spd = "set_speed",
		shld = "set_shield",
		crid = "set_cri_dmg",
		torr = "set_torrent",
		rev = "set_revenge",
		pen = "set_penetrate",
		vam = "set_vampire",
		immu = "set_immune",
		cri = "set_cri",
		acc = "set_acc",
		res = "set_res",
		mh = "set_max_hp",
		att = "set_att"
	})[arg_346_1]
end

function UIUtil.isEquipRecallable(arg_347_0, arg_347_1)
	if not arg_347_1 or not AccountData.recall_info then
		return false
	end
	
	local var_347_0 = arg_347_1.code
	local var_347_1 = AccountData.recall_info.recall_period.equips[var_347_0]
	
	if not var_347_1 or not var_347_1.start_time or not var_347_1.end_time then
		return false
	end
	
	if var_347_1.start_time > os.time() or var_347_1.end_time < os.time() or var_347_1.start_time < to_n(arg_347_1.ct or os.time()) then
		return false
	end
	
	if AccountData.recall_info.recalled_equips[arg_347_1.id] and to_n(AccountData.recall_info.recalled_equips[arg_347_1.id].last_recall) >= var_347_1.end_time then
		return false
	end
	
	if arg_347_1:isArtifact() then
		if to_n(arg_347_1.exp) > 0 and (to_n(arg_347_1:getMaxSkillLevel()) > 5 or to_n(arg_347_1:getExp()) >= 1800) then
			return true
		end
	elseif var_347_1.exclusive and arg_347_1.db.exclusive_skill and table.find(var_347_1.exclusive, arg_347_1.db.exclusive_skill .. "_0" .. arg_347_1.op[2][2]) then
		return true
	end
	
	return false
end

function UIUtil.showObtainableSetTooltip(arg_348_0, arg_348_1, arg_348_2, arg_348_3)
	if not get_cocos_refid(arg_348_1) or table.empty(arg_348_2) then
		return 
	end
	
	local var_348_0 = arg_348_1:getChildByName("n_set_tooltip")
	
	if not get_cocos_refid(var_348_0) then
		return 
	end
	
	var_348_0:setVisible(arg_348_3)
	
	if arg_348_3 == false then
		return 
	end
	
	local var_348_1 = 236
	local var_348_2 = 0
	
	local function var_348_3(arg_349_0, arg_349_1)
		if not get_cocos_refid(arg_349_0) then
			return 
		end
		
		arg_349_0:setVisible(arg_349_1 ~= nil)
		arg_349_0:setPositionY(var_348_1)
		
		if not arg_349_1 then
			return 
		end
		
		local var_349_0, var_349_1, var_349_2 = DB("item_set", arg_349_1, {
			"name",
			"set_number",
			"desc2"
		})
		
		if_set(arg_349_0, "txt_set_title", T(var_349_0))
		if_set(arg_349_0, "txt_set_condition", T("set_req_number", {
			num = var_349_1
		}))
		if_set(arg_349_0, "txt_set_effect", T(var_349_2 or "item_set 에 desc 컬럼이 없습니다."))
		
		local var_349_3 = EQUIP:getSetItemIconPath(arg_349_1)
		
		if_set_sprite(arg_349_0, "set_icon", var_349_3)
		
		local var_349_4 = arg_349_0:getChildByName("txt_set_effect")
		
		if not get_cocos_refid(var_349_4) then
			return 
		end
		
		local var_349_5 = var_349_4:getStringNumLines()
		local var_349_6 = var_349_4:getLineHeight() * var_349_4:getScale()
		local var_349_7 = 58
		local var_349_8 = var_349_6 * var_349_5
		
		var_348_1 = var_348_1 - var_349_8 - var_349_7
		var_348_2 = var_348_2 + var_349_8 - var_349_6
	end
	
	local var_348_4 = 0
	local var_348_5 = string.len("n_set")
	local var_348_6 = var_348_0:getChildByName("n_con")
	
	if not get_cocos_refid(var_348_6) then
		var_348_6 = var_348_0:getChildByName("n_icon")
	end
	
	for iter_348_0, iter_348_1 in pairs(var_348_6:getChildren()) do
		local var_348_7 = iter_348_1:getName()
		
		if string.starts(var_348_7, "n_set") then
			local var_348_8 = tonumber(string.sub(var_348_7, var_348_5 + 1, -1))
			
			if var_348_4 < var_348_8 then
				var_348_4 = var_348_8
			end
		end
	end
	
	for iter_348_2 = 1, var_348_4 do
		local var_348_9 = var_348_6:getChildByName("n_set" .. iter_348_2)
		
		var_348_3(var_348_9, arg_348_2[iter_348_2])
	end
	
	local var_348_10 = var_348_0:getChildByName("set_bg")
	local var_348_11 = var_348_10:getContentSize()
	local var_348_12 = 475 - (4 - #arg_348_2) * 85 + var_348_2
	
	var_348_10:setContentSize({
		width = var_348_11.width,
		height = var_348_12
	})
end

function UIUtil.getCaptureUnitIcon(arg_350_0, arg_350_1, arg_350_2)
	if not get_cocos_refid(arg_350_1) then
		return nil
	end
	
	arg_350_2 = arg_350_2 or {}
	
	arg_350_1:setAnchorPoint(0, 0)
	
	local var_350_0 = arg_350_1:getContentSize()
	
	arg_350_2.scale = arg_350_2.scale or 1
	
	local var_350_1 = cc.RenderTexture:create(var_350_0.width * arg_350_2.scale, var_350_0.height * arg_350_2.scale, cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888)
	
	var_350_1:setKeepMatrix(false)
	var_350_1:begin()
	arg_350_1:visit()
	var_350_1:endToLua()
	
	local var_350_2 = var_350_1:getSprite()
	
	var_350_2:ejectFromParent()
	var_350_2:setAnchorPoint(0.5, 0.5)
	var_350_2:setCascadeOpacityEnabled(true)
	var_350_2:setName("face_icon_" .. arg_350_2.code)
	var_350_2:setScale(arg_350_2.scale)
	
	return var_350_2
end

function UIUtil.isSDModelItem(arg_351_0, arg_351_1)
	if not arg_351_1 then
		return false
	end
	
	local var_351_0 = DBT("item_material", arg_351_1, {
		"ma_type",
		"ma_type2"
	})
	
	if var_351_0 and var_351_0.ma_type == "profile" and var_351_0.ma_type2 == "sd" then
		return true
	end
	
	return false
end

function UIUtil.popupUnlockInfoDialog(arg_352_0, arg_352_1, arg_352_2, arg_352_3, arg_352_4)
	local var_352_0 = load_dlg("unlock_system_open", true, "wnd")
	
	var_352_0:setName("unlock_system_open")
	
	if arg_352_2 then
		if_set(var_352_0, "txt_title", T(arg_352_2))
	end
	
	if arg_352_3 then
		if_set(var_352_0, "infor", T(arg_352_3))
	end
	
	if arg_352_4 then
		if_set_sprite(var_352_0, "icon_storyguide", "img/" .. arg_352_4 .. ".png")
	end
	
	var_352_0:setVisible(false)
	UIAction:Add(FADE_IN(100), var_352_0, "UNLOCK")
	
	local var_352_1 = var_352_0:getChildByName("n_arrow")
	
	if get_cocos_refid(var_352_1) then
		UIAction:Add(SEQ(LOOP(SEQ(LOG(MOVE_TO(350, 0, 0)), RLOG(MOVE_TO(350, 0, -10))))), var_352_1, "arrow_move")
	end
	
	if get_cocos_refid(arg_352_1) then
		arg_352_1:addChild(var_352_0)
	else
		Dialog:msgBox("", {
			no_reward_effect = true,
			dlg = var_352_0
		})
	end
	
	return var_352_0
end

function UIUtil.getIllustPath(arg_353_0, arg_353_1, arg_353_2)
	if not arg_353_2 then
		return 
	end
	
	arg_353_1 = arg_353_1 or ""
	
	local var_353_0 = arg_353_1 .. arg_353_2 .. ".webp"
	
	if not cc.FileUtils:getInstance():isFileExist(var_353_0) then
		var_353_0 = arg_353_1 .. arg_353_2 .. ".png"
	end
	
	return var_353_0
end

function UIUtil.getIllustPathWithCheckExist(arg_354_0, arg_354_1, arg_354_2)
	if not arg_354_2 then
		return 
	end
	
	arg_354_1 = arg_354_1 or ""
	
	local var_354_0 = arg_354_1 .. arg_354_2 .. ".webp"
	
	if not cc.FileUtils:getInstance():isFileExist(var_354_0) then
		return nil
	end
	
	return var_354_0
end
