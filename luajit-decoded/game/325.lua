MoonlightDestinyMsgBox = MoonlightDestinyMsgBox or {}
MoonlightDestinyMsgBox.vars = {}

function HANDLER.destiny_moonlight_msgbox(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_close" then
		return 
	end
	
	if arg_1_1 == "btn_cancel" then
		MoonlightDestinyMsgBox:close()
		
		return 
	end
	
	if arg_1_1 == "btn_ok" then
		MoonlightDestinyMsgBox:select()
		
		return 
	end
end

function MoonlightDestinyMsgBox.open(arg_2_0, arg_2_1)
	arg_2_0.vars.wnd = load_dlg("destiny_moonlight_msgbox", true, "wnd", function()
		arg_2_0:close()
	end)
	
	if not get_cocos_refid(arg_2_0.vars.wnd) then
		return 
	end
	
	SceneManager:getRunningPopupScene():addChild(arg_2_0.vars.wnd)
	arg_2_0.vars.wnd:setOpacity(0)
	UIAction:Add(LOG(FADE_IN(200)), arg_2_0.vars.wnd, "block")
	
	local var_2_0 = arg_2_0.vars.wnd:getChildByName("n_hero")
	
	if not get_cocos_refid(var_2_0) then
		return 
	end
	
	local var_2_1 = var_2_0:getChildByName("mob_icon")
	
	if not get_cocos_refid(var_2_1) then
		return 
	end
	
	local var_2_2 = UNIT:create({
		code = arg_2_1
	})
	local var_2_3 = {
		no_popup = true,
		name = false,
		no_lv = true,
		no_role = false,
		parent = var_2_1,
		grade = var_2_2.db.grade
	}
	
	UIUtil:getUserIcon(arg_2_1, var_2_3)
	
	local var_2_4 = T(DB("character", arg_2_1, {
		"name"
	}))
	
	if_set(var_2_0, "t_name", var_2_4)
	
	local var_2_5 = MoonlightDestiny:isLastSelectChance() and T("character_mc_only_once2") or T("character_mc_only_once")
	
	if MoonlightDestiny:isLastSelectChance() then
		var_2_5 = "<#cd0000>" .. var_2_5 .. "</>"
	end
	
	if_set(arg_2_0.vars.wnd, "txt_caution", var_2_5)
end

function MoonlightDestinyMsgBox.close(arg_4_0)
	if not get_cocos_refid(arg_4_0.vars.wnd) then
		return 
	end
	
	BackButtonManager:pop({
		dlg = arg_4_0.vars.wnd
	})
	UIAction:Add(SEQ(LOG(FADE_OUT(200)), REMOVE()), arg_4_0.vars.wnd, "block")
end

function MoonlightDestinyMsgBox.select(arg_5_0)
	query("relation_moonlight_change", {
		season = MoonlightDestiny:getCurrentSeasonNumber(),
		code = MoonlightDestinyHero:getSelectCode()
	})
end
