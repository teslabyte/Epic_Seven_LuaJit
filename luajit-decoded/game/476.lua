SummonUI = {}

copy_functions(ScrollView, SummonUI)

function HANDLER.summon_item(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_info" then
		SummonUI:showDetail(getParentWindow(arg_1_0).info)
	end
	
	if arg_1_1 == "btn_toggle" or arg_1_1 == "btn_joined" then
		SoundEngine:play("event:/unit_team/change_leader")
		SummonUI:toggle(getParentWindow(arg_1_0).info)
	end
end

function HANDLER.summon_detail(arg_2_0, arg_2_1)
	HANDLER.summon_item(arg_2_0, arg_2_1)
	
	if arg_2_1 == "btn_enhance" then
		balloon_message_with_sound("notyet_dev")
	end
	
	if arg_2_1 == "btn_close" then
		SummonUI:close()
	end
	
	if arg_2_1 == "btn_back" then
		SummonUI:hideDetail()
	end
end

function HANDLER.summon_base(arg_3_0, arg_3_1)
	if arg_3_1 == "btn_close" then
		SummonUI:close()
	end
end

function SummonUI.show(arg_4_0, arg_4_1, arg_4_2)
	arg_4_1 = arg_4_1 or SceneManager:getRunningNativeScene()
	arg_4_0.vars = {}
	arg_4_0.vars.wnd = load_dlg("summon_base", true, "wnd")
	
	UIUtil:slideOpen(arg_4_0.vars.wnd, arg_4_0.vars.wnd:findChildByName("frame"), true)
	
	arg_4_0.vars.parent_class = arg_4_2
	arg_4_0.vars.team_idx = Account:getCurrentTeamIndex()
	
	if arg_4_0.vars.parent_class and arg_4_0.vars.parent_class.isCrehuntMode and arg_4_0.vars.parent_class:isCrehuntMode() then
		arg_4_0.vars.team_idx = Account:getCrehuntTeamIndex()
	end
	
	arg_4_0.vars.scrollview = arg_4_0.vars.wnd:getChildByName("scrollview")
	arg_4_0.vars.summons = {}
	arg_4_0.vars.items = {}
	
	for iter_4_0 = 1, 99 do
		local var_4_0, var_4_1, var_4_2, var_4_3 = DB("character", string.format("s%04d", iter_4_0), {
			"id",
			"name",
			"face_id",
			"role"
		})
		
		if not var_4_0 then
			break
		end
		
		local var_4_4 = {
			idx = iter_4_0,
			code = var_4_0,
			name = var_4_1,
			face = var_4_2,
			role = var_4_3,
			unit = Account:getSummonByCode(var_4_0),
			fake_unit = var_4_4.unit or UNIT:create({
				code = var_4_4.code
			})
		}
		
		arg_4_0.vars.summons[#arg_4_0.vars.summons + 1] = var_4_4
	end
	
	arg_4_0:initScrollView(arg_4_0.vars.wnd:getChildByName("scrollview"), 280, 590, {
		force_horizontal = true
	})
	arg_4_0:createScrollViewItems(arg_4_0.vars.summons)
	arg_4_1:addChild(arg_4_0.vars.wnd)
	BackButtonManager:push({
		check_id = "sinsu_ui_show",
		back_func = function()
			SummonUI:close()
		end
	})
	SoundEngine:play("event:/ui/popup/tap")
	TutorialGuide:procGuide()
end

function SummonUI.addSummonInfo(arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0:getSummonWindow(arg_6_1)
	
	var_6_0:setPosition((arg_6_1 - 1) * 280, 0)
	arg_6_0.vars.scrollview:addChild(var_6_0)
end

function SummonUI.close(arg_7_0)
	if arg_7_0:isShowDetail() then
		arg_7_0:hideDetail()
	else
		UIUtil:slideOpen(arg_7_0.vars.wnd, arg_7_0.vars.wnd:findChildByName("frame"), false)
		BackButtonManager:pop("sinsu_ui_show")
	end
end

function SummonUI.toggle(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0.vars.team_idx or Account:getCurrentTeamIndex()
	
	if not arg_8_1.unit then
		Dialog:msgBox(T("no_summon." .. arg_8_1.code))
		
		return 
	end
	
	if Account:isInTeam(arg_8_1.unit, var_8_0) then
		Account:removeFromTeam(arg_8_1.unit, var_8_0, 5)
	else
		Account:addToTeam(arg_8_1.unit, var_8_0, 5, true)
	end
	
	arg_8_0.vars.parent_class:updateFormation()
	arg_8_0.vars.parent_class:setFormationDirtyFlag(true)
	arg_8_0:close()
	TutorialGuide:procGuide()
end

function SummonUI.onSelectScrollViewItem(arg_9_0, arg_9_1, arg_9_2)
end

function SummonUI.getScrollViewItem(arg_10_0, arg_10_1)
	local var_10_0 = load_dlg("summon_item", true, "wnd")
	
	arg_10_0:setSummonInfo(var_10_0, arg_10_1)
	
	return var_10_0
end

function SummonUI.changeItemButtonState(arg_11_0, arg_11_1)
	if not get_cocos_refid(arg_11_1) then
		return 
	end
	
	if not arg_11_1.info then
		return 
	end
	
	local var_11_0 = arg_11_1.info
	local var_11_1 = arg_11_1.c.n_btn_joined
	local var_11_2 = arg_11_1.c.btn_toggle
	local var_11_3 = arg_11_0.vars.team_idx or Account:getCurrentTeamIndex()
	
	if Account:isInTeam(var_11_0.unit, var_11_3) then
		var_11_2:setVisible(false)
		
		if var_11_1 then
			var_11_1:setVisible(true)
			if_set(var_11_1, "label", T("summon_team_cancle"))
		end
	else
		var_11_2:setVisible(true)
	end
end

function SummonUI.setSummonInfo(arg_12_0, arg_12_1, arg_12_2)
	arg_12_1.info = arg_12_2
	
	local var_12_0 = arg_12_1:getChildByName("n_image")
	local var_12_1 = ccui.ImageView:create()
	
	var_12_1:setAnchorPoint(0, 0)
	SpriteCache:setSpriteTexture(var_12_1, "face/" .. arg_12_2.face .. "_bg.png")
	var_12_1:setScale(var_12_0:getContentSize().height / var_12_1:getContentSize().height)
	var_12_0:addChild(var_12_1)
	
	local var_12_2 = ccui.ImageView:create()
	
	SpriteCache:setSpriteTexture(var_12_2, "face/" .. arg_12_2.face .. "_fu.png")
	var_12_2:setScale(0.7)
	var_12_0:addChild(var_12_2)
	
	if tolua.type(var_12_0) == "ccui.Layout" then
		local var_12_3 = var_12_0:getContentSize()
		
		var_12_2:setPosition(var_12_3.width / 2, var_12_3.height / 2)
	end
	
	local var_12_4 = arg_12_1.c.btn_toggle
	
	if_set_visible(arg_12_1.c.n_btn_joined, nil, false)
	if_set_visible(arg_12_1, "txt_not", arg_12_2.unit == nil)
	
	if arg_12_2.unit then
		arg_12_0:changeItemButtonState(arg_12_1)
		
		if arg_12_1.c.n_lv then
			UIUtil:setLevel(arg_12_1.c.n_lv, arg_12_2.unit:getLv(), arg_12_2.unit:getMaxLevel(), 2)
		end
	else
		var_12_2:setColor(cc.c3b(130, 130, 130))
		var_12_2:getVirtualRenderer():setState(1)
		var_12_1:getVirtualRenderer():setState(1)
		UIUtil:changeButtonState(var_12_4, false)
		if_set(var_12_4, "label", T("summon_none"))
	end
	
	if_set(arg_12_1, "txt_name", T(arg_12_2.name))
	if_set(arg_12_1, "txt_story", T(DB("character", arg_12_2.code, "2line")))
	SpriteCache:resetSprite(arg_12_1:getChildByName("role"), "img/cm_icon_class" .. arg_12_2.role .. ".png")
	
	if arg_12_2.unit then
		UIUtil:setLevelDetail(arg_12_1:getChildByName("n_lv"), arg_12_2.unit:getLv(), arg_12_2.unit:getMaxLevel())
	else
		if_set_visible(arg_12_1, "n_lv", false)
	end
	
	local var_12_5 = to_n(arg_12_2.fake_unit:getSkillReqPoint(arg_12_2.fake_unit:getSkillByIndex(1)))
	
	if_set_visible(arg_12_1, "soul" .. math.floor(var_12_5 / GAME_STATIC_VARIABLE.max_soul_point) + 1, false)
	
	local var_12_6 = arg_12_1:getChildByName("n_skill1")
	
	if var_12_6 then
		local var_12_7 = DB("character", arg_12_2.code, "skill1")
		
		if var_12_7 then
			local var_12_8 = UIUtil:getSkillIcon(arg_12_2.fake_unit, 1, {
				name = true,
				tooltip_opts = {
					show_effs = "left"
				}
			})
			
			var_12_6:addChild(var_12_8)
			upgradeLabelToRichLabel(arg_12_0.vars.wnd, "txt_skill_desc")
			if_set(arg_12_0.vars.wnd, "txt_skill_desc", TooltipUtil:getSkillTooltipText(var_12_7, 0))
		end
	end
	
	arg_12_1:setAnchorPoint(0, 0)
	arg_12_1:setPosition(0, 0)
	table.insert(arg_12_0.vars.items, arg_12_1)
	
	return arg_12_1
end

function SummonUI.updateSummonItems(arg_13_0)
	for iter_13_0, iter_13_1 in pairs(arg_13_0.vars.items) do
		arg_13_0:changeItemButtonState(iter_13_1)
	end
end

function SummonUI.isShow(arg_14_0)
	if arg_14_0.vars and get_cocos_refid(arg_14_0.vars.wnd) then
		return arg_14_0.vars.wnd:isVisible()
	end
	
	return false
end

function SummonUI.hideDetail(arg_15_0)
	if not arg_15_0.vars.detail_wnd then
		return 
	end
	
	BackButtonManager:pop("sinsu_detail_ui_show")
	arg_15_0.vars.detail_wnd:removeFromParent()
	
	arg_15_0.vars.detail_wnd = nil
	
	if_set_visible(arg_15_0.vars.wnd, "scrollview", true)
	arg_15_0:updateSummonItems()
end

function SummonUI.showDetail(arg_16_0, arg_16_1)
	if_set_visible(arg_16_0.vars.wnd, "scrollview", false)
	
	arg_16_0.vars.detail_wnd = load_dlg("summon_detail", true, "wnd")
	
	if_set_visible(arg_16_0.vars.detail_wnd, "g", false)
	arg_16_0.vars.wnd:addChild(arg_16_0.vars.detail_wnd)
	arg_16_0:setSummonInfo(arg_16_0.vars.detail_wnd, arg_16_1)
	
	local var_16_0 = UnitInfosUtil:getCharacterVoiceName(arg_16_1.code)
	
	if_set_visible(arg_16_0.vars.detail_wnd, "t_cv", var_16_0)
	if_set(arg_16_0.vars.detail_wnd, "t_cv", var_16_0)
	UIUtil:alignControl(arg_16_0.vars.detail_wnd, "txt_name", "soul1", 10)
	BackButtonManager:push({
		check_id = "sinsu_detail_ui_show",
		back_func = function()
			SummonUI:hideDetail()
		end
	})
end

function SummonUI.isShowDetail(arg_18_0)
	if not arg_18_0.vars then
		return false
	end
	
	if not get_cocos_refid(arg_18_0.vars.wnd) then
		return false
	end
	
	if not arg_18_0.vars.wnd:findChildByName("scrollview"):isVisible() then
		return true
	end
end
