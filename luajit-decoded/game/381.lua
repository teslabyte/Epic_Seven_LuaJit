UnitIntimacy = {}

function HANDLER.hero_detail_intimacy_present(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_close" then
		UnitIntimacy:closePresent()
		
		return 
	elseif arg_1_1 == "btn_cancle" then
		if UnitIntimacy.vars.present.select_items and table.count(UnitIntimacy.vars.present.select_items) > 0 then
			UnitIntimacy.vars.present.select_items = {}
			
			UnitIntimacy.vars.present.itemView:refresh()
		end
	elseif arg_1_1 == "btn_ok" then
		if UnitIntimacy.vars.present.select_items and table.count(UnitIntimacy.vars.present.select_items) > 0 and UnitIntimacy.vars.unit:getFavLevel() < 10 then
			UnitIntimacy:addIntimacy()
		end
	elseif arg_1_1 == "btn_select" then
		UnitIntimacy:touchIntimacyItem(arg_1_0.datasource, arg_1_0:getParent())
	end
	
	UnitIntimacy:updatePresentWnd(UnitIntimacy:getIntimacyData())
end

function MsgHandler.add_intimacy(arg_2_0)
	for iter_2_0, iter_2_1 in pairs(arg_2_0.items) do
		Account:setItemCount(iter_2_0, iter_2_1)
	end
	
	Account:updateCurrencies(arg_2_0)
	TopBarNew:topbarUpdate(true)
	UnitIntimacy:updateUnitIntimacy(arg_2_0)
	UnitIntimacy:initListView()
	UnitIntimacy:resetPresentPopup()
	
	local var_2_0 = HeroBelt:getInst("UnitMain")
	local var_2_1 = {}
	local var_2_2 = UnitIntimacy.vars.unit
	
	if var_2_2 then
		local var_2_3, var_2_4 = var_2_2:getFavLevel(arg_2_0.org_xp)
		local var_2_5, var_2_6 = var_2_2:getFavLevel(arg_2_0.cur_exp)
		
		var_2_1[var_2_2.db.code] = {
			prev_exp = var_2_4,
			curr_exp = var_2_6,
			prev_lv = var_2_3,
			curr_lv = var_2_5
		}
		
		if var_2_3 < var_2_5 then
			ConditionContentsManager:dispatch("fav.levelup", {
				level = var_2_5,
				prev_level = var_2_3,
				code = var_2_2.db.code,
				uid = var_2_2.inst.uid
			})
		end
		
		if var_2_0 then
			var_2_0:update()
			var_2_0:scrollToUnit(var_2_2, 0)
			var_2_0:updateSelectedControlColor(var_2_2)
		end
	end
	
	if var_2_2:getFavLevel(arg_2_0.cur_exp) >= 10 then
		UnitIntimacy:closePresent()
	end
	
	var_2_2 = var_2_2 or UnitInfosController:getUnit()
	
	if var_2_2:getFavLevel(arg_2_0.org_xp) < var_2_2:getFavLevel(arg_2_0.cur_exp) then
		UnitIntimacy:closePresent()
		ClearResult:addPopupFavLevelUp(var_2_2, false, false, true, {
			units_favexp = var_2_1,
			cur_exp = arg_2_0.cur_exp,
			org_exp = arg_2_0.org_xp
		})
	end
end

function UnitIntimacy.open(arg_3_0, arg_3_1)
	if arg_3_0.vars and get_cocos_refid(arg_3_0.vars.wnd) then
		return 
	end
	
	if not arg_3_1 then
		return 
	end
	
	arg_3_0.vars = {}
	arg_3_0.vars.wnd = load_dlg("hero_detail_intimacy", true, "wnd")
	arg_3_0.vars.unit = arg_3_1
	arg_3_0.vars.fav_lv = arg_3_1:getFavLevel()
	
	local var_3_0 = arg_3_1.inst.skin_code or arg_3_1.db.code
	
	arg_3_0.vars.birth_grade = DB("character", var_3_0, "grade") or 3
	
	arg_3_0:init()
	SceneManager:getRunningNativeScene():addChild(arg_3_0.vars.wnd)
	arg_3_0.vars.wnd:bringToFront()
	arg_3_0.vars.wnd:setOpacity(0)
	UIAction:Add(LOG(FADE_IN(250)), arg_3_0.vars.wnd, "block")
end

function UnitIntimacy.init(arg_4_0)
	if not arg_4_0.vars or not get_cocos_refid(arg_4_0.vars.wnd) or not arg_4_0.vars.birth_grade then
		return 
	end
	
	if_set_visible(arg_4_0.vars.wnd, "n_intimacy10", false)
	if_set_visible(arg_4_0.vars.wnd, "txt_skillpoint_disc", false)
	
	if arg_4_0.vars.birth_grade > 3 then
		UIUtil:getRewardIcon(nil, "ma_skillpoint", {
			no_tooltip = false,
			no_bg = true,
			no_grade = true,
			parent = arg_4_0.vars.wnd:getChildByName("n_skill_icon")
		})
		
		if arg_4_0.vars.fav_lv < 10 then
			if_set_visible(arg_4_0.vars.wnd, "txt_skillpoint_disc", true)
			if_set(arg_4_0.vars.wnd, "txt_skillpoint_disc", T("ui_intimacy_info_sp_desc"))
			if_set_visible(arg_4_0.vars.wnd, "img_locked", arg_4_0.vars.fav_lv < 10)
		else
			if_set_visible(arg_4_0.vars.wnd, "txt_skillpoint_disc", false)
			if_set_visible(arg_4_0.vars.wnd, "n_intimacy10", true)
			if_set(arg_4_0.vars.wnd, "txt_complete", T("ui_intimacy_complete_desc"))
			if_set(arg_4_0.vars.wnd, "txt_skillpoint_disc2", T("ui_intimacy_skillup_desc"))
		end
		
		if_set_opacity(arg_4_0.vars.wnd, "n_skill_icon", arg_4_0.vars.fav_lv < 10 and 76.5 or 255)
	end
	
	local var_4_0 = {
		"c3026"
	}
	
	if table.isInclude(var_4_0, arg_4_0.vars.unit.db.code) then
		if_set_visible(arg_4_0.vars.wnd, "txt_skillpoint_disc", true)
		if_set_visible(arg_4_0.vars.wnd, "n_intimacy10", false)
		if_set(arg_4_0.vars.wnd, "txt_skillpoint_disc", T("ui_intimacy_info_sp_desc_c3026"))
		
		local var_4_1 = arg_4_0.vars.wnd:getChildByName("n_skillpoint")
		
		if_set_visible(var_4_1, "img_locked", true)
		if_set_opacity(arg_4_0.vars.wnd, "n_skill_icon", 76.5)
	end
end

function UnitIntimacy.close(arg_5_0)
	if not arg_5_0.vars or not get_cocos_refid(arg_5_0.vars.wnd) then
		return 
	end
	
	arg_5_0.vars.wnd:removeFromParent()
	
	arg_5_0.vars = {}
end

function UnitIntimacy.getIntimacyData(arg_6_0, arg_6_1)
	if not arg_6_0.vars then
		arg_6_0.vars = {}
		arg_6_0.vars.fav_lv = arg_6_1:getFavLevel()
	end
	
	arg_6_0.vars.unit = arg_6_1 or arg_6_0.vars.unit
	
	if not arg_6_0.vars.unit then
		return 
	end
	
	if not arg_6_0.vars.unit:canUseIntimacy() then
		return 
	end
	
	local var_6_0 = {
		unit = arg_6_0.vars.unit
	}
	
	var_6_0.unit_name = var_6_0.unit.db.name
	var_6_0.unit_code = var_6_0.unit.db.code
	var_6_0.unit_skin = var_6_0.unit.inst.skin_code
	var_6_0.unit_role = var_6_0.unit.db.role
	var_6_0.unit_class = var_6_0.unit.db.class
	var_6_0.unit_grade = var_6_0.unit:getGrade()
	var_6_0.unit_attribute = var_6_0.unit.db.ch_attribute
	var_6_0.unit_intimacy_exp = var_6_0.unit:getFav()
	var_6_0.unit_zodiac_grade = var_6_0.unit:getZodiacGrade()
	var_6_0.unit_intimacy_lv, var_6_0.unit_intimacy_exp_ratio = var_6_0.unit:getFavLevel()
	var_6_0.is_max_intimacy_lv = var_6_0.unit_intimacy_lv >= 10
	
	return var_6_0
end

function UnitIntimacy.initPresentWnd(arg_7_0, arg_7_1, arg_7_2)
	if not arg_7_0.vars.present then
		return 
	end
	
	arg_7_2 = arg_7_2 or {}
	arg_7_1 = arg_7_1 or {}
	
	if arg_7_0.vars.present.wnd:getChildByName("star1") then
		if arg_7_2.hide_star then
			for iter_7_0 = 1, 6 do
				if_set_visible(arg_7_0.vars.present.wnd, "star" .. iter_7_0, false)
			end
		elseif not arg_7_2.use_basic_star then
			UIUtil:setStarsByUnit(arg_7_0.vars.present.wnd, arg_7_1.unit)
		end
	end
	
	if_set(arg_7_0.vars.present.wnd, "txt_name", T(arg_7_1.unit_name))
	
	local var_7_0 = arg_7_0.vars.present.wnd:getChildByName("txt_color")
	
	if_set(var_7_0, nil, T("hero_ele_" .. arg_7_1.unit_attribute))
	SpriteCache:resetSprite(arg_7_0.vars.present.wnd:getChildByName("color"), UIUtil:getColorIcon(arg_7_0.vars.unit))
	if_call(arg_7_0.vars.present.wnd, "n_role", "setPositionX", var_7_0:getPositionX() + var_7_0:getContentSize().width * var_7_0:getScaleX() + 6)
	if_set(arg_7_0.vars.present.wnd, "txt_role", T("ui_hero_role_" .. arg_7_1.unit_role))
	SpriteCache:resetSprite(arg_7_0.vars.present.wnd:getChildByName("role"), "img/cm_icon_role_" .. arg_7_0.vars.unit.db.role .. ".png")
	UIUtil:getRewardIcon(nil, arg_7_1.unit_skin or arg_7_1.unit_code, {
		no_popup = true,
		scale = 1,
		no_grade = true,
		parent = arg_7_0.vars.present.wnd:getChildByName("mob_icon")
	})
	arg_7_0:initListView()
	if_set_visible(arg_7_0.vars.present.wnd, "upgrade", false)
	if_set_visible(arg_7_0.vars.present.wnd, "n_intimacy_up", false)
	arg_7_0:updatePresentWnd(arg_7_1)
	if_set_opacity(arg_7_0.vars.present.wnd, "btn_cancle", 76.5)
	if_set_opacity(arg_7_0.vars.present.wnd, "btn_ok", 76.5)
end

function UnitIntimacy.isMyBonus(arg_8_0, arg_8_1)
	if not arg_8_1 then
		return 
	end
	
	if arg_8_0.vars.unit.db.color == arg_8_1.target then
		return true
	elseif arg_8_0.vars.unit.db.role == arg_8_1.target then
		return true
	elseif arg_8_0.vars.unit.db.code == arg_8_1.target then
		return true
	end
	
	return false
end

function UnitIntimacy.callback_count(arg_9_0)
	if not arg_9_0.vars.present or not arg_9_0.vars.present.count_wnd then
		return 
	end
	
	arg_9_0.vars.present.count_wnd:removeFromParent()
	
	arg_9_0.vars.present.count_wnd = nil
	
	BackButtonManager:pop()
end

function UnitIntimacy.handler_count(arg_10_0)
	if not arg_10_0.vars.present or not arg_10_0.vars.present.count_wnd then
		return 
	end
	
	arg_10_0.vars.present.use_count = arg_10_0.vars.present.count_wnd.slider:getPercent()
	
	if_set(arg_10_0.vars.present.count_wnd, "t_count", arg_10_0.vars.present.count_wnd.slider:getPercent() .. "/" .. arg_10_0.vars.present.count_wnd.slider:getMaxPercent())
	
	if arg_10_0.vars.present.count_wnd.slider:getPercent() > Dialog.count.req_count then
		if_set_opacity(arg_10_0.vars.present.count_wnd, "btn_plus", 76.5)
		if_set_opacity(arg_10_0.vars.present.count_wnd, "btn_max", 76.5)
	else
		if_set_opacity(arg_10_0.vars.present.count_wnd, "btn_plus", 255)
		if_set_opacity(arg_10_0.vars.present.count_wnd, "btn_max", 255)
	end
end

function UnitIntimacy.handler_count_button(arg_11_0)
	if not arg_11_0.vars.present or not arg_11_0.vars.present.count_wnd then
		return 
	end
	
	if arg_11_0.vars.present.use_count <= 0 then
		arg_11_0.vars.present.use_count = 1
	end
	
	arg_11_0:updateList()
	arg_11_0:updatePresentWnd(arg_11_0:getIntimacyData())
	arg_11_0:callback_count()
end

function UnitIntimacy.addIntimacy(arg_12_0)
	if not arg_12_0.vars.present.select_items or table.count(arg_12_0.vars.present.select_items) <= 0 then
		return 
	end
	
	local function var_12_0()
		local var_13_0 = {
			target = arg_12_0.vars.unit:getUID(),
			items = json.encode(arg_12_0.vars.present.select_items),
			curr_point = arg_12_0.vars.unit:getPoint()
		}
		
		query("add_intimacy", var_13_0)
	end
	
	if arg_12_0.vars.unit:getFav() + arg_12_0:calcSelectedItemsEXP() > 1500 then
		Dialog:msgBox(T("msg_char_intimacy_exp_over"), {
			yesno = true,
			handler = var_12_0
		}):setLocalZOrder(1000000)
	else
		var_12_0()
	end
end

function UnitIntimacy.updateList(arg_14_0)
	if arg_14_0.vars.present.count_wnd and arg_14_0.vars.present.count_wnd.item and arg_14_0.vars.present.use_count >= arg_14_0.vars.present.count_wnd.item.count then
		if_set_opacity(arg_14_0.vars.present.selected_item_node, "bg_item", 76.5)
	end
	
	local var_14_0 = arg_14_0.vars.present.selected_item_node:getChildByName("txt_value")
	
	var_14_0:setTextColor(tocolor("#6bc11b"))
	var_14_0:setString(arg_14_0.vars.present.count_wnd.item.count - arg_14_0.vars.present.use_count .. "(-" .. arg_14_0.vars.present.use_count .. ")")
	if_set_visible(arg_14_0.vars.present.selected_item_node, "select_material", true)
	if_set_visible(arg_14_0.vars.present.selected_item_node, "icon_check_material", true)
	
	local var_14_1 = arg_14_0.vars.present.count_wnd.item
	
	arg_14_0.vars.present.select_items[var_14_1.code] = var_14_1
	arg_14_0.vars.present.select_items[var_14_1.code].total_exp = var_14_1.xp
	
	if arg_14_0:isMyBonus(var_14_1.intimacy_bonus) then
		arg_14_0.vars.present.select_items[var_14_1.code].total_exp = arg_14_0.vars.present.select_items[var_14_1.code].total_exp * var_14_1.intimacy_bonus.bonus
	end
	
	arg_14_0.vars.present.select_items[var_14_1.code].total_exp = arg_14_0.vars.present.select_items[var_14_1.code].total_exp * arg_14_0.vars.present.use_count
	arg_14_0.vars.present.select_items[var_14_1.code].use_count = arg_14_0.vars.present.use_count
end

function UnitIntimacy.updateUnitIntimacy(arg_15_0, arg_15_1)
	if not arg_15_0.vars.unit then
		return 
	end
	
	arg_15_0.vars.unit.inst.fav = arg_15_1.cur_exp
	arg_15_0.vars.fav_lv = arg_15_0.vars.unit:getFavLevel()
	arg_15_0.vars.select_fav_lv = arg_15_0.vars.fav_lv
	
	if UnitIntimacy.vars and get_cocos_refid(UnitIntimacy.vars.wnd) then
		arg_15_0:selectFavLevel(arg_15_0.vars.select_fav_lv)
		arg_15_0:updatePopup()
	end
	
	UnitDetail:updateUnitInfo(arg_15_0.vars.unit)
end

function UnitIntimacy.resetPresentPopup(arg_16_0)
	arg_16_0.vars.present.select_items = {}
	
	arg_16_0:updatePresentWnd(arg_16_0:getIntimacyData())
end

function UnitIntimacy.touchIntimacyItem(arg_17_0, arg_17_1, arg_17_2)
	if not arg_17_0.vars.present or not arg_17_1 then
		return 
	end
	
	arg_17_0.vars.present.select_items = arg_17_0.vars.present.select_items or {}
	
	if_set_opacity(arg_17_2, "bg_item", 255)
	
	local var_17_0 = arg_17_2:getChildByName("txt_value")
	
	if arg_17_0.vars.present.select_items[arg_17_1.code] then
		if_set_visible(arg_17_2, "select_material", false)
		if_set_visible(arg_17_2, "icon_check_material", false)
		var_17_0:setString(arg_17_1.count)
		var_17_0:setTextColor(tocolor("#FFFFFF"))
		
		arg_17_0.vars.present.select_items[arg_17_1.code] = nil
	else
		if arg_17_0.vars.unit:getFav() + arg_17_0:calcSelectedItemsEXP() >= 1500 then
			balloon_message_with_sound("msg_over_intimacy_exp_max")
			
			return 
		end
		
		arg_17_0.vars.present.use_count = 0
		
		if arg_17_1.count > 1 then
			local var_17_1 = 1500 - arg_17_0.vars.unit:getFav() - arg_17_0:calcSelectedItemsEXP()
			
			arg_17_0.vars.present.max_count = 1
			
			if var_17_1 > 0 then
				local var_17_2 = arg_17_1.xp
				
				if arg_17_0:isMyBonus(arg_17_1.intimacy_bonus) then
					var_17_2 = var_17_2 * arg_17_1.intimacy_bonus.bonus
				end
				
				arg_17_0.vars.present.max_count = math.ceil(var_17_1 / var_17_2)
			end
			
			arg_17_0.vars.present.count_wnd = Dialog:openCountPopup({
				t_req = "msg_over_intimacy_exp_max_count",
				wnd = arg_17_0.vars.present.wnd,
				max_count = arg_17_0.vars.present.max_count >= arg_17_1.count and arg_17_1.count or arg_17_0.vars.present.max_count,
				req_count = arg_17_0.vars.present.max_count,
				back_func = function()
					arg_17_0:callback_count()
				end,
				slider_func = function()
					arg_17_0:handler_count()
				end,
				button_func = function()
					arg_17_0:handler_count_button()
				end
			})
			arg_17_0.vars.present.count_wnd.item = arg_17_1
			arg_17_0.vars.present.selected_item_node = arg_17_2
		else
			arg_17_0.vars.present.use_count = 1
			arg_17_0.vars.present.select_items[arg_17_1.code] = arg_17_1
			arg_17_0.vars.present.select_items[arg_17_1.code].use_count = arg_17_0.vars.present.use_count
		end
		
		if arg_17_0.vars.present.select_items[arg_17_1.code] then
			arg_17_0.vars.present.select_items[arg_17_1.code].total_exp = 0
			arg_17_0.vars.present.select_items[arg_17_1.code].total_exp = arg_17_1.xp
			
			if arg_17_0:isMyBonus(arg_17_1.intimacy_bonus) then
				arg_17_0.vars.present.select_items[arg_17_1.code].total_exp = arg_17_0.vars.present.select_items[arg_17_1.code].total_exp * arg_17_1.intimacy_bonus.bonus
			end
		end
		
		if arg_17_0.vars.present.use_count > 0 then
			if arg_17_0.vars.present.use_count >= arg_17_1.count then
				if_set_opacity(arg_17_2, "bg_item", 76.5)
			end
			
			var_17_0:setString(arg_17_1.count - arg_17_0.vars.present.use_count .. "(-" .. arg_17_0.vars.present.use_count .. ")")
			var_17_0:setTextColor(tocolor("#6bc11b"))
		elseif not arg_17_0.vars.present.count_wnd then
			arg_17_0.vars.present.select_items[arg_17_1.code] = nil
		end
		
		if_set_visible(arg_17_2, "select_material", arg_17_0.vars.present.use_count > 0)
		if_set_visible(arg_17_2, "icon_check_material", arg_17_0.vars.present.use_count > 0)
	end
end

function UnitIntimacy.updateListViewItem(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	if_set_visible(arg_21_1, "icon_check", false)
	if_set_visible(arg_21_1, "equip", false)
	if_set_visible(arg_21_1, "select", false)
	if_set_visible(arg_21_1, "n_num", false)
	if_set_visible(arg_21_1, "icon_type", false)
	if_set_visible(arg_21_1, "select_material", false)
	if_set_visible(arg_21_1, "icon_check_material", false)
	if_set_opacity(arg_21_1, "bg_item", 255)
	arg_21_1:getChildByName("txt_value"):setTextColor(tocolor("#FFFFFF"))
	
	local var_21_0 = arg_21_0:isMyBonus(arg_21_3.intimacy_bonus)
	
	if_set_visible(arg_21_1, "eff_bonus", var_21_0)
	
	if var_21_0 then
		if not UIAction:Find("eff_bonus_" .. arg_21_3.code) then
			UIAction:Add(LOOP(SEQ(LOG(FADE_OUT(500)), LOG(FADE_IN(500)))), arg_21_1:getChildByName("eff_bonus"), "eff_bonus_" .. arg_21_3.code)
		else
			UIAction:Remove("eff_bonus_" .. arg_21_3.code)
			UIAction:Add(LOOP(SEQ(LOG(FADE_OUT(500)), LOG(FADE_IN(500)))), arg_21_1:getChildByName("eff_bonus"), "eff_bonus_" .. arg_21_3.code)
		end
	end
	
	local var_21_1 = UIUtil:getRewardIcon(nil, arg_21_3.code, {
		tooltip_delay = 130,
		parent = arg_21_1:getChildByName("bg_item")
	})
	
	if arg_21_3.count > 0 then
		if_set(arg_21_1, "txt_value", arg_21_3.count)
		if_set_visible(arg_21_1, "txt_value", true)
		if_set_visible(arg_21_1, "t_none", false)
	else
		if_set_visible(arg_21_1, "txt_value", false)
		if_set_visible(arg_21_1, "t_none", true)
		var_21_1:setOpacity(76.5)
	end
end

function UnitIntimacy.getIntimacyBonus(arg_22_0, arg_22_1)
	local var_22_0 = arg_22_1
	
	if type(var_22_0) == "table" then
		var_22_0 = arg_22_1.id
	end
	
	local var_22_1, var_22_2, var_22_3, var_22_4 = DB("item_material_intimacy", var_22_0, {
		"id",
		"type",
		"target",
		"bonus"
	})
	
	if not var_22_1 then
		return 
	end
	
	return {
		id = var_22_1,
		type = var_22_2,
		target = var_22_3,
		bonus = var_22_4
	}
end

function UnitIntimacy.calcSelectedItemsEXP(arg_23_0)
	if not arg_23_0.vars.present or not arg_23_0.vars.present.select_items then
		return 0
	end
	
	local var_23_0 = 0
	
	for iter_23_0, iter_23_1 in pairs(arg_23_0.vars.present.select_items) do
		if iter_23_1.total_exp then
			var_23_0 = var_23_0 + iter_23_1.total_exp
		end
	end
	
	return var_23_0
end

function UnitIntimacy.initListView(arg_24_0)
	local var_24_0 = arg_24_0.vars.present.wnd:getChildByName("scrollview")
	
	arg_24_0.vars.present.itemView = ItemListView_v2:bindControl(var_24_0)
	
	local var_24_1 = load_control("wnd/sanctuary_alchemy_material_card.csb")
	
	if var_24_0.STRETCH_INFO then
		local var_24_2 = var_24_0:getContentSize()
		
		resetControlPosAndSize(var_24_1, var_24_2.width, var_24_0.STRETCH_INFO.width_prev)
	end
	
	local var_24_3 = {
		onUpdate = function(arg_25_0, arg_25_1, arg_25_2, arg_25_3)
			arg_24_0:updateListViewItem(arg_25_1, arg_25_2, arg_25_3)
			
			arg_25_1:getChildByName("btn_select").datasource = arg_25_3
		end
	}
	
	arg_24_0.vars.present.itemView:setRenderer(var_24_1, var_24_3)
	arg_24_0.vars.present.itemView:removeAllChildren()
	
	local var_24_4 = {}
	local var_24_5 = 1
	
	for iter_24_0, iter_24_1 in pairs(Account:getIntimacyItems()) do
		var_24_4[var_24_5] = iter_24_1
		
		if iter_24_1.intimacy_bonus then
			var_24_4[var_24_5].intimacy_bonus = arg_24_0:getIntimacyBonus(iter_24_1.intimacy_bonus)
		end
		
		var_24_5 = var_24_5 + 1
	end
	
	if table.count(var_24_4) > 0 then
		arg_24_0.vars.present.itemView:setDataSource(arg_24_0:_sort(var_24_4))
	else
		if_set_visible(arg_24_0.vars.present.itemView, nil, false)
		if_set_visible(arg_24_0.vars.present.wnd, "n_no_data", true)
	end
	
	arg_24_0.vars.present.itemView:jumpToTop()
end

function UnitIntimacy.updatePresentWnd(arg_26_0, arg_26_1)
	if not arg_26_1 then
		return 
	end
	
	if not arg_26_0.vars.present or not arg_26_0.vars.present.wnd then
		return 
	end
	
	local var_26_0 = arg_26_0.vars.present.wnd:getChildByName("n_intimacy")
	local var_26_1 = string.format("img/hero_love_icon_%d.png", arg_26_1.unit_intimacy_lv > 7 and 3 or arg_26_1.unit_intimacy_lv > 4 and 2 or 1)
	
	if_set_sprite(var_26_0, "icon", var_26_1)
	if_set(var_26_0, "t_lv", arg_26_1.unit_intimacy_lv)
	if_set(var_26_0, "txt_name", T("inttl_" .. arg_26_1.unit_intimacy_lv))
	
	local var_26_2 = arg_26_1.unit_intimacy_exp
	local var_26_3 = var_26_2 + arg_26_0:calcSelectedItemsEXP()
	local var_26_4 = 1
	
	for iter_26_0, iter_26_1 in pairs(arg_26_0.vars.present.intimacy_db or {}) do
		if var_26_3 < iter_26_1 then
			var_26_4 = iter_26_0
			
			break
		end
	end
	
	local var_26_5 = arg_26_0.vars.present.intimacy_db[#arg_26_0.vars.present.intimacy_db]
	
	if arg_26_0.vars.present.intimacy_db and var_26_5 <= var_26_3 then
		var_26_4 = 10
	end
	
	local var_26_6 = var_26_4 > arg_26_1.unit_intimacy_lv
	
	var_26_6 = var_26_6 and arg_26_0.vars.present.select_items and table.count(arg_26_0.vars.present.select_items or {}) > 0
	
	local var_26_7 = arg_26_0.vars.present.wnd:getChildByName("up_exp_gauge")
	local var_26_8 = arg_26_0.vars.present.wnd:getChildByName("exp_gauge")
	local var_26_9, var_26_10 = UNIT:getFavLevel(var_26_3)
	local var_26_11, var_26_12 = UNIT:getFavLevel(var_26_2)
	
	var_26_7:setPercent(var_26_11 < var_26_9 and 100 or var_26_10 * 100)
	var_26_8:setPercent(var_26_12 * 100)
	
	local var_26_13 = arg_26_0.vars.present.wnd:getChildByName("n_intimacy_up")
	local var_26_14 = arg_26_0.vars.present.wnd:getChildByName("icon_arrow")
	
	local function var_26_15()
		local var_27_0 = string.format("img/hero_love_icon_%d.png", var_26_4 > 7 and 3 or var_26_4 > 4 and 2 or 1)
		
		if_set_sprite(var_26_13, "icon", var_27_0)
		if_set(var_26_13, "t_lv", var_26_4)
		if_set(var_26_13, "txt_name", T("inttl_" .. var_26_4))
		if_set(arg_26_0.vars.present.wnd, "label_up", "+" .. var_26_4 - arg_26_1.unit_intimacy_lv)
	end
	
	if var_26_6 then
		arg_26_0.vars.present.wnd:getChildByName("upgrade"):setScale(0)
		UIAction:Add(SEQ(CALL(var_26_15), SHOW(true), SPAWN(LOG(SCALE(100, 0, 1)))), arg_26_0.vars.present.wnd:getChildByName("upgrade"), "block")
		
		if not UIAction:Find("intimacy_arrow") then
			UIAction:Add(LOOP(SEQ(SHOW(true), FADE_OUT(100), LOG(MOVE_TO(500, var_26_14:getPositionX(), var_26_14:getPositionY() + 5)), FADE_IN(100), LOG(MOVE_TO(500, var_26_14:getPositionX(), var_26_14:getPositionY() - 5)))), var_26_14, "intimacy_arrow")
		end
		
		if var_26_13:isVisible() then
			UIAction:Add(SEQ(LOG(FADE_OUT(50)), CALL(var_26_15), LOG(FADE_IN(150))), var_26_13, "block")
		else
			UIAction:Add(SEQ(CALL(var_26_15), SHOW(true), LOG(FADE_IN(100))), var_26_13, "block")
		end
	else
		if UIAction:Find("intimacy_arrow") then
			UIAction:Remove("intimacy_arrow")
		end
		
		if var_26_13:isVisible() then
			UIAction:Add(SEQ(LOG(FADE_OUT(100)), SHOW(false)), var_26_13, "block")
			UIAction:Add(SEQ(SHOW(true), FADE_OUT(100), SHOW(false), CALL(var_26_15)), var_26_14, "intimacy_arrow")
		else
			UIAction:Add(SPAWN(CALL(var_26_15), SHOW(false)), var_26_13, "block")
			UIAction:Add(SHOW(false), var_26_14, "intimacy_arrow")
		end
		
		UIAction:Add(SEQ(SPAWN(LOG(SCALE(100, arg_26_0.vars.present.wnd:getChildByName("upgrade"):getScale(), 0))), SHOW(false)), arg_26_0.vars.present.wnd:getChildByName("upgrade"), "block")
	end
	
	if arg_26_0.vars.present.select_items then
		if table.count(arg_26_0.vars.present.select_items) <= 0 then
			if_set_opacity(arg_26_0.vars.present.wnd, "btn_cancle", 76.5)
			if_set_opacity(arg_26_0.vars.present.wnd, "btn_ok", 76.5)
		else
			if_set_opacity(arg_26_0.vars.present.wnd, "btn_cancle", 255)
			if_set_opacity(arg_26_0.vars.present.wnd, "btn_ok", 255)
		end
	else
		if_set_opacity(arg_26_0.vars.present.wnd, "btn_cancle", 76.5)
		if_set_opacity(arg_26_0.vars.present.wnd, "btn_ok", 76.5)
	end
end

function UnitIntimacy.openPresent(arg_28_0, arg_28_1, arg_28_2)
	if not arg_28_1 then
		return 
	end
	
	arg_28_2 = arg_28_2 or {}
	
	BackButtonManager:push({
		check_id = "hero_detail_intimacy_present",
		back_func = function()
			UnitIntimacy:closePresent()
		end
	})
	
	arg_28_0.vars.present = {}
	arg_28_0.vars.present.wnd = load_dlg("hero_detail_intimacy_present", true, "wnd")
	arg_28_0.vars.present.intimacy_db = {}
	
	for iter_28_0 = 1, 99 do
		local var_28_0 = DBN("character_intimacy", iter_28_0, {
			"exp"
		})
		
		if not var_28_0 then
			break
		end
		
		arg_28_0.vars.present.intimacy_db[iter_28_0] = var_28_0
	end
	
	arg_28_0:initPresentWnd(arg_28_1, arg_28_2)
	SceneManager:getRunningNativeScene():addChild(arg_28_0.vars.present.wnd)
	arg_28_0.vars.present.wnd:bringToFront()
end

function UnitIntimacy.closePresent(arg_30_0)
	if not arg_30_0.vars.present or not arg_30_0.vars.present.wnd then
		return 
	end
	
	BackButtonManager:pop("hero_detail_intimacy_present")
	arg_30_0.vars.present.wnd:removeFromParent()
	
	arg_30_0.vars.present.select_items = nil
	arg_30_0.vars.present = nil
end

function UnitIntimacy._sort(arg_31_0, arg_31_1)
	local var_31_0 = arg_31_1 or {}
	
	table.sort(var_31_0, function(arg_32_0, arg_32_1)
		return arg_32_0.sort > arg_32_1.sort
	end)
	table.sort(var_31_0, function(arg_33_0, arg_33_1)
		return arg_33_0.grade > arg_33_1.grade
	end)
	table.sort(var_31_0, function(arg_34_0, arg_34_1)
		local var_34_0 = arg_31_0:isMyBonus(arg_34_0.intimacy_bonus)
		local var_34_1 = arg_31_0:isMyBonus(arg_34_1.intimacy_bonus)
		
		if var_34_0 and var_34_1 then
			local var_34_2 = arg_31_0:getIntimacyBonus(arg_34_0.intimacy_bonus)
			local var_34_3 = arg_31_0:getIntimacyBonus(arg_34_1.intimacy_bonus)
			
			return arg_34_0.xp * var_34_2.bonus > arg_34_1.xp * var_34_3.bonus
		end
		
		if var_34_0 then
			return true
		end
		
		if var_34_1 then
			return false
		end
		
		return arg_34_0.grade > arg_34_1.grade
	end)
	
	return var_31_0
end
