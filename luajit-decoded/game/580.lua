BossGuide = {}
BossGuideUtil = {}
BOSS_GUIDE_ITEM = "boss_guide_item"
MAX_GUIDE_CORP = 5
MAX_GUIDE_DROP = 10

copy_functions(ScrollView, BossGuide)

function HANDLER.boss_guide(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_close" then
		BossGuide:close()
	end
end

function BossGuide.show(arg_2_0, arg_2_1)
	print("BossGuide enter_id", arg_2_1.enter_id)
	
	if UIAction:Find("block") then
		return 
	end
	
	arg_2_1 = arg_2_1 or {}
	arg_2_0.vars = {}
	arg_2_0.vars.wnd = Dialog:open("wnd/boss_guide", arg_2_0, {
		back_func = function()
			BossGuide:close()
		end
	})
	
	arg_2_0.vars.wnd:setAnchorPoint(0.18, 0.75)
	arg_2_0.vars.wnd:setPosition(230.39999999999998, 540)
	arg_2_0.vars.wnd:setVisible(true)
	
	arg_2_0.vars.scrollView = arg_2_0.vars.wnd:getChildByName("scrollview")
	
	arg_2_0.vars.scrollView:removeAllChildren()
	
	arg_2_0.vars.clearData = arg_2_1.clear_data or Account:getClearEvent(arg_2_1.enter_id) or {}
	arg_2_0.vars.isExpired = Account:isExpiredStage(arg_2_1.enter_id)
	arg_2_0.vars.enter_id = arg_2_1.enter_id
	
	local var_2_0 = T(DB("level_enter", arg_2_1.enter_id, {
		"name"
	}))
	local var_2_1 = T("guide_desc_" .. tostring(arg_2_1.enter_id))
	
	if_set(arg_2_0.vars.wnd, "title", T("level_guide_title", {
		enter_name = var_2_0
	}))
	if_set(arg_2_0.vars.wnd, "desc", var_2_1)
	arg_2_0:initScrollView(arg_2_0.vars.scrollView, 740, 420)
	arg_2_0:createGuideItems(arg_2_1)
	arg_2_0:createScrollViewItems(arg_2_0.vars.guideItems)
	arg_2_0:focusToItem(arg_2_1)
	arg_2_1.parent:addChild(arg_2_0.vars.wnd)
	arg_2_0.vars.wnd:bringToFront()
	SoundEngine:play("event:/ui/popup/tap")
end

function BossGuide.close(arg_4_0)
	BackButtonManager:pop("boss_guide")
	UIAction:Add(SEQ(LOG(SPAWN(FADE_OUT(150), SCALE(150, 1, 0))), REMOVE()), arg_4_0.vars.wnd, "block")
end

function BossGuide.focusToItem(arg_5_0, arg_5_1)
	if not arg_5_1 or not arg_5_1.current_sector_id then
		return 
	end
	
	if #arg_5_0.ScrollViewItems <= 1 then
		return 
	end
	
	local var_5_0 = 1
	
	for iter_5_0 = 1, 999 do
		local var_5_1 = arg_5_1.enter_id .. "_" .. tostring(iter_5_0)
		local var_5_2, var_5_3 = DB("level_guide_ext", var_5_1, {
			"id",
			"stage_data_id"
		})
		
		if var_5_2 == nil then
			break
		end
		
		if var_5_3 == arg_5_1.current_sector_id then
			var_5_0 = to_n(string.sub(var_5_2, -1, -1))
			
			break
		end
	end
	
	arg_5_0:jumpToIndex(var_5_0)
end

function BossGuide.isClear(arg_6_0, arg_6_1)
	if arg_6_0.vars.isExpired then
		return false
	end
	
	if not table.find(arg_6_0.vars.clearData, function(arg_7_0, arg_7_1)
		if DB("level_enter", arg_6_0.vars.enter_id, "contents_type") == "raid" then
			arg_7_0 = string.gsub(arg_7_0, "#", "_")
		end
		
		return arg_7_0 == arg_6_1 and arg_7_1 == true
	end) then
		return false
	end
	
	return true
end

function BossGuide.hasGuide(arg_8_0, arg_8_1)
	arg_8_1 = arg_8_1 or 0
	
	for iter_8_0 = 1, 999 do
		local var_8_0 = DBN("level_guide_ext", iter_8_0, {
			"id"
		})
		
		if not var_8_0 then
			break
		end
		
		if string.starts(tostring(var_8_0), tostring(arg_8_1)) then
			return true
		end
	end
	
	return false
end

function BossGuide.createGuideItems(arg_9_0, arg_9_1)
	arg_9_0.vars.guideItems = {}
	
	for iter_9_0 = 1, 999 do
		local var_9_0 = arg_9_1.enter_id .. "_" .. tostring(iter_9_0)
		local var_9_1, var_9_2 = DB("level_guide_ext", var_9_0, {
			"id",
			"stage_data_id"
		})
		
		if var_9_1 == nil then
			break
		end
		
		local var_9_3 = {}
		
		table.insert(var_9_3, BossGuideUtil:createBossInfo(var_9_0))
		table.insert(var_9_3, BossGuideUtil:createCorpsInfo(var_9_0))
		table.insert(var_9_3, BossGuideUtil:createDropsInfo(var_9_0, arg_9_1.enter_id))
		table.insert(var_9_3, {
			id = var_9_1,
			stage_id = var_9_2,
			is_clear = arg_9_0:isClear(var_9_2)
		})
		table.push(arg_9_0.vars.guideItems, var_9_3)
	end
end

function BossGuide.getScrollViewItem(arg_10_0, arg_10_1)
	local var_10_0 = load_dlg(BOSS_GUIDE_ITEM, true, "wnd")
	
	if arg_10_1 and not table.empty(arg_10_1) then
		arg_10_0:setItemInfo(var_10_0, arg_10_1)
	end
	
	return var_10_0
end

function BossGuide.getBossInfo(arg_11_0, arg_11_1, arg_11_2)
	for iter_11_0 = 1, 999 do
		local var_11_0 = arg_11_1 .. "_" .. tostring(iter_11_0)
		local var_11_1, var_11_2, var_11_3, var_11_4, var_11_5, var_11_6 = DB("level_guide_ext", var_11_0, {
			"id",
			"stage_data_id",
			"boss",
			"lv",
			"grade",
			"power"
		})
		
		if var_11_1 == nil then
			break
		end
		
		if var_11_2 == arg_11_2 then
			return {
				var_11_3,
				var_11_4,
				var_11_5,
				var_11_6
			}
		end
	end
	
	return nil
end

function BossGuide.setItemInfo(arg_12_0, arg_12_1, arg_12_2)
	BossGuideUtil:setBossInfo(arg_12_1, arg_12_2[1])
	BossGuideUtil:setCorpsInfo(arg_12_1, arg_12_2[2])
	BossGuideUtil:setDropsInfo(arg_12_1, arg_12_2[3])
	BossGuideUtil:setAdditionInfo(arg_12_1, arg_12_2[4])
end

function BossGuideUtil.setBossInfo(arg_13_0, arg_13_1, arg_13_2)
	if_set(arg_13_1, "boss_name", T(arg_13_2.name))
	if_set(arg_13_1, "boss_desc", T(arg_13_2.desc))
	if_set_sprite(arg_13_1, "boss_element", "img/cm_icon_prom" .. (arg_13_2.attr or "") .. ".png")
	if_set_sprite(arg_13_1, "boss_role", "img/cm_icon_role_" .. (arg_13_2.role or "") .. ".png")
	
	if arg_13_2.unit then
		UIUtil:setLevel(arg_13_1:getChildByName("n_lv"), arg_13_2.unit:getLv(), nil, 2)
		UIUtil:getRewardIcon(nil, arg_13_2.id, {
			no_db_grade = true,
			hide_star = true,
			scale = 1,
			hide_lv = true,
			monster = true,
			parent = arg_13_1:getChildByName("boss_icon"),
			lv = arg_13_2.unit:getLv(),
			tier = arg_13_2.tier,
			grade = arg_13_2.unit:getGrade(),
			power = arg_13_2.power
		})
	end
end

function BossGuideUtil.setCorpsInfo(arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = 0
	
	for iter_14_0 = 1, MAX_GUIDE_CORP do
		if arg_14_2[iter_14_0] and arg_14_2[iter_14_0].id then
			local var_14_1 = "mob_icon_" .. tostring(iter_14_0)
			
			UIUtil:getRewardIcon(nil, arg_14_2[iter_14_0].id, {
				no_db_grade = true,
				scale = 1,
				monster = true,
				hide_star = true,
				parent = arg_14_1:getChildByName(var_14_1),
				lv = arg_14_2[iter_14_0].unit:getLv(),
				tier = arg_14_2[iter_14_0].tier,
				grade = arg_14_2[iter_14_0].unit:getGrade()
			})
			
			var_14_0 = var_14_0 + 1
		end
	end
	
	if_set_visible(arg_14_1, "n_enemy_none_info", var_14_0 == 0)
end

function BossGuideUtil.setDropsInfo(arg_15_0, arg_15_1, arg_15_2)
	local var_15_0 = 0
	
	for iter_15_0 = 1, MAX_GUIDE_DROP do
		if arg_15_2[iter_15_0] and arg_15_2[iter_15_0][1] then
			local var_15_1 = "item_" .. tostring(iter_15_0)
			local var_15_2 = {
				scale = 1,
				grade_max = true,
				parent = arg_15_1:getChildByName(var_15_1),
				set_drop = arg_15_2[iter_15_0][3] or nil,
				grade_rate = arg_15_2[iter_15_0][4]
			}
			
			if string.starts(arg_15_2[iter_15_0][1], "e") and DB("equip_item", arg_15_2[iter_15_0][1], "type") == "artifact" then
				var_15_2.scale = 0.66
			end
			
			UIUtil:getRewardIcon(nil, arg_15_2[iter_15_0][1], var_15_2)
			
			var_15_0 = var_15_0 + 1
		end
	end
	
	if_set_visible(arg_15_1, "n_item_none_info", var_15_0 == 0)
end

function BossGuideUtil.setAdditionInfo(arg_16_0, arg_16_1, arg_16_2)
	if_set_visible(arg_16_1, "n_complete", arg_16_2.is_clear)
	
	if arg_16_2.is_clear then
		arg_16_1:getChildByName("n_left"):setOpacity(76.5)
		arg_16_1:getChildByName("n_right"):setOpacity(76.5)
	end
	
	local var_16_0 = arg_16_1:getChildByName("boss_desc")
	
	if get_cocos_refid(var_16_0) then
		local var_16_1 = UIUtil:setTextAndReturnHeight(var_16_0, T("guide_boss_" .. arg_16_2.id), var_16_0:getContentSize().width)
		local var_16_2 = arg_16_1:getContentSize()
		local var_16_3 = arg_16_1:getChildByName("n_boss_card")
		local var_16_4 = 140
		local var_16_5 = 254
		
		arg_16_1:setContentSize(var_16_2.width, var_16_5 + (var_16_1 + var_16_4))
		var_16_3:setPosition(var_16_3:getPositionX(), -var_16_2.height + var_16_5 + (var_16_1 + var_16_4))
	end
end

function BossGuideUtil.createUnitInfo(arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
	if arg_17_1 then
		local var_17_0, var_17_1, var_17_2, var_17_3, var_17_4 = DB("character", arg_17_1, {
			"name",
			"ch_attribute",
			"role",
			"monster_tier",
			"2line"
		})
		local var_17_5 = UNIT:create({
			code = arg_17_1,
			lv = arg_17_2,
			p = arg_17_4
		})
		local var_17_6 = var_17_5:getPoint()
		
		return {
			id = arg_17_1,
			unit = var_17_5,
			name = var_17_0,
			desc = var_17_4,
			tier = var_17_3,
			role = var_17_2,
			attr = var_17_1,
			lv = arg_17_2,
			grade = arg_17_3,
			power = var_17_6
		}
	else
		return {}
	end
end

function BossGuideUtil.createBossInfo(arg_18_0, arg_18_1)
	local var_18_0, var_18_1, var_18_2, var_18_3 = DB("level_guide_ext", arg_18_1, {
		"boss",
		"lv",
		"grade",
		"power"
	})
	
	return BossGuideUtil:createUnitInfo(var_18_0, var_18_1, var_18_2, var_18_3)
end

function BossGuideUtil.createCorpsInfo(arg_19_0, arg_19_1)
	local function var_19_0(arg_20_0, arg_20_1, arg_20_2)
		for iter_20_0 = 1, MAX_GUIDE_CORP do
			local var_20_0, var_20_1, var_20_2, var_20_3 = DB("level_guide_ext", arg_19_1, {
				tostring(arg_20_1) .. iter_20_0,
				arg_20_2 .. "lv" .. iter_20_0,
				arg_20_2 .. "grade" .. iter_20_0,
				arg_20_2 .. "power" .. iter_20_0
			})
			
			if var_20_0 then
				table.push(arg_20_0, BossGuideUtil:createUnitInfo(var_20_0, var_20_1, var_20_2, var_20_3))
			end
		end
	end
	
	local var_19_1 = {}
	
	var_19_0(var_19_1, "monster", "")
	var_19_0(var_19_1, "custom", "c")
	
	return var_19_1
end

function BossGuideUtil.createDropsInfo(arg_21_0, arg_21_1, arg_21_2)
	local var_21_0 = {}
	local var_21_1 = {}
	local var_21_2 = 1
	
	for iter_21_0 = 1, MAX_GUIDE_DROP do
		local var_21_3 = DB("level_guide_ext", arg_21_1, {
			"item" .. iter_21_0
		})
		
		if var_21_3 then
			table.insert(var_21_1, {
				item = var_21_3,
				order = var_21_2
			})
			
			var_21_2 = var_21_2 + 1
		end
	end
	
	for iter_21_1 = 1, 40 do
		local var_21_4, var_21_5, var_21_6, var_21_7 = DB("level_enter_drops", arg_21_2, {
			"item" .. iter_21_1,
			"type" .. iter_21_1,
			"set" .. iter_21_1,
			"grade_rate" .. iter_21_1
		})
		
		if var_21_4 and table.isInclude(var_21_1, function(arg_22_0, arg_22_1)
			if var_21_4 == arg_22_1.item then
				var_21_2 = arg_22_1.order
				
				return true
			end
		end) and not UIUtil:isHideItem(var_21_4) then
			table.insert(var_21_0, {
				var_21_4,
				var_21_5,
				var_21_6,
				var_21_7,
				var_21_2
			})
		end
	end
	
	table.sort(var_21_0, function(arg_23_0, arg_23_1)
		return arg_23_0[5] < arg_23_1[5]
	end)
	
	local var_21_8 = DB("level_guide_ext", arg_21_1, {
		"custom_reward_id"
	})
	
	if var_21_8 then
		local var_21_9 = totable(var_21_8)
		local var_21_10 = {}
		
		for iter_21_2, iter_21_3 in pairs(var_21_9 or {}) do
			table.push(var_21_10, {
				id = iter_21_2,
				c = iter_21_3[1],
				s = iter_21_3[2]
			})
		end
		
		table.sort(var_21_10, function(arg_24_0, arg_24_1)
			return to_n(arg_24_0.s) < to_n(arg_24_1.s)
		end)
		
		for iter_21_4, iter_21_5 in pairs(var_21_10 or {}) do
			table.insert(var_21_0, {
				iter_21_5.id,
				[5] = iter_21_5.s
			})
		end
	end
	
	return var_21_0
end
