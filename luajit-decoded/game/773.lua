SPLBGRenderer = {}

copy_functions(HTBBGRenderer, SPLBGRenderer)

function SPLBGRenderer.init(arg_1_0, arg_1_1)
	arg_1_0:base_init("tile_sub", SPLSystem:getCurrentMapId(), arg_1_1)
end

function SPLBGRenderer.syncPosition(arg_2_0)
	arg_2_0:base_syncPosition(SPLInterfaceImpl.getMoveRatio)
end

function SPLBGRenderer.changeBackground(arg_3_0, arg_3_1)
end
