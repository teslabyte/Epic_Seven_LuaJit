SPLObjectData = ClassDef(HTBObjectData)
SPLObjectHandler = {
	DETAIL = {
		default = function(arg_1_0)
		end
	},
	USE = {
		overlap = function(arg_2_0)
		end,
		monster = function(arg_3_0)
			local function var_3_0()
				SPLSystem:startBattle(arg_3_0:getDBId(), arg_3_0:getLevelID())
			end
			
			if arg_3_0:getMainEventKey() then
				var_3_0()
			else
				SPLEventSystem:pause()
				UIAction:Add(SEQ(CALL(function()
					local var_5_0 = SPLTileMapSystem:getTileById(arg_3_0:getUID())
					
					SPLCameraSystem:tweenCameraToTile(var_5_0)
				end), DELAY(500), CALL(function()
					SPLObjectRenderer:showEncounterEffect(arg_3_0:getUID())
				end), DELAY(1000), CALL(function()
					var_3_0()
				end)), arg_3_0, "block")
			end
		end,
		default = function(arg_8_0)
			SPLUserData:queryObject(arg_8_0:getDBId())
		end
	},
	RESPONSE = {
		warp = function(arg_9_0, arg_9_1)
			SPLSystem:warp()
		end,
		preset_change = function(arg_10_0, arg_10_1)
			SPLMovableSystem:setPlayerPreset(SPLUserData:getPresetID())
		end
	},
	EXPIRE = {
		empty = function(arg_11_0)
			local var_11_0 = arg_11_0:getUID()
			local var_11_1 = arg_11_0:getNextObject()
			
			if var_11_1 then
				SPLObjectSystem:removeObject(var_11_0)
				SPLObjectSystem:createObject(var_11_1, var_11_0)
			else
				SPLObjectSystem:removeObject(var_11_0)
			end
		end,
		default = function(arg_12_0)
			local var_12_0 = arg_12_0:getUID()
			local var_12_1 = arg_12_0:getNextObject()
			
			if var_12_1 then
				SPLObjectSystem:removeObject(var_12_0)
				SPLObjectSystem:createObject(var_12_1, var_12_0)
			elseif not arg_12_0:isExistAfterIcon() then
				SPLObjectSystem:removeObject(var_12_0)
			else
				SPLObjectRenderer:requestExpire(var_12_0)
			end
		end
	}
}
SPLObjectHandler.NEAR = SPLObjectHandler.USE
SPLObjectHandler.CREATE = SPLObjectHandler.USE

function SPLObjectData.constructor(arg_13_0, arg_13_1)
	arg_13_0:base_constructor(arg_13_1, "tile_sub_object_data", "tile_sub_object_icon")
	arg_13_0:initEventList()
end

function SPLObjectData.bindObjectDB(arg_14_0)
	arg_14_0.db = DBT(arg_14_0.object_db_name, arg_14_0.db_key, {
		"id",
		"name",
		"desc",
		"map_icon_before",
		"map_icon_after",
		"add_trans",
		"main_event",
		"sub_event",
		"eyesight",
		"grade",
		"near_range",
		"max_use",
		"type",
		"sub_type",
		"level_id",
		"btn_text",
		"btn_icon",
		"next_object",
		"link_object"
	}) or {}
end

local function var_0_0(arg_15_0, arg_15_1)
	return DBT(arg_15_1, arg_15_0, {
		"id",
		"map_icon",
		"character",
		"scale",
		"location_x",
		"location_y",
		"reflect",
		"effect",
		"eff_scale",
		"eff_location",
		"adj_focus_y_pos",
		"icon_y_pos"
	}) or {}
end

function SPLObjectData.bindIconDB(arg_16_0)
	arg_16_0.after_offset_db = var_0_0(arg_16_0.db.map_icon_after, arg_16_0.object_icon_db_name)
	arg_16_0.before_offset_db = var_0_0(arg_16_0.db.map_icon_before, arg_16_0.object_icon_db_name)
end

function SPLObjectData.getType(arg_17_0)
	return arg_17_0.db.type
end

function SPLObjectData.getTypeDetail(arg_18_0)
	return arg_18_0.db.type
end

function SPLObjectData.isMonsterType(arg_19_0)
	return arg_19_0:getType() == "monster"
end

function SPLObjectData.isExistAfterObject(arg_20_0)
	return arg_20_0.db.next_object ~= nil
end

function SPLObjectData.updateObjectInfo(arg_21_0, arg_21_1)
	arg_21_0:base_updateObjectInfo(SPLInterfaceImpl.createChildIdListToObjectInfo, arg_21_1)
end

function SPLObjectData.getMinimapIconMiddlePosition(arg_22_0)
	return arg_22_0:base_getMinimapIconMiddlePosition(SPLInterfaceImpl.getTileById)
end

function SPLObjectData.initEventList(arg_23_0)
	local var_23_0 = {}
	
	if arg_23_0.db.sub_event then
		var_23_0 = string.split(arg_23_0.db.sub_event, ",") or {}
	end
	
	arg_23_0.inst.event_list = {}
	
	for iter_23_0, iter_23_1 in pairs(var_23_0) do
		local var_23_1 = SPLEventData(arg_23_0, iter_23_1)
		
		arg_23_0:registEvent(var_23_1)
	end
	
	if arg_23_0.db.main_event then
		local var_23_2 = SPLEventData(arg_23_0, arg_23_0.db.main_event)
		
		arg_23_0:registEvent(var_23_2)
	end
end

function SPLObjectData.registEvent(arg_24_0, arg_24_1)
	if not arg_24_0.inst then
		return 
	end
	
	local var_24_0 = arg_24_1:getTrigger()
	
	if var_24_0 then
		local var_24_1 = SPLEventType[var_24_0]
		
		if not SPLEventType[var_24_0] then
			Log.e("유효하지 않은 trigger입니다.", var_24_0)
			
			return 
		end
		
		if var_24_1 == SPLEventType.NEAR and not arg_24_0:getNearRange() then
			Log.e("near_range가 존재하지 않습니다.", arg_24_0.db.id)
			
			return 
		end
		
		if not arg_24_0.inst.event_list[var_24_1] then
			arg_24_0.inst.event_list[var_24_1] = {}
		end
		
		table.insert(arg_24_0.inst.event_list[var_24_1], arg_24_1)
	end
end

function SPLObjectData.getMainEventKey(arg_25_0)
	if not arg_25_0.db then
		return 
	end
	
	return arg_25_0.db.main_event
end

function SPLObjectData.getName(arg_26_0)
	if not arg_26_0.db then
		return 
	end
	
	return arg_26_0.db.name
end

function SPLObjectData.getKey(arg_27_0)
	return arg_27_0.db_key
end

function SPLObjectData.getNearRange(arg_28_0)
	if not arg_28_0.db then
		return 
	end
	
	return arg_28_0.db.near_range
end

function SPLObjectData.getLinkId(arg_29_0)
	if not arg_29_0.db then
		return 
	end
	
	return arg_29_0.db.link_object
end

function SPLObjectData.getNextObject(arg_30_0)
	if not arg_30_0.db then
		return 
	end
	
	return arg_30_0.db.next_object
end

function SPLObjectData.isExistAfterIcon(arg_31_0)
	if not arg_31_0.db then
		return 
	end
	
	return arg_31_0.db.map_icon_after ~= nil
end

function SPLObjectData.getButtonText(arg_32_0)
	if not arg_32_0.db then
		return 
	end
	
	return arg_32_0.db.btn_text
end

function SPLObjectData.getButtonIcon(arg_33_0)
	if not arg_33_0.db then
		return 
	end
	
	return arg_33_0.db.btn_icon
end

function SPLObjectData.getObjectOffsetDB(arg_34_0)
	local var_34_0 = arg_34_0.before_offset_db
	
	if not arg_34_0:isActive() then
		var_34_0 = arg_34_0.after_offset_db
	end
	
	if arg_34_0.force_offset_db then
		var_34_0 = arg_34_0.force_offset_db
	end
	
	return var_34_0
end

function SPLObjectData.setObjectOffsetDB(arg_35_0, arg_35_1)
	if not arg_35_1 then
		return 
	end
	
	arg_35_0.force_offset_db = var_0_0(arg_35_1, arg_35_0.object_icon_db_name)
end

function SPLObjectData.getIconYPos(arg_36_0)
	return arg_36_0:getObjectOffsetDB().icon_y_pos or 0
end

function SPLObjectData.getSpritePath(arg_37_0)
	local var_37_0 = arg_37_0:getObjectOffsetDB()
	
	if arg_37_0:isModel() then
		return var_37_0.character
	end
	
	if var_37_0.map_icon == nil then
		return 
	end
	
	return "tile/" .. var_37_0.map_icon .. ".png"
end

function SPLObjectData.getMiddlePosition(arg_38_0)
	if table.empty(arg_38_0:getChildTileList()) then
		return 0, 0
	end
	
	local var_38_0 = SPLTileMapSystem:getTileById(arg_38_0:getUID())
	local var_38_1 = 0
	local var_38_2 = 0
	local var_38_3 = 0
	local var_38_4 = 0
	
	for iter_38_0, iter_38_1 in pairs(arg_38_0:getChildTileList()) do
		local var_38_5 = SPLTileMapSystem:getTileById(iter_38_1)
		local var_38_6 = HTUtil:getDecedPosition(var_38_5:getPos(), var_38_0:getPos())
		
		var_38_1 = math.min(var_38_6.x, var_38_1)
		var_38_2 = math.max(var_38_6.x, var_38_2)
		var_38_3 = math.min(var_38_6.y, var_38_3)
		var_38_4 = math.max(var_38_6.y, var_38_4)
	end
	
	local var_38_7 = var_38_1 + (var_38_2 - var_38_1) / 2
	local var_38_8 = var_38_3 + (var_38_4 - var_38_3) / 2
	
	return var_38_7, var_38_8
end

function SPLObjectData.getTransTileList(arg_39_0)
	return arg_39_0.inst.trans_id
end

function SPLObjectData.getSubType(arg_40_0)
	if not arg_40_0.db then
		return 
	end
	
	return totable(arg_40_0.db.sub_type, "=", ",")
end

local function var_0_1(arg_41_0)
	if arg_41_0 then
		for iter_41_0, iter_41_1 in pairs(arg_41_0) do
			SPLEventSystem:enqueueEvent(iter_41_1)
		end
	end
end

function SPLObjectData.onUse(arg_42_0)
	local var_42_0 = arg_42_0.inst.event_list[SPLEventType.USE]
	
	if var_42_0 then
		var_0_1(var_42_0)
	else
		local var_42_1 = SPLObjectHandler.USE[arg_42_0:getType()] or SPLObjectHandler.USE.default
		
		if type(var_42_1) == "function" then
			var_42_1(arg_42_0)
		end
	end
end

function SPLObjectData.onNear(arg_43_0)
	if not arg_43_0:getNearRange() then
		return 
	end
	
	if not SPLEventSystem:checkNear(arg_43_0) then
		return 
	end
	
	local var_43_0 = arg_43_0.inst.event_list[SPLEventType.NEAR]
	
	if var_43_0 then
		var_0_1(var_43_0)
	elseif arg_43_0:isMonsterType() then
		local var_43_1 = SPLObjectHandler.NEAR[arg_43_0:getType()] or SPLObjectHandler.NEAR.default
		
		if type(var_43_1) == "function" then
			var_43_1(arg_43_0)
		end
	end
end

function SPLObjectData.onCreate(arg_44_0)
	if not arg_44_0.inst.event_list[SPLEventType.CREATE] then
		return 
	end
	
	var_0_1(arg_44_0.inst.event_list[SPLEventType.CREATE])
end

function SPLObjectData.onResponse(arg_45_0, arg_45_1)
	arg_45_0:updateUseCount(arg_45_1.use_count)
	
	local var_45_0 = arg_45_0:getSubType() or {}
	
	for iter_45_0, iter_45_1 in pairs(var_45_0) do
		local var_45_1 = SPLObjectHandler.RESPONSE[iter_45_0]
		
		if type(var_45_1) == "function" then
			var_45_1(arg_45_0, arg_45_1)
		end
	end
end

function SPLObjectData.onExpire(arg_46_0)
	local var_46_0 = SPLObjectHandler.EXPIRE[arg_46_0:getType()] or SPLObjectHandler.EXPIRE.default
	
	if type(var_46_0) == "function" then
		var_46_0(arg_46_0)
	end
end
