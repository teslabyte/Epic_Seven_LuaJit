DockPet = {}

copy_functions(DockFast, DockPet)

function DockPet.create(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = {}
	
	copy_functions(DockPet, var_1_0)
	var_1_0:init(arg_1_1, arg_1_2)
	var_1_0:fastInit()
	
	return var_1_0
end

function DockPet.setPetData(arg_2_0, arg_2_1, arg_2_2)
	for iter_2_0, iter_2_1 in pairs(arg_2_0.controls) do
		iter_2_1:setVisible(false)
		
		iter_2_1.idx = nil
	end
	
	arg_2_0:_setData(arg_2_1, arg_2_2)
end
