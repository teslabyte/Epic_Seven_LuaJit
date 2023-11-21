UnitSkin = {}
SKIN_TEST_MODE = false

function MsgHandler.change_skin(arg_1_0)
	Account:setUnitSkin(arg_1_0)
	UnitSkin:update()
	
	local var_1_0 = SceneManager:getCurrentSceneName()
	local var_1_1 = Account:getUnit(arg_1_0.unit_uid)
	
	var_1_1:updateUnitOptionValue(arg_1_0.unit_opt)
	
	if var_1_0 == "unit_ui" or var_1_0 == "pvp_team" or var_1_0 == "pvp" or UnitMain:isValid() then
		TopBarNew:setTitleName(T(var_1_1.db.name), "infounit1_2")
		UnitMain:updateFormation()
		UnitMain:getHeroBelt():updateUnit(nil, var_1_1)
		UnitDetail:updateUnitInfo(var_1_1)
		
		if UnitDetail:getCurDetailMode() == "Profile" and UnitDetailProfile:isVisible() then
			UnitDetailProfile:setMode(2)
		else
			UnitMain:removePortrait()
			UnitMain:changePortrait(var_1_1)
		end
	end
end

function HANDLER.unit_skin(arg_2_0, arg_2_1)
	if arg_2_1 == "btn_close" then
		UnitSkin:hide()
	end
	
	if arg_2_1 == "btn_wearing" then
		if arg_2_0:getOpacity() < 255 and not SKIN_TEST_MODE then
			balloon_message_with_sound("ui_skin_no_have")
			
			return 
		end
		
		UnitSkin:wear()
	end
	
	if arg_2_1 == "btn_preview" then
		UnitSkin:preview()
	end
	
	if arg_2_1 == "btn_buy" then
		UnitSkin:purchase()
	end
end

function HANDLER.unit_skin_preview(arg_3_0, arg_3_1)
	if arg_3_1 == "btn_close" then
		UnitSkin:hide()
	end
	
	if arg_3_1 == "btn_preview" then
		UnitSkin:preview()
	end
end

function UnitSkin.show(arg_4_0, arg_4_1, arg_4_2)
	arg_4_0.vars = {}
	arg_4_0.vars.wnd = load_dlg("unit_skin", true, "wnd")
	arg_4_0.vars.unit = arg_4_1
	arg_4_0.vars.dict_mode = arg_4_2
	
	arg_4_0:init()
	SceneManager:getRunningPopupScene():addChild(arg_4_0.vars.wnd)
	
	if not arg_4_2 then
		HeroBelt:getInst("UnitMain"):updateUnit(nil, arg_4_1)
		UnitInfosDetail:updateSkinAlert()
	end
	
	BackButtonManager:push({
		check_id = "unit_skin_popup",
		back_func = function()
			UnitSkin:hide()
		end
	})
end

function UnitSkin.createForOne(arg_6_0, arg_6_1)
	arg_6_0.vars = {}
	arg_6_0.vars.wnd = load_dlg("unit_skin_preview", true, "wnd")
	arg_6_0.vars.itemList = {}
	
	local var_6_0
	
	for iter_6_0 = 1, 9999 do
		local var_6_1 = DBN("character_skin", iter_6_0, "id")
		
		if not var_6_1 then
			break
		end
		
		local var_6_2 = false
		
		for iter_6_1 = 1, GAME_STATIC_VARIABLE.max_skin_count or 3 do
			local var_6_3 = string.format("skin%02d", iter_6_1)
			local var_6_4 = string.format("skin%02d_ma", iter_6_1)
			local var_6_5, var_6_6 = DBN("character_skin", iter_6_0, {
				var_6_3,
				var_6_4
			})
			
			if arg_6_1 == var_6_6 then
				table.insert(arg_6_0.vars.itemList, {
					code = var_6_5,
					material = var_6_6
				})
				
				var_6_2 = true
				var_6_0 = var_6_1
				
				break
			end
		end
		
		if var_6_2 then
			break
		end
	end
	
	if table.count(arg_6_0.vars.itemList) == 0 then
		return 
	end
	
	arg_6_0:setSkin()
	
	local var_6_7 = Account:getCollectionUnit(var_6_0) ~= nil and "skin_preview_popup_have_hero" or "skin_preview_popup_no_hero"
	local var_6_8 = arg_6_0.vars.wnd:getChildByName("n_info_none")
	
	if_set_visible(var_6_8, nil, true)
	if_set(var_6_8, "label", T(var_6_7))
	
	return arg_6_0.vars.wnd
end

function UnitSkin.hide(arg_7_0)
	BackButtonManager:pop("unit_skin_popup")
	
	if get_cocos_refid(arg_7_0.vars.wnd) then
		arg_7_0.vars.wnd:removeFromParent()
	end
	
	arg_7_0.vars.wnd = nil
end

function UnitSkin.changeSkin(arg_8_0)
end

function UnitSkin.getSkinList(arg_9_0, arg_9_1)
	return UIUtil:getSkinList(arg_9_1.inst.code)
end

function UnitSkin.init(arg_10_0)
	local var_10_0 = arg_10_0.vars.wnd:getChildByName("listview")
	
	arg_10_0.vars.itemList = arg_10_0:getSkinList(arg_10_0.vars.unit)
	arg_10_0.vars.itemView = ItemListView_v2:bindControl(var_10_0)
	
	local var_10_1 = arg_10_0.vars.unit:getSkinCode() or arg_10_0.vars.itemList[#arg_10_0.vars.itemList].code
	local var_10_2 = load_control("wnd/unit_skin_item.csb")
	
	if var_10_0.STRETCH_INFO then
		local var_10_3 = var_10_0:getContentSize()
		
		resetControlPosAndSize(var_10_2, var_10_3.width, var_10_0.STRETCH_INFO.width_prev)
	end
	
	arg_10_0:selectItem(var_10_1, true)
	
	local var_10_4 = {
		onUpdate = function(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
			if_set_visible(arg_11_1, "bg_select", arg_10_0.vars.selected == arg_11_3.code)
			
			local var_11_0 = DB("character", arg_11_3.code, "face_id")
			
			replaceSprite(arg_11_1, "face", "face/" .. var_11_0 .. "_s.png")
			if_set_visible(arg_11_1, "tag_bg", not arg_11_3.material)
			
			local var_11_1 = DB("item_material", arg_11_3.material, "grade") or 1
			local var_11_2 = UIUtil:getSkinGradeBorder(var_11_1)
			local var_11_3 = UIUtil:getSkinGradeBG(var_11_1)
			
			replaceSprite(arg_11_1, "frame", "item/border/" .. var_11_2 .. ".png")
			replaceSprite(arg_11_1, "frame_bg", "img/" .. var_11_3 .. ".png")
			
			if arg_11_3.material then
				arg_11_1:setColor(Account:getItemCount(arg_11_3.material) > 0 and cc.c3b(255, 255, 255) or cc.c3b(75, 75, 75))
			end
			
			return arg_11_3.code
		end,
		onTouchDown = function(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
			arg_10_0:selectItem(arg_12_3.code)
			arg_10_0.vars.itemView:refresh()
		end
	}
	
	arg_10_0.vars.itemView:setRenderer(var_10_2, var_10_4)
	arg_10_0.vars.itemView:removeAllChildren()
	arg_10_0.vars.itemView:setDataSource(arg_10_0.vars.itemList)
	
	local var_10_5 = false
	
	for iter_10_0, iter_10_1 in pairs(arg_10_0.vars.itemList) do
		if iter_10_1.material then
			local var_10_6 = Account:getItemCount(iter_10_1.material) ~= 0
			local var_10_7 = SAVE:get("skin:" .. iter_10_1.material)
			
			if var_10_6 and not var_10_7 then
				SAVE:set("skin:" .. iter_10_1.material, true)
				
				var_10_5 = true
			end
		end
	end
	
	if var_10_5 then
		SAVE:save()
	end
end

function UnitSkin.selectItem(arg_13_0, arg_13_1, arg_13_2)
	if not table.find(arg_13_0.vars.itemList, function(arg_14_0, arg_14_1)
		return arg_13_1 == arg_14_1.code
	end) then
		return 
	end
	
	local var_13_0 = arg_13_0.vars.selected
	
	arg_13_0.vars.selected = arg_13_1
	
	arg_13_0:update(arg_13_2 or var_13_0 ~= arg_13_1)
end

function UnitSkin.setSkin(arg_15_0)
	arg_15_0.vars.selected = arg_15_0.vars.itemList[1].code
	
	arg_15_0:update(true)
end

function UnitSkin.update(arg_16_0, arg_16_1)
	if not arg_16_0.vars or not get_cocos_refid(arg_16_0.vars.wnd) then
		return 
	end
	
	local var_16_0 = table.find(arg_16_0.vars.itemList, function(arg_17_0, arg_17_1)
		return arg_16_0.vars.selected == arg_17_1.code
	end)
	
	if not var_16_0 then
		return 
	end
	
	local var_16_1 = arg_16_0.vars.itemList[var_16_0]
	local var_16_2 = DBT("character", arg_16_0.vars.selected, {
		"name",
		"model_id",
		"face_id",
		"model_opt",
		"skin",
		"atlas",
		"model_id2",
		"skin_group",
		"skin_check"
	})
	
	if not var_16_2 then
		return 
	end
	
	local var_16_3, var_16_4, var_16_5, var_16_6, var_16_7, var_16_8 = DB("item_material", var_16_1.material, {
		"id",
		"name",
		"ma_type",
		"grade",
		"desc_category",
		"desc"
	})
	
	if var_16_3 then
		if_set(arg_16_0.vars.wnd, "t_skin_grade", T(var_16_7))
		if_set(arg_16_0.vars.wnd, "t_skin_name", T(var_16_4))
		if_set(arg_16_0.vars.wnd, "t_skin_desc", T(var_16_8))
		if_set_opacity(arg_16_0.vars.wnd, "btn_wearing", Account:getItemCount(var_16_3) > 0 and 255 or 76)
	else
		if_set(arg_16_0.vars.wnd, "t_skin_grade", T("item_category_skin_normal"))
		if_set(arg_16_0.vars.wnd, "t_skin_name", T("item_skin_normal_name"))
		if_set(arg_16_0.vars.wnd, "t_skin_desc", T("item_skin_normal_desc"))
		if_set_opacity(arg_16_0.vars.wnd, "btn_wearing", 255)
	end
	
	if arg_16_0.vars.unit then
		local var_16_9 = arg_16_0.vars.unit:getSkinCode() or arg_16_0.vars.itemList[#arg_16_0.vars.itemList].code
		
		if_set_visible(arg_16_0.vars.wnd, "btn_wearing", false)
		if_set_visible(arg_16_0.vars.wnd, "n_current", false)
		if_set_visible(arg_16_0.vars.wnd, "btn_buy", false)
		
		if not arg_16_0.vars.dict_mode then
			if var_16_9 == arg_16_0.vars.selected then
				if_set_visible(arg_16_0.vars.wnd, "n_current", true)
			elseif Account:getItemCount(var_16_3) > 0 or arg_16_0.vars.selected == var_16_2.skin_group or var_16_2.skin_check == nil then
				if_set_visible(arg_16_0.vars.wnd, "btn_wearing", true)
			else
				if_set_visible(arg_16_0.vars.wnd, "btn_buy", true)
				
				if arg_16_0:canPurchasable() then
					if_set_opacity(arg_16_0.vars.wnd, "btn_buy", 255)
				else
					if_set_opacity(arg_16_0.vars.wnd, "btn_buy", 76.5)
				end
			end
		end
	end
	
	if not arg_16_1 then
		return 
	end
	
	local var_16_10 = CACHE:getModel(var_16_2.model_id, var_16_2.skin, "idle", var_16_2.atlas, var_16_2.model_opt)
	local var_16_11 = arg_16_0.vars.wnd:getChildByName("n_pos_character")
	
	if get_cocos_refid(var_16_11) then
		var_16_11:removeAllChildren()
		var_16_11:addChild(var_16_10)
		
		if var_16_2.model_id2 then
			local var_16_12 = CACHE:getModel(var_16_2.model_id2, var_16_2.skin, "idle", var_16_2.atlas, var_16_2.model_opt)
			
			var_16_11:addChild(var_16_12)
			var_16_10:setPositionX(-30)
			var_16_12:setPositionX(30)
		end
	end
	
	local var_16_13, var_16_14 = UIUtil:getPortraitAni(var_16_2.face_id, {
		pin_sprite_position_y = true
	})
	
	if get_cocos_refid(var_16_13) then
		if not var_16_14 then
			var_16_13:setPositionY(var_16_13:getPositionY() + 400)
		end
		
		local var_16_15 = arg_16_0.vars.wnd:getChildByName("n_portrait")
		
		if get_cocos_refid(var_16_15) then
			var_16_15:removeAllChildren()
			var_16_15:addChild(var_16_13)
		end
	end
	
	local var_16_16 = arg_16_0.vars.wnd:getChildByName("t_skin_name")
	local var_16_17 = arg_16_0.vars.wnd:getChildByName("t_skin_grade")
	local var_16_18 = var_16_16:getStringNumLines()
	
	if var_16_18 > 1 then
		local var_16_19 = 5 + (var_16_18 - 1) * 21
		
		if get_cocos_refid(var_16_17) then
			if not var_16_17.origin_y then
				var_16_17.origin_y = var_16_17:getPositionY()
			end
			
			var_16_17:setPositionY(var_16_17.origin_y + var_16_19)
		end
	else
		if not var_16_17.origin_y then
			var_16_17.origin_y = var_16_17:getPositionY()
		end
		
		var_16_17:setPositionY(var_16_17.origin_y)
	end
	
	local var_16_20 = var_16_6 == 5
	
	if_set_visible(arg_16_0.vars.wnd, "n_voice", var_16_20)
	
	local var_16_21 = arg_16_0.vars.wnd:getChildByName("n_info")
	local var_16_22 = arg_16_0.vars.wnd:getChildByName("n_move_info")
	
	if get_cocos_refid(var_16_21) and get_cocos_refid(var_16_22) then
		if not var_16_21.origin_x then
			var_16_21.origin_x = var_16_21:getPositionX()
		end
		
		if not var_16_21.origin_y then
			var_16_21.origin_y = var_16_21:getPositionY()
		end
		
		if var_16_20 then
			var_16_21:setPosition(var_16_22:getPositionX(), var_16_22:getPositionY())
		else
			var_16_21:setPosition(var_16_21.origin_x, var_16_21.origin_y)
		end
	end
	
	local var_16_23 = arg_16_0.vars.wnd:getChildByName("n_skin_info")
	local var_16_24 = arg_16_0.vars.wnd:getChildByName("n_move_skin_info")
	
	if arg_16_0.vars.dict_mode and get_cocos_refid(var_16_23) and get_cocos_refid(var_16_24) then
		var_16_23:setPositionY(var_16_24:getPositionY())
	end
	
	if_set_color(arg_16_0.vars.wnd, "t_skin_grade", UIUtil:getGradeColor(nil, var_16_6 or 1))
end

function UnitSkin.canPurchasable(arg_18_0)
	if not arg_18_0.vars.selected then
		return nil
	end
	
	local var_18_0 = table.find(arg_18_0.vars.itemList, function(arg_19_0, arg_19_1)
		return arg_18_0.vars.selected == arg_19_1.code
	end)
	
	if not var_18_0 then
		return nil
	end
	
	local var_18_1 = arg_18_0.vars.itemList[var_18_0]
	
	if var_18_1.material and AccountData.skinshop_itemlist then
		for iter_18_0, iter_18_1 in pairs(AccountData.skinshop_itemlist or {}) do
			if iter_18_1 == var_18_1.material then
				return "shop", var_18_1.material
			end
		end
	end
	
	local var_18_2 = SeasonPass:getOpenSeasonID() or SeasonPass:getRewardableSeasonID()
	
	if var_18_2 then
		local var_18_3 = SeasonPass:getSchedule(var_18_2)
		
		if var_18_3 and var_18_3.main_db and var_18_3.main_db.skin_id == arg_18_0.vars.selected then
			return "seasonpass"
		end
	end
	
	return nil
end

function UnitSkin.purchase(arg_20_0)
	if not arg_20_0.vars.unit or arg_20_0.vars.dict_mode then
		return 
	end
	
	local var_20_0, var_20_1 = arg_20_0:canPurchasable()
	
	if not var_20_0 then
		balloon_message_with_sound("err_skin_popup_cannot_purchase")
		
		return 
	end
	
	arg_20_0:hide()
	
	if var_20_0 == "shop" and var_20_1 then
		Shop:open("normal", "skin", {
			tab_opts = {
				default_skin_material_id = var_20_1
			}
		})
	elseif var_20_0 == "seasonpass" then
		local var_20_2 = SeasonPass:getOpenSeasonID() or SeasonPass:getRewardableSeasonID()
		
		if var_20_2 then
			SeasonPassBase:open(var_20_2, function()
				TopBarNew:updateSeasonPass()
			end)
		end
	end
end

function UnitSkin.wear(arg_22_0)
	query("change_skin", {
		unit_uid = arg_22_0.vars.unit.inst.uid,
		skin_code = arg_22_0.vars.selected
	})
end

function UnitSkin.CheckNotification(arg_23_0, arg_23_1)
	local var_23_0 = arg_23_0:getSkinList(arg_23_1)
	
	for iter_23_0, iter_23_1 in pairs(var_23_0) do
		if iter_23_1.material then
			local var_23_1 = Account:getItemCount(iter_23_1.material) > 0
			local var_23_2 = SAVE:get("skin:" .. iter_23_1.material)
			
			if var_23_1 and not var_23_2 then
				return true
			end
		end
	end
	
	return false
end

function UnitSkin.CheckNotificationByMaterialID(arg_24_0, arg_24_1)
	if not arg_24_1 then
		return false
	end
	
	local var_24_0 = Account:getItemCount(arg_24_1) > 0
	local var_24_1 = SAVE:get("skin:" .. arg_24_1)
	
	if var_24_0 and not var_24_1 then
		return true
	end
	
	return false
end

function UnitSkin.preview(arg_25_0)
	if ContentDisable:checkDisableUnitByAlias("preview_skills", arg_25_0.vars.selected) then
		balloon_message_with_sound("skill_preview_lock_info")
		
		return 
	end
	
	SceneManager:cancelReseveResetSceneFlow()
	startSkillPreview(arg_25_0.vars.selected)
end
