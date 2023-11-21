SPLInterfaceImpl = {
	getPlayerPos = {
		getPlayerPos = function(arg_1_0)
			return arg_1_0:getPlayerPos()
		end,
		self = SPLMovableSystem
	},
	calcTilePosToWorldPos = {
		calcTilePosToWorldPos = function(arg_2_0, arg_2_1)
			return arg_2_0:calcTilePosToWorldPos(arg_2_1)
		end,
		self = SPLUtil
	},
	calcWorldPosToTilePos = {
		calcWorldPosToTilePos = function(arg_3_0, arg_3_1, arg_3_2)
			return arg_3_0:calcWorldPosToTilePos(arg_3_1, arg_3_2)
		end,
		self = SPLTileMapSystem
	},
	calcWorldPosToCameraPos = {
		calcWorldPosToCameraPos = function(arg_4_0, arg_4_1)
			return SPLCameraSystem:worldPosToCameraPos(arg_4_1)
		end
	},
	fogSyncPosition = {
		fogSyncPosition = function(arg_5_0)
		end
	},
	getWorldMinMaxPos = {
		getWorldMinMaxPos = function(arg_6_0)
			return arg_6_0:getWorldMinMaxPos()
		end,
		self = SPLUtil
	},
	updateFieldUIScale = {
		updateFieldUIScale = function(arg_7_0)
			return arg_7_0:updateFieldUIScale()
		end,
		self = SPLFieldUI
	},
	updatePingScale = {
		updatePingScale = function(arg_8_0)
		end,
		self = SPLSystem
	},
	getTileSprite = {
		getTileSprite = function(arg_9_0, arg_9_1)
			return arg_9_0:getTileSprite(arg_9_1)
		end,
		self = SPLTileMapRenderer
	},
	tileRendererInit = {
		tileRendererInit = function(arg_10_0, arg_10_1, arg_10_2)
			return arg_10_0:init(arg_10_1, arg_10_2)
		end,
		self = SPLTileMapRenderer
	},
	tileRendererDraw = {
		tileRendererDraw = function(arg_11_0, arg_11_1)
			return arg_11_0:draw(arg_11_1)
		end,
		self = SPLTileMapRenderer
	},
	tileRendererRelease = {
		tileRendererRelease = function(arg_12_0)
			return arg_12_0:release()
		end,
		self = SPLTileMapRenderer
	},
	tileRendererClose = {
		tileRendererClose = function(arg_13_0)
			return arg_13_0:close()
		end,
		self = SPLTileMapRenderer
	},
	touchPosToWorldPos = {
		touchPosToWorldPos = function(arg_14_0, arg_14_1)
			return arg_14_0:touchPosToWorldPos(arg_14_1)
		end,
		self = SPLSystem
	},
	getPosById = {
		getPosById = function(arg_15_0, arg_15_1)
			return arg_15_0:getPosById(arg_15_1)
		end,
		self = SPLTileMapSystem
	},
	getUserLevel = {
		getUserLevel = function(arg_16_0, arg_16_1)
			return arg_16_0:getUserLevel(arg_16_1)
		end,
		self = SPLUtil
	},
	createTileMapData = {
		createTileMapData = function(arg_17_0, arg_17_1)
			return SPLTileMapData(nil, arg_17_1)
		end,
		self = SPLTileMapData
	},
	whiteboardSet = {
		whiteboardSet = function(arg_18_0, arg_18_1, arg_18_2)
			return arg_18_0:set(arg_18_1, arg_18_2)
		end,
		self = SPLWhiteboard
	},
	whiteboardGet = {
		whiteboardGet = function(arg_19_0, arg_19_1)
			return arg_19_0:get(arg_19_1)
		end,
		self = SPLWhiteboard
	},
	isPlayerMovable = {
		isPlayerMovable = function(arg_20_0, arg_20_1)
			do return true end
			return arg_20_0:isPlayerMovable(arg_20_1)
		end,
		self = SPLMovableSystem
	},
	isTileHaveAddSelect = {
		isTileHaveAddSelect = function(arg_21_0, arg_21_1)
			return SPLUtil:isTileHaveAddSelect(arg_21_1)
		end
	},
	onMovableSetPos = {
		onMovableSetPos = function(arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4)
			if arg_22_2 then
				SPLMovableRenderer:setPosMovable(arg_22_1, arg_22_3)
			end
		end,
		self = SPLMovableRenderer
	},
	onCheckPos = {
		onCheckPos = function(arg_23_0, arg_23_1, arg_23_2)
			return arg_23_0:onCheckPos(arg_23_1, arg_23_2)
		end,
		self = SPLTileMapSystem
	},
	createMovableData = {
		createMovableData = function(arg_24_0, arg_24_1)
			return SPLMovableData(arg_24_1)
		end
	},
	getFogVisibility = {
		getFogVisibility = function(arg_25_0, arg_25_1, arg_25_2)
			return arg_25_0:getFogVisibility(arg_25_1, arg_25_2)
		end,
		self = SPLFogSystem
	},
	getMovablesByPos = {
		getMovablesByPos = function(arg_26_0, arg_26_1)
			return SPLMovableSystem:getMovablesByPos(arg_26_1)
		end,
		self = SPLMovableSystem
	},
	getTileByPos = {
		getTileByPos = function(arg_27_0, arg_27_1)
			return SPLTileMapSystem:getTileByPos(arg_27_1)
		end
	},
	getTileById = {
		getTileById = function(arg_28_0, arg_28_1)
			return SPLTileMapSystem:getTileById(arg_28_1)
		end
	},
	getTileIdByPos = {
		getTileIdByPos = function(arg_29_0, arg_29_1)
			return SPLTileMapSystem:getTileIdByPos(arg_29_1)
		end
	},
	getChildIdList = {
		getChildIdList = function(arg_30_0, arg_30_1)
			return SPLUtil:getChildIdList(arg_30_1)
		end
	},
	getObject = {
		getObject = function(arg_31_0, arg_31_1)
			return SPLObjectSystem:getObject(arg_31_1)
		end
	},
	addObjectToRenderer = {
		addObjectToRenderer = function(arg_32_0, arg_32_1)
			return SPLObjectRenderer:addRenderObject(arg_32_1)
		end
	},
	tileDetachObject = {
		tileDetachObject = function(arg_33_0, arg_33_1)
			return SPLTileMapSystem:detachObject(arg_33_1)
		end
	},
	tileAttachObject = {
		tileAttachObject = function(arg_34_0, arg_34_1, arg_34_2)
			return SPLTileMapSystem:attachObject(arg_34_1, arg_34_2)
		end
	},
	createObjectData = {
		createObjectData = function(arg_35_0, arg_35_1)
			return SPLObjectData(arg_35_1)
		end
	},
	createChildIdListToObjectInfo = {
		createChildIdListToObjectInfo = function(arg_36_0, arg_36_1)
			return SPLUtil:createChildIdListToObjectInfo(arg_36_1)
		end
	},
	objectAddRenderObject = {
		objectAddRenderObject = function(arg_37_0, arg_37_1)
			SPLObjectRenderer:addRenderObject(arg_37_1)
		end
	},
	objectRemoveRenderObject = {
		objectRemoveRenderObject = function(arg_38_0, arg_38_1, arg_38_2)
			local var_38_0 = SPLObjectSystem:getObject(arg_38_1)
			
			if not var_38_0 or var_38_0:getType() == "empty" then
				return 
			end
			
			SPLObjectRenderer:removeRenderObject(arg_38_1, arg_38_2)
		end
	},
	objectRendererUpdateObject = {
		objectRendererUpdateObject = function(arg_39_0, arg_39_1)
			SPLObjectRenderer:updateRenderObject(arg_39_1)
		end
	},
	getCameraPos = {
		getCameraPos = function(arg_40_0)
			return SPLCameraSystem:getCameraPos()
		end
	},
	getZoomPivotPos = {
		getZoomPivotPos = function(arg_41_0)
			return SPLCameraSystem:getZoomPivotPos()
		end
	},
	getCameraScale = {
		getCameraScale = function(arg_42_0)
			return SPLCameraSystem:getCameraScale()
		end
	},
	objectCulling = {
		objectCulling = function(arg_43_0)
			SPLCameraSystem:objectCulling()
		end
	},
	getFogDiscoveredList = {
		getFogDiscoveredList = function(arg_44_0)
			return SPLFogSystem:getFogDiscoveredList()
		end
	},
	createFogMapData = {
		createFogMapData = function(arg_45_0, arg_45_1)
			return SPLFogMapData(arg_45_1)
		end
	},
	initFogRenderer = {
		initFogRenderer = function(arg_46_0, arg_46_1)
			SPLFogRenderer:init(arg_46_1)
		end
	},
	fogRendererDraw = {
		fogRendererDraw = function(arg_47_0, arg_47_1)
			SPLFogRenderer:renderFogs(arg_47_1)
		end
	},
	fogRendererRelease = {
		fogRendererRelease = function(arg_48_0)
			SPLFogRenderer:release()
		end
	},
	fogRendererClose = {
		fogRendererClose = function(arg_49_0)
			SPLFogRenderer:close()
		end
	},
	onUpdateFogCallback = {
		onUpdateFogCallback = function(arg_50_0, arg_50_1, arg_50_2, arg_50_3)
			SPLObjectRenderer:updateColorByFog(arg_50_1, arg_50_2, arg_50_3)
			SPLMovableRenderer:updateColorByFog(arg_50_1, arg_50_2, arg_50_3)
		end
	},
	getMoveRatio = {
		getMoveRatio = function(arg_51_0)
			return SPLCameraSystem:getMoveRatio()
		end
	},
	objectNotifyCallback = {
		onDetailCallback = function(arg_52_0, arg_52_1)
			arg_52_1:onDetail()
		end,
		onUseCallback = function(arg_53_0, arg_53_1)
			arg_53_1:onUse()
		end,
		onCancelCallback = function(arg_54_0, arg_54_1)
			arg_54_1:onCancel()
		end,
		onResponseCallback = function(arg_55_0, arg_55_1, arg_55_2)
			arg_55_1:onResponse(arg_55_2)
		end,
		onExpireCallback = function(arg_56_0, arg_56_1)
			arg_56_1:onExpire()
		end
	},
	findPath = {
		findPath = function(arg_57_0, arg_57_1, arg_57_2, arg_57_3)
			return SPLPathFindingSystem:find(arg_57_1, arg_57_2, arg_57_3)
		end
	},
	getReachableTiles = {
		getReachableTiles = function(arg_58_0, arg_58_1, arg_58_2, arg_58_3)
			return SPLPathFindingSystem:getReachableTiles(arg_58_1, arg_58_2, arg_58_3)
		end
	},
	drawMovableTiles = {
		drawMovableTiles = function(arg_59_0, arg_59_1, arg_59_2)
			SPLTileMapSystem:updateInteractArea(arg_59_1)
			SPLTileMapRenderer:drawMovableArea(arg_59_1, arg_59_2)
		end
	},
	movableRendererInit = {
		movableRendererInit = function(arg_60_0, arg_60_1, arg_60_2, arg_60_3)
			SPLMovableRenderer:init(arg_60_1, arg_60_2)
			SPLMovableRenderer:firstDraw(arg_60_3:getList())
		end
	},
	movableRendererRelease = {
		movableRendererRelease = function(arg_61_0)
			SPLMovableRenderer:release()
		end
	},
	movableRendererClose = {
		movableRendererClose = function(arg_62_0)
			SPLMovableRenderer:close()
		end
	},
	movableManagerCreate = {
		movableManagerCreate = function(arg_63_0)
			return SPLMovableManager()
		end
	}
}
