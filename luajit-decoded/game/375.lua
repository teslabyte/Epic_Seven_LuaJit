UnitReview = {}

function UnitReview.onPushBackButton(arg_1_0)
	UnitMain:setMode("Detail", {
		unit = UnitDetail.vars.unit
	})
end

function UnitReview.onEnter(arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = load_dlg("hero_detail_vote", true, "wnd")
	
	if_set_visible(var_2_0, "txt_rating_count", false)
	if_set_visible(var_2_0, "txt_rating", false)
	
	local var_2_1 = IS_PUBLISHER_STOVE and not ContentDisable:byAlias("eq_arti_statistics")
	
	if_set_visible(var_2_0, "btn_equip_arti", var_2_1)
	
	local var_2_2 = var_2_0:findChildByName("n_review")
	
	var_2_2:setPositionX(var_2_2:getPositionX() + 221 + 150)
	
	local var_2_3 = var_2_0:findChildByName("LEFT")
	
	var_2_3:setPositionX(var_2_3:getPositionX() - 150)
	UIAction:Add(SEQ(LOG(MOVE_BY(180, 150))), var_2_3, "block")
	UIAction:Add(SEQ(LOG(MOVE_BY(180, -150))), var_2_2, "block")
	
	arg_2_0.vars = {}
	
	local var_2_4 = UnitDetail:getUnit()
	
	Review:setLeft(var_2_0, arg_2_2.code, var_2_4, {
		txt_story_name = "txt_story"
	})
	Review:show({
		set_pos_x = 0,
		renew = true,
		no_portrait = true,
		unit = var_2_4,
		code = arg_2_2.code,
		layer = var_2_2
	})
	
	if not var_2_2.origin_pos_x then
		var_2_2.origin_pos_x = var_2_2:getPositionX() - 150
	end
	
	NotchManager:addListener(var_2_2, nil, function(arg_3_0, arg_3_1, arg_3_2)
		if get_cocos_refid(arg_3_0) and arg_3_0.origin_pos_x then
			arg_3_0:setPositionX(arg_3_0.origin_pos_x)
		end
	end)
	
	arg_2_0.vars.wnd = var_2_0
	
	UnitMain.vars.base_wnd:addChild(var_2_0)
	if_set_visible(arg_2_0.vars.wnd, "n_bg", false)
end

function UnitReview.onLeave(arg_4_0)
	local var_4_0 = arg_4_0.vars.wnd
	local var_4_1 = var_4_0:findChildByName("n_review")
	local var_4_2 = var_4_0:findChildByName("LEFT")
	
	UIAction:Add(SEQ(LOG(MOVE_BY(180, -150))), var_4_2, "block")
	UIAction:Add(SEQ(LOG(MOVE_BY(180, 150))), var_4_1, "block")
	
	if arg_4_0.vars.wnd then
		arg_4_0.vars.wnd:removeFromParent()
	end
	
	arg_4_0.vars = nil
end

function UnitReview.onTouchDown(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_1:getLocation()
	
	return true
end

function UnitReview.onTouchUp(arg_6_0, arg_6_1, arg_6_2)
end
