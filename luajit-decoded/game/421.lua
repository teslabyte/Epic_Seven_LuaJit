UnitInfosReview = {}

function UnitInfosReview.onCreate(arg_1_0, arg_1_1)
	local var_1_0 = UnitInfosController:getUnit()
	local var_1_1 = var_1_0.db.code
	
	if var_1_0:isMoonlightDestinyUnit() then
		var_1_1 = MoonlightDestiny:getRelationCharacterCode(var_1_1)
	end
	
	arg_1_0.vars = {}
	arg_1_0.vars.dlg = load_dlg("hero_detail_vote", true, "wnd")
	
	if_set_visible(arg_1_0.vars.dlg, "txt_rating_count", false)
	if_set_visible(arg_1_0.vars.dlg, "txt_rating", false)
	Review:open({
		code = var_1_1
	})
	Review:setLeft(arg_1_0.vars.dlg, var_1_1, nil, {
		txt_story_name = "txt_story"
	})
	arg_1_1:addChild(arg_1_0.vars.dlg)
	if_set_visible(arg_1_0.vars.dlg, "btn_equip_arti", not ContentDisable:byAlias("eq_arti_statistics"))
	UnitMain:movePortrait("Review")
end

function UnitInfosReview.onReceive(arg_2_0, arg_2_1)
	local var_2_0 = arg_2_0.vars.dlg:findChildByName("n_review")
	local var_2_1 = UnitInfosController:getUnit()
	
	arg_2_0.vars.review_wnd = Review:show({
		is_moonlight_destiny_unit = true,
		renew = true,
		no_portrait = true,
		code = var_2_1.db.code,
		layer = var_2_0
	})
	
	arg_2_0.vars.review_wnd:setPosition(0, 360)
	
	local var_2_2, var_2_3 = arg_2_0.vars.review_wnd:getPosition()
	
	arg_2_0.vars.review_wnd:setPositionX(var_2_2 + 500)
	UIAction:Add(SEQ(LOG(MOVE_TO(300, var_2_2, var_2_3))), arg_2_0.vars.review_wnd, "block")
end

function UnitInfosReview.onLeave(arg_3_0)
	Review:close()
	arg_3_0.vars.dlg:removeFromParent()
end
