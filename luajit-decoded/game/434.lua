PetSlot = PetSlot or {}
PET_SLOT = {
	CONTENTS = 3,
	LOBBY = 2,
	STORY = 1
}

function PetSlot.getPetsBySlot(arg_1_0, arg_1_1)
	local var_1_0 = Account:getPetSlots()
	
	if not var_1_0 then
		return 
	end
	
	for iter_1_0, iter_1_1 in pairs(var_1_0) do
		if iter_1_0 == arg_1_1 then
			return Account:getPet(iter_1_1)
		end
	end
end
