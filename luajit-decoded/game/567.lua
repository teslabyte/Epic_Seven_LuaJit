InventoryPopupDetail = {}

function MsgHandler.recall_equip_preview(arg_1_0)
	if arg_1_0.reward_confirm then
		InventoryPopupDetail:previewRecallEquip(arg_1_0.reward_confirm)
	end
end

function MsgHandler.recall_equip(arg_2_0)
	InventoryPopupDetail:processRecallEquip(arg_2_0)
end

function HANDLER.artifact_detail_sub_popup(arg_3_0, arg_3_1)
	if arg_3_1 == "btn_zoom" then
		InventoryPopupDetail:onZoom()
	end
end

function HANDLER.inventory_equip_popup(arg_4_0, arg_4_1, arg_4_2)
	if arg_4_1 == "btn_close" then
		InventoryPopupDetail:Close()
	elseif arg_4_1 == "btn_unequip" then
		InventoryPopupDetail:onUnEquip()
	elseif arg_4_1 == "btn_upgrade" then
		InventoryPopupDetail:openUpgradePopup()
	elseif arg_4_1 == "btn_private_store" then
		InventoryPopupDetail:sendToAlchemy()
	elseif arg_4_1 == "btn_op_change" then
		InventoryPopupDetail:openOptionChangePopup()
	elseif arg_4_1 == "btn_extract" then
		InventoryPopupDetail:onExtract()
	elseif arg_4_1 == "btn_change" then
		InventoryPopupDetail:openWearPopup()
	elseif arg_4_1 == "btn_i_lock" then
		local var_4_0 = InventoryPopupDetail.vars.equip.list_type == "storage" and 1 or nil
		
		InventoryPopupDetail:reqLock(var_4_0)
	elseif arg_4_1 == "btn_i_locked" then
		local var_4_1 = InventoryPopupDetail.vars.equip.list_type == "storage" and 1 or nil
		
		InventoryPopupDetail:reqLock(var_4_1)
	elseif arg_4_1 == "btn_delete" then
		InventoryPopupDetail:onDelete()
	elseif arg_4_1 == "btn_recall" then
		InventoryPopupDetail:requestPreviewRecallEquip()
	elseif arg_4_1 == "btn_equip_arti" then
		if ContentDisable:byAlias("eq_arti_statistics") then
			balloon_message(T("content_disable"))
		elseif InventoryPopupDetail:getEquip():isArtifact() then
			Stove:openArtifactUsagePage(InventoryPopupDetail:getEquip().code)
		end
	elseif arg_4_1 == "btn_eq_storage" then
		InventoryPopupDetail:onStorage()
	elseif arg_4_1 == "btn_reforge" then
		InventoryPopupDetail:openReforgePopup()
	elseif arg_4_1 == "btn_share" then
		InventoryPopupDetail:shareEquip()
	elseif arg_4_1 == "btn_close_share" then
		ShareChatPopup:close()
	end
end

HANDLER.inventory_artifact_popup = HANDLER.inventory_equip_popup

function InventoryPopupDetail.IsOpen(arg_5_0)
	return arg_5_0.vars ~= nil and arg_5_0.vars.dlg ~= nil
end

function InventoryPopupDetail.Open(arg_6_0, arg_6_1, arg_6_2)
	if arg_6_0.vars and get_cocos_refid(arg_6_0.vars.dlg) then
		return 
	end
	
	arg_6_2 = arg_6_2 or {}
	
	TutorialGuide:procGuide("equip_install")
	
	local var_6_0 = arg_6_2.layer or SceneManager:getRunningPopupScene()
	local var_6_1
	
	if arg_6_1:isArtifact() then
		var_6_1 = load_dlg("inventory_artifact_popup", true, "wnd")
		
		local var_6_2 = load_control("wnd/artifact_detail_sub_popup.csb")
		
		var_6_1:getChildByName("n_artifact"):addChild(var_6_2)
		
		local var_6_3 = IS_PUBLISHER_STOVE and not ContentDisable:byAlias("eq_arti_statistics")
		
		if_set_visible(var_6_1, "btn_equip_arti", var_6_3)
	elseif arg_6_1:isExclusive() then
		var_6_1 = load_dlg("inventory_equip_popup", true, "wnd")
		
		if_set_opacity(var_6_1, "btn_upgrade", 76.5)
		if_set_opacity(var_6_1, "btn_delete", 76.5)
		if_set_visible(var_6_1, "n_equip_point", false)
	else
		var_6_1 = load_dlg("inventory_equip_popup", true, "wnd")
	end
	
	if arg_6_1:isArtifact() or arg_6_1:isExclusive() then
		if_set_opacity(var_6_1, "btn_share", 76.5)
	end
	
	LuaEventDispatcher:addIfNotEventListener("update.equip.lock", LISTENER(InventoryPopupDetail.updateEquipLock, arg_6_0), "inventory.equip.detail.popup")
	var_6_0:addChild(var_6_1)
	BackButtonManager:push({
		check_id = "InventoryPopupDetail",
		back_func = function()
			InventoryPopupDetail:Close()
		end,
		dlg = var_6_1
	})
	
	arg_6_0.vars = {
		dlg = var_6_1,
		equip = arg_6_1,
		opts = arg_6_2
	}
	
	arg_6_0:update()
end

function InventoryPopupDetail.Close(arg_8_0, arg_8_1)
	ShareChatPopup:close()
	
	if arg_8_0.vars and get_cocos_refid(arg_8_0.vars.dlg) then
		BackButtonManager:pop({
			id = "InventoryPopupDetail",
			dlg = arg_8_0.vars.dlg
		})
		arg_8_0.vars.dlg:removeFromParent()
		
		arg_8_0.vars = nil
	end
end

function InventoryPopupDetail.getEquip(arg_9_0)
	if not arg_9_0.vars then
		return 
	end
	
	return arg_9_0.vars.equip
end

function InventoryPopupDetail.getSellDlg(arg_10_0)
	local var_10_0 = calcEquipSellPrice(arg_10_0.vars.equip)
	local var_10_1 = 0
	
	if arg_10_0.vars.equip:isArtifact() then
		var_10_1 = calcArtifactSellPowder(arg_10_0.vars.equip)
	end
	
	local var_10_2 = var_10_0 + PetSkill:getLobbyAddCalcValue(SKILL_CONDITION.EQUIP_SELL_GOLD_UP, var_10_0)
	local var_10_3 = arg_10_0.vars.equip.list_type == "storage" and 1 or nil
	
	Inventory:getSellDialog(var_10_2, var_10_1, arg_10_0.vars.equip.id, "inventory_popup", true, var_10_3)
end

function InventoryPopupDetail.getExtractDlg(arg_11_0)
	local var_11_0
	local var_11_1
	
	if Account:getEquipFromStorage(arg_11_0.vars.equip.id) then
		var_11_1 = 1
	end
	
	Inventory:getExtractDialog({
		arg_11_0.vars.equip
	}, "inventory", nil, var_11_0, var_11_1)
end

function InventoryPopupDetail.getStorageDlg(arg_12_0)
	local var_12_0 = {
		putin = json.encode({
			arg_12_0.vars.equip.id
		})
	}
	
	Dialog:msgBox(T("confirm_equip_move_storage"), {
		yesno = true,
		handler = function()
			query("equip_storage_put_in", var_12_0)
		end
	})
end

function InventoryPopupDetail.onUnEquip(arg_14_0)
	if UnitEquip:isVisible() then
		balloon_message_with_sound("msg_equip_cant_use_btn")
		
		return 
	end
	
	Inventory:ReqUnequip(arg_14_0.vars.equip, "inventory_popup")
end

function InventoryPopupDetail.onDelete(arg_15_0)
	if arg_15_0.vars.equip:isExclusive() then
		balloon_message_with_sound("cannot_sell_exclusive_de")
		
		return 
	end
	
	if arg_15_0.vars.equip.parent then
		balloon_message_with_sound("equip_sell_used")
		
		return 
	end
	
	if arg_15_0.vars.equip.lock then
		balloon_message_with_sound("equip_sell_locked")
		
		return 
	end
	
	if arg_15_0.vars.equip:isForceLock() then
		balloon_message_with_sound("err_cannot_sell_equip")
		
		return 
	end
	
	arg_15_0:getSellDlg()
end

function InventoryPopupDetail.onExtract(arg_16_0)
	if arg_16_0.vars.equip:isExclusive() then
		balloon_message_with_sound("cannot_extraction_exclusive")
		
		return 
	end
	
	if arg_16_0.vars.equip.parent then
		balloon_message_with_sound("equip_extraction_used")
		
		return 
	end
	
	if arg_16_0.vars.equip.lock then
		balloon_message_with_sound("equip_extraction_locked")
		
		return 
	end
	
	if arg_16_0.vars.equip:isForceLock() then
		balloon_message_with_sound("err_cannot_extraction_equip")
		
		return 
	end
	
	if not Account:isUnlockExtract() then
		balloon_message_with_sound("system_121_btn_before")
		
		return 
	end
	
	arg_16_0:getExtractDlg()
end

function InventoryPopupDetail.onStorage(arg_17_0)
	if arg_17_0.vars.equip.parent then
		balloon_message_with_sound("msg_equip_cannot_move")
		
		return 
	end
	
	if EquipStorageMain:isActive() then
		balloon_message_with_sound("msg_equip_cannot_use_storage")
		
		return 
	end
	
	if not Account:getEquipStorageCount() then
		query("equip_storage_list", {
			caller = "inventory"
		})
		
		return 
	end
	
	if Account:getEquipStorageCount() + 1 > Account:getEquipStorageMaxCount() then
		Dialog:msgBox(T("storage_overflow_desc"), {
			yesno = true,
			yes_text = T("storage_full_expand"),
			title = T("storage_overflow_title"),
			handler = function()
				UIUtil:showIncEquipStorageDialog()
			end
		})
		
		return 
	end
	
	arg_17_0:getStorageDlg()
end

function InventoryPopupDetail.updateEquipLock(arg_19_0)
	if not arg_19_0.vars then
		return 
	end
	
	local var_19_0 = arg_19_0.vars.equip
	
	if_set_visible(arg_19_0.vars.dlg, "btn_i_lock", not var_19_0.lock)
	if_set_visible(arg_19_0.vars.dlg, "btn_i_locked", var_19_0.lock)
	if_set_visible(arg_19_0.vars.dlg, "locked", var_19_0.lock)
	if_set_opacity(arg_19_0.vars.dlg, "btn_delete", not var_19_0:checkSell() and 76.5 or 255)
	
	if not var_19_0:isArtifact() then
		if var_19_0:isExtractable() and var_19_0.parent == nil then
			if_set_opacity(arg_19_0.vars.dlg, "btn_extract", 255)
		else
			if_set_opacity(arg_19_0.vars.dlg, "btn_extract", 76.5)
		end
	end
	
	if not Account:isUnlockExtract() then
		if_set_opacity(arg_19_0.vars.dlg, "btn_extract", 76.5)
	end
	
	Inventory:UpdateContents(var_19_0)
end

function InventoryPopupDetail.openOptionChangePopup(arg_20_0)
	if not UnlockSystem:isUnlockSystem(UNLOCK_ID.EQUIP_SUB_CHANGE) then
		balloon_message_with_sound("system_139_btn_before")
		
		return 
	end
	
	UnitEquipChangeSub:init(SceneManager:getRunningPopupScene(), arg_20_0.vars.equip)
end

function InventoryPopupDetail.openUpgradePopup(arg_21_0)
	if not arg_21_0.vars.equip:isUpgradable() or arg_21_0.vars.equip:isExclusive() then
		balloon_message_with_sound("cannot_enchant_exclusive_de")
		
		return 
	end
	
	TutorialGuide:procGuide("equip_install")
	UnitEquipUpgrade:OpenPopup(arg_21_0.vars.equip, {
		exit_callback = function()
			arg_21_0:update()
		end
	})
end

function InventoryPopupDetail.openReforgePopup(arg_23_0)
	local var_23_0 = arg_23_0.vars.equip
	
	if var_23_0.db.item_level ~= 85 then
		balloon_message_with_sound("msg_reforge_req_equip_level")
		
		return 
	end
	
	if not var_23_0:isCraftUpgradable() then
		balloon_message_with_sound("msg_reforge_not_hunt_equip")
		
		return 
	end
	
	if EquipStorageMain:isActive() then
		balloon_message_with_sound("msg_equip_cannot_use_storage")
		
		return 
	end
	
	if not UnlockSystem:isUnlockSystem(UNLOCK_ID.EQUIP_UPGRADE) then
		balloon_message_with_sound("ui_reforge_level_error")
		
		return 
	end
	
	SanctuaryCraftUpgrade:quickEnter(var_23_0, {
		callback_on_leave = function()
			if not arg_23_0.vars then
				return 
			end
			
			arg_23_0.vars.equip = Account:getEquip(var_23_0:getUID())
			
			arg_23_0:update()
			arg_23_0:updatePopupCaller()
		end
	})
end

function InventoryPopupDetail.shareEquip(arg_25_0)
	if not arg_25_0.vars or not arg_25_0.vars.equip or not get_cocos_refid(arg_25_0.vars.dlg) then
		return 
	end
	
	local var_25_0 = arg_25_0.vars.equip
	local var_25_1 = table.empty(arg_25_0.vars.have_sub_stat_material_list) and 0 or -49
	
	if var_25_0:isArtifact() then
	elseif var_25_0:isExclusive() then
		balloon_message_with_sound("err_msg_exclusive_equip_share_unavailable")
		
		return 
	end
	
	ShareChatPopup:open({
		is_equip = true,
		uid = var_25_0:getUID(),
		parent_layer = arg_25_0.vars.dlg:getChildByName("n_share_chat"),
		move_x = var_25_1
	})
end

function InventoryPopupDetail.onZoom(arg_26_0)
	local var_26_0 = arg_26_0.vars.equip
	
	if not var_26_0:isArtifact() then
		Log.e("not artifact but try enter ArtiZoom. please check.")
		
		return 
	end
	
	ArtiZoom:onCreate({
		code = var_26_0.code,
		layer = SceneManager:getRunningPopupScene(),
		close_callback = function()
			InventoryPopupDetail:ArtiZoomNodeAction()
		end
	})
end

function InventoryPopupDetail.sendToAlchemy(arg_28_0)
	if Account:isUnlockArchemistExclusive() then
		if SceneManager:getCurrentSceneName() ~= "sanctuary" then
			SceneManager:nextScene("sanctuary", {
				start_archemist_mode = "alchemy_exclusive",
				mode = "Archemist"
			})
		else
			if MusicBoxUI:isShow() then
				MusicBoxUI:close()
			end
			
			if SanctuaryMain:getMode() ~= "Archemist" then
				SanctuaryMain:setMode("Archemist", {
					start_archemist_mode = "alchemy_exclusive"
				})
			elseif not SanctuaryArchemistCategories:isActive() then
				SanctuaryArchemistMain:clickEventById("alchemy_exclusive")
			elseif SanctuaryArchemist:getCurrentMode() ~= "alchemy_exclusive" then
				SanctuaryArchemistCategories:onSelectScrollViewItemById("alchemy_exclusive")
			end
			
			InventoryPopupDetail:Close()
			Inventory:close()
		end
	else
		balloon_message_with_sound("ui_exclusive_main_btn_before")
	end
end

function InventoryPopupDetail.openWearPopup(arg_29_0)
	if UnitEquip:isVisible() then
		balloon_message_with_sound("msg_equip_cant_use_btn")
		
		return 
	end
	
	local var_29_0 = arg_29_0.vars.equip
	
	if not var_29_0 then
		return 
	end
	
	local var_29_1 = Account:getUnit(var_29_0.parent)
	
	if not var_29_1 then
		return 
	end
	
	local var_29_2 = var_29_0:getEquipPositionIndex()
	
	if var_29_2 ~= 8 and #UnitEquip:GetItems(nil, var_29_0.db.type, {
		ignore_stone = true,
		excepted_item = var_29_0
	}) < 1 then
		return 
	end
	
	arg_29_0:Close()
	
	if var_29_2 == 8 then
		UnitExclusiveEquip:OpenPopup(var_29_1, var_29_2)
	else
		UnitEquip:OpenPopup(var_29_1, var_29_2)
	end
end

function InventoryPopupDetail.updateSubStat(arg_30_0)
	local var_30_0 = arg_30_0.vars.dlg
	local var_30_1 = arg_30_0.vars.equip
	
	if not var_30_1:isBasicEquip() then
		return 
	end
	
	arg_30_0.vars.equip_sub_logic = UnitEquipChangeSubLogic:startLogic(var_30_1)
	
	local var_30_2 = arg_30_0.vars.equip_sub_logic:getUsableSubStatChangeMaterialsId()
	
	arg_30_0.vars.have_sub_stat_material_list = arg_30_0:getSubStatMaterials(var_30_2)
	
	local var_30_3 = arg_30_0.vars.equip_sub_logic:isCanChangeSubStat()
	
	if_set_visible(var_30_0, "btn_upgrade", not var_30_3)
	if_set_visible(var_30_0, "btn_op_change", var_30_3)
	
	if not table.empty(arg_30_0.vars.have_sub_stat_material_list) then
		InventoryPopupDetail:openSubStatMaterialList()
	else
		InventoryPopupDetail:closeSubStatMaterialList()
	end
	
	local var_30_4 = 255
	
	if not UnlockSystem:isUnlockSystem(UNLOCK_ID.EQUIP_SUB_CHANGE) then
		var_30_4 = var_30_4 * 0.3
	end
	
	if_set_opacity(arg_30_0.vars.dlg, "btn_op_change", var_30_4)
end

function InventoryPopupDetail.ArtiZoomNodeAction(arg_31_0)
	if not arg_31_0.vars or not get_cocos_refid(arg_31_0.vars.dlg) then
		return 
	end
	
	local var_31_0 = arg_31_0.vars.dlg:findChildByName("n_artifact")
	
	if not get_cocos_refid(var_31_0) then
		return 
	end
	
	ArtiZoom:ArtiZoomNodeAction(var_31_0:findChildByName("n_zoom"))
end

function InventoryPopupDetail.set_exclusiveSkills(arg_32_0, arg_32_1, arg_32_2)
	local var_32_0 = arg_32_2.db.exclusive_unit
	local var_32_1 = arg_32_2.db.exclusive_skill
	local var_32_2, var_32_3, var_32_4 = DB("character", var_32_0, {
		"skill1",
		"skill2",
		"skill3"
	})
	local var_32_5, var_32_6, var_32_7, var_32_8 = DB("skill_equip", var_32_1 .. "_01", {
		"skill_number",
		"skilllv_eff",
		"equipskill_desc",
		"change_sk_desc"
	})
	local var_32_9 = cc.Layer:create()
	
	var_32_9:setPosition(0, 0)
	arg_32_1:addChild(var_32_9)
	var_32_9:setPosition(50, 0)
	
	local var_32_10 = UNIT:create({
		code = var_32_0
	})
	local var_32_11 = UIUtil:getSkillIcon(var_32_10, var_32_2, {
		show_exclusive_target = 1
	})
	
	var_32_11:setPosition(100, 100)
	var_32_9:addChild(var_32_11)
	
	local var_32_12 = UIUtil:getSkillIcon(var_32_10, var_32_3, {
		show_exclusive_target = 2
	})
	
	var_32_12:setPosition(300, 100)
	var_32_9:addChild(var_32_12)
	
	local var_32_13 = UIUtil:getSkillIcon(var_32_10, var_32_4, {
		show_exclusive_target = 3
	})
	
	var_32_13:setPosition(500, 100)
	var_32_9:addChild(var_32_13)
end

function InventoryPopupDetail.update(arg_33_0)
	if not arg_33_0.vars then
		return 
	end
	
	local var_33_0 = arg_33_0.vars.dlg
	local var_33_1 = arg_33_0.vars.equip
	local var_33_2
	
	if var_33_1.parent then
		var_33_2 = Account:getUnit(var_33_1.parent)
	end
	
	if var_33_1:isBasicEquip() and var_33_1.grade then
		if_set_sprite_with_9_slice(var_33_0, "frame", "img/_box_equip_" .. var_33_1.grade .. "b.png", {
			top = 245,
			bottom = 130,
			left = 360,
			right = 60
		})
	end
	
	local var_33_3 = var_33_1:isArtifact()
	
	ItemTooltip:updateEquipSubWindow(var_33_1, {
		sub_artifact_name = "wnd/artifact_detail_sub_popup.csb",
		wnd = var_33_0:getChildByName("n_equip_detail"),
		zoom_on = var_33_3
	})
	
	if var_33_2 then
		local var_33_4 = var_33_0:getChildByName("n_unit")
		
		SpriteCache:resetSprite(var_33_4:getChildByName("role"), "img/cm_icon_role_" .. var_33_2.db.role .. ".png")
		SpriteCache:resetSprite(var_33_4:getChildByName("color"), "img/cm_icon_pro" .. var_33_2.db.color .. ".png")
		UIUtil:setLevelDetail(var_33_4:getChildByName("n_lv"), var_33_2:getLv(), var_33_2:getMaxLevel())
		
		local var_33_5 = var_33_0:getChildByName("txt_unit_name")
		local var_33_6 = get_word_wrapped_name(var_33_5, T(var_33_2.db.name))
		
		if_set_scale_fit_width_long_word(var_33_5, nil, var_33_6, var_33_5:getContentSize().width)
		
		local var_33_7 = UIUtil:setTextAndReturnHeight(var_33_5, var_33_6)
		local var_33_8 = var_33_0:getChildByName("btn_equip_arti")
		
		if get_cocos_refid(var_33_8) then
			var_33_8:setPositionY(var_33_8:getPositionY() + var_33_8:getContentSize().height - var_33_7 - 30)
			var_33_8:getChildByName("label"):setPositionY(32)
			var_33_8:getChildByName("icon_menu_equip_arti"):setPositionY(30)
		end
		
		UIUtil:getUserIcon(var_33_2, {
			no_role = false,
			no_lv = false,
			scale = 1.5,
			parent = var_33_0:getChildByName("n_face"),
			unit = var_33_2
		})
	end
	
	if var_33_2 == nil or UnitEquip:isVisible() then
		if_set_opacity(var_33_0, "btn_unequip", 76.5)
	end
	
	if var_33_2 == nil or #UnitEquip:GetItems(var_33_2, var_33_1.db.type, {
		ignore_stone = true,
		excepted_item = var_33_1
	}) < 1 or UnitEquip:isVisible() then
		if_set_opacity(var_33_0, "btn_change", 76.5)
	end
	
	if_set_visible(var_33_0, "txt_unit_name", var_33_2 ~= nil)
	
	if not var_33_1:isUpgradable() then
		if_set_opacity(var_33_0, "btn_upgrade", 76.5)
	end
	
	local var_33_9 = var_33_0:getChildByName("n_vary")
	
	if get_cocos_refid(var_33_9) and not var_33_9.originPosY then
		var_33_9.originPosY = var_33_9:getPositionY()
	end
	
	if get_cocos_refid(var_33_9) then
		if var_33_1:isCraftUpgradable() then
			local var_33_10 = not UnlockSystem:isUnlockSystem(UNLOCK_ID.EQUIP_UPGRADE) or EquipStorageMain:isActive()
			
			var_33_9:setPositionY(var_33_9.originPosY + 60)
			if_set_visible(var_33_0, "btn_reforge", true)
			if_set_opacity(var_33_0, "btn_reforge", var_33_10 and 76.5 or 255)
		else
			var_33_9:setPositionY(var_33_9.originPosY)
			if_set_visible(var_33_0, "btn_reforge", false)
		end
	end
	
	if var_33_1:isExclusive() then
		if_set_visible(var_33_0, "btn_private_store", true)
		if_set_opacity(var_33_0, "btn_private_store", 255 * (Account:isUnlockArchemistExclusive() and 1 or 0.3))
		if_set_visible(var_33_0, "btn_upgrade", false)
		if_set_visible(var_33_0, "btn_eq_storage", false)
	elseif var_33_1.parent or EquipStorageMain:isActive() then
		if_set_opacity(var_33_0, "btn_eq_storage", 76.5)
	else
		if_set_opacity(var_33_0, "btn_eq_storage", 255)
	end
	
	if var_33_1:isArtifact() and var_33_1:isUpgradable() and var_33_1:isMaxEnhance() then
		if_set(var_33_0:getChildByName("btn_upgrade"), "label", T("ui_artifact_popup_dup_enhance"))
	else
		if_set(var_33_0:getChildByName("btn_upgrade"), "label", T("ui_artifact_popup_enhance"))
	end
	
	arg_33_0:updateEquipLock()
	if_set_visible(var_33_0, "n_unit", var_33_2 ~= nil)
	if_set_visible(var_33_0, "n_no_unit", not var_33_2)
	arg_33_0:updateRecall()
	if_set_opacity(var_33_0, "btn_delete", 255 * (var_33_1:isForceLock() and 0.3 or 1))
	
	if var_33_1:isArtifact() then
		local var_33_11 = Booster:isActiveBoosterSubType(EVENT_BOOSTER_SUB_TYPE.EQUIP_ALL_FREE_EVENT) or Booster:isActiveBoosterSubType(EVENT_BOOSTER_SUB_TYPE.EQUIP_ARTI_FREE)
		
		if_set_visible(var_33_0, "event_badge", var_33_11)
	else
		local var_33_12 = Booster:isActiveBoosterSubType(EVENT_BOOSTER_SUB_TYPE.EQUIP_ALL_FREE_EVENT) or Booster:isActiveBoosterSubType(EVENT_BOOSTER_SUB_TYPE.EQUIP_NO_ARTI_FREE)
		
		if_set_visible(var_33_0, "event_badge", var_33_12)
	end
	
	if not var_33_1:isArtifact() then
		if var_33_1:isExtractable() and var_33_2 == nil then
			if_set_opacity(var_33_0, "btn_extract", 255)
		else
			if_set_opacity(var_33_0, "btn_extract", 76.5)
		end
	end
	
	if not Account:isUnlockExtract() then
		if_set_opacity(var_33_0, "btn_extract", 76.5)
	end
	
	if_set_opacity(arg_33_0.vars.dlg, "btn_delete", not var_33_1:checkSell() and 76.5 or 255)
	arg_33_0:updateSubStat()
	GrowthGuideNavigator:proc()
end

function InventoryPopupDetail.updatePopupCaller(arg_34_0, arg_34_1)
	if not arg_34_0.vars then
		return 
	end
	
	if Inventory:isShow() then
		Inventory:UpdateContents(arg_34_1, {
			do_not_keep_pos = false
		})
	end
	
	if UnitEquip:isVisible() then
		UnitEquip:updateInfos()
	end
	
	if UnitDetail:isValid() then
		UnitDetail:updateUnitInfo()
	end
end

function InventoryPopupDetail.reqLock(arg_35_0, arg_35_1)
	if arg_35_0.vars.equip.lock then
		query("unlock_equip", {
			equip = arg_35_0.vars.equip.id,
			stored_item = arg_35_1
		})
	else
		query("lock_equip", {
			equip = arg_35_0.vars.equip.id,
			stored_item = arg_35_1
		})
	end
end

function InventoryPopupDetail.updateRecall(arg_36_0)
	local var_36_0 = arg_36_0.vars.dlg
	local var_36_1 = arg_36_0.vars.equip
	local var_36_2 = UIUtil:isEquipRecallable(var_36_1)
	
	if_set_visible(var_36_0, "btn_recall", var_36_2)
end

function InventoryPopupDetail.requestPreviewRecallEquip(arg_37_0)
	if arg_37_0.vars.equip and arg_37_0.vars.equip:isExclusive() then
		ExclusiveRecallPopup:openExclusiveRecallPopup()
	else
		query("recall_equip_preview", {
			equip_id = arg_37_0.vars.equip.id
		})
	end
end

function InventoryPopupDetail.getSubStatMaterials(arg_38_0, arg_38_1)
	local var_38_0 = {}
	
	for iter_38_0, iter_38_1 in pairs(arg_38_1) do
		local var_38_1 = Account:getItemCount(iter_38_1)
		
		if var_38_1 > 0 then
			local var_38_2 = UnitEquipUtil:getSubStatChangeMaterialInfo(iter_38_1)
			
			if var_38_2 then
				local var_38_3 = UnitEquipUtil:parsingSubStatChangeMaType2(var_38_2)
				
				if var_38_3 then
					table.insert(var_38_0, {
						id = iter_38_1,
						count = var_38_1,
						set = var_38_3[2]
					})
				end
			end
		end
	end
	
	return var_38_0
end

function InventoryPopupDetail.popupResize(arg_39_0, arg_39_1)
	if not get_cocos_refid(arg_39_0.vars.dlg) then
		return 
	end
	
	local var_39_0 = arg_39_0.vars.dlg:findChildByName("frame")
	local var_39_1 = arg_39_0.vars.dlg:findChildByName("touch")
	
	if not arg_39_0.vars._frame_origin_size then
		arg_39_0.vars._frame_origin_size = var_39_0:getContentSize()
	end
	
	if not arg_39_0.vars._touch_origin_size then
		arg_39_0.vars._touch_origin_size = var_39_1:getContentSize()
	end
	
	arg_39_1 = arg_39_1 or 0
	
	var_39_0:setContentSize(arg_39_0.vars._frame_origin_size.width + arg_39_1, arg_39_0.vars._frame_origin_size.height)
	var_39_1:setContentSize(arg_39_0.vars._touch_origin_size.width + arg_39_1, arg_39_0.vars._touch_origin_size.height)
end

function InventoryPopupDetail.saveSubStatMaterialListToggle(arg_40_0, arg_40_1)
	if not arg_40_0.vars then
		return 
	end
	
	SAVE:set("substat_item_list.toggle", arg_40_1)
end

function InventoryPopupDetail.openSubStatMaterialList(arg_41_0)
	if not arg_41_0.vars then
		return 
	end
	
	if not arg_41_0.vars.equip_sub_logic then
		print("NO : self.vars.equip_sub_logic")
		
		return 
	end
	
	local var_41_0 = arg_41_0.vars.have_sub_stat_material_list
	
	if table.empty(var_41_0) then
		balloon_message_with_sound("msg_change_option_material_lack")
		
		return 
	end
	
	arg_41_0:popupResize(98)
	if_set_visible(arg_41_0.vars.dlg, "btn_open_material", false)
	if_set_visible(arg_41_0.vars.dlg, "btn_close_material", true)
	if_set_visible(arg_41_0.vars.dlg, "n_material_view", true)
	
	if not arg_41_0.vars.listview_material then
		local var_41_1 = ItemListView:bindControl(arg_41_0.vars.dlg:getChildByName("listview_material"))
		local var_41_2 = {
			onUpdate = function(arg_42_0, arg_42_1, arg_42_2)
				arg_42_1:removeAllChildren()
				
				arg_42_1 = UIUtil:getRewardIcon(arg_42_2.count, arg_42_2.id, {
					no_tooltip = true,
					scale = 0.8,
					parent = arg_42_1,
					set_fx = arg_42_2.set
				})
				
				arg_42_1:setPosition(10, 10)
				arg_42_1:setAnchorPoint(0, 0)
			end
		}
		local var_41_3 = cc.Layer:create()
		
		var_41_3:setContentSize(90, 90)
		var_41_1:setRenderer(var_41_3, var_41_2)
		
		arg_41_0.vars.listview_material = var_41_1
	end
	
	arg_41_0.vars.listview_material:setItems(var_41_0)
end

function InventoryPopupDetail.closeSubStatMaterialList(arg_43_0)
	if not arg_43_0.vars then
		return 
	end
	
	if not arg_43_0.vars.equip_sub_logic then
		print("NO : self.vars.equip_sub_logic")
		
		return 
	end
	
	arg_43_0:popupResize()
	if_set_visible(arg_43_0.vars.dlg, "btn_open_material", true)
	if_set_visible(arg_43_0.vars.dlg, "n_material_view", false)
	if_set_visible(arg_43_0.vars.dlg, "btn_close_material", false)
	
	if arg_43_0.vars.listview_material then
		arg_43_0.vars.listview_material:setItems({})
	end
end

function InventoryPopupDetail.previewRecallEquip(arg_44_0, arg_44_1)
	if arg_44_1 == nil or arg_44_1.confirm_rewards == nil or arg_44_1.code ~= arg_44_0.vars.equip.code or arg_44_1.equip_id ~= arg_44_0.vars.equip.id then
		Dialog:msgBox(T("recall_invalid_arti_desc"), {
			handler = function()
				SceneManager:nextScene("lobby")
			end,
			title = T("recall_invalid_arti_title")
		})
		
		return 
	end
	
	local var_44_0 = arg_44_1.confirm_rewards.enhance
	local var_44_1 = arg_44_1.confirm_rewards.limit
	local var_44_2 = load_dlg("recall", true, "wnd")
	local var_44_3 = var_44_2:getChildByName("n_arti")
	
	var_44_3:setVisible(true)
	if_set_visible(var_44_2, "n_hero", false)
	if_set(var_44_2, "t_title", T("ui_recall_arti_tl"))
	if_set(var_44_2, "t_disc", T("ui_recall_arti_desc"))
	
	local var_44_4 = var_44_3:getChildByName("enchantment")
	
	if var_44_0 then
		for iter_44_0 = 1, 7 do
			local var_44_5 = var_44_4:getChildByName("n_" .. iter_44_0)
			
			if var_44_5 then
				if var_44_0[iter_44_0] then
					if string.starts(var_44_0[iter_44_0].i, "to_") then
						UIUtil:getRewardIcon(var_44_0[iter_44_0].c, var_44_0[iter_44_0].i, {
							no_popup = true,
							scale = 0.8,
							no_tooltip = true,
							parent = var_44_5:getChildByName("n_item")
						})
						if_set_visible(var_44_5, "t_count_mob", false)
					else
						UIUtil:getRewardIcon(nil, var_44_0[iter_44_0].i, {
							no_popup = true,
							no_tooltip = true,
							scale = 0.8,
							no_grade = true,
							parent = var_44_5:getChildByName("n_item")
						})
						if_set(var_44_5, "t_count_mob", "x" .. var_44_0[iter_44_0].c)
					end
					
					var_44_5:setVisible(true)
				else
					var_44_5:setVisible(false)
				end
			end
		end
		
		var_44_4:setVisible(true)
	else
		var_44_4:setVisible(false)
	end
	
	local var_44_6 = var_44_3:getChildByName("limit_break")
	
	if var_44_1 then
		for iter_44_1 = 1, 1 do
			local var_44_7 = var_44_6:getChildByName("n_" .. iter_44_1)
			
			if var_44_7 then
				if var_44_1[iter_44_1] then
					if string.starts(var_44_1[iter_44_1].i, "to_") then
						UIUtil:getRewardIcon(var_44_1[iter_44_1].c, var_44_1[iter_44_1].i, {
							no_popup = true,
							scale = 0.8,
							no_tooltip = true,
							parent = var_44_7:getChildByName("n_item")
						})
						if_set_visible(var_44_7, "t_count_mob", false)
					else
						UIUtil:getRewardIcon(nil, var_44_1[iter_44_1].i, {
							no_popup = true,
							scale = 0.63,
							no_tooltip = true,
							parent = var_44_7:getChildByName("n_item")
						})
						if_set(var_44_7, "t_count_mob", "x" .. var_44_1[iter_44_1].c)
					end
					
					var_44_7:setVisible(true)
				else
					var_44_7:setVisible(false)
				end
			end
		end
		
		var_44_6:setVisible(true)
	else
		var_44_6:setVisible(false)
	end
	
	Dialog:msgBox("", {
		yesno = true,
		dlg = var_44_2,
		handler = function()
			arg_44_0:confirmRecall(1)
		end
	})
end

function InventoryPopupDetail.confirmRecall(arg_47_0, arg_47_1)
	local var_47_0 = load_dlg("recall_confirm_p", true, "wnd")
	
	if_set(var_47_0, "txt_title", T("ui_recall_arti_tl"))
	
	if arg_47_1 == 1 then
		if_set(var_47_0, "disc", T("ui_recall_arti_confirm_desc1"))
		if_set_visible(var_47_0, "disc", true)
		if_set_visible(var_47_0, "disc_2", false)
	elseif arg_47_1 == 2 then
		if_set(var_47_0, "disc_2", T("ui_recall_arti_confirm_desc2"))
		if_set_visible(var_47_0, "disc", false)
		if_set_visible(var_47_0, "disc_2", true)
	end
	
	local var_47_1 = var_47_0:getChildByName("n_contents")
	local var_47_2 = var_47_1:getChildByName("n_before")
	
	if_set_visible(var_47_2, "n_lv", false)
	UIUtil:getRewardIcon(nil, arg_47_0.vars.equip.code, {
		no_popup = true,
		scale = 1,
		no_tooltip = true,
		parent = var_47_2:getChildByName("n_item")
	})
	
	if to_n(arg_47_0.vars.equip.enhance) > 0 then
		if_set(var_47_2, "skill_up", "+" .. arg_47_0.vars.equip.enhance)
		if_set_visible(var_47_2, "skill_up_bg", true)
	else
		if_set_visible(var_47_2, "skill_up_bg", false)
	end
	
	local var_47_3 = var_47_1:getChildByName("n_after")
	
	if_set_visible(var_47_3, "n_lv", false)
	UIUtil:getRewardIcon(nil, arg_47_0.vars.equip.code, {
		no_popup = true,
		scale = 1,
		no_tooltip = true,
		parent = var_47_3:getChildByName("n_item")
	})
	Dialog:msgBox("", {
		yesno = true,
		dlg = var_47_0,
		handler = function()
			if arg_47_1 == nil or arg_47_1 == 1 then
				arg_47_0:confirmRecall(2)
			elseif arg_47_1 == 2 then
				arg_47_0:requestRecallEquip()
			end
		end
	})
end

function InventoryPopupDetail.requestRecallEquip(arg_49_0)
	if not arg_49_0.vars or not arg_49_0.vars.equip then
		return 
	end
	
	local var_49_0 = arg_49_0.vars.equip
	
	if var_49_0.isArtifact and var_49_0:isArtifact() then
		if UIUtil:checkArtifactInven() == false then
			return 
		end
	elseif UIUtil:checkEquipInven() == false then
		return 
	end
	
	query("recall_equip", {
		equip_id = arg_49_0.vars.equip.id
	})
end

function InventoryPopupDetail.processRecallEquip(arg_50_0, arg_50_1)
	if arg_50_1.err then
		balloon_message_with_sound(arg_50_1.err)
		
		return 
	end
	
	if arg_50_1.recall_info then
		AccountData.recall_info = arg_50_1.recall_info
	end
	
	if arg_50_1.updated_equip then
		local var_50_0 = Account:getEquip(arg_50_1.updated_equip.id)
		
		if var_50_0 then
			var_50_0.exp = arg_50_1.updated_equip.e or 0
			var_50_0.op = arg_50_1.updated_equip.op
			var_50_0.dup_pt = arg_50_1.updated_equip.sk or 0
			
			var_50_0:update()
			
			if var_50_0.parent then
				local var_50_1 = Account:getUnit(var_50_0.parent)
				
				if var_50_1 then
					var_50_1:calc()
				end
			end
		end
	end
	
	if arg_50_1.rewards then
		Account:addReward(arg_50_1.rewards, {
			ignore_get_condition = true
		})
	end
	
	Dialog:msgBox(T("recall_complete_desc"), {
		handler = function()
			SceneManager:nextScene("lobby")
		end,
		title = T("recall_complete_title")
	})
end
