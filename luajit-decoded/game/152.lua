function HANDLER.mail_list(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_receive" then
		Postbox:readMail(arg_1_0:getParent():getParent().item)
	end
	
	if arg_1_1 == "btn_all" and arg_1_0.active_flag then
		Dialog:msgBox(T("msg_mail_all_receive_confirm"), {
			yesno = true,
			postbox = true,
			handler = function()
				Postbox:readAllMail()
			end
		})
	end
	
	if string.starts(arg_1_1, "btn_main_tab") then
		local var_1_0 = tonumber(string.sub(arg_1_1, -1, -1))
		
		Postbox:selectTab(var_1_0)
	end
	
	if arg_1_1 == "btn_close" then
		if Postbox.vars.portrait then
			UIUtil:playNPCSoundRandomly("mail.leave")
		end
		
		Postbox:close()
	end
	
	if arg_1_1 == "btn_banner" then
		Postbox:openEventBanner(arg_1_0)
	end
	
	if arg_1_1 == "btn_sort" or arg_1_1 == "btn_toggle" then
		Postbox:toggleSort()
	end
	
	if arg_1_1 == "sort_1" then
		Postbox:toggleSort(1)
	end
	
	if arg_1_1 == "sort_2" then
		Postbox:toggleSort(2)
	end
	
	if arg_1_1 == "btn_replay" then
		Postbox:onBtnReplay(arg_1_0)
	end
end

function ErrHandler.read_mail(arg_3_0, arg_3_1, arg_3_2)
	if arg_3_2.err == "already_received_mail" then
		balloon_message_with_sound("mail_just_recv")
	else
		balloon_message_with_sound(arg_3_2.err)
	end
end

function MsgHandler.mail_list(arg_4_0)
	if arg_4_0.mail then
		AccountData.mails = arg_4_0.mail
	end
	
	TopBarNew:updateMailMark()
	
	if Postbox.need_to_open then
		Postbox:show()
		
		Postbox.need_to_open = nil
	end
end

function MsgHandler.mail_log(arg_5_0)
	AccountData.mail_logs = arg_5_0.logs
	Postbox.log_dirty = false
	
	Postbox:selectTab(3)
end

function MsgHandler.read_mail(arg_6_0)
	local var_6_0 = Postbox:getMail(arg_6_0.idx[1])
	
	if var_6_0 == nil then
		return 
	end
	
	local var_6_1 = #arg_6_0.idx
	local var_6_2 = {
		title = T("read_mail"),
		desc = T("success_receive_all")
	}
	
	if var_6_1 == 1 and var_6_0.i and string.starts(var_6_0.i, "sp_") and DB("item_special", var_6_0.i, "type") == "package" then
		var_6_2.desc = T("receive_mail_package")
	end
	
	local function var_6_3(arg_7_0)
		arg_7_0 = arg_7_0 or {}
		
		local var_7_0 = Account:addReward(arg_6_0, {
			play_reward_data = var_6_2,
			single = not arg_7_0.is_single_popup and var_6_1 == 1,
			parent = Postbox.vars.wnd,
			force_show_effect = arg_7_0.force_show_effect,
			force_character_effect = arg_7_0.force_character_effect,
			is_no_reward_popup = arg_7_0.is_no_reward_popup
		})
		
		Postbox:removeMail(Postbox.selected_mail)
		Account:updateCurrencies(arg_6_0)
		BattleReady:updateButtons()
		DescentReady:updateButtons()
		BurningReady:updateButtons()
		SubStoryBurningStory:updateButtons()
		TopBarNew:topbarUpdate(true)
		Postbox:updateNewMark()
		ClanDonate:updateUI()
		
		Postbox.log_dirty = true
		
		SceneManager:dispatchGameEvent("read_mail")
		
		if var_6_0 and var_6_0.i and string.find(var_6_0.i, "exc") then
			ShopExclusiveEquip_result:open_resultPopup({
				rewards = arg_6_0
			}, {
				type = "post_box"
			})
		end
		
		return var_7_0
	end
	
	if arg_6_0.nickname then
		UserNickName:nameChanged("ok", arg_6_0.nickname)
		balloon_message_with_sound("nickname_chanhe_complete")
		Friend:setNameUI()
	end
	
	if DB("item_special", var_6_0.i, "type") == "gacha_select" then
		var_6_3({
			force_show_effect = true,
			force_character_effect = true
		})
		
		return 
	end
	
	local var_6_4 = DB("character", var_6_0.i, "type")
	
	if var_6_1 == 1 and (var_6_4 == "character" or var_6_4 == "limited") then
		var_6_3({
			force_character_effect = true
		})
		
		return 
	end
	
	local var_6_5 = arg_6_0.packages and arg_6_0.packages[1] and arg_6_0.packages[1].package or nil
	
	if not var_6_5 then
		var_6_3()
		
		return 
	end
	
	if DB("item_special", var_6_5, {
		"type"
	}) == "option" then
		local var_6_6 = var_6_3({
			is_no_reward_popup = true
		})
		
		if var_6_6.data_for_rewards_dlg then
			EquipPack:show(arg_6_0.new_equips, var_6_6.data_for_rewards_dlg)
		end
	else
		var_6_3()
	end
end

function HANDLER.mail_event_popup(arg_8_0, arg_8_1)
	if arg_8_1 == "btn_receive" then
		local var_8_0 = arg_8_0:getParent():getChildByName("btn_link")
		
		if get_cocos_refid(var_8_0) and var_8_0.link_url then
			Postbox.link_url_opened = Postbox.link_url_opened or {}
			
			if to_n(Postbox.link_url_opened[var_8_0.link_url]) ~= 1 then
				Dialog:msgBox(T("msg_mail_link_first"))
				
				return 
			end
		end
		
		local var_8_1, var_8_2 = Postbox:checkPasswordMail(arg_8_0)
		
		if var_8_1 ~= true then
			return 
		end
		
		Dialog:close("mail_event_popup", false)
		
		if var_8_2 then
			Postbox:queryReadMail({
				input_password = var_8_2
			})
		else
			Postbox:queryReadMail()
		end
		
		return 
	end
	
	if arg_8_1 == "btn_cancel" then
		Dialog:close("mail_event_popup", false)
		
		return 
	end
	
	if arg_8_1 == "btn_link" then
		if get_cocos_refid(arg_8_0) and arg_8_0.link_url then
			Postbox.link_url_opened = Postbox.link_url_opened or {}
			
			if to_n(Postbox.link_url_opened[arg_8_0.link_url]) ~= 1 and to_n(Postbox.category) == 1 then
				Postbox.link_url_opened[arg_8_0.link_url] = 1
				
				local var_8_3 = arg_8_0:getParent():getChildByName("btn_receive")
				
				if_set_opacity(var_8_3, nil, 255)
			end
			
			movetoPath(arg_8_0.link_url)
		end
		
		return 
	end
end

Postbox = Postbox or {}

function Postbox._getTextFromMail(arg_9_0, arg_9_1)
	if not arg_9_1 then
		return ""
	end
	
	if string.empty(arg_9_1.m) then
		return ""
	end
	
	local var_9_0 = tostring(UIUtil:translateByLang(arg_9_1.m))
	local var_9_1 = DB("mail_send", var_9_0, "desc_1")
	
	var_9_0 = var_9_1 and T(var_9_1) or var_9_0
	
	return UIUtil:translateServerText(var_9_0)
end

function Postbox._getLinkUrlFromMail(arg_10_0, arg_10_1)
	if not arg_10_1 then
		return ""
	end
	
	if string.empty(arg_10_1.m) then
		return ""
	end
	
	local var_10_0 = json.decode(arg_10_1.m)
	
	if type(var_10_0) ~= "table" then
		return ""
	end
	
	if not var_10_0.link then
		return ""
	end
	
	return UIUtil:getUserLanguageValue(var_10_0.link)
end

function Postbox._addEventDialog(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	if not get_cocos_refid(arg_11_1) then
		return 
	end
	
	if not arg_11_2 then
		return 
	end
	
	local var_11_0 = arg_11_3 or arg_11_0:_getTextFromMail(arg_11_2)
	
	UIUtil:setScrollViewText(arg_11_1:getChildByName("scrollview"), var_11_0):setTextColor(cc.c3b(136, 136, 136))
	
	local var_11_1 = arg_11_0:getTimeStr(arg_11_2, os.time())
	
	if_set(arg_11_1, "txt_date", var_11_1)
	SceneManager:getRunningPopupScene():addChild(arg_11_1)
end

function Postbox.showEventDialogForInbox(arg_12_0, arg_12_1, arg_12_2)
	if not arg_12_0.vars or not get_cocos_refid(arg_12_0.vars.wnd) then
		return 
	end
	
	if not arg_12_1 then
		return 
	end
	
	local var_12_0 = Dialog:open("wnd/mail_event_popup", arg_12_0, true)
	
	arg_12_0:setMailInfo(var_12_0, arg_12_1)
	if_set_visible(var_12_0, "n_locked", false)
	if_set_visible(var_12_0, "n_normal", false)
	if_set_visible(var_12_0, "btn_log", false)
	
	local var_12_1 = arg_12_1 and arg_12_1.pr and Base64.decode(arg_12_1.pr) or ""
	
	if not string.empty(tostring(var_12_1)) then
		if_set_visible(var_12_0, "n_locked", true)
		
		local var_12_2 = var_12_0:getChildByName("txt_name_input")
		
		if get_cocos_refid(var_12_2) then
			var_12_2:setCursorEnabled(true)
			var_12_2:setTextColor(cc.c3b(107, 101, 27))
		end
	else
		local var_12_3 = arg_12_0:_getLinkUrlFromMail(arg_12_1)
		
		if not string.empty(var_12_3) then
			if_set_visible(var_12_0, "btn_log", true)
			
			local var_12_4 = var_12_0:getChildByName("btn_log")
			
			if get_cocos_refid(var_12_4) then
				local var_12_5 = var_12_4:getChildByName("btn_link")
				
				if get_cocos_refid(var_12_5) then
					var_12_5.link_url = var_12_3
					Postbox.link_url_opened = Postbox.link_url_opened or {}
					
					if to_n(Postbox.link_url_opened[var_12_3]) ~= 1 then
						local var_12_6 = var_12_4:getChildByName("btn_receive")
						
						if_set_opacity(var_12_6, nil, 76.5)
					end
				end
			end
		else
			if_set_visible(var_12_0, "n_normal", true)
		end
	end
	
	arg_12_0:_addEventDialog(var_12_0, arg_12_1, arg_12_2)
end

function Postbox.showEventDialogForReplay(arg_13_0, arg_13_1)
	if not arg_13_1 then
		return 
	end
	
	local var_13_0 = Dialog:open("wnd/mail_event_popup", arg_13_0, true)
	
	arg_13_0:setMailInfo(var_13_0, arg_13_1)
	if_set_visible(var_13_0, "n_normal", false)
	if_set_visible(var_13_0, "n_locked", false)
	if_set_visible(var_13_0, "btn_log", false)
	
	local function var_13_1(arg_14_0, arg_14_1)
		if arg_14_1 == 2 then
			balloon_message_with_sound(arg_13_1.r and "ui_mail_reward_complete" or "ui_mail_reward_over")
		end
	end
	
	local var_13_2 = arg_13_0:_getLinkUrlFromMail(arg_13_1)
	
	if not string.empty(var_13_2) then
		local var_13_3 = var_13_0:getChildByName("btn_log")
		
		if get_cocos_refid(var_13_3) then
			if_set_visible(var_13_3, nil, true)
			
			local var_13_4 = var_13_3:getChildByName("btn_receive")
			
			if get_cocos_refid(var_13_4) then
				if_set_opacity(var_13_4, nil, 76.5)
				var_13_4:addTouchEventListener(var_13_1)
			end
			
			local var_13_5 = var_13_3:getChildByName("btn_link")
			
			if get_cocos_refid(var_13_5) then
				var_13_5.link_url = var_13_2
			end
		end
	else
		local var_13_6 = var_13_0:getChildByName("n_normal")
		
		if get_cocos_refid(var_13_6) then
			if_set_visible(var_13_6, nil, true)
			if_set_opacity(var_13_6, nil, 76.5)
			
			local var_13_7 = var_13_6:getChildByName("btn_receive")
			
			if get_cocos_refid(var_13_7) then
				var_13_7:addTouchEventListener(var_13_1)
			end
		end
	end
	
	arg_13_0:_addEventDialog(var_13_0, arg_13_1, nil)
end

function Postbox.getMail(arg_15_0, arg_15_1)
	for iter_15_0, iter_15_1 in pairs(AccountData.mails) do
		if iter_15_1.id == tonumber(arg_15_1) then
			return iter_15_1
		end
	end
end

function Postbox.error(arg_16_0)
end

local function var_0_0(arg_17_0, arg_17_1, arg_17_2)
	if Postbox.category ~= 3 then
		local var_17_0 = arg_17_0:getChildByName("txt_date")
		
		var_17_0:setScaleX(0.83)
		UIUserData:call(var_17_0, "SINGLE_WSCALE(90)")
		if_set(arg_17_0, "txt_date", Postbox:getTimeStr(arg_17_1))
	elseif arg_17_1.r == nil then
		if_set(arg_17_0, "txt_date_log", T("time_before", {
			time = sec_to_string(os.time() - arg_17_1.ct)
		}))
	else
		if_set(arg_17_0, "txt_date_log", T("time_before", {
			time = sec_to_string(os.time() - arg_17_1.r)
		}))
	end
	
	if arg_17_2 then
		return 
	end
	
	arg_17_0.item = arg_17_1
	
	Postbox:setMailInfo(arg_17_0, arg_17_1)
	
	if Postbox.category ~= 3 then
		if_set_visible(arg_17_0, "n_log", false)
		if_set_visible(arg_17_0, "n_read", true)
		
		local var_17_1 = arg_17_0:getChildByName("txt_date")
		
		var_17_1:setScaleX(0.83)
		UIUserData:call(var_17_1, "SINGLE_WSCALE(90)")
		if_set(arg_17_0, "txt_date", Postbox:getTimeStr(arg_17_1))
	else
		if_set_visible(arg_17_0, "n_log", true)
		if_set_visible(arg_17_0, "n_read", false)
		
		if arg_17_1.mc == "E" then
			if_set_visible(arg_17_0, "n_received_log_btn", false)
			if_set_visible(arg_17_0, "n_deleted_log_btn", false)
			if_set_visible(arg_17_0, "btn_replay", true)
		else
			if_set_visible(arg_17_0, "n_received_log_btn", arg_17_1.r ~= nil)
			if_set_visible(arg_17_0, "n_deleted_log_btn", arg_17_1.r == nil)
			if_set_visible(arg_17_0, "btn_replay", false)
		end
		
		local var_17_2 = arg_17_0:getChildByName("txt_date_log")
		
		var_17_2:setScaleX(0.83)
		UIUserData:call(var_17_2, "SINGLE_WSCALE(90)")
		
		if arg_17_1.r == nil then
			UIUserData:call(arg_17_0:getChildByName("txt_recevied_log"), "SINGLE_WSCALE(115)")
			if_set(arg_17_0, "txt_recevied_log", T("expired"))
			if_set(arg_17_0, "txt_date_log", T("time_before", {
				time = sec_to_string(os.time() - arg_17_1.ct)
			}))
		else
			if_set(arg_17_0, "txt_date_log", T("time_before", {
				time = sec_to_string(os.time() - arg_17_1.r)
			}))
		end
	end
	
	local var_17_3 = Postbox:_getTextFromMail(arg_17_1)
	local var_17_4 = arg_17_0:findChildByName("txt_info")
	
	set_ellipsis_multi_label(var_17_4, var_17_3, 2, 10)
	
	if var_17_4:getTextBoxSize().height > 45 then
		local var_17_5 = arg_17_0:getChildByName("n_desc_head")
		
		if get_cocos_refid(var_17_5) then
			var_17_5:setPositionY(10)
		end
	end
	
	if_set(arg_17_0, "txt_receive", T("receive"))
end

function Postbox.isShow(arg_18_0)
	return arg_18_0.vars and get_cocos_refid(arg_18_0.vars.wnd)
end

function Postbox.show(arg_19_0, arg_19_1)
	if arg_19_0:isShow() then
		UIUtil:slideOpen(arg_19_0.vars.wnd, arg_19_0.vars.wnd:getChildByName("n_content"), true)
		
		return 
	end
	
	if Account:checkIapResponses() then
		return 
	end
	
	if SceneManager:getCurrentSceneName() == "battle" then
		BattleField:setVisible(false)
	end
	
	arg_19_0.vars = arg_19_0.vars or {}
	arg_19_0.vars.opts = arg_19_1 or arg_19_0.vars.opts or {}
	
	local var_19_0 = Dialog:open("wnd/mail_list", arg_19_0, {
		back_func = function()
			arg_19_0:close()
		end
	})
	
	arg_19_0.vars.parent = arg_19_0.vars.opts.parent or SceneManager:getRunningPopupScene()
	arg_19_0.vars.wnd = var_19_0
	
	arg_19_0:_customSetupForPub()
	arg_19_0.vars.parent:addChild(var_19_0)
	UIUtil:slideOpen(var_19_0, var_19_0:getChildByName("n_content"), true)
	
	local var_19_1 = arg_19_0.vars.wnd:getChildByName("n_portrait")
	
	if var_19_1 then
		local var_19_2 = UIUtil:getPortraitAni("npc1004", {
			pin_sprite_position_y = true
		})
		
		arg_19_0.vars.portrait:setScale(0.97)
		var_19_1:removeAllChildren()
		var_19_1:addChild(var_19_2)
	end
	
	local var_19_3 = json.decode(Account:getConfigData("postbox_sort") or "{}")
	
	if var_19_3 and var_19_3.sidx ~= nil and var_19_3.sdec ~= nil then
		SAVE:setTempConfigData("postbox_sort", nil)
		
		if SAVE:getKeep("postbox_sort") == nil then
			SAVE:setKeep("postbox_sort", var_19_3)
		end
	end
	
	local var_19_4 = SAVE:getKeep("postbox_sort")
	
	if var_19_4 == nil or var_19_4.sidx == nil or var_19_4.sdec == nil then
		arg_19_0.vars.sort_idx = 1
		arg_19_0.vars.sort_decending = true
	else
		arg_19_0.vars.sort_idx = var_19_4.sidx
		arg_19_0.vars.sort_decending = var_19_4.sdec
	end
	
	arg_19_0.vars.sort_names = {
		T("ui_mail_item_get"),
		T("ui_mail_item_remain")
	}
	
	local var_19_5 = var_19_0:getChildByName("n_layer_sort")
	
	if get_cocos_refid(var_19_5) then
		for iter_19_0 = 1, 2 do
			if_set(var_19_5:getChildByName("sort_" .. iter_19_0), "label", arg_19_0.vars.sort_names[iter_19_0])
		end
	end
	
	arg_19_0.wnd = var_19_0
	arg_19_0.tick = os.time()
	
	local var_19_6 = var_19_0:getChildByName("n_content")
	
	arg_19_0.vars.listview = ItemListView_v2:bindControl(var_19_6:getChildByName("listview"))
	
	arg_19_0.vars.listview:setRenderer(load_control("wnd/mail_item.csb"), {
		onUpdate = function(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
			var_0_0(arg_21_1, arg_21_3)
		end
	})
	
	for iter_19_1 = 1, 2 do
		arg_19_0:initList(iter_19_1)
		
		if #arg_19_0.List > 0 then
			arg_19_0:selectTab(iter_19_1, true)
			
			break
		end
	end
	
	if #arg_19_0.List == 0 then
		arg_19_0:selectTab(1, true)
	end
	
	if arg_19_0.vars.portrait then
		UIUtil:playNPCSoundRandomly("mail.enter", 250)
	end
	
	arg_19_0:updateEventSide()
	SoundEngine:play("event:/ui/main_hud/btn_mail")
	
	if MusicBoxUI:isShow() then
		arg_19_0.vars.wnd:bringToFront()
	end
	
	Scheduler:add(var_19_0, Postbox.onUpdate, arg_19_0)
end

function Postbox._customSetupForPub(arg_22_0)
	if not get_cocos_refid(arg_22_0.vars.wnd) then
		return 
	end
	
	if IS_PUBLISHER_ZLONG then
		local var_22_0 = arg_22_0.vars.wnd:getChildByName("n_content_zl")
		
		if get_cocos_refid(var_22_0) then
			arg_22_0.vars.wnd:removeChildByName("n_content")
			var_22_0:setName("n_content")
			var_22_0:setVisible(true)
		end
	end
end

function Postbox.onUpdate(arg_23_0)
	local var_23_0 = os.time()
	
	if var_23_0 == arg_23_0.tick then
		return 
	end
	
	arg_23_0.vars.listview:enumControls(function(arg_24_0)
		var_0_0(arg_24_0, arg_24_0.item, true)
	end)
	
	arg_23_0.tick = var_23_0
end

function Postbox.open(arg_25_0, arg_25_1)
	arg_25_0.vars = {}
	arg_25_0.vars.opts = arg_25_1
	
	query("mail_list")
	
	Postbox.need_to_open = true
	Postbox.log_dirty = true
end

function Postbox.getMails(arg_26_0, arg_26_1)
	local var_26_0 = {}
	local var_26_1 = "ghtpodvkscbe"
	
	if arg_26_1 < 3 then
		for iter_26_0 = #AccountData.mails, 1, -1 do
			local var_26_2 = AccountData.mails[iter_26_0]
			
			var_26_0[#var_26_0 + 1] = var_26_2
		end
		
		if arg_26_0.vars.sort_idx == 1 then
			if arg_26_0.vars.sort_decending then
				table.sort(var_26_0, function(arg_27_0, arg_27_1)
					if not arg_27_0.ct and not arg_27_1.ct then
						return arg_27_0.id > arg_27_1.id
					end
					
					if not arg_27_0.ct then
						return false
					end
					
					if not arg_27_1.ct then
						return true
					end
					
					if arg_27_0.ct == arg_27_1.ct then
						return arg_27_0.id > arg_27_1.id
					end
					
					return arg_27_0.ct > arg_27_1.ct
				end)
			else
				table.sort(var_26_0, function(arg_28_0, arg_28_1)
					if not arg_28_0.ct and not arg_28_1.ct then
						return arg_28_0.id < arg_28_1.id
					end
					
					if not arg_28_0.ct then
						return true
					end
					
					if not arg_28_1.ct then
						return false
					end
					
					if arg_28_0.ct == arg_28_1.ct then
						return arg_28_0.id < arg_28_1.id
					end
					
					return arg_28_0.ct < arg_28_1.ct
				end)
			end
		elseif arg_26_0.vars.sort_decending then
			table.sort(var_26_0, function(arg_29_0, arg_29_1)
				if not arg_29_0.et and not arg_29_1.et then
					return arg_29_0.id > arg_29_1.id
				end
				
				if not arg_29_0.et then
					return true
				end
				
				if not arg_29_1.et then
					return false
				end
				
				if arg_29_0.et == arg_29_1.et then
					return arg_29_0.id > arg_29_1.id
				end
				
				return arg_29_0.et > arg_29_1.et
			end)
		else
			table.sort(var_26_0, function(arg_30_0, arg_30_1)
				if not arg_30_0.et and not arg_30_1.et then
					return arg_30_0.id < arg_30_1.id
				end
				
				if not arg_30_0.et then
					return false
				end
				
				if not arg_30_1.et then
					return true
				end
				
				if arg_30_0.et == arg_30_1.et then
					return arg_30_0.id < arg_30_1.id
				end
				
				return arg_30_0.et < arg_30_1.et
			end)
		end
	else
		for iter_26_1 = #AccountData.mail_logs, 1, -1 do
			local var_26_3 = AccountData.mail_logs[iter_26_1]
			
			var_26_0[#var_26_0 + 1] = var_26_3
		end
		
		table.sort(var_26_0, function(arg_31_0, arg_31_1)
			return arg_31_0.id > arg_31_1.id
		end)
	end
	
	return var_26_0
end

function Postbox.initList(arg_32_0, arg_32_1)
	arg_32_1 = arg_32_1 or arg_32_0.category
	arg_32_0.List = arg_32_0:getMails(arg_32_1)
	
	if_set_visible(arg_32_0.wnd, "n_empty", arg_32_1 ~= 3 and #arg_32_0.List == 0)
	if_set_visible(arg_32_0.wnd, "n_empty_log", arg_32_1 == 3 and #arg_32_0.List == 0)
	arg_32_0:updateSort()
end

function Postbox.removeMail(arg_33_0, arg_33_1, arg_33_2)
	arg_33_0.log_dirty = true
	
	if type(arg_33_1) == "table" then
		for iter_33_0, iter_33_1 in pairs(arg_33_1) do
			arg_33_0:removeMail(arg_33_1[iter_33_0], true)
		end
		
		arg_33_0.vars.listview:setDataSource(arg_33_0.List)
		
		return 
	end
	
	local function var_33_0(arg_34_0, arg_34_1)
		for iter_34_0, iter_34_1 in pairs(arg_34_0) do
			if iter_34_1.id == arg_34_1 then
				table.remove(arg_34_0, iter_34_0)
				
				return true
			end
		end
	end
	
	var_33_0(AccountData.mails, arg_33_1)
	var_33_0(arg_33_0.List, arg_33_1)
	
	if not arg_33_2 then
		arg_33_0:refresh()
	end
end

function Postbox.refresh(arg_35_0)
	arg_35_0.vars.listview:setDataSource(arg_35_0.List)
end

function Postbox.onDialogTouchDown(arg_36_0, arg_36_1, arg_36_2, arg_36_3)
end

function Postbox.onTouchMove(arg_37_0, arg_37_1, arg_37_2)
	arg_37_0:onDialogTouchDown(nil, arg_37_1, arg_37_2)
end

function Postbox.onTouchDown(arg_38_0, arg_38_1, arg_38_2)
	arg_38_0:onDialogTouchDown(nil, arg_38_1, arg_38_2)
end

function Postbox.onTouchUp(arg_39_0, arg_39_1, arg_39_2)
end

Postbox.onDialogTouchMove = Postbox.onDialogTouchDown

function Postbox.selectTab(arg_40_0, arg_40_1, arg_40_2)
	if arg_40_1 == 3 and (AccountData.mail_logs == nil or arg_40_0.log_dirty == nil or arg_40_0.log_dirty == true) then
		arg_40_0.log_dirty = false
		
		query("mail_log")
		
		return 
	end
	
	if not arg_40_2 then
		SoundEngine:play("event:/ui/category/select")
	end
	
	arg_40_0.category = tonumber(arg_40_1)
	
	arg_40_0:initList()
	arg_40_0:refresh()
	
	for iter_40_0 = 1, 3 do
		if_set_visible(arg_40_0.wnd, "selected" .. iter_40_0, arg_40_1 == iter_40_0)
	end
	
	if_set_visible(arg_40_0.wnd, "n_mail_logs", arg_40_1 == 3)
	if_set(arg_40_0.wnd:getChildByName("n_mail_logs"), "txt_desc_log", T("ui_mail_log_info"))
	arg_40_0:updateNewMark()
	arg_40_0.vars.listview:jumpToTop()
end

function Postbox.getMailCount(arg_41_0)
	if not AccountData or not AccountData.mails then
		return 0
	end
	
	return #AccountData.mails
end

function Postbox.updateSort(arg_42_0)
	local var_42_0 = arg_42_0.wnd:getChildByName("n_layer_sort")
	local var_42_1 = arg_42_0.wnd:getChildByName("btn_sort")
	
	if not get_cocos_refid(var_42_0) or not get_cocos_refid(var_42_1) then
		return 
	end
	
	if_set(var_42_1, "txt_sort", arg_42_0.vars.sort_names[arg_42_0.vars.sort_idx])
	
	local var_42_2 = arg_42_0.wnd:getChildByName("sort_" .. arg_42_0.vars.sort_idx)
	
	if get_cocos_refid(var_42_2) then
		local var_42_3 = arg_42_0.wnd:getChildByName("n_updown")
		
		var_42_3:setPositionY(var_42_2:getPositionY())
		arg_42_0.wnd:getChildByName("sort_cursor"):setPositionY(var_42_2:getPositionY())
		
		if arg_42_0.vars.sort_decending then
			if_set_visible(var_42_3, "btn_up", false)
			if_set_visible(var_42_3, "btn_down", true)
		else
			if_set_visible(var_42_3, "btn_up", true)
			if_set_visible(var_42_3, "btn_down", false)
		end
	end
end

function Postbox.toggleSort(arg_43_0, arg_43_1)
	local var_43_0 = arg_43_0.wnd:getChildByName("n_layer_sort")
	
	if not get_cocos_refid(var_43_0) then
		return 
	end
	
	local var_43_1 = var_43_0:isVisible()
	
	var_43_0:setVisible(not var_43_1)
	
	if not var_43_1 then
		return 
	end
	
	if not arg_43_1 then
		return 
	end
	
	if arg_43_0.vars.sort_idx == arg_43_1 then
		arg_43_0.vars.sort_decending = not arg_43_0.vars.sort_decending
	else
		arg_43_0.vars.sort_idx = arg_43_1
		arg_43_0.vars.sort_decending = true
	end
	
	arg_43_0:selectTab(arg_43_0.category)
	
	local var_43_2 = {
		sidx = arg_43_0.vars.sort_idx,
		sdec = arg_43_0.vars.sort_decending
	}
	
	SAVE:setKeep("postbox_sort", var_43_2)
end

function Postbox.updateNewMark(arg_44_0)
	local var_44_0 = #arg_44_0.List > 0 and arg_44_0.category == 1
	local var_44_1 = arg_44_0.wnd:getChildByName("btn_all")
	local var_44_2 = arg_44_0.wnd:getChildByName("n_counter_base")
	
	if arg_44_0.category == 3 then
		var_44_1:setVisible(false)
		if_set_visible(arg_44_0.wnd, "btn_all", false)
		if_set_visible(arg_44_0.wnd, "btn_sort", false)
		var_44_2:setVisible(false)
		if_set_visible(arg_44_0.wnd, "n_empty", false)
		if_set_visible(arg_44_0.wnd, "n_empty_log", #arg_44_0.List == 0)
	else
		if_set_visible(arg_44_0.wnd, "btn_all", arg_44_0.category == 1)
		if_set_visible(arg_44_0.wnd, "btn_sort", true)
		var_44_2:setVisible(true)
		UIUtil:changeButtonState(var_44_1, var_44_0 and arg_44_0.category == 1)
		if_set_visible(arg_44_0.wnd, "n_empty", #arg_44_0.List == 0)
		if_set_visible(arg_44_0.wnd, "n_empty_log", false)
		if_set(arg_44_0.wnd, "txt_total_count", arg_44_0:getMailCount() .. "/" .. 100)
	end
end

function Postbox.getTimeStr(arg_45_0, arg_45_1, arg_45_2)
	arg_45_2 = arg_45_2 or os.time()
	
	local var_45_0 = ""
	
	if arg_45_1.et then
		local var_45_1 = arg_45_1.et - arg_45_2
		
		if var_45_1 <= 0 then
			var_45_0 = T("expired")
		else
			var_45_0 = T("time_remain", {
				time = sec_to_string(var_45_1)
			})
		end
	else
		var_45_0 = T("unlimited")
	end
	
	return var_45_0
end

function Postbox.setMailInfo(arg_46_0, arg_46_1, arg_46_2)
	local var_46_0 = T(arg_46_2.s) or T(DB("character", "c1030", "name"))
	local var_46_1 = arg_46_2.p
	
	if not var_46_1 or var_46_1 == "" then
		var_46_1 = "c1030"
	end
	
	UIUtil:getRewardIcon("c", var_46_1, {
		grade = 0,
		is_npc = true,
		parent = arg_46_1:getChildByName("n_face"),
		face = var_46_1
	})
	if_set(arg_46_1, "txt_sender", var_46_0)
	if_set_visible(arg_46_1, "icon_gm", arg_46_2.mc == "E")
	arg_46_0:setItemIcon(arg_46_1, arg_46_2)
end

function Postbox.setItemIcon(arg_47_0, arg_47_1, arg_47_2)
	if not arg_47_2.i then
		if_set_visible(arg_47_1, "n_item", false)
		
		return 
	end
	
	if_set_visible(arg_47_1, "n_item", true)
	
	local var_47_0 = Account:isCurrencyType(arg_47_2.i)
	
	if var_47_0 then
		UIUtil:getRewardIcon(arg_47_2.c, "to_" .. var_47_0, {
			parent = arg_47_1:getChildByName("n_item"),
			count = arg_47_2.c
		})
		
		return 
	end
	
	if string.starts(arg_47_2.i, "e") then
		if DB("equip_item", arg_47_2.i, "id") then
			if arg_47_2.op and arg_47_2.op.fixed_opts then
				fixed_opts = arg_47_2.op.fixed_opts
				
				local var_47_1 = EQUIP:createByInfo(fixed_opts)
				
				UIUtil:getRewardIcon("equip", var_47_1.code, {
					no_count = true,
					show_name = false,
					parent = arg_47_1:getChildByName("n_item"),
					equip = var_47_1,
					grade = var_47_1.grade
				})
			else
				UIUtil:getRewardIcon(nil, arg_47_2.i, {
					parent = arg_47_1:getChildByName("n_item"),
					count = arg_47_2.c
				})
			end
		end
		
		return 
	end
	
	if string.starts(arg_47_2.i, "ma_") then
		local var_47_2 = DB("item_material", arg_47_2.i, "id")
		
		if var_47_2 then
			local var_47_3 = false
			
			if string.find(var_47_2, "ma_petpoint") then
				var_47_3 = true
			end
			
			UIUtil:getRewardIcon(arg_47_2.c, arg_47_2.i, {
				parent = arg_47_1:getChildByName("n_item"),
				count = arg_47_2.c,
				use_drop_icon = var_47_3
			})
		end
		
		return 
	end
	
	if string.starts(arg_47_2.i, "sp_") then
		local var_47_4, var_47_5, var_47_6, var_47_7 = DB("item_special", arg_47_2.i, {
			"id",
			"type",
			"value",
			"unwrap"
		})
		
		if var_47_4 then
			if var_47_5 == "package" and var_47_7 == "y" then
				for iter_47_0 = 1, 99999 do
					local var_47_8, var_47_9, var_47_10, var_47_11 = DBN("package", iter_47_0, {
						"id",
						"item_special_value",
						"item_id",
						"value"
					})
					
					if not var_47_8 then
						break
					end
					
					if var_47_9 == var_47_6 then
						UIUtil:getRewardIcon(var_47_11, var_47_10, {
							parent = arg_47_1:getChildByName("n_item"),
							count = var_47_11
						})
						
						return 
					end
				end
			end
			
			UIUtil:getRewardIcon(nil, arg_47_2.i, {
				use_badge = true,
				parent = arg_47_1:getChildByName("n_item"),
				count = arg_47_2.c
			})
		end
		
		return 
	end
	
	if string.starts(arg_47_2.i, "pet") then
		if DB("pet_character", arg_47_2.i, "id") then
			UIUtil:getRewardIcon(arg_47_2.c, arg_47_2.i, {
				parent = arg_47_1:getChildByName("n_item"),
				count = arg_47_2.c
			})
		end
		
		return 
	end
	
	if DB("character", arg_47_2.i, "id") then
		UIUtil:getRewardIcon("c", arg_47_2.i, {
			parent = arg_47_1:getChildByName("n_item"),
			count = arg_47_2.c
		})
	end
end

function Postbox.checkInventoryMailForMulti(arg_48_0, arg_48_1)
	local var_48_0 = arg_48_0:checkInventoryMail(arg_48_1)
	
	if not var_48_0 then
		return true
	end
	
	local var_48_1 = 0
	
	if var_48_0.unit and Account:getUsedHeroInventoryCount() >= Account:getCurrentHeroCount() then
		var_48_1 = var_48_1 + 1
	end
	
	if var_48_0.equip and Account:getFreeEquipCount() >= Account:getCurrentEquipCount() then
		var_48_1 = var_48_1 + 1
	end
	
	if var_48_0.artifact and Account:getFreeArtifactCount() >= Account:getCurrentArtifactCount() then
		var_48_1 = var_48_1 + 1
	end
	
	return var_48_1 == 0
end

function Postbox.checkInventoryMail(arg_49_0, arg_49_1)
	return Inventory:checkInventoryItem(arg_49_1.i)
end

function Postbox.readMail(arg_50_0, arg_50_1)
	local var_50_0 = Postbox:getMail(arg_50_1.id)
	
	if not var_50_0 then
		balloon_message_with_sound("mail_just_recv")
		
		return 
	end
	
	if var_50_0.et and var_50_0.et <= os.time() then
		Postbox:removeMail(var_50_0.id)
		Postbox:updateNewMark()
		Dialog:msgBox(T("msg_mail_over"))
		
		return 
	end
	
	local var_50_1 = arg_50_0:checkInventoryMail(var_50_0)
	
	if var_50_1 and var_50_1.equip and UIUtil:checkEquipInven() == false then
		return 
	end
	
	if var_50_1 and var_50_1.artifact and UIUtil:checkArtifactInven() == false then
		return 
	end
	
	if var_50_1 and var_50_1.unit and UIUtil:checkUnitInven() == false then
		return 
	end
	
	local var_50_2, var_50_3, var_50_4 = DB("item_special", var_50_0.i, {
		"type",
		"value",
		"name"
	})
	local var_50_5 = var_50_2 == "account_skill"
	
	if var_50_5 and AccountSkill:isBlockConditionEquipFree(var_50_3) == true then
		return 
	end
	
	Postbox.selected_mail = arg_50_1.id
	
	local var_50_6
	
	if var_50_5 then
		var_50_6 = T("mailbox_buffitem_info2")
		
		local var_50_7, var_50_8 = AccountSkill:isChangeTextEquipFree(var_50_3)
		
		if var_50_7 then
			var_50_6 = var_50_8
		end
	end
	
	if var_50_0.mc == "E" then
		arg_50_0:showEventDialogForInbox(var_50_0, var_50_6)
		
		return 
	end
	
	if var_50_5 then
		local var_50_9 = var_50_6 or T("mailbox_buffitem_info", {
			item = T(var_50_4)
		})
		
		Postbox:showConfirm(var_50_0, var_50_9)
		
		return 
	end
	
	arg_50_0:queryReadMail()
end

function Postbox.onBtnReplay(arg_51_0, arg_51_1)
	if not get_cocos_refid(arg_51_1) then
		return 
	end
	
	local var_51_0 = arg_51_1:getParent()
	
	if not get_cocos_refid(var_51_0) then
		return 
	end
	
	local var_51_1 = var_51_0:getParent()
	
	if not get_cocos_refid(var_51_1) then
		return 
	end
	
	arg_51_0:showEventDialogForReplay(var_51_1.item)
end

function Postbox.showConfirm(arg_52_0, arg_52_1, arg_52_2)
	opts = opts or {}
	
	Dialog:msgBox(arg_52_2, {
		yesno = true,
		title = T("mail"),
		handler = function()
			arg_52_0:queryReadMail()
		end,
		yes_text = T("receive")
	})
end

function Postbox.onAfterUpdate(arg_54_0)
	local var_54_0 = os.time()
	
	if arg_54_0.last_tick == var_54_0 then
		return 
	end
	
	arg_54_0.last_tick = var_54_0
end

function Postbox.close(arg_55_0)
	local var_55_0 = BackButtonManager:getTopInfo()
	
	if var_55_0 and var_55_0.dlg and var_55_0.dlg ~= arg_55_0.vars.wnd then
		return 
	end
	
	BackButtonManager:pop({
		check_id = "Dialog.mail_list",
		dlg = arg_55_0.vars.wnd
	})
	
	if arg_55_0.vars.portrait then
		UIUtil:playNPCSoundRandomly("mail.leave")
	end
	
	UIUtil:slideOpen(arg_55_0.vars.wnd, arg_55_0.vars.wnd:getChildByName("n_content"), false)
	
	if arg_55_0.vars.opts.callback then
		arg_55_0.vars.opts.callback()
	end
	
	TopBarNew:updateMailMark()
	
	if SceneManager:getCurrentSceneName() == "battle" then
		BattleField:setVisible(true)
	end
	
	local var_55_1 = {
		sidx = arg_55_0.vars.sort_idx,
		sdec = arg_55_0.vars.sort_decending
	}
	
	SAVE:setKeep("postbox_sort", var_55_1)
	
	arg_55_0.vars = nil
	
	Scheduler:remove(Postbox.onUpdate)
end

function Postbox.checkPasswordMail(arg_56_0, arg_56_1)
	local var_56_0 = Postbox:getMail(arg_56_0.selected_mail)
	
	if not var_56_0 then
		return false, nil
	end
	
	local var_56_1
	
	if var_56_0.pr then
		var_56_1 = string.lower(Base64.decode(var_56_0.pr))
	end
	
	if var_56_1 and string.len(tostring(var_56_1)) > 0 then
		local var_56_2 = arg_56_1:getParent():getChildByName("txt_name_input")
		
		if get_cocos_refid(var_56_2) then
			local var_56_3 = string.lower(string.trim(tostring(var_56_2:getString())))
			
			if var_56_3 == var_56_1 then
				return true, var_56_3
			end
		end
		
		balloon_message_with_sound("mail_invalid_password_msg")
		
		return false, nil
	end
	
	return true, nil
end

function Postbox.queryReadMail(arg_57_0, arg_57_1)
	local var_57_0 = Postbox:getMail(arg_57_0.selected_mail)
	
	if not var_57_0 then
		return 
	end
	
	arg_57_1 = arg_57_1 or {}
	
	local var_57_1 = DB("item_special", var_57_0.i, "type")
	
	if var_57_1 and var_57_1 == "option" then
		PostboxOptionSelector:show(arg_57_0.vars.wnd, var_57_0.i)
		
		return 
	elseif var_57_0.i == "ma_coupon_name" then
		UserNickName:popupNickname(nil, nil, function(arg_58_0)
			arg_57_0:changeNicknameCallback(arg_58_0)
		end)
		
		return 
	elseif var_57_1 and var_57_1 == "gacha_select" then
		query("select_pool_list", {
			caller = "postbox",
			item = var_57_0.i
		})
		
		return 
	end
	
	arg_57_1.idx = arg_57_0.selected_mail
	
	query("read_mail", arg_57_1)
end

function Postbox.changeNicknameCallback(arg_59_0, arg_59_1)
	if arg_59_1 then
		query("read_mail", {
			idx = Postbox.selected_mail,
			nickname = arg_59_1
		})
	end
end

function Postbox.readAllMail(arg_60_0)
	arg_60_0.selected_mail = {}
	
	local var_60_0 = ""
	
	for iter_60_0, iter_60_1 in pairs(arg_60_0.List or {}) do
		if not iter_60_1.et or iter_60_1.et > os.time() then
			local var_60_1 = DB("item_special", iter_60_1.i, "type")
			local var_60_2 = not var_60_1 or var_60_1 ~= "account_skill" and var_60_1 ~= "randombox" and var_60_1 ~= "cheat" and var_60_1 ~= "package" and var_60_1 ~= "option" and var_60_1 ~= "gacha_select" and var_60_1 ~= "promotion_list"
			local var_60_3 = iter_60_1.i ~= "to_pvphonor" and iter_60_1.i ~= "pvphonor" and iter_60_1.i ~= "to_pvphonor2" and iter_60_1.i ~= "pvphonor2" and iter_60_1.i ~= "ma_coupon_name"
			local var_60_4 = DB("character", iter_60_1.i, "type")
			
			if (not var_60_4 or var_60_4 ~= "character" and var_60_4 ~= "limited") and var_60_3 and var_60_2 and arg_60_0:checkInventoryMailForMulti(iter_60_1) and iter_60_1.mc ~= "E" then
				if string.len(var_60_0) > 0 then
					var_60_0 = var_60_0 .. ","
				end
				
				var_60_0 = var_60_0 .. iter_60_1.id
				
				table.push(arg_60_0.selected_mail, iter_60_1.id)
			end
		else
			arg_60_0:removeMail(iter_60_1.id)
		end
	end
	
	if #var_60_0 == 0 then
		arg_60_0:updateNewMark()
		balloon_message_with_sound("mail_no")
	else
		query("read_mail", {
			idx = var_60_0
		})
		
		if arg_60_0.vars.portrait then
			UIUtil:playNPCSoundRandomly("mail.getmail")
		end
	end
end

function Postbox.openEventBanner(arg_61_0, arg_61_1)
	if arg_61_1.event_web_address then
		if arg_61_1.event_id then
			local var_61_0 = "custom_web_event_noti"
			local var_61_1 = SAVE:getKeep(var_61_0, {})
			
			var_61_1[tostring(arg_61_1.event_id)] = 1
			
			SAVE:setKeep(var_61_0, var_61_1)
			if_set_visible(arg_61_1:getParent(), "icon_noti", false)
			TopBarNew:updateMailMark()
		end
		
		local var_61_2 = os.time()
		
		if to_n(arg_61_1.end_tm) > 0 and var_61_2 < to_n(arg_61_1.end_tm) then
			movetoPath(arg_61_1.event_web_address)
		end
	end
	
	if arg_61_1.event_link then
		if arg_61_1.event_id then
			SAVE:set("web_indicator" .. arg_61_1.event_id, AccountData.server_time.today_day_id)
			if_set_visible(arg_61_1:getParent(), "icon_noti", false)
		end
		
		movetoPath(arg_61_1.event_link)
	end
end

function Postbox._testClearNoti(arg_62_0, arg_62_1)
	SAVE:setKeep("custom_web_event_noti", {})
end

function Postbox.updateEventBannerCustom(arg_63_0, arg_63_1, arg_63_2, arg_63_3)
	arg_63_3 = arg_63_3 or {}
	
	local var_63_0 = arg_63_3.info
	local var_63_1 = arg_63_1:getChildByName("n_banner")
	local var_63_2 = var_63_1:getChildByName("btn_banner")
	
	if var_63_0.event_web_address then
		var_63_2.event_id = arg_63_3.event_id
		var_63_2.event_web_address = var_63_0.event_web_address
		var_63_2.end_tm = arg_63_3.issued_data.end_tm
	end
	
	local var_63_3 = var_63_0["banner_" .. getUserLanguage()] or var_63_0.banner_en
	
	if var_63_3 == "a" then
		var_63_3 = "https://d382nwn6r8hxt6.cloudfront.net/QA_group/qa_banner/E7_20071602_KR.png"
	end
	
	local var_63_4 = cc.Sprite:create(var_63_3)
	
	if var_63_4 and get_cocos_refid(var_63_4) then
		var_63_4:setAnchorPoint(0, 0)
		var_63_1:getChildByName("img_banner"):addChild(var_63_4)
	end
	
	local var_63_5 = "custom_web_event_noti"
	local var_63_6 = SAVE:getKeep(var_63_5, {})
	
	if_set_visible(var_63_1, "icon_noti", to_n(var_63_6[tostring(arg_63_3.event_id)]) ~= 1)
	
	local var_63_7 = var_63_1:getChildByName("n_special")
	
	var_63_7:setVisible(true)
	EffectManager:Play({
		fn = "ui_event_point_loop.cfx",
		layer = var_63_7:getChildByName("n_eff_loop")
	})
	UIAction:Add(LOOP(SEQ(CALL(function()
		EffectManager:Play({
			fn = "ui_event_point_eff.cfx",
			layer = var_63_7:getChildByName("n_eff")
		})
	end), DELAY(8000))), var_63_7, "event_point_eff")
	
	local var_63_8 = arg_63_1:getChildByName("n_time")
	local var_63_9 = arg_63_3.issued_data
	
	if_set(var_63_8, "txt_period", T("time_slash_y_m_d", timeToStringDef({
		preceding_with_zeros = true,
		time = var_63_9.created_tm
	})) .. " - " .. T("time_slash_y_m_d", timeToStringDef({
		preceding_with_zeros = true,
		time = var_63_9.end_tm
	})))
	
	local var_63_10 = var_63_9.end_tm - os.time()
	
	if var_63_10 > 0 then
		if_set(var_63_8, "txt_date", T("time_remain", {
			time = sec_to_string(var_63_10)
		}))
	else
		if_set(var_63_8, "txt_date", T("expired"))
	end
end

function Postbox.updateEventBannerWebEvent(arg_65_0, arg_65_1, arg_65_2, arg_65_3)
	local var_65_0 = arg_65_1:getChildByName("n_banner")
	local var_65_1 = var_65_0:getChildByName("btn_banner")
	
	if arg_65_3.link then
		var_65_1.event_id = arg_65_3.id
		var_65_1.event_link = arg_65_3.link
		var_65_1.end_tm = arg_65_3.end_time
	end
	
	if arg_65_3.id then
		local var_65_2 = not (SAVE:get("web_indicator" .. arg_65_3.id, 0) == AccountData.server_time.today_day_id) and arg_65_3.indicator
		
		if_set_visible(var_65_0, "icon_noti", var_65_2)
	end
	
	arg_65_3.img = UIUtil:translateByLang(arg_65_3.img)
	
	local var_65_3 = totable(arg_65_3.img)
	local var_65_4 = cc.Sprite:create(var_65_3.banner)
	
	if var_65_4 and get_cocos_refid(var_65_4) then
		var_65_4:setAnchorPoint(0, 0)
		var_65_0:getChildByName("img_banner"):addChild(var_65_4)
	end
	
	local var_65_5 = arg_65_1:getChildByName("n_time")
	
	if_set(var_65_5, "txt_period", T("time_slash_y_m_d", timeToStringDef({
		preceding_with_zeros = true,
		time = arg_65_3.start_time
	})) .. " - " .. T("time_slash_y_m_d", timeToStringDef({
		preceding_with_zeros = true,
		time = arg_65_3.end_time
	})))
	
	local var_65_6 = arg_65_3.end_time - os.time()
	
	if var_65_6 > 0 then
		if_set(var_65_5, "txt_date", T("time_remain", {
			time = sec_to_string(var_65_6)
		}))
	else
		if_set(var_65_5, "txt_date", T("expired"))
	end
end

function Postbox.updateEventSide(arg_66_0)
	local var_66_0 = arg_66_0.wnd:getChildByName("n_promotion")
	
	if not get_cocos_refid(var_66_0) then
		return 
	end
	
	var_66_0:setVisible(true)
	
	local var_66_1 = var_66_0:getChildByName("listview")
	local var_66_2 = ItemListView_v2:bindControl(var_66_1)
	local var_66_3 = load_control("wnd/mail_event_item.csb")
	
	if var_66_1.STRETCH_INFO then
		local var_66_4 = var_66_1:getContentSize()
		
		resetControlPosAndSize(var_66_3, var_66_4.width, var_66_1.STRETCH_INFO.width_prev)
	end
	
	local var_66_5 = {
		onUpdate = function(arg_67_0, arg_67_1, arg_67_2, arg_67_3)
			if arg_67_3.event_id and arg_67_3.issued_data then
				arg_66_0:updateEventBannerCustom(arg_67_1, arg_67_2, arg_67_3)
			else
				arg_66_0:updateEventBannerWebEvent(arg_67_1, arg_67_2, arg_67_3)
			end
		end
	}
	
	var_66_2:setRenderer(var_66_3, var_66_5)
	var_66_2:removeAllChildren()
	
	local var_66_6 = os.time()
	local var_66_7 = {}
	
	for iter_66_0, iter_66_1 in pairs(AccountData.banners) do
		if to_n(iter_66_1.mail_expose) == 1 and var_66_6 < to_n(iter_66_1.end_time) then
			table.push(var_66_7, iter_66_1)
		end
	end
	
	var_66_2:setDataSource(var_66_7)
end

function MsgHandler.test_stove_custom_webevent(arg_68_0)
	table.print(arg_68_0)
end

function Postbox.test_custom_web_event(arg_69_0, arg_69_1)
	query("test_stove_custom_webevent", {
		event_id = arg_69_1
	})
end

PostboxOptionSelector = {}

copy_functions(ScrollView, PostboxOptionSelector)

function HANDLER.mail_select_popup(arg_70_0, arg_70_1)
	if arg_70_1 == "btn_cancel" then
		PostboxOptionSelector:close()
	elseif arg_70_1 == "btn_yes" then
		PostboxOptionSelector:confirmSelect()
	elseif string.starts(arg_70_1, "btn_select:") then
		PostboxOptionSelector:selectItem(arg_70_1)
	end
end

function PostboxOptionSelector.close(arg_71_0)
	Dialog:close("mail_select_popup")
	
	arg_71_0.vars = nil
end

function PostboxOptionSelector.show(arg_72_0, arg_72_1, arg_72_2)
	arg_72_0.vars = {}
	arg_72_0.vars.parent = arg_72_1
	arg_72_0.vars.selected_index = nil
	arg_72_0.vars.option_item_special_id = arg_72_2
	arg_72_0.vars.wnd = Dialog:open("wnd/mail_select_popup", arg_72_0)
	
	arg_72_0.vars.parent:addChild(arg_72_0.vars.wnd)
	if_set(arg_72_0.vars.wnd, "text_selected", T("package_selected_option_none"))
	if_set_opacity(arg_72_0.vars.wnd, "btn_yes", 127.5)
	
	local var_72_0 = arg_72_0.vars.wnd:getChildByName("scrollview")
	
	arg_72_0.vars.itemView = ItemListView_v2:bindControl(var_72_0)
	
	local var_72_1 = load_control("wnd/mail_select_popup_item.csb")
	
	if var_72_0.STRETCH_INFO then
		local var_72_2 = var_72_0:getContentSize()
		
		resetControlPosAndSize(var_72_1, var_72_2.width, var_72_0.STRETCH_INFO.width_prev)
	end
	
	local var_72_3 = {
		onUpdate = function(arg_73_0, arg_73_1, arg_73_2, arg_73_3)
			PostboxOptionSelector:updateItem(arg_73_1, arg_73_3)
			
			return arg_73_3.id
		end,
		onTouchUp = function(arg_74_0, arg_74_1, arg_74_2, arg_74_3, arg_74_4)
			return true
		end
	}
	
	arg_72_0.vars.itemView:setRenderer(var_72_1, var_72_3)
	arg_72_0.vars.itemView:removeAllChildren()
	
	local var_72_4 = {}
	
	var_72_4.id, var_72_4.type, var_72_4.name, var_72_4.icon, var_72_4.value, var_72_4.desc = DB("item_special", arg_72_0.vars.option_item_special_id, {
		"id",
		"type",
		"name",
		"icon",
		"value",
		"desc"
	})
	
	local var_72_5 = {}
	
	for iter_72_0 = 1, 99999 do
		local var_72_6 = {}
		
		var_72_6.id, var_72_6.item_special_value, var_72_6.item_id, var_72_6.value = DBN("option", iter_72_0, {
			"id",
			"item_special_value",
			"item_id",
			"value"
		})
		
		if not var_72_6.id then
			break
		end
		
		if var_72_6.item_special_value == var_72_4.value then
			local var_72_7 = {}
			
			var_72_7.id, var_72_7.type, var_72_7.name, var_72_7.icon, var_72_7.value, var_72_7.desc = DB("item_special", var_72_6.item_id, {
				"id",
				"type",
				"name",
				"icon",
				"value",
				"desc"
			})
			var_72_6.item_special_db = var_72_7
			
			table.push(var_72_5, var_72_6)
		end
	end
	
	var_72_4.option_db = var_72_5
	arg_72_0.vars.sp_db = var_72_4
	
	arg_72_0.vars.itemView:setDataSource(var_72_5)
end

function PostboxOptionSelector.updateItem(arg_75_0, arg_75_1, arg_75_2)
	local var_75_0 = arg_75_2.item_special_db
	
	if_set(arg_75_1, "txt_name", T(arg_75_0.vars.sp_db.name))
	if_set(arg_75_1, "txt_desc", T(var_75_0.name))
	set_scale_fit_width(arg_75_1:getChildByName("txt_name"), 225)
	set_scale_fit_width(arg_75_1:getChildByName("txt_desc"), 215)
	UIUtil:getRewardIcon(nil, var_75_0.id, {
		parent = arg_75_1:getChildByName("item")
	})
	if_set_visible(arg_75_1, "bg_select", false)
	arg_75_1:getChildByName("btn_select"):setName("btn_select:" .. var_75_0.id)
	
	arg_75_1.item = arg_75_2
	
	return arg_75_1
end

function PostboxOptionSelector.selectItem(arg_76_0, arg_76_1)
	local var_76_0 = string.split(arg_76_1, ":")
	
	if var_76_0[1] ~= "btn_select" or var_76_0[2] == nil then
		return 
	end
	
	local var_76_1 = 0
	
	for iter_76_0, iter_76_1 in pairs(arg_76_0.vars.sp_db.option_db) do
		if iter_76_1.item_id == var_76_0[2] then
			var_76_1 = iter_76_0
			
			break
		end
	end
	
	if var_76_1 == 0 then
		return 
	end
	
	arg_76_0.vars.selected_index = var_76_1
	
	local var_76_2 = arg_76_0.vars.sp_db.option_db[var_76_1]
	
	if not var_76_2 then
		return 
	end
	
	local var_76_3 = var_76_2.item_special_db
	
	if_set(arg_76_0.vars.wnd, "text_selected", T("package_selected_option", {
		check = T(var_76_3.name)
	}))
	if_set_opacity(arg_76_0.vars.wnd, "btn_yes", 255)
	arg_76_0:updateSelected()
end

function PostboxOptionSelector.updateSelected(arg_77_0)
	arg_77_0.vars.itemView:enumControls(function(arg_78_0)
		if_set_visible(arg_78_0, "bg_select", false)
		
		if arg_78_0 and arg_78_0.item then
			local var_78_0 = arg_77_0.vars.sp_db.option_db[arg_77_0.vars.selected_index]
			
			if var_78_0 and var_78_0.id == arg_78_0.item.id then
				if_set_visible(arg_78_0, "bg_select", true)
			end
		end
	end)
end

function PostboxOptionSelector.confirmSelect(arg_79_0)
	if not arg_79_0.vars.selected_index then
		balloon_message_with_sound("msg_option_no_select")
		
		return 
	end
	
	Dialog:close("mail_select_popup")
	
	if not Postbox:getMail(Postbox.selected_mail) then
		return 
	end
	
	local var_79_0 = arg_79_0.vars.sp_db.option_db[arg_79_0.vars.selected_index]
	
	if not var_79_0 then
		return 
	end
	
	query("read_mail", {
		idx = Postbox.selected_mail,
		oid = var_79_0.id
	})
end
