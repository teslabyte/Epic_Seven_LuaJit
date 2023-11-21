Inventory.Artifact = {}

function Inventory.Artifact.setCurrentMaxUid(arg_1_0)
	if Inventory.equipMaxUids == nil then
		Inventory:checkLastInventoryEnter()
	end
	
	local var_1_0 = -1
	
	for iter_1_0, iter_1_1 in pairs(Account.equips) do
		if iter_1_1:isArtifact() then
			var_1_0 = math.max(var_1_0, iter_1_1:getUID())
		end
	end
	
	Inventory.equipMaxUids.artifact = var_1_0
end

function Inventory.Artifact.onEnter(arg_2_0)
end

function Inventory.Artifact.onLeave(arg_3_0)
	arg_3_0:setCurrentMaxUid()
end

function Inventory.Artifact.selectSubTab(arg_4_0, arg_4_1)
	arg_4_0.tab = arg_4_1
end

function Inventory.Artifact.isCorrectTab(arg_5_0, arg_5_1)
	local var_5_0 = {
		all = 1,
		knight = 2,
		manauser = 7,
		assassin = 4,
		warrior = 3,
		ranger = 5,
		mage = 6
	}
	
	return arg_5_0.tab == var_5_0[arg_5_1]
end

function Inventory.Artifact.selectItems(arg_6_0)
	local var_6_0 = {}
	
	for iter_6_0, iter_6_1 in pairs(Account.equips) do
		local var_6_1 = iter_6_1.db.role or "all"
		
		if iter_6_1:isArtifact() and not iter_6_1:isStone() and (arg_6_0.tab == 0 or arg_6_0:isCorrectTab(var_6_1)) and (not Inventory:ishideArtifactLockItems() or not iter_6_1.lock) and (not Inventory:ishideMaxArtifactItems() or not iter_6_1:isMaxEnhance()) then
			table.push(var_6_0, iter_6_1)
		end
	end
	
	return var_6_0
end
