HeroGet = HeroGet or {}
HeroGet.vars = {}

local var_0_0 = 200

function HANDLER.hero_get(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_close" then
		HeroGet:close()
		
		return 
	end
	
	if arg_1_1 == "btn_ok" then
		HeroGet:ok()
		
		return 
	end
end

function HeroGet.close(arg_2_0)
	UIAction:Add(SEQ(LOG(FADE_OUT(var_0_0)), REMOVE()), arg_2_0.vars.wnd, "block")
	BackButtonManager:pop(arg_2_0.vars.wnd)
	UnitSummonResult:showResultOnly(arg_2_0.vars.code, arg_2_0.vars.layer, arg_2_0.vars.callback_ok_btn, {
		is_new = true
	})
end

function HeroGet.open(arg_3_0, arg_3_1)
	arg_3_1 = arg_3_1 or {}
	arg_3_0.vars = {}
	arg_3_0.vars.callback_ok_btn = arg_3_1.callback_ok_btn or function()
	end
	
	local var_3_0 = arg_3_1.layer or SceneManager:getRunningUIScene()
	local var_3_1 = arg_3_1.code or "c1018"
	
	arg_3_0.vars.wnd = load_dlg("hero_get", true, "wnd", function()
		arg_3_0:close()
	end)
	
	arg_3_0.vars.wnd:setOpacity(0)
	UIAction:Add(LOG(FADE_IN(var_0_0)), arg_3_0.vars.wnd, "block")
	var_3_0:addChild(arg_3_0.vars.wnd)
	arg_3_0.vars.wnd:bringToFront()
	
	local var_3_2 = UNIT:create({
		code = var_3_1
	})
	local var_3_3 = {
		no_popup = false,
		name = false,
		no_lv = false,
		no_role = false,
		parent = arg_3_0.vars.wnd:getChildByName("mob_icon"),
		grade = var_3_2.db.grade
	}
	
	UIUtil:getUserIcon(var_3_2, var_3_3)
	if_set(arg_3_0.vars.wnd, "txt_title", T(var_3_1 .. "_get_title"))
	
	if var_3_1 == "c1005" then
		if_set(arg_3_0.vars.wnd, "txt_disc", T(var_3_1 .. "_get_desc2"))
	else
		if_set(arg_3_0.vars.wnd, "txt_disc", T(var_3_1 .. "_get_desc"))
	end
	
	arg_3_0.vars.layer = var_3_0
	arg_3_0.vars.code = var_3_1
end

function HeroGet.ok(arg_6_0)
	arg_6_0:close()
end
