DungeonClan = DungeonClan or {}
DungeonPvP = DungeonPvP or {}
DungeonRaid = DungeonRaid or {}

copy_functions(ScrollView, DungeonHell)

function DungeonPvP.UpdatePvPInfo(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6)
	if AccountData.pvp_info then
		local var_1_0, var_1_1, var_1_2 = DB("pvp_sa", AccountData.pvp_info.league, {
			"name",
			"emblem",
			"name_league"
		})
		
		SpriteCache:resetSprite(arg_1_1:getChildByName(arg_1_2), "emblem/" .. var_1_1 .. ".png")
		if_set(arg_1_1, arg_1_3, T("clan_league", {
			name = T(var_1_2)
		}))
		if_set(arg_1_1, arg_1_4, T("clan_point", {
			point = AccountData.pvp_info.score
		}))
		
		local var_1_3 = os.time()
		
		if var_1_3 < AccountData.pvp_info.season_end_time then
			local var_1_4 = AccountData.pvp_info.season_end_time - var_1_3
			
			if_set(arg_1_1, arg_1_5, T("clan_season_rest"))
			if_set(arg_1_1, arg_1_6, sec_to_string(math.floor(var_1_4)))
		elseif var_1_3 > AccountData.pvp_info.next_season_start_time then
			if_set(arg_1_1, arg_1_5, T("clan_season_start"))
			if_set(arg_1_1, arg_1_6, T("clan_calculate_complete"))
		else
			if_set(arg_1_1, arg_1_5, T("clan_season_end"))
			if_set(arg_1_1, arg_1_6, T("clan_calculate_ing"))
		end
	end
end

function DungeonPvP.create(arg_2_0, arg_2_1)
	arg_2_0:UpdatePvPInfo(arg_2_1, "battle_robby_thumbgrade_106", "label_grade", "label_gradePoint", "label_title_time", "cn_time")
	
	return EffectManager:Play({
		pivot_x = 0,
		fn = "ui_bg_battle.cfx",
		pivot_y = 0,
		pivot_z = 0,
		layer = arg_2_1:getChildByName("n_bg")
	}), true
end

function DungeonPvP.onEnter(arg_3_0)
	SceneManager:nextScene("pvp")
end

function DungeonRaid.create(arg_4_0, arg_4_1)
	return EffectManager:Play({
		pivot_x = 0,
		fn = "raid_idle.cfx",
		pivot_y = -180,
		pivot_z = 0,
		layer = arg_4_1:getChildByName("n_bg")
	}), true
end

function DungeonClan.create(arg_5_0, arg_5_1)
	local var_5_0 = cc.Layer:create()
	
	var_5_0:setScale(0.67)
	var_5_0:setAnchorPoint(0, 0)
	var_5_0:setPosition(0, 0)
	var_5_0:setScaleX(-0.67)
	
	local var_5_1 = 1280
	local var_5_2 = 720
	local var_5_3 = CACHE:getEffect("title_bg_b")
	
	var_5_3:setScaleFactor(1)
	var_5_3:setAnimation(0, "animation", true)
	var_5_3:setPosition(var_5_1 * 0.5, var_5_2 / 2)
	var_5_3:setPosition(0, 0)
	var_5_0:addChild(var_5_3)
	
	local var_5_4 = CACHE:getEffect("title_bg_dragon")
	
	var_5_4:setScaleFactor(1)
	var_5_4:setAnimation(0, "animation", true)
	var_5_4:setPosition(var_5_1 * 0.5, var_5_2 / 2)
	var_5_4:setPosition(0, 0)
	var_5_0:addChild(var_5_4)
	
	local var_5_5 = CACHE:getEffect("title_bg_f")
	
	var_5_5:setScaleFactor(1)
	var_5_5:setAnimation(0, "animation", true)
	var_5_5:setPosition(var_5_1 / 2, var_5_2 / 2)
	var_5_5:setPosition(0, 0)
	var_5_0:addChild(var_5_5)
	
	local var_5_6 = CACHE:getEffect("snow_02.particle", "effect")
	
	var_5_6:setPosition(var_5_1 * 0.99, var_5_2 * 0.05)
	var_5_6:setScaleFactor(1)
	var_5_6:start()
	var_5_6:setPosition(0, 0)
	var_5_0:addChild(var_5_6)
	
	local var_5_7 = CACHE:getEffect("snow_02.particle", "effect")
	
	var_5_7:setPosition(var_5_1 * 0.7, var_5_2 * 0.25)
	var_5_7:setScaleFactor(1)
	var_5_7:start()
	var_5_7:setPosition(0, 0)
	var_5_0:addChild(var_5_7)
	
	local var_5_8 = CACHE:getEffect("title_bg_ff")
	
	var_5_8:setScaleFactor(1)
	var_5_8:setAnimation(0, "animation", true)
	var_5_8:setPosition(var_5_1 * 0.5, var_5_2 / 2)
	var_5_8:setPosition(0, 0)
	var_5_0:addChild(var_5_8)
	
	local var_5_9 = CACHE:getEffect("snow_01.particle")
	
	var_5_9:setPosition(0, 0)
	var_5_9:setScaleFactor(0.5)
	var_5_9:start()
	var_5_0:addChild(var_5_9)
	
	return var_5_0
end
