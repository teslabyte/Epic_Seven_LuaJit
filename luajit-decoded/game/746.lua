HTBInterface = {}

function HTBInterface.getWorldMinMaxPos(arg_1_0, arg_1_1)
	return HTBUtil:callInterface(arg_1_1, "getWorldMinMaxPos", true)
end

function HTBInterface.getPlayerPos(arg_2_0, arg_2_1)
	return HTBUtil:callInterface(arg_2_1, "getPlayerPos", true)
end

function HTBInterface.getTileIdPos(arg_3_0, arg_3_1, arg_3_2)
	return HTBUtil:callInterface(arg_3_1, "getTileIdPos", true, arg_3_2)
end

function HTBInterface.getChildIdList(arg_4_0, arg_4_1, arg_4_2)
	return HTBUtil:callInterface(arg_4_1, "getChildIdList", true, arg_4_2)
end

function HTBInterface.getTileByPos(arg_5_0, arg_5_1, arg_5_2)
	return HTBUtil:callInterface(arg_5_1, "getTileByPos", true, arg_5_2)
end

function HTBInterface.getTileById(arg_6_0, arg_6_1, arg_6_2)
	return HTBUtil:callInterface(arg_6_1, "getTileById", true, arg_6_2)
end

function HTBInterface.getTileIdByPos(arg_7_0, arg_7_1, arg_7_2)
	return HTBUtil:callInterface(arg_7_1, "getTileIdByPos", true, arg_7_2)
end

function HTBInterface.getMovableById(arg_8_0, arg_8_1, arg_8_2)
	return HTBUtil:callInterface(arg_8_1, "getMovableById", true, arg_8_2)
end

function HTBInterface.getMovablesByPos(arg_9_0, arg_9_1, arg_9_2)
	return HTBUtil:callInterface(arg_9_1, "getMovablesByPos", true, arg_9_2)
end

function HTBInterface.getPosById(arg_10_0, arg_10_1, arg_10_2)
	return HTBUtil:callInterface(arg_10_1, "getPosById", true, arg_10_2)
end

function HTBInterface.getPosToHashKey(arg_11_0, arg_11_1, arg_11_2)
	return HTBUtil:callInterface(arg_11_1, "getPosToHashKey", true, arg_11_2)
end

function HTBInterface.getFogVisibility(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	return HTBUtil:callInterface(arg_12_1, "getFogVisibility", true, arg_12_2, arg_12_3)
end

function HTBInterface.getTileSprite(arg_13_0, arg_13_1, arg_13_2)
	return HTBUtil:callInterface(arg_13_1, "getTileSprite", true, arg_13_2)
end

function HTBInterface.getReachableTiles(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
	return HTBUtil:callInterface(arg_14_1, "getReachableTiles", true, arg_14_2, arg_14_3, arg_14_4)
end

function HTBInterface.getObject(arg_15_0, arg_15_1, arg_15_2)
	return HTBUtil:callInterface(arg_15_1, "getObject", true, arg_15_2)
end

function HTBInterface.onCheckPos(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	return HTBUtil:callInterface(arg_16_1, "onCheckPos", true, arg_16_2, arg_16_3)
end

function HTBInterface.calcTilePosToWorldPos(arg_17_0, arg_17_1, arg_17_2)
	return HTBUtil:callInterface(arg_17_1, "calcTilePosToWorldPos", true, arg_17_2)
end

function HTBInterface.calcWorldPosToTilePos(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	return HTBUtil:callInterface(arg_18_1, "calcWorldPosToTilePos", true, arg_18_2, arg_18_3)
end

function HTBInterface.calcWorldPosToCameraPos(arg_19_0, arg_19_1, arg_19_2)
	return HTBUtil:callInterface(arg_19_1, "calcWorldPosToCameraPos", true, arg_19_2)
end

function HTBInterface.fogSyncPosition(arg_20_0, arg_20_1)
	return HTBUtil:callInterface(arg_20_1, "fogSyncPosition")
end

function HTBInterface.findPath(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	return HTBUtil:callInterface(arg_21_1, "findPath", true, arg_21_2, arg_21_3)
end

function HTBInterface.updateFieldUIScale(arg_22_0, arg_22_1)
	return HTBUtil:callInterface(arg_22_1, "updateFieldUIScale")
end

function HTBInterface.updatePingScale(arg_23_0, arg_23_1)
	return HTBUtil:callInterface(arg_23_1, "updatePingScale")
end

function HTBInterface.touchPosToWorldPos(arg_24_0, arg_24_1, arg_24_2)
	return HTBUtil:callInterface(arg_24_1, "touchPosToWorldPos", true, arg_24_2)
end

function HTBInterface.drawMovableTiles(arg_25_0, arg_25_1, arg_25_2, arg_25_3)
	return HTBUtil:callInterface(arg_25_1, "drawMovableTiles", nil, arg_25_2, arg_25_3)
end

function HTBInterface.onVisibleCallback(arg_26_0, arg_26_1, arg_26_2)
	return HTBUtil:callInterface(arg_26_1, "onVisibleCallback", nil, arg_26_2)
end

function HTBInterface.onVisibleOffCallback(arg_27_0, arg_27_1)
	return HTBUtil:callInterface(arg_27_1, "onVisibleOffCallback")
end

function HTBInterface.onVisibleCheckCallback(arg_28_0, arg_28_1, arg_28_2)
	return HTBUtil:callInterface(arg_28_1, "onVisibleCheckCallback", nil, arg_28_2)
end

function HTBInterface.onConsiderExpire(arg_29_0, arg_29_1)
	return HTBUtil:callInterface(arg_29_1, "onConsiderExpire")
end

function HTBInterface.onMovableSetPos(arg_30_0, arg_30_1, arg_30_2, arg_30_3, arg_30_4, arg_30_5)
	return HTBUtil:callInterface(arg_30_1, "onMovableSetPos", nil, arg_30_2, arg_30_3, arg_30_4, arg_30_5)
end

function HTBInterface.onMinimapUpdate(arg_31_0, arg_31_1, arg_31_2, arg_31_3)
	return HTBUtil:callInterface(arg_31_1, "onMinimapUpdate", nil, arg_31_2, arg_31_3)
end

function HTBInterface.onDetailCallback(arg_32_0, arg_32_1, arg_32_2)
	return HTBUtil:callInterface(arg_32_1, "onDetailCallback", nil, arg_32_2)
end

function HTBInterface.onUseCallback(arg_33_0, arg_33_1, arg_33_2)
	return HTBUtil:callInterface(arg_33_1, "onUseCallback", nil, arg_33_2)
end

function HTBInterface.onResponseCallback(arg_34_0, arg_34_1, arg_34_2, arg_34_3)
	return HTBUtil:callInterface(arg_34_1, "onResponseCallback", nil, arg_34_2, arg_34_3)
end

function HTBInterface.onExpireCallback(arg_35_0, arg_35_1, arg_35_2)
	return HTBUtil:callInterface(arg_35_1, "onExpireCallback", nil, arg_35_2)
end

function HTBInterface.onCancelCallback(arg_36_0, arg_36_1, arg_36_2)
	return HTBUtil:callInterface(arg_36_1, "onCancelCallback", nil, arg_36_2)
end

function HTBInterface.onMovableAdd(arg_37_0, arg_37_1, arg_37_2)
	return HTBUtil:callInterface(arg_37_1, "onMovableAdd", nil, arg_37_2)
end

function HTBInterface.onPlayerLevelUp(arg_38_0, arg_38_1, arg_38_2)
	return HTBUtil:callInterface(arg_38_1, "onPlayerLevelUp", nil, arg_38_2)
end

function HTBInterface.setVisibleObject(arg_39_0, arg_39_1, arg_39_2, arg_39_3)
	return HTBUtil:callInterface(arg_39_1, "setVisibleObject", nil, arg_39_2, arg_39_3)
end

function HTBInterface.setVisibleMovable(arg_40_0, arg_40_1, arg_40_2)
	return HTBUtil:callInterface(arg_40_1, "setVisibleMovable", nil, arg_40_2)
end

function HTBInterface.getUserLevel(arg_41_0, arg_41_1, arg_41_2)
	return HTBUtil:callInterface(arg_41_1, "getUserLevel", nil, arg_41_2)
end

function HTBInterface.isPlayerMovable(arg_42_0, arg_42_1, arg_42_2)
	return HTBUtil:callInterface(arg_42_1, "isPlayerMovable", true, arg_42_2)
end

function HTBInterface.isProcJumpPath(arg_43_0, arg_43_1)
	return HTBUtil:callInterface(arg_43_1, "isProcJumpPath")
end

function HTBInterface.isTileHaveAddSelect(arg_44_0, arg_44_1, arg_44_2)
	return HTBUtil:callInterface(arg_44_1, "isTileHaveAddSelect", true, arg_44_2)
end

function HTBInterface.isMovableCanCreate(arg_45_0, arg_45_1, arg_45_2, arg_45_3)
	return HTBUtil:callInterface(arg_45_1, "isMovableCanCreate", nil, arg_45_2, arg_45_3)
end

function HTBInterface.checkMovableCost(arg_46_0, arg_46_1, arg_46_2)
	return HTBUtil:callInterface(arg_46_1, "checkMovableCost", true, arg_46_2)
end

function HTBInterface.createMovableData(arg_47_0, arg_47_1, arg_47_2)
	return HTBUtil:callInterface(arg_47_1, "createMovableData", true, arg_47_2)
end

function HTBInterface.createObjectData(arg_48_0, arg_48_1, arg_48_2)
	return HTBUtil:callInterface(arg_48_1, "createObjectData", true, arg_48_2)
end

function HTBInterface.createUIMovableInfo(arg_49_0, arg_49_1, arg_49_2, arg_49_3, arg_49_4)
	return HTBUtil:callInterface(arg_49_1, "createUIModelInfo", nil, arg_49_2, arg_49_3, arg_49_4)
end

function HTBInterface.createTileMapData(arg_50_0, arg_50_1, arg_50_2)
	return HTBUtil:callInterface(arg_50_1, "createTileMapData", nil, arg_50_2)
end

function HTBInterface.whiteboardSet(arg_51_0, arg_51_1, arg_51_2, arg_51_3)
	return HTBUtil:callInterface(arg_51_1, "whiteboardSet", nil, arg_51_2, arg_51_3)
end

function HTBInterface.whiteboardGet(arg_52_0, arg_52_1, arg_52_2)
	return HTBUtil:callInterface(arg_52_1, "whiteboardGet", nil, arg_52_2)
end

function HTBInterface.movableRendererInit(arg_53_0, arg_53_1, arg_53_2, arg_53_3, arg_53_4)
	return HTBUtil:callInterface(arg_53_1, "movableRendererInit", nil, arg_53_2, arg_53_3, arg_53_4)
end

function HTBInterface.movableRendererRelease(arg_54_0, arg_54_1)
	return HTBUtil:callInterface(arg_54_1, "movableRendererRelease")
end

function HTBInterface.movableRendererClose(arg_55_0, arg_55_1)
	return HTBUtil:callInterface(arg_55_1, "movableRendererClose")
end

function HTBInterface.movableRendererAddDrawObject(arg_56_0, arg_56_1, arg_56_2)
	return HTBUtil:callInterface(arg_56_1, "movableRendererAddDrawObject", nil, arg_56_2)
end

function HTBInterface.movableRendererRemoveDrawObject(arg_57_0, arg_57_1, arg_57_2)
	return HTBUtil:callInterface(arg_57_1, "movableRendererRemoveDrawObject", nil, arg_57_2)
end

function HTBInterface.movableManagerCreate(arg_58_0, arg_58_1)
	return HTBUtil:callInterface(arg_58_1, "movableManagerCreate")
end

function HTBInterface.tileRendererInit(arg_59_0, arg_59_1, arg_59_2, arg_59_3)
	return HTBUtil:callInterface(arg_59_1, "tileRendererInit", true, arg_59_2, arg_59_3)
end

function HTBInterface.tileRendererDraw(arg_60_0, arg_60_1, arg_60_2)
	return HTBUtil:callInterface(arg_60_1, "tileRendererDraw", true, arg_60_2)
end

function HTBInterface.tileRendererRelease(arg_61_0, arg_61_1)
	return HTBUtil:callInterface(arg_61_1, "tileRendererRelease", true)
end

function HTBInterface.tileRendererClose(arg_62_0, arg_62_1)
	return HTBUtil:callInterface(arg_62_1, "tileRendererClose", true)
end

function HTBInterface.drawInteractionArea(arg_63_0, arg_63_1, arg_63_2)
	return HTBUtil:callInterface(arg_63_1, "drawInteractionArea", nil, arg_63_2)
end

function HTBInterface.onOpenPopup(arg_64_0, arg_64_1, arg_64_2, arg_64_3, arg_64_4)
	return HTBUtil:callInterface(arg_64_1, "onOpenPopup", nil, arg_64_2, arg_64_3, arg_64_4)
end

function HTBInterface.isMyMovableUID(arg_65_0, arg_65_1, arg_65_2)
	return HTBUtil:callInterface(arg_65_1, "isMyMovableUID", nil, arg_65_2)
end

function HTBInterface.addToEffectFieldUI(arg_66_0, arg_66_1, arg_66_2)
	return HTBUtil:callInterface(arg_66_1, "addToEffectFieldUI", nil, arg_66_2)
end

function HTBInterface.addObjectToRenderer(arg_67_0, arg_67_1, arg_67_2)
	return HTBUtil:callInterface(arg_67_1, "addObjectToRenderer", nil, arg_67_2)
end

function HTBInterface.addMovableEffect(arg_68_0, arg_68_1, arg_68_2, arg_68_3)
	return HTBUtil:callInterface(arg_68_1, "addMovableEffect", nil, arg_68_2, arg_68_3)
end

function HTBInterface.tileDetachObject(arg_69_0, arg_69_1, arg_69_2)
	return HTBUtil:callInterface(arg_69_1, "tileDetachObject", nil, arg_69_2)
end

function HTBInterface.tileAttachObject(arg_70_0, arg_70_1, arg_70_2, arg_70_3)
	return HTBUtil:callInterface(arg_70_1, "tileAttachObject", nil, arg_70_2, arg_70_3)
end

function HTBInterface.initObjectRenderer(arg_71_0, arg_71_1, arg_71_2)
	return HTBUtil:callInterface(arg_71_1, "initObjectRenderer", true, arg_71_2)
end

function HTBInterface.createObjectManager(arg_72_0, arg_72_1, arg_72_2)
	return HTBUtil:callInterface(arg_72_1, "createObjectManager", true, arg_72_2)
end

function HTBInterface.createChildIdListToObjectInfo(arg_73_0, arg_73_1, arg_73_2)
	return HTBUtil:callInterface(arg_73_1, "createChildIdListToObjectInfo", true, arg_73_2)
end

function HTBInterface.objectAddRenderObject(arg_74_0, arg_74_1, arg_74_2)
	return HTBUtil:callInterface(arg_74_1, "objectAddRenderObject", true, arg_74_2)
end

function HTBInterface.objectRemoveRenderObject(arg_75_0, arg_75_1, arg_75_2, arg_75_3)
	return HTBUtil:callInterface(arg_75_1, "objectRemoveRenderObject", true, arg_75_2, arg_75_3)
end

function HTBInterface.objectUpdateRenderObject(arg_76_0, arg_76_1, arg_76_2)
	return HTBUtil:callInterface(arg_76_1, "objectUpdateRenderObject", true, arg_76_2)
end

function HTBInterface.getCameraPos(arg_77_0, arg_77_1)
	return HTBUtil:callInterface(arg_77_1, "getCameraPos", nil)
end

function HTBInterface.getZoomPivotPos(arg_78_0, arg_78_1)
	return HTBUtil:callInterface(arg_78_1, "getZoomPivotPos", nil)
end

function HTBInterface.getCameraScale(arg_79_0, arg_79_1)
	return HTBUtil:callInterface(arg_79_1, "getCameraScale", nil)
end

function HTBInterface.objectCulling(arg_80_0, arg_80_1)
	return HTBUtil:callInterface(arg_80_1, "objectCulling", nil)
end

function HTBInterface.getFogDiscoveredList(arg_81_0, arg_81_1)
	return HTBUtil:callInterface(arg_81_1, "getFogDiscoveredList", nil)
end

function HTBInterface.createFogMapData(arg_82_0, arg_82_1, arg_82_2)
	return HTBUtil:callInterface(arg_82_1, "createFogMapData", nil, arg_82_2)
end

function HTBInterface.initFogRenderer(arg_83_0, arg_83_1, arg_83_2)
	return HTBUtil:callInterface(arg_83_1, "initFogRenderer", nil, arg_83_2)
end

function HTBInterface.fogRendererDraw(arg_84_0, arg_84_1, arg_84_2)
	return HTBUtil:callInterface(arg_84_1, "fogRendererDraw", nil, arg_84_2)
end

function HTBInterface.fogRendererRelease(arg_85_0, arg_85_1)
	return HTBUtil:callInterface(arg_85_1, "fogRendererRelease", nil)
end

function HTBInterface.fogRendererClose(arg_86_0, arg_86_1)
	return HTBUtil:callInterface(arg_86_1, "fogRendererClose", nil)
end

function HTBInterface.onUpdateFogCallback(arg_87_0, arg_87_1, arg_87_2, arg_87_3, arg_87_4)
	return HTBUtil:callInterface(arg_87_1, "onUpdateFogCallback", nil, arg_87_2, arg_87_3, arg_87_4)
end

function HTBInterface.getMoveRatio(arg_88_0, arg_88_1)
	return HTBUtil:callInterface(arg_88_1, "getMoveRatio", nil)
end
