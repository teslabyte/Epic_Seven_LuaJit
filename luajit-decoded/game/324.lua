MoonlightDestinyRecall = MoonlightDestinyRecall or {}
MoonlightDestinyRecall.vars = {}

function HANDLER.destiny_moonlight_recall(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_cancel" then
		MoonlightDestinyRecall:close()
	elseif arg_1_1 == "btn_recall" then
		MoonlightDestinyRecall:requestRecall()
	end
end

function MsgHandler.relation_moonlight_change_preview(arg_2_0)
	if arg_2_0 and arg_2_0.res == "ok" then
		MoonlightDestinyRecall:openRecallPreview(arg_2_0.preview_rewards)
	end
end

function MoonlightDestinyRecall.requestRecall(arg_3_0)
	local var_3_0 = AccountData.relation_moonlight_reset_info.reset_cost
	
	if UIUtil:checkCurrencyDialog(var_3_0.item_code, var_3_0.count) ~= true then
		return 
	end
	
	Dialog:msgBox(T("character_mc_reset_desc2"), {
		yesno = true,
		handler = function()
			query("relation_moonlight_change_recall", {
				season = MoonlightDestiny:getCurrentSeasonNumber()
			})
		end,
		title = T("character_mc_reset_title2")
	})
end

function MoonlightDestinyRecall.open(arg_5_0, arg_5_1)
	local var_5_0 = Account:getRelationMoonlightSeason()
	
	if not var_5_0 or not AccountData.relation_moonlight_reset_info then
		return 
	end
	
	if to_n(var_5_0.reset_count) >= to_n(AccountData.relation_moonlight_reset_info.reset_count_limit) then
		balloon_message_with_sound("character_mc_cannot_change_more")
		
		return 
	end
	
	arg_5_0.vars.wnd_layer = arg_5_1
	arg_5_0.vars.recall_unit = Account:getUnit(var_5_0.unit_id)
	
	if not arg_5_0.vars.recall_unit then
		return 
	end
	
	local var_5_1 = arg_5_0.vars.recall_unit:getUsableCodeList()
	
	if var_5_1 then
		Dialog:msgUnitLock(var_5_1)
		
		return 
	end
	
	if arg_5_0.vars.recall_unit:isDoingSubTask() then
		balloon_message_with_sound("cannot_recall_subtask")
		
		return 
	end
	
	query("relation_moonlight_change_preview", {
		season = MoonlightDestiny:getCurrentSeasonNumber()
	})
end

function MoonlightDestinyRecall.openRecallPreview(arg_6_0, arg_6_1)
	arg_6_0.vars.wnd = load_dlg("destiny_moonlight_recall", true, "wnd", function()
		arg_6_0:close()
	end)
	
	if not get_cocos_refid(arg_6_0.vars.wnd) then
		return 
	end
	
	local var_6_0 = arg_6_0.vars.wnd:getChildByName("n_hero")
	
	if_set_visible(var_6_0, "intimacy", false)
	UnitDetailGrowth:updatePreviewRecallUnitUI(arg_6_1, var_6_0)
	;(arg_6_0.vars.wnd_layer or SceneManager:getRunningPopupScene()):addChild(arg_6_0.vars.wnd)
	arg_6_0.vars.wnd:setOpacity(0)
	UIAction:Add(LOG(FADE_IN(200)), arg_6_0.vars.wnd, "block")
end

function MoonlightDestinyRecall.close(arg_8_0)
	if not get_cocos_refid(arg_8_0.vars.wnd) then
		return 
	end
	
	BackButtonManager:pop({
		dlg = arg_8_0.vars.wnd
	})
	UIAction:Add(SEQ(LOG(FADE_OUT(200)), REMOVE()), arg_8_0.vars.wnd, "block")
end
