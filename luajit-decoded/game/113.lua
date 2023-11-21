SubstoryUIUtil = SubstoryUIUtil or {}

function SubstoryUIUtil.testBGInfo(arg_1_0, arg_1_1)
	if PRODUCTION_MODE then
		return 
	end
	
	if arg_1_1 and type(arg_1_1) ~= "table" then
		Log.e("params_error", "info_opts")
		
		return 
	end
	
	local var_1_0 = SubstoryManager:getInfo()
	local var_1_1 = var_1_0.id
	local var_1_2 = var_1_0.background_summary
	local var_1_3 = arg_1_0.test_bg_info or SubstoryUIUtil:getBGInfo(var_1_2, var_1_1)
	
	if arg_1_1 then
		for iter_1_0, iter_1_1 in pairs(arg_1_1) do
			var_1_3[iter_1_0] = arg_1_1[iter_1_0]
		end
	end
	
	arg_1_0.test_bg_info = var_1_3
	
	arg_1_0:testBackground()
end

function SubstoryUIUtil.testBGReset(arg_2_0)
	if PRODUCTION_MODE then
		return 
	end
	
	SubstoryUIUtil.test_bg_info = nil
	
	SubstoryUIUtil:testBackground()
end

function SubstoryUIUtil.testBackground(arg_3_0, arg_3_1)
	if PRODUCTION_MODE then
		return 
	end
	
	if (SubstoryManager:getInfo().csb_name or "dungeon_story") == "dungeon_story" then
		arg_3_1 = true
	end
	
	local var_3_0 = true
	
	if arg_3_1 then
		var_3_0 = nil
	end
	
	local var_3_1 = SubstoryManager:getInfo()
	local var_3_2 = var_3_1.id
	local var_3_3 = var_3_1.background_summary
	local var_3_4 = SceneManager:getRunningNativeScene()
	local var_3_5 = var_3_4:getChildByName("dungeon_story_bg") or var_3_4:getChildByName("dungeon_story_bg_center")
	
	if not var_3_5 then
		return 
	end
	
	var_3_5:removeFromParent()
	
	local var_3_6 = arg_3_0.test_bg_info or SubstoryUIUtil:getBGInfo(var_3_3, var_3_2)
	
	arg_3_0.test_bg_info = var_3_6
	
	table.print(var_3_6)
	
	local var_3_7 = SubstoryUIUtil:getBackground(var_3_2, var_3_3, {
		isEnter = true,
		isCenter = var_3_0,
		test_bg_info = var_3_6
	})
	local var_3_8 = SubStoryLobby:getWnd()
	
	var_3_7:setAnchorPoint(0.5, 0.5)
	var_3_7:setLocalZOrder(-1)
	var_3_8:addChild(var_3_7)
end

function SubstoryUIUtil.load_link_url(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = {}
	local var_4_1 = getUserLanguage() or ""
	
	if arg_4_1 then
		local var_4_2 = arg_4_2
		
		if arg_4_1[var_4_2 .. "_" .. var_4_1] then
			var_4_2 = var_4_2 .. "_" .. var_4_1
		end
		
		local var_4_3 = arg_4_1[var_4_2]
		
		if var_4_3 and type(var_4_3) == "string" then
			local var_4_4 = string.gsub(var_4_3, "%s+", "")
			
			var_4_0.link = string.len(var_4_4) > 0 and arg_4_1[var_4_2] or nil
		end
	end
	
	return var_4_0
end

function SubstoryUIUtil.setLayoutData(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	arg_5_3 = arg_5_3 or {}
	
	local var_5_0 = arg_5_1:getChildByName(arg_5_2)
	
	if not get_cocos_refid(var_5_0) then
		return 
	end
	
	if arg_5_4 and not arg_5_3[arg_5_4] then
		var_5_0:setVisible(false)
		
		return 
	end
	
	if arg_5_3.txt then
		if_set(arg_5_1, arg_5_2, T(arg_5_3.txt))
		
		if get_cocos_refid(var_5_0) then
			if arg_5_3.v_align == "top" then
				var_5_0:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
			elseif arg_5_3.v_align == "center" then
				var_5_0:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
			elseif arg_5_3.v_align == "bot" then
				var_5_0:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_BOTTOM)
			end
			
			if arg_5_3.h_align == "left" then
				var_5_0:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
			elseif arg_5_3.h_align == "center" then
				var_5_0:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
			elseif arg_5_3.h_align == "right" then
				var_5_0:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_RIGHT)
			end
		end
	end
	
	SubstoryUIUtil:addMapFromData(var_5_0, arg_5_3)
	SubstoryUIUtil:addImageFromData(var_5_0, arg_5_3, arg_5_5)
	SubstoryUIUtil:addSpineObjectFromData(var_5_0, arg_5_3)
	SubstoryUIUtil:addEffectFromData(var_5_0, arg_5_3)
	SubstoryUIUtil:addPortraitFromData(var_5_0, arg_5_3, arg_5_5)
	
	if arg_5_3.offset_x then
		var_5_0:setPositionX(var_5_0:getPositionX() + (tonumber(arg_5_3.offset_x) or 0))
	end
	
	if arg_5_3.offset_y then
		var_5_0:setPositionY(var_5_0:getPositionY() + (tonumber(arg_5_3.offset_y) or 0))
	end
	
	if arg_5_3.rotation then
		var_5_0:setRotation(tonumber(arg_5_3.rotation) or 0)
	end
	
	if not arg_5_3.fill then
		if arg_5_3.scale_x then
			var_5_0:setScaleX(var_5_0:getScaleX() + (tonumber(arg_5_3.scale_x) or 1))
		end
		
		if arg_5_3.scale_y then
			var_5_0:setScaleY(var_5_0:getScaleY() + (tonumber(arg_5_3.scale_y) or 1))
		end
	end
	
	if arg_5_3.anchor_x or arg_5_3.anchor_y then
		var_5_0:setAnchorPoint(arg_5_3.anchor_x or 0.5, arg_5_3.anchor_y or 0.5)
	end
	
	if arg_5_3.show ~= nil then
		var_5_0:setVisible(arg_5_3.show)
	end
	
	if arg_5_3.link then
		var_5_0.link = arg_5_3.link
		
		var_5_0:setVisible(true)
	end
	
	return var_5_0
end

function SubstoryUIUtil.getBackground(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	arg_6_3 = arg_6_3 or {}
	
	local var_6_0 = arg_6_3.isEnter
	local var_6_1 = arg_6_3.isCenter
	local var_6_2 = SceneManager:getRunningNativeScene():findChildByName("@curtain")
	
	if get_cocos_refid(var_6_2) then
		var_6_2:removeFromParent()
	end
	
	local var_6_3 = arg_6_1
	local var_6_4 = arg_6_3.test_bg_info or SubstoryUIUtil:getBGInfo(arg_6_2, var_6_3)
	local var_6_5 = "dungeon_story_home"
	
	if var_6_0 and var_6_1 then
		var_6_5 = "dungeon_story_bg_center"
	elseif var_6_0 then
		var_6_5 = "dungeon_story_bg"
	end
	
	local var_6_6 = load_dlg(var_6_5, true, "wnd")
	
	var_6_6:setAnchorPoint(0.5, 1)
	
	if var_6_4.logo then
		var_6_4.logo.logo_position = var_6_4.logo_position and var_6_4.logo_position.poster_bi_x and var_6_4.logo_position or nil
	end
	
	arg_6_0:setLayoutData(var_6_6, "n_logo", var_6_4.logo, "img")
	
	if var_6_4.logo_position then
		local var_6_7 = var_6_6:getChildByName("n_logo")
		
		if var_6_4.logo_position.poster_bi_x then
			local var_6_8 = var_6_7:getChildByName(var_6_4.logo.img)
			
			if var_6_8 then
				var_6_8:setPositionX(var_6_4.logo_position.poster_bi_x or 0)
				var_6_8:setPositionY(var_6_4.logo_position.poster_bi_y or 0)
				var_6_8:setScale(var_6_4.logo_position.poster_bi_scale or 1)
			end
		end
	end
	
	arg_6_0:setLayoutData(var_6_6, "txt_logo_name", var_6_4.logo_title, "txt")
	arg_6_0:setLayoutData(var_6_6, "txt_logo_desc", var_6_4.logo_desc, "txt")
	arg_6_0:setLayoutData(var_6_6, "logo_grow", var_6_4.logo_glow)
	arg_6_0:setLayoutData(var_6_6, "txt_title_name", var_6_4.title, "txt")
	arg_6_0:setLayoutData(var_6_6, "txt_title_desc", var_6_4.desc, "txt")
	arg_6_0:setLayoutData(var_6_6, "title_grow", var_6_4.detail_glow)
	arg_6_0:setLayoutData(var_6_6, "t_info", var_6_4.desc2, "txt")
	arg_6_0:setLayoutData(var_6_6, "img_grow", var_6_4.detail_glow2)
	arg_6_0:setLayoutData(var_6_6, "n_bg", var_6_4.bg)
	arg_6_0:setLayoutData(var_6_6, "n_portrait", var_6_4.portrait, "portrait", {
		face = (var_6_4.face or {}).c
	})
	
	local var_6_9 = var_6_6:getChildByName("portrait")
	
	if var_6_9 then
		var_6_9:setAnchorPoint(0.5, 0.5)
	end
	
	arg_6_0:setLayoutData(var_6_6, "n_side_left", var_6_4.side_left)
	
	local var_6_10 = Account:getSubStoryScheduleDBById(var_6_4.substory_id)
	
	if arg_6_3.is_dlc then
		local var_6_11 = var_6_6:getChildByName("btn_event")
		local var_6_12 = var_6_6:getChildByName("btn_video")
		
		if get_cocos_refid(var_6_12) and get_cocos_refid(var_6_11) then
			var_6_12:setVisible(false)
			var_6_11:setVisible(false)
		end
	else
		local var_6_13 = arg_6_0:load_link_url(var_6_10, "link")
		local var_6_14 = arg_6_0:load_link_url(var_6_10, "web_event")
		local var_6_15 = arg_6_0:setLayoutData(var_6_6, "btn_video", var_6_13, "link")
		local var_6_16 = arg_6_0:setLayoutData(var_6_6, "btn_event", var_6_14, "link")
		local var_6_17 = var_6_6:getChildByName("n_btn_event")
		local var_6_18 = var_6_6:getChildByName("n_btn_video")
		
		if get_cocos_refid(var_6_17) and get_cocos_refid(var_6_16) then
			var_6_17:setVisible(true)
			var_6_18:setVisible(true)
		end
		
		local var_6_19 = SubstoryManager:getInfo()
		local var_6_20 = var_6_19 and (var_6_19.bonus_artifact1 or var_6_19.bonus_artifact2 or var_6_19.bonus_artifact3 or var_6_19.bonus_artifact4) ~= nil
		
		if var_6_19 and not var_6_19.category then
			if get_cocos_refid(var_6_17) and get_cocos_refid(var_6_16) then
				local var_6_21 = var_6_17:getChildByName("no_shop")
				
				var_6_16:setPosition(var_6_21:getPosition())
			end
			
			if get_cocos_refid(var_6_18) and get_cocos_refid(var_6_15) then
				local var_6_22 = var_6_18:getChildByName("no_shop")
				
				var_6_15:setPosition(var_6_22:getPosition())
			end
		elseif not var_6_20 then
			if get_cocos_refid(var_6_17) and get_cocos_refid(var_6_16) then
				local var_6_23 = var_6_17:getChildByName("no_arti")
				
				var_6_16:setPosition(var_6_23:getPosition())
			end
			
			if get_cocos_refid(var_6_18) and get_cocos_refid(var_6_15) then
				local var_6_24 = var_6_18:getChildByName("no_arti")
				
				var_6_15:setPosition(var_6_24:getPosition())
			end
		end
		
		if var_6_19 and not var_6_19.category and not var_6_20 and get_cocos_refid(var_6_18) and get_cocos_refid(var_6_15) and not get_cocos_refid(var_6_16) then
			local var_6_25 = var_6_18:getChildByName("n_only_pv")
			local var_6_26 = var_6_18:getChildByName("no_arti")
			
			if get_cocos_refid(var_6_25) and not var_6_19.achieve_flag then
				var_6_15:setPosition(var_6_25:getPosition())
			elseif var_6_19.achieve_flag then
				var_6_15:setPosition(var_6_26:getPosition())
			end
		end
		
		if var_6_19 and not var_6_1 and get_cocos_refid(var_6_15) and SubStoryUtil:getEventState(var_6_19.start_time, var_6_19.end_time) == SUBSTORY_CONSTANTS.STATE_READY then
			local var_6_27 = var_6_15:getParent()
			local var_6_28 = var_6_6:getChildByName("n_btn_pre_video")
			
			if get_cocos_refid(var_6_27) and get_cocos_refid(var_6_28) then
				local var_6_29, var_6_30 = var_6_28:getWorldPosition()
				local var_6_31 = var_6_28:convertToWorldSpace({
					x = var_6_29,
					y = var_6_30
				})
				local var_6_32 = var_6_27:convertToNodeSpace(var_6_31)
				
				var_6_15:setPosition(var_6_32.x, var_6_32.y)
			end
		end
	end
	
	if not var_6_0 then
		NotchManager:setIgnoreViewBase(var_6_6:getChildByName("LEFT"), true)
		
		local var_6_33 = cc.Layer:create()
		local var_6_34 = var_6_6:getChildByName("n_side_left")
		
		if arg_6_2 and arg_6_2 == "default" and get_cocos_refid(var_6_34) then
			if not var_6_34.origin_x then
				var_6_34.origin_x = var_6_34:getPositionX()
			end
			
			var_6_34:setPositionX(var_6_34.origin_x - 60)
		end
		
		var_6_6:setPositionX(-VIEW_BASE_LEFT)
		var_6_33:addChild(var_6_6)
		
		var_6_6 = var_6_33
	end
	
	local var_6_35 = var_6_6:getChildByName("n_core_reward")
	
	if var_6_4.custom_type and var_6_4.custom_type == "y" then
		if get_cocos_refid(var_6_35) then
			var_6_35:setVisible(true)
			
			local var_6_36 = {
				artifact_multiply_scale = 0.76,
				hero_multiply_scale = 1.06
			}
			local var_6_37 = SubstoryManager:setCoreRewardIcons(var_6_35, var_6_3, var_6_36)
			
			var_6_35:setVisible(var_6_37 and #var_6_37 > 0)
			
			local var_6_38 = var_6_35:getChildByName("btn_core_reward")
			
			var_6_38.substory_id = var_6_3
			var_6_38.popup_parent = DungeonList:getWndControl("n_reward_popup")
		end
	elseif get_cocos_refid(var_6_35) then
		var_6_35:setVisible(false)
	end
	
	local var_6_39 = var_6_6:getChildByName("n_title")
	
	if var_6_4.title and get_cocos_refid(var_6_39) then
		local var_6_40 = var_6_39:getChildByName("txt_title_name")
		local var_6_41 = var_6_39:getChildByName("txt_title_desc")
		
		if get_cocos_refid(var_6_40) and get_cocos_refid(var_6_41) then
			local var_6_42 = 10
			local var_6_43 = 8
			local var_6_44 = var_6_41:getStringNumLines()
			
			if not var_6_40.origin_y then
				var_6_40.origin_y = var_6_40:getPositionY()
				
				var_6_40:setPositionY(var_6_41:getPositionY() + var_6_43 + var_6_44 * var_6_42)
			end
		end
	end
	
	if var_6_4.desc2 then
		if_set_visible(var_6_6, "n_collaboration_info", true)
	end
	
	return var_6_6
end

function SubstoryUIUtil.getBGInfo(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_1
	local var_7_1 = arg_7_2
	
	if arg_7_2 then
		local var_7_2, var_7_3 = SubStoryUtil:getScheduleInfo(arg_7_2)
		local var_7_4 = (var_7_2 or {}).append
		
		var_7_1 = var_7_3 or var_7_1
		
		if var_7_4 then
			local var_7_5 = var_7_0 .. "_" .. var_7_4
			
			if DB("substory_bg", var_7_5, "id") then
				var_7_0 = var_7_5
			end
		end
	end
	
	local var_7_6 = DBT("substory_bg", var_7_0, {
		"logo",
		"title",
		"desc",
		"bg",
		"portrait",
		"home_bg",
		"logo_title",
		"logo_desc",
		"menu_color",
		"logo_glow",
		"detail_glow",
		"side_left",
		"btn_link",
		"btn_link_en",
		"btn_link_zht",
		"btn_event",
		"btn_event_en",
		"btn_event_zht",
		"pre_title",
		"pre_desc",
		"face",
		"logo_position",
		"desc2",
		"detail_glow2"
	}) or {}
	
	local function var_7_7(arg_8_0)
		local var_8_0 = arg_8_0 or ""
		local var_8_1 = string.gsub(var_8_0, " ", "")
		
		local function var_8_2(arg_9_0)
			if arg_9_0 == "n" or arg_9_0 == "false" then
				return false
			end
			
			if arg_9_0 == "y" or arg_9_0 == "true" then
				return true
			end
			
			if arg_9_0 == "nil" or arg_9_0 == "" then
				return nil
			end
			
			local var_9_0 = tonumber(arg_9_0)
			
			if var_9_0 then
				return var_9_0
			end
			
			return arg_9_0
		end
		
		local var_8_3 = totable(var_8_1)
		
		for iter_8_0, iter_8_1 in pairs(var_8_3) do
			var_8_3[iter_8_0] = var_8_2(iter_8_1)
		end
		
		return var_8_3
	end
	
	for iter_7_0, iter_7_1 in pairs(var_7_6) do
		var_7_6[iter_7_0] = var_7_7(iter_7_1)
	end
	
	var_7_6.substory_id = var_7_1
	
	return var_7_6
end

function SubstoryUIUtil.addImageFromData(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	arg_10_3 = arg_10_3 or {}
	arg_10_2 = arg_10_2 or {}
	
	if arg_10_2.img then
		local var_10_0 = load_control("wnd/dungeon_story_poster.csb")
		
		if arg_10_3.isCenter then
			var_10_0 = cc.Node:create()
			
			local var_10_1 = cc.Node:create()
			
			var_10_1:setName("n_bg")
			var_10_0:addChild(var_10_1)
		else
			var_10_0:setAnchorPoint(0, 0.5)
		end
		
		local var_10_2 = SpriteCache:getSprite(arg_10_2.img)
		
		if get_cocos_refid(var_10_2) then
			if arg_10_2.fill then
				local var_10_3
				local var_10_4
				local var_10_5 = var_10_2:getContentSize()
				
				if type(arg_10_2.fill) == "string" then
					if string.starts(arg_10_2.fill, "ver") then
						local var_10_6 = var_10_5.height / var_10_5.width
						
						var_10_4 = VIEW_HEIGHT / var_10_5.height
						var_10_3 = var_10_4 * var_10_6
					elseif string.starts(arg_10_2.fill, "hor") then
						local var_10_7 = var_10_5.width / var_10_5.height
						
						var_10_3 = VIEW_WIDTH / var_10_5.width
						var_10_4 = var_10_3 * var_10_7
					end
				else
					var_10_3 = VIEW_WIDTH / var_10_5.width
					var_10_4 = VIEW_HEIGHT / var_10_5.height
				end
				
				var_10_3 = math.is_nan_or_inf(var_10_3) and 1 or var_10_3
				var_10_4 = math.is_nan_or_inf(var_10_4) and 1 or var_10_4
				
				var_10_2:setScale(var_10_3, var_10_4)
			end
			
			if arg_10_2.img_anchor_x or arg_10_2.img_anchor_y then
				var_10_2:setAnchorPoint(arg_10_2.img_anchor_x or 0.5, arg_10_2.img_anchor_y or 0.5)
			end
			
			var_10_0:getChildByName("n_bg"):addChild(var_10_2)
			arg_10_1:addChild(var_10_0)
			
			if arg_10_2.map then
				local var_10_8 = cc.LayerColor:create(cc.c3b(0, 0, 0))
				
				var_10_8:setContentSize(VIEW_WIDTH, VIEW_HEIGHT)
				var_10_8:setLocalZOrder(-1)
				arg_10_1:addChild(var_10_8)
				var_10_8:setName("@curtain")
			end
			
			return var_10_0
		end
	end
end

function SubstoryUIUtil.addMapFromData(arg_11_0, arg_11_1, arg_11_2)
	if arg_11_2.map then
		local var_11_0, var_11_1 = FIELD_NEW:create(arg_11_2.map)
		
		var_11_1:setViewPortPosition(arg_11_2.scroll_x or 0, arg_11_2.scroll_y or 0)
		var_11_1:updateViewport()
		var_11_0:setPositionY(-360)
		var_11_0:setLocalZOrder(-1)
		var_11_0:setName("@field_bg")
		arg_11_1:addChild(var_11_0)
	end
end

function SubstoryUIUtil.addSpineObjectFromData(arg_12_0, arg_12_1, arg_12_2)
	if arg_12_2.scsp then
		scsp = CACHE:getEffect(arg_12_2.scsp)
		
		if get_cocos_refid(scsp) then
			scsp:setScale(arg_12_2.scsp_scale or 1)
			scsp:setAnimation(0, arg_12_2.scsp_ani or "idle", arg_12_2.loop)
			arg_12_1:addChild(scsp)
		end
	end
end

function SubstoryUIUtil.addEffectFromData(arg_13_0, arg_13_1, arg_13_2)
	if arg_13_2.effect then
		EffectManager:Play({
			fn = arg_13_2.effect,
			layer = arg_13_1,
			x = arg_13_2.effect_x or 0,
			y = arg_13_2.effect_y or 0,
			z = arg_13_2.effect_z or 0
		})
	end
end

function SubstoryUIUtil.addPortraitFromData(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	if arg_14_2.portrait then
		local var_14_0 = UIUtil:getPortraitAni(arg_14_2.portrait, {
			pin_sprite_position_y = arg_14_2.portrait_pin
		})
		
		var_14_0:setScaleX(arg_14_2.portrait_flip and -var_14_0:getScaleX() or var_14_0:getScaleX())
		arg_14_1:addChild(var_14_0)
		
		if arg_14_3 and arg_14_3.face then
			UIUtil:setPortraitFace(var_14_0, arg_14_3.face)
		end
	end
end

function SubstoryUIUtil.updateQuestUI(arg_15_0, arg_15_1, arg_15_2)
	local var_15_0 = arg_15_1:getChildByName("n_quest_progress")
	
	if not get_cocos_refid(var_15_0) then
		return 
	end
	
	local var_15_1 = SubstoryManager:getQuestCount()
	local var_15_2 = SubstoryManager:getClearQuestCount()
	
	var_15_0:setVisible(var_15_1 > 0)
	
	if arg_15_2 then
		var_15_2 = var_15_1
	end
	
	local var_15_3 = var_15_0:getChildByName("progress_bar")
	
	if_set_percent(var_15_0, "progress_bar", var_15_2 / var_15_1)
	if_set(var_15_0, "t_percent", math.floor(var_15_2 / var_15_1 * 100) .. "%")
end

function SubstoryUIUtil.updateAchieveUI(arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = arg_16_1:getChildByName("n_achieve_progress")
	
	if not get_cocos_refid(var_16_0) then
		return 
	end
	
	local var_16_1, var_16_2 = SubstoryManager:getNotIncludeHideAchieveDatas({
		hide_not_include = true
	})
	
	var_16_0:setVisible(var_16_1 > 0)
	
	if arg_16_2 then
		var_16_2 = var_16_1
	end
	
	if_set_percent(var_16_0, "progress_bar", var_16_2 / var_16_1)
	if_set(var_16_0, "t_percent", math.floor(var_16_2 / var_16_1 * 100) .. "%")
	arg_16_0:updateNotifier(arg_16_1)
end

function SubstoryUIUtil.updateContents2Noti(arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	local var_17_0 = arg_17_1:getChildByName("btn_contents2")
	
	if not get_cocos_refid(var_17_0) or not arg_17_2 or not arg_17_3 then
		return 
	end
	
	local var_17_1
	
	if arg_17_3 == "content_travel" and not var_17_0.is_locked then
		var_17_1 = SubStoryTravel:canReceiveRewardQuestNoti(arg_17_2)
	elseif arg_17_3 == "content_village" then
		var_17_1 = ChristmasUtil:canRecieveTreeReward(arg_17_2) or ChristmasUtil:can_building_upgradable(arg_17_2) or ChristmasUtil:canRecieveCraftReward(arg_17_2)
	elseif arg_17_3 == "content_board" then
		var_17_1 = SubStoryControlBoardUtil:getRewardNoti(arg_17_2)
	end
	
	if_set_visible(var_17_0, "icon_noti", var_17_1)
end

function SubstoryUIUtil.updateNotifier(arg_18_0, arg_18_1)
	local var_18_0 = arg_18_1:getChildByName("btn_achieve")
	local var_18_1 = arg_18_0:isAchieveNotifier()
	
	if_set_visible(var_18_0, "icon_achieve_noti", var_18_1)
end

function SubstoryUIUtil.isAchieveNotifier(arg_19_0)
	local var_19_0 = SubstoryManager:getInfo()
	local var_19_1 = var_19_0.id
	local var_19_2 = Account:getSubStoryAchievementBySubstoryID(var_19_1)
	local var_19_3 = false
	
	for iter_19_0, iter_19_1 in pairs(var_19_2) do
		if not DB("substory_achievement", iter_19_0, "hide") and iter_19_1.state == SUBSTORY_QUEST_STATE.CLEAR then
			var_19_3 = true
			
			break
		end
	end
	
	if not var_19_3 then
		local var_19_4 = var_19_0.condition_state_id
		
		if var_19_4 then
			local var_19_5 = ConditionContentsState:getClearData(var_19_4) or {}
			
			if Account:getSubStory(var_19_1).ach_reward_state == 1 and var_19_5.is_cleared then
				var_19_3 = true
			end
		end
	end
	
	return var_19_3
end

function SubstoryUIUtil.updateLobbyRightBaseInfo(arg_20_0, arg_20_1, arg_20_2)
	local var_20_0 = SubStoryUtil:getEventState(arg_20_2.start_time, arg_20_2.end_time)
	local var_20_1 = arg_20_2.start_time
	local var_20_2 = arg_20_2.end_time
	local var_20_3
	local var_20_4
	local var_20_5 = arg_20_1:getChildByName("top_pivot")
	local var_20_6 = not arg_20_2.achieve_flag and not arg_20_2.quest_flag
	
	if not SubstoryManager:isSystemSubStory() then
		if_set(arg_20_1, "label_period", T("ui_dungeon_story_period", timeToStringDef({
			preceding_with_zeros = true,
			start_time = var_20_1,
			end_time = var_20_2
		})))
	else
		if_set_visible(arg_20_1, "n_period", false)
	end
	
	if var_20_0 == SUBSTORY_CONSTANTS.STATE_OPEN then
		if SubstoryManager:isEpilogueUI(arg_20_2) then
			if_set_visible(arg_20_1, "ON", false)
			if_set_visible(arg_20_1, "OFF", true)
			if_set_visible(arg_20_1, "n_period", false)
			
			var_20_3 = arg_20_1:getChildByName("OFF")
			
			if get_cocos_refid(var_20_3) then
				arg_20_0:setLiteUI(arg_20_2, var_20_3)
			end
		else
			if_set_visible(arg_20_1, "ON", true)
			if_set_visible(arg_20_1, "OFF", false)
			
			var_20_3 = arg_20_1:getChildByName("ON")
			var_20_4 = arg_20_1:getChildByName("list_view")
		end
	elseif var_20_0 == SUBSTORY_CONSTANTS.STATE_CLOSE_SOON or var_20_0 == SUBSTORY_CONSTANTS.STATE_CLOSE then
		if_set_visible(arg_20_1, "ON", false)
		if_set_visible(arg_20_1, "OFF", true)
		
		var_20_3 = arg_20_1:getChildByName("OFF")
		
		if_set_opacity(arg_20_1, "btn_go", 100)
	else
		if_set_visible(arg_20_1, "LEFT", true)
		if_set_visible(arg_20_1, "ON", false)
		if_set_visible(arg_20_1, "OFF", true)
		if_set_visible(arg_20_1, "btn_go", false)
		
		if get_cocos_refid(var_20_5) then
			var_20_5:setPositionY(var_20_5:getPositionY() + 40)
		end
		
		var_20_3 = arg_20_1:getChildByName("OFF")
		
		if get_cocos_refid(var_20_3) then
			arg_20_0:setLiteUI(arg_20_2, var_20_3)
		end
	end
	
	if get_cocos_refid(var_20_3) and var_20_6 then
		if_set_visible(arg_20_1, "n_progress", false)
		var_20_3:setPositionY(var_20_5:getPositionY())
	end
	
	local var_20_7 = arg_20_1:getChildByName("n_line")
	local var_20_8 = arg_20_1:getChildByName("n_progress_line_pos1")
	local var_20_9 = arg_20_1:getChildByName("n_progress_line_pos2")
	
	if get_cocos_refid(var_20_7) and get_cocos_refid(var_20_8) and get_cocos_refid(var_20_9) then
		if arg_20_2.achieve_flag == nil or arg_20_2.achieve_flag ~= "y" or arg_20_2.quest_flag == nil or arg_20_2.quest_flag ~= "y" then
			var_20_7:setPosition(var_20_8:getPosition())
		else
			var_20_7:setPosition(var_20_9:getPosition())
		end
	end
	
	local var_20_10 = arg_20_1:getChildByName("n_core_reward")
	
	if get_cocos_refid(var_20_10) then
		local var_20_11 = {
			hero_multiply_scale = 1,
			artifact_multiply_scale = 0.65,
			multiply_scale = 0.9
		}
		local var_20_12 = SubstoryManager:setCoreRewardIcons(var_20_10, arg_20_2.id, var_20_11)
		
		var_20_10:setVisible(var_20_12 and #var_20_12 > 0)
		
		if var_20_12 == nil and get_cocos_refid(var_20_4) then
			var_20_4:setContentSize(var_20_4:getContentSize().width, var_20_4:getContentSize().height + 139)
		end
		
		local var_20_13 = var_20_10:getChildByName("btn_core_reward")
		
		var_20_13.popup_parent, var_20_13.substory_id = arg_20_1:getChildByName("n_reward_popup"), arg_20_2.id
	end
	
	local var_20_14 = SubstoryManager:getContents2CommonDB()
	local var_20_15 = arg_20_1:getChildByName("btn_contents2")
	
	if var_20_14 and var_20_14.enter_btn_hide_lobby ~= "y" and var_20_14.enter_btn_text and var_20_14.enter_btn_icon and get_cocos_refid(var_20_15) then
		if_set(var_20_15, "label", T(var_20_14.enter_btn_text))
		if_set_sprite(var_20_15, "icon", var_20_14.enter_btn_icon)
	end
	
	if arg_20_2.contents_type_2 and arg_20_2.contents_type_2 == SUBSTORY_CONTENTS_TYPE.INFERENCE and var_20_14 and var_20_14.rumble_show_btn == "y" then
		if_set(var_20_15, "label", T("rumble_enter_btn"))
		if_set_sprite(var_20_15, "icon", "img/icon_menu_rumble.png")
	end
	
	if var_20_14 and var_20_14.unlock_enter_btn_condition and not Account:isClearedSubStoryAchievement(var_20_14.unlock_enter_btn_condition) then
		if_set_opacity(var_20_15, nil, 76.5)
		
		var_20_15.is_locked = true
	end
	
	if get_cocos_refid(var_20_4) then
		if var_20_6 then
			local var_20_16 = var_20_4:getContentSize()
			
			var_20_4:setContentSize(var_20_16.width, var_20_16.height + var_20_5:getPositionY())
			var_20_4:setPositionY(var_20_4:getPositionY() - var_20_5:getPositionY())
		end
		
		local var_20_17 = GroupListView:bindControl(var_20_4)
		local var_20_18 = load_control("wnd/dungeon_story_title.csb")
		
		var_20_18:setPositionY(-8)
		
		local var_20_19 = {
			onUpdate = function(arg_21_0, arg_21_1, arg_21_2)
				local var_21_0 = string.split(arg_21_2, ",")
				local var_21_1 = false
				
				for iter_21_0 = 1, 3 do
					local var_21_2 = var_21_0[iter_21_0]
					local var_21_3, var_21_4 = DB("skill", tostring(var_21_2), {
						"name",
						"sk_icon"
					})
					
					if var_21_2 and var_21_2 == "substory_cs" then
						var_21_1 = true
					end
					
					local var_21_5 = iter_21_0
					
					if var_21_1 then
						var_21_5 = math.max(iter_21_0 - 1, 1)
					end
					
					if var_21_3 then
						if_set(arg_21_1, "label_stat" .. var_21_5, T(var_21_3))
					else
						if_set_visible(arg_21_1, "label_stat" .. var_21_5, false)
					end
					
					if var_21_4 then
						if string.find(var_21_4, "/") then
							if_set_sprite(arg_21_1, "icon_stat" .. var_21_5, var_21_4 .. ".png")
						else
							if_set_sprite(arg_21_1, "icon_stat" .. var_21_5, "skill/" .. var_21_4 .. ".png")
						end
						
						if_set_visible(arg_21_1, "icon_stat" .. var_21_5, true)
					else
						if_set_visible(arg_21_1, "icon_stat" .. var_21_5, false)
					end
				end
				
				if var_21_1 then
					local var_21_6 = arg_21_1:getChildByName("n_bauff_main")
					local var_21_7 = arg_21_1:getChildByName("n_buff")
					
					if var_21_6 and var_21_7 then
						var_21_6:setVisible(true)
						
						if not var_21_6.origin_x and not var_21_7.origin_x then
							var_21_6.origin_x = var_21_6:getPositionX()
							var_21_7.origin_x = var_21_7:getPositionX()
							
							var_21_6:setPositionX(var_21_6.origin_x + 106)
							var_21_7:setPositionX(var_21_7.origin_x + 106)
						end
						
						local var_21_8 = DB("cs", "substory_cs", "cs_effectexplain")
						
						if var_21_8 then
							WidgetUtils:setupTooltip({
								delay = 100,
								control = var_21_6:getChildByName("icon_buff_aura"),
								creator = function()
									return UIUtil:getSkillEffectTip(var_21_8)
								end
							})
						end
					end
				end
			end
		}
		local var_20_20 = SubstoryManager:getInfo() or {}
		local var_20_21 = var_20_20.powerup_hero_open_schedule
		local var_20_22 = var_20_20.powerup_hero_unkown_icon or "m0000"
		local var_20_23 = UIUtil:getRewardIcon("c", "c1001", {
			no_popup = true,
			name = false,
			scale = 0.9,
			no_grade = true
		})
		local var_20_24 = var_20_23:getContentSize()
		
		var_20_23:setAnchorPoint(0, 0)
		var_20_23:setContentSize(var_20_24.width * 0.9, var_20_24.height)
		var_20_23:setTouchEnabled(true)
		
		local var_20_25 = {
			onUpdate = function(arg_23_0, arg_23_1, arg_23_2)
				local var_23_0 = false
				
				if DB("character", arg_23_2, {
					"id"
				}) == nil then
					var_23_0 = true
				end
				
				if not var_23_0 and (not var_20_21 or SubstoryManager:isHeroOpen(var_20_21, arg_23_2)) then
					replaceSprite(arg_23_1, "face", "face/" .. arg_23_2 .. "_s.png")
					WidgetUtils:setupPopup({
						control = arg_23_1,
						creator = function()
							return UIUtil:getCharacterPopup({
								grade = 6,
								lv = 60,
								hide_star = true,
								code = arg_23_2
							})
						end
					})
				else
					replaceSprite(arg_23_1, "face", "face/" .. var_20_22 .. "_s.png")
				end
				
				WidgetUtils:setupPopup({
					control = arg_23_1,
					creator = function()
						balloon_message_with_sound("before_schedule_open")
					end
				})
			end
		}
		
		var_20_17:setTouchEnabled(true)
		var_20_17:setRenderer(var_20_18, var_20_23, var_20_19, var_20_25)
		var_20_17:removeAllChildren()
		
		local var_20_26
		local var_20_27 = {}
		
		for iter_20_0 = 0, 2 do
			local var_20_28 = arg_20_2["powerup_hero" .. iter_20_0]
			local var_20_29 = arg_20_2["powerup_cs" .. iter_20_0]
			local var_20_30 = {}
			
			if var_20_28 then
				for iter_20_1, iter_20_2 in pairs(string.split(var_20_28, ",")) do
					if not is_enhanced_mer(iter_20_2) then
						table.insert(var_20_30, iter_20_2)
					end
				end
			end
			
			if iter_20_0 == 0 and var_20_29 and string.find(var_20_29, "substory_cs") then
				var_20_26 = true
			end
			
			table.insert(var_20_27, {
				cs = var_20_29,
				items = var_20_30
			})
		end
		
		if not table.empty(var_20_27) then
			if var_20_26 then
				local var_20_31 = {}
				
				if var_20_27[1] and var_20_27[2] then
					local var_20_32 = var_20_27[1]
					local var_20_33 = var_20_27[2]
					
					if var_20_32.cs and var_20_33.cs and var_20_32.items and var_20_33.items then
						local var_20_34 = var_20_32.cs .. "," .. var_20_33.cs
						local var_20_35 = {}
						
						for iter_20_3, iter_20_4 in pairs(var_20_32.items) do
							table.insert(var_20_35, iter_20_4)
						end
						
						for iter_20_5, iter_20_6 in pairs(var_20_33.items) do
							if not table.find(var_20_35, iter_20_6) then
								table.insert(var_20_35, iter_20_6)
							end
						end
						
						table.insert(var_20_31, {
							cs = var_20_34,
							items = var_20_35
						})
						
						for iter_20_7, iter_20_8 in pairs(var_20_27) do
							if iter_20_7 >= 3 then
								table.insert(var_20_31, iter_20_8)
							end
						end
						
						var_20_27 = var_20_31
					end
				end
			end
			
			for iter_20_9, iter_20_10 in pairs(var_20_27) do
				var_20_17:addGroup(iter_20_10.cs, iter_20_10.items)
			end
		end
	end
	
	local var_20_36 = (SubstoryManager:getInfo() or {}).powerup_desc or false
	
	if_set_visible(arg_20_1, "n_hero_info", var_20_36)
	
	for iter_20_11 = 1, 2 do
		if_set_visible(arg_20_1, string.format("n_buff_list%02d", iter_20_11), false)
	end
	
	local var_20_37 = arg_20_1:getChildByName("n_achieve_progress")
	local var_20_38 = arg_20_1:getChildByName("n_quest_progress")
	
	if not var_20_6 and not arg_20_2.quest_flag then
		local var_20_39 = var_20_38:getPositionX()
		local var_20_40 = var_20_38:getPositionY()
		
		var_20_37:setPosition(var_20_39, var_20_40)
		var_20_38:setVisible(false)
	end
	
	if not var_20_6 and not arg_20_2.achieve_flag then
		var_20_37:setVisible(false)
	end
	
	for iter_20_12, iter_20_13 in pairs({
		var_20_38,
		var_20_37
	}) do
		local var_20_41 = iter_20_13
		
		if get_cocos_refid(var_20_41) then
			if_set_percent(var_20_41, "progress_bar", 0)
			if_set(var_20_41, "t_percent", "0%")
		end
	end
end

function SubstoryUIUtil.setLiteUI(arg_26_0, arg_26_1, arg_26_2)
	local var_26_0 = "pre_sub_story_title"
	local var_26_1 = "pre_sub_story_desc"
	local var_26_2 = 0
	local var_26_3 = 0
	local var_26_4 = 0
	local var_26_5 = 0
	local var_26_6 = SubstoryUIUtil:getBGInfo(arg_26_1.background_summary, arg_26_1.id)
	
	if var_26_6.pre_title then
		local var_26_7 = var_26_6.pre_title
		
		var_26_0 = var_26_7.txt or var_26_0
		var_26_2 = var_26_7.offset_x or var_26_2
		var_26_3 = var_26_7.offset_y or var_26_3
	end
	
	if var_26_6.pre_desc then
		local var_26_8 = var_26_6.pre_desc
		
		var_26_1 = var_26_8.txt or var_26_1
		var_26_4 = var_26_8.offset_x or var_26_4
		var_26_5 = var_26_8.offset_y or var_26_5
	end
	
	local var_26_9 = arg_26_2:getChildByName("label_title")
	
	if get_cocos_refid(var_26_9) then
		if_set(arg_26_2, "label_title", T(var_26_0))
		var_26_9:setPosition(var_26_9:getPositionX() + var_26_2, var_26_9:getPositionY() + var_26_3)
	end
	
	local var_26_10 = arg_26_2:getChildByName("label")
	
	if get_cocos_refid(var_26_10) then
		if_set(arg_26_2, "label", T(var_26_1))
		var_26_10:setPosition(var_26_10:getPositionX() + var_26_4, var_26_10:getPositionY() + var_26_5)
	end
end

function SubstoryUIUtil.createBanner(arg_27_0, arg_27_1, arg_27_2, arg_27_3)
	if not arg_27_1 or not arg_27_2 then
		return 
	end
	
	local var_27_0 = load_control("wnd/story_banner.csb")
	local var_27_1 = var_27_0:getChildByName("bi_img")
	local var_27_2 = var_27_0:getChildByName("banner_bg")
	
	if not string.starts(arg_27_2, "banner/") then
		if_set_sprite(var_27_1, nil, "banner/" .. (arg_27_2 or "banner_sample") .. ".png")
	else
		if_set_sprite(var_27_1, nil, arg_27_2)
	end
	
	if not string.starts(arg_27_1, "banner/") then
		if_set_sprite(var_27_2, nil, "banner/" .. (arg_27_1 or "banner_sample") .. ".png")
	else
		if_set_sprite(var_27_2, nil, arg_27_1)
	end
	
	if_set_visible(var_27_1, nil, arg_27_3)
	
	if arg_27_3 then
		var_27_1:setAnchorPoint(0, 0)
		var_27_1:setPositionY(arg_27_3.y or 0)
		var_27_1:setPositionX(arg_27_3.x or 0)
	end
	
	return var_27_0
end

function SubstoryUIUtil.onBtnVideo(arg_28_0, arg_28_1)
	if arg_28_1.link then
		Stove:openVideoPage(arg_28_1.link)
	end
end
