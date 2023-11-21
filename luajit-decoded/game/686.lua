LotaObjectData = ClassDef()
LotaObjectInterface = {
	object_id = "",
	inst = {
		max_use = 0,
		object_id = "",
		dead = false,
		use_count = 0,
		tile_id = 1,
		user_users = {},
		object_info = {
			max_use = 5,
			use_users = {},
			event = {}
		},
		child_id = {}
	},
	db = {}
}
LotaObjectDataNotifyInterface = {
	onDetail = function(arg_1_0)
		arg_1_0:onDetail()
	end,
	onUse = function(arg_2_0)
		arg_2_0:onUse()
	end,
	onCancel = function(arg_3_0)
		arg_3_0:onCancel()
	end,
	onResponse = function(arg_4_0, arg_4_1)
		arg_4_0:onResponse(arg_4_1)
	end,
	onExpire = function(arg_5_0)
		arg_5_0:onExpire()
	end
}

local function var_0_0(arg_6_0)
	if arg_6_0 == "debug_object" then
	end
end

local function var_0_1(arg_7_0)
	if arg_7_0 == "debug_object" then
	end
end

DEBUG.LOTA_DEBUG_OBJECTS = true

local function var_0_2(arg_8_0)
	return DBT("clan_heritage_object_icon", arg_8_0, {
		"id",
		"map_icon",
		"character",
		"scale",
		"location_x",
		"location_y",
		"reflect",
		"effect",
		"hp_offset",
		"effect",
		"eff_scale",
		"eff_location",
		"adj_focus_y_pos"
	}) or {}
end

function LotaObjectData.constructor(arg_9_0, arg_9_1)
	arg_9_0.inst = arg_9_1
	arg_9_0.db_key = arg_9_1.object_id
	arg_9_0.db = {}
	arg_9_0.db = DBT("clan_heritage_object_data", arg_9_0.db_key, {
		"id",
		"category",
		"name",
		"desc",
		"map_icon_before",
		"map_icon_after",
		"minimap_color",
		"use_token",
		"type_1",
		"type_2",
		"role",
		"after_kill",
		"max_use",
		"monster_level",
		"level_id",
		"grade",
		"skill",
		"floating_idx",
		"floating_direction",
		"reward_type",
		"reward_title",
		"reward_desc",
		"reward_id",
		"preview_reward_id"
	})
	arg_9_0.after_offset_db = var_0_2(arg_9_0.db.map_icon_after)
	arg_9_0.before_offset_db = var_0_2(arg_9_0.db.map_icon_before)
	
	if not arg_9_0.inst.max_use and arg_9_0.db.max_use then
		arg_9_0.inst.max_use = arg_9_0.db.max_use
	end
	
	if not arg_9_0.inst.object_info then
		arg_9_0.inst.object_info = {}
	end
	
	if not arg_9_0.inst.object_info.use_users then
		arg_9_0.inst.object_info.use_users = {}
	end
	
	arg_9_0:translateUseUsersKey()
end

function LotaObjectData.translateUseUsersKey(arg_10_0)
	if arg_10_0.inst.object_info.use_users then
		local var_10_0 = {}
		
		for iter_10_0, iter_10_1 in pairs(arg_10_0.inst.object_info.use_users) do
			var_10_0[tostring(iter_10_0)] = iter_10_1
		end
		
		arg_10_0.inst.object_info.use_users = var_10_0
	end
end

function LotaObjectData.getUID(arg_11_0)
	return tostring(arg_11_0.inst.tile_id)
end

function LotaObjectData.isMainId(arg_12_0, arg_12_1)
	return tostring(arg_12_0:getUID()) == tostring(arg_12_1)
end

function LotaObjectData.getMinimapIconMiddlePosition(arg_13_0)
	if table.empty(arg_13_0:getChildTileList()) then
		return 1, 1
	end
	
	local var_13_0 = 1
	local var_13_1 = 1
	local var_13_2 = LotaTileMapSystem:getTileById(arg_13_0:getUID())
	local var_13_3 = 0
	local var_13_4 = 0
	local var_13_5 = 0
	local var_13_6 = 0
	
	for iter_13_0, iter_13_1 in pairs(arg_13_0:getChildTileList()) do
		local var_13_7 = LotaTileMapSystem:getTileById(iter_13_1)
		local var_13_8 = LotaUtil:getDecedPosition(var_13_7:getPos(), var_13_2:getPos())
		
		var_13_3 = math.min(var_13_8.x, var_13_3)
		var_13_4 = math.max(var_13_8.x, var_13_4)
		var_13_5 = math.min(var_13_8.y, var_13_5)
		var_13_6 = math.max(var_13_8.y, var_13_6)
	end
	
	local var_13_9 = var_13_0 + (var_13_4 - var_13_3) / 2
	local var_13_10 = var_13_1 + (var_13_6 - var_13_5) / 2
	
	return var_13_9, var_13_10
end

function LotaObjectData.getChildTileList(arg_14_0)
	return arg_14_0.inst.child_id
end

function LotaObjectData.isMonsterType(arg_15_0)
	return ({
		elite_monster = true,
		boss_monster = true,
		keeper_monster = true,
		normal_monster = true
	})[arg_15_0:getTypeDetail()]
end

function LotaObjectData.isCoopMonsterType(arg_16_0)
	return ({
		keeper_monster = true,
		boss_monster = true,
		elite_monster = true
	})[arg_16_0:getTypeDetail()]
end

function LotaObjectData.isActive(arg_17_0)
	if arg_17_0.inst.force_active then
		return true
	end
	
	if arg_17_0:isMonsterType() and arg_17_0:getTypeDetail() ~= "normal_monster" then
		return not (LotaBattleDataSystem:isBossDeadByTileId(arg_17_0:getUID(), arg_17_0:getDBId()) or false)
	end
	
	if arg_17_0:getTypeDetail() == "portal" then
		return LotaClanInfo:isAvailableBossBattle(LotaUserData:getFloor())
	end
	
	return (arg_17_0:getMaxUse() or 0) > (arg_17_0.inst.use_count or 0)
end

function LotaObjectData.isExistAfterObject(arg_18_0)
	return arg_18_0.db.after_kill ~= nil
end

function LotaObjectData.isExistAfterMonster(arg_19_0)
	local var_19_0 = {
		elite_monster = true,
		boss_monster = true,
		keeper_monster = true,
		normal_monster = true
	}
	
	if arg_19_0.db.after_kill then
		local var_19_1, var_19_2 = DB("clan_heritage_object_data", arg_19_0.db.after_kill, {
			"type_1",
			"type_2"
		})
		
		return var_19_0[var_19_2]
	end
	
	return false
end

function LotaObjectData.getClanObjectUseCount(arg_20_0)
	return arg_20_0.inst.use_count or 0
end

function LotaObjectData.getMonsterHP(arg_21_0)
	if not arg_21_0:isMonsterType() then
		error("NOT MONSTER BUT TRY ACCESS MONSTER HP")
		
		return 
	end
	
	return (arg_21_0:getMaxUse() or 0) - (arg_21_0.inst.use_count or 0)
end

function LotaObjectData.getMaxUse(arg_22_0)
	return arg_22_0.db.max_use or -9999
end

function LotaObjectData.getLevelID(arg_23_0)
	return arg_23_0.db.level_id
end

function LotaObjectData.getDBId(arg_24_0)
	return arg_24_0.db.id
end

function LotaObjectData.getTileId(arg_25_0)
	return tostring(arg_25_0.inst.tile_id)
end

function LotaObjectData.getCategory(arg_26_0)
	return arg_26_0.db.category
end

function LotaObjectData.getCost(arg_27_0)
	return arg_27_0.db.use_token
end

function LotaObjectData.getSanctuaryTargetRole(arg_28_0)
	return arg_28_0.db.role
end

function LotaObjectData.getType(arg_29_0)
	return arg_29_0.db.type_1
end

function LotaObjectData.getMonsterLevel(arg_30_0)
	return arg_30_0.db.monster_level
end

function LotaObjectData.getTypeDetail(arg_31_0)
	return arg_31_0.db.type_2
end

function LotaObjectData.isModel(arg_32_0)
	return arg_32_0:getObjectOffsetDB().character ~= nil
end

function LotaObjectData.getIconColumn(arg_33_0)
	if arg_33_0:isActive() then
		return "map_icon_before"
	end
	
	return "map_icon_after"
end

function LotaObjectData.getUseToken(arg_34_0)
	return arg_34_0.db.use_token
end

function LotaObjectData.getRewardId(arg_35_0)
	return arg_35_0.db.reward_id
end

function LotaObjectData.getFloatingIdx(arg_36_0)
	return arg_36_0.db.floating_idx
end

function LotaObjectData.getFloatingDirection(arg_37_0)
	return arg_37_0.db.floating_direction or "left"
end

function LotaObjectData.getRewardDummyId(arg_38_0)
	return arg_38_0.db.preview_reward_id
end

function LotaObjectData.getDisplayRewardId(arg_39_0)
	local var_39_0 = arg_39_0.db.preview_reward_id
	
	if var_39_0 then
		return var_39_0
	end
	
	return arg_39_0:getRewardId()
end

function LotaObjectData.getRewardTitle(arg_40_0)
	return arg_40_0.db.reward_title
end

function LotaObjectData.getRewardDesc(arg_41_0)
	return arg_41_0.db.reward_desc
end

function LotaObjectData.debug_updateOffsetDB(arg_42_0, arg_42_1, arg_42_2, arg_42_3, arg_42_4)
	local var_42_0 = arg_42_0:getObjectOffsetDB()
	
	if var_42_0.id == arg_42_1 then
		var_42_0.location_x = arg_42_2 or var_42_0.location_x
		var_42_0.location_y = arg_42_3 or var_42_0.location_y
		var_42_0.scale = arg_42_4 or var_42_0.scale
	end
end

function LotaObjectData.debug_updateEffectOffsetDB(arg_43_0, arg_43_1, arg_43_2, arg_43_3, arg_43_4, arg_43_5)
	local var_43_0 = arg_43_0:getObjectOffsetDB()
	
	if var_43_0.id == arg_43_1 then
		if arg_43_2 then
			var_43_0.effect = arg_43_2
		end
		
		print("id, effect, x, y, scale", arg_43_1, arg_43_2, arg_43_3, arg_43_4, arg_43_5)
		
		local var_43_1 = var_43_0.eff_location
		local var_43_2 = string.split(var_43_1, ",")
		
		arg_43_3 = arg_43_3 or to_n(var_43_2[1])
		arg_43_4 = arg_43_4 or to_n(var_43_2[2])
		var_43_0.eff_location = tostring(arg_43_3) .. "," .. tostring(arg_43_4)
		var_43_0.eff_scale = arg_43_5 or var_43_0.eff_scale
	end
end

function LotaObjectData.getOffsetDBKey(arg_44_0)
	local var_44_0 = arg_44_0:getIconColumn()
	
	return DB("clan_heritage_object_data", arg_44_0.db.id, var_44_0) or ""
end

function LotaObjectData.getSpritePath(arg_45_0)
	local var_45_0 = arg_45_0:getObjectOffsetDB()
	
	if arg_45_0:isModel() then
		return var_45_0.character
	end
	
	if var_45_0.map_icon == nil then
		return "img/cm_icon_clan_war1.png"
	end
	
	return "tile/" .. var_45_0.map_icon .. ".png"
end

function LotaObjectData.getObjectOffsetDB(arg_46_0)
	local var_46_0 = arg_46_0.before_offset_db
	
	if not arg_46_0:isActive() then
		var_46_0 = arg_46_0.after_offset_db
	end
	
	return var_46_0
end

function LotaObjectData.getAdjustFocusYPos(arg_47_0)
	return arg_47_0:getObjectOffsetDB().adj_focus_y_pos or 0
end

function LotaObjectData.getPositionXOffset(arg_48_0)
	return arg_48_0:getObjectOffsetDB().location_x
end

function LotaObjectData.getHPBarPositionXOffset(arg_49_0)
	local var_49_0 = arg_49_0:getObjectOffsetDB().hp_offset
	
	if not var_49_0 then
		return 0
	end
	
	local var_49_1 = string.split(var_49_0, ",")
	
	return to_n(var_49_1[1])
end

function LotaObjectData.getHPBarPositionYOffset(arg_50_0)
	local var_50_0 = arg_50_0:getObjectOffsetDB().hp_offset
	
	if not var_50_0 then
		return 0
	end
	
	local var_50_1 = string.split(var_50_0, ",")
	
	return to_n(var_50_1[2])
end

function LotaObjectData.isExistEffect(arg_51_0)
	return arg_51_0:getObjectOffsetDB().effect ~= nil
end

function LotaObjectData.getEffect(arg_52_0)
	return arg_52_0:getObjectOffsetDB().effect
end

function LotaObjectData.getEffectScale(arg_53_0)
	return arg_53_0:getObjectOffsetDB().eff_scale
end

function LotaObjectData.getEffectLocation(arg_54_0)
	local var_54_0 = arg_54_0:getObjectOffsetDB().eff_location
	
	if not var_54_0 then
		return {
			x = 0,
			y = 0
		}
	end
	
	local var_54_1 = string.split(var_54_0, ",")
	
	return {
		x = tonumber(var_54_1[1]),
		y = tonumber(var_54_1[2])
	}
end

function LotaObjectData.getPositionYOffset(arg_55_0)
	return arg_55_0:getObjectOffsetDB().location_y
end

function LotaObjectData.getScaleOffset(arg_56_0)
	return arg_56_0:getObjectOffsetDB().scale
end

function LotaObjectData.isReflect(arg_57_0)
	return arg_57_0:getObjectOffsetDB().reflect
end

function LotaObjectData.isClanObject(arg_58_0)
	return arg_58_0.db.type_1 == "clan"
end

function LotaObjectData.isUsedClanObject(arg_59_0)
	if arg_59_0.db.type_1 ~= "clan" then
		print("!!!!!! ONLY USE ON CLAN !!!!!!")
		
		return 
	end
	
	if arg_59_0:isMonsterType() then
		return false
	end
	
	return arg_59_0.inst.object_info.use_users[tostring(AccountData.id)] == true
end

function LotaObjectData.onDetail(arg_60_0)
	local var_60_0 = LotaObjectDetailHandler[arg_60_0.db.type_2]
	
	if var_60_0 then
		var_60_0(LotaObjectDetailHandler, arg_60_0)
	else
		LotaInteractiveUI:openDetailTooltip(arg_60_0)
	end
end

function LotaObjectData.onUse(arg_61_0)
	local var_61_0 = LotaObjectInteractionHandler[arg_61_0.db.type_2]
	
	if var_61_0 then
		var_61_0(LotaObjectInteractionHandler, arg_61_0)
	else
		Log.e("NOT IMPLED HANDLER", arg_61_0.db.type_2)
	end
end

function LotaObjectData.onResponse(arg_62_0, arg_62_1)
	local var_62_0 = LotaObjectResponseHandler[arg_62_0.db.type_2]
	
	if var_62_0 then
		var_62_0(LotaObjectResponseHandler, arg_62_0, arg_62_1)
	else
		Log.e("NOT IMPLED HANDLER", arg_62_0.db.type_2)
	end
end

function LotaObjectData.onExpire(arg_63_0)
	local var_63_0 = LotaObjectExpireHandler[arg_63_0.db.type_2]
	
	if var_63_0 then
		var_63_0(LotaObjectExpireHandler, arg_63_0)
	else
		LotaObjectRenderer:requestExpire(arg_63_0:getUID())
	end
end

function LotaObjectData.onCancel(arg_64_0)
end

function LotaObjectData.updateInfo(arg_65_0, arg_65_1)
	arg_65_0.inst = table.clone(arg_65_1)
end

function LotaObjectData.updateObjectInfo(arg_66_0, arg_66_1)
	arg_66_0.inst.object_info = arg_66_1
	arg_66_0.inst.object_id = arg_66_0.inst.object
	
	LotaUtil:createChildIdListToObjectInfo(arg_66_0.inst)
	arg_66_0:translateUseUsersKey()
end

function LotaObjectData.isExistEvent(arg_67_0)
	return arg_67_0.inst.object_info.event ~= nil and not table.empty(arg_67_0.inst.object_info.event)
end

function LotaObjectData.isUsableEvent(arg_68_0)
	return arg_68_0:isExistEvent() and not arg_68_0.inst.object_info.event.complete
end

function LotaObjectData.getEventId(arg_69_0)
	if not arg_69_0:isExistEvent() then
		return 
	end
	
	return arg_69_0.inst.object_info.event.event_id
end

function LotaObjectData.updateUseCount(arg_70_0, arg_70_1)
	arg_70_0.inst.use_count = arg_70_1
end

function LotaObjectData.updateDead(arg_71_0, arg_71_1)
	arg_71_0.inst.dead = arg_71_1
end
