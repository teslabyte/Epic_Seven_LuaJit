UnitDetailProfile = {}
UnitDetailProfile.profile_list = {}
UnitDetailProfile.intimacy_list = {}

function HANDLER.unit_detail_profile_item(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_voice" then
		UnitDetailProfile:playVoice(arg_1_0)
	end
end

function MsgHandler.set_unit_face_value(arg_2_0)
	UnitDetailProfile:resUnitEmotion(arg_2_0)
end

function MsgHandler.add_unit_special_illust(arg_3_0)
	UnitDetailProfile:resSpecialIllust(arg_3_0)
end

function UnitDetailProfile.onCreate(arg_4_0, arg_4_1)
	arg_4_1 = arg_4_1 or {}
	
	if not get_cocos_refid(arg_4_1.detail_wnd) then
		return 
	end
	
	arg_4_0.vars = {}
	arg_4_0.vars.menu_wnd = arg_4_1.detail_wnd:getChildByName("n_menu_profile")
	
	arg_4_0:initUI()
end

function UnitDetailProfile.initUI(arg_5_0)
	if not arg_5_0.vars or not get_cocos_refid(arg_5_0.vars.menu_wnd) then
		return 
	end
	
	arg_5_0.vars.left = arg_5_0.vars.menu_wnd:getChildByName("left_profile")
	arg_5_0.vars.right = arg_5_0.vars.menu_wnd:getChildByName("right_profile")
	arg_5_0.vars.mode = {
		arg_5_0.profile_list,
		arg_5_0.intimacy_list
	}
	
	for iter_5_0, iter_5_1 in pairs(arg_5_0.vars.mode or {}) do
		if iter_5_1 and iter_5_1.onCreate and type(iter_5_1.onCreate) == "function" then
			iter_5_1:onCreate(arg_5_0.vars.menu_wnd)
		end
	end
	
	local var_5_0 = arg_5_0.vars.left:getChildByName("btn_intimacy")
	
	if get_cocos_refid(var_5_0) then
		var_5_0:addTouchEventListener(function(arg_6_0, arg_6_1)
			if not arg_5_0:isVisible() then
				return 
			end
			
			if arg_6_1 == 0 or arg_6_1 == 1 then
				UnitDetailProfile:openIntimacy()
			else
				UnitIntimacy:close()
			end
		end)
	end
end

function UnitDetailProfile.getMenu(arg_7_0)
	if not arg_7_0.vars then
		return nil
	end
	
	return arg_7_0.vars.menu_wnd
end

function UnitDetailProfile.isVisible(arg_8_0)
	if not arg_8_0.vars or not get_cocos_refid(arg_8_0.vars.menu_wnd) then
		return false
	end
	
	return arg_8_0.vars.menu_wnd:isVisible()
end

function UnitDetailProfile.setMode(arg_9_0, arg_9_1)
	if not arg_9_0:isVisible() then
		return 
	end
	
	if table.empty(arg_9_0.vars.mode) or not arg_9_0.vars.unit then
		return 
	end
	
	arg_9_1 = arg_9_1 or 1
	
	if arg_9_1 == 2 and not UnitInfosUtil:isDetailInfoUnit(arg_9_0.vars.unit) then
		balloon_message_with_sound("no_detail_info")
		
		return 
	end
	
	local var_9_0
	
	if arg_9_0.vars.cur_mode then
		local var_9_1 = arg_9_0.vars.mode[arg_9_0.vars.cur_mode]
		
		if var_9_1 and var_9_1.onLeave and type(var_9_1.onLeave) == "function" then
			var_9_1:onLeave()
		end
	end
	
	arg_9_0.vars.cur_mode = arg_9_1
	
	arg_9_0:updateModeTab(arg_9_1)
	
	local var_9_2 = arg_9_0.vars.mode[arg_9_0.vars.cur_mode]
	
	if var_9_2 and var_9_2.onEnter and type(var_9_2.onEnter) == "function" then
		var_9_2:onEnter(arg_9_0.vars.unit)
	end
end

function UnitDetailProfile.updateModeTab(arg_10_0, arg_10_1)
	if not arg_10_0:isVisible() then
		return 
	end
	
	arg_10_1 = arg_10_1 or 1
	
	local var_10_0 = arg_10_0.vars.menu_wnd:getChildByName("n_tab_box")
	
	if get_cocos_refid(var_10_0) then
		if get_cocos_refid(arg_10_0.vars.cur_mode_tab) then
			if_set_visible(arg_10_0.vars.cur_mode_tab, "tab_bg", false)
		end
		
		arg_10_0.vars.cur_mode_tab = var_10_0:getChildByName("n_tab_profile" .. arg_10_1)
		
		if_set_visible(arg_10_0.vars.cur_mode_tab, "tab_bg", true)
	end
end

function UnitDetailProfile.onEnter(arg_11_0)
	if not arg_11_0.vars or not get_cocos_refid(arg_11_0.vars.menu_wnd) then
		return 
	end
	
	if not get_cocos_refid(arg_11_0.vars.left) or not get_cocos_refid(arg_11_0.vars.right) then
		return 
	end
	
	arg_11_0:enterUI()
end

function UnitDetailProfile.onLeave(arg_12_0)
	if not arg_12_0.vars or not get_cocos_refid(arg_12_0.vars.menu_wnd) then
		return 
	end
	
	if not get_cocos_refid(arg_12_0.vars.left) or not get_cocos_refid(arg_12_0.vars.right) then
		return 
	end
	
	arg_12_0:leaveUI()
end

function UnitDetailProfile.resetUI(arg_13_0)
	if not arg_13_0.vars or not get_cocos_refid(arg_13_0.vars.menu_wnd) then
		return 
	end
	
	arg_13_0.vars.cur_mode = 1
	arg_13_0.vars.cur_mode_tab = nil
	
	local var_13_0 = arg_13_0.vars.menu_wnd:getChildByName("n_tab_box")
	
	if get_cocos_refid(var_13_0) then
		for iter_13_0 = 1, 2 do
			local var_13_1 = var_13_0:getChildByName("n_tab_profile" .. iter_13_0)
			
			if get_cocos_refid(var_13_1) then
				if_set_visible(var_13_1, "tab_bg", false)
			end
		end
	end
	
	arg_13_0.profile_list:onRelease()
	arg_13_0.intimacy_list:onRelease()
end

function UnitDetailProfile.enterUI(arg_14_0)
	if not arg_14_0.vars or not get_cocos_refid(arg_14_0.vars.menu_wnd) then
		return 
	end
	
	if not get_cocos_refid(arg_14_0.vars.left) or not get_cocos_refid(arg_14_0.vars.right) then
		return 
	end
	
	arg_14_0.vars.menu_wnd:setVisible(true)
	arg_14_0.vars.menu_wnd:setOpacity(0)
	UIAction:Add(FADE_IN(400), arg_14_0.vars.menu_wnd, "block")
	
	local var_14_0 = arg_14_0.vars.left
	
	var_14_0:getChildByName("n_box"):setOpacity(0)
	UIAction:Add(SEQ(SLIDE_IN(200, 600)), var_14_0:getChildByName("name"), "block")
	UIAction:Add(SEQ(DELAY(80), SLIDE_IN(200, 600)), var_14_0:getChildByName("n_box"), "block")
	
	local var_14_1 = arg_14_0.vars.right
	
	if_set_visible(var_14_1, "n_btn_sub", true)
	if_set_opacity(var_14_1, "n_btn_sub", 255)
	if_set_visible(var_14_1, "n_closet", false)
	UIAction:Add(SEQ(SLIDE_IN(200, -100)), arg_14_0.vars.right, "block")
	
	local var_14_2 = UnitDetail:getHeroBelt()
	
	if var_14_2 then
		var_14_2:setTouchEnabled(false)
		var_14_2:setScrollEnabled(false)
	end
end

function UnitDetailProfile.leaveUI(arg_15_0)
	if not arg_15_0.vars or not get_cocos_refid(arg_15_0.vars.menu_wnd) then
		return 
	end
	
	if not get_cocos_refid(arg_15_0.vars.left) or not get_cocos_refid(arg_15_0.vars.right) then
		return 
	end
	
	UIAction:Add(SEQ(DELAY(400), SHOW(false)), arg_15_0.vars.menu_wnd, "block")
	
	local var_15_0 = arg_15_0.vars.left
	
	UIAction:Add(SEQ(SLIDE_OUT(200, -600)), var_15_0:getChildByName("name"), "block")
	UIAction:Add(SEQ(DELAY(80), SLIDE_OUT(200, -600)), var_15_0:getChildByName("n_box"), "block")
	UIAction:Add(SEQ(SLIDE_OUT(200, 100)), arg_15_0.vars.right, "block")
	
	local var_15_1 = UnitDetail:getHeroBelt()
	
	if var_15_1 then
		var_15_1:setTouchEnabled(true)
		var_15_1:setScrollEnabled(true)
	end
end

function UnitDetailProfile.updateUnitInfo(arg_16_0, arg_16_1, arg_16_2)
	if not arg_16_0.vars or not get_cocos_refid(arg_16_0.vars.menu_wnd) then
		return 
	end
	
	arg_16_1 = arg_16_1 or arg_16_0.vars.unit
	
	local var_16_0 = UnitDetail:getHeroBelt()
	
	if var_16_0 then
		var_16_0:scrollToUnit(arg_16_1)
	end
	
	arg_16_0.vars.unit = arg_16_1
	
	arg_16_0:resetUI()
	
	local var_16_1 = arg_16_1.inst.code
	
	if arg_16_1:isMoonlightDestinyUnit() then
		var_16_1 = MoonlightDestiny:getRelationCharacterCode(var_16_1)
	end
	
	local var_16_2 = UnitInfosUtil:getCharacterVoiceName(var_16_1)
	
	if_set(arg_16_0.vars.menu_wnd, "txt_cv", var_16_2)
	
	local var_16_3 = arg_16_0.vars.menu_wnd:getChildByName("txt_name")
	
	var_16_3:setString(T(arg_16_1.db.name))
	UIUserData:proc(var_16_3)
	if_call(arg_16_0.vars.menu_wnd, "star1", "setPositionX", 10 + var_16_3:getContentSize().width * var_16_3:getScaleX() + var_16_3:getPositionX())
	UIUtil:setUnitAllInfo(arg_16_0.vars.menu_wnd, arg_16_1)
	
	if arg_16_0.vars.unit:isGrowthBoostRegistered() then
		local var_16_4 = arg_16_0.vars.unit:clone()
		
		GrowthBoost:apply(var_16_4)
		
		var_16_4.inst.locked = arg_16_0.vars.unit:isLocked()
		
		UIUtil:setUnitAllInfo(arg_16_0.vars.menu_wnd, var_16_4)
	end
	
	arg_16_0:updateButtons(arg_16_1)
	arg_16_0:setSkinList(arg_16_1)
	
	if not UnitInfosUtil:isDetailInfoUnit(arg_16_1) then
		arg_16_0.vars.cur_mode = 1
	end
	
	arg_16_0:setMode(arg_16_0.vars.cur_mode or 1)
end

function UnitDetailProfile.updateButtons(arg_17_0, arg_17_1)
	if not arg_17_0:isVisible() then
		return 
	end
	
	arg_17_1 = arg_17_1 or arg_17_0.vars.unit
	
	if not arg_17_1 then
		return 
	end
	
	arg_17_0:updateModeTabButton(arg_17_1)
	arg_17_0:updateIntimacyButtons(arg_17_1)
	arg_17_0:updateSpecialRecordButton(arg_17_1)
	arg_17_0:updateSkinButton(arg_17_1)
end

function UnitDetailProfile.updateModeTabButton(arg_18_0, arg_18_1)
	if not arg_18_0:isVisible() or not get_cocos_refid(arg_18_0.vars.left) then
		return 
	end
	
	arg_18_1 = arg_18_1 or arg_18_0.vars.unit
	
	if not arg_18_1 then
		return 
	end
	
	if_set_opacity(arg_18_0.vars.left, "n_tab_profile2", UnitInfosUtil:isDetailInfoUnit(arg_18_1) and 255 or 76.5)
end

function UnitDetailProfile.updateIntimacyButtons(arg_19_0, arg_19_1)
	if not arg_19_0:isVisible() or not get_cocos_refid(arg_19_0.vars.left) then
		return 
	end
	
	arg_19_1 = arg_19_1 or arg_19_0.vars.unit
	
	if not arg_19_1 then
		return 
	end
	
	local var_19_0 = arg_19_1:getFavLevel() >= 10
	
	if_set_opacity(arg_19_0.vars.left, "btn_present", 255)
	
	local var_19_1 = UnitInfosUtil:isDetailInfoUnit(arg_19_1)
	
	if not var_19_1 or arg_19_1:isMoonlightDestinyUnit() or BackPlayManager:isInBackPlayTeam(arg_19_1:getUID()) then
		if_set_opacity(arg_19_0.vars.left, "btn_present", 76.5)
	end
	
	if_set_visible(arg_19_0.vars.left, "btn_present", not var_19_0)
	if_set_visible(arg_19_0.vars.left, "btn_intimacy", var_19_1 and arg_19_1:getBaseGrade() > 3)
	if_set_opacity(arg_19_0.vars.left, "btn_intimacy", var_19_1 and arg_19_1:getBaseGrade() > 3 and 255 or 76.5)
	if_set_visible(arg_19_0.vars.left, "n_intimacy_complet", var_19_0)
end

function UnitDetailProfile.updateSpecialRecordButton(arg_20_0, arg_20_1)
	if not arg_20_0.vars or not get_cocos_refid(arg_20_0.vars.menu_wnd) or not get_cocos_refid(arg_20_0.vars.left) then
		return 
	end
	
	arg_20_1 = arg_20_1 or arg_20_0.vars.unit
	
	if not arg_20_1 then
		return 
	end
	
	if_set_visible(arg_20_0.vars.left, "btn_special_record", false)
	if_set_visible(arg_20_0.vars.left, "icon_locked_special_record", false)
	
	local var_20_0, var_20_1, var_20_2 = DB("character_profile", arg_20_1.db.code, {
		"awake_illust",
		"awake_story",
		"awake_reward"
	})
	
	if var_20_0 and var_20_1 and var_20_2 then
		local var_20_3 = DB("character_profile_unlock", "awake_reward", {
			"level"
		}) or 5
		local var_20_4, var_20_5 = arg_20_1:getDevoteGrade()
		local var_20_6 = var_20_3 <= var_20_5
		local var_20_7 = arg_20_0.vars.left:getChildByName("btn_special_record")
		
		if get_cocos_refid(var_20_7) then
			var_20_7:setVisible(true)
			var_20_7:setOpacity(var_20_6 and 255 or 127.5)
			
			var_20_7.story_id = var_20_1
			var_20_7.illust_id = var_20_2
		end
		
		if_set_visible(arg_20_0.vars.left, "icon_locked_special_record", not var_20_6)
	end
end

function UnitDetailProfile.startSpecialRecord(arg_21_0, arg_21_1, arg_21_2)
	do return  end
	
	if not arg_21_0:isVisible() or not arg_21_0.vars.unit then
		return 
	end
	
	if not arg_21_1 and not arg_21_2 then
		return 
	end
	
	if Account:getItemCount(arg_21_2) > 0 then
		arg_21_0.vars.story_id = nil
		
		start_new_story(nil, arg_21_1, {
			force = true
		})
		
		return 
	end
	
	arg_21_0.vars.story_id = arg_21_1
	
	query("add_unit_special_illust", {
		code = arg_21_2,
		unit_id = arg_21_0.vars.unit:getUID()
	})
end

function UnitDetailProfile.resSpecialIllust(arg_22_0, arg_22_1)
	if not arg_22_1 or arg_22_1.res ~= "ok" then
		return 
	end
	
	if not arg_22_0:isVisible() or not arg_22_0.vars.story_id then
		return 
	end
	
	Account:addReward(arg_22_1.result)
	
	if arg_22_1.result and arg_22_1.result.new_items and arg_22_1.result.new_items[1] then
		local var_22_0 = arg_22_1.result.new_items[1].code
		
		arg_22_0:startSpecialRecord(arg_22_0.vars.story_id, var_22_0)
	end
end

function UnitDetailProfile.updateSkinButton(arg_23_0, arg_23_1)
	if not arg_23_0.vars or not get_cocos_refid(arg_23_0.vars.menu_wnd) or not get_cocos_refid(arg_23_0.vars.right) then
		return 
	end
	
	arg_23_1 = arg_23_1 or arg_23_0.vars.unit
	
	if not arg_23_1 then
		return 
	end
	
	local var_23_0 = arg_23_0.vars.right:getChildByName("btn_skin")
	
	if get_cocos_refid(var_23_0) then
		if_set_opacity(var_23_0, nil, UIUtil:isExistSkin(arg_23_1.inst.code) and 255 or 127.5)
		if_set_visible(var_23_0, "alert_skin", UnitSkin:CheckNotification(arg_23_1))
	end
end

function UnitDetailProfile.toggleSkinMode(arg_24_0)
	if not arg_24_0.vars or not get_cocos_refid(arg_24_0.vars.menu_wnd) or not arg_24_0.vars.menu_wnd:isVisible() or not get_cocos_refid(arg_24_0.vars.right) then
		return 
	end
	
	if not arg_24_0.vars.unit then
		return 
	end
	
	local var_24_0 = arg_24_0.vars.right:getChildByName("n_btn_sub")
	local var_24_1 = arg_24_0.vars.right:getChildByName("n_closet")
	
	if get_cocos_refid(var_24_0) and get_cocos_refid(var_24_1) then
		local var_24_2 = var_24_0:isVisible()
		local var_24_3
		
		if var_24_2 then
			arg_24_0:setSkinList(arg_24_0.vars.unit)
			UIAction:Add(SEQ(FADE_OUT(100), CALL(function()
				var_24_0:setVisible(not var_24_2)
			end)), var_24_0, "block")
			UIAction:Add(SLIDE_IN(200, -100), var_24_1, "block")
		else
			UIAction:Add(SEQ(FADE_IN(100), CALL(function()
				var_24_0:setVisible(not var_24_2)
			end)), var_24_0, "block")
			UIAction:Add(SLIDE_OUT(200, 100), var_24_1, "block")
			
			arg_24_0.vars.selected_skin_code = nil
		end
		
		local var_24_4 = var_24_2 and "DetailProfileSkin" or "DetailProfile"
		
		if UnitMain:isPortraitUseMode(var_24_4) then
			UnitMain:movePortrait(var_24_4)
			UnitMain:changePortrait(arg_24_0.vars.unit, nil, nil, var_24_2)
		end
	end
end

function UnitDetailProfile.setSkinList(arg_27_0, arg_27_1)
	if not arg_27_0.vars or not get_cocos_refid(arg_27_0.vars.menu_wnd) or not get_cocos_refid(arg_27_0.vars.right) then
		return 
	end
	
	arg_27_1 = arg_27_1 or arg_27_0.vars.unit
	
	if not arg_27_1 then
		return 
	end
	
	if not UIUtil:isExistSkin(arg_27_1.inst.code) then
		return 
	end
	
	local var_27_0 = arg_27_0.vars.right:getChildByName("n_closet")
	local var_27_1
	
	if get_cocos_refid(var_27_0) then
		var_27_1 = var_27_0:getChildByName("n_skin_list")
		
		if get_cocos_refid(var_27_1) then
			for iter_27_0 = 1, 3 do
				if_set_visible(var_27_1, "n_skin_" .. iter_27_0, false)
			end
			
			local var_27_2 = UIUtil:getSkinList(arg_27_1.inst.code)
			
			for iter_27_1, iter_27_2 in pairs(var_27_2) do
				local var_27_3 = var_27_1:getChildByName("n_skin_" .. iter_27_1)
				
				if get_cocos_refid(var_27_3) then
					var_27_3:setVisible(true)
					
					local var_27_4 = arg_27_1.db.face_id == iter_27_2.code
					
					if_set_visible(var_27_3, "icon_check", var_27_4)
					
					if var_27_4 then
						arg_27_0.vars.selected_skin_code = iter_27_2.code
						
						arg_27_0:setSkinInfo(iter_27_2)
						arg_27_0:updateClosetButtons(iter_27_2, arg_27_1)
					end
					
					if_set_visible(var_27_3, "alert_skin_n", UnitSkin:CheckNotificationByMaterialID(iter_27_2.material))
					
					local var_27_5 = var_27_3:getChildByName("btn_sel_skin")
					
					if get_cocos_refid(var_27_5) then
						var_27_5.skin_info = iter_27_2
					end
					
					local var_27_6 = DB("item_material", iter_27_2.material, "grade") or 1
					local var_27_7 = UIUtil:getSkinGradeBorder(var_27_6)
					local var_27_8 = UIUtil:getSkinGradeBG(var_27_6)
					local var_27_9 = DB("character", iter_27_2.code, "face_id")
					
					replaceSprite(var_27_3, "face", "face/" .. var_27_9 .. "_s.png")
					replaceSprite(var_27_3, "frame", "item/border/" .. var_27_7 .. ".png")
					replaceSprite(var_27_3, "frame_bg", "img/" .. var_27_8 .. ".png")
					
					if iter_27_2.material then
						if_set_opacity(var_27_3, nil, Account:getItemCount(iter_27_2.material) > 0 and 255 or 76.5)
					end
				end
			end
		end
	end
end

function UnitDetailProfile.setSkinInfo(arg_28_0, arg_28_1)
	if not arg_28_0.vars or not get_cocos_refid(arg_28_0.vars.menu_wnd) or not get_cocos_refid(arg_28_0.vars.right) then
		return 
	end
	
	if not arg_28_1 then
		return 
	end
	
	local var_28_0 = arg_28_0.vars.right:getChildByName("n_closet")
	
	if get_cocos_refid(var_28_0) then
		local var_28_1, var_28_2, var_28_3, var_28_4 = DB("item_material", arg_28_1.material, {
			"id",
			"name",
			"grade",
			"desc_category"
		})
		
		if var_28_1 then
			if_set(var_28_0, "t_skin_grade", T(var_28_4))
			if_set(var_28_0, "t_skin_name", T(var_28_2))
		else
			if_set(var_28_0, "t_skin_grade", T("item_category_skin_normal"))
			if_set(var_28_0, "t_skin_name", T("item_skin_normal_name"))
		end
		
		if_set_color(var_28_0, "t_skin_grade", UIUtil:getGradeColor(nil, var_28_3 or 1))
		
		local var_28_5 = var_28_3 == 5
		
		if_set_visible(var_28_0, "icon_menu_mic", var_28_5)
		
		local var_28_6 = 0
		local var_28_7
		local var_28_8 = var_28_0:getChildByName("t_skin_grade")
		
		if get_cocos_refid(var_28_8) then
			var_28_6 = var_28_8:getContentSize().width - 100
		end
		
		local var_28_9 = var_28_0:getChildByName("icon_menu_mic")
		
		if get_cocos_refid(var_28_9) then
			if not arg_28_0.origin_mic_pos_x then
				arg_28_0.origin_mic_pos_x = var_28_9:getPositionX()
			end
			
			if_set_position_x(var_28_0, "icon_menu_mic", arg_28_0.origin_mic_pos_x + var_28_6)
		end
	end
end

function UnitDetailProfile.updateClosetButtons(arg_29_0, arg_29_1, arg_29_2)
	if not arg_29_0.vars or not get_cocos_refid(arg_29_0.vars.menu_wnd) or not get_cocos_refid(arg_29_0.vars.right) then
		return 
	end
	
	if not arg_29_1 then
		return 
	end
	
	arg_29_2 = arg_29_2 or arg_29_0.vars.unit
	
	if not arg_29_2 then
		return 
	end
	
	local var_29_0 = DBT("character", arg_29_1.code, {
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
	
	if not var_29_0 then
		return 
	end
	
	local var_29_1 = arg_29_0.vars.right:getChildByName("n_closet")
	
	if get_cocos_refid(var_29_1) then
		if_set_visible(var_29_1, "n_current", false)
		if_set_visible(var_29_1, "btn_buy", false)
		if_set_visible(var_29_1, "btn_wearing", false)
		
		if arg_29_2.db.face_id == arg_29_1.code then
			if_set_visible(var_29_1, "n_current", true)
			
			return 
		end
		
		if Account:getItemCount(arg_29_1.material) > 0 or arg_29_0.vars.selected == var_29_0.skin_group or var_29_0.skin_check == nil then
			if_set_visible(var_29_1, "btn_wearing", true)
			
			return 
		end
		
		if_set_visible(var_29_1, "btn_buy", true)
		if_set_opacity(var_29_1, "btn_buy", arg_29_0:canPurchasable(arg_29_2) and 255 or 76.5)
	end
end

function UnitDetailProfile.selectSkin(arg_30_0, arg_30_1)
	if not arg_30_0.vars or not arg_30_0.vars.unit or not get_cocos_refid(arg_30_1) then
		return 
	end
	
	if table.empty(arg_30_1.skin_info) then
		return 
	end
	
	local var_30_0 = arg_30_1.skin_info
	
	if arg_30_0.vars.selected_skin_code and var_30_0.code and arg_30_0.vars.selected_skin_code == var_30_0.code then
		return 
	end
	
	arg_30_0.vars.selected_skin_code = var_30_0.code
	
	arg_30_0:setSkinInfo(var_30_0)
	arg_30_0:updateClosetButtons(var_30_0)
	
	local var_30_1 = arg_30_0.vars.unit:clone()
	
	var_30_1.db.face_id = var_30_0.code
	
	local var_30_2 = UnitMain:changePortrait(var_30_1, nil, nil, true)
	
	UnitMain:setPortraitEmotion(arg_30_0.vars.unit, var_30_2, "normal")
	arg_30_0:updateSkinButton(arg_30_0.vars.unit)
	
	if var_30_0.material then
		local var_30_3 = false
		local var_30_4 = Account:getItemCount(var_30_0.material) ~= 0
		local var_30_5 = SAVE:get("skin:" .. var_30_0.material)
		
		if var_30_4 and not var_30_5 then
			SAVE:set("skin:" .. var_30_0.material, true)
			
			var_30_3 = true
		end
		
		if var_30_3 then
			SAVE:save()
		end
		
		if_set_visible(arg_30_1:getParent(), "alert_skin_n", UnitSkin:CheckNotificationByMaterialID(var_30_0.material))
	end
end

function UnitDetailProfile.wearSkin(arg_31_0)
	if not arg_31_0:isVisible() then
		return 
	end
	
	if not arg_31_0.vars.unit or not arg_31_0.vars.selected_skin_code then
		return 
	end
	
	query("change_skin", {
		unit_uid = arg_31_0.vars.unit.inst.uid,
		skin_code = arg_31_0.vars.selected_skin_code
	})
end

function UnitDetailProfile.buySkin(arg_32_0)
	if not arg_32_0:isVisible() or not arg_32_0.vars.unit then
		return 
	end
	
	local var_32_0, var_32_1 = arg_32_0:canPurchasable(arg_32_0.vars.unit)
	
	if not var_32_0 then
		balloon_message_with_sound("err_skin_popup_cannot_purchase")
		
		return 
	end
	
	if var_32_0 == "shop" and var_32_1 then
		Shop:open("normal", "skin", {
			tab_opts = {
				default_skin_material_id = var_32_1
			}
		})
	elseif var_32_0 == "seasonpass" then
		local var_32_2 = SeasonPass:getOpenSeasonID() or SeasonPass:getRewardableSeasonID()
		
		if var_32_2 then
			SeasonPassBase:open(var_32_2, function()
				TopBarNew:updateSeasonPass()
			end)
		end
	end
end

function UnitDetailProfile.canPurchasable(arg_34_0, arg_34_1)
	if not arg_34_0.vars or not arg_34_0.vars.selected_skin_code then
		return false
	end
	
	arg_34_1 = arg_34_1 or arg_34_0.vars.unit
	
	if not arg_34_1 then
		return false
	end
	
	local var_34_0 = UIUtil:getSkinList(arg_34_1.inst.code)
	
	if table.empty(var_34_0) then
		return false
	end
	
	local var_34_1 = table.find(var_34_0, function(arg_35_0, arg_35_1)
		return arg_34_0.vars.selected_skin_code == arg_35_1.code
	end)
	
	if not var_34_1 then
		return false
	end
	
	local var_34_2 = var_34_0[var_34_1]
	
	if var_34_2.material and AccountData.skinshop_itemlist then
		for iter_34_0, iter_34_1 in pairs(AccountData.skinshop_itemlist or {}) do
			if iter_34_1 == var_34_2.material then
				return "shop", var_34_2.material
			end
		end
	end
	
	local var_34_3 = SeasonPass:getOpenSeasonID() or SeasonPass:getRewardableSeasonID()
	
	if var_34_3 then
		local var_34_4 = SeasonPass:getSchedule(var_34_3)
		
		if var_34_4 and var_34_4.main_db and var_34_4.main_db.skin_id == arg_34_0.vars.selected_skin_code then
			return "seasonpass"
		end
	end
	
	return nil
end

function UnitDetailProfile.playVoice(arg_36_0, arg_36_1)
	if not get_cocos_refid(arg_36_1) or table.empty(arg_36_1.data) then
		return 
	end
	
	if get_cocos_refid(arg_36_0.vars._played_se) then
		arg_36_0.vars._played_se:stop()
	end
	
	if not arg_36_1.data.is_unlock then
		balloon_message_with_sound("need_more_fav_point")
		
		return 
	end
	
	arg_36_0.vars._played_se = SoundEngine:playVoice("event:/" .. arg_36_1.data.sound_id)
end

function UnitDetailProfile.resUnitEmotion(arg_37_0, arg_37_1)
	if not arg_37_0:isVisible() then
		return 
	end
	
	if not arg_37_0.vars or not arg_37_0.vars.unit then
		return 
	end
	
	if not arg_37_1 or not arg_37_1.unit_opt then
		return 
	end
	
	arg_37_0.vars.unit:updateUnitOptionValue(arg_37_1.unit_opt)
end

function UnitDetailProfile.openIntimacy(arg_38_0)
	if not arg_38_0:isVisible() then
		return 
	end
	
	if not arg_38_0.vars.unit then
		return 
	end
	
	local var_38_0 = arg_38_0.vars.unit
	
	if not UnitInfosUtil:isDetailInfoUnit(var_38_0) then
		balloon_message_with_sound("no_detail_info")
		
		return 
	end
	
	UnitIntimacy:open(var_38_0)
end

function UnitDetailProfile.openPresent(arg_39_0)
	if not arg_39_0:isVisible() then
		return 
	end
	
	if not arg_39_0.vars.unit then
		return 
	end
	
	local var_39_0 = arg_39_0.vars.unit
	
	if not UnitInfosUtil:isDetailInfoUnit(var_39_0) then
		balloon_message_with_sound("no_detail_info")
		
		return 
	end
	
	if BackPlayManager:isInBackPlayTeam(var_39_0:getUID()) then
		balloon_message_with_sound("msg_bgbattle_cant_levelup")
		
		return 
	end
	
	local var_39_1 = UnitIntimacy:getIntimacyData(var_39_0)
	
	if not var_39_1 then
		balloon_message_with_sound("no_detail_info")
		
		return 
	end
	
	if var_39_1.is_max_intimacy_lv then
		return 
	end
	
	if var_39_1.unit and var_39_1.unit:isMoonlightDestinyUnit() then
		balloon_message_with_sound("character_mc_cannot_gift")
		
		return 
	end
	
	UnitIntimacy:openPresent(var_39_1)
end

function UnitDetailProfile.profile_list.onCreate(arg_40_0, arg_40_1)
	if not get_cocos_refid(arg_40_1) then
		return 
	end
	
	copy_functions(ScrollView, arg_40_0)
	
	arg_40_0.vars = {}
	arg_40_0.vars.profile_unlock_infos = {}
	
	for iter_40_0 = 1, 9999 do
		local var_40_0, var_40_1, var_40_2 = DBN("character_profile_unlock", iter_40_0, {
			"id",
			"type",
			"level"
		})
		
		if not var_40_0 then
			break
		end
		
		arg_40_0.vars.profile_unlock_infos[var_40_0] = {
			type = var_40_1,
			level = var_40_2
		}
	end
	
	arg_40_0.vars.listview = arg_40_1:getChildByName("ListView_profile1")
	
	arg_40_0.vars.listview:removeAllChildren()
	arg_40_0:initScrollView(arg_40_0.vars.listview, 613, 100)
end

function UnitDetailProfile.profile_list.onRelease(arg_41_0)
	if not arg_41_0.vars or not get_cocos_refid(arg_41_0.vars.listview) then
		return 
	end
	
	arg_41_0:clearScrollViewItems()
	arg_41_0:onLeave()
end

function UnitDetailProfile.profile_list.onEnter(arg_42_0, arg_42_1)
	if not arg_42_0.vars or not get_cocos_refid(arg_42_0.vars.listview) then
		return 
	end
	
	arg_42_1 = arg_42_1 or arg_42_0.vars.unit
	
	if not arg_42_1 then
		return 
	end
	
	arg_42_0.vars.unit = arg_42_1
	
	local var_42_0 = arg_42_0:getUnitProcessProfileData(arg_42_1)
	
	arg_42_0.vars.listview:setVisible(true)
	arg_42_0:createScrollViewItems(var_42_0)
	arg_42_0.vars.listview:forceDoLayout()
end

function UnitDetailProfile.profile_list.onLeave(arg_43_0)
	if not arg_43_0.vars or not get_cocos_refid(arg_43_0.vars.listview) then
		return 
	end
	
	arg_43_0.vars.listview:setVisible(false)
end

function UnitDetailProfile.profile_list.getUnitProcessProfileData(arg_44_0, arg_44_1)
	if not arg_44_0.vars or table.empty(arg_44_0.vars.profile_unlock_infos) then
		return nil
	end
	
	arg_44_1 = arg_44_1 or arg_44_0.vars.unit
	
	if not arg_44_1 then
		return nil
	end
	
	local var_44_0 = UnitInfosUtil:getCharacterProfileData(arg_44_1)
	
	if table.empty(var_44_0) then
		return nil
	end
	
	local function var_44_1(arg_45_0, arg_45_1)
		if not arg_45_0 or not arg_45_1 then
			return false
		end
		
		local var_45_0 = arg_44_0.vars.profile_unlock_infos[arg_45_1]
		
		if table.empty(var_45_0) then
			return true
		end
		
		if var_45_0.type then
			if var_45_0.type == "intimacy" then
				local var_45_1 = arg_45_0:getFavLevel()
				
				if var_45_1 and var_45_1 >= var_45_0.level then
					return true
				end
			elseif var_45_0.type == "devotion" then
				local var_45_2, var_45_3 = arg_45_0:getDevoteGrade()
				
				if var_45_3 and var_45_3 >= var_45_0.level then
					return true
				end
			end
		end
		
		return false
	end
	
	local var_44_2 = {}
	
	for iter_44_0, iter_44_1 in pairs(var_44_0) do
		local var_44_3 = {}
		
		if iter_44_0 and string.match(iter_44_0, "secret%d") then
			if not table.empty(iter_44_1.voice) then
				var_44_3.voice = {
					is_unlock = var_44_1(arg_44_1, iter_44_1.voice.type),
					type = iter_44_1.voice.type,
					sound_id = iter_44_1.voice.value
				}
			end
			
			var_44_3.value = iter_44_1.value
		else
			var_44_3.value = iter_44_1
		end
		
		var_44_3.is_unlock = var_44_1(arg_44_1, iter_44_0)
		var_44_3.type = iter_44_0
		
		table.insert(var_44_2, var_44_3)
	end
	
	local var_44_4 = {
		profile3 = 5,
		profile1 = 3,
		secret3 = 10,
		dic_category = 2,
		profile4 = 6,
		intro = 1,
		profile2 = 4,
		secret1 = 8,
		profile5 = 7,
		secret2 = 9
	}
	
	table.sort(var_44_2, function(arg_46_0, arg_46_1)
		return (var_44_4[arg_46_0.type] or 9999) < (var_44_4[arg_46_1.type] or 9999)
	end)
	
	return var_44_2
end

function UnitDetailProfile.profile_list.getScrollViewItem(arg_47_0, arg_47_1)
	if not arg_47_0.vars or not get_cocos_refid(arg_47_0.vars.listview) or table.empty(arg_47_1) then
		return 
	end
	
	local var_47_0 = load_control("wnd/unit_detail_profile_item.csb")
	
	if arg_47_1.type then
		local function var_47_1(arg_48_0, arg_48_1)
			if not get_cocos_refid(arg_48_0) or not arg_48_1 then
				return 
			end
			
			local var_48_0 = arg_47_0.vars.profile_unlock_infos[arg_48_1]
			
			if table.empty(var_48_0) then
				return 
			end
			
			local var_48_1
			local var_48_2 = "msg_profile_unlock_req_"
			
			if var_48_0.type then
				var_48_1 = var_48_2 .. var_48_0.type
				
				if var_48_0.type == "intimacy" then
					var_48_1 = T(var_48_1, {
						intimacy_level = var_48_0.level or 0
					})
				elseif var_48_0.type == "devotion" then
					local var_48_3 = DB("devotion_skill_grade", tostring(var_48_0.level), "grade")
					
					var_48_1 = T(var_48_1, {
						devotion_grade = var_48_3 or "S"
					})
				end
			end
			
			if_set(arg_48_0, nil, var_48_1)
		end
		
		local var_47_2 = "ui_unit_detail_profile_item_"
		local var_47_3 = arg_47_1.type
		local var_47_4 = 0
		local var_47_5 = var_47_0:getChildByName("title_bg")
		
		if get_cocos_refid(var_47_5) then
			var_47_4 = var_47_5:getContentSize().height * var_47_5:getScale()
		end
		
		local var_47_6 = var_47_2 .. var_47_3
		
		if var_47_3 == "intro" then
			var_47_6 = "ui_unit_detail_profile_item_2line"
		elseif var_47_3 == "dic_category" then
			var_47_6 = "ui_unit_detail_profile_item_dic_ctg"
		end
		
		if_set(var_47_0, "txt_title", T(var_47_6))
		
		local var_47_7 = 0
		local var_47_8
		local var_47_9
		
		if arg_47_1.is_unlock then
			local var_47_10
			
			if table.empty(arg_47_1.voice) then
				var_47_10 = var_47_0:getChildByName("n_txt")
				
				if get_cocos_refid(var_47_10) then
					var_47_8 = var_47_10:getChildByName("txt_contents")
				end
			else
				var_47_10 = var_47_0:getChildByName("n_txt_voice")
				
				if get_cocos_refid(var_47_10) then
					local var_47_11 = var_47_10:getChildByName("btn_voice")
					
					if get_cocos_refid(var_47_11) then
						var_47_11.data = arg_47_1.voice
						
						if arg_47_1.voice.is_unlock then
							if_set(var_47_11, "txt_voice", T("ui_unit_detail_profile_item_secret_voice"))
						else
							var_47_1(var_47_11:getChildByName("txt_voice_locked"), arg_47_1.voice.type)
						end
						
						if_set_opacity(var_47_11, nil, arg_47_1.voice.is_unlock and 255 or 127.5)
						if_set_visible(var_47_10, "icon_locked_voice", not arg_47_1.voice.is_unlock)
						if_set_visible(var_47_10, "txt_voice", arg_47_1.voice.is_unlock)
						if_set_visible(var_47_10, "txt_voice_locked", not arg_47_1.voice.is_unlock)
					end
					
					var_47_8 = var_47_10:getChildByName("txt_contents")
					var_47_7 = var_47_7 + var_47_11:getContentSize().height * var_47_11:getScale()
				end
			end
			
			var_47_10:setVisible(true)
			if_set(var_47_8, nil, T(arg_47_1.value))
			
			local var_47_12 = var_47_8:getContentSize()
			
			var_47_7 = var_47_7 + UIUtil:setTextAndReturnHeight(var_47_8, T(arg_47_1.value), var_47_12.width)
		else
			local var_47_13 = var_47_0:getChildByName("n_locked")
			
			if get_cocos_refid(var_47_13) then
				var_47_13:setVisible(true)
				
				var_47_8 = var_47_13:getChildByName("txt_locked")
				
				var_47_1(var_47_8, var_47_3)
			end
			
			local var_47_14 = var_47_8:getContentSize()
			
			var_47_7 = var_47_7 + UIUtil:setTextAndReturnHeight(var_47_8, var_47_8:getString(), var_47_14.width)
		end
		
		local var_47_15 = var_47_0:getContentSize()
		local var_47_16 = (var_47_7 <= var_47_4 and var_47_4 or var_47_7) + 20
		local var_47_17 = var_47_16 - var_47_15.height
		
		if_set_position_y(var_47_0, "n_base", var_47_17)
		
		var_47_15.height = var_47_16
		
		var_47_0:setContentSize(var_47_15)
	end
	
	return var_47_0
end

function UnitDetailProfile.intimacy_list.onCreate(arg_49_0, arg_49_1)
	if not get_cocos_refid(arg_49_1) then
		return 
	end
	
	arg_49_0.vars = {}
	arg_49_0.vars.n_scroll_view_group = arg_49_1:getChildByName("n_ScrollView_profile2")
	
	if not get_cocos_refid(arg_49_0.vars.n_scroll_view_group) then
		return 
	end
	
	arg_49_0:initVoiceList()
	arg_49_0:initEmotionList()
	arg_49_0.vars.n_scroll_view_group:setVisible(false)
end

function UnitDetailProfile.intimacy_list.onRelease(arg_50_0)
	if not arg_50_0.vars or not get_cocos_refid(arg_50_0.vars.n_scroll_view_group) then
		return 
	end
	
	if not arg_50_0.vars.voice or not arg_50_0.vars.emotion then
		return 
	end
	
	arg_50_0.vars.voice.listview:clear()
	arg_50_0.vars.emotion.listview:removeAllChildren()
	arg_50_0.vars.emotion.listview:setDataSource(nil)
	arg_50_0:onLeave()
end

function UnitDetailProfile.intimacy_list.initVoiceList(arg_51_0)
	if not arg_51_0.vars or not get_cocos_refid(arg_51_0.vars.n_scroll_view_group) then
		return 
	end
	
	arg_51_0.vars.voice = {}
	
	local var_51_0 = arg_51_0.vars.n_scroll_view_group:getChildByName("ListView_voice")
	
	if get_cocos_refid(var_51_0) then
		arg_51_0.vars.voice.listview = GroupListView:bindControl(var_51_0)
		
		arg_51_0.vars.voice.listview:setListViewCascadeOpacityEnabled(true)
		arg_51_0.vars.voice.listview:setEnableMargin(true)
		
		local var_51_1 = load_control("wnd/hero_detail_intimacy_voice_header.csb")
		local var_51_2 = {
			onUpdate = function(arg_52_0, arg_52_1, arg_52_2)
				arg_51_0:updateVoiceHeaderItem(arg_52_1, arg_52_2)
			end
		}
		local var_51_3 = {
			onUpdate = function(arg_53_0, arg_53_1, arg_53_2)
				arg_51_0:updateVoiceListViewItem(arg_53_1, arg_53_2)
			end
		}
		local var_51_4 = load_control("wnd/hero_detail_intimacy_voice.csb")
		
		arg_51_0.vars.voice.listview:setRenderer(var_51_1, var_51_4, var_51_2, var_51_3)
		arg_51_0.vars.voice.listview:clear()
	end
end

function UnitDetailProfile.intimacy_list.initEmotionList(arg_54_0)
	if not arg_54_0.vars or not get_cocos_refid(arg_54_0.vars.n_scroll_view_group) then
		return 
	end
	
	arg_54_0.vars.emotion = {}
	
	local var_54_0 = arg_54_0.vars.n_scroll_view_group:getChildByName("ListView_expression")
	
	if get_cocos_refid(var_54_0) then
		arg_54_0.vars.emotion.listview = ItemListView_v2:bindControl(var_54_0)
		
		local var_54_1 = {
			onUpdate = function(arg_55_0, arg_55_1, arg_55_2, arg_55_3)
				arg_54_0:updateEmotionListViewItem(arg_55_1, arg_55_3)
				
				return arg_55_3.id
			end
		}
		local var_54_2 = load_control("wnd/hero_detail_expression_face.csb")
		
		arg_54_0.vars.emotion.listview:setRenderer(var_54_2, var_54_1)
	end
end

function UnitDetailProfile.intimacy_list.onEnter(arg_56_0, arg_56_1)
	if not UnitDetailProfile:isVisible() then
		return 
	end
	
	if not arg_56_0.vars or not get_cocos_refid(arg_56_0.vars.n_scroll_view_group) then
		return 
	end
	
	arg_56_1 = arg_56_1 or arg_56_0.vars.unit
	
	if not arg_56_1 then
		return 
	end
	
	arg_56_0.vars.unit = arg_56_1
	
	arg_56_0.vars.n_scroll_view_group:setVisible(true)
	arg_56_0:setEmotionList(arg_56_1)
	arg_56_0:setVoiceList(arg_56_1)
end

function UnitDetailProfile.intimacy_list.setVoiceList(arg_57_0, arg_57_1)
	if not UnitDetailProfile:isVisible() then
		return 
	end
	
	if not arg_57_0.vars.voice or not get_cocos_refid(arg_57_0.vars.voice.listview) then
		return 
	end
	
	if not arg_57_0.vars.emotion or table.empty(arg_57_0.vars.emotion.db) then
		return 
	end
	
	arg_57_1 = arg_57_1 or arg_57_0.vars.unit
	
	if not arg_57_1 then
		return 
	end
	
	arg_57_0.vars.voice.notyet_infos = {}
	arg_57_0.vars.voice.unlock_infos = {}
	
	local var_57_0 = arg_57_1:getFavLevel()
	
	for iter_57_0, iter_57_1 in pairs(arg_57_0.vars.emotion.db) do
		if iter_57_1.voice_id then
			if iter_57_1.lock == "y" then
				arg_57_0.vars.voice.notyet_infos[iter_57_1.voice_id] = true
			else
				arg_57_0.vars.voice.unlock_infos[iter_57_1.voice_id] = {
					intimacy_level = iter_57_1.intimacy_level,
					is_unlock = var_57_0 >= iter_57_1.intimacy_level
				}
			end
		end
	end
	
	local var_57_1 = {
		"battle",
		"skill",
		"smalltalk",
		"camping"
	}
	
	arg_57_0.vars.voice.db = {}
	
	local var_57_2 = arg_57_1.db.code
	
	if arg_57_1:isMoonlightDestinyUnit() then
		var_57_2 = MoonlightDestiny:getRelationCharacterCode(var_57_2)
	end
	
	local var_57_3 = arg_57_1:getSkinCode()
	
	for iter_57_2, iter_57_3 in pairs(var_57_1) do
		local var_57_4 = {}
		
		for iter_57_4 = 1, 99 do
			local var_57_5 = var_57_2
			
			if var_57_3 then
				local var_57_6 = string.format("%s_%s_%02d", var_57_3, iter_57_3, iter_57_4)
				
				if DB("character_intimacy_voice", var_57_6, "id") then
					var_57_5 = var_57_3
				end
			end
			
			local var_57_7 = string.format("%s_%s_%02d", var_57_5, iter_57_3, iter_57_4)
			local var_57_8 = SLOW_DB_ALL("character_intimacy_voice", var_57_7)
			
			if not var_57_8 then
				break
			end
			
			if var_57_8.id == nil then
				break
			end
			
			var_57_8.is_unlock = false
			
			if arg_57_0.vars.voice.unlock_infos and arg_57_0.vars.voice.unlock_infos[iter_57_3] then
				var_57_8.is_unlock = arg_57_0.vars.voice.unlock_infos[iter_57_3].is_unlock
			end
			
			if not arg_57_0.vars.voice.notyet_infos[iter_57_3] then
				table.insert(var_57_4, var_57_8)
			end
		end
		
		if #var_57_4 > 0 then
			arg_57_0.vars.voice.db[iter_57_3] = var_57_4
		end
	end
	
	arg_57_0.vars.voice.listview:clear()
	
	for iter_57_5, iter_57_6 in pairs(arg_57_0.vars.voice.db or {}) do
		arg_57_0.vars.voice.listview:addGroup(iter_57_5, iter_57_6)
	end
end

function UnitDetailProfile.intimacy_list.updateVoiceHeaderItem(arg_58_0, arg_58_1, arg_58_2)
	if not UnitDetailProfile:isVisible() then
		return 
	end
	
	if not get_cocos_refid(arg_58_1) or not arg_58_2 then
		return 
	end
	
	if not arg_58_0.vars or not arg_58_0.vars.voice or not arg_58_0.vars.voice.unlock_infos then
		return 
	end
	
	if arg_58_0.vars.voice.unlock_infos[arg_58_2] then
		local var_58_0 = arg_58_0.vars.voice.unlock_infos[arg_58_2]
		local var_58_1 = arg_58_0.vars.voice.unlock_infos[arg_58_2].is_unlock
		
		if_set_visible(arg_58_1, "n_title", false)
		if_set_visible(arg_58_1, "n_title_locked", false)
		
		local var_58_2
		local var_58_3 = var_58_1 and "n_title" or "n_title_locked"
		local var_58_4 = arg_58_1:getChildByName(var_58_3)
		
		if get_cocos_refid(var_58_4) then
			var_58_4:setVisible(true)
			if_set_visible(var_58_4, "icon_battle", arg_58_2 == "battle")
			if_set_visible(var_58_4, "icon_skill", arg_58_2 == "skill")
			if_set_visible(var_58_4, "icon_camping", arg_58_2 == "camping")
			
			local var_58_5 = {
				camping = "camp_start_title",
				skill = "voice_list_skill",
				battle = "voice_list_normal"
			}
			local var_58_6
			local var_58_7
			
			if var_58_1 then
				var_58_6 = "txt_title"
				var_58_7 = T(var_58_5[arg_58_2])
			else
				var_58_6 = "txt_locked"
				var_58_7 = T("msg_profile_unlock_req_intimacy", {
					intimacy_level = var_58_0.intimacy_level or 0
				})
				
				local var_58_8 = var_58_4:getChildByName(var_58_6)
				
				if get_cocos_refid(var_58_8) then
					var_58_8:ignoreContentAdaptWithSize(true)
					UIUserData:call(var_58_8, "SINGLE_WSCALE(220)")
				end
			end
			
			if_set(var_58_4, var_58_6, var_58_7)
		end
	end
end

function UnitDetailProfile.intimacy_list.updateVoiceListViewItem(arg_59_0, arg_59_1, arg_59_2)
	if not UnitDetailProfile:isVisible() then
		return 
	end
	
	if not get_cocos_refid(arg_59_1) or table.empty(arg_59_2) then
		return 
	end
	
	local var_59_0 = arg_59_1:getChildByName("btn_voice_nosound")
	
	if get_cocos_refid(var_59_0) then
		var_59_0.data = arg_59_2
		
		if_set_opacity(var_59_0, nil, arg_59_2.is_unlock and 255 or 127.5)
		
		local var_59_1 = var_59_0:getChildByName("label")
		
		if get_cocos_refid(var_59_1) then
			var_59_1:ignoreContentAdaptWithSize(true)
			UIUserData:call(var_59_1, "SINGLE_WSCALE(204)")
			if_set(var_59_1, nil, T(arg_59_2.name))
		end
	end
end

function UnitDetailProfile.intimacy_list.setEmotionList(arg_60_0, arg_60_1)
	if not UnitDetailProfile:isVisible() then
		return 
	end
	
	if not arg_60_0.vars.emotion or not get_cocos_refid(arg_60_0.vars.emotion.listview) then
		return 
	end
	
	arg_60_1 = arg_60_1 or arg_60_0.vars.unit
	
	if not arg_60_1 then
		return 
	end
	
	local var_60_0 = arg_60_1.db.code
	
	if arg_60_1.inst.skin_code ~= nil and arg_60_1.inst.skin_code ~= "" then
		var_60_0 = arg_60_1.inst.skin_code
	end
	
	arg_60_0.vars.emotion.db = {}
	
	for iter_60_0 = 1, 10 do
		local var_60_1 = SLOW_DB_ALL("character_intimacy_level", (DB("character", var_60_0, "emotion_id") or var_60_0) .. "_" .. iter_60_0)
		
		if not var_60_1 then
			break
		end
		
		if not var_60_1.id then
			break
		end
		
		table.push(arg_60_0.vars.emotion.db, var_60_1)
	end
	
	local var_60_2 = arg_60_0.vars.unit:getFaceID() or "normal"
	local var_60_3 = arg_60_1:getFavLevel()
	local var_60_4 = {}
	
	for iter_60_1, iter_60_2 in pairs(arg_60_0.vars.emotion.db or {}) do
		if iter_60_2.emotion then
			local var_60_5 = table.clone(iter_60_2)
			
			if var_60_3 and iter_60_2.intimacy_level then
				var_60_5.is_unlock = var_60_3 >= iter_60_2.intimacy_level
			end
			
			if iter_60_2.emotion == var_60_2 then
				arg_60_0.vars.emotion.original_intimacy_level = iter_60_2.intimacy_level
				var_60_5.is_selected = true
			end
			
			table.insert(var_60_4, var_60_5)
		end
	end
	
	arg_60_0.vars.emotion.listview:removeAllChildren()
	arg_60_0.vars.emotion.listview:setDataSource(var_60_4)
	arg_60_0.vars.emotion.listview:jumpToTop()
end

function UnitDetailProfile.intimacy_list.updateEmotionListViewItem(arg_61_0, arg_61_1, arg_61_2)
	if not UnitDetailProfile:isVisible() then
		return 
	end
	
	if not get_cocos_refid(arg_61_1) or table.empty(arg_61_2) then
		return 
	end
	
	local var_61_0 = arg_61_2.emotion
	
	if string.starts(var_61_0, "special") then
		var_61_0 = "special"
	end
	
	local var_61_1 = "img/cm_icon_face_" .. var_61_0 .. ".png"
	
	if_set_opacity(arg_61_1, "n_face", arg_61_2.is_unlock and 255 or 127.5)
	if_set_sprite(arg_61_1, "icon", var_61_1)
	
	if arg_61_2.is_unlock then
		if_set(arg_61_1, "txt_name", T("emo_" .. arg_61_2.emotion))
	else
		if_set(arg_61_1, "txt_locked", T("msg_profile_unlock_req_intimacy", {
			intimacy_level = arg_61_2.intimacy_level or 0
		}))
	end
	
	if_set_visible(arg_61_1, "txt_name", arg_61_2.is_unlock)
	if_set_color(arg_61_1, "txt_name", arg_61_2.is_selected and tocolor("#FFFFFF") or tocolor("#40426e"))
	if_set_visible(arg_61_1, "txt_locked", not arg_61_2.is_unlock)
	if_set_visible(arg_61_1, "icon_locked", not arg_61_2.is_unlock)
	if_set_visible(arg_61_1, "select", arg_61_2.is_selected)
	if_set_visible(arg_61_1, "icon_check", arg_61_2.is_selected)
	
	if arg_61_2.is_selected then
		arg_61_0.vars.emotion.cur_seleted_item = arg_61_2
	end
	
	local var_61_2 = arg_61_1:getChildByName("btn_face")
	
	if var_61_2 then
		var_61_2.data = arg_61_2
	end
end

function UnitDetailProfile.intimacy_list.setEmotion(arg_62_0, arg_62_1)
	if not UnitDetailProfile:isVisible() then
		return 
	end
	
	if not arg_62_0.vars or not arg_62_0.vars.emotion or not arg_62_0.vars.unit then
		return 
	end
	
	if not get_cocos_refid(arg_62_1) or table.empty(arg_62_1.data) then
		return 
	end
	
	local var_62_0 = UnitMain:getPortrait()
	
	if var_62_0 and var_62_0.unit and var_62_0.unit.db.face_id ~= arg_62_0.vars.unit.db.face_id then
		balloon_message_with_sound("msg_cant_emotion_while_skin")
		
		return 
	end
	
	local var_62_1 = arg_62_1.data
	
	if not var_62_1.is_unlock then
		balloon_message_with_sound("need_more_fav_point")
		
		return 
	end
	
	if arg_62_0.vars.emotion.original_intimacy_level and arg_62_0.vars.emotion.original_intimacy_level == var_62_1.intimacy_level then
		return 
	end
	
	if arg_62_0.vars.emotion.cur_seleted_item then
		arg_62_0.vars.emotion.cur_seleted_item.is_selected = false
	end
	
	var_62_1.is_selected = true
	arg_62_0.vars.emotion.cur_seleted_item = var_62_1
	
	arg_62_0.vars.emotion.listview:refresh()
	UnitMain:setPortraitEmotion(arg_62_0.vars.unit, UnitMain:getPortrait(), var_62_1.emotion)
	
	if var_62_1.intimacy_level then
		local var_62_2 = var_62_1.intimacy_level - 1
		
		if var_62_2 >= 0 and var_62_2 < 10 then
			query("set_unit_face_value", {
				target = arg_62_0.vars.unit:getUID(),
				value = var_62_2
			})
			
			arg_62_0.vars.emotion.original_intimacy_level = var_62_1.intimacy_level
		end
	end
end

function UnitDetailProfile.intimacy_list.onLeave(arg_63_0)
	if not arg_63_0.vars or not get_cocos_refid(arg_63_0.vars.n_scroll_view_group) then
		return 
	end
	
	arg_63_0.vars.n_scroll_view_group:setVisible(false)
end
