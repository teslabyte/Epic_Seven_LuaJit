RumbleBench = {}

function RumbleBench.init(arg_1_0, arg_1_1)
	if not get_cocos_refid(arg_1_1) then
		return 
	end
	
	arg_1_0.vars = {}
	arg_1_0.vars.layer = arg_1_1
	
	local var_1_0 = RumblePlayer:getBenchUnits()
	local var_1_1 = RumbleBelt:create("rumble")
	
	var_1_1:resetData(var_1_0, "rumble")
	
	local var_1_2 = var_1_1:getCurrentControl()
	
	if_set_visible(var_1_2, "add", true)
	arg_1_0.vars.layer:addChild(var_1_1:getWindow())
	
	arg_1_0.vars.hero_belt = var_1_1
	
	arg_1_0.vars.hero_belt:setEventHandler(arg_1_0.onHeroListEvent, arg_1_0)
end

function RumbleBench.onHeroListEvent(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	if not arg_2_0.vars then
		return 
	end
	
	if RumbleSystem:isInBattle() then
		return 
	end
	
	if arg_2_1 == "select" and arg_2_2 and arg_2_3 then
		RumbleUnitPopup:open({
			unit = arg_2_2
		})
	end
	
	if arg_2_1 == "change" then
		arg_2_0:deselectUnit()
		
		local var_2_0 = arg_2_0.vars.hero_belt:getControl(arg_2_2)
		local var_2_1 = arg_2_0.vars.hero_belt:getControl(arg_2_3)
		
		if_set_visible(var_2_0, "add", false)
		if_set_visible(var_2_1, "add", true)
	end
	
	if arg_2_1 == "add" then
		if RumbleBoard:getSelectedUnit() then
			RumbleBoard:showTiles(false, true)
			RumbleBoard:deselectUnit()
		end
		
		arg_2_0:selectUnit(arg_2_2)
	end
end

function RumbleBench.onSummonUnit(arg_3_0, arg_3_1)
	if not arg_3_0.vars then
		return 
	end
	
	if arg_3_0.vars.hero_belt then
		local var_3_0 = RumblePlayer:getBenchUnits()
		
		arg_3_0.vars.hero_belt:resetData(var_3_0, "rumble", arg_3_1)
	end
end

function RumbleBench.revertUnit(arg_4_0, arg_4_1)
	if not arg_4_0.vars then
		return 
	end
	
	if arg_4_0.vars.hero_belt then
		arg_4_0.vars.hero_belt:revertPoppedItem(arg_4_1)
	end
end

function RumbleBench.removeUnit(arg_5_0, arg_5_1)
	if not arg_5_0.vars then
		return 
	end
	
	if arg_5_0.vars.hero_belt then
		arg_5_0.vars.hero_belt:popItem(arg_5_1)
	end
end

function RumbleBench.playDevoteEffect(arg_6_0, arg_6_1)
	if not arg_6_0.vars then
		return 
	end
	
	if arg_6_0.vars.hero_belt then
		local var_6_0 = arg_6_0.vars.hero_belt:getControl(arg_6_1)
		
		if get_cocos_refid(var_6_0) then
			local var_6_1 = var_6_0:getContentSize()
			local var_6_2 = EffectManager:Play({
				extractNodes = true,
				fn = "ui_super_battle_slotglow.cfx",
				layer = var_6_0,
				x = var_6_1.width * 0.5,
				y = var_6_1.height * 0.5
			})
			
			var_6_2:setOpacity(0)
			UIAction:Add(SEQ(FADE_IN(200), DELAY(600), FADE_OUT(200)), var_6_2)
		end
	end
end

function RumbleBench.selectUnit(arg_7_0, arg_7_1)
	if not arg_7_0.vars then
		return 
	end
	
	RumbleBoard:selectUnit(arg_7_1)
	TutorialGuide:procGuide()
end

function RumbleBench.deselectUnit(arg_8_0)
	if not arg_8_0.vars then
		return 
	end
	
	RumbleBoard:deselectUnit()
end

function RumbleBench.show(arg_9_0, arg_9_1)
	if not arg_9_0.vars or not arg_9_0.vars.hero_belt then
		return 
	end
	
	local var_9_0 = arg_9_0.vars.hero_belt:getWindow()
	
	if not get_cocos_refid(var_9_0) then
		return 
	end
	
	if arg_9_1 then
		arg_9_0.vars.hero_belt:scrollToFirstUnit(0.2)
	end
end

RumbleBelt = {}

copy_functions(HeroBelt, RumbleBelt)

function RumbleBelt.resetData(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5, arg_10_6, arg_10_7)
	if not arg_10_0.vars then
		return 
	end
	
	arg_10_0.vars.o_units = arg_10_1
	
	local var_10_0 = {}
	local var_10_1
	
	for iter_10_0, iter_10_1 in pairs(arg_10_1) do
		var_10_0[#var_10_0 + 1] = iter_10_1
	end
	
	arg_10_0.dock:setData(var_10_0, arg_10_0.dock:getGarbages())
	arg_10_0:resetControlColors()
	arg_10_0.dock:arrangeItems()
	arg_10_0:updateHeroCount()
	
	if arg_10_3 then
		arg_10_0.dock:scrollToItem(arg_10_3, 0.2)
		if_set_visible(arg_10_0.dock:getRenderer(arg_10_3), "add", true)
	end
end

function RumbleBelt.create(arg_11_0, arg_11_1)
	arg_11_0.vars = {}
	arg_11_0.vars.wnd = load_dlg("unit_list", true, "wnd")
	
	if_set_visible(arg_11_0.vars.wnd, "layer_sort", false)
	if_set_visible(arg_11_0.vars.wnd, "grow", false)
	if_set_visible(arg_11_0.vars.wnd, "add_inven", false)
	
	local var_11_0 = DockFast:create({
		item_size = 90,
		height = 550,
		item_gap = 60,
		dir = "right",
		selected_item_pos = 0.11,
		width = 250,
		scroll_ratio = 2,
		handler = arg_11_0
	}, arg_11_0.vars.wnd:getChildByName("scrollview"))
	
	arg_11_0.dock = var_11_0
	
	arg_11_0:resetData({}, arg_11_1, nil, true)
	arg_11_0.vars.wnd:getChildByName("layer_unit_bar"):addChild(var_11_0.wnd)
	NotchManager:addListener(arg_11_0.vars.wnd:getChildByName("RIGHT"), false, function(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
		resetPosForNotch(arg_12_0, arg_12_1, {
			isLeft = arg_12_2,
			origin_x = arg_12_3
		})
	end)
	HeroBeltEventInterface:addListener(arg_11_0.vars.wnd, arg_11_0)
	
	local var_11_1 = arg_11_0.vars.wnd:getChildByName("btn_empty")
	
	if get_cocos_refid(var_11_1) then
		var_11_1:addTouchEventListener(function(arg_13_0, arg_13_1)
			if arg_13_1 ~= 2 then
				return 
			end
			
			RumbleBench:deselectUnit()
		end)
	end
	
	return arg_11_0
end

function RumbleBelt.revertPoppedItem(arg_14_0, arg_14_1)
	arg_14_0.dock:revertGarbageItem(arg_14_1)
	arg_14_0.dock:arrangeItems()
	arg_14_0:updateControlsOpacity()
	arg_14_0:updateHeroCount()
end

function RumbleBelt.updateUnitBar(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	arg_15_3 = arg_15_3 or {}
	
	local var_15_0 = arg_15_2 or load_control("wnd/unit_bar.csb")
	
	if_set_visible(var_15_0, "n_state", false)
	if_set_visible(var_15_0, "n_selected", false)
	if_set_visible(var_15_0, "n_banned", false)
	if_set_visible(var_15_0, "n_banned_bg", false)
	if_set_visible(var_15_0, "n_moonlight_destiny", false)
	if_set_visible(var_15_0, "lock", false)
	if_set_visible(var_15_0, "team", false)
	if_set_visible(var_15_0, "resurrection", false)
	if_set_visible(var_15_0, "check", false)
	if_set_visible(var_15_0, "subtask_max", false)
	if_set_visible(var_15_0, "main_bg", false)
	if_set_visible(var_15_0, "n_skillup", false)
	if_set_visible(var_15_0, "n_mp", false)
	if_set_visible(var_15_0, "add", false)
	if_set_visible(var_15_0, "n_name", false)
	if_set_visible(var_15_0, "detail", false)
	
	local var_15_1 = DBT("character", arg_15_1.db.base_chr, {
		"id",
		"face_id",
		"name"
	})
	
	if not var_15_1 then
		return var_15_0
	end
	
	local var_15_2 = var_15_0:getChildByName("n_rumble")
	
	if not get_cocos_refid(var_15_2) then
		return var_15_0
	end
	
	var_15_2:setVisible(true)
	
	local var_15_3 = var_15_2:getChildByName("n_r_dedi")
	
	if get_cocos_refid(var_15_3) then
		var_15_0.dedi_pos_x = var_15_3:getPositionX()
		var_15_0.dedi_pos_y = var_15_3:getPositionY()
		var_15_0.dedi_scale = var_15_3:getScale()
		
		var_15_3:removeFromParent()
	end
	
	local var_15_4 = var_15_2:getChildByName("txt_name")
	
	if not get_cocos_refid(var_15_4) then
		return var_15_0
	end
	
	if not var_15_0.o_name_scale then
		var_15_0.o_name_scale = var_15_4:getScaleX()
	end
	
	var_15_4:setString(T(var_15_1.name))
	
	local var_15_5 = var_15_4:getContentSize().width
	local var_15_6 = 1
	local var_15_7 = 176
	
	if var_15_7 < var_15_5 then
		var_15_6 = var_15_7 / var_15_5
	end
	
	var_15_4:setScaleX(var_15_6 * var_15_0.o_name_scale)
	SpriteCache:resetSprite(var_15_0:getChildByName("face"), "face/" .. (var_15_1.face_id or "") .. "_l.png")
	
	local var_15_8 = RumbleSynergy:getSynergyIcon(arg_15_1:getCamp())
	
	if var_15_8 then
		if_set_sprite(var_15_2, "n_belong", var_15_8)
	end
	
	if_set_visible(var_15_2, "n_belong", var_15_8)
	
	local var_15_9 = RumbleSynergy:getSynergyIcon(arg_15_1:getRole())
	
	if var_15_9 then
		if_set_sprite(var_15_2, "n_role", var_15_9)
	end
	
	if_set_visible(var_15_2, "n_role", var_15_9)
	
	local var_15_10 = var_15_2:getChildByName("n_devote")
	
	if not get_cocos_refid(var_15_10) then
		var_15_10 = cc.Sprite:create("img/hero_dedi_a_none.png")
		
		var_15_10:setName("n_devote")
		var_15_10:setScale(var_15_0.dedi_scale)
		var_15_10:setPosition(var_15_0.dedi_pos_x, var_15_0.dedi_pos_y)
		var_15_2:addChild(var_15_10)
	end
	
	local var_15_11, var_15_12 = UIUtil:getDevoteSprite(arg_15_1, true)
	
	if_set_sprite(var_15_10, nil, var_15_12)
	
	local var_15_13 = arg_15_1:getGrade()
	
	for iter_15_0 = 1, 6 do
		local var_15_14 = var_15_2:getChildByName("star" .. iter_15_0)
		
		if get_cocos_refid(var_15_14) then
			var_15_14:setVisible(iter_15_0 <= var_15_13)
		end
	end
	
	return var_15_0
end

function RumbleBelt.updateControlColor(arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
	arg_16_3 = arg_16_3 or arg_16_1:getRenderer(arg_16_2)
	
	if not arg_16_3 then
		return 
	end
	
	local var_16_0 = arg_16_3:getChildByName("list_tag_memory")
	local var_16_1 = arg_16_3:getChildByName("list_tag_exp")
	local var_16_2 = arg_16_3:getChildByName("list_tag_buff_story")
	
	if var_16_0 then
		arg_16_3:removeChild(var_16_0)
	end
	
	if var_16_1 then
		arg_16_3:removeChild(var_16_1)
	end
	
	if var_16_2 then
		arg_16_3:removeChild(var_16_2)
	end
	
	if arg_16_4 then
		if_set_sprite(arg_16_3, "bg", "img/hero_bg_selected.png")
	else
		if_set_sprite(arg_16_3, "bg", "img/hero_bg_normal.png")
	end
end

function RumbleBelt.updateHeroCount(arg_17_0)
	RumbleUI:updateBenchCount()
	
	if arg_17_0.vars and get_cocos_refid(arg_17_0.vars.wnd) then
		local var_17_0 = arg_17_0.vars.wnd:findChildByName("n_info")
		
		if_set_visible(var_17_0, nil, arg_17_0:getItemCount() == 0)
		if_set(var_17_0, "label", T("ui_unit_list_none"))
	end
end
