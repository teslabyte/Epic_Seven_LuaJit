PET = PET or {}
PET_TYPE = {
	BATTLE = "battle",
	LOBBY = "lobby"
}
PET_TEAM_IDX = 7

function PET.create(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = {
		is_pet = true,
		apply_crc = arg_1_2
	}
	
	PET.bindFunctions(var_1_0)
	
	if not PET.bindGameDB(var_1_0, arg_1_1.code) then
		return nil
	end
	
	PET.makeInstData(var_1_0, arg_1_1)
	var_1_0:updateLevel()
	var_1_0:updateFavLevel()
	
	return var_1_0
end

function PET.exportCloneData(arg_2_0)
	local var_2_0 = {
		code = arg_2_0.db.code
	}
	
	var_2_0.lv = 1
	var_2_0.grade = arg_2_0.inst.grade
	var_2_0.exp = arg_2_0.inst.exp or 0
	var_2_0.skill_id1 = arg_2_0.inst.skill_id1
	var_2_0.skill_id2 = arg_2_0.inst.skill_id2
	var_2_0.skill_id3 = arg_2_0.inst.skill_id3
	var_2_0.skill_id4 = arg_2_0.inst.skill_id4
	var_2_0.skill_id5 = arg_2_0.inst.skill_id5
	var_2_0.skill_rank1 = arg_2_0.inst.skill_rank1
	var_2_0.skill_rank2 = arg_2_0.inst.skill_rank2
	var_2_0.skill_rank3 = arg_2_0.inst.skill_rank3
	var_2_0.skill_rank4 = arg_2_0.inst.skill_rank4
	var_2_0.skill_rank5 = arg_2_0.inst.skill_rank5
	var_2_0.fav = arg_2_0.inst.fav or 0
	var_2_0.lock = arg_2_0.inst.lock or 0
	var_2_0.name = arg_2_0.inst.name
	var_2_0.name_free = arg_2_0.inst.name_free
	var_2_0.personality = arg_2_0.inst.personality
	
	return var_2_0
end

function PET.clone(arg_3_0)
	return (PET:create(arg_3_0:exportCloneData(), arg_3_0.apply_crc))
end

function PET.bindFunctions(arg_4_0)
	copy_functions(PET, arg_4_0)
end

function PET.bindGameDB(arg_5_0, arg_5_1)
	arg_5_0.db = {}
	arg_5_0.db.skills = {}
	
	local var_5_0 = arg_5_1
	
	arg_5_0.db = DBT("pet_character", var_5_0, {
		"name",
		"desc",
		"type",
		"location",
		"grade",
		"race",
		"feature",
		"limit",
		"model_1",
		"model_2",
		"model_3",
		"model_4",
		"model_5",
		"model_unique",
		"face_1",
		"face_2",
		"face_3",
		"face_4",
		"face_5",
		"skill",
		"personal",
		"exp",
		"price",
		"pet_offset",
		"pet_scale",
		"move"
	})
	
	if arg_5_0.db.grade == nil then
		print("ERROR : NO PET -" .. arg_5_1)
		Dialog:msgBox("NO PET:" .. arg_5_1)
		
		return nil
	end
	
	arg_5_0.db.code = arg_5_1
	
	if not arg_5_0.db.name then
		error("no found character data : " .. arg_5_1)
	end
	
	return true
end

function PET.makeInstData(arg_6_0, arg_6_1)
	arg_6_0.inst = {}
	arg_6_0.inst.uid = arg_6_1.id
	arg_6_0.inst.code = arg_6_1.code
	arg_6_0.inst.lv = 1
	arg_6_0.inst.grade = arg_6_1.grade
	arg_6_0.inst.exp = arg_6_1.exp or 0
	arg_6_0.inst.skill_id1 = arg_6_1.skill_id1
	arg_6_0.inst.skill_id2 = arg_6_1.skill_id2
	arg_6_0.inst.skill_id3 = arg_6_1.skill_id3
	arg_6_0.inst.skill_id4 = arg_6_1.skill_id4
	arg_6_0.inst.skill_id5 = arg_6_1.skill_id5
	arg_6_0.inst.skill_rank1 = arg_6_1.skill_rank1
	arg_6_0.inst.skill_rank2 = arg_6_1.skill_rank2
	arg_6_0.inst.skill_rank3 = arg_6_1.skill_rank3
	arg_6_0.inst.skill_rank4 = arg_6_1.skill_rank4
	arg_6_0.inst.skill_rank5 = arg_6_1.skill_rank5
	arg_6_0.inst.fav = arg_6_1.fav or 0
	arg_6_0.inst.lock = arg_6_1.lock or 0
	arg_6_0.inst.name = arg_6_1.name
	arg_6_0.inst.name_free = arg_6_1.name_free
	arg_6_0.inst.care_day = arg_6_1.care_day
	arg_6_0.inst.personality = arg_6_1.personality
end

function PET.updateLevel(arg_7_0)
	local var_7_0 = 1
	local var_7_1 = arg_7_0:getMaxLevel()
	
	for iter_7_0 = 1, var_7_1 do
		var_7_0 = iter_7_0
		
		local var_7_2 = arg_7_0:getNextExp(iter_7_0)
		
		if var_7_2 == nil or var_7_2 > arg_7_0.inst.exp then
			break
		end
	end
	
	local var_7_3 = arg_7_0.inst.lv ~= var_7_0
	
	arg_7_0.inst.lv = var_7_0
	
	return var_7_3
end

function PET.updateFavLevel(arg_8_0)
	local var_8_0 = 1
	local var_8_1 = arg_8_0:getFavMaxLevel()
	
	for iter_8_0 = 1, var_8_1 do
		var_8_0 = iter_8_0
		
		local var_8_2 = arg_8_0:getNextFavExp(iter_8_0)
		
		if var_8_2 == nil or var_8_2 > arg_8_0.inst.fav then
			break
		end
	end
	
	local var_8_3 = arg_8_0.inst.fav_lv ~= var_8_0
	
	arg_8_0.inst.fav_lv = var_8_0
	
	return var_8_3
end

function PET.getUnitType(arg_9_0)
	return "pet"
end

function PET.getPoint(arg_10_0)
	return 0
end

function PET.getFaceID(arg_11_0)
	return arg_11_0.db["face_" .. arg_11_0.inst.grade]
end

function PET.isAnimationMovable(arg_12_0)
	return arg_12_0.db.move == "y"
end

function PET.isCanRemove(arg_13_0)
	if arg_13_0:isLocked() then
		return false
	end
	
	if Account:isPetInLobby(arg_13_0) then
		return false
	end
	
	for iter_13_0, iter_13_1 in pairs(Account:getPublicReservedTeamSlot()) do
		if Account:isPetInTeam(arg_13_0, iter_13_1) then
			return false
		end
	end
	
	if Account:isPetInTeam(arg_13_0, Account:getDescentPetTeamIdx()) then
		return false
	end
	
	if Account:isPetInTeam(arg_13_0, Account:getBurningPetTeamIdx()) then
		return false
	end
	
	if Account:isPetInTeam(arg_13_0, Account:getCrehuntTeamIndex()) then
		return false
	end
	
	if BackPlayManager:isRunningTeamPet(arg_13_0:getUID()) then
		return false
	end
	
	return true
end

function PET.isCanSynthesis(arg_14_0)
	if arg_14_0:isLocked() then
		return false
	end
	
	if BackPlayManager:isRunningTeamPet(arg_14_0:getUID()) then
		return false
	end
	
	return true
end

function PET.getUsableSynthesisList(arg_15_0)
	local var_15_0 = {}
	
	if arg_15_0:isLocked() then
		table.insert(var_15_0, "locked_pet")
	end
	
	if BackPlayManager:isRunningTeamPet(arg_15_0:getUID()) then
		table.insert(var_15_0, "ul_bgbattle")
	end
	
	return var_15_0
end

function PET.getUsableCodeList(arg_16_0)
	local var_16_0 = {}
	
	if arg_16_0:isLocked() then
		table.insert(var_16_0, "locked_pet")
	end
	
	if Account:isPetInLobby(arg_16_0) then
		table.insert(var_16_0, "locked_pet_lobby")
	end
	
	for iter_16_0, iter_16_1 in pairs(Account:getPublicReservedTeamSlot()) do
		if Account:isPetInTeam(arg_16_0, iter_16_1) then
			table.insert(var_16_0, "ul_team_" .. iter_16_1)
		end
	end
	
	if Account:isPetInTeam(arg_16_0, Account:getDescentPetTeamIdx()) then
		table.insert(var_16_0, "ul_descent")
	end
	
	if Account:isPetInTeam(arg_16_0, Account:getBurningPetTeamIdx()) then
		table.insert(var_16_0, "ul_burning")
	end
	
	if Account:isPetInTeam(arg_16_0, Account:getCrehuntTeamIndex()) then
		table.insert(var_16_0, "ul_team_29")
	end
	
	if BackPlayManager:isRunningTeamPet(arg_16_0:getUID()) then
		table.insert(var_16_0, "ul_bgbattle")
	end
	
	if #var_16_0 == 0 then
		return nil
	end
	
	return var_16_0
end

function PET.getLv(arg_17_0)
	return arg_17_0.inst.lv
end

function PET.getNeedExp(arg_18_0, arg_18_1)
	arg_18_1 = arg_18_1 or arg_18_0.inst.lv
	
	local var_18_0 = DB("pet_exp", tostring(arg_18_1), "grade" .. arg_18_0:getBaseGrade())
	
	if arg_18_1 <= 1 then
		return var_18_0
	end
	
	return var_18_0 - DB("pet_exp", tostring(arg_18_1 - 1), "grade" .. arg_18_0:getBaseGrade())
end

function PET.getRestFavExp(arg_19_0, arg_19_1)
	arg_19_1 = arg_19_1 or arg_19_0.inst.fav_lv
	
	local var_19_0 = "petaff_" .. arg_19_1
	
	return tonumber(DB("pet_affection", var_19_0, "exp")) - arg_19_0.inst.fav
end

function PET.getNeedFavExp(arg_20_0, arg_20_1)
	arg_20_1 = arg_20_1 or arg_20_0.inst.fav_lv
	
	local var_20_0 = "petaff_"
	local var_20_1 = DB("pet_affection", var_20_0 .. tostring(arg_20_1), "exp")
	
	if arg_20_1 <= 1 then
		return var_20_1
	end
	
	return var_20_1 - DB("pet_affection", var_20_0 .. tostring(arg_20_1 - 1), "exp")
end

function PET.getFavMaxLevel(arg_21_0)
	return GAME_STATIC_VARIABLE.max_pet_favor
end

function PET.getFavExpString(arg_22_0, arg_22_1)
	arg_22_1 = arg_22_1 or 0
	
	if arg_22_0:isMaxFav() then
		return "Max", 1
	end
	
	local var_22_0 = arg_22_0:getMaxFav()
	local var_22_1 = (var_22_0 - (var_22_0 - (arg_22_0:getFav() + arg_22_1))) / var_22_0
	
	return comma_value(arg_22_0:getFav() + arg_22_1) .. "/" .. comma_value(var_22_0), var_22_1
end

function PET.getRestExp(arg_23_0, arg_23_1)
	arg_23_1 = arg_23_1 or arg_23_0.inst.lv
	
	return to_n(DB("pet_character", tostring(arg_23_1), "petaff_" .. arg_23_0:getFavLevel())) - arg_23_0:getEXP()
end

function PET.getNextFavExp(arg_24_0, arg_24_1)
	local var_24_0 = arg_24_1 or arg_24_0.inst.fav_lv
	
	if var_24_0 > GAME_STATIC_VARIABLE.max_pet_favor then
		return 
	end
	
	return DB("pet_affection", "petaff_" .. var_24_0, {
		"exp"
	})
end

function PET.getFavLevel(arg_25_0)
	return arg_25_0.inst.fav_lv
end

function PET.isMaxFav(arg_26_0)
	if arg_26_0.inst.fav_lv == arg_26_0:getFavMaxLevel() then
		return true
	end
	
	return false
end

function PET.getExpString(arg_27_0, arg_27_1)
	arg_27_1 = arg_27_1 or 0
	
	if arg_27_0:isMaxLevel() then
		return "Max", 1
	end
	
	local var_27_0 = math.max(0, arg_27_0:getRestExp() - arg_27_1)
	local var_27_1 = arg_27_0:getNeedExp()
	local var_27_2 = (var_27_1 - var_27_0) / var_27_1
	
	return comma_value(var_27_1 - arg_27_0:getRestExp() + arg_27_1) .. "/" .. comma_value(var_27_1), var_27_2
end

function PET.isPet(arg_28_0)
	return arg_28_0.is_pet
end

function PET.isSummon(arg_29_0)
	return false
end

function PET.getNextExp(arg_30_0, arg_30_1)
	arg_30_1 = arg_30_1 or arg_30_0.inst.lv
	
	return DB("pet_exp", tostring(arg_30_1), "grade" .. arg_30_0:getBaseGrade())
end

function PET.getRestExp(arg_31_0, arg_31_1)
	arg_31_1 = arg_31_1 or arg_31_0.inst.lv
	
	return to_n(DB("pet_exp", tostring(arg_31_1), "grade" .. arg_31_0:getBaseGrade())) - arg_31_0:getEXP()
end

function PET.getName(arg_32_0)
	if arg_32_0.inst.name then
		return arg_32_0.inst.name
	else
		return T(arg_32_0.db.name)
	end
end

function PET.getDefaultName(arg_33_0)
	return T(arg_33_0.db.name)
end

function PET.getUID(arg_34_0)
	return arg_34_0.inst.uid
end

function PET.getConsumeExp(arg_35_0)
	local var_35_0 = arg_35_0:getGrade()
	local var_35_1 = DB("pet_grade", "pg_" .. var_35_0, "exp_up") or 1
	
	return arg_35_0.db.exp * var_35_1
end

function PET.getEXP(arg_36_0)
	return arg_36_0.inst.exp
end

function PET.getSkillID(arg_37_0, arg_37_1)
	return arg_37_0.inst["skill_id" .. arg_37_1]
end

function PET.getSkillRank(arg_38_0, arg_38_1)
	return arg_38_0.inst["skill_rank" .. arg_38_1]
end

function PET.getHighestSkillRank(arg_39_0)
	local var_39_0 = 0
	
	for iter_39_0 = 1, 5 do
		local var_39_1 = arg_39_0.inst["skill_rank" .. iter_39_0]
		
		if not var_39_1 then
			break
		end
		
		var_39_0 = math.max(var_39_0, var_39_1)
	end
	
	return var_39_0
end

function PET.getSkillMax(arg_40_0)
	return 4
end

function PET.getSynthesisValue(arg_41_0)
	return arg_41_0:getGrade() * GAME_STATIC_VARIABLE.pet_synthesis_value
end

function PET.getTransformValue(arg_42_0)
	return DB("pet_grade", "pg_" .. arg_42_0:getGrade(), {
		"transform_token"
	}) or 0
end

function PET.getAllSkillID(arg_43_0)
	local var_43_0 = arg_43_0:getSkillMax()
	local var_43_1 = {}
	
	for iter_43_0 = 1, var_43_0 do
		local var_43_2 = arg_43_0.inst["skill_id" .. iter_43_0]
		
		if not var_43_2 then
			break
		end
		
		table.insert(var_43_1, var_43_2)
	end
	
	return var_43_1
end

function PET.getAllSkillRank(arg_44_0)
	local var_44_0 = arg_44_0:getSkillMax()
	local var_44_1 = {}
	
	for iter_44_0 = 1, var_44_0 do
		local var_44_2 = arg_44_0.inst["skill_rank" .. iter_44_0]
		
		if not var_44_2 then
			break
		end
		
		table.insert(var_44_1, var_44_2)
	end
	
	return var_44_1
end

function PET.isTodayTakeCare(arg_45_0)
	if not arg_45_0.inst.care_day then
		return true
	end
	
	return arg_45_0.inst.care_day < Account:serverTimeDayLocalDetail()
end

function PET.update_careDay(arg_46_0)
	arg_46_0.inst.care_day = Account:serverTimeDayLocalDetail()
end

function PET.set_careDay(arg_47_0, arg_47_1)
	arg_47_0.inst.care_day = arg_47_1
end

function PET.get_careDay(arg_48_0)
	return arg_48_0.inst.care_day
end

function PET.getBaseGrade(arg_49_0)
	return arg_49_0.db.grade
end

function PET.getGrade(arg_50_0)
	return arg_50_0.inst.grade
end

function PET.getComposeTargetGrade(arg_51_0)
	return arg_51_0.inst.grade + 1
end

function PET.getRepeat_count(arg_52_0)
	return DB("pet_grade", "pg_" .. arg_52_0:getGrade(), {
		"repeat_count"
	}) or 0
end

function PET.getMaxFixSkillNum(arg_53_0)
	local var_53_0 = "pg_" .. arg_53_0:getGrade()
	
	return DB("pet_grade", var_53_0, "max_fix")
end

function PET.getMaxGrade(arg_54_0)
	return GAME_STATIC_VARIABLE.max_pet_grade
end

function PET.isMaxGrade(arg_55_0)
	return arg_55_0:getGrade() == arg_55_0:getMaxGrade()
end

function PET.getMaxFav(arg_56_0, arg_56_1)
	arg_56_1 = arg_56_1 or arg_56_0:getGrade()
	
	local var_56_0 = arg_56_0:getMaxGrade()
	
	if var_56_0 < arg_56_1 then
		arg_56_1 = var_56_0
	end
	
	return DB("pet_grade", "pg_" .. arg_56_1, "affection")
end

function PET.isFavUpgradeable(arg_57_0)
	if arg_57_0:getMaxFav() <= arg_57_0.inst.fav then
		return false
	end
	
	return true
end

function PET.getCode(arg_58_0)
	return arg_58_0.db.code
end

function PET.getSortByCodeValue(arg_59_0)
	local var_59_0 = tonumber(string.sub(arg_59_0.db.code, 4, 6))
	local var_59_1 = string.sub(arg_59_0.db.code, -1)
	local var_59_2 = tonumber(var_59_1)
	
	if var_59_2 ~= nil then
		var_59_1 = var_59_2
	else
		var_59_1 = string.byte(var_59_1)
	end
	
	return var_59_0 * 1000 + var_59_1
end

function PET.getDisplayCode(arg_60_0)
	return arg_60_0.db.code
end

function PET.getType(arg_61_0)
	return arg_61_0.db.type
end

function PET.getRace(arg_62_0)
	return arg_62_0.db.race
end

function PET.getDesc(arg_63_0)
	return arg_63_0.db.desc
end

function PET.setFav(arg_64_0, arg_64_1)
	arg_64_0.inst.fav = arg_64_1
	
	arg_64_0:updateFavLevel()
end

function PET.getFav(arg_65_0)
	return arg_65_0.inst.fav or 0
end

function PET.getModelID(arg_66_0)
	local var_66_0 = math.clamp(arg_66_0:getGrade(), 1, arg_66_0:getMaxGrade())
	
	return arg_66_0.db["model_" .. var_66_0]
end

function PET.getModelScale(arg_67_0)
	return 1 or to_n(arg_67_0.db.pet_scale)
end

function PET.getPersonality(arg_68_0)
	return arg_68_0.inst.personality
end

function PET.isMoverPaused(arg_69_0)
	return arg_69_0.inst.mover_pause
end

function PET.isNameChangeFree(arg_70_0)
	return arg_70_0.inst.name_free == 0
end

function PET.setName(arg_71_0, arg_71_1)
	arg_71_0.inst.name = arg_71_1
	
	if arg_71_0.inst.name_free == 0 then
		arg_71_0.inst.name_free = 1
	end
end

function PET.setMoverPause(arg_72_0, arg_72_1)
	arg_72_0.inst.mover_pause = arg_72_1
end

function PET.isFeature(arg_73_0)
	return arg_73_0.db.feature
end

function PET.isLimit(arg_74_0)
	return arg_74_0.db.limit
end

function PET.getGiftItemID(arg_75_0)
	local var_75_0 = "pg_" .. arg_75_0:getGrade()
	
	return DB("pet_grade", var_75_0, "lobby_gift")
end

function PET.getGiftTime(arg_76_0)
	return GAME_STATIC_VARIABLE.pet_gift_time
end

function PET.getExpToLevel(arg_77_0, arg_77_1)
	arg_77_1 = arg_77_1 or arg_77_0.inst.exp
	
	local var_77_0 = 1
	
	for iter_77_0 = 1, arg_77_0:getMaxLevel() do
		var_77_0 = iter_77_0
		
		local var_77_1 = arg_77_0:getNextExp(iter_77_0)
		
		if var_77_1 == nil or arg_77_1 < var_77_1 then
			break
		end
	end
	
	local var_77_2 = arg_77_0.inst.lv ~= var_77_0
	local var_77_3 = var_77_0 - arg_77_0.inst.lv
	
	return var_77_2, var_77_0, var_77_3
end

function PET.getEnhancePrice(arg_78_0)
	local var_78_0 = GAME_STATIC_VARIABLE.pet_enhance_price or 150
	
	return (3 + arg_78_0.db.grade) * var_78_0
end

function PET.getSellGoldPrice(arg_79_0)
	return arg_79_0.db.price * DB("pet_grade", "pg_" .. arg_79_0:getGrade(), "price_up")
end

function PET.getSellPetPointPrice(arg_80_0)
	return (DB("pet_grade", "pg_" .. arg_80_0:getGrade(), "token"))
end

function PET.updateLevel(arg_81_0)
	local var_81_0, var_81_1, var_81_2 = arg_81_0:getExpToLevel()
	
	if var_81_0 then
		arg_81_0.inst.lv = var_81_1
	end
	
	return var_81_0, var_81_1, var_81_2
end

function PET.addExp(arg_82_0, arg_82_1)
	arg_82_0.inst.exp = arg_82_0.inst.exp + arg_82_1
	
	return arg_82_0:updateLevel()
end

function PET.setExp(arg_83_0, arg_83_1)
	arg_83_0.inst.exp = arg_83_1
	
	return arg_83_0:updateLevel()
end

function PET.getMaxLevel(arg_84_0, arg_84_1)
	arg_84_1 = arg_84_1 or arg_84_0:getGrade()
	
	return (math.min(arg_84_1 * 10, GAME_STATIC_VARIABLE.max_pet_level))
end

function PET.isPetFood(arg_85_0)
	return false
end

function PET.isLocked(arg_86_0)
	return arg_86_0.inst.lock == 1
end

function PET.setLocked(arg_87_0, arg_87_1)
	arg_87_0.inst.lock = arg_87_1
end

function PET.isMaxLevel(arg_88_0)
	return arg_88_0.inst.lv >= arg_88_0:getMaxLevel()
end

function PET.isMaxFavoriteLevel(arg_89_0)
	return arg_89_0:getFavLevel() >= arg_89_0:getMaxFav()
end

function PET.isUpgradable(arg_90_0)
	return not arg_90_0:isMaxLevel() and arg_90_0:getGrade() < arg_90_0:getMaxGrade()
end

function PET.addToTeam(arg_91_0, arg_91_1)
end

function PET.playPetSound(arg_92_0)
	SoundEngine:play("event:/ui/pet/" .. arg_92_0:getRace())
end
