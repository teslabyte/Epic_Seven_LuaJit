UnitEquip = {}

copy_functions(ScrollView, UnitEquip)

function MsgHandler.puton_equip(arg_1_0)
	if UnitExclusiveEquip.vars and get_cocos_refid(UnitExclusiveEquip.vars.wnd) then
		UnitExclusiveEquip:PutOn(arg_1_0)
	else
		UnitEquip:PutOn(arg_1_0)
	end
	
	local var_1_0 = Account:getEquip(arg_1_0.equip)
	local var_1_1 = Account:getUnit(arg_1_0.unit)
	
	if var_1_0 and var_1_1 then
		UnitEquip:updateCondition(var_1_1, var_1_0)
	end
end

function MsgHandler.putoff_equip(arg_2_0)
	if UnitExclusiveEquip.vars and get_cocos_refid(UnitExclusiveEquip.vars.wnd) then
		UnitExclusiveEquip:PutOff(arg_2_0)
	else
		UnitEquip:PutOff(arg_2_0)
	end
end

function HANDLER.unit_item(arg_3_0, arg_3_1)
	if arg_3_1 == "btn_top_back" then
		UnitEquip:onPushBackButton()
	end
end

function HANDLER.item_detail(arg_4_0, arg_4_1)
	local var_4_0 = getParentWindow(arg_4_0).equip
	
	if (arg_4_1 == "btn_up" or arg_4_1 == "btn_puton" or arg_4_1 == "btn_putoff") and var_4_0 and var_4_0:isStone() then
		balloon_message_with_sound("equip_stone_none")
		
		return 
	end
	
	if arg_4_1 == "btn_puton" or arg_4_1 == "btn_putoff" or arg_4_1 == "btn_puton_cost" then
		local var_4_1 = getParentWindow(arg_4_0)
		
		UnitEquip:reqWearEquip(var_4_1.equip_id)
	end
	
	if arg_4_1 == "btn_item_info" then
		local var_4_2 = getParentWindow(arg_4_0)
		
		UnitEquip:onButtonInfo(var_4_2.equip_id)
	end
	
	if arg_4_1 == "btn_top_back" then
		UnitEquip:onPushBackButton()
	end
end

HANDLER.artifact_detail = HANDLER.item_detail

function HANDLER.artifact_detail_sub(arg_5_0, arg_5_1)
	if arg_5_1 == "btn_equip_arti" then
		if not get_cocos_refid(arg_5_0) then
			return 
		end
		
		if not arg_5_0.equip then
			return 
		end
		
		Stove:openArtifactUsagePage(arg_5_0.equip.code)
		
		return 
	end
	
	if arg_5_1 == "btn_zoom" then
		if not arg_5_0.equip then
			Log.e("cont.equip was nil.")
			
			return 
		end
		
		UnitEquip:onZoom(arg_5_0.equip)
	end
end

function UnitEquip.isVisible(arg_6_0)
	return arg_6_0.vars and arg_6_0.vars.wnd and get_cocos_refid(arg_6_0.vars.wnd)
end

function UnitEquip.getEquipBelt(arg_7_0)
	return arg_7_0.vars and arg_7_0.vars.equip_belt
end

function UnitEquip.isEquipBeltVisible(arg_8_0)
	return arg_8_0.vars and arg_8_0.vars.equip_belt and arg_8_0.vars.equip_belt:isVisible()
end

function UnitEquip.OpenPopup(arg_9_0, arg_9_1, arg_9_2)
	arg_9_0:onCreate({
		popup_mode = true,
		unit = arg_9_1,
		pos = arg_9_2
	})
	arg_9_0:onEnter()
	TopBarNew:createFromPopup(T("puton"), arg_9_0.vars.wnd, function()
		arg_9_0:onLeave()
	end)
	TopBarNew:setDisableTopRight()
	Analytics:setPopup("unit_equip")
end

function UnitEquip.onCreate(arg_11_0, arg_11_1)
	arg_11_0.vars = {}
	arg_11_0.vars.opts = arg_11_1
	arg_11_0.vars.popup_mode = arg_11_1.popup_mode
	arg_11_0.vars.wnd = load_dlg("unit_item", true, "wnd")
	
	local var_11_0 = arg_11_0.vars.wnd:findChildByName("TOP_LEFT")
	
	if_set_visible(var_11_0, nil, arg_11_1.popup_mode == true)
	
	if arg_11_1.popup_mode and get_cocos_refid(var_11_0) then
		if not var_11_0.prv_x then
			var_11_0.prv_x = var_11_0:getPositionX()
		end
		
		local var_11_1 = 0
		
		if NotchStatus:isRequireAdjustEdge() then
			var_11_1 = NotchStatus:getAdjustEdgeValue()
		end
		
		var_11_0:setPositionX(var_11_0.prv_x + var_11_1)
	end
	
	if_set_visible(arg_11_0.vars.wnd, "n_dim_img", arg_11_1.popup_mode)
	;(arg_11_1.layer or SceneManager:getRunningPopupScene()):addChild(arg_11_0.vars.wnd)
	arg_11_0.vars.wnd:getChildByName("LEFT"):setOpacity(0)
	arg_11_0.vars.wnd:getChildByName("ITEM"):setOpacity(0)
	arg_11_0.vars.wnd:getChildByName("ARTIFACT"):setOpacity(0)
end

function UnitEquip.onSelectEquip(arg_12_0, arg_12_1)
	if not arg_12_1 then
		return 
	end
	
	if arg_12_1 == arg_12_0.vars.base_equip then
		balloon_message_with_sound("msg_cannot_change_already_equipped")
		
		return 
	end
	
	arg_12_0:setDiffEquip(arg_12_1)
	arg_12_0:updateGuide()
	SoundEngine:play("event:/ui/ok")
	TutorialGuide:procGuide("equip_install")
	TutorialGuide:procGuide("artifact_install")
end

function UnitEquip.onZoom(arg_13_0, arg_13_1)
	if not arg_13_1 then
		return 
	end
	
	if not arg_13_1:isArtifact() then
		Log.e("not artifact but try enter ArtiZoom. please check.")
		
		return 
	end
	
	ArtiZoom:onCreate({
		code = arg_13_1.code,
		layer = SceneManager:getRunningPopupScene(),
		close_callback = function()
			if not arg_13_0.vars then
				return 
			end
			
			local var_14_0 = arg_13_0.vars.base_equip_wnd or arg_13_0.vars.diff_equip_wnd
			
			if get_cocos_refid(var_14_0) then
				local var_14_1 = arg_13_0.vars.base_equip or arg_13_0.vars.diff_equip
				
				if var_14_1 and var_14_1:isArtifact() then
					local var_14_2 = var_14_0:findChildByName("n_zoom")
					
					ArtiZoom:ArtiZoomNodeAction(var_14_2)
				end
			end
		end
	})
end

function UnitEquip.setBaseEquip(arg_15_0, arg_15_1)
	if arg_15_1 then
		local var_15_0 = arg_15_1:isArtifact()
		
		if not arg_15_0.vars.base_equip_wnd then
			local var_15_1 = ItemTooltip:updateEquipSubWindow(arg_15_1, {
				sub_equip_name = "wnd/item_detail_change.csb",
				is_before_equip = true,
				detail = true,
				unit = arg_15_0.vars.unit,
				zoom_on = var_15_0
			})
			
			var_15_1:setPosition(arg_15_0.vars.wnd:getChildByName("pos_base"):getPosition())
			arg_15_0.vars.wnd:getChildByName("LEFT"):addChild(var_15_1)
			
			arg_15_0.vars.base_equip_wnd = var_15_1
		else
			arg_15_0.vars.base_equip_wnd:getChildByName("bg_item"):removeAllChildren()
			ItemTooltip:updateEquipSubWindow(arg_15_1, {
				is_before_equip = true,
				sub_equip_name = "wnd/item_detail_change.csb",
				detail = true,
				unit = arg_15_0.vars.unit,
				wnd = arg_15_0.vars.base_equip_wnd,
				zoom_on = var_15_0
			})
		end
		
		if not arg_15_0.vars.is_artifact and arg_15_1.parent then
			local var_15_2 = Account:getUnit(arg_15_1.parent)
			
			if var_15_2 then
				UIUtil:getRewardIcon("c", var_15_2:getDisplayCode(), {
					no_popup = true,
					no_grade = true,
					parent = arg_15_0.vars.base_equip_wnd:getChildByName("n_unit_icon")
				})
				if_set_visible(arg_15_0.vars.base_equip_wnd, "n_unit_icon", true)
				if_set_visible(arg_15_0.vars.base_equip_wnd, "locked", false)
			end
		end
	elseif arg_15_0.vars.base_equip_wnd then
		arg_15_0.vars.base_equip_wnd:removeFromParent()
		
		arg_15_0.vars.base_equip_wnd = nil
	end
	
	arg_15_0.vars.base_equip = arg_15_1
	
	arg_15_0:updateGuide()
end

function UnitEquip.setDiffEquip(arg_16_0, arg_16_1)
	if arg_16_1 then
		local var_16_0 = arg_16_1:isArtifact()
		
		if not arg_16_0.vars.diff_equip_wnd then
			local var_16_1 = ItemTooltip:updateEquipSubWindow(arg_16_1, {
				is_after_equip = true,
				sub_equip_name = "wnd/item_detail_change.csb",
				unit = arg_16_0.vars.unit,
				zoom_on = var_16_0
			})
			
			if arg_16_0.vars.is_artifact then
				arg_16_0.vars.wnd:getChildByName("ARTIFACT"):addChild(var_16_1)
				var_16_1:setPosition(0, 0)
				var_16_1:getChildByName("n_artifact_detail"):setPositionX(0)
			else
				arg_16_0.vars.wnd:getChildByName("ITEM"):addChild(var_16_1)
				var_16_1:setPosition(arg_16_0.vars.wnd:getChildByName("pos_diff"):getPosition())
			end
			
			arg_16_0.vars.diff_equip_wnd = var_16_1
		else
			arg_16_0.vars.diff_equip_wnd:getChildByName("bg_item"):removeAllChildren()
			ItemTooltip:updateEquipSubWindow(arg_16_1, {
				is_after_equip = true,
				sub_equip_name = "wnd/item_detail_change.csb",
				unit = arg_16_0.vars.unit,
				wnd = arg_16_0.vars.diff_equip_wnd,
				zoom_on = var_16_0
			})
		end
		
		if arg_16_0.vars.is_artifact then
			if arg_16_0.vars.unit:getEquipByPos(arg_16_1.db.type) then
				UIUtil:changeButtonState(arg_16_0.vars.diff_equip_wnd.c.btn_puton_cost, arg_16_1:checkRole(arg_16_0.vars.unit), true)
			else
				UIUtil:changeButtonState(arg_16_0.vars.diff_equip_wnd.c.btn_puton, arg_16_1:checkRole(arg_16_0.vars.unit), true)
			end
		elseif arg_16_1.parent then
			local var_16_2 = Account:getUnit(arg_16_1.parent)
			
			if var_16_2 then
				UIUtil:getRewardIcon("c", var_16_2:getDisplayCode(), {
					no_popup = true,
					no_grade = true,
					parent = arg_16_0.vars.diff_equip_wnd:getChildByName("n_unit_icon")
				})
				if_set_visible(arg_16_0.vars.diff_equip_wnd, "n_unit_icon", true)
				if_set_visible(arg_16_0.vars.diff_equip_wnd, "locked", false)
			end
		end
		
		if_set(arg_16_0.vars.diff_equip_wnd, "title", T("equip_selected"))
	elseif arg_16_0.vars.diff_equip_wnd then
		arg_16_0.vars.diff_equip_wnd:removeFromParent()
		
		arg_16_0.vars.diff_equip_wnd = nil
	end
	
	if arg_16_0.vars.diff_equip then
		arg_16_0.vars.equip_belt:setSelect(arg_16_0.vars.diff_equip, false)
	end
	
	arg_16_0.vars.equip_belt:setSelect(arg_16_1, true)
	
	arg_16_0.vars.diff_equip = arg_16_1
	
	arg_16_0:updateGuide()
end

function UnitEquip.GetItems(arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	arg_17_3 = arg_17_3 or {}
	arg_17_2 = arg_17_2 or arg_17_0.vars.category
	
	local var_17_0 = arg_17_3.ignore_stone
	local var_17_1 = arg_17_3.ignore_equipped or arg_17_3.is_upgrade_mode
	local var_17_2 = arg_17_3.ignore_locked or arg_17_3.is_upgrade_mode
	local var_17_3 = arg_17_3.excepted_item
	local var_17_4 = arg_17_3.check_role
	local var_17_5 = {}
	
	for iter_17_0, iter_17_1 in pairs(Account.equips) do
		if (iter_17_1.db.type == arg_17_2 or iter_17_1:isCompatibleCategoryStone(arg_17_2)) and iter_17_1 ~= var_17_3 then
			local var_17_6 = true
			
			if var_17_1 and iter_17_1.parent then
				var_17_6 = arg_17_1 and iter_17_1.parent == arg_17_1:getUID() or false
			end
			
			if var_17_0 and iter_17_1.db.stone == "y" then
				var_17_6 = false
			end
			
			if iter_17_1.db.limit_break and var_17_3 and to_n(iter_17_1.db.limit_break) ~= to_n(var_17_3.grade) then
				var_17_6 = false
			end
			
			if var_17_4 and arg_17_1 and not iter_17_1:checkRole(arg_17_1) then
				var_17_6 = false
			end
			
			if var_17_6 then
				local var_17_7 = var_17_3 and var_17_3:isArtifact() and var_17_3.code ~= iter_17_1.code and iter_17_1:isForceLock()
				local var_17_8 = iter_17_1.lock or var_17_7
				
				if not (var_17_2 and var_17_8) then
					var_17_5[#var_17_5 + 1] = iter_17_1
				end
			end
		end
	end
	
	return var_17_5
end

function UnitEquip.onEnter(arg_18_0, arg_18_1, arg_18_2)
	arg_18_2 = arg_18_2 or arg_18_0.vars.opts or {}
	
	local var_18_0 = arg_18_2.unit
	local var_18_1 = arg_18_2.pos
	local var_18_2 = arg_18_2.diff_equip
	
	arg_18_0.old_args = arg_18_0.old_args or {}
	
	if var_18_0 == nil then
		var_18_0 = arg_18_0.old_args.unit
		var_18_1 = arg_18_0.old_args.pos
		
		if arg_18_0.old_args.diff_equip and Account:getEquip(arg_18_0.old_args.diff_equip:getUID()) then
			var_18_2 = arg_18_0.old_args.diff_equip
		end
	end
	
	arg_18_0.vars.is_artifact = var_18_1 == 7
	arg_18_0.vars.unit = var_18_0
	arg_18_0.vars.pos = var_18_1
	arg_18_0.vars.category = EQUIP:getEquipPositionByIndex(var_18_1)
	
	local var_18_3 = "equip_wear_sort_index"
	
	if arg_18_0.vars.is_artifact then
		var_18_3 = "artifact_wear_sort_index"
	end
	
	arg_18_0.vars.equip_belt = EquipBelt:createInstance()
	
	arg_18_0.vars.equip_belt:show({
		is_artifact = arg_18_0.vars.is_artifact,
		base_unit = var_18_0,
		parent = arg_18_0.vars.wnd:getChildByName("n_equiplist"),
		sorter_parent = arg_18_0.vars.wnd:getChildByName("n_custom_sorting"),
		default_sort_index = Account:getConfigData(var_18_3) or 1,
		callback_sort = function(arg_19_0, arg_19_1)
			SAVE:setTempConfigData(var_18_3, arg_19_1)
		end,
		select_callback = function(arg_20_0)
			arg_18_0:onSelectEquip(arg_20_0)
		end,
		priority_sort_func = function(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
			if arg_21_0:isArtifact() then
				local var_21_0 = arg_21_0:checkRole(arg_21_3.base_unit)
				
				if var_21_0 ~= arg_21_1:checkRole(arg_21_3.base_unit) then
					return var_21_0 == true
				end
			end
		end
	})
	arg_18_0.vars.equip_belt:updateList(arg_18_0:GetItems(var_18_0, arg_18_0.vars.category, {
		ignore_stone = true
	}))
	
	if arg_18_0.vars.is_artifact then
		arg_18_0.vars.diff_equip = var_18_2 or var_18_0:getEquipByIndex(var_18_1)
		
		if arg_18_0.vars.diff_equip == nil then
			arg_18_0:onSelectEquip(arg_18_0.vars.equip_belt:getEquipList()[1])
		end
	else
		arg_18_0.vars.base_equip = var_18_0:getEquipByIndex(var_18_1)
		arg_18_0.vars.diff_equip = var_18_2
	end
	
	if arg_18_0.vars.is_artifact then
		if_set_visible(arg_18_0.vars.wnd, "LEFT", false)
		if_set_visible(arg_18_0.vars.wnd, "ITEM", false)
		UIAction:Add(SEQ(SLIDE_IN_Y(200, 1200)), arg_18_0.vars.wnd:getChildByName("ARTIFACT"), "block")
	else
		UIAction:Add(SEQ(SLIDE_IN(200, 600)), arg_18_0.vars.wnd:getChildByName("LEFT"), "block")
		UIAction:Add(SEQ(SLIDE_IN_Y(200, 1200)), arg_18_0.vars.wnd:getChildByName("ITEM"), "block")
		if_set_visible(arg_18_0.vars.wnd, "ARTIFACT", false)
		
		if arg_18_0.vars.base_equip then
			arg_18_0:setBaseEquip(arg_18_0.vars.base_equip)
		end
	end
	
	local var_18_4 = arg_18_0.vars.wnd:getChildByName("n_custom_sorting")
	
	UIAction:Add(SEQ(MOVE_TO(200, var_18_4:getPosition())), var_18_4, "block")
	var_18_4:setPositionX(var_18_4:getPositionX() + 900)
	
	if arg_18_0.vars.diff_equip then
		arg_18_0:setDiffEquip(arg_18_0.vars.diff_equip)
	end
	
	SpriteCache:resetSprite(arg_18_0.vars.wnd:getChildByName("icon_base_parts"), "img/cm_icon_par" .. var_18_1 .. ".png")
	SpriteCache:resetSprite(arg_18_0.vars.wnd:getChildByName("icon_diff_parts"), "img/cm_icon_par" .. var_18_1 .. ".png")
	TutorialGuide:procGuide("equip_install")
end

function UnitEquip.updateGuide(arg_22_0)
	if not arg_22_0.vars or not get_cocos_refid(arg_22_0.vars.wnd) then
		return 
	end
	
	if arg_22_0.vars.is_artifact then
	else
		if_set_visible(arg_22_0.vars.wnd:getChildByName("LEFT"), "txt_no_base", arg_22_0.vars.base_equip == nil)
		if_set_visible(arg_22_0.vars.wnd:getChildByName("ITEM"), "txt_no_diff", arg_22_0.vars.diff_equip == nil)
	end
end

function UnitEquip.onLeave(arg_23_0, arg_23_1)
	if arg_23_0.vars.popup_mode then
		TopBarNew:pop()
		BackButtonManager:pop("TopBarNew." .. T("puton"))
	end
	
	arg_23_0.vars.equip_belt:hide()
	
	arg_23_0.old_args.unit = arg_23_0.vars.unit
	arg_23_0.old_args.pos = arg_23_0.vars.pos
	arg_23_0.old_args.diff_equip = arg_23_0.vars.diff_equip
	
	if arg_23_0.vars.is_artifact then
		UIAction:Add(SEQ(SLIDE_OUT_Y(200, -1200)), arg_23_0.vars.wnd:getChildByName("ARTIFACT"), "block")
	else
		UIAction:Add(SEQ(SLIDE_OUT(40, -600)), arg_23_0.vars.wnd:getChildByName("LEFT"), "block")
		UIAction:Add(SEQ(SLIDE_OUT_Y(200, -1200)), arg_23_0.vars.wnd:getChildByName("ITEM"), "block")
	end
	
	UIAction:Add(SEQ(MOVE_BY(200, 900)), arg_23_0.vars.wnd:getChildByName("n_custom_sorting"), "block")
	UIAction:Add(SEQ(DELAY(260), REMOVE()), arg_23_0.vars.wnd, "block")
	
	if UnitDetail.vars and get_cocos_refid(UnitDetail.vars.wnd) and arg_23_0.vars.unit then
		HeroBelt:getInst("UnitMain"):scrollToUnit(arg_23_0.vars.unit, 0)
	end
	
	arg_23_0.vars = nil
	
	Analytics:closePopup()
end

function UnitEquip.PutOn(arg_24_0, arg_24_1)
	local var_24_0 = Account:getUnit(arg_24_1.unit)
	local var_24_1 = Account:getEquip(arg_24_1.equip)
	local var_24_2 = Account:getEquip(arg_24_1.putoff_equip)
	
	if var_24_2 then
		var_24_0:removeEquip(var_24_2)
	end
	
	Account:updateCurrencies(arg_24_1)
	TopBarNew:topbarUpdate(true)
	
	if not var_24_0:addEquip(var_24_1) then
		return false
	end
	
	local var_24_3 = "event:/ui/equip/equip_" .. var_24_1.db.type
	
	if SoundEngine:existsEvent(var_24_3) then
		SoundEngine:play(var_24_3)
	else
		SoundEngine:play("event:/ui/equip_on")
	end
	
	if arg_24_0.vars then
		arg_24_0:onLeave()
	end
	
	arg_24_0:updateWearInfo(var_24_0, var_24_1)
	Inventory:UpdateContents(nil, {
		do_not_keep_pos = false
	})
	Inventory:PlayEquipSetEffect(var_24_0, var_24_1)
	
	if TutorialGuide:isPlayingTutorial("equip_install") then
		TutorialGuide:procGuide("equip_install")
	else
		TutorialGuide:forceClearTutorials({
			"equip_install"
		})
	end
	
	return true
end

function UnitEquip.resTotalChange(arg_25_0, arg_25_1)
	Account:updateCurrencies(arg_25_1)
	TopBarNew:topbarUpdate(true)
	
	for iter_25_0, iter_25_1 in pairs(arg_25_1.putons.unequip) do
		local var_25_0 = Account:getUnit(tonumber(iter_25_0))
		
		for iter_25_2, iter_25_3 in pairs(iter_25_1) do
			local var_25_1 = Account:getEquip(tonumber(iter_25_3))
			
			if var_25_0 ~= nil and var_25_1 ~= nil then
				var_25_0:removeEquip(var_25_1)
			end
		end
	end
	
	local var_25_2
	local var_25_3
	
	for iter_25_4, iter_25_5 in pairs(arg_25_1.putons.equip) do
		for iter_25_6, iter_25_7 in pairs(iter_25_5) do
			var_25_2 = Account:getUnit(tonumber(iter_25_4))
			var_25_3 = Account:getEquip(tonumber(iter_25_7))
		end
	end
	
	if not var_25_2:addEquip(var_25_3) then
		return 
	end
	
	if var_25_2 and var_25_3 then
		arg_25_0:updateCondition(var_25_2, var_25_3)
	end
	
	local var_25_4 = "event:/ui/equip/equip_" .. var_25_3.db.type
	
	if SoundEngine:existsEvent(var_25_4) then
		SoundEngine:play(var_25_4)
	else
		SoundEngine:play("event:/ui/equip_on")
	end
	
	if arg_25_0.vars then
		arg_25_0:onLeave()
	end
	
	arg_25_0:updateWearInfo(var_25_2, var_25_3)
	Inventory:UpdateContents(nil, {
		do_not_keep_pos = false
	})
	Inventory:PlayEquipSetEffect(var_25_2, var_25_3)
	
	if TutorialGuide:isPlayingTutorial("equip_install") then
		TutorialGuide:procGuide("equip_install")
	else
		TutorialGuide:forceClearTutorials({
			"equip_install"
		})
	end
end

function UnitEquip.updateCondition(arg_26_0, arg_26_1, arg_26_2)
	local var_26_0 = arg_26_2.code
	local var_26_1 = DB("equip_item", var_26_0, "type")
	local var_26_2 = arg_26_1.db.code
	local var_26_3 = arg_26_2:getEnhance()
	
	ConditionContentsManager:dispatch("equip.wear", {
		equiptype = var_26_1,
		charid = var_26_2,
		level = var_26_3
	})
end

function UnitEquip.updateWearInfo(arg_27_0, arg_27_1, arg_27_2)
	if SceneManager:getCurrentSceneName() == "unit_ui" or UnitDetail.vars and get_cocos_refid(UnitDetail.vars.wnd) then
		local var_27_0 = HeroBelt:getInst("UnitMain")
		
		if var_27_0:isValid() then
			var_27_0:updateUnit(nil, arg_27_1)
		end
		
		if UnitDetail:isValid() then
			UnitDetail:updateUnitInfo()
			
			if arg_27_2 then
				UIUtil:playEquipSetEffect(UnitDetail.vars.wnd, arg_27_1, arg_27_2)
			end
		end
	end
end

function UnitEquip.onButtonInfo(arg_28_0, arg_28_1)
	if arg_28_1 then
		local var_28_0 = Account:getEquip(arg_28_1)
		
		InventoryPopupDetail:Open(var_28_0)
	end
end

function UnitEquip.updateInfos(arg_29_0)
	if not arg_29_0.vars then
		return 
	end
	
	if arg_29_0.vars.equip_belt then
		arg_29_0.vars.equip_belt:updateList(arg_29_0:GetItems(arg_29_0.vars.unit, arg_29_0.vars.category, {
			ignore_stone = true
		}))
	end
	
	if arg_29_0.vars.base_equip_wnd then
		local var_29_0 = Account:getEquip(arg_29_0.vars.base_equip:getUID())
		
		arg_29_0:setBaseEquip(var_29_0)
	end
	
	if arg_29_0.vars.diff_equip_wnd then
		local var_29_1 = Account:getEquip(arg_29_0.vars.diff_equip:getUID())
		
		arg_29_0:setDiffEquip(var_29_1)
	end
end

function UnitEquip.PutOff(arg_30_0, arg_30_1)
	SoundEngine:play("event:/ui/equip_off")
	Account:updateCurrencies(arg_30_1)
	TopBarNew:topbarUpdate(true)
	
	local var_30_0
	local var_30_1 = {}
	
	for iter_30_0, iter_30_1 in pairs(arg_30_1.equips) do
		local var_30_2 = Account:getEquip(iter_30_1)
		
		if var_30_2 then
			var_30_0 = Account:getUnit(var_30_2.parent)
			
			if var_30_0 then
				var_30_0:removeEquip(var_30_2)
				
				if UnitEquip:isEquipBeltVisible() then
					arg_30_0.vars.equip_belt:updateList()
				end
				
				table.push(var_30_1, var_30_0)
			end
		end
	end
	
	if string.starts(arg_30_1.caller, "inventory") then
		Inventory:MSG_putoff_equip(arg_30_1)
	end
	
	arg_30_0:updateWearInfo(var_30_0)
	
	if SceneManager:getCurrentSceneName() == "unit_ui" then
		for iter_30_2, iter_30_3 in pairs(var_30_1) do
			HeroBelt:getInst("UnitMain"):updateUnit(nil, iter_30_3)
		end
		
		if UnitDetail:isValid() then
			UnitDetail:updateUnitInfo()
		end
	end
	
	if arg_30_0.vars then
		if get_cocos_refid(arg_30_0.vars.base_equip_wnd) then
			arg_30_0.vars.base_equip_wnd:removeFromParent()
		end
		
		arg_30_0.vars.base_equip_wnd = nil
		arg_30_0.vars.base_equip = nil
		
		arg_30_0:updateGuide()
		
		if arg_30_0.vars.diff_equip then
			arg_30_0:setDiffEquip(arg_30_0.vars.diff_equip)
		end
	end
	
	SkillEffectFilterManager:refreshUnit(var_30_0)
end

function UnitEquip.reqWearEquip(arg_31_0, arg_31_1)
	local var_31_0 = Account:getEquip(arg_31_1)
	local var_31_1 = arg_31_0.vars.unit
	
	TutorialGuide:procGuide("artifact_install")
	
	if var_31_0.db.character_group and var_31_0.db.character_group ~= var_31_1.db.set_group then
		balloon_message_with_sound("popup_artifact_character_diff")
		
		return 
	end
	
	if var_31_0.db.character and var_31_0.db.character ~= var_31_1.db.code then
		balloon_message_with_sound("popup_artifact_character_diff")
		
		return 
	end
	
	if var_31_0.db.role and var_31_0.db.role ~= var_31_1.db.role then
		balloon_message_with_sound("popup_artifact_role_diff")
		
		return 
	end
	
	if var_31_0.db.exclusive_unit and var_31_0.db.exclusive_unit ~= var_31_1.db.code then
		balloon_message_with_sound("popup_artifact_role_diff")
		
		return 
	end
	
	local var_31_2 = var_31_1:getEquipByPos(var_31_0.db.type)
	local var_31_3 = var_31_2 and var_31_2:getUnequipCost() or 0
	local var_31_4
	
	if var_31_0.parent then
		if var_31_0 == arg_31_0.vars.diff_equip and var_31_0.parent ~= var_31_1:getUID() then
			local var_31_5 = tostring(var_31_1:getUID())
			local var_31_6 = tostring(Account:getUnit(var_31_0.parent):getUID())
			local var_31_7 = {
				unequip = {},
				equip = {}
			}
			
			var_31_7.equip[var_31_5] = {
				var_31_0:getUID()
			}
			var_31_7.unequip[var_31_6] = {
				var_31_0:getUID()
			}
			
			if var_31_2 then
				var_31_7.unequip[var_31_5] = {
					var_31_2:getUID()
				}
			end
			
			var_31_3 = var_31_3 + var_31_0:getUnequipCost()
			
			function var_31_4()
				query("puton_equip_mass", {
					caller = "unit_equip",
					putons = json.encode(var_31_7)
				})
			end
		end
		
		if var_31_0 == arg_31_0.vars.base_equip then
			Inventory:ReqUnequip(var_31_0, "inventory_wear")
			
			return 
		end
	else
		function var_31_4()
			local var_33_0
			
			if var_31_2 then
				var_33_0 = var_31_2:getUID()
			end
			
			query("puton_equip", {
				unit = var_31_1:getUID(),
				equip = arg_31_1,
				putoff_equip = var_33_0
			})
		end
	end
	
	local var_31_8 = Booster:isActiveBoosterSubType(EVENT_BOOSTER_SUB_TYPE.EQUIP_ALL_FREE_EVENT)
	local var_31_9 = Booster:isActiveBoosterSubType(EVENT_BOOSTER_SUB_TYPE.EQUIP_NO_ARTI_FREE)
	local var_31_10 = Booster:isActiveBoosterSubType(EVENT_BOOSTER_SUB_TYPE.EQUIP_ARTI_FREE)
	
	if var_31_3 <= 0 or var_31_8 or var_31_0:isArtifact() and var_31_10 or not var_31_0:isArtifact() and var_31_9 then
		var_31_4()
		
		return 
	end
	
	if var_31_3 > Account:getCurrency("gold") then
		UIUtil:checkCurrencyDialog("gold")
		
		return 
	end
	
	Dialog:msgBox(T("equip_swap_desc", {
		cost = var_31_3
	}), {
		token = "to_gold",
		yesno = true,
		title = T("equip_change_title"),
		cost = var_31_3,
		handler = var_31_4
	})
end

function UnitEquip.onGameEvent(arg_34_0, arg_34_1, arg_34_2)
	if not arg_34_0.vars then
		return 
	end
	
	if (arg_34_1 == "inc_equip_inven" or arg_34_1 == "inc_artifact_inven") and arg_34_0:isEquipBeltVisible() then
		arg_34_0:getEquipBelt():UpdateEquipListCounter()
	end
end

function UnitEquip.onPushBackButton(arg_35_0)
end
