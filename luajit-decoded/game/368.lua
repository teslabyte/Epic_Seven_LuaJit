UnitEquipUtil = {}

function UnitEquipUtil.getEquipDetail(arg_1_0, arg_1_1)
	return ItemTooltip:getItemDetail({
		equip = arg_1_1
	})
end

function UnitEquipUtil.getSubStat(arg_2_0, arg_2_1)
	local var_2_0 = {}
	local var_2_1 = {}
	local var_2_2 = 0
	
	for iter_2_0 = 2, 99 do
		if arg_2_1.equip_stat[iter_2_0] then
			local var_2_3 = arg_2_1.equip_stat[iter_2_0][1]
			local var_2_4 = arg_2_1.equip_stat[iter_2_0][2]
			
			if not var_2_1[var_2_3] then
				var_2_2 = var_2_2 + 1
				var_2_1[var_2_3] = var_2_2
			end
			
			if type(var_2_4) == "table" then
				var_2_0[var_2_3] = var_2_4
			else
				var_2_0[var_2_3] = (var_2_0[var_2_3] or 0) + var_2_4
			end
		end
	end
	
	return var_2_0, var_2_1
end

function UnitEquipUtil.getSubStatUpgradeCount(arg_3_0, arg_3_1)
	local var_3_0 = {}
	
	for iter_3_0 = 2, 99 do
		if not arg_3_1.equip_stat[iter_3_0] then
			break
		end
		
		if not arg_3_1.equip_stat[iter_3_0][3] then
			local var_3_1 = arg_3_1.equip_stat[iter_3_0][1]
			
			if not var_3_0[var_3_1] then
				var_3_0[var_3_1] = 0
			end
			
			var_3_0[var_3_1] = var_3_0[var_3_1] + 1
		end
	end
	
	return var_3_0
end

function UnitEquipUtil.parsingSubStatChangeMaType2(arg_4_0, arg_4_1)
	local var_4_0 = string.split(arg_4_1, ";")
	
	if table.count(var_4_0) ~= 2 then
		return 
	end
	
	return var_4_0
end

function UnitEquipUtil.getSubStatChangeMaterialInfo(arg_5_0, arg_5_1)
	return DB("item_material", arg_5_1, "ma_type2")
end

function UnitEquipUtil.reCalcUnitStatByEquipEnhance(arg_6_0, arg_6_1)
	if arg_6_1.parent then
		Account:getUnit(arg_6_1.parent):calc()
	end
end

function UnitEquipUtil.getOptionsSumTable(arg_7_0, arg_7_1)
	local var_7_0 = {}
	local var_7_1 = {}
	local var_7_2 = 1
	
	for iter_7_0 = 2, table.count(arg_7_1.op) do
		local var_7_3 = arg_7_1.op[iter_7_0]
		
		if not var_7_3 then
			return 
		end
		
		local var_7_4 = var_7_3[1]
		local var_7_5 = var_7_3[2]
		
		if not var_7_1[var_7_4] then
			var_7_1[var_7_4] = var_7_2
			var_7_0[var_7_2] = {}
			var_7_0[var_7_2][1] = var_7_4
			var_7_0[var_7_2][2] = 0
			var_7_2 = var_7_2 + 1
		end
		
		local var_7_6 = var_7_1[var_7_4]
		
		var_7_0[var_7_6][2] = var_7_0[var_7_6][2] + var_7_5
	end
	
	return var_7_0
end

function UnitEquipUtil.findDiffOption(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = 0
	
	for iter_8_0 = 1, table.count(arg_8_2) do
		if arg_8_2[iter_8_0] and arg_8_2[iter_8_0][1] ~= arg_8_1[iter_8_0][1] then
			var_8_0 = iter_8_0
			
			break
		end
		
		if arg_8_2[iter_8_0] and arg_8_2[iter_8_0][2] ~= arg_8_1[iter_8_0][2] then
			var_8_0 = iter_8_0
			
			break
		end
	end
	
	if var_8_0 == 0 then
		return 
	end
	
	return var_8_0
end

function UnitEquipUtil.getUpgradeTagValue(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = 0
	
	for iter_9_0 = 2, table.count(arg_9_1.op) do
		local var_9_1 = arg_9_1.op[iter_9_0]
		
		if not var_9_1 then
			break
		end
		
		if var_9_1[3] == "u" and var_9_1[1] == arg_9_2 then
			var_9_0 = var_9_0 + var_9_1[2]
		end
	end
	
	return var_9_0
end

function UnitEquipUtil.findUpgradeOption(arg_10_0, arg_10_1)
	for iter_10_0 = 1, 9999 do
		local var_10_0, var_10_1, var_10_2 = DBN("item_equip_upgrade", iter_10_0, {
			"id",
			"item_equip_result",
			"option"
		})
		
		if not var_10_0 then
			break
		end
		
		if arg_10_1 == var_10_1 then
			return var_10_2
		end
	end
end

function UnitEquipUtil.getEquipUpgradeStatTable(arg_11_0, arg_11_1)
	local var_11_0 = {}
	
	for iter_11_0 = 1, 999 do
		local var_11_1, var_11_2 = DB("item_equip_upgrade_stat", arg_11_1 .. "_" .. iter_11_0, {
			"option",
			"value"
		})
		
		if not var_11_1 or not var_11_2 then
			break
		end
		
		var_11_0[var_11_1] = var_11_2
	end
	
	return var_11_0
end

function UnitEquipUtil.is_percentage_stat(arg_12_0, arg_12_1)
	if arg_12_1 == "con" or arg_12_1 == "dodge" or arg_12_1 == "cri" or arg_12_1 == "res" or arg_12_1 == "cri_dmg" or arg_12_1 == "pen" or arg_12_1 == "res_stun" or arg_12_1 == "acc" then
		return true
	end
	
	if arg_12_1 and string.len(arg_12_1) > 5 and string.find(arg_12_1, "_rate") then
		return true
	end
	
	return false
end

function UnitEquipUtil.get_normalize_value(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	arg_13_3 = arg_13_3 or false
	
	local var_13_0 = 0
	
	if arg_13_0:is_percentage_stat(arg_13_1) then
		var_13_0 = math.max(0.01, round(arg_13_2, 2))
	elseif arg_13_3 then
		var_13_0 = math.floor(arg_13_2)
	else
		var_13_0 = math.max(1, math.floor(arg_13_2))
	end
	
	return var_13_0
end

UnitEquipFilterUtil = {}

function UnitEquipFilterUtil.updateAllSelectButton(arg_14_0, arg_14_1)
	local var_14_0 = false
	
	for iter_14_0, iter_14_1 in pairs(arg_14_1) do
		if iter_14_0 ~= 1 and iter_14_1 then
			var_14_0 = true
			
			break
		end
	end
	
	arg_14_1[1] = not var_14_0
end

function UnitEquipFilterUtil.clear(arg_15_0, arg_15_1)
	for iter_15_0, iter_15_1 in pairs(arg_15_1) do
		arg_15_1[iter_15_0] = false
	end
	
	arg_15_1[1] = true
end

function UnitEquipFilterUtil.copyOnAllButton(arg_16_0, arg_16_1)
	local var_16_0 = {}
	
	for iter_16_0, iter_16_1 in pairs(arg_16_1) do
		var_16_0[iter_16_1] = true
	end
	
	return var_16_0
end

function UnitEquipFilterUtil.getUsableFilter(arg_17_0)
	local var_17_0 = {}
	
	for iter_17_0, iter_17_1 in pairs(arg_17_0.vars.selected_list) do
		if iter_17_0 == 1 and iter_17_1 then
			var_17_0 = arg_17_0:copyAll()
			
			break
		end
		
		if iter_17_0 ~= 1 and iter_17_1 then
			var_17_0[arg_17_0.vars.set_item_list[iter_17_0]] = true
		end
	end
	
	return var_17_0
end

function UnitEquipFilterUtil.getSortIndex(arg_18_0, arg_18_1)
	local var_18_0, var_18_1 = string.find(arg_18_1, "%d+")
	
	if not var_18_0 then
		Log.e("BTN SORT, BUT NOT HAVE NUMBER")
		
		return 
	end
	
	return tonumber(string.sub(arg_18_1, var_18_0, var_18_1))
end

function UnitEquipFilterUtil.setCursor(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
	if not arg_19_2 then
		Log.e("REQ INDEX")
	end
	
	if_set_visible(arg_19_1, "cursor", arg_19_3)
	
	local var_19_0 = "checkbox_set_"
	local var_19_1 = arg_19_1:findChildByName(var_19_0 .. arg_19_2)
	
	if var_19_1 then
		var_19_1:setSelected(arg_19_3)
	end
end

function UnitEquipFilterUtil.updateListUI(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	for iter_20_0 = 1, arg_20_1 do
		local var_20_0 = arg_20_3:findChildByName("btn_sort" .. iter_20_0)
		
		if not get_cocos_refid(var_20_0) then
			return 
		end
		
		arg_20_0:setCursor(var_20_0, iter_20_0, arg_20_2[iter_20_0])
	end
end

function UnitEquipFilterUtil.getUsableFilter(arg_21_0, arg_21_1, arg_21_2)
	local var_21_0 = {}
	
	for iter_21_0, iter_21_1 in pairs(arg_21_1) do
		if iter_21_0 == 1 and iter_21_1 then
			var_21_0 = arg_21_0:copyOnAllButton(arg_21_2)
			
			break
		end
		
		if iter_21_0 ~= 1 and iter_21_1 then
			var_21_0[arg_21_2[iter_21_0]] = true
		end
	end
	
	return var_21_0
end

function UnitEquipFilterUtil.getFilterList(arg_22_0, arg_22_1, arg_22_2)
	local var_22_0 = {}
	local var_22_1 = false
	
	for iter_22_0, iter_22_1 in pairs(arg_22_1) do
		if iter_22_0 == 1 and iter_22_1 then
			var_22_1 = true
		elseif iter_22_0 ~= 1 and iter_22_1 then
			table.insert(var_22_0, arg_22_2[iter_22_0])
		end
	end
	
	return var_22_0, var_22_1
end
