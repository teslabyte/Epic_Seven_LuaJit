Preset = Preset or {}

function MsgHandler.preset(arg_1_0)
	if arg_1_0.add_units then
		for iter_1_0, iter_1_1 in pairs(arg_1_0.add_units) do
			Account:addUnit(iter_1_1)
		end
	else
		Account:addUnitsByUnitInfos(arg_1_0.units)
		
		Account.equips = {}
		
		for iter_1_2, iter_1_3 in pairs(Account.units) do
			iter_1_3.equips = {}
			
			iter_1_3:calc()
		end
	end
	
	for iter_1_4, iter_1_5 in pairs(arg_1_0.equips or {}) do
		local var_1_0 = Account:getEquip(iter_1_5.id)
		
		if var_1_0 then
			EQUIP:createByInfo(iter_1_5, var_1_0)
		else
			var_1_0 = EQUIP:createByInfo(iter_1_5)
			
			table.insert(Account.equips, var_1_0)
			
			if var_1_0:isArtifact() then
				Account:onAddEquip(var_1_0.code, var_1_0.db.grade)
			end
		end
		
		if var_1_0.parent then
			Account:getUnit(var_1_0.parent):addEquip(var_1_0)
		end
	end
	
	if arg_1_0.max_team then
		AccountData.max_team = arg_1_0.max_team
	end
	
	if arg_1_0.teams then
		for iter_1_6, iter_1_7 in pairs(arg_1_0.teams) do
			AccountData.teams[iter_1_6] = {}
			
			for iter_1_8, iter_1_9 in pairs(iter_1_7) do
				local var_1_1 = Account:getUnit(iter_1_9)
				
				AccountData.teams[iter_1_6][iter_1_8] = var_1_1
				
				var_1_1:addToTeam(iter_1_6, iter_1_8)
			end
		end
	end
	
	if arg_1_0.relations then
		Account:setRelations(arg_1_0.relations)
	end
	
	if arg_1_0.main_unit then
		Account:updateMainUnitId(arg_1_0.main_unit)
	end
	
	local var_1_2 = Preset:getCheat()
	
	Preset:runCheat(var_1_2)
	balloon_message_with_sound(T("preset_success"))
	Preset:clear()
end

function Preset.clear(arg_2_0)
	arg_2_0.cheat = nil
end

function Preset.getCheat(arg_3_0)
	return arg_3_0.cheat
end

function Preset.runCheat(arg_4_0, arg_4_1)
	if arg_4_1 then
		local var_4_0 = string.split(arg_4_1, ";")
		
		if var_4_0 then
			for iter_4_0, iter_4_1 in pairs(var_4_0) do
				local var_4_1 = loadstring(iter_4_1)
				
				if var_4_1 then
					var_4_1()
				end
			end
		end
	end
end

function Preset.set(arg_5_0, arg_5_1)
	local var_5_0 = load_file("../tool/cheat/preset.txt")
	
	if not var_5_0 then
		print("tool/cheat/preset no_file.!")
		
		var_5_0 = load_file("preset/preset.txt")
	end
	
	if not var_5_0 then
		Log.e("preset", "no_file" .. arg_5_1)
	end
	
	local var_5_1 = "return " .. var_5_0
	local var_5_2
	local var_5_3 = {}
	local var_5_4 = {}
	local var_5_5
	local var_5_6, var_5_7 = loadstring(var_5_1)
	
	if var_5_6 then
		var_5_5 = var_5_6()
		
		if var_5_5[tostring(arg_5_1)] then
			var_5_2 = var_5_5[tostring(arg_5_1)]
		end
	elseif var_5_7 then
		table.print(var_5_7)
	end
	
	if not var_5_5 or not var_5_5.unit_info_set then
		Log.e("cheat", "load_datas unit_info_set_null")
		
		return 
	end
	
	if not var_5_2 then
		print("unit_info_set_null")
		
		return 
	end
	
	for iter_5_0, iter_5_1 in pairs(var_5_2.TEAMS or {}) do
		local var_5_8 = {}
		
		for iter_5_2, iter_5_3 in pairs(iter_5_1.units) do
			if var_5_8[iter_5_3.code] then
				Log.e("cheat", "duplication_err_team_unit", iter_5_0)
				
				return 
			end
			
			if iter_5_3.set_id and var_5_5.unit_info_set[iter_5_3.set_id] and not var_5_3[iter_5_3.set_id] then
				var_5_3[iter_5_3.set_id] = var_5_5.unit_info_set[iter_5_3.set_id]
			elseif iter_5_3.set_id and not var_5_3[iter_5_3.set_id] then
				return Log.e("cheat", "set_id_null : " .. iter_5_3.set_id)
			end
			
			for iter_5_4, iter_5_5 in pairs(iter_5_3.equips or {}) do
				if not var_5_5.unit_equip_set[iter_5_5.set_id] then
					Log.e("cheat", "equip_set_id_null : " .. iter_5_5.set_id)
					
					return 
				end
				
				var_5_4[iter_5_5.set_id] = var_5_5.unit_equip_set[iter_5_5.set_id]
			end
			
			var_5_8[iter_5_3.code] = {}
		end
	end
	
	local var_5_9, var_5_10
	
	if var_5_2.COLLECTION_ADD_UNIT or var_5_2.COLLECTION_ADD_ARTI then
		var_5_9 = var_5_2.COLLECTION_ADD_UNIT
		var_5_10 = var_5_2.COLLECTION_ADD_ARTI
		
		for iter_5_6 = 1, 9999 do
			local var_5_11, var_5_12, var_5_13, var_5_14 = DBN("dic_data", iter_5_6, {
				"id",
				"type",
				"type_detail",
				"show"
			})
			
			if not var_5_11 then
				break
			end
			
			if var_5_12 == "character" and var_5_13 == "character" and var_5_14 == "y" and var_5_9 then
				var_5_2.UNITS = nil
				var_5_2.ADD_UNITS = var_5_2.ADD_UNITS or {}
				
				if DB("character", var_5_11, "id") then
					table.insert(var_5_2.ADD_UNITS, {
						code = var_5_11,
						set_id = var_5_9.set_id or "full_chr"
					})
				end
			elseif var_5_12 == "equip" and var_5_13 == "artifact" and var_5_14 == "y" and var_5_10 and DB("equip_item", var_5_11, "id") then
				table.insert(var_5_2.EQUIPS, {
					code = var_5_11,
					set_id = var_5_10.set_id or "full_art",
					count = var_5_10.count or 1
				})
			end
		end
	end
	
	for iter_5_7, iter_5_8 in pairs(var_5_2.UNITS or {}) do
		for iter_5_9, iter_5_10 in pairs(iter_5_8) do
			if iter_5_9 == "set_id" and var_5_5.unit_info_set[iter_5_10] and not var_5_3[iter_5_10] then
				var_5_3[iter_5_10] = var_5_5.unit_info_set[iter_5_10]
			elseif iter_5_9 == "set_id" and not var_5_3[iter_5_10] then
				return Log.e("cheat", "set_id_null : " .. iter_5_10)
			end
			
			for iter_5_11, iter_5_12 in pairs(iter_5_8.equips or {}) do
				if not var_5_5.unit_equip_set[iter_5_12.set_id] then
					Log.e("cheat", "equip_set_id_null : " .. iter_5_12.set_id)
					
					return 
				end
				
				var_5_4[iter_5_12.set_id] = var_5_5.unit_equip_set[iter_5_12.set_id]
			end
		end
	end
	
	for iter_5_13, iter_5_14 in pairs(var_5_2.ADD_UNITS or {}) do
		for iter_5_15, iter_5_16 in pairs(iter_5_14) do
			if iter_5_15 == "set_id" and var_5_5.unit_info_set[iter_5_16] and not var_5_3[iter_5_16] then
				var_5_3[iter_5_16] = var_5_5.unit_info_set[iter_5_16]
			elseif iter_5_15 == "set_id" and not var_5_3[iter_5_16] then
				return Log.e("cheat", "set_id_null : " .. iter_5_16)
			end
			
			for iter_5_17, iter_5_18 in pairs(iter_5_14.equips or {}) do
				if not var_5_5.unit_equip_set[iter_5_18.set_id] then
					Log.e("cheat", "equip_set_id_null : " .. iter_5_18.set_id)
					
					return 
				end
				
				var_5_4[iter_5_18.set_id] = var_5_5.unit_equip_set[iter_5_18.set_id]
			end
		end
	end
	
	for iter_5_19, iter_5_20 in pairs(var_5_2.EQUIPS or {}) do
		if not var_5_5.unit_equip_set[iter_5_20.set_id] then
			Log.e("cheat", "equip_set_id_null : " .. iter_5_20.set_id)
			
			return 
		end
		
		var_5_4[iter_5_20.set_id] = var_5_5.unit_equip_set[iter_5_20.set_id]
	end
	
	if not var_5_2.TEAMS and not var_5_2.UNITS and var_5_2.CHEAT and not var_5_2.ADD_UNITS and var_5_2.CHEAT[1] then
		arg_5_0:runCheat(var_5_2.CHEAT[1])
		
		return 
	end
	
	if not var_5_2.TEAMS and not var_5_2.UNITS and not var_5_2.ADD_UNITS then
		Log.e("cheat", "no_data")
		
		return 
	end
	
	if var_5_2.CHEAT then
		arg_5_0.cheat = var_5_2.CHEAT[1]
		var_5_2.CHEAT = nil
	end
	
	query("preset", {
		preset_data = json.encode(var_5_2),
		set_datas = json.encode(var_5_3),
		equip_set_datas = json.encode(var_5_4)
	})
end
