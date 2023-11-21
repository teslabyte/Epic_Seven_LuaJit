ShareUnitPopup = ShareUnitPopup or {}
ShareChatPopup = {}
ShareUnitUtil = ShareUnitUtil or {}

function HANDLER.hero_vote_open(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_close" then
		ShareUnitPopup:close()
		
		return 
	end
	
	if ReviewPreviewPopup.ready and arg_1_1 == "btn_good" then
		balloon_message_with_sound("err_cannot_rate_review_popup")
		
		return 
	end
	
	if arg_1_1 == "btn_good" then
		local var_1_0 = arg_1_0:getName()
		local var_1_1 = arg_1_0.comment_id
		local var_1_2 = 1
		
		Review:reviewComment(var_1_1, var_1_2)
	end
end

function HANDLER.unit_share(arg_2_0, arg_2_1)
	if arg_2_1 == "btn_close" then
		ShareUnitPopup:close()
	end
end

function ShareUnitPopup.open(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	if arg_3_0.vars and get_cocos_refid(arg_3_0.vars.wnd) or not arg_3_1 then
		return 
	end
	
	local var_3_0 = arg_3_3 or {}
	
	if ContentDisable:byAlias("hero_equip_share") then
		balloon_message_with_sound("msg_contents_disable_hero_equip_share")
		
		return 
	end
	
	if not ChatSock:is_connected() then
		balloon_message_with_sound("err_message_channel_connecting")
		
		return 
	end
	
	if not var_3_0.is_chat then
		arg_3_1 = UNIT:create(arg_3_1, false, true)
	else
		arg_3_1 = arg_3_1:clone()
	end
	
	local var_3_1 = var_3_0.gb_level or 0
	
	if var_3_0.growth_boost then
		arg_3_1 = GrowthBoost:applyManual(arg_3_1, var_3_1)
	end
	
	local var_3_2 = arg_3_2 or {}
	
	if not arg_3_1 or not ShareUnitUtil:checkSharableUnit(arg_3_1) then
		return 
	end
	
	for iter_3_0, iter_3_1 in pairs(var_3_2) do
		local var_3_3 = EQUIP:createByInfo(iter_3_1)
		
		if not var_3_3 then
			print("Error: no equip : " .. tostring(iter_3_1.code))
		else
			arg_3_1:addEquip(var_3_3, true)
		end
	end
	
	arg_3_1:calc()
	
	arg_3_0.vars = {}
	arg_3_0.vars.opts = var_3_0
	arg_3_0.vars.is_review = arg_3_0.vars.opts.is_review and var_3_0.review_data
	arg_3_0.vars.can_use_exlusive = arg_3_1:isExclusiveEquip_exist()
	
	local var_3_4 = "unit_share"
	
	if arg_3_0.vars.is_review then
		var_3_4 = "hero_vote_open"
	end
	
	arg_3_0.vars.wnd = load_dlg(var_3_4, true, "wnd", function()
		arg_3_0:close()
	end)
	
	SceneManager:getRunningPopupScene():addChild(arg_3_0.vars.wnd)
	arg_3_0.vars.wnd:bringToFront()
	
	arg_3_0.vars.unit = arg_3_1
	arg_3_0.vars.equips = arg_3_1.equips
	
	if arg_3_0.vars.is_review then
		arg_3_0.vars.comment_data = var_3_0.review_data
	else
		arg_3_0.vars.user_name = var_3_0.user_name
	end
	
	arg_3_0:init()
end

function ShareUnitPopup.init(arg_5_0)
	arg_5_0:initCharacterUI()
	arg_5_0:initEquipsUI()
	
	if arg_5_0.vars.is_review then
		arg_5_0:initComment()
		
		local var_5_0 = arg_5_0.vars.wnd:getChildByName("LEFT")
		
		UIUtil:getRewardIcon(nil, arg_5_0.vars.unit:getDisplayCode(), {
			no_db_grade = true,
			role = true,
			no_popup = true,
			parent = var_5_0:getChildByName("mob_icon"),
			lv = arg_5_0.vars.unit:getLv(),
			max_lv = arg_5_0.vars.unit:getMaxLevel(),
			grade = arg_5_0.vars.unit:getGrade(),
			zodiac = arg_5_0.vars.unit:getZodiacGrade(),
			awake = arg_5_0.vars.unit:getAwakeGrade()
		})
	else
		arg_5_0:initPortrait()
		UIUtil:setLevelDetail(arg_5_0.vars.wnd:getChildByName("LEFT"), arg_5_0.vars.unit:getLv(), arg_5_0.vars.unit:getMaxLevel())
		
		if arg_5_0.vars.user_name then
			if_set(arg_5_0.vars.wnd, "title", T("popup_hero_shared_details_title", {
				name = arg_5_0.vars.user_name
			}))
			
			local var_5_1 = arg_5_0.vars.opts.leader_code
			local var_5_2 = arg_5_0.vars.opts.border_code
			
			if var_5_1 and var_5_2 then
				UIUtil:getRewardIcon(nil, var_5_1, {
					no_popup = true,
					scale = 0.8,
					no_grade = true,
					parent = arg_5_0.vars.wnd:getChildByName("n_infoface_mob_icon"),
					border_code = var_5_2
				})
			end
		end
	end
end

function ShareUnitPopup.initCharacterUI(arg_6_0)
	arg_6_0:initStatUI()
	
	local var_6_0 = arg_6_0.vars.wnd:getChildByName("n_skills")
	
	UIUtil:setUnitSkillInfo(var_6_0, arg_6_0.vars.unit, {
		tooltip_opts = {
			show_effs = "right"
		}
	})
end

function ShareUnitPopup.initStatUI(arg_7_0)
	UIUtil:setUnitAllInfo(arg_7_0.vars.wnd, arg_7_0.vars.unit)
	UIUtil:setDevoteDetail_new(arg_7_0.vars.wnd, arg_7_0.vars.unit, {
		target = "n_dedi",
		fit_sprite = true
	})
end

function get_equip_type_index(arg_8_0)
	return ({
		weapon = 1,
		armor = 4,
		ring = 6,
		boot = 5,
		helm = 2,
		artifact = 7,
		neck = 3,
		exclusive = 8
	})[arg_8_0]
end

function ShareUnitPopup.initEquipsUI(arg_9_0)
	local var_9_0 = arg_9_0.vars.wnd:getChildByName("n_item")
	
	if not get_cocos_refid(var_9_0) then
		return 
	end
	
	for iter_9_0, iter_9_1 in pairs(arg_9_0.vars.equips) do
		local var_9_1 = get_equip_type_index(iter_9_1.db.type)
		
		if var_9_1 then
			local var_9_2
			
			if var_9_1 == 7 or var_9_1 == 8 then
				var_9_2 = var_9_0:getChildByName("btn_item" .. var_9_1)
			else
				var_9_2 = var_9_0:getChildByName("item_slot" .. var_9_1)
			end
			
			if get_cocos_refid(var_9_2) then
				local var_9_3
				local var_9_4 = 1
				
				if var_9_1 == 7 then
					var_9_3 = var_9_2:getChildByName("item_art_icon")
				elseif var_9_1 == 8 then
					var_9_3 = var_9_2:getChildByName("n_private_icon")
				else
					var_9_3 = var_9_2:getChildByName("n_item1")
				end
				
				var_9_3:setVisible(true)
				
				if iter_9_1.lock then
					iter_9_1.lock = false
				end
				
				local var_9_5 = UIUtil:getRewardIcon("equip", iter_9_1.code, {
					tooltip_delay = 130,
					parent = var_9_3,
					equip = iter_9_1,
					scale = var_9_4
				})
			end
		end
	end
	
	if not arg_9_0.vars.can_use_exlusive then
		local var_9_6 = var_9_0:getChildByName("btn_item7")
		
		var_9_0:getChildByName("btn_item8"):setVisible(false)
		
		if not var_9_6.move_pos then
			var_9_6.move_pos = true
			
			var_9_6:setPositionY(var_9_6:getPositionY() - 55)
		end
	end
end

function ShareUnitPopup.initComment(arg_10_0)
	if not arg_10_0.vars.is_review or not arg_10_0.vars.comment_data then
		return 
	end
	
	local var_10_0 = arg_10_0.vars.wnd:getChildByName("n_vote")
	local var_10_1 = arg_10_0.vars.comment_data
	local var_10_2 = var_10_1.comment
	
	if_set(var_10_0, "t_review", urldecode(var_10_2))
	if_set(arg_10_0.vars.wnd:getChildByName("n_window"), "title", T("hero_review_detail_popup_title", {
		name = var_10_1.name
	}))
	if_set(var_10_0, "txt_date", T("time_dot_y_m_d", timeToStringDef({
		preceding_with_zeros = true,
		time = var_10_1.created
	})))
	arg_10_0:refreshCommentButtons()
end

function ShareUnitPopup.refreshCommentButtons(arg_11_0, arg_11_1)
	if not arg_11_0.vars or not get_cocos_refid(arg_11_0.vars.wnd) or not arg_11_0.vars.comment_data then
		return 
	end
	
	local var_11_0 = arg_11_0.vars.comment_data
	local var_11_1 = arg_11_0.vars.wnd:getChildByName("n_vote")
	
	if arg_11_1 and var_11_0.comment_id == tonumber(arg_11_1.cid) then
		var_11_0.my_like = arg_11_1.c.my_like
		arg_11_0.vars.comment_data.my_like = arg_11_1.c.my_like
		var_11_0.like_count = arg_11_1.c.like_count
		arg_11_0.vars.comment_data.like_count = arg_11_1.c.like_count
	end
	
	ReviewCommon:updateCommentButtons(var_11_1, var_11_0.comment_id, var_11_0.like_count, var_11_0.dislike_count, var_11_0.my_like)
end

function ShareUnitPopup.initPortrait(arg_12_0)
	local var_12_0 = arg_12_0.vars.unit.db.face_id
	local var_12_1, var_12_2 = UIUtil:getPortraitAni(var_12_0, {
		pin_sprite_position_y = true
	})
	
	if var_12_1 then
		arg_12_0.vars.wnd:getChildByName("n_portrait"):addChild(var_12_1)
		
		if var_12_2 then
			var_12_1:setPositionY(-470)
		else
			var_12_1:setScaleX(-0.6)
			var_12_1:setScaleY(0.6)
			
			local var_12_3 = var_12_1:getContentSize()
			
			var_12_1:setPositionY(var_12_3.height / 2 * 0.3)
		end
	end
end

function ShareUnitPopup.close(arg_13_0, arg_13_1)
	if not arg_13_0.vars or not get_cocos_refid(arg_13_0.vars.wnd) then
		return 
	end
	
	BackButtonManager:pop({
		check_id = "ShareUnitPopup",
		dlg = arg_13_0.vars.wnd
	})
	arg_13_0.vars.wnd:removeFromParent()
	
	arg_13_0.vars = nil
end

function ShareUnitUtil.checkSharableUnit(arg_14_0, arg_14_1)
	if not arg_14_1 then
		return 
	end
	
	return not (arg_14_1:getBaseGrade() < 2) and not arg_14_1:isPromotionUnit() and not arg_14_1:isDevotionUnit() and not arg_14_1:isSpecialUnit()
end

function HANDLER.share_chat(arg_15_0, arg_15_1, arg_15_2)
	if arg_15_1 == "btn_nor_channel" then
		ShareChatPopup:req_share("public")
	elseif arg_15_1 == "btn_knt_channel" then
		if not Account:getClanId() then
			balloon_message_with_sound("err_message_knights_channel_unavailable")
		else
			ShareChatPopup:req_share("clan")
		end
	end
end

function ShareChatPopup.open(arg_16_0, arg_16_1)
	if ContentDisable:byAlias("hero_equip_share") then
		balloon_message_with_sound("msg_contents_disable_hero_equip_share")
		
		return 
	end
	
	if not ChatSock:is_connected() then
		balloon_message_with_sound("err_message_channel_connecting")
		
		return 
	end
	
	local var_16_0 = arg_16_1 or {}
	local var_16_1 = var_16_0.parent_layer
	
	if not var_16_1 or not get_cocos_refid(var_16_1) then
		return 
	end
	
	arg_16_0.vars = {}
	arg_16_0.vars.wnd = load_dlg("share_chat", true, "wnd", function()
		arg_16_0:close()
	end)
	arg_16_0.vars.is_equip = var_16_0.is_equip
	arg_16_0.vars.uid = var_16_0.uid
	
	local var_16_2 = var_16_0.move_x or 0
	
	var_16_1:setVisible(true)
	var_16_1:addChild(arg_16_0.vars.wnd)
	
	arg_16_0.vars.parent_layer = var_16_1
	
	if not Account:getClanId() then
		if_set_opacity(arg_16_0.vars.wnd, "btn_knt_channel", 76.5)
	end
	
	if arg_16_0.vars.is_equip then
		if_set(arg_16_0.vars.wnd, "txt_t", T("popup_equip_share_title"))
	else
		if_set(arg_16_0.vars.wnd, "txt_t", T("popup_hero_share_title"))
	end
	
	arg_16_0.vars.wnd:setPosition(var_16_2, 60)
	arg_16_0.vars.wnd:setAnchorPoint(0, 0)
	
	return arg_16_0.vars.wnd
end

function ShareChatPopup.req_share(arg_18_0, arg_18_1)
	if not arg_18_0.vars or not get_cocos_refid(arg_18_0.vars.wnd) then
		return 
	end
	
	if arg_18_0.vars.is_equip then
		ChatMain:requestShareEquip(arg_18_0.vars.uid, arg_18_1)
	else
		ChatMain:requestShareUnit(arg_18_0.vars.uid, arg_18_1)
	end
	
	arg_18_0:close()
end

function ShareChatPopup.close(arg_19_0)
	if not arg_19_0.vars or not get_cocos_refid(arg_19_0.vars.wnd) then
		return 
	end
	
	if get_cocos_refid(arg_19_0.vars.parent_layer) then
		arg_19_0.vars.parent_layer:setVisible(false)
	end
	
	BackButtonManager:pop({
		dlg = arg_19_0.vars.wnd
	})
	arg_19_0.vars.wnd:removeFromParent()
	
	arg_19_0.vars = nil
end
