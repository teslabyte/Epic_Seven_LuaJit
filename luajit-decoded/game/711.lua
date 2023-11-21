LotaStartingPointUI = {}

function HANDLER.clan_heritage_start(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_left" then
		LotaStartingPointUI:goLeftStartPosition()
	end
	
	if arg_1_1 == "btn_right" then
		LotaStartingPointUI:goRightStartPosition()
	end
	
	if arg_1_1 == "btn_select" then
		LotaStartingPointUI:confirm()
	end
end

function LotaStartingPointUI.goLeftStartPosition(arg_2_0)
	arg_2_0:setCameraStartPointPos(arg_2_0.vars.start_point_idx - 1)
end

function LotaStartingPointUI.goRightStartPosition(arg_3_0)
	arg_3_0:setCameraStartPointPos(arg_3_0.vars.start_point_idx + 1)
end

function LotaStartingPointUI.confirm(arg_4_0)
	local var_4_0 = LotaTileMapSystem:getStartPositionByIdx(arg_4_0.vars.start_point_idx)
	
	LotaMovableSystem:confirmPlayerStartPoint(var_4_0:getTileId())
end

function LotaStartingPointUI.init(arg_5_0, arg_5_1)
	arg_5_0.vars = {}
	arg_5_0.vars.dlg = LotaUtil:getUIDlg("clan_heritage_start")
	
	arg_5_1:addChild(arg_5_0.vars.dlg)
	arg_5_0:setCameraStartPointPos(1)
end

function LotaStartingPointUI.close(arg_6_0)
	arg_6_0.vars.dlg:removeFromParent()
	
	arg_6_0.vars = nil
end

function LotaStartingPointUI.setCameraStartPointPos(arg_7_0, arg_7_1)
	local var_7_0 = LotaTileMapSystem:getStartPositionByIdx(arg_7_1)
	
	if_set_visible(arg_7_0.vars.dlg, "btn_left", LotaTileMapSystem:getStartPositionByIdx(arg_7_1 - 1) ~= nil)
	if_set_visible(arg_7_0.vars.dlg, "btn_right", LotaTileMapSystem:getStartPositionByIdx(arg_7_1 + 1) ~= nil)
	if_set_visible(arg_7_0.vars.dlg, "btn_select", true)
	if_set(arg_7_0.vars.dlg, "t_point", T("[WIP TEXT] 위치 : ", {
		pos = arg_7_1
	}))
	LotaTileRenderer:marking(var_7_0:getPos())
	LotaCameraSystem:setCameraPosByTile(var_7_0)
	
	arg_7_0.vars.start_point_idx = arg_7_1
end
