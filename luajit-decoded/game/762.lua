SPLMovableManager = ClassDef(HTBMovableManager)

function SPLMovableManager.onSetPos(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	arg_1_0:base_onSetPos(SPLInterfaceImpl.isPlayerMovable, SPLInterfaceImpl.onMovableSetPos, {}, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	SPLFogSystem:discover(arg_1_2.x, arg_1_2.y, arg_1_1:getSightCell())
end

function SPLMovableManager.onCheckPos(arg_2_0, arg_2_1)
	return arg_2_0:base_onCheckPos(SPLInterfaceImpl.onCheckPos, arg_2_1)
end

function SPLMovableManager.addMovable(arg_3_0, arg_3_1)
	return arg_3_0:base_addMovable(SPLInterfaceImpl.createMovableData, arg_3_1)
end
