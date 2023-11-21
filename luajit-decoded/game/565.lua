Inventory.Exclusive_Equip = {}

function Inventory.Exclusive_Equip.onEnter(arg_1_0)
end

function Inventory.Exclusive_Equip.onLeave(arg_2_0)
	arg_2_0:setCurrentMaxUid()
end

function Inventory.Exclusive_Equip.setCurrentMaxUid(arg_3_0, arg_3_1)
	if Inventory.equipMaxUids == nil then
		Inventory:checkLastInventoryEnter()
	end
	
	if arg_3_1 ~= nil then
		local var_3_0 = -1
		
		for iter_3_0, iter_3_1 in pairs(Account.equips) do
			if not iter_3_1:isArtifact() and (arg_3_1 == 0 or arg_3_0:isCorrectTab(iter_3_1.db.type) or iter_3_1:isCompatibleCategoryStone(arg_3_0:getCurrentCategoryName())) then
				var_3_0 = math.max(var_3_0, iter_3_1:getUID())
			end
		end
		
		if arg_3_1 == 0 then
			for iter_3_2 = 0, 6 do
				Inventory.equipMaxUids[iter_3_2] = var_3_0
			end
		else
			Inventory.equipMaxUids[arg_3_1] = var_3_0
			Inventory.equipMaxUids[0] = var_3_0 > Inventory.equipMaxUids[0] and var_3_0 or Inventory.equipMaxUids[0]
		end
	end
end

function Inventory.Exclusive_Equip.selectSubTab(arg_4_0, arg_4_1)
	if arg_4_0.tab ~= arg_4_1 then
		arg_4_0:setCurrentMaxUid(arg_4_0.tab)
	end
	
	arg_4_0.tab = arg_4_1
end

function Inventory.Exclusive_Equip.isCorrectTab(arg_5_0, arg_5_1)
	local var_5_0 = {
		manauser = 5,
		knight = 1,
		assassin = 4,
		warrior = 2,
		ranger = 3,
		mage = 6
	}
	
	return arg_5_0.tab == var_5_0[arg_5_1]
end

function Inventory.Exclusive_Equip.getCurrentCategoryName(arg_6_0)
	return ({
		"knight",
		"warrior",
		"assassin",
		"ranger",
		"mage",
		"manauser"
	})[arg_6_0.tab]
end

function Inventory.Exclusive_Equip.selectItems(arg_7_0)
	local var_7_0 = {}
	
	for iter_7_0, iter_7_1 in pairs(Account.equips) do
		if not iter_7_1:isArtifact() and not iter_7_1:isStone() and iter_7_1:isExclusive() and (arg_7_0.tab == 0 or arg_7_0:isCorrectTab(iter_7_1.db.role)) then
			table.push(var_7_0, iter_7_1)
		end
	end
	
	return var_7_0
end
