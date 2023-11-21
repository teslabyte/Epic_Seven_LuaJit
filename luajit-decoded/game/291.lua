HeroStatViewer = HeroStatViewer or {}

function HANDLER.dict_hero_stat_view(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_minus_grade" then
		local var_1_0 = HeroStatViewer.vars.grade_slider_button:getPercent() - 1
		
		HeroStatViewer.vars.grade_slider_button:setPercent(var_1_0)
		Dialog.defaultSliderEventHandler(HeroStatViewer.vars.grade_slider_button, 2)
	end
	
	if arg_1_1 == "btn_plus_grade" then
		local var_1_1 = HeroStatViewer.vars.grade_slider_button:getPercent() + 1
		
		HeroStatViewer.vars.grade_slider_button:setPercent(var_1_1)
		Dialog.defaultSliderEventHandler(HeroStatViewer.vars.grade_slider_button, 2)
	end
	
	if arg_1_1 == "btn_minus_level" then
		local var_1_2 = HeroStatViewer.vars.level_slider_button:getPercent() - 1
		
		HeroStatViewer.vars.level_slider_button:setPercent(var_1_2)
		Dialog.defaultSliderEventHandler(HeroStatViewer.vars.level_slider_button, 2)
	end
	
	if arg_1_1 == "btn_plus_level" then
		local var_1_3 = HeroStatViewer.vars.level_slider_button:getPercent() + 1
		
		HeroStatViewer.vars.level_slider_button:setPercent(var_1_3)
		Dialog.defaultSliderEventHandler(HeroStatViewer.vars.level_slider_button, 2)
	end
	
	if arg_1_1 == "check_box_awake" then
		HeroStatViewer:setZodiacMode(arg_1_0:isSelected())
	end
	
	if arg_1_1 == "check_box_potentail" then
		HeroStatViewer:setPotentialMode(arg_1_0:isSelected())
	end
end

function HeroStatViewer.setUnit(arg_2_0, arg_2_1)
	if not arg_2_0.vars then
		return 
	end
	
	arg_2_0.vars.unit = arg_2_1
	arg_2_0.vars.code = arg_2_1.db.code
	arg_2_0.vars.default_grade = arg_2_1.db.grade
	
	arg_2_0:updateStat()
end

function HeroStatViewer.showStatPopup(arg_3_0, arg_3_1)
	if not arg_3_1 then
		return 
	end
	
	arg_3_0.vars = {}
	arg_3_0.vars.stat_wnd = load_dlg("dict_hero_stat_view", true, "wnd")
	arg_3_0.vars.unit = arg_3_1
	arg_3_0.vars.code = arg_3_1.db.code
	arg_3_0.vars.default_grade = arg_3_1.db.grade
	
	local function var_3_0()
		arg_3_0.vars.stat_wnd:removeFromParent()
		
		arg_3_0.vars = nil
		
		BackButtonManager:pop("dict_hero_stat_view")
	end
	
	BackButtonManager:push({
		check_id = "dict_hero_stat_view",
		back_func = var_3_0
	})
	SceneManager:getRunningPopupScene():addChild(arg_3_0.vars.stat_wnd)
	
	local var_3_1 = ccui.Button:create()
	
	var_3_1:setTouchEnabled(true)
	var_3_1:ignoreContentAdaptWithSize(false)
	var_3_1:setContentSize(VIEW_WIDTH, VIEW_HEIGHT)
	var_3_1:setPosition(VIEW_BASE_LEFT, 0)
	var_3_1:setAnchorPoint(0, 0)
	var_3_1:setLocalZOrder(-1)
	var_3_1:addTouchEventListener(function(arg_5_0, arg_5_1)
		if arg_5_1 ~= 2 then
			return 
		end
		
		var_3_0()
	end)
	var_3_1:setName("btn_close")
	arg_3_0.vars.stat_wnd:addChild(var_3_1)
	if_set(arg_3_0.vars.stat_wnd, "txt_li_point_name", T("unit_power"))
	if_set(arg_3_0.vars.stat_wnd, "txt_li_dmg_name", T("att"))
	if_set(arg_3_0.vars.stat_wnd, "txt_li_hp_name", T("max_hp"))
	if_set(arg_3_0.vars.stat_wnd, "txt_li_speed_name", T("speed"))
	if_set(arg_3_0.vars.stat_wnd, "txt_li_def_name", T("def"))
	if_set(arg_3_0.vars.stat_wnd, "txt_li_cri_name", T("cri"))
	if_set(arg_3_0.vars.stat_wnd, "txt_li_cri_dmg_name", T("cri_dmg"))
	if_set(arg_3_0.vars.stat_wnd, "txt_li_con_name", T("con"))
	if_set(arg_3_0.vars.stat_wnd, "txt_li_coop_name", getStatName("coop"))
	if_set(arg_3_0.vars.stat_wnd, "txt_li_acc_name", T("acc"))
	if_set(arg_3_0.vars.stat_wnd, "txt_li_res_name", T("res"))
	
	arg_3_0.vars.check_box_awake = arg_3_0.vars.stat_wnd:getChildByName("check_box_awake")
	
	arg_3_0.vars.check_box_awake:setSelected(false)
	
	arg_3_0.vars.check_box_potentail = arg_3_0.vars.stat_wnd:getChildByName("check_box_potentail")
	
	arg_3_0.vars.check_box_potentail:setSelected(false)
	
	arg_3_0.vars.grade_slider_button = arg_3_0.vars.stat_wnd:getChildByName("star_slider_button")
	
	arg_3_0.vars.grade_slider_button:addTouchEventListener(Dialog.defaultSliderEventHandler)
	
	function arg_3_0.vars.grade_slider_button.handler(arg_6_0, arg_6_1, arg_6_2)
		if not arg_3_0.vars then
			return 
		end
		
		if not arg_3_0:isPotentialMode() then
			arg_3_0.vars.level_slider_button.max = arg_6_1 * 10
			
			arg_3_0.vars.level_slider_button:setMaxPercent(arg_3_0.vars.level_slider_button.max)
			arg_3_0.vars.level_slider_button:setPercent(arg_3_0.vars.level_slider_button.max)
		end
		
		arg_3_0:updateStat()
	end
	
	arg_3_0.vars.level_slider_button = arg_3_0.vars.stat_wnd:getChildByName("level_slider_button")
	
	arg_3_0.vars.level_slider_button:addTouchEventListener(Dialog.defaultSliderEventHandler)
	
	function arg_3_0.vars.level_slider_button.handler(arg_7_0, arg_7_1, arg_7_2)
		if not arg_3_0.vars then
			return 
		end
		
		arg_3_0:updateStat()
	end
	
	arg_3_0.vars.grade_slider_button.min = arg_3_0.vars.default_grade
	arg_3_0.vars.grade_slider_button.max = 6
	
	arg_3_0.vars.grade_slider_button:setMaxPercent(arg_3_0.vars.grade_slider_button.max)
	arg_3_0.vars.grade_slider_button:setPercent(arg_3_0.vars.default_grade)
	
	arg_3_0.vars.level_slider_button.min = 1
	arg_3_0.vars.level_slider_button.max = arg_3_0.vars.grade_slider_button:getPercent() * 10
	
	arg_3_0.vars.level_slider_button:setMaxPercent(arg_3_0.vars.level_slider_button.max)
	arg_3_0.vars.level_slider_button:setPercent(arg_3_0.vars.default_grade * 10)
	
	if not DB("char_awake", "ca_" .. arg_3_1.db.code .. "_1", "id") then
		if_set_visible(arg_3_0.vars.stat_wnd, "txt_potentail", false)
		if_set_position_x(arg_3_0.vars.stat_wnd, "txt_awake", 466)
	end
	
	for iter_3_0 = 1, 6 do
		if_set_visible(arg_3_0.vars.stat_wnd, "star" .. iter_3_0 .. "_0", false)
	end
	
	arg_3_0:updateStat()
	
	return arg_3_0.vars.stat_wnd
end

function HeroStatViewer.updateStat(arg_8_0)
	arg_8_0:updateLevelSlider()
	
	local var_8_0 = arg_8_0.vars.grade_slider_button:getPercent()
	local var_8_1 = arg_8_0.vars.level_slider_button:getPercent()
	local var_8_2 = arg_8_0:isPotentialMode() and var_8_0 or 0
	
	var_8_0 = arg_8_0:isPotentialMode() and 6 or var_8_0
	
	local var_8_3 = arg_8_0:isZodiacMode() and var_8_0 or 0
	
	UIUtil:setLevelDetail(arg_8_0.vars.stat_wnd, var_8_1, var_8_0 * 10)
	
	local var_8_4 = UNIT:create({
		code = arg_8_0.vars.code,
		g = var_8_0,
		lv = var_8_1,
		z = var_8_3,
		awake = var_8_2
	})
	
	if_set(arg_8_0.vars.stat_wnd, "txt_li_point_value", var_8_4:getPoint())
	if_set(arg_8_0.vars.stat_wnd, "txt_li_dmg_value", var_8_4.status.att)
	if_set(arg_8_0.vars.stat_wnd, "txt_li_hp_value", var_8_4.status.max_hp)
	if_set(arg_8_0.vars.stat_wnd, "txt_li_speed_value", var_8_4.status.speed)
	if_set(arg_8_0.vars.stat_wnd, "txt_li_def_value", var_8_4.status.def)
	if_set(arg_8_0.vars.stat_wnd, "txt_li_cri_value", string.format("%3.1f", var_8_4.status.cri * 100) .. "%")
	if_set(arg_8_0.vars.stat_wnd, "txt_li_cri_dmg_value", string.format("%3.1f", var_8_4.status.cri_dmg * 100) .. "%")
	if_set(arg_8_0.vars.stat_wnd, "txt_li_coop_value", string.format("%3.1f", var_8_4.status.coop * 100) .. "%")
	if_set(arg_8_0.vars.stat_wnd, "txt_li_acc_value", string.format("%3.1f", var_8_4.status.acc * 100) .. "%")
	if_set(arg_8_0.vars.stat_wnd, "txt_li_res_value", string.format("%3.1f", var_8_4.status.res * 100) .. "%")
	
	for iter_8_0 = 1, 6 do
		if_set_visible(arg_8_0.vars.stat_wnd, "star" .. iter_8_0, iter_8_0 <= var_8_0)
	end
	
	UIUtil:setStarsByUnit(arg_8_0.vars.stat_wnd, var_8_4)
end

function HeroStatViewer.getUnit(arg_9_0)
	return arg_9_0.vars and arg_9_0.vars.unit
end

function HeroStatViewer.setZodiacMode(arg_10_0, arg_10_1)
	if not arg_10_0.vars then
		return 
	end
	
	arg_10_0.vars.check_box_awake:setSelected(arg_10_1)
	
	if not arg_10_1 then
		arg_10_0:setPotentialMode(false)
	else
		arg_10_0:updateStat()
	end
	
	arg_10_0.vars.level_slider_button:setTouchEnabled(not arg_10_1)
end

function HeroStatViewer.setPotentialMode(arg_11_0, arg_11_1)
	if not arg_11_0.vars then
		return 
	end
	
	arg_11_0.vars.check_box_potentail:setSelected(arg_11_1)
	
	if arg_11_1 then
		arg_11_0.vars.grade_slider_button.min = 1
		
		arg_11_0.vars.grade_slider_button:setPercent(arg_11_0.vars.lase_awake or 1)
		
		arg_11_0.vars.level_slider_button.max = 60
		
		arg_11_0.vars.level_slider_button:setMaxPercent(arg_11_0.vars.level_slider_button.max)
		arg_11_0:setZodiacMode(true)
	else
		arg_11_0.vars.lase_awake = arg_11_0.vars.grade_slider_button:getPercent()
		arg_11_0.vars.grade_slider_button.min = arg_11_0.vars.default_grade
		
		arg_11_0.vars.grade_slider_button:setPercent(6)
		
		arg_11_0.vars.level_slider_button.max = 60
		
		arg_11_0.vars.level_slider_button:setMaxPercent(arg_11_0.vars.level_slider_button.max)
		arg_11_0.vars.level_slider_button:setPercent(arg_11_0.vars.level_slider_button.max)
		arg_11_0:updateStat()
	end
end

function HeroStatViewer.updateLevelSlider(arg_12_0)
	if not arg_12_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_12_0.vars.level_slider_button) then
		return 
	end
	
	if not get_cocos_refid(arg_12_0.vars.grade_slider_button) then
		return 
	end
	
	if arg_12_0:isZodiacMode() then
		arg_12_0.vars.level_slider_button:setPercent(arg_12_0.vars.level_slider_button.max)
	end
end

function HeroStatViewer.isZodiacMode(arg_13_0)
	if not arg_13_0.vars or not get_cocos_refid(arg_13_0.vars.check_box_awake) then
		return false
	end
	
	return arg_13_0.vars.check_box_awake:isSelected()
end

function HeroStatViewer.isPotentialMode(arg_14_0)
	if not arg_14_0.vars or not get_cocos_refid(arg_14_0.vars.check_box_potentail) then
		return false
	end
	
	return arg_14_0.vars.check_box_potentail:isSelected()
end

function HeroStatViewer.isVisible(arg_15_0)
	return arg_15_0.vars and get_cocos_refid(arg_15_0.vars.stat_wnd)
end
