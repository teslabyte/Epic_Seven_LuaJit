Inventory.Equip = {}

function Inventory.Equip.onEnter(arg_1_0, arg_1_1)
end

function Inventory.Equip.onLeave(arg_2_0)
end

function Inventory.Equip.isCorrectTab(arg_3_0, arg_3_1)
	local var_3_0 = {
		weapon = 1,
		armor = 4,
		ring = 6,
		boot = 5,
		helm = 2,
		neck = 3
	}
	
	return arg_3_0.tab == var_3_0[arg_3_1]
end

function Inventory.Equip.isCorrectEquipMaterialTab(arg_4_0, arg_4_1)
	local var_4_0 = ({
		"weapon",
		"helm",
		"neck",
		"armor",
		"boot",
		"ring"
	})[arg_4_0.tab] or ""
	
	return string.find(arg_4_1, var_4_0)
end

function Inventory.Equip.getCurrentCategoryName(arg_5_0)
	return ({
		"weapon",
		"helm",
		"neck",
		"armor",
		"boot",
		"ring"
	})[arg_5_0.tab]
end

function Inventory.Equip.setCurrentMaxUid(arg_6_0, arg_6_1)
	if Inventory.equipMaxUids == nil then
		Inventory:checkLastInventoryEnter()
	end
	
	if arg_6_1 ~= nil then
		local var_6_0 = -1
		
		for iter_6_0, iter_6_1 in pairs(Account.equips) do
			if not iter_6_1:isArtifact() and (arg_6_1 == 0 or arg_6_0:isCorrectTab(iter_6_1.db.type) or iter_6_1:isCompatibleCategoryStone(arg_6_0:getCurrentCategoryName())) then
				var_6_0 = math.max(var_6_0, iter_6_1:getUID())
			end
		end
		
		if arg_6_1 == 0 then
			for iter_6_2 = 0, 6 do
				Inventory.equipMaxUids[iter_6_2] = var_6_0
			end
		else
			Inventory.equipMaxUids[arg_6_1] = var_6_0
			Inventory.equipMaxUids[0] = var_6_0 > Inventory.equipMaxUids[0] and var_6_0 or Inventory.equipMaxUids[0]
		end
	end
end

function Inventory.Equip.selectSubTab(arg_7_0, arg_7_1)
	if arg_7_0.tab ~= arg_7_1 then
		arg_7_0:setCurrentMaxUid(arg_7_0.tab)
	end
	
	arg_7_0.tab = arg_7_1
end

function Inventory.Equip.selectItems(arg_8_0)
	local var_8_0 = {}
	
	local function var_8_1(arg_9_0)
		if (arg_8_0.tab == 0 or arg_8_0:isCorrectTab(arg_9_0.db.type) or arg_9_0:isCompatibleCategoryStone(arg_8_0:getCurrentCategoryName())) and (not Inventory:isHideEquippedItems() or not arg_9_0.parent) and (not Inventory:isHideMaxEquipItems() or not arg_9_0:isMaxEnhance()) then
			return true
		end
		
		return false
	end
	
	for iter_8_0, iter_8_1 in pairs(Account.equips) do
		if not iter_8_1:isArtifact() and not iter_8_1:isStone() and not iter_8_1:isExclusive() and var_8_1(iter_8_1) then
			table.push(var_8_0, iter_8_1)
		end
	end
	
	return var_8_0
end
