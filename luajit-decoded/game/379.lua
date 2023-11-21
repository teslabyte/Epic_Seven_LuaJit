UnitGuide = {}

function HANDLER.hero_guide(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_close" then
		UnitGuide:close()
	end
	
	if arg_1_1 == "btn_p2" then
		UnitGuide:setPage(2)
	end
	
	if arg_1_1 == "btn_p1" then
		UnitGuide:setPage(1)
	end
end

function UnitGuide.open(arg_2_0, arg_2_1)
	arg_2_1 = arg_2_1 or {
		code = "c1002"
	}
	
	if not DB("character_guide", arg_2_1.code, "id") then
		balloon_message_with_sound("no_guide")
		
		return 
	end
	
	arg_2_0.vars = {}
	arg_2_0.vars.wnd = load_dlg("hero_guide", true, "wnd")
	
	;(arg_2_1.parent or SceneManager:getRunningNativeScene()):addChild(arg_2_0.vars.wnd)
	if_set_visible(arg_2_0.vars.wnd, "2", false)
	arg_2_0:updateInfo(arg_2_1.code)
	arg_2_0.vars.wnd:setOpacity(0)
	UIAction:Add(SLIDE_IN(200), arg_2_0.vars.wnd, "block")
end

function UnitGuide.close(arg_3_0)
	UIAction:Add(SEQ(SLIDE_OUT(200), SHOW(false)), arg_3_0.vars.wnd, "block")
	
	arg_3_0.vars = {}
end

function UnitGuide.setPage(arg_4_0, arg_4_1)
	local var_4_0 = arg_4_0.vars.wnd:getChildByName("n_pages"):getChildren()
	
	for iter_4_0, iter_4_1 in pairs(var_4_0) do
		iter_4_1:setVisible(iter_4_1:getName() == tostring(arg_4_1))
	end
end

function UnitGuide.updateInfo(arg_5_0, arg_5_1)
	local var_5_0 = SLOW_DB_ALL("character_guide", arg_5_1) or {}
	local var_5_1 = T(DB("character", arg_5_1, "name"))
	
	if_set(arg_5_0.vars.wnd, "txt_title", var_5_1)
	if_set(arg_5_0.vars.wnd, "txt_goodhero", T("guide_sub_title", {
		name = var_5_1
	}))
	
	local var_5_2 = string.split(var_5_0.stat, ",")
	
	if_set_sprite(arg_5_0.vars.wnd, "stat1", "img/cm_icon_stat_" .. var_5_2[1] .. ".png")
	
	if var_5_2[2] then
		if_set_sprite(arg_5_0.vars.wnd, "stat2", "img/cm_icon_stat_" .. var_5_2[2] .. ".png")
		if_set(arg_5_0.vars.wnd, "txt_stats", T(var_5_2[1]) .. "," .. T(var_5_2[2]))
	else
		if_set_visible(arg_5_0.vars.wnd, "stat2", false)
		arg_5_0.vars.wnd:getChildByName("n_stat_icons"):setPositionX(0)
		if_set(arg_5_0.vars.wnd, "txt_stats", T(var_5_2[1]))
	end
	
	local var_5_3 = string.split(var_5_0.set, ",")
	
	if_set_sprite(arg_5_0.vars.wnd, "set1", "item/" .. (DB("item_set", var_5_3[1], "icon") or "") .. ".png")
	
	if var_5_3[2] then
		if_set_sprite(arg_5_0.vars.wnd, "set2", "item/" .. (DB("item_set", var_5_3[2], "icon") or "") .. ".png")
		if_set(arg_5_0.vars.wnd, "txt_sets", T(DB("item_set", var_5_3[1], "name") or "no_set") .. "," .. T(DB("item_set", var_5_3[2], "name") or "no_set"))
	else
		arg_5_0.vars.wnd:getChildByName("n_set_icons"):setPositionX(0)
		if_set_visible(arg_5_0.vars.wnd, "set2", false)
		if_set(arg_5_0.vars.wnd, "txt_sets", T(DB("item_set", var_5_3[1], "name")))
	end
	
	for iter_5_0, iter_5_1 in pairs(var_5_0) do
		if_set(arg_5_0.vars.wnd, "t_" .. iter_5_0, T(iter_5_1))
	end
	
	for iter_5_2 = 1, 2 do
		local var_5_4 = var_5_0["hero_" .. iter_5_2]
		local var_5_5 = arg_5_0.vars.wnd:getChildByName("n_unit" .. iter_5_2)
		local var_5_6, var_5_7 = DB("character", var_5_4, {
			"name",
			"grade"
		})
		
		if_set(var_5_5, "txt_unit_name", T(var_5_6))
		if_set_visible(var_5_5, "star" .. var_5_7 + 1, false)
		UIUtil:getRewardIcon("c", var_5_4, {
			no_grade = true,
			code = var_5_4,
			parent = var_5_5:getChildByName("n_face")
		})
	end
	
	if var_5_0.art then
		if_set(arg_5_0.vars.wnd, "txt_artifact", T(DB("equip_item", var_5_0.art, var_5_1) or "no_art"))
		UIUtil:getRewardIcon("equip", var_5_0.art, {
			code = var_5_0.art,
			parent = arg_5_0.vars.wnd:getChildByName("n_artifact")
		})
	end
end
