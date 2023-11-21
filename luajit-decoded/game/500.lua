Profile = {}

function HANDLER.user_profile(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_close" then
		Profile:close()
	elseif arg_1_1 == "btn_support" then
		SceneManager:nextScene("unit_ui", {
			mode = "Support"
		})
	elseif arg_1_1 == "btn_nickname" then
		UserNickName:popupNickname()
	elseif arg_1_1 == "btn_message" then
		Profile:showIntroEditPopup()
	elseif arg_1_1 == "btn_hero" then
		SceneManager:nextScene("unit_ui", {
			mode = "Detail",
			detail_mode = "Growth",
			unit = Account:getMainUnit()
		})
	elseif arg_1_1 == "btn_frame" then
		UserBorderChange:show()
	elseif string.starts(arg_1_1, "btn_off") or string.starts(arg_1_1, "btn_on") then
		local var_1_0
		local var_1_1 = 0
		
		if string.starts(arg_1_1, "btn_off") then
			var_1_1 = string.len("btn_off_")
		elseif string.starts(arg_1_1, "btn_on") then
			var_1_1 = string.len("btn_on_")
		end
		
		if var_1_1 ~= 0 then
			var_1_0 = string.sub(arg_1_1, var_1_1 + 1, -1)
		end
		
		Profile:toggleBlind(var_1_0)
	elseif arg_1_1 == "btn_custom" then
		Profile:openProfileCardList()
	end
end

function MsgHandler.set_blind(arg_2_0)
	if arg_2_0 and arg_2_0.res and arg_2_0.res == "ok" then
		Account:setUserOption(arg_2_0.user_opt)
		
		if UIAction:Find("block") then
			UIAction:Remove("block")
		end
	end
end

function MsgHandler.set_intro(arg_3_0)
	Profile:setIntroMsg(arg_3_0.res, arg_3_0.intro)
	Friend:setIntroUI()
	Profile:updateIntro()
end

function ErrHandler.set_intro(arg_4_0, arg_4_1, arg_4_2)
	if not arg_4_1 then
		return 
	end
	
	balloon_message_with_sound("intro." .. arg_4_1)
end

function HANDLER.frame_change_popup(arg_5_0, arg_5_1)
	if arg_5_1 == "btn_cancel" then
		BackButtonManager:pop("UserBorderChange")
		UserBorderChange:hide(arg_5_0:getParent())
	end
end

function MsgHandler.set_main_border(arg_6_0)
	Account:setBorderCode(arg_6_0.border_code)
	Profile:updateBorder()
	LuaEventDispatcher:dispatchEvent("change_border", {
		border_code = arg_6_0.border_code
	})
	
	if Friend and SceneManager:getCurrentSceneName() == "friend" then
		Friend:updateUserIcon()
	end
	
	if TopBarNew then
		TopBarNew:changeUnitFrame()
	end
end

function Profile.open(arg_7_0, arg_7_1)
	arg_7_1 = arg_7_1 or {}
	
	if arg_7_0.vars and get_cocos_refid(arg_7_0.vars.wnd) then
		arg_7_0:close()
	end
	
	arg_7_0.vars = {}
	arg_7_0.vars.wnd = load_dlg(arg_7_1.wnd or "user_profile", true, "wnd", function()
		arg_7_0:close()
	end)
	
	SceneManager:getRunningPopupScene():addChild(arg_7_0.vars.wnd)
	
	if arg_7_1.open_profile_card_list then
		arg_7_0:openProfileCardList(arg_7_1)
	end
	
	arg_7_0:updateProfile()
	SoundEngine:play("event:/ui/popup/tap")
	TutorialGuide:procGuide()
	TutorialNotice:update("user_profile")
end

function Profile.close(arg_9_0)
	if not arg_9_0.vars or not get_cocos_refid(arg_9_0.vars.wnd) then
		return 
	end
	
	local var_9_0 = BackButtonManager:getTopInfo()
	
	if var_9_0 and var_9_0.dlg and var_9_0.dlg ~= arg_9_0.vars.wnd then
		return 
	end
	
	BackButtonManager:pop({
		id = "user_profile",
		dlg = arg_9_0.vars.wnd
	})
	arg_9_0.vars.wnd:removeFromParent()
	
	arg_9_0.vars.wnd = nil
	arg_9_0.vars = nil
end

function Profile.isVisible(arg_10_0)
	return arg_10_0.vars and get_cocos_refid(arg_10_0.vars.wnd)
end

function Profile.updateProfile(arg_11_0)
	if not arg_11_0.vars or not get_cocos_refid(arg_11_0.vars.wnd) then
		return 
	end
	
	arg_11_0:updateAccount()
	arg_11_0:updateArena()
	arg_11_0:updateSupportTeam()
	arg_11_0:updateIntro()
	arg_11_0:updateProfileCard()
	arg_11_0:updateButtons()
	arg_11_0:updateFrameNotify()
end

function Profile.updateFrameNotify(arg_12_0)
	if arg_12_0.vars and get_cocos_refid(arg_12_0.vars.wnd) then
		local var_12_0 = arg_12_0.vars.wnd:getChildByName("btn_frame")
		
		if_set_visible(var_12_0, "noti", Account:checkNewBorder())
	end
end

function Profile.updateAccount(arg_13_0)
	if not arg_13_0.vars or not get_cocos_refid(arg_13_0.vars.wnd) then
		return 
	end
	
	local var_13_0 = Account:getMainUnitCode()
	local var_13_1 = arg_13_0.vars.wnd:getChildByName("n_face")
	
	UIUtil:getUserIcon(var_13_0, {
		no_popup = true,
		name = false,
		no_role = true,
		no_lv = true,
		scale = 1,
		no_grade = true,
		parent = var_13_1,
		border_code = Account:getBorderCode()
	}):setName("@user_icon")
	
	local var_13_2 = arg_13_0.vars.wnd:getChildByName("n_my")
	
	if get_cocos_refid(var_13_2) then
		local var_13_3
		
		if Login:getRegion() then
			var_13_3 = T(Login:getRegion() .. "_server") .. " | "
		end
		
		if AccountData.user_number then
			var_13_3 = var_13_3 .. tostring(AccountData.user_number)
		end
		
		if var_13_3 then
			if_set(var_13_2, "txt_server", var_13_3)
		end
		
		local var_13_4 = Account:getName(true)
		
		if_set(var_13_2, "txt_name", var_13_4)
		UIUtil:setLevel(var_13_2:getChildByName("n_lv"), AccountData.level, MAX_ACCOUNT_LEVEL, 3, false, nil, 18)
		if_set(var_13_2, "txt_friends", T("ui_friends_user_friends", {
			num = to_n(AccountData.friend_count),
			max = Friend:friend_max(AccountData.level)
		}))
		
		local var_13_5 = Account:checkNameChanged()
		local var_13_6 = arg_13_0.vars.wnd:getChildByName("btn_nickname")
		
		if get_cocos_refid(var_13_6) then
			var_13_6:setVisible(not var_13_5)
			if_set_visible(var_13_6, "noti", not var_13_5)
		end
		
		if var_13_5 then
			var_13_2:setPositionY(var_13_2:getPositionY() - 29)
		end
	end
	
	local var_13_7 = arg_13_0.vars.wnd:getChildByName("n_clan")
	
	if get_cocos_refid(var_13_7) then
		local var_13_8 = Account:getClanId()
		
		if_set_visible(var_13_7, "n_belong", var_13_8)
		if_set_visible(var_13_7, "n_none", not var_13_8)
		
		if var_13_8 then
			local var_13_9 = Clan:getClanInfo()
			
			if var_13_9 then
				UIUtil:updateClanEmblem(var_13_7, var_13_9)
				
				local var_13_10 = var_13_7:getChildByName("txt_clan")
				
				if_set(var_13_10, nil, T("clan"))
				
				local var_13_11 = var_13_7:getChildByName("txt_clan_name")
				
				UIUtil:updateTextWrapMode(var_13_11, var_13_9.name)
				if_set(var_13_11, nil, var_13_9.name)
			end
		end
	end
end

function Profile.updateArena(arg_14_0)
	if not arg_14_0.vars or not get_cocos_refid(arg_14_0.vars.wnd) then
		return 
	end
	
	local var_14_0 = Account:getUserOption()
	local var_14_1 = arg_14_0.vars.wnd:getChildByName("n_arena_season")
	
	if get_cocos_refid(var_14_1) then
		local var_14_2 = getExtractedUserOption(var_14_0, 1) == 3
		
		if_set_visible(var_14_1, "btn_off_season", not var_14_2)
		if_set_visible(var_14_1, "btn_on_season", var_14_2)
		
		local var_14_3 = var_14_1:getChildByName("n_pvp")
		
		if get_cocos_refid(var_14_3) then
			local var_14_4
			local var_14_5
			local var_14_6 = AccountData.pvp_info
			
			if_set_visible(var_14_3, "n_normal", false)
			if_set_visible(var_14_3, "n_placement", false)
			
			if var_14_6 then
				if_set_visible(var_14_3, "n_normal", true)
				
				local var_14_7 = var_14_3:getChildByName("n_normal")
				
				var_14_5 = var_14_7:getChildByName("icon_emblem")
				
				local var_14_8, var_14_9 = DB("pvp_sa", AccountData.pvp_info.league, {
					"name",
					"emblem"
				})
				
				if_set(var_14_7, "txt_arena", T("arena_a_name"))
				SpriteCache:resetSprite(var_14_5, "emblem/" .. var_14_9 .. ".png")
				if_set(var_14_7, "txt_league", T(var_14_8))
			else
				if_set_visible(var_14_3, "n_placement", true)
				
				local var_14_10 = var_14_3:getChildByName("n_placement")
				
				var_14_5 = var_14_10:getChildByName("icon_emblem")
				
				if_set(var_14_10, "txt_arena", T("arena_a_name"))
			end
			
			if_set_opacity(var_14_5, nil, var_14_2 and 76.5 or 255)
		end
		
		local var_14_11 = var_14_1:getChildByName("n_pvplive")
		
		if get_cocos_refid(var_14_11) then
			local var_14_12
			local var_14_13
			local var_14_14 = AccountData.world_pvp_league
			
			if_set_visible(var_14_11, "n_normal", false)
			if_set_visible(var_14_11, "n_placement", false)
			
			if var_14_14 then
				if var_14_14 == "draft" then
					if_set_visible(var_14_11, "n_placement", true)
					
					local var_14_15 = var_14_11:getChildByName("n_placement")
					
					var_14_13 = var_14_15:getChildByName("icon_emblem")
					
					SpriteCache:resetSprite(var_14_13, "emblem/" .. ARENA_UNRANK_ICON)
					if_set(var_14_15, "txt_arena", T("arena_wa_name"))
					if_set(var_14_15, "txt_placement", T(ARENA_UNRANK_TEXT))
				else
					if_set_visible(var_14_11, "n_normal", true)
					
					local var_14_16 = var_14_11:getChildByName("n_normal")
					
					var_14_13 = var_14_16:getChildByName("icon_emblem")
					
					local var_14_17, var_14_18 = getArenaNetRankInfo(nil, var_14_14)
					
					if var_14_17 and var_14_18 then
						SpriteCache:resetSprite(var_14_13, "emblem/" .. var_14_18 .. ".png")
						if_set(var_14_16, "txt_pvplive", T(var_14_17))
					else
						SpriteCache:resetSprite(var_14_13, "emblem/" .. ARENA_UNRANK_ICON)
						if_set(var_14_16, "txt_pvplive", "")
					end
				end
			else
				if_set_visible(var_14_11, "n_placement", true)
				
				local var_14_19 = var_14_11:getChildByName("n_placement")
				
				var_14_13 = var_14_19:getChildByName("icon_emblem")
				
				SpriteCache:resetSprite(var_14_13, "emblem/" .. ARENA_UNRANK_ICON)
				if_set(var_14_19, "txt_arena", T("arena_wa_name"))
				if_set(var_14_19, "txt_placement", T(ARENA_UNRANK_TEXT))
			end
			
			if_set_opacity(var_14_13, nil, var_14_2 and 76.5 or 255)
		end
	end
	
	local var_14_20 = arg_14_0.vars.wnd:getChildByName("n_arena_score")
	
	if get_cocos_refid(var_14_20) then
		local var_14_21 = getExtractedUserOption(var_14_0, 2) == 3
		
		if_set_visible(var_14_20, "btn_off_score", not var_14_21)
		if_set_visible(var_14_20, "btn_on_score", var_14_21)
		
		local var_14_22 = var_14_20:getChildByName("n_pvp")
		
		if get_cocos_refid(var_14_22) then
			local var_14_23
			local var_14_24
			local var_14_25 = AccountData.max_pvp_league
			
			if_set_visible(var_14_22, "n_normal", false)
			if_set_visible(var_14_22, "n_placement", false)
			
			if var_14_25 then
				if_set_visible(var_14_22, "n_normal", true)
				
				local var_14_26 = var_14_22:getChildByName("n_normal")
				
				var_14_24 = var_14_26:getChildByName("icon_emblem")
				
				local var_14_27, var_14_28 = DB("pvp_sa", var_14_25, {
					"name",
					"emblem"
				})
				
				if_set(var_14_26, "txt_arena", T("arena_a_name"))
				SpriteCache:resetSprite(var_14_24, "emblem/" .. var_14_28 .. ".png")
				if_set(var_14_26, "txt_league", T(var_14_27))
			else
				if_set_visible(var_14_22, "n_placement", true)
				
				local var_14_29 = var_14_22:getChildByName("n_placement")
				
				var_14_24 = var_14_29:getChildByName("icon_emblem")
				
				local var_14_30 = AccountData.pvp_info
				
				if var_14_30 then
					local var_14_31, var_14_32 = DB("pvp_sa", var_14_30.league, {
						"name",
						"emblem"
					})
					
					if_set(var_14_29, "txt_arena", T("arena_a_name"))
					SpriteCache:resetSprite(var_14_24, "emblem/" .. var_14_32 .. ".png")
					if_set(var_14_29, "txt_placement", T(var_14_31))
				else
					if_set(var_14_29, "txt_arena", T("arena_a_name"))
					if_set(var_14_29, "txt_placement", T("pvp_sa_name_bronze_5"))
				end
			end
			
			if_set_opacity(var_14_24, nil, var_14_21 and 76.5 or 255)
		end
		
		local var_14_33 = var_14_20:getChildByName("n_pvplive")
		
		if get_cocos_refid(var_14_33) then
			local var_14_34
			local var_14_35
			local var_14_36 = AccountData.max_rta_league
			
			if var_14_36 then
				if_set_visible(var_14_33, "n_normal", true)
				
				local var_14_37 = var_14_33:getChildByName("n_normal")
				
				var_14_35 = var_14_37:getChildByName("icon_emblem")
				
				local var_14_38, var_14_39 = DB("pvp_rta", var_14_36, {
					"league_name",
					"emblem"
				})
				
				SpriteCache:resetSprite(var_14_35, "emblem/" .. var_14_39 .. ".png")
				if_set(var_14_37, "txt_pvplive", T(var_14_38))
			else
				if_set_visible(var_14_33, "n_placement", true)
				
				local var_14_40 = var_14_33:getChildByName("n_placement")
				
				var_14_35 = var_14_40:getChildByName("icon_emblem")
				
				SpriteCache:resetSprite(var_14_35, "emblem/" .. ARENA_UNRANK_ICON)
				if_set(var_14_40, "txt_arena", T("arena_wa_name"))
				if_set(var_14_40, "txt_placement", T(ARENA_UNRANK_TEXT))
			end
			
			if_set_opacity(var_14_35, nil, var_14_21 and 76.5 or 255)
		end
	end
end

function Profile.updateSupportTeam(arg_15_0)
	if not arg_15_0.vars or not get_cocos_refid(arg_15_0.vars.wnd) then
		return 
	end
	
	local var_15_0 = arg_15_0.vars.wnd:getChildByName("n_support")
	local var_15_1
	
	if get_cocos_refid(var_15_0) then
		var_15_1 = Account:getTeam(12)
		
		for iter_15_0 = 1, 7 do
			local var_15_2 = var_15_0:getChildByName("n_pos" .. iter_15_0)
			local var_15_3 = var_15_1[iter_15_0]
			
			if var_15_3 then
				var_15_2:setVisible(true)
				
				local var_15_4 = Account:getUnit(var_15_3:getUID())
				
				if var_15_4 ~= nil then
					local var_15_5 = {
						name = false,
						mob_icon2 = true,
						no_popup = false,
						no_lv = false,
						no_grade = false,
						parent = var_15_2,
						role = iter_15_0 ~= 0,
						leader_role = iter_15_0 == 1,
						border_code = var_15_4.border_code,
						zodiac = var_15_4:getZodiacGrade(),
						content_size = {
							width = 55,
							height = 55
						},
						s = var_15_3.inst.skill_lv
					}
					
					var_15_5.no_power = true
					var_15_5.no_devote = true
					
					UIUtil:getUserIcon(var_15_4, var_15_5)
				end
			else
				if_set_visible(var_15_0, "icon_" .. iter_15_0, not var_15_1[iter_15_0])
			end
		end
	end
end

function Profile.updateIntro(arg_16_0)
	if not arg_16_0.vars or not get_cocos_refid(arg_16_0.vars.wnd) then
		return 
	end
	
	local var_16_0 = AccountData.intro_msg or T("friend.default_intro_msg")
	local var_16_1 = arg_16_0.vars.wnd:getChildByName("btn_message")
	
	if get_cocos_refid(var_16_1) then
		local var_16_2 = var_16_1:getChildByName("txt_message")
		
		if get_cocos_refid(var_16_2) then
			if_set(var_16_2, nil, var_16_0)
			UIUtil:updateTextWrapMode(var_16_2, var_16_0, 20)
		end
	end
end

function Profile.updateProfileCard(arg_17_0)
	if not arg_17_0.vars or not get_cocos_refid(arg_17_0.vars.wnd) then
		return 
	end
	
	local var_17_0 = arg_17_0.vars.wnd:getChildByName("n_custom_card")
	
	if get_cocos_refid(var_17_0) then
		var_17_0:removeAllChildren()
		
		local var_17_1
		local var_17_2 = Account:getMainProfileCard()
		
		if table.empty(var_17_2) then
			local var_17_3
			local var_17_4
			local var_17_5 = Account:getMainUnit()
			
			if var_17_5 then
				var_17_3 = var_17_5:getDisplayCode()
				var_17_4 = var_17_5:getUnitOptionValue("face_num")
			end
			
			var_17_1 = CustomProfileCard:create({
				is_default = true,
				leader_code = var_17_3,
				face_id = var_17_4
			})
		elseif var_17_2.data then
			var_17_1 = CustomProfileCard:create({
				card_data = var_17_2.data
			})
		end
		
		if not var_17_1 then
			return 
		end
		
		local var_17_6 = var_17_1:getWnd()
		
		if get_cocos_refid(var_17_6) then
			var_17_0:addChild(var_17_6)
		end
	end
end

function Profile.updateButtons(arg_18_0)
	if not arg_18_0.vars or not get_cocos_refid(arg_18_0.vars.wnd) then
		return 
	end
	
	if_set_visible(arg_18_0.vars.wnd, "n_btn", true)
	if_set_visible(arg_18_0.vars.wnd, "n_btn_zl", false)
	
	local var_18_0 = arg_18_0.vars.wnd:getChildByName("btn_custom")
	
	if get_cocos_refid(var_18_0) then
		if_set_visible(var_18_0, "noti", HiddenMission:isExistClearedMission(HIDDEN_MISSION_TYPE.CUSTOM_PROFILE))
		if_set_opacity(var_18_0, nil, Account:getProfileCardBanState() and 76.5 or 255)
	end
end

function Profile.toggleBlind(arg_19_0, arg_19_1)
	if not arg_19_0.vars or not get_cocos_refid(arg_19_0.vars.wnd) then
		return 
	end
	
	if arg_19_1 ~= "season" and arg_19_1 ~= "score" then
		return 
	end
	
	local var_19_0 = arg_19_0.vars.wnd:getChildByName("n_arena_" .. arg_19_1)
	
	if get_cocos_refid(var_19_0) then
		local var_19_1 = var_19_0:getChildByName("btn_on_" .. arg_19_1)
		local var_19_2 = var_19_0:getChildByName("btn_off_" .. arg_19_1)
		local var_19_3 = var_19_0:getChildByName("n_pvp")
		local var_19_4 = var_19_0:getChildByName("n_pvplive")
		
		if get_cocos_refid(var_19_1) and get_cocos_refid(var_19_2) and get_cocos_refid(var_19_3) and get_cocos_refid(var_19_4) then
			local var_19_5 = var_19_1:isVisible()
			local var_19_6 = {}
			
			table.insert(var_19_6, var_19_3)
			table.insert(var_19_6, var_19_4)
			
			local var_19_7 = {}
			
			table.insert(var_19_7, "n_normal")
			table.insert(var_19_7, "n_placement")
			
			for iter_19_0, iter_19_1 in pairs(var_19_6) do
				for iter_19_2, iter_19_3 in pairs(var_19_7) do
					local var_19_8 = iter_19_1:getChildByName(iter_19_3)
					
					if_set_opacity(var_19_8, "icon_emblem", var_19_5 and 255 or 76.5)
				end
			end
			
			var_19_1:setVisible(not var_19_1:isVisible())
			var_19_2:setVisible(not var_19_2:isVisible())
			
			local var_19_9 = var_19_5 and 2 or 3
			local var_19_10
			
			if arg_19_1 == "season" then
				var_19_10 = "pvp"
			elseif arg_19_1 == "score" then
				var_19_10 = "pvp_max"
			end
			
			query("set_blind", {
				type = var_19_10,
				blind = var_19_9
			})
			UIAction:Add(DELAY(5000), arg_19_0.vars.wnd, "block")
		end
	end
end

function Profile.showIntroEditPopup(arg_20_0)
	local function var_20_0()
		if arg_20_0.vars.noti_info.text == arg_20_0.vars.noti_info.prev_text then
			balloon_message_with_sound("no_change_text_intro")
			
			return 
		end
		
		local var_21_0 = arg_20_0.vars.noti_info.text
		local var_21_1 = string.trim(var_21_0)
		
		if var_21_1 == nil or utf8len(var_21_1) < 1 then
			balloon_message_with_sound("lack_intro_msg_length")
			
			return 
		end
		
		if check_abuse_filter(var_21_1, ABUSE_FILTER.CHAT) then
			balloon_message_with_sound("invalid_input_word")
			
			return 
		end
		
		arg_20_0.vars.noti_info.text = string.trim(arg_20_0.vars.noti_info.text or "")
		
		query("set_intro", {
			intro = arg_20_0.vars.noti_info.text or ""
		})
	end
	
	arg_20_0.vars.noti_info = {}
	arg_20_0.vars.noti_info.prev_text = Account:getIntroMsg() or T("friend.default_intro_msg")
	
	local var_20_1, var_20_2 = Dialog:openInputBox(arg_20_0, var_20_0, {
		max_limit = 50,
		info = arg_20_0.vars.noti_info
	})
	
	arg_20_0.vars.wnd:addChild(var_20_1)
end

function Profile.setIntroMsg(arg_22_0, arg_22_1, arg_22_2)
	if not arg_22_1 or arg_22_1 ~= "ok" then
		return 
	end
	
	Account:setIntroMsg(arg_22_2)
end

function Profile.openProfileCardList(arg_23_0, arg_23_1)
	if not arg_23_0:isVisible() then
		return 
	end
	
	arg_23_1 = arg_23_1 or {}
	
	local var_23_0, var_23_1 = Account:getProfileCardBanState()
	
	if var_23_0 then
		if var_23_1 then
			balloon_message_with_sound("msg_profile_ban_remain_time", {
				remain_time = sec_to_full_string(var_23_1, false, {
					count = 3
				})
			})
		else
			balloon_message_with_sound("msg_profile_ban_forever")
		end
		
		return 
	end
	
	local var_23_2 = "ProfileCardEdit.comp_stop_watching"
	
	if not Dialog:isSkip(var_23_2) and not arg_23_1.open_profile_card_list then
		Dialog:openDailySkipPopup(var_23_2, {
			add_pop_scene = true,
			use_single_label = true,
			title = "ui_profile_card_popup_title",
			hide_info = true,
			desc = "ui_profile_popup_warning_desc",
			func = function()
				if_set_opacity(arg_23_0.vars.wnd, "btn_custom", Account:getProfileCardBanState() and 76.5 or 255)
				
				if not CustomProfileCardList:getProfileCardList() then
					query("get_profile_card_list")
					
					return 
				end
				
				CustomProfileCardList:open()
			end
		})
		
		return 
	end
	
	if_set_opacity(arg_23_0.vars.wnd, "btn_custom", Account:getProfileCardBanState() and 76.5 or 255)
	
	if not CustomProfileCardList:getProfileCardList() then
		query("get_profile_card_list")
		
		return 
	end
	
	CustomProfileCardList:open()
end

function Profile.updateBorder(arg_25_0)
	if not arg_25_0.vars or not get_cocos_refid(arg_25_0.vars.wnd) then
		return 
	end
	
	local var_25_0 = Account:getMainUnitCode()
	local var_25_1 = arg_25_0.vars.wnd:getChildByName("n_face")
	
	var_25_1:removeChildByName("@user_icon")
	UIUtil:getUserIcon(var_25_0, {
		no_popup = true,
		name = false,
		no_role = true,
		no_lv = true,
		scale = 1,
		no_grade = true,
		parent = var_25_1,
		border_code = Account:getBorderCode()
	}):setName("@user_icon")
end

UserBorderChange = {}

copy_functions(ScrollView, UserBorderChange)

function UserBorderChange.show(arg_26_0, arg_26_1)
	if not Profile:isVisible() then
		return 
	end
	
	arg_26_1 = arg_26_1 or {}
	arg_26_0.vars = {}
	arg_26_0.vars.dlg = load_dlg("frame_change_popup", true, "wnd")
	arg_26_0.vars.opts = arg_26_1
	arg_26_0.vars.prev_border = Account:getBorderCode()
	arg_26_0.vars.curr_border = arg_26_0.vars.prev_border
	arg_26_0.vars.scrollview = arg_26_0.vars.dlg:getChildByName("scrollview")
	
	upgradeLabelToRichLabel(arg_26_0.vars.dlg, "txt_desc")
	arg_26_0:initialize()
	;(arg_26_1.parent or SceneManager:getRunningPopupScene()):addChild(arg_26_0.vars.dlg)
	TutorialGuide:ifStartGuide("user_border")
	Account:setBorderList(Account:getCurrentBorderList())
	Profile:updateFrameNotify()
	TopBarNew:checkDefaultNotification()
	BackButtonManager:push({
		check_id = "UserBorderChange",
		back_func = function()
			BackButtonManager:pop({
				id = "UserBorderChange",
				dlg = arg_26_0.vars.dlg
			})
			UserBorderChange:hide()
		end,
		dlg = arg_26_0.vars.dlg
	})
end

function UserBorderChange.hide(arg_28_0, arg_28_1)
	if not arg_28_0.vars then
		return 
	end
	
	if get_cocos_refid(arg_28_1) and arg_28_1 ~= arg_28_0.vars.dlg then
		arg_28_1:removeFromParent()
	end
	
	if get_cocos_refid(arg_28_0.vars.dlg) then
		arg_28_0.vars.dlg:removeFromParent()
	end
	
	if arg_28_0.vars.prev_border ~= arg_28_0.vars.curr_border then
		query("set_main_border", {
			border_code = arg_28_0.vars.curr_border
		})
	end
	
	arg_28_0.vars = nil
end

function UserBorderChange.initialize(arg_29_0)
	local var_29_0 = {}
	local var_29_1 = arg_29_0:getBorderHideKeys()
	local var_29_2 = os.time()
	local var_29_3 = {}
	local var_29_4 = 604800
	
	for iter_29_0, iter_29_1 in pairs(Account:getSeasonPassSchedules()) do
		if iter_29_1.main_db.border and var_29_2 >= iter_29_1.start_time and var_29_2 <= iter_29_1.end_time + var_29_4 then
			var_29_3[iter_29_1.main_db.border] = true
		end
	end
	
	for iter_29_2 = 1, GAME_CONTENT_VARIABLE.max_border or 30 do
		local var_29_5, var_29_6, var_29_7, var_29_8, var_29_9, var_29_10, var_29_11 = DB("item_material", "ma_border" .. iter_29_2, {
			"id",
			"sort",
			"ma_type",
			"icon",
			"name",
			"desc",
			"ma_type2"
		})
		
		if var_29_5 and not var_29_1[var_29_5] then
			local var_29_12 = Account:getItemCount(var_29_5) > 0
			
			var_29_6 = var_29_6 or 999
			
			if var_29_12 then
				var_29_6 = var_29_6 - 999
			end
			
			local var_29_13 = true
			
			if not var_29_12 and var_29_11 == "season_pass" then
				var_29_13 = var_29_3[var_29_5] == true
			end
			
			if var_29_13 then
				table.insert(var_29_0, {
					id = var_29_5,
					icon = var_29_8,
					sort = var_29_6,
					name = var_29_9,
					desc = var_29_10,
					lock = not var_29_12
				})
			end
		end
	end
	
	table.sort(var_29_0, function(arg_30_0, arg_30_1)
		return arg_30_0.sort < arg_30_1.sort
	end)
	arg_29_0:initScrollView(arg_29_0.vars.scrollview, 134, 133)
	arg_29_0:createScrollViewItems(var_29_0)
	arg_29_0:select(arg_29_0.vars.prev_border)
end

function UserBorderChange.getScrollViewItem(arg_31_0, arg_31_1)
	local var_31_0 = load_control("wnd/frame_change_popup_item.csb")
	
	if_set_sprite(var_31_0, "frame", "item/" .. arg_31_1.icon .. ".png")
	
	if arg_31_1.lock then
		if_set_opacity(var_31_0, "frame", 76)
		if_set_opacity(var_31_0, "bg_face", 76)
	end
	
	if_set_visible(var_31_0, "lock", arg_31_1.lock)
	
	return var_31_0
end

function UserBorderChange.onSelectScrollViewItem(arg_32_0, arg_32_1, arg_32_2)
	local var_32_0 = arg_32_0.ScrollViewItems[arg_32_1]
	local var_32_1 = var_32_0.control
	local var_32_2 = var_32_0.item
	
	if var_32_2.lock then
		arg_32_0:showLockPopup(var_32_2)
		
		return 
	end
	
	arg_32_0.vars.curr_border = var_32_2.id
	
	arg_32_0:select(arg_32_0.vars.curr_border)
end

function UserBorderChange.showLockPopup(arg_33_0, arg_33_1)
	local var_33_0 = load_control("wnd/frame_change_lock.csb")
	
	if_set(var_33_0, "t_name", T(arg_33_1.name))
	if_set_sprite(var_33_0, "frame", "item/" .. arg_33_1.icon .. ".png")
	Dialog:msgBox(T(arg_33_1.desc), {
		yesno = true,
		dlg = var_33_0,
		title = T("title_border_unlock")
	})
end

function UserBorderChange.select(arg_34_0, arg_34_1)
	local var_34_0 = arg_34_0.vars.dlg:getChildByName("mob_icon")
	local var_34_1 = Account:getMainUnitCode()
	
	var_34_0:removeChildByName("@char_frame")
	UIUtil:getUserIcon(var_34_1, {
		no_popup = true,
		name = false,
		no_role = true,
		no_lv = true,
		scale = 1,
		no_grade = true,
		parent = var_34_0,
		border_code = arg_34_1
	}):setName("@char_frame")
	
	local var_34_2
	
	for iter_34_0, iter_34_1 in pairs(arg_34_0.ScrollViewItems) do
		local var_34_3 = iter_34_1.control
		local var_34_4 = iter_34_1.item
		
		if var_34_4.id == arg_34_1 then
			var_34_2 = var_34_4
		end
		
		if_set_visible(var_34_3, "bg_select", var_34_4.id == arg_34_1)
	end
	
	if var_34_2 then
		if_set(arg_34_0.vars.dlg, "txt_title", T(var_34_2.name))
		if_set(arg_34_0.vars.dlg, "txt_desc", T(var_34_2.desc))
	end
	
	arg_34_0.vars.curr_border = arg_34_1
end

function UserBorderChange.getBorderHideKeys(arg_35_0)
	local var_35_0
	
	if Account:isJPN() then
		var_35_0 = GAME_CONTENT_VARIABLE.border_hide_jpn
	elseif IS_PUBLISHER_ZLONG then
		var_35_0 = GAME_CONTENT_VARIABLE.border_hide_chn
	else
		var_35_0 = GAME_CONTENT_VARIABLE.border_hide_global
	end
	
	local var_35_1 = {}
	
	if var_35_0 then
		for iter_35_0, iter_35_1 in pairs(string.split(var_35_0, ";")) do
			if iter_35_1 then
				var_35_1[string.trim(iter_35_1)] = true
			end
		end
	end
	
	return var_35_1
end
