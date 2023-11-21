function GachaUnit.setPickupTag(arg_1_0, arg_1_1, arg_1_2)
	if not arg_1_1 or not get_cocos_refid(arg_1_1) then
		return 
	end
	
	local var_1_0, var_1_1, var_1_2, var_1_3, var_1_4, var_1_5, var_1_6 = DB("character", arg_1_2, {
		"face_id",
		"model_id",
		"name",
		"role",
		"grade",
		"moonlight",
		"ch_attribute"
	})
	
	if_set(arg_1_1, "name", T(var_1_2))
	if_set_sprite(arg_1_1, "role", "img/cm_icon_role_" .. var_1_3 .. ".png")
	
	if arg_1_1:getChildByName("star1") then
		for iter_1_0 = 1, 6 do
			if_set_visible(arg_1_1, "star" .. iter_1_0, iter_1_0 <= var_1_4)
		end
	end
	
	local var_1_7 = "img/cm_icon_pro"
	
	if var_1_5 then
		var_1_7 = var_1_7 .. "m"
	end
	
	if_set_sprite(arg_1_1, "color", var_1_7 .. var_1_6 .. ".png")
	arg_1_1:setVisible(true)
end

function GachaUnit.setPickupPortrait(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	if not arg_2_1 or not get_cocos_refid(arg_2_1) then
		return 
	end
	
	arg_2_1:removeAllChildren()
	
	if get_cocos_refid(arg_2_4) then
		UIAction:Add(SEQ(SPAWN(RLOG(SCALE(250, 1, 0), 300), RLOG(MOVE_BY(250, 600), 300), FADE_OUT(250)), REMOVE()), arg_2_4)
	end
	
	local var_2_0 = DB("character", arg_2_2, {
		"face_id"
	})
	local var_2_1 = UIUtil:getPortraitAni(var_2_0)
	
	if var_2_1 then
		arg_2_1:addChild(var_2_1)
		arg_2_1:setVisible(true)
		
		if arg_2_5 then
			arg_2_1:setOpacity(0)
			UIAction:Add(SEQ(SPAWN(LOG(SCALE(250, 0, 1), 300), LOG(SLIDE_IN(250, 1600, false), 300), FADE_IN(250))), arg_2_1)
		end
		
		UIUtil:setPortraitPositionByFaceBone(var_2_1)
		GachaIntroduceBG.Util:setPortraitInfoData(var_2_1, arg_2_1, arg_2_3)
	end
	
	return var_2_1
end

function GachaUnit.enterGachaPickup(arg_3_0, arg_3_1, arg_3_2)
	if arg_3_1 and string.starts(arg_3_1, "gacha_start") then
		arg_3_0:enterGachaStart()
		
		return 
	end
	
	if not PRODUCTION_MODE and arg_3_1 then
		local var_3_0 = T("gacha_" .. arg_3_1)
		
		if var_3_0 and string.starts(var_3_0, "@") then
			balloon_message_with_sound("TEXT DB NOT FOUND: " .. "gacha_" .. arg_3_1)
		end
	end
	
	local var_3_1 = arg_3_0.vars.gacha_mode or "gacha_rare"
	local var_3_2 = os.time()
	local var_3_3 = Account:getGachaShopInfo()
	
	if arg_3_1 then
		arg_3_0.vars.gacha_mode = "gacha_pickup:" .. arg_3_1
		
		arg_3_0:saveSceneState(arg_3_0.vars.gacha_mode)
	elseif var_3_3.pickup and arg_3_0.vars.pickup_list then
		local var_3_4
		
		for iter_3_0, iter_3_1 in pairs(arg_3_0.vars.pickup_list) do
			if iter_3_1.start_time and var_3_2 > iter_3_1.start_time and iter_3_1.end_time and var_3_2 < iter_3_1.end_time then
				arg_3_1 = iter_3_1.id
				
				if var_3_1 == "gacha_pickup:" .. arg_3_1 then
					var_3_4 = var_3_1
					
					break
				end
			end
		end
		
		if not var_3_4 then
			for iter_3_2, iter_3_3 in pairs(arg_3_0.vars.pickup_list) do
				if iter_3_3.start_time and var_3_2 > iter_3_3.start_time and iter_3_3.end_time and var_3_2 < iter_3_3.end_time then
					arg_3_1 = iter_3_3.id
					var_3_4 = "gacha_pickup:" .. arg_3_1
					
					break
				end
			end
		end
		
		if var_3_4 then
			arg_3_0.vars.gacha_mode = var_3_4
			
			arg_3_0:saveSceneState(arg_3_0.vars.gacha_mode)
		else
			arg_3_0:enterGachaRare()
			
			return 
		end
	end
	
	arg_3_0.vars.element_mode = nil
	arg_3_0.vars.gsp_id = nil
	arg_3_2 = arg_3_2 or var_3_3.pickup[arg_3_1]
	
	if not arg_3_2 then
		arg_3_0:enterGachaRare()
		
		return 
	end
	
	arg_3_0.vars.pickup_data = arg_3_2
	
	if arg_3_2.start_time and var_3_2 < arg_3_2.start_time or arg_3_2.end_time and var_3_2 > arg_3_2.end_time then
		balloon_message_with_sound("buy_gacha.invalid_time")
		arg_3_0:showRightMenu(false, true)
		arg_3_0:enterGachaRare()
		
		return 
	end
	
	local var_3_5 = arg_3_0.vars.ui_wnd:getChildByName("n_before")
	local var_3_6 = var_3_5:getChildByName("n_pickup_pos")
	
	var_3_6:removeAllChildren()
	var_3_5:getChildByName("n_pickup_pos2"):removeAllChildren()
	arg_3_0:prepareEnterGachaVisibleOff(var_3_5)
	arg_3_0:updateGachaTempInventoryCount()
	if_set_visible(var_3_5, "n_btn_summon_2", true)
	if_set_visible(var_3_5, "n_btn_rate", true)
	if_set_visible(var_3_5, "n_pickup", true)
	
	if get_cocos_refid(arg_3_0.vars.intro.m_biblika_node) then
		arg_3_0.vars.intro.m_biblika_node:setVisible(false)
	end
	
	if get_cocos_refid(arg_3_0.vars.intro.m_biblio_node) then
		arg_3_0.vars.intro.m_biblio_node:setVisible(false)
	end
	
	GachaIntroduceBG:setup("pickup", var_3_6, {
		nb = var_3_5,
		n_pickup_pos = var_3_6,
		pickup_id = arg_3_1,
		pickup_data = arg_3_2,
		gacha_shop_info = var_3_3
	})
	
	local var_3_7 = GachaIntroduceBG.PickUp:getPickupNode()
	local var_3_8 = arg_3_2.gacha_id
	local var_3_9
	local var_3_10 = arg_3_0:getEventToken(arg_3_1)
	local var_3_11 = var_3_5:getChildByName("n_btn_summon_2")
	
	if get_cocos_refid(var_3_11) and var_3_11:isVisible() then
		if_set_visible(var_3_11, "cm_free_tooltip", false)
		if_set_visible(var_3_11, "cm_free_tooltip2", false)
		
		if var_3_10 and Account:getCurrency(var_3_10.token) >= to_n(var_3_10.price) then
			var_3_9 = var_3_10
		else
			var_3_9 = var_3_3.gacha[var_3_8]
		end
		
		local var_3_12 = var_3_11:getChildByName("btn_summon_1")
		
		if_set_visible(var_3_12, "cm_icon_gacha", false)
		if_set(var_3_12, "txt_summon", T("ui_gacha_summon_1_btn"))
		if_set(var_3_12, "cost", var_3_9.price)
		if_set_sprite(var_3_12, "icon_res", "item/" .. DB("item_token", var_3_9.token, {
			"icon"
		}) .. ".png")
		
		if var_3_10 and Account:getCurrency(var_3_10.token) >= to_n(var_3_10.price) * 10 then
			var_3_9 = var_3_10
		else
			var_3_9 = var_3_3.gacha[var_3_8]
		end
		
		local var_3_13 = var_3_11:getChildByName("btn_summon_10")
		
		if_set(var_3_13, "txt_summon", T("ui_gacha_summon_10_btn"))
		if_set(var_3_13, "cost", var_3_9.price * 10)
		if_set_sprite(var_3_13, "icon_res", "item/" .. DB("item_token", var_3_9.token, {
			"icon"
		}) .. ".png")
	else
		local var_3_14 = var_3_5:getChildByName("btn_summon")
		
		if get_cocos_refid(var_3_14) then
			var_3_14:setVisible(true)
		end
		
		if_set_visible(var_3_14, "cm_free_tooltip", false)
		if_set_visible(var_3_14, "cm_icon_gacha", false)
		if_set(var_3_14, "txt_summon", T(var_3_9.name))
		if_set(var_3_14, "cost", var_3_9.price)
		if_set_sprite(var_3_14, "icon_res", "item/" .. DB("item_token", var_3_9.token, {
			"icon"
		}) .. ".png")
	end
	
	local var_3_15
	
	if arg_3_2.limit == "y" then
		var_3_15 = var_3_7:getChildByName("n_date_limited")
		
		if_set_visible(var_3_7, "n_date", false)
		if_set(var_3_15, "title", T("gacha_limit_period_tag"))
		if_set(var_3_15, "t_limited", T("gacha_limit_desc"))
	elseif arg_3_2.limit == "a" then
		var_3_15 = var_3_7:getChildByName("n_date_limited")
		
		if_set_visible(var_3_7, "n_date", false)
		if_set(var_3_15, "title", T("gacha_limit2_period_tag"))
		if_set(var_3_15, "t_limited", T("gacha_limit2_desc"))
	elseif arg_3_2.limit == "b" then
		var_3_15 = var_3_7:getChildByName("n_date_limited")
		
		if_set_visible(var_3_7, "n_date", false)
		if_set(var_3_15, "title", T("gacha_limit3_period_tag"))
		if_set(var_3_15, "t_limited", T("gacha_limit3_desc"))
	end
	
	if not var_3_15 then
		var_3_15 = var_3_7:getChildByName("n_date")
		
		if_set_visible(var_3_7, "n_date_limited", false)
	end
	
	if var_3_15 and arg_3_2.start_time and arg_3_2.end_time then
		var_3_15:setVisible(true)
		if_set(var_3_15, "disc", T("time_slash_period_y_m_d_time", timeToStringDef({
			preceding_with_zeros = true,
			start_time = arg_3_2.start_time,
			end_time = arg_3_2.end_time
		})))
		
		local var_3_16 = var_3_15:findChildByName("t_limited")
		local var_3_17 = var_3_15:findChildByName("title")
		
		if get_cocos_refid(var_3_16) and get_cocos_refid(var_3_17) and var_3_16:getStringNumLines() == 4 then
			var_3_17._origin_pos_y = var_3_17._origin_pos_y or var_3_17:getPositionY()
			
			var_3_17:setPositionY(var_3_17._origin_pos_y + 10)
		end
		
		if to_n(arg_3_2.end_time) - os.time() > (GAME_STATIC_VARIABLE.summon_expire_info_time or 172800) then
			if_set_color(var_3_15, "disc", tocolor("#c89b60"))
		else
			if_set_color(var_3_15, "disc", tocolor("#6bc11b"))
		end
	else
		var_3_15:setVisible(false)
	end
	
	arg_3_0:showRightMenu(false)
	arg_3_0:updateGachaCustomGroupPickupList(arg_3_2.pickup_gacha_list)
	arg_3_0:showRightMenu(false)
	Analytics:toggleTab("gacha_pickup")
end

function GachaUnit.updatePickupCharacterUI(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	arg_4_5 = arg_4_5 or {}
	
	if arg_4_4.left_character and not arg_4_5.ignore_left then
		arg_4_0:setPickupPortrait(arg_4_2:getChildByName("n_portrait_l"), arg_4_4.left_character, arg_4_4.left_data)
		arg_4_0:setPickupTag(arg_4_2:getChildByName("n_info_left"), arg_4_4.left_character)
	end
	
	if arg_4_4.right_character and not arg_4_5.ignore_right then
		arg_4_0:setPickupPortrait(arg_4_2:getChildByName("n_pos1"), arg_4_4.right_character, arg_4_4.right_data)
		arg_4_0:setPickupTag(arg_4_2:getChildByName("n_info_right"), arg_4_4.right_character)
	end
	
	if arg_4_4.pickup_gacha_list and #arg_4_4.pickup_gacha_list == 1 then
		local var_4_0 = arg_4_2:getChildByName("btn_info")
		
		var_4_0:setName("btn_info_single")
		
		local var_4_1 = arg_4_4.pickup_gacha_list[1]
		local var_4_2, var_4_3, var_4_4, var_4_5, var_4_6 = DB("character", var_4_1, {
			"name",
			"role",
			"grade",
			"moonlight",
			"ch_attribute"
		})
		
		WidgetUtils:setupPopup({
			control = var_4_0,
			creator = function()
				return UIUtil:getGachaCharacterPopup({
					skill_preview = true,
					code = var_4_1,
					grade = var_4_4
				})
			end
		})
	end
	
	if arg_4_4.ceiling_artifact then
		if_set_visible(arg_4_2, "n_arti_tooltip", true)
		
		local var_4_7 = arg_4_2:getChildByName("n_arti_tooltip")
		
		if_set_visible(var_4_7, "btn_arti_info", true)
		if_set_visible(var_4_7, "n_tooltip_info", false)
	else
		if_set_visible(arg_4_2, "n_arti_tooltip", false)
	end
	
	local var_4_8 = arg_4_1:getChildByName("n_pickup_ceiling_info")
	
	if var_4_8 then
		if arg_4_4.ceiling_character and arg_4_4.ceiling_count and to_n(arg_4_4.ceiling_count) > 0 then
			local var_4_9
			
			if arg_4_3.pickup_ceiling then
				var_4_9 = arg_4_3.pickup_ceiling[arg_4_4.gacha_id]
			end
			
			local var_4_10 = to_n(arg_4_4.ceiling_count)
			
			if var_4_9 then
				var_4_10 = var_4_10 - to_n(var_4_9.current)
			end
			
			if tolua:type(var_4_8:getChildByName("txt_count")) ~= "ccui.RichText" then
				upgradeLabelToRichLabel(var_4_8, "txt_count"):ignoreContentAdaptWithSize(true)
			end
			
			local var_4_11 = DB("character", arg_4_4.ceiling_character, {
				"name"
			})
			
			if var_4_10 == 0 then
				if_set(var_4_8, "txt_count", T("ui_gacha_pickup_ceiling_complete", {
					character_name = T(var_4_11)
				}))
				if_set_width_from(var_4_8, "tooltip_info", "txt_count", {
					add = 60,
					ratio = 1
				})
			else
				if_set(var_4_8, "txt_count", T("ui_gacha_pickup_ceiling_remain", {
					count = var_4_10,
					character_name = T(var_4_11)
				}))
				if_set_width_from(var_4_8, "tooltip_info", "txt_count", {
					add = 60,
					ratio = 1
				})
			end
			
			var_4_8:setVisible(true)
		else
			var_4_8:setVisible(false)
		end
	end
end

function GachaUnit.updatePickupInfoUIListview(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_1:getChildByName("n_pickup_pos"):getChildByName("n_pickup_infolist"):getChildByName("ListView_infolist")
	local var_6_1 = ItemListView_v2:bindControl(var_6_0)
	local var_6_2 = load_control("wnd/gacha_popup_infolist_item.csb")
	
	if var_6_0.STRETCH_INFO then
		local var_6_3 = var_6_0:getContentSize()
		
		resetControlPosAndSize(var_6_2, var_6_3.width, var_6_0.STRETCH_INFO.width_prev)
	end
	
	local var_6_4 = {
		onUpdate = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
			print("pg_id?", arg_7_3)
			
			if arg_7_3 then
				local var_7_0 = string.starts(arg_7_3, "c")
				local var_7_1 = var_7_0 and "n_info" or "n_info_arti"
				local var_7_2 = arg_7_1:getChildByName(var_7_1)
				
				if_set_visible(arg_7_1, "n_info", var_7_0)
				if_set_visible(arg_7_1, "n_info_arti", not var_7_0)
				
				local var_7_3 = var_7_2:getChildByName("btn_pickup_info")
				
				var_7_3:setName("btn_pickup_info" .. ":" .. arg_7_3)
				
				if var_7_0 then
					local var_7_4, var_7_5, var_7_6, var_7_7, var_7_8 = DB("character", arg_7_3, {
						"name",
						"role",
						"grade",
						"moonlight",
						"ch_attribute"
					})
					
					if var_7_2:getChildByName("star1") then
						for iter_7_0 = 1, 6 do
							if_set_visible(var_7_2, "star" .. iter_7_0, iter_7_0 <= var_7_6)
						end
					end
					
					if_set(var_7_2, "txt_name", T(var_7_4))
					
					local var_7_9 = var_7_2:getChildByName("n_element")
					
					var_7_9:setVisible(true)
					
					local var_7_10 = "img/cm_icon_pro"
					
					if var_7_7 then
						var_7_10 = var_7_10 .. "m"
					end
					
					if_set_sprite(var_7_9, "icon_element", var_7_10 .. var_7_8 .. ".png")
					
					local var_7_11 = var_7_2:getChildByName("n_icon")
					
					UIUtil:getRewardIcon("c", arg_7_3, {
						no_popup = true,
						name = false,
						role = true,
						scale = 1,
						no_grade = true,
						parent = var_7_11
					})
					WidgetUtils:setupPopup({
						control = var_7_3,
						creator = function()
							return UIUtil:getGachaCharacterPopup({
								skill_preview = true,
								code = arg_7_3,
								grade = var_7_6
							})
						end
					})
				else
					if_set_visible(var_7_2, "n_element", false)
					
					local var_7_12, var_7_13 = DB("equip_item", arg_7_3, {
						"name",
						"artifact_grade"
					})
					
					if_set(var_7_2, "txt_name", T(var_7_12))
					
					if var_7_2:getChildByName("star1") then
						for iter_7_1 = 1, 6 do
							if_set_visible(var_7_2, "star" .. iter_7_1, iter_7_1 <= var_7_13)
						end
					end
					
					local var_7_14 = var_7_2:getChildByName("n_icon_arti")
					
					UIUtil:getRewardIcon(nil, arg_7_3, {
						no_popup = true,
						name = false,
						role = true,
						scale = 1,
						no_grade = true,
						parent = var_7_14
					})
					
					local var_7_15 = EQUIP:createByInfo({
						code = arg_7_3
					})
					
					WidgetUtils:setupPopup({
						control = var_7_3,
						creator = function()
							return ItemTooltip:getItemTooltip({
								show_max_check_box = true,
								artifact_popup = true,
								code = arg_7_3,
								grade = var_7_13,
								equip = var_7_15,
								equip_stat = var_7_15.stats
							})
						end
					})
				end
			else
				if_set_visible(arg_7_1, "n_info", false)
				if_set_visible(arg_7_1, "n_info_arti", false)
			end
		end
	}
	
	var_6_1:setRenderer(var_6_2, var_6_4)
	var_6_1:removeAllChildren()
	var_6_1:setDataSource(arg_6_2)
end

function GachaUnit.updatePickupInfoUI(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	if arg_10_2:getChildByName("n_pickup_info") then
		local var_10_0 = arg_10_1:getChildByName("n_btn_pickup_info_pos")
		local var_10_1 = arg_10_2:getChildByName("n_btn_pickup_info")
		
		if_set_visible(arg_10_2, "n_btn_pickup_info", true)
		if_set_visible(arg_10_2, "n_pickup_infolist", false)
		
		local var_10_2 = arg_10_2:getChildByName("n_pickup_infolist")
		local var_10_3 = var_10_2:getChildByName("img_bg")
		local var_10_4 = var_10_3:getContentSize()
		local var_10_5 = var_10_2:getChildByName("txt_pickupinfo_title")
		local var_10_6 = var_10_2:getChildByName("bar1_l")
		local var_10_7 = var_10_2:getChildByName("bar1_r")
		local var_10_8 = 0
		
		for iter_10_0 = 1, 3 do
			local var_10_9 = arg_10_3[iter_10_0]
			
			if var_10_9 then
				var_10_8 = var_10_8 + 1
				
				local var_10_10 = string.starts(var_10_9, "c")
				local var_10_11 = var_10_10 and "n_info" or "n_info_arti"
				local var_10_12 = var_10_2:getChildByName(var_10_11 .. iter_10_0)
				
				if_set_visible(var_10_2, "n_info" .. iter_10_0, var_10_10)
				if_set_visible(var_10_2, "n_info_arti" .. iter_10_0, not var_10_10)
				
				local var_10_13 = var_10_12:getChildByName("btn_pickup_info" .. iter_10_0)
				
				var_10_13:setName("btn_pickup_info" .. iter_10_0 .. ":" .. var_10_9)
				
				if var_10_10 then
					local var_10_14, var_10_15, var_10_16, var_10_17, var_10_18 = DB("character", var_10_9, {
						"name",
						"role",
						"grade",
						"moonlight",
						"ch_attribute"
					})
					
					if var_10_12:getChildByName("star1") then
						for iter_10_1 = 1, 6 do
							if_set_visible(var_10_12, "star" .. iter_10_1, iter_10_1 <= var_10_16)
						end
					end
					
					if_set(var_10_12, "txt_name", T(var_10_14))
					
					local var_10_19 = var_10_12:getChildByName("n_element")
					
					var_10_19:setVisible(true)
					
					local var_10_20 = "img/cm_icon_pro"
					
					if var_10_17 then
						var_10_20 = var_10_20 .. "m"
					end
					
					if_set_sprite(var_10_19, "icon_element", var_10_20 .. var_10_18 .. ".png")
					
					local var_10_21 = var_10_12:getChildByName("n_icon")
					
					UIUtil:getRewardIcon("c", var_10_9, {
						no_popup = true,
						name = false,
						role = true,
						scale = 1,
						no_grade = true,
						parent = var_10_21
					})
					WidgetUtils:setupPopup({
						control = var_10_13,
						creator = function()
							return UIUtil:getGachaCharacterPopup({
								skill_preview = true,
								code = var_10_9,
								grade = var_10_16
							})
						end
					})
				else
					if_set_visible(var_10_12, "n_element", false)
					
					local var_10_22, var_10_23 = DB("equip_item", var_10_9, {
						"name",
						"artifact_grade"
					})
					
					if_set(var_10_12, "txt_name", T(var_10_22))
					
					if var_10_12:getChildByName("star1") then
						for iter_10_2 = 1, 6 do
							if_set_visible(var_10_12, "star" .. iter_10_2, iter_10_2 <= var_10_23)
						end
					end
					
					local var_10_24 = var_10_12:getChildByName("n_icon_arti")
					
					UIUtil:getRewardIcon(nil, var_10_9, {
						no_popup = true,
						name = false,
						role = true,
						scale = 1,
						no_grade = true,
						parent = var_10_24
					})
					
					local var_10_25 = EQUIP:createByInfo({
						code = var_10_9
					})
					
					WidgetUtils:setupPopup({
						control = var_10_13,
						creator = function()
							return ItemTooltip:getItemTooltip({
								show_max_check_box = true,
								artifact_popup = true,
								code = var_10_9,
								grade = var_10_23,
								equip = var_10_25,
								equip_stat = var_10_25.stats
							})
						end
					})
				end
			else
				if_set_visible(var_10_2, "n_info" .. iter_10_0, false)
				if_set_visible(var_10_2, "n_info_arti" .. iter_10_0, false)
			end
		end
		
		var_10_2:setPositionY(515 - (3 - var_10_8) * 100)
		var_10_3:setContentSize(var_10_4.width, var_10_4.height - (3 - var_10_8) * 100)
	else
		if_set_visible(arg_10_2, "n_btn_pickup_info", false)
		if_set_visible(arg_10_2, "n_pickup_infolist", false)
	end
end
