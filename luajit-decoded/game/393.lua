SubStoryLobbyUIFestival = SubStoryLobbyUIFestival or {}

copy_functions(SubStoryLobbyCommon, SubStoryLobbyUIFestival)

function HANDLER.dungeon_story_festival(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_board" then
		SubstoryFestivalBoard:show()
	elseif arg_1_1 == "btn_inn" then
		if not SubStoryFestival:isOpenEvent() then
			balloon_message_with_sound("fm_error_4")
			
			return 
		end
		
		SubstoryFestivalInn:show()
	elseif arg_1_1 == "btn_management" then
		SubStoryFestivalOffice:show()
	elseif arg_1_1 == "btn_office" then
		SubStoryFestivalOffice:show()
	elseif arg_1_1 == "btn_shop" then
		SubStoryLobby:hideBG()
		SubstoryManager:openStoryShop()
	elseif arg_1_1 == "btn_prologue" then
		SubstoryManager:playPrologue()
	elseif arg_1_1 == "btn_bonus" then
		Substory_ArtBouns:open()
	elseif arg_1_1 == "btn_achieve" then
		SubstoryAchievePopup:show()
	end
end

function SubStoryLobbyUIFestival.onEnterUI(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0.vars = {}
	arg_2_0.vars.wnd = arg_2_1
	
	local var_2_0 = SubstoryUIUtil:getBackground(arg_2_2.id, arg_2_2.background_summary, {
		isEnter = true
	})
	local var_2_1 = var_2_0:getChildByName("btn_video")
	
	if get_cocos_refid(var_2_1) then
		var_2_1:setPositionX(0 - VIEW_WIDTH + 250)
		var_2_1:setPositionY(var_2_1:getPositionY() - 70)
	end
	
	if_set_visible(arg_2_0.vars.wnd, "icon_achieve_noti", false)
	var_2_0:setAnchorPoint(0.5, 0.5)
	var_2_0:setLocalZOrder(-1)
	arg_2_0.vars.wnd:addChild(var_2_0)
	
	arg_2_0.vars.info = arg_2_2
	
	arg_2_0:addBaseInfo(arg_2_2)
	
	local var_2_2 = SubStoryUtil:getEventState(arg_2_2.start_time, arg_2_2.end_time)
	local var_2_3 = {}
	
	if var_2_2 ~= SUBSTORY_CONSTANTS.STATE_READY then
		var_2_3 = SubStoryUtil:getTopbarCurrencies(arg_2_2)
	end
	
	arg_2_0:setVisibleArtiEffectBtn(var_2_2, arg_2_2)
	arg_2_0:setVisiblePrologueBtn(var_2_2, arg_2_2)
	TopBarNew:setCurrencies(var_2_3)
	TopBarNew:setVisible(true)
	if_set_visible(arg_2_0.vars.wnd, "btn_achieve", arg_2_2.achieve_flag and arg_2_2.achieve_flag == "y" and var_2_2 == SUBSTORY_CONSTANTS.STATE_OPEN)
end

function SubStoryLobbyUIFestival.updateEnterQueryUI(arg_3_0, arg_3_1)
	if not arg_3_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_3_0.vars.wnd) then
		return 
	end
	
	arg_3_0:exceptionHandling(arg_3_1)
	SubStoryFestivalUIUtil:updateFestivalDateUI(arg_3_0.vars.wnd)
	SubStoryFestivalUIUtil:updateNotiBalloon(arg_3_0.vars.info.id, arg_3_0.vars.wnd)
	SubStoryLobbyUIFestival:updateRedDot()
end

function SubStoryLobbyUIFestival.updateRedDot(arg_4_0)
	SubStoryFestivalUIUtil:updateOfficeRedDot(arg_4_0.vars.wnd)
	
	local var_4_0 = arg_4_0.vars.wnd:getChildByName("n_board")
	
	SubStoryFestivalUIUtil:updateBoardRedDot(var_4_0)
end

function SubStoryLobbyUIFestival.updateUI(arg_5_0)
	if not arg_5_0.vars or not get_cocos_refid(arg_5_0.vars.wnd) then
		return 
	end
	
	arg_5_0:updateRedDot()
	SubstoryUIUtil:updateAchieveUI(arg_5_0.vars.wnd)
	SubstoryUIUtil:updateQuestUI(arg_5_0.vars.wnd)
end
