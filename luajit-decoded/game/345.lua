UnitDetail = {}
UnitDetailTabMode = {
	"Growth",
	"Equip",
	"Profile",
	"Story"
}

function HANDLER.unit_detail(arg_1_0, arg_1_1)
	if string.find(arg_1_1, "btn_main_tab_") then
		if not arg_1_0.is_enable then
			balloon_message_with_sound("no_detail_info")
			
			return 
		end
		
		local var_1_0 = string.len("btn_main_tab_")
		local var_1_1 = string.sub(arg_1_1, var_1_0 + 1, -1)
		local var_1_2 = UnitDetail.vars.unit
		
		if not var_1_2 then
			return 
		end
		
		UnitDetail:setMode(var_1_1, {
			unit = var_1_2
		})
	end
	
	if arg_1_1 == "btn_background" then
		UnitDetailGrowth:showBGPacks()
		
		return 
	end
	
	if arg_1_1 == "btn_bg_close" then
		UnitDetailGrowth:closeBGPacks()
		
		return 
	end
	
	if arg_1_1 == "btn_lock" or arg_1_1 == "btn_locked" then
		UnitDetailGrowth:reqToggleLock()
		
		return 
	end
	
	if arg_1_1 == "btn_main" then
		UnitDetailGrowth:setMainUnit()
		
		return 
	end
	
	if arg_1_1 == "btn_main_done" then
		balloon_message_with_sound("unit_detail_main_char_still")
		
		return 
	end
	
	if arg_1_1 == "btn_info" then
		local var_1_3 = UnitDetail:getUnit()
		
		if not var_1_3 then
			return 
		end
		
		if var_1_3:isGrowthBoostRegistered() then
			UnitDetailGrowth:openGrowthBoostTooltip()
			
			return 
		end
		
		UnitDetailGrowth:openMoonlightDestinyTooltip()
		
		return 
	end
	
	if arg_1_1 == "btn_equip" then
		if UnitDetail.vars.changed_unit then
			return 
		end
		
		if UnitDetail.vars and UnitDetail.vars.unit ~= nil then
			if not UnitDetail.vars.unit:isOrganizable() then
				balloon_message_with_sound("cant_equips")
				
				return 
			else
				UnlockSystem:isUnlockSystemAndMsg({
					exclude_story = true,
					id = UNLOCK_ID.TUTORIAL_EQUIP
				}, function()
					UnitMain:setMode("Build", {
						unit = UnitDetail.vars.unit
					})
				end)
			end
		end
	elseif arg_1_1 == "btn_unequip" then
		UnitDetailEquip:onUnEquip()
	end
	
	if string.find(arg_1_1, "btn_tab_profile") then
		local var_1_4 = string.len("btn_tab_profile")
		local var_1_5 = tonumber(string.sub(arg_1_1, var_1_4 + 1, -1))
		
		UnitDetailProfile:setMode(var_1_5)
	end
	
	if arg_1_1 == "btn_present" then
		UnitDetailProfile:openPresent()
		
		return 
	end
	
	if arg_1_1 == "btn_voice_nosound" then
		UnitDetailProfile:playVoice(arg_1_0)
		
		return 
	end
	
	if arg_1_1 == "btn_face" then
		UnitDetailProfile.intimacy_list:setEmotion(arg_1_0)
		
		return 
	end
	
	if arg_1_1 == "btn_special_record" then
		do return  end
		
		if arg_1_0:getOpacity() < 255 then
			balloon_message_with_sound("msg_awake_special_illust_lock")
			
			return 
		end
		
		if arg_1_0.story_id and arg_1_0.illust_id then
			UnitDetailProfile:startSpecialRecord(arg_1_0.story_id, arg_1_0.illust_id)
		end
		
		return 
	end
	
	if arg_1_1 == "btn_zoom" then
		if UnitDetail.vars.changed_unit then
			return 
		end
		
		UnitMain:setMode("Zoom", {
			unit = UnitDetail.vars.unit
		})
	end
	
	if arg_1_1 == "btn_skin" or arg_1_1 == "btn_closet_close" then
		if arg_1_0:getOpacity() < 255 then
			balloon_message_with_sound("ui_skin_none")
			
			return 
		end
		
		UnitDetailProfile:toggleSkinMode()
	end
	
	if arg_1_1 == "btn_sel_skin" then
		UnitDetailProfile:selectSkin(arg_1_0)
	end
	
	if arg_1_1 == "btn_wearing" then
		UnitDetailProfile:wearSkin()
	end
	
	if arg_1_1 == "btn_buy" then
		UnitDetailProfile:buySkin()
	end
	
	if arg_1_1 == "btn_cur" then
		UnitDetailStory:selectGeneration(UnitDetailStory:getCurGeneration(), "next")
	elseif arg_1_1 == "btn_pre" then
		UnitDetailStory:selectGeneration(UnitDetailStory:getCurGeneration(), "pre")
	end
	
	if arg_1_1 == "btn_storylist" then
		local var_1_6 = UnitDetailStory:getSelectedItem() or {}
		
		SubStoryEntrance:show("SYSTEM_STORY", nil, nil, {
			id = var_1_6.id
		})
	elseif arg_1_1 == "btn_book" then
		Dialog:msgBox(T("collection_move"), {
			yesno = true,
			handler = function()
				local var_3_0 = {
					mode = "story",
					parent_id = "story7",
					select_item = UnitDetailStory:getSelectedItem()
				}
				
				if not Account:checkQueryEmptyDungeonData("collection", var_3_0) then
					SceneManager:reserveResetSceneFlow()
					SceneManager:nextScene("collection", var_3_0)
				end
			end
		})
	end
	
	if arg_1_1 == "btn_dedi" or arg_1_1 == "btn_dedi2" then
		if UnitDetail.vars.changed_unit then
			return 
		end
		
		DevoteTooltip:showDevoteDetail(UnitDetail.vars.unit, UnitDetail.vars.wnd)
	end
	
	if arg_1_1 == "btn_guide" then
		UnitGuide:open({
			code = UnitDetail.vars.unit.inst.code
		})
	end
	
	if arg_1_1 == "btn_skill" then
		if UnitDetail.vars.changed_unit then
			return 
		end
		
		if not UnitDetail.vars then
			return 
		end
		
		local var_1_7 = UnitDetail.vars.unit
		
		if not var_1_7 then
			return 
		end
		
		if var_1_7:isSpecialUnit() or var_1_7:isPromotionUnit() or var_1_7:isDevotionUnit() then
			balloon_message_with_sound("cant_skill_upgrade")
			
			return 
		end
		
		if var_1_7:isLockSkillUpgrade() then
			balloon_message_with_sound("character_star_cannot_skill_upgrade")
			
			return 
		end
		
		if var_1_7:skillPointNoti() and not SAVE:getKeep(NOTI_UNIT_SKILL_UPGRADE .. var_1_7.inst.uid) then
			SAVE:setKeep(NOTI_UNIT_SKILL_UPGRADE .. var_1_7.inst.uid, true)
		end
		
		UnitMain:setMode("Skill", {
			unit = var_1_7
		})
	end
	
	if arg_1_1 == "btn_upgrade" then
		if UnitDetail.vars.changed_unit then
			return 
		end
		
		local var_1_8 = UnitDetail.vars.unit
		
		if not var_1_8 then
			return 
		end
		
		if arg_1_0.deactive_reason then
			balloon_message_with_sound(arg_1_0.deactive_reason)
			
			return 
		end
		
		UnitMain:setMode("Upgrade", {
			unit = var_1_8
		})
	end
	
	if arg_1_1 == "btn_transfer" then
		local var_1_9, var_1_10 = UnitDetail:isModeChangeable()
		
		if not var_1_9 then
			if var_1_10 then
				balloon_message_with_sound(var_1_10)
			end
			
			return 
		end
		
		UnitMain:setMode("Sell", {
			unit = UnitDetail.vars.unit
		})
		
		return 
	end
	
	if arg_1_1 == "btn_unfold" then
		UnitMain:setMode("Unfold", {
			unit = UnitDetail.vars.unit
		})
		
		return 
	end
	
	if arg_1_1 == "btn_rate" then
		if UnitDetail.vars.changed_unit then
			return 
		end
		
		Review:open({
			open_on_detail = true,
			code = UnitDetail.vars.unit.inst.code,
			uid = UnitDetail.vars.unit:getUID()
		})
	end
	
	if arg_1_1 == "btn_zodiac" then
		if UnitDetail.vars.changed_unit then
			return 
		end
		
		local var_1_11 = UnitDetail:getUnit()
		
		if not var_1_11 then
			return 
		end
		
		if not var_1_11:checkZodiac() then
			balloon_message_with_sound("no_zodiac")
			
			return 
		end
		
		UnlockSystem:isUnlockSystemAndMsg({
			exclude_story = true,
			id = UNLOCK_ID.ZODIAC
		}, function()
			if UnitInfosUtil:isEnableAwake(var_1_11) then
				UnitMain:setMode("Zodiac", {
					enter_mode = "Potential",
					unit = var_1_11
				})
			else
				UnitMain:setMode("Zodiac", {
					unit = var_1_11
				})
			end
		end)
	end
	
	if arg_1_1 == "btn_lv_up" then
		if UnitDetail.vars.changed_unit then
			return 
		end
		
		local var_1_12 = UnitDetail.vars.unit
		
		if not var_1_12 then
			return 
		end
		
		if not arg_1_0.active_flag then
			if arg_1_0.deactive_reason then
				balloon_message_with_sound(arg_1_0.deactive_reason)
			else
				balloon_message_with_sound("cant_upgrade")
			end
			
			return 
		elseif var_1_12:isDevotionUnit() then
			balloon_message_with_sound("cant_upgrade")
			
			return 
		elseif var_1_12:isExpUnit() then
			balloon_message_with_sound("cant_upgrade")
			
			return 
		elseif BackPlayManager:isRunning() and BackPlayManager:isInBackPlayTeam(var_1_12:getUID()) then
			balloon_message_with_sound("msg_bgbattle_cant_levelup")
			
			return 
		end
		
		if UnitDetail.vars.unit:isMaxLevel() then
			if var_1_12:isMaxLevel() and var_1_12:isLockUpgrade6() then
				balloon_message_with_sound("character_star_cannot_grade_upgrade")
				
				return 
			end
			
			if UnitDetail.vars.unit:getGrade() >= 6 then
				balloon_message_with_sound("max_level")
				
				return 
			end
			
			UnitMain:setMode("NewPromote", {
				unit = var_1_12
			})
		else
			UnitMain:setMode("LevelUp", {
				unit = UnitDetail.vars.unit
			})
		end
	end
	
	if string.starts(arg_1_1, "btn_item") then
		UnitDetailEquip:openEquipDialog(tonumber(string.sub(arg_1_1, -1, -1)))
	end
	
	if arg_1_1 == "btn_recall" then
		if UnitDetail.vars.changed_unit then
			return 
		end
		
		UnitDetailGrowth:requestPreviewRecallUnit()
	end
	
	if arg_1_1 == "btn_bulk_up" then
		local var_1_13, var_1_14 = UnitDetail:isModeChangeable()
		
		if not var_1_13 then
			if var_1_14 then
				balloon_message_with_sound(var_1_14)
			end
			
			return 
		end
		
		UnlockSystem:isUnlockSystemAndMsg({
			exclude_story = true,
			id = UNLOCK_ID.MULTI_PROMOTE
		}, function()
			if not UnitDetail:isMultiPromoteEnable() then
				balloon_message_with_sound("ui_bulkup_disable")
				
				return 
			end
			
			UnitMain:setMode("MultiPromote", {
				start_unit = UnitDetail.vars.unit
			})
		end)
	end
	
	if arg_1_1 == "btn_moonlight_destiny" then
		if MoonlightDestiny:isUnlockSeason() then
			SceneManager:nextScene("moonlight_destiny", {})
			SoundEngine:play("event:/ui/whoosh_a")
		end
		
		return 
	end
	
	if arg_1_1 == "btn_cancel" then
		UnitDetailGrowth:closeMoonlightDestinyTooltip()
		UnitDetailGrowth:closeGrowthBoostTooltip()
		
		return 
	end
	
	if arg_1_1 == "btn_info_material" then
		UnitDetail:openMerEnhanceTooltip()
		
		return 
	end
	
	if arg_1_1 == "btn_preview_skills" then
		UnitInfosDetail:showSkillPreview()
		
		return 
	end
	
	if arg_1_1 == "btn_expressions" then
		UnitInfosDetail:onButtonEmotion()
		
		return 
	end
	
	if arg_1_1 == "btn_show_stat" then
		UnitInfosDetail:showStatPreview()
		
		return 
	end
	
	if arg_1_1 == "btn_classchange" then
		UnitDetail:openSkillTreeInfo()
		
		return 
	end
	
	if arg_1_1 == "btn_favorites" or arg_1_1 == "btn_favorites_done" then
		UnitDetailGrowth:reqToggleFavorite()
		
		return 
	end
	
	if arg_1_1 == "btn_visible_off" then
		UnitInfosDetail:hideEquip(true)
		
		return 
	end
	
	if arg_1_1 == "btn_visible_on" then
		UnitInfosDetail:hideEquip(false)
		
		return 
	end
	
	if arg_1_1 == "add_inven" then
		UIUtil:showIncHeroInvenDialog()
		
		return 
	end
	
	if arg_1_1 == "btn_share" then
		UnitDetailGrowth:shareUnit()
		
		return 
	end
	
	if arg_1_1 == "btn_close_share" then
		ShareChatPopup:close()
		
		return 
	end
	
	if arg_1_1 == "btn_blessing_go" then
		GrowthBoostUI:show()
	end
end

function MsgHandler.recall_unit_preview(arg_6_0)
	if arg_6_0.reward_confirm then
		UnitDetailGrowth:previewRecallUnit(arg_6_0.reward_confirm)
	end
end

function MsgHandler.recall_unit(arg_7_0)
	UnitDetailGrowth:processRecallUnit(arg_7_0)
end

function UnitDetail.onPushBackground(arg_8_0)
end

function UnitDetail.openSkillTreeInfo(arg_9_0)
	local var_9_0 = arg_9_0.vars.unit
	
	if not var_9_0 then
		return 
	end
	
	local var_9_1 = var_9_0:isClassChangeableUnit()
	
	if not var_9_1 then
		return 
	end
	
	local var_9_2 = EpisodeAdin:isAdinCode(var_9_0.db.code) and UnitExtensionSkillList or ClassChangeSkillList
	local var_9_3 = ClassChange:openInfoPopup(var_9_2, SceneManager:getRunningPopupScene(), "ui_classchange_list_skill", var_9_1)
	
	if not get_cocos_refid(var_9_3) then
		return 
	end
	
	if var_9_1 ~= var_9_0.db.code then
		local var_9_4 = var_9_3:getChildByName("btn_skilltree")
		
		if get_cocos_refid(var_9_4) then
			var_9_4:setVisible(true)
			var_9_4:addTouchEventListener(function(arg_10_0, arg_10_1)
				if arg_10_1 ~= 2 then
					return 
				end
				
				ClassChange.open_popup:removeFromParent()
				BackButtonManager:pop("classchange.popup")
				UnitMain:setMode("Zodiac", {
					enter_mode = "Rune",
					unit = arg_9_0.vars.unit
				})
			end)
		end
		
		UIUserData:call(var_9_3:getChildByName("n_title"), "SINGLE_WSCALE(367)")
	else
		local var_9_5 = var_9_3:getChildByName("listview")
		
		var_9_5:setContentSize({
			height = 440,
			width = var_9_5:getContentSize().width
		})
		if_set_visible(var_9_3, "n_info", true)
	end
end

function UnitDetail.onCreate(arg_11_0, arg_11_1)
	if not arg_11_0.vars or not get_cocos_refid(arg_11_0.vars.wnd) then
		arg_11_0.vars = {}
		arg_11_0.vars.changed_tm_delay = 500
		arg_11_0.vars.touch_tick_delay = 1000
		arg_11_0.vars.wnd = load_dlg("unit_detail", true, "wnd")
		
		arg_11_0.vars.wnd:setLocalZOrder(1)
		UnitMain.vars.base_wnd:addChild(arg_11_0.vars.wnd)
	end
	
	arg_11_0.vars.hero_belt = HeroBelt:getInst("UnitMain")
	arg_11_0.vars.pvp_mode = arg_11_1.pvp_mode
	
	local var_11_0 = arg_11_1.unit
	
	if arg_11_1.unit_uid then
		var_11_0 = var_11_0 or Account:getUnit(arg_11_1.unit_uid)
	end
	
	arg_11_0.vars.unit = var_11_0
	arg_11_0.vars.mode = {
		Growth = UnitDetailGrowth,
		Equip = UnitDetailEquip,
		Profile = UnitDetailProfile,
		Story = UnitDetailStory
	}
	
	local var_11_1 = {
		detail_wnd = arg_11_0.vars.wnd
	}
	
	for iter_11_0, iter_11_1 in pairs(arg_11_0.vars.mode) do
		if iter_11_1.onCreate and type(iter_11_1.onCreate) == "function" then
			iter_11_1:onCreate(var_11_1)
		end
	end
	
	if table.empty(arg_11_0.vars.mode_tabs) then
		arg_11_0.vars.mode_tabs = {}
		
		local var_11_2 = arg_11_0.vars.wnd:getChildByName("n_main_tab")
		
		if get_cocos_refid(var_11_2) then
			local var_11_3 = var_11_2:getChildByName("n_tab")
			
			if get_cocos_refid(var_11_3) then
				for iter_11_2, iter_11_3 in pairs(var_11_3:getChildren()) do
					if get_cocos_refid(iter_11_3) then
						local var_11_4 = iter_11_3:getName()
						local var_11_5 = string.len("n_tab")
						local var_11_6 = tonumber(string.sub(var_11_4, var_11_5 + 1, -1))
						
						if var_11_6 then
							local var_11_7 = UnitDetailTabMode[var_11_6]
							
							iter_11_3:setName("n_tab_" .. (var_11_7 or ""))
							
							local var_11_8 = iter_11_3:getChildByName("btn_main_tab" .. var_11_6)
							
							if get_cocos_refid(var_11_8) then
								var_11_8:setName("btn_main_tab_" .. (var_11_7 or ""))
								
								var_11_8.is_enable = true
								arg_11_0.vars.mode_tabs[var_11_7] = var_11_8
							end
						end
					end
				end
			end
		end
	end
	
	arg_11_0.vars.ui_right = arg_11_0.vars.wnd:getChildByName("RIGHT")
	
	if_set_visible(arg_11_0.vars.ui_right, nil, false)
	
	arg_11_0.vars.n_main_tab = arg_11_0.vars.wnd:getChildByName("n_main_tab")
	
	if_set_opacity(arg_11_0.vars.ui_right, nil, 0)
end

function UnitDetail.setMode(arg_12_0, arg_12_1, arg_12_2)
	if not arg_12_0.vars or not get_cocos_refid(arg_12_0.vars.wnd) or table.empty(arg_12_0.vars.mode) then
		return 
	end
	
	arg_12_2 = arg_12_2 or {}
	arg_12_1 = arg_12_1 or "Growth"
	
	local var_12_0
	
	if arg_12_0.vars.cur_detail_mode then
		if arg_12_0.vars.cur_detail_mode == arg_12_1 then
			return 
		else
			local var_12_1 = arg_12_0.vars.mode[arg_12_0.vars.cur_detail_mode]
			
			if var_12_1 and var_12_1.onLeave and type(var_12_1.onLeave) == "function" then
				var_12_1:onLeave()
			end
		end
	end
	
	arg_12_0.vars.cur_detail_mode = arg_12_1
	
	arg_12_0:updateBg(arg_12_1)
	arg_12_0:updateHeroBelt(arg_12_1)
	arg_12_0:updateModeTab(arg_12_1)
	arg_12_0:saveLastMode(arg_12_1)
	
	local var_12_2 = arg_12_0.vars.mode[arg_12_1]
	
	if var_12_2 and var_12_2.onEnter and type(var_12_2.onEnter) == "function" then
		var_12_2:onEnter()
		UnitMain:onSelectUnit(arg_12_2.unit or arg_12_0.vars.unit)
	end
end

function UnitDetail.getCurDetailMode(arg_13_0)
	if not arg_13_0.vars or not get_cocos_refid(arg_13_0.vars.wnd) then
		return 
	end
	
	return arg_13_0.vars.cur_detail_mode
end

function UnitDetail.getPrevDetailMode(arg_14_0)
	if not arg_14_0.vars or not get_cocos_refid(arg_14_0.vars.wnd) then
		return 
	end
	
	return arg_14_0.vars.prev_detail_mode
end

function UnitDetail.updateModeTab(arg_15_0, arg_15_1)
	if not arg_15_0.vars or not get_cocos_refid(arg_15_0.vars.wnd) then
		return 
	end
	
	arg_15_1 = arg_15_1 or "Growth"
	
	local var_15_0 = arg_15_0.vars.wnd:getChildByName("n_main_tab")
	
	if get_cocos_refid(var_15_0) then
		if get_cocos_refid(arg_15_0.vars.cur_mode_tab) then
			if_set_visible(arg_15_0.vars.cur_mode_tab, "tab_bg", false)
		end
		
		arg_15_0.vars.cur_mode_tab = var_15_0:getChildByName("n_tab_" .. arg_15_1)
		
		if_set_visible(arg_15_0.vars.cur_mode_tab, "tab_bg", true)
	end
end

function UnitDetail.updateHeroBelt(arg_16_0, arg_16_1)
	if not arg_16_0.vars or not get_cocos_refid(arg_16_0.vars.wnd) or not arg_16_0.vars.hero_belt then
		return 
	end
	
	arg_16_1 = arg_16_1 or "Growth"
	
	local var_16_0 = arg_16_0:needToShowUnitList(arg_16_1)
	
	if var_16_0 then
		arg_16_0:enterCommonUI()
	else
		arg_16_0:leaveCommonUI()
	end
	
	UnitMain:updateGrow(var_16_0)
	arg_16_0.vars.hero_belt:setVisible(var_16_0)
end

function UnitDetail.updateBg(arg_17_0, arg_17_1)
	if not arg_17_0.vars or not get_cocos_refid(arg_17_0.vars.wnd) or not UnitMain:isShow() then
		return 
	end
	
	arg_17_1 = arg_17_1 or "Growth"
	
	if UnitMain:isExistBackground() then
		if arg_17_0:isEnableBackgroundMode(arg_17_1) then
			if not UnitMain:isVisibleBackground() then
				UnitMain:fadeInBackground()
			end
		elseif UnitMain:isVisibleBackground() then
			UnitMain:fadeOutBackground()
		end
	end
end

function UnitDetail.getCurModeTab(arg_18_0)
	if not arg_18_0.vars or not get_cocos_refid(arg_18_0.vars.wnd) then
		return nil
	end
	
	return arg_18_0.vars.cur_mode_tab
end

function UnitDetail.saveLastMode(arg_19_0, arg_19_1)
	if not arg_19_1 then
		return 
	end
	
	if not arg_19_0:isEnableSaveMode(arg_19_1) then
		return 
	end
	
	SAVE:setKeep("unit_detail_mode", arg_19_1)
end

function UnitDetail.updateModeTabsState(arg_20_0, arg_20_1)
	if not arg_20_0.vars or not get_cocos_refid(arg_20_0.vars.wnd) or table.empty(arg_20_0.vars.mode_tabs) then
		return 
	end
	
	arg_20_1 = arg_20_1 or arg_20_0.vars.unit
	
	if not arg_20_1 then
		return 
	end
	
	local var_20_0 = arg_20_0.vars.wnd:getChildByName("n_main_tab")
	
	if get_cocos_refid(var_20_0) then
		for iter_20_0, iter_20_1 in pairs(arg_20_0.vars.mode_tabs) do
			if iter_20_0 and get_cocos_refid(iter_20_1) then
				if iter_20_0 == "Story" then
					iter_20_1.is_enable = arg_20_1:checkStory()
				end
				
				if_set_opacity(var_20_0, "n_tab_" .. iter_20_0, iter_20_1.is_enable and 255 or 76.5)
			end
		end
	end
end

function UnitDetail.needToShowUnitList(arg_21_0, arg_21_1)
	return arg_21_1 == "Growth" or arg_21_1 == "Equip"
end

function UnitDetail.isEnableBackgroundMode(arg_22_0, arg_22_1)
	return arg_22_1 == "Growth" or arg_22_1 == "Equip"
end

function UnitDetail.isEnableSaveMode(arg_23_0, arg_23_1)
	return arg_23_1 == "Growth" or arg_23_1 == "Equip"
end

function UnitDetail.clipUnitList(arg_24_0, arg_24_1)
	if not arg_24_0.vars or not arg_24_0.vars.hero_belt then
		return 
	end
	
	local var_24_0 = arg_24_0.vars.hero_belt:getWindow()
	local var_24_1
	local var_24_2
	local var_24_3
	
	if arg_24_1 then
		var_24_1 = arg_24_0.vars.wnd:getChildByName("n_herolist")
		var_24_2 = arg_24_0.vars.ui_right:getChildByName("n_sorting")
		var_24_3 = arg_24_0.vars.ui_right:getChildByName("add_inven")
	else
		var_24_1 = UnitMain.vars.base_wnd
		var_24_2 = var_24_0:getChildByName("n_sorting")
		var_24_3 = var_24_0:getChildByName("add_inven")
	end
	
	var_24_0:ejectFromParent()
	var_24_1:addChild(var_24_0)
	arg_24_0.vars.hero_belt:changeSorterParent(var_24_2, true)
	arg_24_0.vars.hero_belt:changeCountParent(var_24_3)
	arg_24_0.vars.hero_belt:updateHeroCount()
end

function UnitDetail.getSceneState(arg_25_0)
	if not arg_25_0.vars then
		return {}
	end
	
	return {
		unit_uid = arg_25_0.vars.unit:getUID(),
		detail_mode = arg_25_0.vars.cur_detail_mode
	}
end

function UnitDetail.onEnter(arg_26_0, arg_26_1, arg_26_2)
	if not arg_26_0.vars or not get_cocos_refid(arg_26_0.vars.wnd) then
		return 
	end
	
	if get_cocos_refid(arg_26_0.vars.n_main_tab) then
		UIAction:Add(SEQ(FADE_IN(200), SHOW(true)), arg_26_0.vars.n_main_tab, "block")
	end
	
	arg_26_0.vars.hero_belt:changeMode("Detail")
	SoundEngine:play("event:/ui/hero_story")
	
	arg_26_0.vars.prev_mode = arg_26_1
	
	local var_26_0 = false
	local var_26_1 = arg_26_2.unit
	
	if arg_26_2.unit_uid then
		var_26_1 = var_26_1 or Account:getUnit(arg_26_2.unit_uid)
		var_26_0 = true
	end
	
	if arg_26_2.unit_code then
		var_26_1 = var_26_1 or Account:getUnitByCode(arg_26_2.unit_code)
		var_26_0 = true
	end
	
	if arg_26_2.select_next_promotable_unit then
		local var_26_2 = Account:getUnitsByCode(var_26_1.inst.code)
		local var_26_3
		
		if var_26_1 then
			for iter_26_0 = var_26_1:getGrade() - 1, 1, -1 do
				for iter_26_1, iter_26_2 in pairs(var_26_2) do
					if not var_26_3 and iter_26_2:isMaxLevel() and iter_26_0 == iter_26_2:getGrade() then
						var_26_3 = iter_26_2
					end
				end
				
				if var_26_3 then
					var_26_1 = var_26_3
					
					break
				end
			end
		end
		
		if not var_26_3 then
			for iter_26_3, iter_26_4 in pairs(var_26_2) do
				if not var_26_3 and iter_26_4:isMaxLevel() then
					var_26_3 = iter_26_4
				elseif var_26_3 and iter_26_4:isMaxLevel() and var_26_3:getGrade() > iter_26_4:getGrade() then
					var_26_3 = iter_26_4
				end
			end
			
			if var_26_3 then
				var_26_1 = var_26_3
			end
		end
	end
	
	if not arg_26_1 or (arg_26_1 == "Main" or arg_26_1 == "Sell") and not UnitMain:isExistBackground() then
		local var_26_4 = SAVE:getKeep("unit_detail_bg_id")
		local var_26_5 = make_bgpack_item(var_26_4)
		
		if var_26_5 then
			UnitMain:setBackground(var_26_5)
		end
		
		UnitMain:setVisibleBackground(true)
	end
	
	arg_26_0.vars.hero_belt:update()
	
	if not var_26_1 then
		local var_26_6 = arg_26_0.vars.hero_belt:getItems()
		
		if var_26_6[1] then
			var_26_1 = var_26_6[1]
		else
			arg_26_0.vars.hero_belt:resetFilter()
			
			var_26_1 = arg_26_0.vars.hero_belt:getItems()[1]
		end
	end
	
	if not UnitMain:isPortraitUseMode(arg_26_1) then
		arg_26_0.vars.hero_belt:tempSaveFilter("Detail")
		UnitMain:enterPortrait()
	end
	
	arg_26_0.vars.hero_belt:updateSelectedControlColor(var_26_1)
	
	local var_26_7 = arg_26_2.detail_mode or "Growth"
	
	arg_26_0:setMode(var_26_7, {
		unit = var_26_1
	})
	
	if arg_26_1 or var_26_0 then
		arg_26_0:resetChangedUnit()
		arg_26_0.vars.hero_belt:scrollToUnit(var_26_1, 0)
	end
	
	local var_26_8 = false
	
	for iter_26_5 = 1, 999 do
		local var_26_9 = DBN("item_material_bgpack", iter_26_5, "id")
		
		if not var_26_9 then
			break
		end
		
		local var_26_10 = "zoom_newCheck_data_" .. AccountData.id .. "_" .. var_26_9
		
		if Account:getItemCount(var_26_9) > 0 and SAVE:getUserDefaultData(var_26_10, true) then
			var_26_8 = true
			
			break
		end
	end
	
	if_set_visible(arg_26_0.vars.wnd, "alert_zoom", var_26_8)
	TopBarNew:setCurrencies()
	
	if arg_26_1 == "Main" then
		local var_26_11 = SceneManager:getRunningNativeScene():getChildByName("n_dedi_tooltip_slide")
		
		if get_cocos_refid(var_26_11) then
			var_26_11:setVisible(false)
		end
	end
	
	TutorialGuide:procGuide("artifact_install")
end

function UnitDetail.onLeave(arg_27_0, arg_27_1)
	local var_27_0 = UnitMain:needToShowUnitList(arg_27_1)
	
	arg_27_0:leaveCommonUI(var_27_0)
	
	if arg_27_1 ~= nil then
		UnitMain:fadeOutBackground()
	end
	
	if not UnitMain:isPortraitUseMode(arg_27_1) then
		if arg_27_1 ~= "Zodiac" and arg_27_1 ~= "MultiPromote" and arg_27_1 ~= "Unfold" then
			arg_27_0.vars.hero_belt:clearTempSaveFilter("Detail")
		end
		
		UnitMain:leavePortrait(nil, arg_27_1 ~= "Main")
	end
	
	if get_cocos_refid(arg_27_0.vars.n_main_tab) then
		UIAction:Add(SEQ(FADE_OUT(200), SHOW(false)), arg_27_0.vars.n_main_tab, "block")
	end
	
	Formation:change_buttonImg(SceneManager:getRunningNativeScene():getChildByName("n_btn_dedi"))
	
	local var_27_1 = arg_27_0.vars.cur_detail_mode or "Growth"
	local var_27_2 = arg_27_0.vars.mode[var_27_1]
	
	if var_27_2 and var_27_2.onLeave and type(var_27_2.onLeave) == "function" then
		var_27_2:onLeave()
	end
	
	arg_27_0.vars.cur_detail_mode = nil
	arg_27_0.vars.prev_detail_mode = var_27_1
end

function UnitDetail.onChangeResolution(arg_28_0)
	if not arg_28_0.vars or not get_cocos_refid(arg_28_0.vars.wnd) or table.empty(arg_28_0.vars.mode) then
		return 
	end
	
	local var_28_0 = arg_28_0.vars.mode[arg_28_0.vars.cur_detail_mode]
	
	if var_28_0 and var_28_0.onChangeResolution and type(var_28_0.onChangeResolution) == "function" then
		var_28_0:onChangeResolution()
	end
end

function UnitDetail.enterCommonUI(arg_29_0, arg_29_1)
	if not arg_29_0.vars or not get_cocos_refid(arg_29_0.vars.wnd) or not get_cocos_refid(arg_29_0.vars.ui_right) then
		return 
	end
	
	if_set_visible(arg_29_0.vars.wnd, "grow_right", true)
	
	if arg_29_0.vars.ui_right:isVisible() then
		return 
	end
	
	arg_29_0:clipUnitList(true)
	
	if arg_29_1 then
		if_set_opacity(arg_29_0.vars.ui_right, nil, 255)
		if_set_visible(arg_29_0.vars.ui_right, nil, true)
	else
		if_set_opacity(arg_29_0.vars.ui_right, nil, 0)
		UIAction:Add(SLIDE_IN(200, -100), arg_29_0.vars.ui_right, "block")
		UnitMain:showUnitList(true)
	end
end

function UnitDetail.leaveCommonUI(arg_30_0, arg_30_1)
	if not arg_30_0.vars or not get_cocos_refid(arg_30_0.vars.wnd) or not get_cocos_refid(arg_30_0.vars.ui_right) then
		return 
	end
	
	if_set_visible(arg_30_0.vars.wnd, "grow_right", false)
	
	if not arg_30_0.vars.ui_right:isVisible() then
		return 
	end
	
	arg_30_0:clipUnitList(false)
	
	if arg_30_1 then
		if_set_visible(arg_30_0.vars.ui_right, nil, false)
	else
		UIAction:Add(SLIDE_OUT(200, 100), arg_30_0.vars.ui_right, "block")
		UnitMain:showUnitList(false)
	end
end

function UnitDetail._getPrevMode(arg_31_0)
	if UnitMain:getStartMode() == "Support" then
		return "Support"
	end
	
	local var_31_0 = {
		"Story",
		"Upgrade",
		"Zoom",
		"Zodiac",
		"Equip",
		"Review",
		"Skill",
		"Build",
		"Sell",
		"MultiPromote",
		"LevelUp",
		"Unfold"
	}
	
	if table.isInclude(var_31_0, arg_31_0.vars.prev_mode) then
		return "Main"
	end
	
	return arg_31_0.vars.prev_mode or UnitMain.vars.start_mode or "Main"
end

function UnitDetail.onPushBackButton(arg_32_0)
	local var_32_0 = arg_32_0:_getPrevMode()
	
	UnitMain:setMode(var_32_0)
	DevoteTooltip:close()
end

function UnitDetail.openMerEnhanceTooltip(arg_33_0)
	Dialog:msgBox(T("confirm_cpshop_move"), {
		yesno = true,
		handler = function()
			movetoPath("epic7://worldmap_scene?continentkey=eureka&continent=poe")
		end
	})
end

function UnitDetail.onSelectUnitViaTouch(arg_35_0, arg_35_1, arg_35_2)
	if not arg_35_0.vars then
		return 
	end
	
	Action:Add(SEQ(DELAY(arg_35_0.vars.changed_tm_delay), CALL(function()
		arg_35_0:resetChangedUnit()
	end)), arg_35_0)
	arg_35_0:onSelectUnit(arg_35_1, arg_35_2)
end

function UnitDetail.getUnit(arg_37_0)
	if not arg_37_0.vars or not arg_37_0.vars.unit then
		return 
	end
	
	return arg_37_0.vars.unit
end

function UnitDetail.getWnd(arg_38_0)
	if not arg_38_0.vars then
		return 
	end
	
	return arg_38_0.vars.wnd
end

function UnitDetail.onSelectUnit(arg_39_0, arg_39_1, arg_39_2)
	if not arg_39_1 then
		return 
	end
	
	arg_39_0.vars.unit = arg_39_1
	
	local var_39_0 = UnitInfosUtil:isDetailInfoUnit(arg_39_1)
	
	if UnitEquip.vars and get_cocos_refid(UnitEquip.vars.wnd) or UnitExclusiveEquip.vars and get_cocos_refid(UnitExclusiveEquip.vars.wnd) then
		return 
	end
	
	arg_39_0.vars.wnd.guide_tag = arg_39_1.db.name
	
	TopBarNew:setTitleName(T(arg_39_1.db.name), "infounit1_2")
	TopBarNew:forcedHelp_OnOff(true)
	arg_39_0:updateModeTabsState(arg_39_1)
	
	local var_39_1 = "Detail" .. (arg_39_0.vars.cur_detail_mode or "Growth")
	
	if UnitMain:isPortraitUseMode(var_39_1) then
		UnitMain:movePortrait(var_39_1, nil, not var_39_0)
		UnitMain:changePortrait(arg_39_1, nil, nil)
	else
		UnitMain:leavePortrait()
	end
	
	arg_39_0:updateUnitInfo(arg_39_1, arg_39_2)
	
	local var_39_2 = UnitMain:isPvpMode() or UnitMain:isCoopMode()
	local var_39_3 = arg_39_1:isSellableDevotionUnit()
	
	if_set_visible(arg_39_0.vars.wnd, "btn_transfer", not arg_39_1:isDevotionUnit() or var_39_3)
	if_set_opacity(arg_39_0.vars.wnd, "btn_transfer", not var_39_2 and 255 or 76.5)
end

function UnitDetail.updateUnitInfo(arg_40_0, arg_40_1, arg_40_2)
	if not arg_40_0.vars or not get_cocos_refid(arg_40_0.vars.wnd) then
		return 
	end
	
	arg_40_1 = arg_40_1 or arg_40_0.vars.unit
	arg_40_0.vars.unit = arg_40_1
	
	local var_40_0 = arg_40_0.vars.mode[arg_40_0.vars.cur_detail_mode or "Growth"]
	
	if var_40_0 and var_40_0.updateUnitInfo and type(var_40_0.updateUnitInfo) == "function" then
		var_40_0:updateUnitInfo(arg_40_1, arg_40_2)
	end
end

function UnitDetail.onGameEvent(arg_41_0, arg_41_1, arg_41_2)
	if not arg_41_0.vars or not arg_41_0.vars.unit then
		return 
	end
	
	if arg_41_0.vars.cur_detail_mode ~= "Equip" then
		return 
	end
	
	if arg_41_1 == "read_mail" then
		local var_41_0 = arg_41_0.vars.mode[arg_41_0.vars.cur_detail_mode]
		
		if var_41_0 and var_41_0.updateUnitInfo and type(var_41_0.updateUnitInfo) == "function" then
			var_41_0:updateUnitInfo(arg_41_0.vars.unit)
		end
	end
end

function UnitDetail.onChangeUnit(arg_42_0, arg_42_1)
	if arg_42_0.vars and not UnitMain:isLeaving() then
		arg_42_0.vars.changed_unit = arg_42_1
		arg_42_0.vars.changed_tm = uitick()
	end
end

function UnitDetail.resetChangedUnit(arg_43_0)
	if not arg_43_0.vars then
		return 
	end
	
	arg_43_0.vars.changed_tm = nil
	arg_43_0.vars.changed_unit = nil
end

function UnitDetail.onAfterUpdate(arg_44_0)
	if arg_44_0.vars and arg_44_0.vars.changed_tm and arg_44_0.vars.changed_tm + arg_44_0.vars.changed_tm_delay < uitick() then
		arg_44_0:onSelectUnit(arg_44_0.vars.changed_unit)
		arg_44_0:resetChangedUnit()
	end
end

function UnitDetail.onTouchDown(arg_45_0, arg_45_1)
	arg_45_0.vars.touch_pos = arg_45_1:getLocation()
	arg_45_0.vars.touch_tick = uitick()
end

function UnitDetail.onTouchUp(arg_46_0, arg_46_1)
	if not arg_46_0.vars.touch_tick then
		return 
	end
	
	if UIAction:Find("block") then
		return 
	end
	
	local var_46_0 = arg_46_1:getLocation()
	
	if uitick() - arg_46_0.vars.touch_tick < 200 and cc.pGetDistance(var_46_0, arg_46_0.vars.touch_pos) < 25 then
		local var_46_1 = arg_46_0.vars.mode[arg_46_0.vars.cur_detail_mode or "Growth"]
		
		if var_46_1 and var_46_1.onTouchUp and type(var_46_1.onTouchUp) == "function" then
			var_46_1:onTouchUp(var_46_0)
		end
	end
	
	DevoteTooltip:close()
end

function UnitDetail.isModeChangeable(arg_47_0)
	if UnitMain:isPvpMode() then
		return false, "cant_pvp_mode"
	end
	
	if UnitMain:isCoopMode() then
		return false, "cant_expedition_mode"
	end
	
	if arg_47_0.vars.changed_unit then
		return false
	end
	
	return true
end

function UnitDetail.isMultiPromoteEnable(arg_48_0)
	MultiPromoteSelector:init()
	MultiPromoteSelector:setDataSource(Account:getUnits())
	
	return MultiPromoteSelector:isMultiPromoteEnable()
end

function UnitDetail.isValid(arg_49_0)
	if not arg_49_0.vars or not get_cocos_refid(arg_49_0.vars.wnd) then
		return 
	end
	
	return true
end

function UnitDetail.getHeroBelt(arg_50_0)
	if not arg_50_0.vars then
		return nil
	end
	
	return arg_50_0.vars.hero_belt
end

function UnitDetail.updateUnitDevoteInfo(arg_51_0, arg_51_1)
	if not arg_51_0.vars or not get_cocos_refid(arg_51_0.vars.wnd) or not arg_51_0.vars.unit then
		return 
	end
	
	arg_51_1 = arg_51_1 or arg_51_0.vars.unit
	
	if not arg_51_1 then
		return 
	end
	
	local var_51_0 = arg_51_0.vars.mode[arg_51_0.vars.cur_detail_mode or "Growth"]
	
	if var_51_0 and var_51_0.updateUnitInfo and type(var_51_0.updateUnitInfo) == "function" then
		var_51_0:updateUnitDevoteInfo(arg_51_1)
	end
end
