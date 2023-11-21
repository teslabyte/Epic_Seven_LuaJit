HTBObjectData = ClassDef()
HTBObjectInterface = {
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

function HTBObjectData.base_constructor(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.inst = arg_1_1
	arg_1_0.db_key = arg_1_1.object_id
	arg_1_0.object_db_name = arg_1_2
	arg_1_0.object_icon_db_name = arg_1_3
	
	arg_1_0:bindObjectDB()
	arg_1_0:bindIconDB()
	
	if not arg_1_0.inst.max_use and arg_1_0.db.max_use then
		arg_1_0.inst.max_use = arg_1_0.db.max_use
	end
	
	if not arg_1_0.inst.object_info then
		arg_1_0.inst.object_info = {}
	end
	
	if not arg_1_0.inst.object_info.use_users then
		arg_1_0.inst.object_info.use_users = {}
	end
	
	arg_1_0:translateUseUsersKey()
end

function HTBObjectData.base_updateObjectInfo(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0.inst.object_info = arg_2_2
	arg_2_0.inst.object_id = arg_2_0.inst.object
	
	HTBInterface:createChildIdListToObjectInfo(arg_2_1, arg_2_0.inst)
	arg_2_0:translateUseUsersKey()
end

function HTBObjectData.bindObjectDB(arg_3_0)
	arg_3_0.db = DBT(arg_3_0.object_db_name, arg_3_0.db_key, {
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
	}) or {}
end

local function var_0_0(arg_4_0, arg_4_1)
	return DBT(arg_4_1, arg_4_0, {
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

function HTBObjectData.bindIconDB(arg_5_0)
	arg_5_0.after_offset_db = var_0_0(arg_5_0.db.map_icon_after, arg_5_0.object_icon_db_name)
	arg_5_0.before_offset_db = var_0_0(arg_5_0.db.map_icon_before, arg_5_0.object_icon_db_name)
end

function HTBObjectData.translateUseUsersKey(arg_6_0)
	if arg_6_0.inst.object_info.use_users then
		local var_6_0 = {}
		
		for iter_6_0, iter_6_1 in pairs(arg_6_0.inst.object_info.use_users) do
			var_6_0[tostring(iter_6_0)] = iter_6_1
		end
		
		arg_6_0.inst.object_info.use_users = var_6_0
	end
end

function HTBObjectData.base_getMinimapIconMiddlePosition(arg_7_0, arg_7_1)
	if table.empty(arg_7_0:getChildTileList()) then
		return 1, 1
	end
	
	local var_7_0 = 1
	local var_7_1 = 1
	local var_7_2 = HTBInterface:getTileById(arg_7_1, arg_7_0:getUID())
	local var_7_3 = 0
	local var_7_4 = 0
	local var_7_5 = 0
	local var_7_6 = 0
	
	for iter_7_0, iter_7_1 in pairs(arg_7_0:getChildTileList()) do
		local var_7_7 = HTBInterface:getTileById(arg_7_1, iter_7_1)
		local var_7_8 = HTUtil:getDecedPosition(var_7_7:getPos(), var_7_2:getPos())
		
		var_7_3 = math.min(var_7_8.x, var_7_3)
		var_7_4 = math.max(var_7_8.x, var_7_4)
		var_7_5 = math.min(var_7_8.y, var_7_5)
		var_7_6 = math.max(var_7_8.y, var_7_6)
	end
	
	local var_7_9 = var_7_0 + (var_7_4 - var_7_3) / 2
	local var_7_10 = var_7_1 + (var_7_6 - var_7_5) / 2
	
	return var_7_9, var_7_10
end

function HTBObjectData.getUID(arg_8_0)
	return tostring(arg_8_0.inst.tile_id)
end

function HTBObjectData.isMainId(arg_9_0, arg_9_1)
	return tostring(arg_9_0:getUID()) == tostring(arg_9_1)
end

function HTBObjectData.getChildTileList(arg_10_0)
	return arg_10_0.inst.child_id
end

function HTBObjectData.isMonsterType(arg_11_0)
	return ({
		elite_monster = true,
		boss_monster = true,
		keeper_monster = true,
		normal_monster = true
	})[arg_11_0:getTypeDetail()]
end

function HTBObjectData.isCoopMonsterType(arg_12_0)
	return ({
		keeper_monster = true,
		boss_monster = true,
		elite_monster = true
	})[arg_12_0:getTypeDetail()]
end

function HTBObjectData.isActive(arg_13_0)
	if arg_13_0.inst.force_active then
		return true
	end
	
	return (arg_13_0:getMaxUse() or 0) > (arg_13_0.inst.use_count or 0)
end

function HTBObjectData.isExistAfterObject(arg_14_0)
	return arg_14_0.db.after_kill ~= nil
end

function HTBObjectData.isExistAfterMonster(arg_15_0)
	local var_15_0 = {
		elite_monster = true,
		boss_monster = true,
		keeper_monster = true,
		normal_monster = true
	}
	
	if arg_15_0.db.after_kill then
		local var_15_1, var_15_2 = DB(arg_15_0.object_db_name, arg_15_0.db.after_kill, {
			"type_1",
			"type_2"
		})
		
		return var_15_0[var_15_2]
	end
	
	return false
end

function HTBObjectData.getClanObjectUseCount(arg_16_0)
	return arg_16_0.inst.use_count or 0
end

function HTBObjectData.getMonsterHP(arg_17_0)
	if not arg_17_0:isMonsterType() then
		error("NOT MONSTER BUT TRY ACCESS MONSTER HP")
		
		return 
	end
	
	return (arg_17_0:getMaxUse() or 0) - (arg_17_0.inst.use_count or 0)
end

function HTBObjectData.getMaxUse(arg_18_0)
	return arg_18_0.db.max_use or -9999
end

function HTBObjectData.getLevelID(arg_19_0)
	return arg_19_0.db.level_id
end

function HTBObjectData.getDBId(arg_20_0)
	return arg_20_0.db.id
end

function HTBObjectData.getTileId(arg_21_0)
	return tostring(arg_21_0.inst.tile_id)
end

function HTBObjectData.getCategory(arg_22_0)
	return arg_22_0.db.category
end

function HTBObjectData.getCost(arg_23_0)
	return arg_23_0.db.use_token
end

function HTBObjectData.getSanctuaryTargetRole(arg_24_0)
	return arg_24_0.db.role
end

function HTBObjectData.getType(arg_25_0)
	return arg_25_0.db.type_1
end

function HTBObjectData.getMonsterLevel(arg_26_0)
	return arg_26_0.db.monster_level
end

function HTBObjectData.getTypeDetail(arg_27_0)
	return arg_27_0.db.type_2
end

function HTBObjectData.isModel(arg_28_0)
	return arg_28_0:getObjectOffsetDB().character ~= nil
end

function HTBObjectData.getIconColumn(arg_29_0)
	if arg_29_0:isActive() then
		return "map_icon_before"
	end
	
	return "map_icon_after"
end

function HTBObjectData.getUseToken(arg_30_0)
	return arg_30_0.db.use_token
end

function HTBObjectData.getRewardId(arg_31_0)
	return arg_31_0.db.reward_id
end

function HTBObjectData.getFloatingIdx(arg_32_0)
	return arg_32_0.db.floating_idx
end

function HTBObjectData.getFloatingDirection(arg_33_0)
	return arg_33_0.db.floating_direction or "left"
end

function HTBObjectData.getRewardDummyId(arg_34_0)
	return arg_34_0.db.preview_reward_id
end

function HTBObjectData.getDisplayRewardId(arg_35_0)
	local var_35_0 = arg_35_0.db.preview_reward_id
	
	if var_35_0 then
		return var_35_0
	end
	
	return arg_35_0:getRewardId()
end

function HTBObjectData.getRewardTitle(arg_36_0)
	return arg_36_0.db.reward_title
end

function HTBObjectData.getRewardDesc(arg_37_0)
	return arg_37_0.db.reward_desc
end

function HTBObjectData.debug_updateOffsetDB(arg_38_0, arg_38_1, arg_38_2, arg_38_3, arg_38_4)
	local var_38_0 = arg_38_0:getObjectOffsetDB()
	
	if var_38_0.id == arg_38_1 then
		var_38_0.location_x = arg_38_2 or var_38_0.location_x
		var_38_0.location_y = arg_38_3 or var_38_0.location_y
		var_38_0.scale = arg_38_4 or var_38_0.scale
	end
end

function HTBObjectData.debug_updateEffectOffsetDB(arg_39_0, arg_39_1, arg_39_2, arg_39_3, arg_39_4, arg_39_5)
	local var_39_0 = arg_39_0:getObjectOffsetDB()
	
	if var_39_0.id == arg_39_1 then
		if arg_39_2 then
			var_39_0.effect = arg_39_2
		end
		
		print("id, effect, x, y, scale", arg_39_1, arg_39_2, arg_39_3, arg_39_4, arg_39_5)
		
		local var_39_1 = var_39_0.eff_location
		local var_39_2 = string.split(var_39_1, ",")
		
		arg_39_3 = arg_39_3 or to_n(var_39_2[1])
		arg_39_4 = arg_39_4 or to_n(var_39_2[2])
		var_39_0.eff_location = tostring(arg_39_3) .. "," .. tostring(arg_39_4)
		var_39_0.eff_scale = arg_39_5 or var_39_0.eff_scale
	end
end

function HTBObjectData.getOffsetDBKey(arg_40_0)
	local var_40_0 = arg_40_0:getIconColumn()
	
	return DB(arg_40_0.object_db_name, arg_40_0.db.id, var_40_0) or ""
end

function HTBObjectData.getSpritePath(arg_41_0)
	local var_41_0 = arg_41_0:getObjectOffsetDB()
	
	if arg_41_0:isModel() then
		return var_41_0.character
	end
	
	if var_41_0.map_icon == nil then
		return "img/cm_icon_clan_war1.png"
	end
	
	return "tile/" .. var_41_0.map_icon .. ".png"
end

function HTBObjectData.getObjectOffsetDB(arg_42_0)
	local var_42_0 = arg_42_0.before_offset_db
	
	if not arg_42_0:isActive() then
		var_42_0 = arg_42_0.after_offset_db
	end
	
	return var_42_0
end

function HTBObjectData.getAdjustFocusYPos(arg_43_0)
	return arg_43_0:getObjectOffsetDB().adj_focus_y_pos or 0
end

function HTBObjectData.getPositionXOffset(arg_44_0)
	return arg_44_0:getObjectOffsetDB().location_x
end

function HTBObjectData.getHPBarPositionXOffset(arg_45_0)
	local var_45_0 = arg_45_0:getObjectOffsetDB().hp_offset
	
	if not var_45_0 then
		return 0
	end
	
	local var_45_1 = string.split(var_45_0, ",")
	
	return to_n(var_45_1[1])
end

function HTBObjectData.getHPBarPositionYOffset(arg_46_0)
	local var_46_0 = arg_46_0:getObjectOffsetDB().hp_offset
	
	if not var_46_0 then
		return 0
	end
	
	local var_46_1 = string.split(var_46_0, ",")
	
	return to_n(var_46_1[2])
end

function HTBObjectData.isExistEffect(arg_47_0)
	return arg_47_0:getObjectOffsetDB().effect ~= nil
end

function HTBObjectData.getEffect(arg_48_0)
	return arg_48_0:getObjectOffsetDB().effect
end

function HTBObjectData.getEffectScale(arg_49_0)
	return arg_49_0:getObjectOffsetDB().eff_scale
end

function HTBObjectData.getEffectLocation(arg_50_0)
	local var_50_0 = arg_50_0:getObjectOffsetDB().eff_location
	
	if not var_50_0 then
		return {
			x = 0,
			y = 0
		}
	end
	
	local var_50_1 = string.split(var_50_0, ",")
	
	return {
		x = tonumber(var_50_1[1]),
		y = tonumber(var_50_1[2])
	}
end

function HTBObjectData.getPositionYOffset(arg_51_0)
	return arg_51_0:getObjectOffsetDB().location_y
end

function HTBObjectData.getScaleOffset(arg_52_0)
	return arg_52_0:getObjectOffsetDB().scale
end

function HTBObjectData.isReflect(arg_53_0)
	return arg_53_0:getObjectOffsetDB().reflect
end

function HTBObjectData.isClanObject(arg_54_0)
	return arg_54_0.db.type_1 == "clan"
end

function HTBObjectData.isUsedClanObject(arg_55_0)
	if arg_55_0.db.type_1 ~= "clan" then
		print("!!!!!! ONLY USE ON CLAN !!!!!!")
		
		return 
	end
	
	if arg_55_0:isMonsterType() then
		return false
	end
	
	return arg_55_0.inst.object_info.use_users[tostring(AccountData.id)] == true
end

function HTBObjectData.onDetail(arg_56_0)
end

function HTBObjectData.onUse(arg_57_0)
end

function HTBObjectData.onResponse(arg_58_0, arg_58_1)
end

function HTBObjectData.onExpire(arg_59_0)
end

function HTBObjectData.onCancel(arg_60_0)
end

function HTBObjectData.updateInfo(arg_61_0, arg_61_1)
	arg_61_0.inst = table.clone(arg_61_1)
end

function HTBObjectData.isExistEvent(arg_62_0)
	return arg_62_0.inst.object_info.event ~= nil and not table.empty(arg_62_0.inst.object_info.event)
end

function HTBObjectData.isUsableEvent(arg_63_0)
	return arg_63_0:isExistEvent() and not arg_63_0.inst.object_info.event.complete
end

function HTBObjectData.getEventId(arg_64_0)
	if not arg_64_0:isExistEvent() then
		return 
	end
	
	return arg_64_0.inst.object_info.event.event_id
end

function HTBObjectData.updateUseCount(arg_65_0, arg_65_1)
	arg_65_0.inst.use_count = arg_65_1
end

function HTBObjectData.updateDead(arg_66_0, arg_66_1)
	arg_66_0.inst.dead = arg_66_1
end
