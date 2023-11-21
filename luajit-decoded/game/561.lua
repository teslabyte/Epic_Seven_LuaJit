Inventory.Wearing = {}

function Inventory.Wearing.onEnter(arg_1_0)
end

function Inventory.Wearing.onLeave(arg_2_0)
end

function Inventory.Wearing.selectItems(arg_3_0)
	local function var_3_0(arg_4_0, arg_4_1)
		local var_4_0 = arg_4_0:getGrade()
		
		if not arg_4_1.star[var_4_0] then
			return false
		end
		
		local var_4_1 = arg_4_0:getColor()
		
		if not arg_4_1.element[var_4_1] then
			return false
		end
		
		return true
	end
	
	local var_3_1 = {}
	local var_3_2 = {}
	
	for iter_3_0, iter_3_1 in pairs(Account.equips) do
		if iter_3_1.parent then
			local var_3_3 = Account:getUnit(iter_3_1.parent)
			
			if var_3_3 then
				var_3_1[var_3_3] = true
			end
		end
	end
	
	for iter_3_2, iter_3_3 in pairs(Account:getPublicReservedTeamSlot()) do
		local var_3_4 = AccountData.teams[iter_3_3]
		
		if type(var_3_4) == "table" then
			for iter_3_4 = 1, 6 do
				if var_3_4[iter_3_4] and (not var_3_4[iter_3_4]:isSummon() or not var_3_4[iter_3_4]:isSpecialUnit()) then
					var_3_1[var_3_4[iter_3_4]] = true
				end
			end
		end
	end
	
	for iter_3_5, iter_3_6 in pairs(var_3_1) do
		if not iter_3_5:isSummon() and (arg_3_0.tab == 0 or arg_3_0:isCorrectTab(iter_3_5.db.role)) and var_3_0(iter_3_5, Inventory.vars.filters) and arg_3_0:checkAllEquipped(iter_3_5) and arg_3_0:checkMaxLevel(iter_3_5) then
			table.push(var_3_2, iter_3_5)
		end
	end
	
	table.sort(var_3_2, function(arg_5_0, arg_5_1)
		local var_5_0 = #arg_5_0.equips
		local var_5_1 = #arg_5_1.equips
		
		if var_5_0 == var_5_1 then
			return arg_5_0.inst.exp > arg_5_1.inst.exp
		end
		
		return var_5_1 < var_5_0
	end)
	
	return var_3_2
end

function Inventory.Wearing.checkAllEquipped(arg_6_0, arg_6_1)
	if not Inventory:getHideAllEquippedItemUnit() then
		return true
	end
	
	if not arg_6_1.equips then
		local var_6_0 = {}
	end
	
	local var_6_1 = table.count(arg_6_1.equips)
	local var_6_2 = 7
	
	if arg_6_1:isExclusiveEquip_exist() and arg_6_1:canEquip_Exclusive() then
		var_6_2 = 8
	end
	
	return var_6_1 < var_6_2
end

function Inventory.Wearing.checkMaxLevel(arg_7_0, arg_7_1)
	if not Inventory:getHideMaxLevelUnits() then
		return true
	end
	
	return arg_7_1:getLv() ~= arg_7_1:getMaxLevel()
end

function Inventory.Wearing.selectSubTab(arg_8_0, arg_8_1)
	arg_8_0.tab = arg_8_1
end

function Inventory.Wearing.isCorrectTab(arg_9_0, arg_9_1)
	local var_9_0 = {
		manauser = 6,
		knight = 2,
		material = 7,
		assassin = 3,
		warrior = 1,
		ranger = 4,
		mage = 5
	}
	
	return arg_9_0.tab == var_9_0[arg_9_1]
end
