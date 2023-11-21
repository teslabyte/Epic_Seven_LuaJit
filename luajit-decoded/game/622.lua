local var_0_0 = {
	"warrior",
	"knight",
	"assassin",
	"ranger",
	"mage",
	"manauser"
}

WorldBossUtil = {}

function get_best_formation(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	local var_1_0 = arg_1_3 or "fire"
	local var_1_1 = 12
	local var_1_2 = {
		knight = {
			count = 0,
			max = 2
		},
		warrior = {
			count = 0,
			max = 2
		},
		assassin = {
			count = 0,
			max = 2
		},
		mage = {
			count = 0,
			max = 2
		},
		manauser = {
			count = 0,
			max = 2
		},
		ranger = {
			count = 0,
			max = 2
		}
	}
	local var_1_3 = {
		arg_1_2[1],
		arg_1_2[2]
	}
	local var_1_4 = {}
	
	for iter_1_0 = 1, table.count(var_1_3) do
		var_1_4[var_1_3[iter_1_0]] = {
			count = 0,
			max = 2
		}
	end
	
	local var_1_5 = {}
	
	local function var_1_6(arg_2_0)
		for iter_2_0, iter_2_1 in pairs(arg_2_0) do
			if iter_2_1.count < iter_2_1.max then
				return false
			end
		end
		
		return true
	end
	
	local function var_1_7(arg_3_0, arg_3_1)
		local var_3_0 = arg_3_0[arg_3_1]
		
		if not var_3_0 then
			return 
		end
		
		if var_3_0.count >= var_3_0.max then
			return 
		end
		
		var_3_0.count = var_3_0.count + 1
		
		return true
	end
	
	local function var_1_8(arg_4_0)
		if not arg_1_1 then
			return 
		end
		
		for iter_4_0, iter_4_1 in pairs(arg_1_1) do
			if tonumber(iter_4_1) == tonumber(arg_4_0.inst.uid) then
				return true
			end
		end
	end
	
	local function var_1_9(arg_5_0, arg_5_1)
		for iter_5_0, iter_5_1 in pairs(arg_5_0) do
			if iter_5_1.inst.code == arg_5_1.inst.code then
				return true
			end
		end
		
		return false
	end
	
	local function var_1_10()
		local var_6_0 = {}
		local var_6_1 = Account:getUnits()
		
		for iter_6_0, iter_6_1 in pairs(var_6_1) do
			local var_6_2 = true and not iter_6_1:isSpecialUnit()
			
			var_6_2 = var_6_2 and not iter_6_1:isPromotionUnit()
			var_6_2 = var_6_2 and not iter_6_1:isDevotionUnit()
			var_6_2 = var_6_2 and not iter_6_1:isGrowthBoostRegistered()
			
			if HeroBelt:getSortMode() == "worldbossSupporter" then
				var_6_2 = var_6_2 and not iter_6_1:isMoonlightDestinyUnit()
			end
			
			if var_6_2 then
				table.insert(var_6_0, iter_6_1)
			end
		end
		
		return var_6_0
	end
	
	local function var_1_11(arg_7_0, arg_7_1)
		for iter_7_0, iter_7_1 in pairs(arg_7_0) do
			if arg_7_1:getUID() ~= iter_7_1:getUID() and arg_7_1:isSameVariationGroup(iter_7_1) then
				arg_7_0[iter_7_0] = nil
			end
		end
	end
	
	local var_1_12 = true
	local var_1_13 = 0
	
	if arg_1_0 then
		for iter_1_1 = 1, table.count(arg_1_0) do
			local var_1_14 = arg_1_0[iter_1_1]
			
			if not var_1_7(var_1_2, var_1_14.db.role) and not var_1_4[var_1_14.db.role] then
				var_1_12 = false
			end
			
			var_1_13 = var_1_13 + var_1_14:getPoint()
		end
	end
	
	local var_1_15 = var_1_10()
	
	for iter_1_2, iter_1_3 in pairs(var_1_15) do
		if var_1_8(iter_1_3) then
			var_1_15[iter_1_2] = nil
		end
	end
	
	table.sort(var_1_15, function(arg_8_0, arg_8_1)
		if arg_8_0 and arg_8_1 then
			return arg_8_0:getPoint() > arg_8_1:getPoint()
		end
	end)
	
	if var_1_1 >= table.count(var_1_15) then
		for iter_1_4, iter_1_5 in pairs(var_1_15) do
			if not var_1_9(var_1_5, iter_1_5) then
				table.insert(var_1_5, iter_1_5)
			end
		end
		
		return var_1_5
	end
	
	local var_1_16 = 0
	local var_1_17 = 1
	
	for iter_1_6, iter_1_7 in pairs(var_1_15) do
		if var_1_17 > 12 then
			break
		end
		
		var_1_16 = var_1_16 + iter_1_7:getPoint()
		var_1_17 = var_1_17 + 1
	end
	
	local var_1_18 = {}
	
	for iter_1_8, iter_1_9 in pairs(var_1_15) do
		local var_1_19 = iter_1_9:getPoint()
		
		if iter_1_9.db.color == var_1_0 then
			var_1_19 = var_1_19 * ((var_1_13 + var_1_16) * (GAME_STATIC_VARIABLE.worldboss_attribute_bonus or 0.04) / var_1_19 + 1)
		end
		
		table.insert(var_1_18, {
			unit = iter_1_9,
			point = var_1_19
		})
	end
	
	table.sort(var_1_18, function(arg_9_0, arg_9_1)
		return arg_9_0.point > arg_9_1.point
	end)
	
	local var_1_20 = 0
	
	for iter_1_10, iter_1_11 in pairs(var_1_18) do
		if var_1_6(var_1_2) then
			break
		end
		
		local var_1_21 = iter_1_11.unit
		
		if not var_1_9(var_1_5, var_1_21) and var_1_7(var_1_2, var_1_21.db.role) then
			table.insert(var_1_5, var_1_21)
			
			var_1_18[iter_1_10] = nil
			var_1_20 = var_1_20 + var_1_21:getPoint()
		end
	end
	
	local var_1_22 = false
	
	if var_1_12 then
		local var_1_23 = 0
		local var_1_24 = 1
		
		for iter_1_12, iter_1_13 in pairs(var_1_18) do
			if var_1_24 > 4 then
				break
			end
			
			var_1_23 = var_1_23 + iter_1_13.unit:getPoint()
			var_1_24 = var_1_24 + 1
		end
		
		local var_1_25 = 0
		local var_1_26 = 0
		
		for iter_1_14, iter_1_15 in pairs(var_1_4) do
			if var_1_26 >= 4 then
				break
			end
			
			local var_1_27 = 0
			
			for iter_1_16, iter_1_17 in pairs(var_1_18) do
				if var_1_27 >= 2 then
					break
				end
				
				local var_1_28 = iter_1_17.unit
				
				if iter_1_14 == var_1_28.db.role then
					var_1_27 = var_1_27 + 1
					var_1_26 = var_1_26 + 1
					var_1_25 = var_1_25 + var_1_28:getPoint()
				end
			end
		end
		
		if var_1_23 < var_1_25 + var_1_20 * (GAME_STATIC_VARIABLE.worldboss_role_bonus or 0.4) then
			for iter_1_18, iter_1_19 in pairs(var_1_18) do
				if var_1_1 <= table.count(var_1_5) then
					return var_1_5
				end
				
				if var_1_6(var_1_4) then
					break
				end
				
				local var_1_29 = iter_1_19.unit
				
				if not var_1_9(var_1_5, var_1_29) and var_1_7(var_1_4, var_1_29.db.role) then
					table.insert(var_1_5, var_1_29)
					
					var_1_18[iter_1_18] = nil
				end
			end
		end
	end
	
	local var_1_30 = var_1_1 - table.count(var_1_5)
	
	for iter_1_20, iter_1_21 in pairs(var_1_18) do
		if var_1_1 <= table.count(var_1_5) then
			return var_1_5
		end
		
		local var_1_31 = iter_1_21.unit
		
		if not var_1_9(var_1_5, var_1_31) then
			table.insert(var_1_5, var_1_31)
		end
	end
	
	if var_1_1 < table.count(var_1_5) then
		Log.e("get_best_formation() 로직이 잘못 되었습니다")
	end
	
	return var_1_5
end

function WorldBossUtil.getRoleCount(arg_10_0, arg_10_1)
	local var_10_0 = {}
	
	for iter_10_0, iter_10_1 in pairs(var_0_0) do
		var_10_0[iter_10_1] = 0
	end
	
	for iter_10_2, iter_10_3 in pairs(arg_10_1) do
		var_10_0[iter_10_3.db.role] = var_10_0[iter_10_3.db.role] + 1
	end
	
	return var_10_0
end

function WorldBossUtil.change_buttonImg(arg_11_0, arg_11_1)
	local var_11_0
	
	if tolua.type(arg_11_1) == "table" then
		var_11_0 = arg_11_1
	elseif tolua.type(arg_11_1) == "number" then
		var_11_0 = Account:getBattleTeam(arg_11_1)
	end
	
	if not var_11_0 then
		return 
	end
	
	local var_11_1 = var_11_0:getDevoteStats()
	local var_11_2 = {}
	local var_11_3 = ""
	
	for iter_11_0, iter_11_1 in pairs(var_11_1) do
		local var_11_4 = false
		
		for iter_11_2, iter_11_3 in pairs(iter_11_1) do
			if iter_11_3.stat > 0 then
				var_11_4 = true
			end
		end
		
		if var_11_4 then
			table.insert(var_11_2, iter_11_0)
		end
	end
	
	table.sort(var_11_2, function(arg_12_0, arg_12_1)
		return arg_12_0 < arg_12_1
	end)
	
	for iter_11_4, iter_11_5 in pairs(var_11_2) do
		var_11_3 = var_11_3 .. iter_11_5
	end
	
	if var_11_3 == "" then
		var_11_3 = 0
	end
	
	return string.format("img/hero_dedi_p_%s.png", var_11_3)
end

function WorldBossUtil.isStrongColor(arg_13_0, arg_13_1, arg_13_2)
	if not arg_13_1 or not arg_13_2 then
		return 
	end
	
	if arg_13_1 == arg_13_2 then
		return true
	end
	
	return false
end

function WorldBossUtil.getStrongColorCount(arg_14_0, arg_14_1, arg_14_2)
	if not arg_14_2 then
		return 
	end
	
	local var_14_0 = 0
	
	for iter_14_0, iter_14_1 in pairs(arg_14_1) do
		if WorldBossUtil:isStrongColor(iter_14_1:getColor(), arg_14_2) then
			var_14_0 = var_14_0 + 1
		end
	end
	
	return var_14_0
end

function WorldBossUtil.getStrongColorIconPath(arg_15_0, arg_15_1)
	local var_15_0
	
	for iter_15_0, iter_15_1 in pairs(IS_STRONG_COLOR_AGAINST) do
		if WorldBossUtil:isStrongColor(iter_15_0, arg_15_1) then
			var_15_0 = iter_15_0
			
			break
		end
	end
	
	local var_15_1 = "img/cm_icon_pro"
	
	if var_15_0 ~= "light" and var_15_0 == "dark" then
	end
	
	return var_15_1 .. var_15_0 .. "_up.png"
end

function WorldBossUtil.checkOnlySecRemain(arg_16_0, arg_16_1)
	local var_16_0 = arg_16_1
	local var_16_1 = math.floor(var_16_0 / 86400)
	local var_16_2 = var_16_0 - var_16_1 * 86400
	local var_16_3 = math.floor(var_16_2 / 3600)
	local var_16_4 = var_16_2 - var_16_3 * 3600
	local var_16_5 = math.floor(var_16_4 / 60)
	local var_16_6 = var_16_4 - var_16_5 * 60
	
	if var_16_1 > 0 then
		return false
	end
	
	if var_16_3 > 0 then
		return false
	end
	
	if var_16_5 > 0 then
		return false
	end
	
	return true
end

function WorldBossUtil.getRemainTimeText(arg_17_0, arg_17_1)
	local var_17_0 = arg_17_1
	local var_17_1 = math.floor(var_17_0 / 86400)
	local var_17_2 = var_17_0 - var_17_1 * 86400
	local var_17_3 = math.floor(var_17_2 / 3600)
	local var_17_4 = var_17_2 - var_17_3 * 3600
	local var_17_5 = math.floor(var_17_4 / 60)
	local var_17_6 = var_17_4 - var_17_5 * 60
	local var_17_7 = false
	local var_17_8 = false
	local var_17_9 = false
	local var_17_10 = ""
	
	if var_17_1 > 0 then
		var_17_10 = T("remain_day", {
			day = var_17_1
		})
		var_17_7 = true
	end
	
	if var_17_3 > 0 then
		var_17_10 = var_17_10 .. " " .. T("remain_hour", {
			hour = var_17_3
		})
		var_17_8 = true
	end
	
	if not var_17_7 and var_17_5 > 0 then
		var_17_10 = var_17_10 .. " " .. T("remain_min", {
			min = var_17_5
		})
		var_17_9 = true
	end
	
	if not var_17_7 and not var_17_8 and not var_17_9 then
		var_17_10 = var_17_10 .. " " .. T("remain_sec", {
			sec = var_17_6
		})
	end
	
	return var_17_10
end

function WorldBossUtil.getBossPosition(arg_18_0, arg_18_1)
	if not arg_18_1 then
		return 
	end
	
	return (DB("clan_worldboss", tostring(arg_18_1), {
		"map_index"
	}))
end

function WorldBossUtil.getWorldbossName(arg_19_0, arg_19_1)
	if not arg_19_1 then
		return 
	end
	
	local var_19_0 = DB("clan_worldboss", arg_19_1, {
		"char_id"
	})
	
	if not var_19_0 then
		return 
	end
	
	local var_19_1 = DB("character", var_19_0, {
		"name"
	})
	
	return T(var_19_1)
end

function WorldBossUtil.getWorldbossBgPath(arg_20_0, arg_20_1)
	if not arg_20_1 then
		return 
	end
	
	local var_20_0 = DB("clan_worldboss", arg_20_1, {
		"bg"
	}) or "bg_worldboss"
	
	return "img/" .. var_20_0 .. ".png"
end

function WorldBossUtil.getWorldbossStoryDesc(arg_21_0, arg_21_1)
	if not arg_21_1 then
		return 
	end
	
	local var_21_0 = DB("clan_worldboss", arg_21_1, {
		"char_id"
	})
	
	if not var_21_0 then
		return 
	end
	
	local var_21_1 = DB("character", var_21_0, {
		"story"
	})
	
	return T(var_21_1)
end

function WorldBossUtil.getWorldbossStory(arg_22_0, arg_22_1)
	if not arg_22_1 then
		return 
	end
	
	local var_22_0, var_22_1 = DB("clan_worldboss", arg_22_1, {
		"start_story",
		"end_story"
	})
	
	return var_22_0, var_22_1
end

function WorldBossUtil.getWorldbossCharID(arg_23_0, arg_23_1)
	if not arg_23_1 then
		return 
	end
	
	return (DB("clan_worldboss", arg_23_1, {
		"char_id"
	}))
end

function WorldBossUtil.setHPBar(arg_24_0, arg_24_1, arg_24_2)
	if not arg_24_1 or not arg_24_2 then
		return 
	end
	
	local var_24_0 = arg_24_1:getChildByName("hp_red")
	
	if_set_visible(arg_24_1, "hp_red", false)
	
	local var_24_1 = arg_24_1:getChildByName("hp")
	
	if not var_24_1 then
		Log.e("boss hpar UI is Nill")
		
		return 
	end
	
	local var_24_2 = var_24_1:getScale() * arg_24_2
	
	var_24_1:setScaleX(arg_24_2 / 100)
end

function WorldBossUtil.getMaxWorldbossEnter(arg_25_0)
	if GAME_STATIC_VARIABLE.worldboss_daily_join_count2 <= Account:getLevel() then
		return 2
	else
		return 0
	end
end

function WorldBossUtil.getBossHP(arg_26_0, arg_26_1, arg_26_2)
	if not arg_26_1 or not arg_26_2 then
		return 
	end
	
	local var_26_0 = WorldBossUtil:getTime()
	local var_26_1 = arg_26_2 - arg_26_1
	
	return (arg_26_2 - var_26_0) / var_26_1 * 100
end

function WorldBossUtil.setTime(arg_27_0, arg_27_1)
	query("test_worldboss_time", {
		time = arg_27_1
	})
end

function WorldBossUtil.resetTime(arg_28_0)
	query("test_worldboss_time", {
		reset = true
	})
end

function WorldBossUtil.getTime(arg_29_0)
	return os.time()
end
