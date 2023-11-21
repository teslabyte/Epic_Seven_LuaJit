RumbleUtil = {}

function RumbleUtil.setBaseInfo(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0
	
	if type(arg_1_2) == "string" then
		var_1_0 = arg_1_2
	elseif type(arg_1_2) == "table" then
		var_1_0 = arg_1_2:getCode()
	end
	
	if not var_1_0 then
		return 
	end
	
	local var_1_1 = RumbleUtil:getUnitInfo(var_1_0)
	
	if not var_1_1 then
		return 
	end
	
	local var_1_2 = UIUtil:getPortraitAni(var_1_1.face_id)
	
	var_1_2:setName("rumble.portrait")
	UIUtil:setPortraitPositionByFaceBone(var_1_2)
	arg_1_1:getChildByName("n_port"):addChild(var_1_2)
	if_set(arg_1_1, "txt_title", T(var_1_1.name))
	if_set(arg_1_1, "txt_role", T(RumbleSynergy:getSynergyName(var_1_1.role)))
	if_set(arg_1_1, "txt_belong", T(RumbleSynergy:getSynergyName(var_1_1.camp)))
	if_set_sprite(arg_1_1, "n_role", RumbleSynergy:getSynergyIcon(var_1_1.role))
	if_set_sprite(arg_1_1, "n_belong", RumbleSynergy:getSynergyIcon(var_1_1.camp))
	
	for iter_1_0 = 4, 5 do
		local var_1_3 = arg_1_1:getChildByName("star" .. iter_1_0)
		
		if get_cocos_refid(var_1_3) then
			var_1_3:setVisible(iter_1_0 <= var_1_1.grade)
		end
	end
end

function RumbleUtil.setStatInfo(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0
	
	if type(arg_2_2) == "string" then
		var_2_0 = RumbleUtil:getUnitStatByCode(arg_2_2, arg_2_3)
	elseif type(arg_2_2) == "table" then
		if arg_2_3 then
			var_2_0 = RumbleUtil:getUnitStatByCode(arg_2_2:getCode(), arg_2_3)
		else
			var_2_0 = arg_2_2:getStats()
		end
	end
	
	if not var_2_0 then
		return 
	end
	
	if_set(arg_2_1, "txt_count1", var_2_0.atk)
	if_set(arg_2_1, "txt_count2", var_2_0.def)
	if_set(arg_2_1, "txt_count3", var_2_0.hp)
	if_set(arg_2_1, "txt_count4", var_2_0.atk_spd)
	if_set(arg_2_1, "txt_count5", var_2_0.crc * 100 .. "%")
	if_set(arg_2_1, "txt_count6", var_2_0.crd * 100 .. "%")
end

function RumbleUtil.getUnitStatByCode(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0, var_3_1, var_3_2, var_3_3, var_3_4 = DB("rumble_character", arg_3_1, {
		"atk",
		"hp",
		"def",
		"atk_spd",
		"memory_imprint_rate"
	})
	
	if not var_3_0 then
		return 
	end
	
	local var_3_5 = 1e-09
	local var_3_6 = 1 + (var_3_4 or 1) * to_n(arg_3_2)
	
	return {
		crc = 0.15,
		crd = 1.5,
		atk = math.floor(to_n(var_3_0) * var_3_6 + var_3_5),
		hp = math.floor(to_n(var_3_1) * var_3_6 + var_3_5),
		def = to_n(var_3_2),
		atk_spd = to_n(var_3_3)
	}
end

function RumbleUtil.getUnitInfo(arg_4_0, arg_4_1)
	local var_4_0 = {
		id = arg_4_1
	}
	
	var_4_0.base_chr, var_4_0.role, var_4_0.camp = DB("rumble_character", arg_4_1, {
		"base_chr",
		"rol",
		"camp"
	})
	
	if not var_4_0.base_chr then
		return 
	end
	
	var_4_0.name, var_4_0.face_id, var_4_0.grade = DB("character", var_4_0.base_chr, {
		"name",
		"face_id",
		"grade"
	})
	
	return var_4_0
end

function RumbleUtil.getHeroIcon(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = RumbleUtil:getUnitInfo(arg_5_1)
	
	if not var_5_0 then
		return 
	end
	
	arg_5_2 = arg_5_2 or {}
	
	local var_5_1 = load_control("wnd/rumble_hero_icon.csb")
	
	if arg_5_2.show_info then
		local var_5_2 = var_5_1:getChildByName("n_info")
		local var_5_3 = load_control("wnd/rumble_hero_info.csb")
		
		var_5_2:addChild(var_5_3)
		RumbleUtil:setHeroInfoNode(var_5_3, arg_5_2.devote, var_5_0.role, var_5_0.camp)
	end
	
	local var_5_4 = var_5_1:getChildByName("n_mob_icon")
	
	UIUtil:getRewardIcon(1, var_5_0.base_chr, {
		no_popup = true,
		no_tooltip = true,
		zero = true,
		scale = 1,
		parent = var_5_4,
		star_scale = arg_5_2.no_star and 0
	})
	
	if arg_5_2.show_synergy then
		if_set_sprite(var_5_1, "n_role", RumbleSynergy:getSynergyIcon(var_5_0.role))
		if_set_sprite(var_5_1, "n_belong", RumbleSynergy:getSynergyIcon(var_5_0.camp))
		if_set_visible(var_5_1, "n_info2", true)
	end
	
	if arg_5_2.popup then
		local var_5_5 = var_5_1:getChildByName("btn_pop")
		
		if get_cocos_refid(var_5_5) then
			var_5_5:addTouchEventListener(function(arg_6_0, arg_6_1)
				if arg_6_1 ~= 2 then
					return 
				end
				
				RumbleUnitPopup:open({
					code = arg_5_1
				})
				SoundEngine:play("event:/ui/ok")
			end)
			var_5_5:setVisible(true)
		end
	end
	
	return var_5_1
end

function RumbleUtil.setHeroInfoNode(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	if not get_cocos_refid(arg_7_1) then
		return 
	end
	
	local var_7_0
	
	if arg_7_2 == "SSS" then
		var_7_0 = arg_7_1:getChildByName("n_3")
	elseif arg_7_2 == "SS" then
		var_7_0 = arg_7_1:getChildByName("n_2")
	else
		var_7_0 = arg_7_1:getChildByName("n_1")
	end
	
	if not get_cocos_refid(var_7_0) then
		return 
	end
	
	if_set_visible(arg_7_1, "n_1", false)
	if_set_visible(arg_7_1, "n_2", false)
	if_set_visible(arg_7_1, "n_3", false)
	if_set_visible(var_7_0, nil, true)
	
	local var_7_1 = RumbleSynergy:getSynergyIcon(arg_7_3)
	
	if_set_sprite(var_7_0, "n_role", var_7_1)
	
	local var_7_2 = RumbleSynergy:getSynergyIcon(arg_7_4)
	
	if_set_sprite(var_7_0, "n_belong", var_7_2)
	if_set_sprite(var_7_0, "n_dedi", string.format("img/hero_dedi_a_%s.png", string.lower(arg_7_2 or "none")))
end

function RumbleUtil.getDevoteGrade(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = arg_8_2
	
	if arg_8_2 == 0 then
		return "none"
	end
	
	local var_8_1 = DB("rumble_character", arg_8_1, "base_chr")
	local var_8_2 = DB("character", var_8_1, "grade") or 3
	local var_8_3 = math.max(3, var_8_2) - 2
	local var_8_4 = math.min(7, var_8_0 + (var_8_3 - 1))
	
	return (DB("devotion_skill_grade", tostring(var_8_4), "grade"))
end

function RumbleUtil.getUnitList(arg_9_0, arg_9_1)
	arg_9_1 = arg_9_1 or {}
	
	local var_9_0 = RumbleSummon:getUnitLineUp() or {}
	local var_9_1 = {}
	
	for iter_9_0, iter_9_1 in pairs(var_9_0) do
		var_9_1[iter_9_1] = true
	end
	
	local var_9_2 = {}
	
	for iter_9_2, iter_9_3 in pairs(var_9_1) do
		local var_9_3 = true
		
		if var_9_3 and arg_9_1.role and DB("rumble_character", iter_9_2, "rol") ~= arg_9_1.role then
			var_9_3 = false
		end
		
		if var_9_3 and arg_9_1.camp and DB("rumble_character", iter_9_2, "camp") ~= arg_9_1.camp then
			var_9_3 = false
		end
		
		if var_9_3 then
			table.insert(var_9_2, iter_9_2)
		end
	end
	
	table.sort(var_9_2, function(arg_10_0, arg_10_1)
		return DB("rumble_character", arg_10_0, "sort") < DB("rumble_character", arg_10_1, "sort")
	end)
	
	return var_9_2
end

function RumbleUtil.getSynergyList(arg_11_0)
	local var_11_0 = {}
	
	local function var_11_1(arg_12_0, arg_12_1)
		if not var_11_0[arg_12_0] then
			local var_12_0 = DB("rumble_synergy", arg_12_0, "sort") or 9999
			
			var_11_0[arg_12_0] = {
				id = arg_12_0,
				sort = var_12_0
			}
		end
		
		table.insert(var_11_0[arg_12_0], arg_12_1)
	end
	
	local var_11_2 = RumbleUtil:getUnitList()
	
	for iter_11_0, iter_11_1 in pairs(var_11_2) do
		local var_11_3 = RumbleUtil:getUnitInfo(iter_11_1)
		
		if var_11_3 then
			var_11_1(var_11_3.camp, var_11_3)
			var_11_1(var_11_3.role, var_11_3)
		end
	end
	
	local var_11_4 = {}
	
	for iter_11_2, iter_11_3 in pairs(var_11_0) do
		table.insert(var_11_4, iter_11_3)
	end
	
	table.sort(var_11_4, function(arg_13_0, arg_13_1)
		return arg_13_0.sort < arg_13_1.sort
	end)
	
	return var_11_4
end

function RumbleUtil.getRumbleSchedule(arg_14_0)
	if not PRODUCTION_MODE and RumbleCheat.schedule_id then
		return RumbleCheat.schedule_id
	end
	
	if DEBUG.MAP_DEBUG then
		return "fm_3w"
	end
	
	if SubstoryManager:isActiveSchedule("vfm3aa_2") then
		return "fm_3w"
	elseif SubstoryManager:isActiveSchedule("vfm3aa_1") then
		return "fm_2w"
	elseif SubstoryManager:isActiveSchedule("vfm3aa") then
		return "fm_1w"
	end
	
	if SubstoryManager:checkEndEvent() then
		return "fm_3w"
	end
	
	return "fm_1w"
end

function RumbleUtil.getOpacityAct(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
	return LINEAR_CALL(arg_15_1, arg_15_4, function(arg_16_0, arg_16_1)
		local var_16_0 = (math.cos(arg_16_1) - 1) * -0.5
		
		arg_16_0:setOpacity(((1 - var_16_0) * arg_15_2 + var_16_0 * arg_15_3) * 255)
	end, 0, math.pi * 2)
end

function RumbleUtil.getSkillIcon(arg_17_0, arg_17_1, arg_17_2)
	local var_17_0 = DB("rumble_skill", arg_17_1, "icon")
	
	if not var_17_0 then
		return 
	end
	
	arg_17_2 = arg_17_2 or {}
	
	local var_17_1 = "skill/" .. var_17_0 .. ".png"
	local var_17_2 = cc.Sprite:create(var_17_1)
	
	if not var_17_2 then
		return 
	end
	
	var_17_2:setAnchorPoint(0, 0)
	var_17_2:setScale(1.25)
	
	if arg_17_2.show_tooltip then
		WidgetUtils:setupTooltip({
			delay = 0,
			control = var_17_2,
			creator = function()
				return RumbleUtil:getSkillTooltip(arg_17_1)
			end
		})
	end
	
	return var_17_2
end

function RumbleUtil.getSkillTooltip(arg_19_0, arg_19_1)
	local var_19_0, var_19_1, var_19_2, var_19_3 = DB("rumble_skill", arg_19_1, {
		"name",
		"desc",
		"cooldown",
		"range"
	})
	
	if not var_19_0 then
		return 
	end
	
	local var_19_4 = load_control("wnd/skill_detail.csb")
	
	if_set_visible(var_19_4, "n_up", false)
	if_set_visible(var_19_4, "n_soul", false)
	if_set_visible(var_19_4, "n_flags", false)
	
	local var_19_5 = 23
	local var_19_6 = var_19_4:getChildByName("n_head")
	
	if get_cocos_refid(var_19_6) then
		if_set_visible(var_19_6, "txt_soul_gain", false)
		if_set(var_19_6, "txt_name", T(var_19_0))
		if_set(var_19_6, "txt_desc", T(var_19_1))
		
		local var_19_7 = to_n(var_19_2)
		
		if var_19_7 > 0 then
			if_set(var_19_6, "txt_cool", T("sk_cool", {
				turn = var_19_7
			}))
		else
			if_set_visible(var_19_6, "n_coolline", false)
		end
		
		local var_19_8 = to_n(var_19_3)
		
		if var_19_8 > 0 and var_19_8 < 10 then
			if_set(var_19_6, "txt_cost", T("rumble_skill_range", {
				range = var_19_8
			}))
		else
			if_set_visible(var_19_6, "txt_cost", false)
		end
		
		local var_19_9 = var_19_6:getChildByName("txt_desc")
		local var_19_10 = var_19_9:getStringNumLines() * 28
		local var_19_11 = var_19_9:getContentSize()
		
		var_19_11.height = var_19_10
		
		var_19_9:setContentSize(var_19_11)
		
		var_19_5 = var_19_5 + var_19_10 * var_19_9:getScale()
		
		var_19_6:setPositionY(var_19_5)
		
		var_19_5 = var_19_5 + 100
	end
	
	local var_19_12 = var_19_4:getChildByName("icon_pos")
	local var_19_13 = RumbleUtil:getSkillIcon(arg_19_1)
	
	if get_cocos_refid(var_19_13) then
		var_19_13:setAnchorPoint(0.5, 0.5)
		var_19_13:setScale(1)
		var_19_12:addChild(var_19_13)
	end
	
	local var_19_14 = var_19_4:getChildByName("wnd")
	
	if get_cocos_refid(var_19_14) then
		local var_19_15 = var_19_14:getContentSize()
		
		var_19_15.height = var_19_5 + 64
		
		var_19_14:setContentSize(var_19_15)
		var_19_4:setContentSize(var_19_15)
	end
	
	return var_19_4
end

function RumbleUtil.getTokenIcon(arg_20_0, arg_20_1)
	arg_20_1 = arg_20_1 or {}
	
	local var_20_0 = RumbleSystem:getConfig("rumble_token_id") or "ma_vfm3aa1"
	local var_20_1 = UIUtil:getRewardIcon(arg_20_1.count or 1, var_20_0, {
		no_tooltip = true,
		zero = arg_20_1.zero,
		no_bg = arg_20_1.no_bg
	})
	
	if not arg_20_1.no_tooltip then
		WidgetUtils:setupTooltip({
			control = var_20_1,
			creator = function()
				local var_21_0 = ItemTooltip:getItemTooltip({
					code = var_20_0
				})
				local var_21_1 = RumblePlayer:getGold()
				
				if_set(var_21_0, "txt_count", T("it_count", {
					count = comma_value(var_21_1)
				}))
				
				return var_21_0
			end,
			delay = arg_20_1.tooltip_delay,
			tooltip_callback = arg_20_1.tooltip_callback,
			event_name = var_20_0
		})
	end
	
	return var_20_1
end

function RumbleUtil.getTokenName(arg_22_0)
	local var_22_0 = RumbleSystem:getConfig("rumble_token_id") or "ma_vfm3aa1"
	
	return DB("item_material", var_22_0, "name")
end

function RumbleUtil.getTokenSprite(arg_23_0)
	local var_23_0 = RumbleSystem:getConfig("rumble_token_id") or "ma_vfm3aa1"
	
	return "item/" .. DB("item_material", var_23_0, "icon") .. ".png"
end

function RumbleUtil.sortLineUp(arg_24_0, arg_24_1)
	local var_24_0 = to_n((RumbleUtil:getUnitInfo(arg_24_0.c) or {}).grade)
	local var_24_1 = to_n((RumbleUtil:getUnitInfo(arg_24_1.c) or {}).grade)
	
	if var_24_0 ~= var_24_1 then
		return var_24_1 < var_24_0
	else
		return to_n(arg_24_0.d) > to_n(arg_24_1.d)
	end
end
