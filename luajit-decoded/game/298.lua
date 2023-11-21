TutorialCondition = TutorialCondition or {}

local var_0_0 = "TutorialCondition"
local var_0_1 = {
	substory_dlc = function()
		return UnlockSystem:isUnlockSystem(UNLOCK_ID.SUBSTORY_DLC)
	end,
	mltheater = function()
		return UnlockSystem:isUnlockSystem(UNLOCK_ID.MOONLIGHT_THEATER)
	end,
	system_008 = function()
		if not UnlockSystem:isUnlockSystem(UNLOCK_ID.PVP) then
			return false
		end
		
		if (function()
			local var_4_0 = Account:getPvpInfo()
			
			if not var_4_0 then
				return false
			end
			
			if not var_4_0.next_season_start_time then
				return false
			end
			
			if not var_4_0.season_end_time then
				return false
			end
			
			local var_4_1 = os.time()
			
			if var_4_1 >= var_4_0.next_season_start_time then
				return false
			end
			
			if var_4_1 <= var_4_0.season_end_time then
				return false
			end
			
			return true
		end)() then
			return false
		end
		
		return true
	end,
	system_015 = function()
		return UnlockSystem:isUnlockSystem(UNLOCK_ID.CLAN)
	end,
	system_016 = function()
		if not UnlockSystem:isUnlockSystem(UNLOCK_ID.PUB) then
			return false
		end
		
		if ShopRandom.npc and ShopRandom.npc ~= "lobby" then
			return false
		end
		
		return true
	end,
	classchange_start = function()
		if not UnlockSystem:isUnlockSystem(UNLOCK_ID.CLASS_CHANGE) then
			return false
		end
		
		return true
	end,
	episode1_clear = function()
		if TutorialGuide:isClearedTutorial("sidonia_start") then
			TutorialGuide:forceClearTutorials({
				"episode1_clear"
			})
			
			return false
		end
		
		return Account:isMapCleared("tae010")
	end,
	itemselection = function()
		return Inventory.Etc:isHaveSpecialItem()
	end,
	system_003 = function()
		if not UnlockSystem:isUnlockSystem(UNLOCK_ID.MAZE) then
			return false
		end
		
		if TutorialGuide:isClearedTutorial("maze_base") then
			return false
		end
		
		return true
	end,
	system_091 = function()
		if not UnlockSystem:isUnlockSystem(UNLOCK_ID.SUBSTORY) then
			return false
		end
		
		local var_11_0 = SubStoryUtil:getStoryList(true, {
			unlock_only = true
		}) or {}
		
		if table.empty(var_11_0) then
			return false
		end
		
		return true
	end,
	system_049 = function()
		return UnlockSystem:isUnlockSystem(UNLOCK_ID.ZODIAC)
	end,
	system_007 = function()
		if not UnlockSystem:isUnlockSystem(UNLOCK_ID.HUNT) then
			return false
		end
		
		if Account:isMapsCleared({
			"hunw001",
			"hung001",
			"hunb001",
			"hunq001"
		}) then
			return false
		end
		
		return true
	end,
	system_002 = function()
		if not UnlockSystem:isUnlockSystem(UNLOCK_ID.WEEKLY) then
			return false
		end
		
		if Account:isMapsCleared({
			"mon001",
			"tue001",
			"wed001",
			"thu001",
			"fri001"
		}) then
			return false
		end
		
		return true
	end,
	system_017 = function()
		if not UnlockSystem:isUnlockSystem(UNLOCK_ID.HELL) then
			return false
		end
		
		if Account:getHellFloor() ~= 1 then
			return false
		end
		
		return true
	end,
	expedition_unlock = function()
		return UnlockSystem:isUnlockSystem(UNLOCK_ID.EXPDEITION)
	end,
	ras_memorization = function()
		local var_17_0 = Account:getUnitsByCode("c1001")
		
		if table.empty(var_17_0) then
			return false
		end
		
		if Account:getItemCount("ma_dv_d1001") <= 0 then
			return false
		end
		
		return true
	end,
	skill_enhance = function(arg_18_0)
		if arg_18_0 and arg_18_0.unit and arg_18_0.unit:isMoonlightDestinyUnit() then
			return false
		end
		
		return true
	end,
	mer_memorization = function()
		local var_19_0 = Account:getUnitsByCode("c1005")
		
		if table.empty(var_19_0) then
			return false
		end
		
		if Account:getItemCount("ma_dv_d1005") <= 0 then
			return false
		end
		
		return true
	end,
	pet_present_new = function()
		return UnlockSystem:isUnlockSystem(UNLOCK_ID.PET)
	end,
	pet_synthesis_new = function()
		return UnlockSystem:isUnlockSystem(UNLOCK_ID.PET)
	end,
	system_100 = function()
		if not UnlockSystem:isUnlockSystem(UNLOCK_ID.AUTOMATON) then
			return false
		end
		
		if ContentDisable:byAlias("automaton") then
			return false
		end
		
		return true
	end,
	system_097 = function()
		return UnlockSystem:isUnlockSystem(UNLOCK_ID.MAZE_RAID)
	end,
	item_reforge = function()
		return UnlockSystem:isUnlockSystem(UNLOCK_ID.EQUIP_UPGRADE)
	end,
	system_118_new = function()
		if not UnlockSystem:isUnlockSystem(UNLOCK_ID.TRIAL_HALL) then
			return false
		end
		
		if ContentDisable:byAlias("trial_hall") then
			return false
		end
		
		return true
	end,
	sidonia_start = function()
		return Account:isMapCleared("tae010")
	end,
	eureka_start = function()
		return Account:isMapCleared("dis010")
	end,
	elasia_start = function()
		return Account:isMapCleared("tru017")
	end,
	bkazran_start = function()
		return UnlockSystem:isUnlockSystem(UNLOCK_ID.WORLD_LEVEL)
	end,
	rta_001 = function()
		return Account:getLevel() >= 60
	end,
	user_border = function()
		return Account:checkNewBorder()
	end,
	system_099 = function()
		if not UnlockSystem:isUnlockSystem(UNLOCK_ID.LOCAL_SHOP) then
			return false
		end
		
		local var_32_0 = WorldMapManager:getCurrentContinentKey()
		
		if var_32_0 ~= "hasud" and var_32_0 ~= "vewrda" then
			return false
		end
		
		return true
	end,
	ep3_force = function()
		if not Account:isMapCleared("lfs010") then
			return false
		end
		
		if WorldMapManager:getCurrentContinentKey() ~= "eureka" then
			return false
		end
		
		return true
	end,
	sanctuary_start = function()
		if not UnlockSystem:isUnlockSystem(UNLOCK_ID.SANC_ORBIS) then
			return false
		end
		
		return true
	end,
	system_068 = function()
		if not UnlockSystem:isUnlockSystem(UNLOCK_ID.SANC_FOREST) then
			return false
		end
		
		if SanctuaryMain:GetSumLevels("Forest") ~= 0 then
			return false
		end
		
		return true
	end,
	system_069 = function()
		if not UnlockSystem:isUnlockSystem(UNLOCK_ID.SANC_SUBTASK) then
			return false
		end
		
		if SanctuaryMain:GetSumLevels("SubTask") ~= 0 then
			return false
		end
		
		return true
	end,
	system_070 = function()
		if not UnlockSystem:isUnlockSystem(UNLOCK_ID.SANC_CRAFT) then
			return false
		end
		
		if SanctuaryMain:GetSumLevels("Craft") ~= 0 then
			return false
		end
		
		return true
	end,
	system_071 = function()
		if not UnlockSystem:isUnlockSystem(UNLOCK_ID.SANC_ALCHEMIST) then
			return false
		end
		
		if SanctuaryMain:GetSumLevels("Archemist") ~= 0 then
			return false
		end
		
		return true
	end,
	system_059 = function()
		return Account:isMapCleared("ije002") and Account:getUnitByCode("c1018")
	end
}

local function var_0_2()
	local var_40_0 = {
		"classchange_fire",
		"classchange_ice",
		"classchange_wind",
		"classchange_light",
		"classchange_dark"
	}
	local var_40_1 = false
	
	for iter_40_0, iter_40_1 in pairs(var_40_0) do
		if TutorialGuide:isClearedTutorial(iter_40_1) then
			var_40_1 = true
			
			break
		end
	end
	
	if var_40_1 then
		return false
	end
	
	local var_40_2 = false
	
	for iter_40_2, iter_40_3 in pairs(var_40_0) do
		if TutorialGuide:isPlayingTutorial(iter_40_3) then
			var_40_2 = true
			
			break
		end
	end
	
	if var_40_2 then
		return false
	end
	
	return true
end

var_0_1.classchange_fire = var_0_2
var_0_1.classchange_ice = var_0_2
var_0_1.classchange_wind = var_0_2
var_0_1.classchange_light = var_0_2
var_0_1.classchange_dark = var_0_2

function var_0_1.tuto_destiny_moonlight()
	return MoonlightDestiny:isUnlockSeason()
end

var_0_1.tuto_destiny_moonlight_zl = var_0_1.tuto_destiny_moonlight

function var_0_1.system_203()
	return MoonlightDestiny:isCompleteSeason(1)
end

function var_0_1.tuto_merc_lobby()
	return Account:isMapCleared("poe010")
end

function var_0_1.tuto_merc_shop1()
	if TutorialGuide:isClearedTutorial("tuto_merc_shop2") then
		return false
	end
	
	return true
end

function var_0_1.tuto_merc_shop2()
	if TutorialGuide:isClearedTutorial("tuto_merc_shop1") then
		return false
	end
	
	return true
end

function var_0_1.tuto_merc_end()
	return Account:isMapCleared("poe017")
end

function var_0_1.adin_artifact_start()
	return Account:isMapCleared("tru013")
end

function var_0_1.tuto_adin_awake_1()
	return not Account:getAdin() and Account:isMapCleared("trd010") and not TutorialGuide:isClearedTutorial("tuto_adin_awake_2")
end

function var_0_1.char_awake_unlock(arg_49_0)
	local function var_49_0(arg_50_0)
		if not arg_50_0 then
			return false
		end
		
		if not arg_50_0:isAwakeUnit() then
			return false
		end
		
		if arg_50_0:isGrowthBoostRegistered() then
			return false
		end
		
		if arg_50_0:getZodiacGrade() < 6 then
			return false
		end
		
		return true
	end
	
	if arg_49_0 and arg_49_0.unit then
		return var_49_0(arg_49_0.unit)
	else
		local var_49_1 = Account:getUnits() or {}
		
		for iter_49_0, iter_49_1 in pairs(var_49_1) do
			if var_49_0(iter_49_1) then
				return true
			end
		end
	end
end

function TutorialCondition.isEnable(arg_51_0, arg_51_1, arg_51_2)
	if TutorialGuide:isClearedTutorial(arg_51_1) then
		return false
	end
	
	local var_51_0 = var_0_1[arg_51_1]
	
	if not var_51_0 then
		return true
	end
	
	return var_51_0(arg_51_2)
end

function TutorialCondition.__test(arg_52_0, arg_52_1)
	if PRODUCTION_MODE then
		return 
	end
	
	arg_52_1 = arg_52_1 or {}
	
	Log.i(var_0_0, "--------------------------------------------------------------------------------------------")
	
	for iter_52_0, iter_52_1 in pairs(var_0_1) do
		local var_52_0
		local var_52_1 = TutorialGuide:isClearedTutorial(iter_52_0) and "is cleared" or tostring(iter_52_1())
		
		if table.empty(arg_52_1) or table.find(arg_52_1, var_52_1) then
			Log.i(var_0_0, iter_52_0, var_52_1)
		end
	end
end

function TutorialCondition.___test(arg_53_0, arg_53_1)
	if PRODUCTION_MODE then
		return 
	end
	
	local var_53_0 = var_0_1[arg_53_1]
	
	if not var_53_0 then
		return 
	end
	
	Log.i(var_0_0, arg_53_1, var_53_0(), "is cleard:", TutorialGuide:isClearedTutorial(arg_53_1))
end
