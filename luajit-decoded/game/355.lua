UIUtil = UIUtil or {}

function UIUtil.updatePetFace(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = arg_1_2:getFaceID()
	
	if arg_1_2.is_pet then
		SpriteCache:resetSprite(arg_1_1, "face/" .. var_1_0 .. "_l.png")
	else
		SpriteCache:resetSprite(arg_1_1, "item/" .. var_1_0 .. "_l.png")
	end
	
	return true
end

function UIUtil.updatePetName(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	local var_2_0 = ""
	
	if arg_2_4 then
		var_2_0 = arg_2_2:getDefaultName()
	else
		var_2_0 = arg_2_2:getName()
	end
	
	if not PRODUCTION_MODE and DEBUG.SHOW_PET_UID then
		var_2_0 = var_2_0 .. "." .. arg_2_2:getUID()
	end
	
	if arg_2_3 then
		arg_2_1._origin_scale_x = arg_2_1._origin_scale_x or arg_2_1:getScaleX()
		
		arg_2_1:setString(var_2_0)
		
		local var_2_1 = 146
		local var_2_2 = arg_2_1:getContentSize().width
		local var_2_3 = 1
		
		if var_2_1 < var_2_2 then
			var_2_3 = var_2_1 / var_2_2
		end
		
		arg_2_1:setScaleX(arg_2_1._origin_scale_x * var_2_3)
	else
		if_set(arg_2_1, nil, var_2_0)
	end
	
	return true
end

function UIUtil.updatePetLevel(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	arg_3_3 = arg_3_3 or {}
	
	local var_3_0 = arg_3_2:getLv()
	local var_3_1 = var_3_0
	
	if arg_3_3.inc_level then
		var_3_1 = var_3_1 + arg_3_3.inc_level
	end
	
	if arg_3_3.use_in_icon then
		arg_3_0:updateIconLevel(arg_3_1, var_3_1)
	else
		if arg_3_3.use_offset then
			arg_3_3.offset_position = arg_3_3.offset_position or 21
			arg_3_3.offset_per_char = UIUtil:numberDigitToCharOffset(var_3_0, 1, arg_3_3.offset_position)
		end
		
		if arg_3_3.use_offsets then
			arg_3_3.offset_per_char = UIUtil:numberDigitsToCharOffsets(var_3_0, arg_3_3.digits, arg_3_3.offsets)
			arg_3_3.force_offset = true
		end
		
		arg_3_0:warpping_setLevel(arg_3_1, var_3_1, arg_3_2:getMaxLevel(), 2, arg_3_3)
	end
	
	return true
end

function UIUtil.updatePetExpBar(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	local var_4_0 = 500
	local var_4_1 = arg_4_3 and arg_4_3.inc_exp or 0
	local var_4_2, var_4_3 = arg_4_2:getExpString(var_4_1)
	
	if arg_4_3 and arg_4_3.is_ani then
		UIAction:Add(LOG(PROGRESS(var_4_0, 0, var_4_3)), arg_4_1)
	else
		if_set_percent(arg_4_1, nil, var_4_3)
	end
end

function UIUtil.updatePetExpText(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	local var_5_0, var_5_1 = arg_5_2:getExpString()
	
	if arg_5_3 and arg_5_3.inc_exp then
		var_5_0 = arg_5_2:getExpString(arg_5_3.inc_exp)
	end
	
	if_set(arg_5_1, nil, var_5_0)
end

function UIUtil.updatePetExpInfos(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	arg_6_3 = arg_6_3 or {}
	
	local var_6_0 = arg_6_3.exp_gauge or "exp_gauge"
	local var_6_1 = arg_6_3.txt_exp or "txt_exp"
	
	arg_6_0:updatePetExpBar(arg_6_1:findChildByName(var_6_0), arg_6_2, arg_6_3)
	arg_6_0:updatePetExpText(arg_6_1:findChildByName(var_6_1), arg_6_2, arg_6_3)
end

function UIUtil.updatePetStory(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	arg_7_3 = arg_7_3 or {}
	
	local var_7_0 = T(arg_7_2:getDesc())
	
	if arg_7_3.show_full_desc then
		var_7_0 = T("pet_info_race", {
			race = T(arg_7_2:getRace())
		}) .. "\n" .. T("pet_info_personal", {
			personal = T(arg_7_2:getPersonality())
		}) .. "\n" .. T(arg_7_2:getDesc())
	end
	
	if_set(arg_7_1, nil, var_7_0)
end

function UIUtil.updatePetStars(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	local var_8_0 = arg_8_2:getGrade()
	
	if arg_8_3 then
		var_8_0 = var_8_0 + arg_8_3
	end
	
	for iter_8_0 = 1, var_8_0 do
		if_set_visible(arg_8_1, "star" .. iter_8_0, true)
	end
	
	local var_8_1 = 6
	
	for iter_8_1 = var_8_0 + 1, var_8_1 do
		if_set_visible(arg_8_1, "star" .. iter_8_1, false)
	end
	
	return true
end

function UIUtil.updatePetStarsPosition(arg_9_0, arg_9_1, arg_9_2)
	if not arg_9_1 or not arg_9_2 then
		return 
	end
	
	local var_9_0 = arg_9_2
	
	if_call(arg_9_1, "star1", "setPositionX", 10 + var_9_0:getContentSize().width * var_9_0:getScaleX() + var_9_0:getPositionX())
end

function UIUtil.updatePetFavLevelText(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0, var_10_1 = arg_10_2:getFavExpString()
	
	if_set(arg_10_1, nil, var_10_0)
end

function UIUtil.updatePetFavBar(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	arg_11_3 = arg_11_3 or {}
	
	local var_11_0 = 500
	local var_11_1, var_11_2 = arg_11_2:getFavExpString(arg_11_3.inc_fav)
	
	if arg_11_3.is_ani then
		UIAction:Add(LOG(PROGRESS(var_11_0, 0, var_11_2)), arg_11_1)
	else
		if_set_percent(arg_11_1, nil, var_11_2)
	end
end

function UIUtil.updatePetFavText(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	local var_12_0 = arg_12_3 or {}
	local var_12_1, var_12_2 = arg_12_2:getFavExpString(var_12_0.inc_fav)
	
	if_set(arg_12_1, nil, var_12_1)
end

function UIUtil.updatePetFavLevel(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	local var_13_0 = arg_13_3 or {}
	local var_13_1 = 1
	
	if arg_13_2 then
		var_13_1 = arg_13_2:getFavLevel()
	elseif var_13_0.fav_level then
		var_13_1 = var_13_0.fav_level
	end
	
	if_set(arg_13_1, nil, tostring(var_13_1))
end

function UIUtil.updatePetFavDesc(arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = arg_14_2:getFavLevel()
	local var_14_1 = "petaff_" .. var_14_0
	local var_14_2 = DB("pet_affection", var_14_1, "name")
	
	if_set(arg_14_1, nil, T(var_14_2))
end

function UIUtil.updatePetFavIcon(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	local var_15_0 = arg_15_3 or {}
	local var_15_1 = 1
	
	if arg_15_2 then
		var_15_1 = arg_15_2:getFavLevel()
	elseif var_15_0.fav_level then
		var_15_1 = var_15_0.fav_level
	end
	
	local var_15_2
	
	if var_15_1 <= 1 then
		var_15_2 = "img/pet_love_icon_1.png"
	elseif var_15_1 <= 3 then
		var_15_2 = "img/pet_love_icon_2.png"
	elseif var_15_1 <= 5 then
		var_15_2 = "img/pet_love_icon_3.png"
	elseif var_15_1 <= 6 then
		var_15_2 = "img/pet_love_icon_4.png"
	end
	
	SpriteCache:resetSprite(arg_15_1, var_15_2)
end

function UIUtil.updatePetRoleIcon(arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = arg_16_2:getType()
	local var_16_1 = "cm_icon_role_pet_" .. var_16_0
	
	if arg_16_2:isFeature() then
		var_16_1 = var_16_1 .. "_s"
	end
	
	local var_16_2 = var_16_1 .. ".png"
	
	if_set_sprite(arg_16_1, nil, var_16_2)
	
	return true
end

function UIUtil.updatePetRoleText(arg_17_0, arg_17_1, arg_17_2)
	local var_17_0 = arg_17_2:getType()
	local var_17_1 = {
		lobby = "pet_type_lobby",
		battle = "pet_type_battle"
	}
	
	if_set(arg_17_1, nil, T(var_17_1[var_17_0]))
	
	return true
end

local function var_0_0(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	local var_18_0 = {
		"d",
		"c",
		"b",
		"a",
		"s"
	}
	
	if arg_18_2 then
		arg_18_2 = arg_18_2 * 100
		
		if arg_18_1.calc_type ~= "sum" then
			arg_18_2 = arg_18_2 * 100
		end
		
		arg_18_2 = arg_18_2 / 100
	end
	
	if_set(arg_18_0, "txt_skill", T(arg_18_1.name, {
		value = arg_18_2
	}))
	if_set_sprite(arg_18_0, "grade_icon", "img/hero_dedi_a_" .. var_18_0[arg_18_3] .. ".png")
end

function UIUtil.updatePetSkillItem(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
	local var_19_0, var_19_1 = PetSkill:getValueByIdx(arg_19_2, arg_19_3)
	local var_19_2 = arg_19_2:getSkillRank(arg_19_3)
	
	var_0_0(arg_19_1, var_19_0, var_19_1, var_19_2)
end

function UIUtil.setPetFixSkillItem(arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
	arg_20_4 = tonumber(arg_20_4)
	
	local var_20_0, var_20_1 = PetSkill:getValueBySkillId(arg_20_2, arg_20_3, arg_20_4)
	
	var_0_0(arg_20_1, var_20_0, var_20_1, arg_20_4)
end

function UIUtil.defaultPetVisibleSetting(arg_21_0, arg_21_1, arg_21_2)
	if_set_visible(arg_21_1, "add", false)
	if_set_visible(arg_21_1, "check", false)
	if_set_visible(arg_21_1, "lock", arg_21_2:isLocked() == true)
end

function UIUtil.updatePetBarPosition(arg_22_0, arg_22_1, arg_22_2)
	local var_22_0 = arg_22_1:findChildByName("detail")
	
	if arg_22_2:isMaxLevel() then
		var_22_0:setPositionX(22)
	else
		var_22_0:setPositionX(0)
	end
end

function UIUtil.updatePetBar(arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4)
	arg_23_1 = arg_23_1 or load_control("wnd/unit_pet_bar.csb")
	
	local var_23_0 = arg_23_4 or {}
	
	if_set_visible(arg_23_1, "badge", var_23_0.is_new)
	
	if var_23_0.is_exist_preview then
		WidgetUtils:setupPopup({
			control = arg_23_1,
			creator = function()
				return UIUtil:getPetPreviewPopup({
					is_fix_skill = false,
					pet = arg_23_3
				})
			end,
			delay = var_23_0.popup_delay
		})
	end
	
	local var_23_1 = arg_23_1:findChildByName("face")
	local var_23_2 = arg_23_1:findChildByName("name")
	local var_23_3 = arg_23_1:findChildByName("n_lv")
	local var_23_4 = arg_23_1:findChildByName("n_stars")
	local var_23_5 = arg_23_1:findChildByName("role")
	
	arg_23_0:defaultPetVisibleSetting(arg_23_1, arg_23_3)
	arg_23_0:updatePetFace(var_23_1, arg_23_3)
	arg_23_0:updatePetName(var_23_2, arg_23_3, true)
	arg_23_0:updatePetLevel(var_23_3, arg_23_3)
	arg_23_0:updatePetStars(var_23_4, arg_23_3)
	arg_23_0:updatePetRoleIcon(var_23_5, arg_23_3)
	arg_23_0:updatePetBarPosition(arg_23_1, arg_23_3)
	
	return arg_23_1
end

function UIUtil.updatePetBarColor(arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4, arg_25_5, arg_25_6)
	arg_25_6 = arg_25_6 or {}
	
	local var_25_0 = arg_25_0.WHITE
	
	if arg_25_2 == "Synthesis" and arg_25_4 and (arg_25_4:getType() ~= arg_25_3:getType() or arg_25_4:getGrade() ~= arg_25_3:getGrade()) then
		var_25_0 = arg_25_0.DARK_GREY
	end
	
	if arg_25_2 == "Synthesis" and not arg_25_3:isCanSynthesis() then
		var_25_0 = arg_25_0.DARK_GREY
	end
	
	if arg_25_6.only_max_lv and not arg_25_3:isMaxLevel() then
		var_25_0 = arg_25_0.DARK_GREY
	end
	
	if arg_25_2 == "Transform" and arg_25_4 and (arg_25_4:getType() ~= arg_25_3:getType() or arg_25_4:getCode() == arg_25_3:getCode()) then
		var_25_0 = arg_25_0.DARK_GREY
	end
	
	if arg_25_6.only_can_remove and not arg_25_3:isCanRemove() then
		var_25_0 = arg_25_0.DARK_GREY
	end
	
	if arg_25_2 == "Transfer" and not arg_25_3:isCanRemove() then
		var_25_0 = arg_25_0.DARK_GREY
	end
	
	arg_25_1:setColor(var_25_0)
end

function UIUtil.updatePetBarStickers(arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4, arg_26_5)
	if_set_visible(arg_26_1, "team", false)
	
	if arg_26_2 ~= "Battle" and arg_26_2 ~= "Lobby" then
		local var_26_0 = Account:isPetEquip(arg_26_3)
		
		if_set_visible(arg_26_1, "team", var_26_0)
	end
	
	if arg_26_2 == "Battle" then
		local var_26_1 = Account:getCurrentTeamIndex()
		
		if_set_visible(arg_26_1, "team", Account:isPetInTeam(arg_26_3, var_26_1))
	end
	
	if arg_26_2 == "Lobby" then
		if_set_visible(arg_26_1, "team", Account:isPetInLobby(arg_26_3))
	end
	
	local var_26_2 = arg_26_3:getHighestSkillRank()
	
	if_set_visible(arg_26_1, "n_hero_dedi", var_26_2 ~= 0)
	
	if var_26_2 ~= 0 then
		local var_26_3 = {
			"d",
			"c",
			"b",
			"a",
			"s"
		}
		
		if_set_sprite(arg_26_1, "grade_icon", "img/hero_dedi_a_" .. var_26_3[var_26_2] .. ".png")
		
		local var_26_4 = arg_26_3:getGrade()
		local var_26_5 = arg_26_1:findChildByName("star" .. var_26_4)
		
		arg_26_1:findChildByName("n_hero_dedi"):setPositionX(var_26_5:getPositionX() + 6)
	end
end

local function var_0_1(arg_27_0)
	local var_27_0 = CACHE:getEffect(arg_27_0)
	
	var_27_0:setAnimation(0, "list", true)
	var_27_0:setPosition(0, 30)
	var_27_0:setScale(0.8)
	
	return var_27_0
end

function UIUtil.updatePetBarEffect(arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5, arg_28_6)
	if arg_28_5 then
		if_set_sprite(arg_28_1, "bg", "img/pet_bg_selected.png")
	else
		if_set_sprite(arg_28_1, "bg", "img/pet_bg_normal.png")
	end
	
	local var_28_0 = arg_28_1:getChildByName("list_tag_exp")
	
	if arg_28_2 == "Upgrade" and arg_28_3:isPetFood() then
		SpriteCache:resetSprite(arg_28_1:getChildByName("bg"), "img/pet_bg_selected.png")
		
		if not var_28_0 then
			local var_28_1 = var_0_1("list_tag_exp")
			
			arg_28_1:addChild(var_28_1)
		end
	elseif var_28_0 then
		var_28_0:removeFromParent()
	end
end

function UIUtil.updatePetBarInfo(arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4, arg_29_5, arg_29_6)
	arg_29_0:updatePetBarColor(arg_29_1, arg_29_2, arg_29_3, arg_29_4, arg_29_5, arg_29_6)
	arg_29_0:updatePetBarStickers(arg_29_1, arg_29_2, arg_29_3, arg_29_4, arg_29_5, arg_29_6)
	arg_29_0:updatePetBarEffect(arg_29_1, arg_29_2, arg_29_3, arg_29_4, arg_29_5, arg_29_6)
end

function UIUtil.updatePetSlotOnSelect(arg_30_0, arg_30_1, arg_30_2)
	if_set_visible(arg_30_1, "selected_btn", true)
	
	local var_30_0 = {
		btn_remove = false,
		btn_add = false,
		btn_change = false,
		btn_team_detail = false
	}
	
	if arg_30_2 == "selected" then
		var_30_0.btn_team_detail = true
		var_30_0.btn_remove = true
	elseif arg_30_2 == "added" then
		var_30_0.btn_add = true
	elseif arg_30_2 == "changed" then
		var_30_0.btn_change = true
	elseif arg_30_2 == "normal" then
	end
	
	for iter_30_0, iter_30_1 in pairs(var_30_0) do
		if_set_visible(arg_30_1, iter_30_0, iter_30_1)
	end
end

function UIUtil.updatePetInfo(arg_31_0, arg_31_1, arg_31_2, arg_31_3)
	arg_31_3 = arg_31_3 or {}
	
	local var_31_0 = arg_31_3.n_stars or "n_stars"
	local var_31_1 = arg_31_3.n_lv or "n_lv"
	local var_31_2 = arg_31_3.role or "role"
	local var_31_3 = arg_31_1:findChildByName(var_31_1)
	local var_31_4 = arg_31_1:findChildByName(var_31_0)
	local var_31_5 = arg_31_1:findChildByName(var_31_2)
	
	arg_31_0:updatePetLevel(var_31_3, arg_31_2, arg_31_3)
	arg_31_0:updatePetStars(var_31_4, arg_31_2)
	arg_31_0:updatePetRoleIcon(var_31_5, arg_31_2)
	
	return true
end

function UIUtil.updatePetSlot(arg_32_0, arg_32_1, arg_32_2, arg_32_3)
	arg_32_3 = arg_32_3 or {}
	
	local var_32_0 = arg_32_3.n_lv or "n_lv"
	local var_32_1 = arg_32_3.role or "role"
	local var_32_2 = arg_32_1:findChildByName(var_32_0)
	local var_32_3 = arg_32_1:findChildByName(var_32_1)
	
	arg_32_0:updatePetLevel(var_32_2, arg_32_2, arg_32_3)
	arg_32_0:updatePetRoleIcon(var_32_3, arg_32_2)
	
	return true
end

function UIUtil.updatePetIcon2(arg_33_0, arg_33_1, arg_33_2, arg_33_3)
	arg_33_3 = arg_33_3 or {}
	arg_33_1 = arg_33_1 or load_control("wnd/pet_icon2.csb")
	
	arg_33_1:setAnchorPoint(0.5, 0.5)
	
	arg_33_3.use_in_icon = true
	
	UIUtil:updatePetInfo(arg_33_1, arg_33_2, arg_33_3)
	
	return arg_33_1
end

function UIUtil.updatePetNameInfo(arg_34_0, arg_34_1, arg_34_2)
	arg_34_0:updatePetName(arg_34_1:findChildByName("txt_name"), arg_34_2)
	arg_34_0:updatePetInfo(arg_34_1, arg_34_2, {
		n_stars = "star1"
	})
	arg_34_0:updatePetStarsPosition(arg_34_1, arg_34_1:findChildByName("txt_name"))
	arg_34_0:updatePetRoleText(arg_34_1:findChildByName("txt_role"), arg_34_2)
end

function UIUtil.updatePetUpgradeInfo(arg_35_0, arg_35_1, arg_35_2)
	arg_35_0:updatePetName(arg_35_1:findChildByName("txt_name"), arg_35_2)
	arg_35_0:updatePetInfo(arg_35_1, arg_35_2)
	arg_35_0:updatePetRoleText(arg_35_1:findChildByName("txt_role"), arg_35_2)
end

function UIUtil.updatePetMainInfo(arg_36_0, arg_36_1, arg_36_2, arg_36_3)
	arg_36_0:updatePetLevel(arg_36_1:findChildByName("n_lv"), arg_36_2, arg_36_3)
	arg_36_0:updatePetExpInfos(arg_36_1:findChildByName("n_exp_detail"), arg_36_2, arg_36_3)
	arg_36_0:updatePetStory(arg_36_1:findChildByName("txt_story"), arg_36_2, arg_36_3)
end

function UIUtil.updatePetFavInfos(arg_37_0, arg_37_1, arg_37_2, arg_37_3)
	arg_37_3 = arg_37_3 or {}
	
	local var_37_0 = arg_37_3.exp_gauge or "exp_gauge"
	local var_37_1 = arg_37_3.txt_exp or "txt_exp"
	local var_37_2 = arg_37_3.txt_level or "txt_level"
	local var_37_3 = arg_37_3.txt_desc or "txt_desc"
	local var_37_4 = arg_37_3.icon or "icon"
	
	arg_37_0:updatePetFavBar(arg_37_1:findChildByName(var_37_0), arg_37_2, arg_37_3)
	arg_37_0:updatePetFavText(arg_37_1:findChildByName(var_37_1), arg_37_2, arg_37_3)
	arg_37_0:updatePetFavLevel(arg_37_1:findChildByName(var_37_2), arg_37_2, arg_37_3)
	arg_37_0:updatePetFavDesc(arg_37_1:findChildByName(var_37_3), arg_37_2)
	arg_37_0:updatePetFavIcon(arg_37_1:findChildByName(var_37_4), arg_37_2, arg_37_3)
end

function UIUtil.setLoveEffect(arg_38_0, arg_38_1, arg_38_2, arg_38_3)
	local var_38_0 = arg_38_3:getFavLevel() or 1
	local var_38_1 = get_cocos_refid(arg_38_1)
	
	if var_38_0 >= 5 and not var_38_1 then
		local var_38_2 = arg_38_2:getBoneNode("top")
		
		return EffectManager:Play({
			fn = "ui_pet_love.cfx",
			layer = var_38_2
		})
	elseif var_38_1 then
		arg_38_1:removeFromParent()
	end
	
	return nil
end

function UIUtil.setPetGiftInfo(arg_39_0, arg_39_1, arg_39_2, arg_39_3)
	local var_39_0 = "n_gift" or arg_39_3.node
	local var_39_1 = arg_39_1:getChildByName(var_39_0)
	
	if not get_cocos_refid(var_39_1) then
		return 
	end
	
	if arg_39_2:getType() == PET_TYPE.BATTLE then
		if_set_visible(var_39_1, nil, false)
		
		return 
	end
	
	if_set_visible(var_39_1, nil, true)
	
	local var_39_2 = arg_39_2:getGiftTime()
	local var_39_3 = arg_39_2:getGiftItemID()
	
	if_set(var_39_1, "txt_info", T("ui_pet_config_popup_gift_time", {
		time = sec_to_full_string(var_39_2)
	}))
	
	local var_39_4 = (Account:getPetSlots().present_tm or 0) + var_39_2 - os.time()
	
	if_set(var_39_1, "txt_time", T("ui_pet_config_popup_gift_remain", {
		time = sec_to_full_string(var_39_4)
	}))
end

function UIUtil.setPet_previewIcons(arg_40_0, arg_40_1, arg_40_2, arg_40_3)
	if not get_cocos_refid(arg_40_1) or not arg_40_2 then
		return 
	end
	
	local var_40_0 = arg_40_3 or {}
	
	if_set_visible(arg_40_1, "n_pet", true)
	
	for iter_40_0 = 1, 6 do
		local var_40_1
		local var_40_2 = 0
		
		if not arg_40_2[iter_40_0] then
			return 
		end
		
		if var_40_0.firend then
			var_40_2 = arg_40_2[iter_40_0].grade
			var_40_1 = arg_40_2[iter_40_0].code
		else
			local var_40_3 = Account:getPet(arg_40_2[iter_40_0])
			
			if not var_40_3 then
				return 
			end
			
			var_40_2 = var_40_3:getGrade()
			var_40_1 = var_40_3:getCode()
		end
		
		UIUtil:getRewardIcon(nil, var_40_1, {
			parent = arg_40_1:getChildByName("n_pet" .. iter_40_0),
			grade = var_40_2
		})
	end
end

function UIUtil.getPetModel(arg_41_0, arg_41_1, arg_41_2)
	if not arg_41_1 then
		return nil
	end
	
	arg_41_2 = arg_41_2 or arg_41_1:getGrade()
	
	local var_41_0 = arg_41_1.db["model_" .. arg_41_2]
	
	return (CACHE:getModel(var_41_0))
end

function UIUtil.getTypeIconPath(arg_42_0, arg_42_1, arg_42_2)
	local var_42_0 = "cm_icon_role_pet_" .. arg_42_1
	
	if arg_42_2 == "y" then
		var_42_0 = var_42_0 .. "_s"
	end
	
	return var_42_0 .. ".png"
end

function UIUtil.setPetPreviewInfoUI(arg_43_0, arg_43_1, arg_43_2, arg_43_3)
	if not arg_43_2 or not arg_43_1 then
		return 
	end
	
	arg_43_3 = arg_43_3 or {}
	
	local var_43_0 = arg_43_1
	local var_43_1 = var_43_0:getChildByName("CENTER")
	local var_43_2 = var_43_0:getChildByName("n_skill_pet")
	
	var_43_1:setVisible(false)
	
	local var_43_3 = var_43_1
	
	if arg_43_3.preview then
		local var_43_4
		
		if arg_43_3.is_fix_skill then
			var_43_4 = PetSkill:getSkilFixData(arg_43_2:getCode())
		else
			var_43_4 = PetSkillList:getPetSkillList(arg_43_2)
		end
		
		if var_43_4 and not table.empty(var_43_4) then
			var_43_3 = var_43_2
			
			for iter_43_0 = 1, 3 do
				if not var_43_4[iter_43_0] then
					break
				end
				
				if var_43_4[iter_43_0].rank ~= 0 or var_43_4[iter_43_0].skill_lv ~= 0 then
					local var_43_5 = load_dlg("gacha_pet_get_item", true, "wnd")
					
					var_43_3:getChildByName("n_skill" .. iter_43_0):addChild(var_43_5)
					var_43_5:setPosition(0 + var_43_5:getContentSize().width / 2, 0 - var_43_5:getContentSize().height / 2)
					
					if arg_43_3.is_fix_skill then
						UIUtil:setPetFixSkillItem(var_43_5, arg_43_2, var_43_4[iter_43_0].id, var_43_4[iter_43_0].rank)
					else
						UIUtil:updatePetSkillItem(var_43_5, arg_43_2, iter_43_0)
					end
				end
			end
		end
		
		if_set_visible(var_43_1, nil, var_43_4 == nil)
		
		local var_43_6 = T("pet_info_race", {
			race = T(arg_43_2:getRace())
		}) .. "\n" .. T(arg_43_2:getDesc())
		
		if_set(var_43_3, "txt_story", var_43_6)
	end
	
	if false then
	end
	
	if_set_visible(var_43_3, nil, true)
	
	local var_43_7 = var_43_3:getChildByName("txt_name")
	
	var_43_7:setString(arg_43_2:getName())
	UIUserData:proc(var_43_7)
	if_call(var_43_3, "star1", "setPositionX", 10 + var_43_7:getContentSize().width * var_43_7:getScaleX() + var_43_7:getPositionX())
	UIUtil:updatePetRoleIcon(var_43_3:getChildByName("role"), arg_43_2)
	UIUtil:updatePetRoleText(var_43_3:getChildByName("txt_role"), arg_43_2)
	
	for iter_43_1 = 1, 6 do
		if_set_visible(var_43_3, "star" .. iter_43_1, false)
	end
	
	local var_43_8 = arg_43_2:getGrade()
	
	for iter_43_2 = 1, var_43_8 do
		if_set_visible(var_43_3, "star" .. iter_43_2, true)
	end
	
	local var_43_9 = arg_43_2:getModelID()
	local var_43_10 = CACHE:getModel(var_43_9, nil, "idle", nil, nil)
	
	var_43_3:getChildByName("n_pos"):addChild(var_43_10)
	
	return var_43_0
end

function UIUtil.setUIUpgradeChance(arg_44_0, arg_44_1, arg_44_2, arg_44_3, arg_44_4)
	local var_44_0 = math.min((arg_44_2 + arg_44_3) * 100, 100)
	local var_44_1 = math.min(arg_44_3 * 100, 100 - arg_44_2 * 100)
	
	if_set(arg_44_1, "txt_count_total", var_44_0 .. "%")
	if_set(arg_44_1, "txt_count_add", "(+" .. var_44_1 .. "%)")
	
	local var_44_2 = (arg_44_2 + arg_44_3) * 100
	local var_44_3 = arg_44_1:findChildByName("txt_count_add")
	
	if not var_44_3 or not arg_44_4 then
		return 
	end
	
	var_44_3.origin_pos_x = var_44_3.origin_pos_x or var_44_3:getPositionX()
	
	if string.len(tostring(var_44_2)) > 2 then
		var_44_3:setPositionX(var_44_3.origin_pos_x + arg_44_4)
	else
		var_44_3:setPositionX(var_44_3.origin_pos_x)
	end
end

function UIUtil.getPetPreviewPopup(arg_45_0, arg_45_1)
	arg_45_1 = arg_45_1 or {}
	
	local var_45_0 = arg_45_1.code
	local var_45_1 = arg_45_1.grade or DB("pet_character", var_45_0, {
		"grade"
	})
	
	arg_45_1.preview = true
	
	local var_45_2 = arg_45_1.pet or {}
	
	if arg_45_1.is_fix_skill then
		var_45_2 = PET:create({
			id = -99,
			code = arg_45_1.code,
			grade = var_45_1
		})
	end
	
	local var_45_3 = load_dlg("pet_preview", true, "wnd")
	
	return (arg_45_0:setPetPreviewInfoUI(var_45_3, var_45_2, arg_45_1))
end

function UIUtil.getPetDetailPopup(arg_46_0, arg_46_1)
	arg_46_1 = arg_46_1 or {}
	
	return (GachaPet:showRewardResult(arg_46_1.pet, {
		show_no_btn = true,
		no_eff = true,
		detail_popup = true
	}))
end
