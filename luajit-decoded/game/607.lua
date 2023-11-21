CharPreviewEndingPart = {}

function CharPreviewEndingPart.uiSetting(arg_1_0, arg_1_1)
	local var_1_0 = load_dlg("intro_hero3", true, "wnd")
	local var_1_1 = CharPreviewData:getUnit(arg_1_1)
	local var_1_2 = var_1_0:getChildByName("txt_role")
	
	if not arg_1_0.txt_role_origin_size then
		arg_1_0.txt_role_origin_size = var_1_2:getContentSize()
	end
	
	UIUtil:setUnitAllInfo(var_1_0, var_1_1, {
		ignore_stat_diff = true,
		is_txt_node_children = true,
		no_repos_sphere = true,
		use_basic_star = true
	})
	UIUtil:setUnitSkillInfo(var_1_0, var_1_1, {
		tooltip_opts = {
			show_effs = "right"
		}
	})
	
	for iter_1_0 = 1, 3 do
		var_1_0:findChildByName("skill" .. iter_1_0):setScale(1.2)
	end
	
	var_1_0:getChildByName("LEFT"):getChildByName("txt_story"):setString(T(DB("character", arg_1_1, "2line"), "text"))
	UIUtil:setDevoteDetail_new(var_1_0, var_1_1, {
		target = "n_dedi",
		not_my_unit = true
	})
	
	local var_1_3 = DB("character", arg_1_1, "grade")
	
	for iter_1_1 = 1, 5 do
		if_set_visible(var_1_0, "star" .. iter_1_1, iter_1_1 <= var_1_3)
	end
	
	local var_1_4 = 15 * (5 - var_1_3)
	local var_1_5 = var_1_0:findChildByName("n_star")
	
	var_1_5:setPositionX(var_1_5:getPositionX() + var_1_4)
	if_set_visible(var_1_0, "gacha_new", CharPreviewData:getTag(arg_1_1) == "new")
	
	local var_1_6 = var_1_0:getChildByName("color")
	local var_1_7 = var_1_0:findChildByName("n_info")
	local var_1_8 = var_1_2:getContentSize().width
	
	var_1_6:setPositionX(var_1_2:getPositionX() + var_1_8 + 15)
	var_1_7:setPositionX(math.min((arg_1_0.txt_role_origin_size.width - var_1_8) / 2, 0))
	
	local var_1_9 = UnitInfosUtil:getCharacterVoiceName(arg_1_1)
	
	SoundEngine:playVoice(string.format("event:/voc/character/%s/evt/get", var_1_1.db.model_id))
	if_set_visible(var_1_0, "t_cv", var_1_9)
	if_set(var_1_0, "t_cv", var_1_9)
	
	return var_1_0
end

function CharPreviewEndingPart.show(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = CharPreviewData:getSummaryBG(arg_2_3)
	local var_2_1, var_2_2 = FIELD_NEW:create(var_2_0, DESIGN_WIDTH)
	
	arg_2_1:addChild(var_2_1)
	var_2_1:setCascadeOpacityEnabled(true)
	var_2_1:setAnchorPoint(0.5, 0.5)
	var_2_2:setForgroundOpacityByTag(125, "bgshow")
	
	arg_2_0.new_bg = var_2_1
	arg_2_0.eff = EffectManager:Play({
		fn = "ui_new_pickup_particles.cfx",
		layer = arg_2_2,
		pivot_x = VIEW_WIDTH / 2,
		pivot_y = VIEW_HEIGHT / 2
	})
	arg_2_0.ui = arg_2_0:uiSetting(arg_2_3)
	
	local var_2_3 = DB("character", arg_2_3, "face_id")
	local var_2_4 = CharPreviewData:getSkin(arg_2_3) or var_2_3
	local var_2_5 = UIUtil:getPortraitAni(var_2_4)
	local var_2_6 = arg_2_0.ui:findChildByName("n_pos")
	
	arg_2_2:addChild(arg_2_0.ui)
	var_2_1:addChild(var_2_5)
	var_2_5:setPosition(var_2_6:getPosition())
	var_2_5:setScale(var_2_6:getScale())
	var_2_1:setScale(1.8)
	Action:AddAsync(SEQ(LOG(SCALE_TO(2000, 1))), var_2_1)
	arg_2_0.ui:setOpacity(0)
	Action:AddAsync(SEQ(DELAY(500), LOG(FADE_IN(500))), arg_2_0.ui)
	arg_2_0.eff:setLocalZOrder(1)
	arg_2_0.new_bg:setLocalZOrder(2)
	arg_2_0.ui:setLocalZOrder(3)
	
	local var_2_7 = DB("char_intro", CharPreviewData:getKey(arg_2_3), "gacha_id")
	
	if_set_visible(arg_2_0.ui, "btn_summon", var_2_7)
	
	local var_2_8 = arg_2_0.ui:getChildByName("btn_summon")
	
	if var_2_8 then
		if var_2_7 then
			var_2_8.gacha_id = var_2_7
		else
			var_2_8.gacha_id = nil
		end
	end
end

function CharPreviewEndingPart.release(arg_3_0)
	if get_cocos_refid(arg_3_0.eff) then
		arg_3_0.eff:removeFromParent()
		
		arg_3_0.eff = nil
	end
	
	if get_cocos_refid(arg_3_0.ui) then
		arg_3_0.ui:removeFromParent()
		
		arg_3_0.ui = nil
	end
	
	if get_cocos_refid(arg_3_0.new_bg) then
		arg_3_0.new_bg:removeFromParent()
		
		arg_3_0.new_bg = nil
	end
	
	arg_3_0.txt_role_origin_size = nil
end
