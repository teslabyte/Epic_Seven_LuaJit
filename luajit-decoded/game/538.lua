UnitZodiacRune = {}

copy_functions(UnitZodiacBase, UnitZodiacRune)

local var_0_0 = 5
local var_0_1 = 3

function MsgHandler.skillrune_enhance(arg_1_0)
	local var_1_0 = Account:getUnit(to_n(arg_1_0.target))
	
	UnitZodiac:respRuneEnhance(arg_1_0)
	var_1_0:calc()
	UnitDetail:updateUnitInfo(var_1_0, true)
end

function MsgHandler.skillrune_reset(arg_2_0)
	local var_2_0 = Account:getUnit(to_n(arg_2_0.target))
	
	var_2_0:setSTreeInfos(arg_2_0.stree)
	Account:updateCurrencies(arg_2_0.currency)
	Account:addReward(arg_2_0.rewards, {
		ignore_get_condition = true
	})
	UnitZodiac:procFunc(nil, "updateComponents", true)
	UnitZodiac:updateInterfaces(true)
	UnitZodiac:updateSkillPoint()
	UnitZodiac:focusOut()
	var_2_0:calc()
	UnitDetail:updateUnitInfo(var_2_0, true)
end

function UnitZodiacRune.onEnter(arg_3_0, arg_3_1)
	if not arg_3_0.vars or not get_cocos_refid(arg_3_0.vars.rune_layer) then
		return 
	end
	
	arg_3_0.vars.rune_layer:setVisible(false)
	arg_3_0.vars.rune_layer:setOpacity(0)
	arg_3_0.vars.rune_layer:setScale(0)
	UIAction:Add(SEQ(SHOW(true), SPAWN(TARGET(arg_3_0.vars.wnd, OPACITY(200, 0, 1)), SCALE(200, 0, 1))), arg_3_0.vars.rune_layer, "block")
end

function UnitZodiacRune.onLeave(arg_4_0)
	UIAction:Add(SPAWN(SCALE(250, 1, 0)), arg_4_0.vars.rune_layer, "block")
	
	arg_4_0.vars = nil
end

function UnitZodiacRune.onModeEnter(arg_5_0)
	UIAction:Add(SEQ(SHOW(true), SPAWN(OPACITY(200, 0, 1), SCALE(200, 2, 1))), arg_5_0.vars.rune_layer, "block")
	
	if EpisodeAdin:isAdinCode(UnitZodiac:getUnit().db.code) then
		local var_5_0 = UnitZodiac.vars.wnd:getChildByName("n_item_mix2")
		
		if_set_opacity(var_5_0, "btn_catalyst", 76.5)
		if_set_opacity(var_5_0, "btn_item_mix", 76.5)
	end
end

function UnitZodiacRune.onModeLeave(arg_6_0)
	UIAction:Add(SEQ(SPAWN(OPACITY(200, 1, 0), SCALE(200, 1, 2)), SHOW(false)), arg_6_0.vars.rune_layer, "block")
end

function UnitZodiacRune.hide(arg_7_0)
	if arg_7_0.vars and get_cocos_refid(arg_7_0.vars.rune_layer) then
		arg_7_0.vars.rune_layer:setVisible(false)
	end
end

function UnitZodiacRune.createBaseLayer(arg_8_0, arg_8_1)
	local var_8_0 = (arg_8_1 or {}).parent
	
	arg_8_0.vars.layer = cc.Layer:create()
	arg_8_0.vars.rune_layer = cc.Layer:create()
	
	arg_8_0.vars.rune_layer:ignoreAnchorPointForPosition(false)
	arg_8_0.vars.rune_layer:setAnchorPoint(0.5, 0.5)
	arg_8_0.vars.rune_layer:setPosition(0, 0)
	arg_8_0.vars.rune_layer:setVisible(false)
	arg_8_0.vars.layer:addChild(arg_8_0.vars.rune_layer)
	UnitZodiac:push_BGLayer({
		arg_8_0.vars.rune_layer,
		0.5,
		1.6
	})
	
	if get_cocos_refid(var_8_0) then
		var_8_0:addChild(arg_8_0.vars.layer)
	end
	
	if arg_8_0:_makeSkillTreeData() then
		arg_8_0.vars.wnd = load_dlg("unit_zodiac_skilltree", true, "wnd")
		
		arg_8_0.vars.rune_layer:addChild(arg_8_0.vars.wnd)
		
		local var_8_1 = UnitZodiac:getUnit()
		local var_8_2 = not CollectionMainUI:isShowDictMain()
		local var_8_3 = not UnitMain:isShow()
		local var_8_4 = UnitExtension:isAttrChangeableUnit(var_8_1 and var_8_1.db.code)
		
		if var_8_1 and var_8_2 and var_8_3 and var_8_4 then
			local var_8_5 = cc.LayerColor:create(cc.c3b(0, 0, 0))
			
			var_8_5:setContentSize(999999, 999999)
			var_8_5:setPosition(-1000, 0)
			var_8_0:getParent():addChild(var_8_5)
			var_8_5:sendToBack()
			var_8_5:setName("@black")
			var_8_5:setTouchEnabled(true)
			var_8_5:setOpacity(0)
			
			local var_8_6 = ccui.Button:create()
			
			var_8_6:setTouchEnabled(true)
			var_8_6:ignoreContentAdaptWithSize(false)
			var_8_6:setContentSize(999999, 999999)
			var_8_6:setPosition(-1000, 360)
			var_8_6:setName("btn_block")
			var_8_5:addChild(var_8_6)
			
			arg_8_0.vars.black_layer = var_8_5
			
			UIAction:Add(FADE_IN(150), arg_8_0.vars.black_layer, "block")
			TopBarNew:createFromPopup(T("awaken_adin_title"), var_8_0:getParent(), function()
				if UnitZodiacRune.vars and UnitZodiacRune.vars.black_layer then
					UIAction:Add(SEQ(FADE_OUT(150), REMOVE()), UnitZodiacRune.vars.black_layer, "block")
				end
				
				if UnitZodiac:isDictMode() then
					UnitZodiac:endDictMode()
					BackButtonManager:pop()
				else
					UnitZodiac:onLeave()
					BackButtonManager:pop()
				end
				
				TopBarNew:pop()
			end, nil, "infoadve1_11", {
				force_unit_top_layer = true
			})
		end
	else
		return 
	end
	
	return true
end

function UnitZodiacRune.regCursor(arg_10_0, arg_10_1)
	if get_cocos_refid(arg_10_1) then
		arg_10_1:setVisible(false)
		arg_10_1:removeFromParent()
		arg_10_0.vars.rune_layer:addChild(arg_10_1)
		
		arg_10_0.vars.cursor = arg_10_1
		
		arg_10_1:setLocalZOrder(999999)
	end
end

function UnitZodiacRune.getHelpID(arg_11_0)
	return "growth_5_2"
end

function UnitZodiacRune._makeSkillTreeData(arg_12_0)
	local var_12_0 = UnitZodiac:getUnit()
	local var_12_1 = string.format("st_%s_", var_12_0.db.code)
	local var_12_2 = {}
	local var_12_3 = true
	local var_12_4 = 0
	
	for iter_12_0 = 1, var_0_0 do
		local var_12_5 = {}
		local var_12_6 = var_12_1 .. iter_12_0
		local var_12_7 = DBT("skill_tree", var_12_6, {
			"id",
			"skill_point",
			"pos_1",
			"req_1",
			"pos_2",
			"req_2",
			"pos_3",
			"req_3"
		})
		
		if not var_12_7.id then
			var_12_3 = false
			
			break
		end
		
		var_12_5.id = var_12_6
		var_12_5.skill_point = var_12_7.skill_point
		var_12_5.childs = {}
		var_12_5.line_num = iter_12_0
		
		for iter_12_1 = 1, var_0_1 do
			local var_12_8 = {
				id = var_12_7["pos_" .. iter_12_1],
				req = var_12_7["req_" .. iter_12_1],
				pos = iter_12_0 .. "_" .. iter_12_1,
				index = (iter_12_0 - 1) * var_0_1 + iter_12_1,
				line_num = iter_12_0
			}
			
			if var_12_8.id then
				var_12_4 = var_12_4 + 1
				var_12_8.num = var_12_4
				var_12_8.opts = {}
				
				for iter_12_2 = 0, 99 do
					local var_12_9 = {}
					local var_12_10 = var_12_8.id .. "_" .. iter_12_2
					local var_12_11 = DBT("skill_tree_rune", var_12_10, {
						"id",
						"name",
						"type",
						"icon_rune",
						"icon_mark",
						"stat",
						"value",
						"skill_number",
						"skill_lv",
						"parent_skill_number",
						"tooltip",
						"tooltip_up",
						"tooltip_value",
						"tooltip_up_value"
					})
					
					if not var_12_11.id then
						break
					end
					
					table.merge(var_12_9, var_12_11)
					table.insert(var_12_8.opts, var_12_9)
				end
			end
			
			table.insert(var_12_5.childs, iter_12_1, var_12_8)
		end
		
		var_12_5.next_num = var_12_4
		
		table.insert(var_12_2, var_12_5)
	end
	
	arg_12_0.vars.runes_data = var_12_2
	
	return var_12_3
end

function UnitZodiacRune.updateSkillRune(arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = UnitZodiac:getUnit()
	local var_13_1 = var_13_0:getSTreeLevel(arg_13_2.num)
	local var_13_2 = false
	local var_13_3 = arg_13_2.opts[math.min(#arg_13_2.opts, var_13_1 + 1)]
	local var_13_4 = var_13_3.icon_mark
	local var_13_5 = var_13_3.icon_rune
	local var_13_6 = var_13_1 == 0
	
	if var_13_6 then
		var_13_5 = var_13_5 .. "_b"
	end
	
	replaceSprite(arg_13_1, "icon_bg", "classchange/" .. var_13_5 .. ".png")
	replaceSprite(arg_13_1, "icon_mark", "classchange/" .. var_13_4 .. ".png")
	if_set(arg_13_1, "skill_up", "+" .. var_13_1)
	if_set_visible(arg_13_1, "skill_up_bg", var_13_1 > 0)
	if_set_color(arg_13_1, "icon_mark", not var_13_6 and cc.c3b(255, 255, 255) or cc.c3b(10, 10, 10))
	if_set_opacity(arg_13_1, "icon_mark", not var_13_6 and 255 or 186)
	
	local var_13_7 = arg_13_1:getChildByName("icon_skill")
	
	if get_cocos_refid(var_13_7) then
		local var_13_8 = arg_13_2.opts[#arg_13_2.opts].parent_skill_number
		
		if var_13_8 and var_13_8 > 0 then
			local var_13_9 = DB("skill", var_13_0:getSkillByIndex(var_13_8), "sk_icon")
			
			replaceSprite(arg_13_1, "icon_skill", "skill/" .. var_13_9 .. ".png")
			var_13_7:setColor(not var_13_6 and cc.c3b(255, 255, 255) or cc.c3b(136, 136, 136))
			var_13_7:setVisible(true)
		else
			var_13_7:setVisible(false)
		end
	end
	
	local var_13_10 = arg_13_1:getParent()
	
	if get_cocos_refid(var_13_10) then
		local var_13_11 = var_13_10:getChildByName("rune_effect")
		
		if var_13_1 > 0 then
			if not get_cocos_refid(var_13_11) then
				EffectManager:Play({
					z = 99998,
					fn = "ui_skill_tree_eff_loop.cfx",
					y = 0,
					x = 0,
					layer = var_13_10
				}):setName("rune_effect")
			end
		elseif get_cocos_refid(var_13_11) then
			var_13_11:removeFromParent()
		end
	end
	
	arg_13_0:updateSkillLine(arg_13_2)
end

function UnitZodiacRune.updateSkillLine(arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = arg_14_0:getSkillRuneInfo(arg_14_1.req)
	
	if var_14_0 and var_14_0.id then
		local var_14_1 = arg_14_0.vars.wnd:getChildByName(var_14_0.pos)
		local var_14_2 = arg_14_0.vars.wnd:getChildByName(arg_14_1.pos)
		
		if get_cocos_refid(var_14_2) and get_cocos_refid(var_14_1) then
			local var_14_3 = cc.Node:create()
			local var_14_4 = var_14_1:getPositionX()
			local var_14_5 = var_14_1:getPositionY()
			local var_14_6 = var_14_2:getPositionX()
			local var_14_7 = var_14_2:getPositionY()
			local var_14_8 = var_14_6 - var_14_4
			
			var_14_3:setPosition(var_14_4, var_14_5)
			
			local var_14_9 = math.atan2(var_14_5 - var_14_7, var_14_6 - var_14_4) * 180 / math.pi + 90
			local var_14_10 = math.sqrt(math.pow(var_14_4 - var_14_6, 2) + math.pow(var_14_5 - var_14_7, 2))
			local var_14_11 = UnitZodiac:getUnit():getSTreeLevel(arg_14_1.num) > 0
			
			addLine(var_14_3, var_14_11 and "img/cm_select_lineon_short.png" or "img/cm_select_lineoff_short.png", var_14_10, true)
			
			local var_14_12 = var_14_0.pos .. "+" .. arg_14_1.pos
			local var_14_13 = arg_14_0.vars.wnd:getChildByName(var_14_12)
			
			if get_cocos_refid(var_14_13) then
				var_14_13:removeFromParent()
			end
			
			var_14_3:setName(var_14_12)
			var_14_3:setRotation(var_14_9)
			var_14_3:setLocalZOrder(-1)
			arg_14_0.vars.wnd:addChild(var_14_3)
		end
	end
end

function UnitZodiacRune.makeSkillRune(arg_15_0, arg_15_1, arg_15_2)
	local var_15_0 = arg_15_2 or {}
	local var_15_1 = cc.CSLoader:createNode("wnd/zodiac_skilltree.csb")
	
	if get_cocos_refid(var_15_0.parent) then
		var_15_1:setName("rune_" .. arg_15_1.index)
		var_15_0.parent:addChild(var_15_1)
	end
	
	arg_15_0:updateSkillRune(var_15_1, arg_15_1)
	
	if var_15_0.add_line and arg_15_1.req then
		arg_15_0:updateSkillLine(arg_15_1)
	end
	
	if var_15_0.add_button then
		local var_15_2 = ccui.Button:create()
		
		var_15_2:setTouchEnabled(true)
		var_15_2:ignoreContentAdaptWithSize(false)
		var_15_2:setContentSize(80, 80)
		var_15_2:setName(arg_15_1.pos)
		var_15_2:addTouchEventListener(arg_15_0.onPushMaterial)
		var_15_1:addChild(var_15_2)
	end
	
	return var_15_1
end

function UnitZodiacRune.getSkillRuneInfo(arg_16_0, arg_16_1, arg_16_2)
	if not arg_16_0.vars.runes_data then
		return 
	end
	
	local var_16_0 = arg_16_2 or "id"
	
	if var_16_0 == "index" or var_16_0 == "num" then
		arg_16_1 = tonumber(arg_16_1)
	end
	
	if not arg_16_1 then
		return 
	end
	
	for iter_16_0, iter_16_1 in pairs(arg_16_0.vars.runes_data) do
		for iter_16_2, iter_16_3 in pairs(iter_16_1.childs or {}) do
			if arg_16_1 == iter_16_3[var_16_0] then
				return iter_16_3
			end
		end
	end
end

function UnitZodiacRune.getNeedItemList(arg_17_0)
	local var_17_0 = {}
	
	for iter_17_0 = 1, 30 do
		local var_17_1 = arg_17_0:getCostInfo(iter_17_0)
		
		if not var_17_1 then
			break
		end
		
		table.insert(var_17_0, {
			var_17_1.res1,
			var_17_1.res1_count
		})
		table.insert(var_17_0, {
			var_17_1.res2,
			var_17_1.res2_count
		})
	end
	
	return var_17_0
end

function UnitZodiacRune.focusIn(arg_18_0, arg_18_1)
	local var_18_0 = arg_18_0:getSkillRuneInfo(arg_18_1, "pos")
	
	UnitZodiac:updateSidePanel(var_18_0)
	
	local var_18_1, var_18_2 = arg_18_0.vars.layer:getChildByName(arg_18_1):getPosition()
	
	UnitZodiac:setZoomIndex(-var_18_0.num)
	UnitZodiac:zoominMaterial(var_18_1, var_18_2)
	arg_18_0.vars.cursor:setPosition(var_18_1, var_18_2)
	arg_18_0.vars.cursor:setScale(1.2)
	arg_18_0.vars.cursor:setVisible(false)
	arg_18_0.vars.cursor:setOpacity(0)
	if_set_visible(arg_18_0.vars.cursor, "txt_caution", false)
	UIAction:Add(SEQ(DELAY(190), SHOW(true), SPAWN(FADE_IN(60), SCALE(60, 1.2, 0.8))), arg_18_0.vars.cursor)
end

function UnitZodiacRune.focusOut(arg_19_0)
	arg_19_0.vars.cursor:setVisible(false)
end

function UnitZodiacRune.updateSidePanel(arg_20_0, arg_20_1, arg_20_2)
	if type(arg_20_2) == "string" then
		arg_20_2 = arg_20_0:getSkillRuneInfo(arg_20_2)
	end
	
	local var_20_0 = arg_20_1:getChildByName("n_rune_pos")
	
	if get_cocos_refid(var_20_0) then
		var_20_0:removeAllChildren()
		arg_20_0:makeSkillRune(arg_20_2, {
			isActiveMode = true,
			parent = var_20_0
		})
	end
	
	if_set_visible(arg_20_1, "n_right_stars", false)
	if_set_visible(arg_20_1, "n_stone_pos", false)
	if_set_visible(arg_20_1, "n_rune_pos", false)
	if_set_visible(arg_20_1, "n_rune", true)
	if_set_visible(arg_20_1, "n_zodiac", false)
	if_set_visible(arg_20_1, "n_skilltree", true)
	if_set_visible(arg_20_1, "n_bonus_keystone", false)
	if_set_visible(arg_20_1, "btn_up", false)
	if_set_visible(arg_20_1, "btn_skill_enhancement", true)
	if_set_visible(arg_20_1, "txt_stone_name", false)
	if_set_visible(arg_20_1, "txt_rune_name", true)
	if_set_visible(arg_20_1, "txt_desc", true)
	
	local var_20_1 = UnitZodiac:getUnit():getSTreeLevel(arg_20_2.num)
	local var_20_2 = arg_20_2.opts
	local var_20_3 = var_20_2[math.min(#var_20_2, var_20_1 + 1)]
	
	if_set(arg_20_1, "txt_rune_name", T(var_20_3.name))
	arg_20_1:getChildByName("n_skill_tooltip"):removeAllChildren()
	arg_20_0:resetSidePanel(arg_20_1)
	
	local var_20_4 = arg_20_0:getCostInfo()
	local var_20_5
	
	if table.empty(var_20_4) then
		if_set_visible(arg_20_1:getChildByName("n_res"), "title", false)
	else
		if_set_visible(arg_20_1:getChildByName("n_res"), "title", true)
		
		var_20_5 = #{
			var_20_4.res1,
			var_20_4.res2
		}
		
		for iter_20_0 = 1, 2 do
			local var_20_6 = var_20_4["res" .. iter_20_0]
			
			if var_20_6 then
				local var_20_7 = var_20_4["res" .. iter_20_0 .. "_count"]
				local var_20_8 = arg_20_1:getChildByName("n_upgrade"):getChildByName("n_res" .. iter_20_0 .. "/" .. var_20_5)
				
				var_20_8:removeAllChildren()
				UIUtil:getRewardIcon(var_20_7, var_20_6, {
					show_count = true,
					no_frame = true,
					scale = 0.8,
					parent = var_20_8,
					count = to_n(var_20_7)
				})
				
				if to_n(var_20_7) > Account:getItemCount(var_20_6) then
					var_20_8:setOpacity(102)
				else
					var_20_8:setOpacity(255)
				end
				
				if_set_visible(arg_20_1, "n_lack_item" .. iter_20_0 .. "/" .. var_20_5, to_n(var_20_7) > Account:getItemCount(var_20_6))
			end
		end
	end
	
	arg_20_0:updateSkillTree(arg_20_1, arg_20_2)
end

function UnitZodiacRune.updateSkillTree(arg_21_0, arg_21_1, arg_21_2)
	local var_21_0 = arg_21_1:findChildByName("n_skilltree")
	
	if not get_cocos_refid(var_21_0) then
		return 
	end
	
	local var_21_1 = arg_21_1:findChildByName("txt_desc")
	
	if get_cocos_refid(var_21_1) and tolua:type(var_21_1) ~= "ccui.RichText" then
		var_21_1 = upgradeLabelToRichLabel(arg_21_1, "txt_desc", true)
	end
	
	local var_21_2 = UnitZodiac:getUnit():getSTreeLevel(arg_21_2.num)
	local var_21_3 = arg_21_2.opts
	local var_21_4 = var_21_3[math.min(#var_21_3, var_21_2 + 1)]
	
	if_set(var_21_1, nil, T(var_21_4.tooltip, {
		tooltip_value = var_21_4.tooltip_value
	}))
	
	local var_21_5 = var_21_0:getChildByName("disc_pannel")
	
	var_21_5.need_inner_scroll_size = 0
	
	local var_21_6 = 203
	
	for iter_21_0 = 1, 3 do
		local var_21_7 = var_21_0:getChildByName("t_" .. iter_21_0 .. "disc")
		
		if not var_21_7 then
			break
		end
		
		if_set(var_21_7, nil, T(var_21_3[iter_21_0 + 1].tooltip_up, {
			tooltip_value = var_21_3[iter_21_0 + 1].tooltip_up_value
		}))
		if_set_color(var_21_7, nil, iter_21_0 <= var_21_2 and cc.c3b(255, 255, 255) or cc.c3b(68, 68, 68))
		
		local var_21_8 = var_21_7:getTextBoxSize().height
		
		var_21_7:setContentSize({
			width = var_21_7:getContentSize().width,
			height = var_21_8
		})
		
		var_21_5.need_inner_scroll_size = var_21_5.need_inner_scroll_size + var_21_8
		
		var_21_7:setPositionY(var_21_6)
		
		local var_21_9 = var_21_7:getChildByName("t_up")
		
		if var_21_9 then
			var_21_9:setPositionY(var_21_8)
		end
		
		var_21_6 = var_21_6 - var_21_8
	end
	
	UIUserData:proc(var_21_5)
end

function UnitZodiacRune.getInfoByIndex(arg_22_0, arg_22_1)
	return arg_22_0:getSkillRuneInfo(arg_22_1 * -1, "num")
end

function UnitZodiacRune.isMaxLevel(arg_23_0, arg_23_1)
	local var_23_0 = UnitZodiac:getUnit()
	local var_23_1 = arg_23_0:getSkillRuneInfo(arg_23_1, "num")
	local var_23_2 = var_23_0:getSTreeLevel(var_23_1.num)
	
	if var_23_1.opts and var_23_2 >= #var_23_1.opts - 1 then
		return true
	end
	
	return false
end

function UnitZodiacRune.getEnhancable(arg_24_0, arg_24_1)
	local var_24_0 = arg_24_0:getCostInfo()
	
	if not table.empty(var_24_0) then
		local var_24_1 = #{
			var_24_0.res1,
			var_24_0.res2
		}
		
		for iter_24_0 = 1, 2 do
			local var_24_2 = var_24_0["res" .. iter_24_0]
			
			if var_24_2 then
				local var_24_3 = var_24_0["res" .. iter_24_0 .. "_count"]
				
				if to_n(var_24_3) > Account:getItemCount(var_24_2) then
					return false
				end
			end
		end
	end
	
	local var_24_4 = UnitZodiac:getUnit()
	local var_24_5 = arg_24_0:getSkillRuneInfo(arg_24_1, "num")
	
	if var_24_5.req then
		local var_24_6 = arg_24_0:getSkillRuneInfo(var_24_5.req)
		
		if var_24_6.num and var_24_4:getSTreeLevel(var_24_6.num) <= 0 then
			return false
		end
	end
	
	local var_24_7 = var_24_4:getSTreeLevel(var_24_5.num)
	
	if var_24_5.opts and var_24_7 >= #var_24_5.opts - 1 then
		return false
	end
	
	local var_24_8 = var_24_4:getSTreeTotalPoint()
	local var_24_9 = var_24_5.line_num
	
	if arg_24_0.vars.runes_data then
		for iter_24_1, iter_24_2 in pairs(arg_24_0.vars.runes_data) do
			if iter_24_2.line_num and iter_24_2.line_num == var_24_9 and iter_24_2.skill_point and var_24_8 < iter_24_2.skill_point then
				return false
			end
		end
	end
	
	return true
end

function UnitZodiacRune.getCostInfo(arg_25_0, arg_25_1)
	local var_25_0 = UnitZodiac:getUnit()
	local var_25_1 = arg_25_1 or var_25_0:getSTreeTotalPoint() + 1
	local var_25_2
	
	if EpisodeAdin:isAdinCode(var_25_0.db.code) then
		var_25_2 = var_25_0.db.code .. "_" .. var_25_1
	else
		var_25_2 = var_25_0:getColor() .. "_" .. var_25_1
	end
	
	return (DBT("skill_tree_material", var_25_2, {
		"res1",
		"res1_count",
		"res2",
		"res2_count",
		"reset_token",
		"reset_count"
	}))
end

function UnitZodiacRune.updateComponents(arg_26_0, arg_26_1)
	local var_26_0 = UnitZodiac:getUnit():getSTreeTotalPoint()
	
	for iter_26_0, iter_26_1 in pairs(arg_26_0.vars.runes_data) do
		local var_26_1 = "n_" .. iter_26_0
		local var_26_2 = arg_26_0.vars.wnd:getChildByName(var_26_1)
		local var_26_3 = iter_26_1.skill_point
		local var_26_4 = var_26_0 >= (iter_26_1.skill_point or 0)
		
		if get_cocos_refid(var_26_2) then
			if_set_visible(var_26_2, "cm_icon_check", var_26_4)
			if_set_opacity(var_26_2, "txt", var_26_4 and 255 or 76)
			
			if var_26_3 then
				var_26_2:setVisible(true)
				if_set(var_26_2, "txt", "+" .. var_26_3)
			else
				var_26_2:setVisible(false)
			end
		end
		
		local var_26_5 = arg_26_0.vars.wnd:getChildByName("line_flloor" .. iter_26_0)
		
		if get_cocos_refid(var_26_5) then
			var_26_5:setLocalZOrder(-2)
			
			local var_26_6 = var_26_5:getParent()
			
			if var_26_4 then
				if not var_26_5.eff then
					local var_26_7
					
					if arg_26_1 then
						var_26_7 = EffectManager:Play({
							z = -1,
							fn = "ui_skill_tree_line_eff.cfx",
							layer = var_26_6,
							x = var_26_5:getPositionX(),
							y = var_26_5:getPositionY()
						})
					else
						var_26_7 = EffectManager:Play({
							z = -1,
							fn = "ui_skill_tree_line_eff_loop.cfx",
							layer = var_26_6,
							x = var_26_5:getPositionX(),
							y = var_26_5:getPositionY()
						})
					end
					
					var_26_7:setRotationSkewX(var_26_5:getRotationSkewX())
					var_26_7:setRotationSkewY(var_26_5:getRotationSkewY())
					var_26_7:setName("line_effect" .. iter_26_0)
					
					var_26_5.eff = var_26_7
				end
			else
				local var_26_8 = var_26_6:getChildByName("line_effect" .. iter_26_0)
				
				if get_cocos_refid(var_26_8) then
					var_26_8:removeFromParent()
				end
				
				var_26_5.eff = nil
			end
		end
		
		for iter_26_2, iter_26_3 in pairs(iter_26_1.childs or {}) do
			if iter_26_3.id then
				local var_26_9 = arg_26_0.vars.wnd:getChildByName(iter_26_3.pos)
				
				if get_cocos_refid(var_26_9) then
					local var_26_10 = var_26_9:getChildByName("rune_" .. iter_26_3.index)
					
					if not get_cocos_refid(var_26_10) then
						var_26_10 = arg_26_0:makeSkillRune(iter_26_3, {
							add_button = true,
							add_line = true,
							parent = var_26_9
						})
					end
					
					if get_cocos_refid(var_26_10) then
						arg_26_0:updateSkillRune(var_26_10, iter_26_3)
					end
				end
			end
		end
	end
end

function UnitZodiacRune.reqEnhance(arg_27_0, arg_27_1)
	if not arg_27_1 then
		balloon_message_with_sound("ui_rune_enhance_not_select")
		
		return 
	end
	
	if UnitZodiacRune:isMaxLevel(math.abs(arg_27_1)) then
		balloon_message_with_sound("ui_rune_enhance_is_max")
		
		return 
	end
	
	if not arg_27_0:getEnhancable(math.abs(arg_27_1)) then
		balloon_message_with_sound("ui_rune_enhance_not_yet")
		
		return 
	end
	
	arg_27_1 = math.abs(arg_27_1)
	
	local var_27_0 = arg_27_0:getSkillRuneInfo(arg_27_1, "num")
	
	query("skillrune_enhance", {
		target = UnitZodiac:getUnit():getUID(),
		rune_id = var_27_0.id
	})
end

function UnitZodiacRune.respEnhance(arg_28_0, arg_28_1)
	local function var_28_0(arg_29_0)
		local var_29_0 = {}
		
		for iter_29_0, iter_29_1 in pairs(arg_28_0.vars.runes_data) do
			if iter_29_1.skill_point then
				table.insert(var_29_0, iter_29_1.skill_point)
			end
		end
		
		local var_29_1 = 0
		
		for iter_29_2, iter_29_3 in pairs(var_29_0) do
			if iter_29_3 <= arg_29_0 then
				var_29_1 = var_29_1 + 1
			end
		end
		
		return var_29_1
	end
	
	local var_28_1 = Account:getUnit(to_n(arg_28_1.target))
	
	for iter_28_0, iter_28_1 in pairs(arg_28_1.items) do
		Account:setItemCount(iter_28_0, iter_28_1)
	end
	
	local var_28_2 = var_28_1:getSTreeTotalPoint()
	local var_28_3 = var_28_0(var_28_2)
	
	var_28_1:setSTreeInfos(arg_28_1.stree)
	
	local var_28_4 = var_28_1:getSTreeTotalPoint()
	
	if var_28_3 < var_28_0(var_28_4) then
		UnitZodiac:focusOut()
	end
	
	local var_28_5 = arg_28_0:getSkillRuneInfo(arg_28_1.rune_id, "id")
	local var_28_6 = arg_28_0.vars.wnd:getChildByName(var_28_5.pos)
	
	UIAction:Add(SEQ(CALL(function()
		local var_30_0 = var_28_6:getChildByName("rune_effect")
		
		if get_cocos_refid(var_30_0) then
			var_30_0:removeFromParent()
		end
		
		EffectManager:Play({
			z = 99998,
			fn = "ui_skill_tree_eff.cfx",
			y = 0,
			x = 0,
			layer = var_28_6
		}):setName("rune_effect")
	end), DELAY(100), CALL(function()
		UnitZodiac:updateSidePanel(var_28_5)
		arg_28_0:updateComponents(true)
	end)), var_28_6, "block")
	UIAction:Add(SEQ(RLOG(OPACITY(1200, 0, 1))), arg_28_0.vars.cursor)
end
