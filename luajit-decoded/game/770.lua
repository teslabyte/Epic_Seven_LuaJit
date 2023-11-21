SPLFogRenderer = {}

copy_functions(HTBFogRenderer, SPLFogRenderer)

function SPLFogRenderer.init(arg_1_0, arg_1_1)
	arg_1_0:base_init(SPLInterfaceImpl.whiteboardGet, arg_1_1)
end

function SPLFogRenderer.makeFogSprite(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6)
	return arg_2_0:base_makeFogSprite(SPLInterfaceImpl.whiteboardGet, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6)
end

function SPLFogRenderer.syncPosition(arg_3_0)
	arg_3_0:base_syncPosition(SPLInterfaceImpl.getCameraPos, SPLInterfaceImpl.getZoomPivotPos, SPLInterfaceImpl.getCameraScale)
end

function SPLFogRenderer.renderFogsOnShader(arg_4_0, arg_4_1)
	arg_4_0:base_renderFogsOnShader(SPLInterfaceImpl.onUpdateFogCallback, arg_4_1)
end

function SPLFogRenderer.renderFogs(arg_5_0, arg_5_1)
	arg_5_0:base_renderFogs(SPLInterfaceImpl.getFogDiscoveredList, SPLInterfaceImpl.onUpdateFogCallback, SPLInterfaceImpl.objectCulling, arg_5_1)
end
