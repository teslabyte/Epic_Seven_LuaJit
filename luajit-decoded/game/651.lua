UnitExtension = {}

function MsgHandler.unit_attribute_change(arg_1_0)
	local var_1_0 = DB("character", Account:getUnit(arg_1_0.unit.id).db.code, "ch_attribute")
	
	Account:unitAttributeChange(arg_1_0.unit)
	
	local var_1_1 = DB("character", arg_1_0.unit.code, "ch_attribute")
	
	if arg_1_0.unit_extension_doc then
		Account:updateUnitExtension(arg_1_0.unit_extension_doc)
	end
	
	Account:addReward(arg_1_0.result)
	UnitExtension:updateAttributeChangeUI(arg_1_0, var_1_1, var_1_0)
	EpisodeAdinUI:closeCharacterPopUp()
end

function UnitExtension.updateAttributeChangeUI(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = Account:getUnit(arg_2_1.unit.id)
	
	UnitDetail:updateUnitInfo(var_2_0, true)
	UnitExtensionUI:close()
	UnitExtensionUI:openChangeResult(arg_2_1.unit.code, arg_2_2, arg_2_3)
	
	local var_2_1 = HeroBelt:getInst("UnitMain")
	
	if var_2_1 then
		var_2_1:updateUnit(nil, var_2_0)
	end
end

function UnitExtension.getAttributeChange(arg_3_0, arg_3_1)
	local var_3_0 = DBT("character_attribute_change", arg_3_1, {
		"id",
		"skill_tree",
		"attr_change_unlock_value",
		"change_attr_group",
		"change_attr_material"
	})
	
	if not var_3_0 or table.count(var_3_0) <= 0 then
		return false
	end
	
	if var_3_0.change_attr_group then
		var_3_0.change_attr_group = string.split(var_3_0.change_attr_group, ";")
	end
	
	if var_3_0.change_attr_material then
		var_3_0.change_attr_material = string.split(var_3_0.change_attr_material, ";")
	end
	
	return var_3_0
end

function UnitExtension.changeAttribute(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = arg_4_0:isChangeableTarget(arg_4_1, arg_4_2)
	local var_4_1 = arg_4_0:getAttributeChange(arg_4_1)
	
	if var_4_0 then
		if var_4_1.change_attr_material == nil or Account:getItemCount(var_4_1.change_attr_material[1]) >= to_n(var_4_1.change_attr_material[2]) then
			query("unit_attribute_change", {
				unit_id = arg_4_2.inst.uid,
				code = arg_4_1
			})
		else
			balloon_message_with_sound("need_token")
			
			return 
		end
	else
		balloon_message_with_sound("msg_cannot_change_attr")
		
		return 
	end
end

function UnitExtension.isAttributeUnlocked(arg_5_0, arg_5_1)
	local var_5_0, var_5_1 = DB("character_attribute_change", arg_5_1, {
		"attr_change_unlock_type",
		"attr_change_unlock_value"
	})
	
	if var_5_0 == "adin" then
		local var_5_2 = Account:getAdinChapterByID(var_5_1)
		
		return var_5_2 and var_5_2.state == ADIN_CHAPTER_STATE.COMPLETE
	end
end

function UnitExtension.openSkillUpgradeUnlockMsgbox(arg_6_0, arg_6_1)
	local var_6_0 = DB("character_attribute_change", arg_6_1, {
		"skill_upgrade_unlock_msg"
	})
	
	if var_6_0 then
		return Dialog:msgBox(T(var_6_0), {
			title = T("skill_upgrade_unlock_title")
		})
	end
end

function UnitExtension.isSkillUpgradeUnlocked(arg_7_0, arg_7_1)
	if arg_7_0:isAttrChangeableUnit(arg_7_1) then
		local var_7_0, var_7_1 = DB("character_attribute_change", arg_7_1, {
			"skill_upgrade_unlock_type",
			"skill_upgrade_unlock_value"
		})
		
		if var_7_0 == "adin" then
			local var_7_2 = Account:getAdinChapterByID(var_7_1)
			
			return var_7_2 and var_7_2.state == ADIN_CHAPTER_STATE.COMPLETE
		end
	end
end

function UnitExtension.getAttributeChangeUnit(arg_8_0, arg_8_1)
	if DB("character_attribute_change", arg_8_1, {
		"attr_change_unlock_type"
	}) == "adin" then
		return Account:getAdin()
	end
end

function UnitExtension.isAttrChangeableUnit(arg_9_0, arg_9_1)
	return DB("character_attribute_change", arg_9_1, {
		"id"
	}) ~= nil
end

function UnitExtension.isChangeableTarget(arg_10_0, arg_10_1, arg_10_2)
	arg_10_2 = arg_10_2 or arg_10_0:getAttributeChangeUnit(arg_10_1)
	
	if not arg_10_2 then
		return 
	end
	
	local var_10_0 = DB("character_attribute_change", arg_10_2.db.code, {
		"change_attr_group"
	})
	
	if not var_10_0 then
		return 
	end
	
	for iter_10_0, iter_10_1 in pairs(string.split(var_10_0, ";")) do
		if iter_10_1 == arg_10_1 then
			return true
		end
	end
	
	return false
end

function UnitExtension.getSkillTreeDB(arg_11_0, arg_11_1)
	return DB("character_attribute_change", arg_11_1, {
		"skill_tree"
	})
end

function UnitExtension.getSkillTree(arg_12_0, arg_12_1)
	local var_12_0 = arg_12_0:getAttributeChangeUnit(arg_12_1)
	local var_12_1 = arg_12_0:getSkillTreeDB(arg_12_1)
	
	if not var_12_0 or not var_12_1 then
		return 
	end
	
	return Account:getSkillTreeFromExtension(var_12_0.inst.uid, var_12_1)
end

function UnitExtension.getSTreeTotalPoint(arg_13_0, arg_13_1)
	local var_13_0 = arg_13_0:getSkillTree(arg_13_1)
	
	if not var_13_0 then
		return 0
	end
	
	local var_13_1 = 0
	
	for iter_13_0, iter_13_1 in pairs(var_13_0) do
		var_13_1 = var_13_1 + iter_13_1
	end
	
	return var_13_1
end

UnitExtensionUI = {}

function HANDLER.adin_property_change(arg_14_0, arg_14_1)
	if arg_14_1 == "btn_cancel" then
		Dialog:close("adin_property_change")
	elseif arg_14_1 == "btn_yes" then
		local var_14_0 = UnitExtension:getAttributeChangeUnit(arg_14_0.code)
		
		if not var_14_0 then
			return 
		end
		
		UnitExtension:changeAttribute(arg_14_0.code, var_14_0)
	end
end

function HANDLER.adin_property_change_confirm(arg_15_0, arg_15_1)
	if arg_15_1 == "btn_close" then
		Dialog:close("adin_property_change_confirm")
	end
end

function UnitExtensionUI.show(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	arg_16_3 = arg_16_3 or {}
	
	local var_16_0 = UnitExtension:getAttributeChange(arg_16_1)
	local var_16_1 = UnitExtension:getAttributeChangeUnit(arg_16_1)
	
	if not var_16_0 or not var_16_1 then
		return 
	end
	
	local var_16_2 = Dialog:open("wnd/adin_property_change", arg_16_0)
	local var_16_3 = DB("character", var_16_1.db.code, {
		"ch_attribute"
	})
	local var_16_4 = var_16_2:getChildByName("pro_before")
	local var_16_5 = var_16_2:getChildByName("pro_after")
	
	for iter_16_0, iter_16_1 in pairs(var_16_4:getChildren()) do
		iter_16_1:setVisible(iter_16_1:getName() == "icon_" .. var_16_3)
	end
	
	for iter_16_2, iter_16_3 in pairs(var_16_5:getChildren()) do
		iter_16_3:setVisible(iter_16_3:getName() == "icon_" .. var_16_0.skill_tree)
	end
	
	if_set_visible(var_16_4, "t_disc", true)
	if_set_visible(var_16_5, "t_disc", true)
	if_set(var_16_4, "t_disc", T("hero_ele_" .. var_16_3))
	if_set(var_16_5, "t_disc", T("hero_ele_" .. var_16_0.skill_tree))
	
	if var_16_0.change_attr_material then
		local var_16_6, var_16_7 = DB("item_material", var_16_0.change_attr_material[1], {
			"drop_icon",
			"name"
		})
		
		if_set(var_16_2, "txt_desc_top", T("ui_adin_property_change_desc", {
			material_name = T(var_16_7)
		}))
		
		local var_16_8 = var_16_2:getChildByName("btn_yes")
		
		if get_cocos_refid(var_16_8) then
			var_16_8.code = arg_16_1
			
			if_set_sprite(var_16_8, "icon_res", "item/" .. var_16_6 .. ".png")
			if_set(var_16_8, "cost", var_16_0.change_attr_material[2] or 0)
		end
	end
	
	arg_16_2:addChild(var_16_2)
	
	if arg_16_3.force_front_show then
		var_16_2:bringToFront()
	end
end

function UnitExtensionUI.openChangeResult(arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	local function var_17_0(arg_18_0)
		arg_17_0.popup_dlg = Dialog:open("wnd/adin_property_change_confirm", arg_18_0, {
			back_func = function()
				BackButtonManager:pop("Dialog.adin_property_change_confirm")
				arg_17_0.popup_dlg:removeFromParent()
				
				if UnitExtension:isAttrChangeableUnit(Account:getMainUnitCode()) then
					local var_19_0 = SceneManager:getCurrentSceneName()
					
					if table.isInclude({
						"worldmap_scene",
						"world_sub",
						"world_custom"
					}, var_19_0) then
						Dialog:msgBox(T("refresh_adin_next.no_desc"), {
							title = T("refresh_adin_next.no_title"),
							handler = function()
								SceneManager:nextScene("lobby")
							end
						})
					end
				end
			end
		})
		
		if_set_visible(arg_17_0.popup_dlg, "n_element", true)
		if_set_visible(arg_17_0.popup_dlg, "element_frame", true)
		
		if arg_17_2 and arg_17_3 then
			local var_18_0 = arg_17_0.popup_dlg:getChildByName("n_center")
			
			var_18_0:setVisible(true)
			
			local var_18_1 = arg_17_0.popup_dlg:getChildByName("n_" .. arg_17_3)
			local var_18_2, var_18_3 = UIUtil:getPortraitAni(arg_17_1, {
				parent_pos_y = var_18_1:getPositionY()
			})
			
			if var_18_2 then
				var_18_1:removeAllChildren()
				var_18_1:addChild(var_18_2)
				
				if not var_18_3 then
					var_18_2:setAnchorPoint(0.5, 0.15)
				end
				
				var_18_2:setScale(0.8)
			end
			
			local var_18_4 = var_18_0:getChildByName("pro_before")
			local var_18_5 = var_18_0:getChildByName("pro_after")
			
			for iter_18_0, iter_18_1 in pairs(var_18_4:getChildren()) do
				iter_18_1:setVisible(iter_18_1:getName() == "icon_" .. arg_17_3)
			end
			
			for iter_18_2, iter_18_3 in pairs(var_18_5:getChildren()) do
				iter_18_3:setVisible(iter_18_3:getName() == "icon_" .. arg_17_2)
			end
			
			if_set_visible(var_18_4, "t_disc", true)
			if_set_visible(var_18_5, "t_disc", true)
			if_set(var_18_4, "t_disc", T("hero_ele_" .. arg_17_3))
			if_set(var_18_5, "t_disc", T("hero_ele_" .. arg_17_2))
		end
		
		if_set_arrow(arg_17_0.popup_dlg)
		if_set_opacity(arg_17_0.popup_dlg, nil, 0)
		arg_18_0:addChild(arg_17_0.popup_dlg)
		UIAction:Add(FADE_IN(200), arg_17_0.popup_dlg, "block")
		EffectManager:Play({
			fn = "ui_reward_popup_eff.cfx",
			delay = 100,
			pivot_z = 99998,
			layer = arg_18_0,
			pivot_x = DESIGN_WIDTH / 2,
			pivot_y = DESIGN_HEIGHT / 2
		})
	end
	
	local var_17_1 = "character_attribute_change_effect.cfx"
	local var_17_2 = SceneManager:getRunningPopupScene()
	local var_17_3 = EffectManager:Play({
		z = 99999,
		fn = var_17_1,
		layer = SceneManager:getRunningUIScene(),
		x = DESIGN_WIDTH / 2,
		y = DESIGN_HEIGHT / 2
	})
	local var_17_4 = ccui.Button:create()
	
	var_17_4:setTouchEnabled(true)
	var_17_4:ignoreContentAdaptWithSize(false)
	var_17_4:setContentSize(VIEW_WIDTH, VIEW_HEIGHT)
	var_17_4:setPosition(VIEW_BASE_LEFT, 0)
	var_17_4:setAnchorPoint(0, 0)
	var_17_4:setLocalZOrder(-1)
	var_17_4:setName("btn_block")
	var_17_2:addChild(var_17_4)
	var_17_4:bringToFront()
	UIAction:Add(SEQ(DELAY(3400), CALL(var_17_0, var_17_2), DELAY(1000), TARGET(var_17_4, REMOVE()), TARGET(var_17_3, REMOVE()), REMOVE()), arg_17_0, "block")
end

function UnitExtensionUI.openUnlockResult(arg_21_0, arg_21_1, arg_21_2)
	arg_21_2 = arg_21_2 or {}
	arg_21_2.code = arg_21_1
	
	local function var_21_0(arg_22_0, arg_22_1)
		local var_22_0 = Dialog:open("wnd/adin_property_change_confirm", arg_22_0, {
			back_func = function()
				UIAction:Add(SEQ(FADE_OUT(300), REMOVE()), arg_22_0, "block")
				EpisodeAdinUI:onUpdateUI({
					first_get_adin_type = arg_21_1
				})
				
				if arg_22_1.tutorial_start then
					EpisodeAdinUI:closeMissionScroll()
					TutorialGuide:startGuide("tuto_adin_awake_3", nil, {
						force_front = true
					})
				end
			end
		})
		
		var_22_0:setPosition(DESIGN_WIDTH / 2 + 1000, DESIGN_HEIGHT / 2 + 1000)
		
		local var_22_1 = DB("character", arg_21_1, "ch_attribute")
		
		if var_22_1 then
			local var_22_2 = var_22_0:getChildByName("n_" .. var_22_1)
			local var_22_3, var_22_4 = UIUtil:getPortraitAni(arg_21_1, {
				parent_pos_y = var_22_2:getPositionY()
			})
			
			if var_22_3 then
				var_22_2:removeAllChildren()
				var_22_2:addChild(var_22_3)
				
				if not var_22_4 then
					var_22_3:setAnchorPoint(0.5, 0.15)
				end
				
				var_22_3:setScale(0.8)
			end
			
			if_set_visible(var_22_0, "n_element", true)
			if_set_visible(var_22_0, "element_frame", true)
			if_set(var_22_0, "txt_desc", T(arg_21_2.desc or "awaken_adin_attribute_unlock_desc"))
			if_set(var_22_0, "txt_title", T(arg_21_2.title or "awaken_adin_attribute_unlock_title"))
			if_set_visible(var_22_0, "n_liberation", true)
			if_set(var_22_0:getChildByName("n_pro"), "t_disc", T("hero_ele_" .. var_22_1))
			if_set_visible(var_22_0:getChildByName("n_pro"), "icon_" .. var_22_1, true)
		end
		
		if_set_visible(var_22_0, "n_eff_common", true)
		if_set_arrow(var_22_0)
		arg_22_0:addChild(var_22_0)
		EffectManager:Play({
			pivot_x = 0,
			fn = "ui_reward_popup_eff.cfx",
			pivot_y = 0,
			pivot_z = 99998,
			layer = var_22_0:getChildByName("n_eff_common")
		})
	end
	
	arg_21_0:showUnlockEffect(var_21_0, arg_21_2)
end

function UnitExtensionUI.openAwakenResult(arg_24_0, arg_24_1, arg_24_2)
	arg_24_2 = arg_24_2 or {}
	arg_24_2.code = arg_24_1
	
	local function var_24_0(arg_25_0, arg_25_1)
		local var_25_0 = Dialog:open("wnd/adin_property_change_confirm", arg_25_0, {
			back_func = function()
				UIAction:Add(SEQ(FADE_OUT(300), REMOVE()), arg_25_0, "block")
				EpisodeAdinUI:onUpdateUI({
					first_get_adin_type = arg_24_1
				})
			end
		})
		
		var_25_0:setPosition(DESIGN_WIDTH / 2 + 1000, DESIGN_HEIGHT / 2 + 1000)
		
		local var_25_1 = var_25_0:getChildByName("n_skill")
		local var_25_2 = DB("character", arg_24_1, "ch_attribute")
		
		if get_cocos_refid(var_25_1) then
			local var_25_3 = var_25_0:getChildByName("n_" .. var_25_2)
			local var_25_4, var_25_5 = UIUtil:getPortraitAni(arg_24_1, {
				parent_pos_y = var_25_3:getPositionY()
			})
			
			if var_25_4 then
				var_25_3:removeAllChildren()
				var_25_3:addChild(var_25_4)
				
				if not var_25_5 then
					var_25_4:setAnchorPoint(0.5, 0.15)
				end
				
				var_25_4:setScale(0.8)
			end
			
			if_set_visible(var_25_0, "skill_frame", true)
			if_set_visible(var_25_1, nil, true)
			if_set(var_25_1, "txt_desc", T(arg_24_2.desc or "awaken_adin_class_desc"))
			if_set(var_25_1, "txt_title", T(arg_24_2.title or "awaken_adin_class_title"))
			
			local var_25_6 = var_25_1:getChildByName("skill_01")
			local var_25_7 = var_25_1:getChildByName("skill_02")
			local var_25_8 = UNIT:create({
				z = 0,
				code = Account:getAdin().db.set_group
			})
			local var_25_9 = UNIT:create({
				z = 0,
				code = arg_24_1
			})
			local var_25_10 = arg_24_2.change_skill or 3
			local var_25_11 = var_25_8:getSkillByIndex(var_25_10)
			local var_25_12 = var_25_9:getSkillByIndex(var_25_10)
			
			UIUtil:getSkillDetail(var_25_8, var_25_11, {
				ignore_check = true,
				wnd = var_25_6,
				skill_id = var_25_11
			})
			UIUtil:getSkillDetail(var_25_9, var_25_12, {
				ignore_check = true,
				wnd = var_25_7,
				skill_id = var_25_12
			})
		end
		
		if_set_visible(var_25_1, "n_eff_common", true)
		if_set_arrow(var_25_1)
		arg_25_0:addChild(var_25_0)
		EffectManager:Play({
			pivot_x = 0,
			fn = "ui_reward_popup_eff.cfx",
			pivot_y = 0,
			pivot_z = 99998,
			layer = var_25_1:getChildByName("n_effect")
		})
	end
	
	arg_24_0:showUnlockEffect(var_24_0, arg_24_2)
end

function UnitExtensionUI.showUnlockEffect(arg_27_0, arg_27_1, arg_27_2)
	arg_27_2 = arg_27_2 or {}
	
	local var_27_0 = arg_27_2.code or "c3143"
	local var_27_1 = "adin_effect_attribute_get.cfx"
	local var_27_2 = SceneManager:getRunningPopupScene()
	local var_27_3 = cc.LayerColor:create(cc.c3b(0, 0, 0))
	
	var_27_3:setContentSize(9999, 9999)
	var_27_3:setAnchorPoint(0.5, 0.5)
	var_27_3:setPosition(-1000, -1000)
	var_27_3:setOpacity(0)
	var_27_2:addChild(var_27_3)
	var_27_3:bringToFront()
	var_27_3:setCascadeOpacityEnabled(true)
	var_27_3:setTouchEnabled(true)
	
	local var_27_4 = ccui.Button:create()
	
	var_27_4:setTouchEnabled(true)
	var_27_4:ignoreContentAdaptWithSize(false)
	var_27_4:setContentSize(9999, 9999)
	var_27_4:setPosition(0, 0)
	var_27_3:addChild(var_27_4)
	UIAction:Add(SEQ(SPAWN(CALL(function()
		SoundEngine:play("event:/effect/awaken_adin_enter_close")
	end), DELAY(250), CALL(function()
		local var_29_0 = EffectManager:Play({
			fn = "awaken_adin_enter_all.cfx",
			pivot_z = 997,
			layer = var_27_3,
			x = DESIGN_WIDTH / 2 + 1000,
			y = VIEW_HEIGHT / 2 + 1000
		})
		
		EffectManager:Play({
			pivot_z = 999,
			fn = var_27_1,
			layer = var_27_3,
			x = DESIGN_WIDTH / 2 + 1000,
			y = DESIGN_HEIGHT / 2 + 1000
		}):setGlobalZOrder(99999)
		var_29_0:setLocalZOrder(0)
	end), FADE_IN(150)), CALL(function()
		SoundEngine:play("event:/effect/awaken_adin_enter_open")
	end), DELAY(500), CALL(function()
		local var_31_0 = EpisodeAdinUI:initLongBackBoard(var_27_0, {
			invisible_info = true
		})
		
		var_31_0:setPosition(1480, 1000)
		var_31_0:setName("adin")
		var_27_3:addChild(var_31_0)
		EpisodeAdinUI:scrollToLeft()
	end), DELAY(3000), CALL(arg_27_1, var_27_3, arg_27_2)), var_27_3, "block")
end

function UnitExtensionUI.close(arg_32_0)
	Dialog:close("adin_property_change")
end
