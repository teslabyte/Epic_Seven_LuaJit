LotaPingSystem = {}

function LotaPingSystem.init(arg_1_0, arg_1_1)
	arg_1_0.vars = {}
	
	LotaPingRenderer:init(arg_1_1)
	
	arg_1_0.vars.manager = LotaPingManager()
end

function LotaPingSystem.updatePingStatus(arg_2_0, arg_2_1)
	if not arg_2_0.vars then
		return 
	end
	
	arg_2_0.vars.manager:updateByResponse(arg_2_1)
	LotaPingRenderer:update()
	LotaMinimapPingRenderer:update()
end

function LotaPingSystem.getPingData(arg_3_0, arg_3_1)
	return arg_3_0.vars.manager:getPingData(arg_3_1)
end

function LotaPingSystem.getPingDataByTileId(arg_4_0, arg_4_1)
	return arg_4_0.vars.manager:getPingDataByTileId(arg_4_1)
end

function LotaPingSystem.getMemoData(arg_5_0, arg_5_1)
	return arg_5_0.vars.manager:getMemoData(arg_5_1)
end

function LotaPingSystem.getPingMaxCount(arg_6_0)
	return (DB("clan_heritage_config", "max_memo", "client_value"))
end

function LotaPingSystem.getPingCount(arg_7_0)
	return arg_7_0.vars.manager:getPingCount()
end

function LotaPingSystem.getPingRemainCount(arg_8_0)
	return arg_8_0:getPingMaxCount() - arg_8_0.vars.manager:getPingCount()
end

function LotaPingSystem.isExistPing(arg_9_0, arg_9_1)
	return arg_9_0.vars.manager:isExistPing(arg_9_1)
end
