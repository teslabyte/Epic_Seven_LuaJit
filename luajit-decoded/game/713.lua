LotaBossReadyUI = {}

function HANDLER.clan_heritage_battle_ready_boss(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_go" then
		LotaBossReadyUI:openBattleReady()
	end
	
	if arg_1_1 == "btn_reward_info" then
		LotaBossReadyUI:openRewardInfo()
	end
end

function LotaBossReadyUI.openRewardInfo(arg_2_0)
	if not arg_2_0.vars then
		return 
	end
	
	LotaUtil:openRewardPreviewDlg(arg_2_0.vars.reward_id, arg_2_0.vars.object_id)
end

function LotaBossReadyUI.openBattleReady(arg_3_0)
	LotaBattleReady:show(arg_3_0.vars.data)
end

function LotaBossReadyUI.responseSync(arg_4_0, arg_4_1)
	if arg_4_0.vars.open_ready then
		if arg_4_1.no_info_reason then
			local var_4_0 = arg_4_0.vars.ready_data.object_id
			local var_4_1 = LotaUtil:getBossInfo(var_4_0)
			
			arg_4_0.vars.ready_data.res = LotaUtil:genResponse(var_4_1)
		else
			arg_4_0.vars.ready_data.res = arg_4_1
		end
		
		arg_4_0:open(arg_4_0.vars.ready_data)
	else
		if not arg_4_1.no_info_reason then
			arg_4_0.vars.data.res = arg_4_1
		end
		
		arg_4_0:updateByResponse()
	end
end

function LotaBossReadyUI.isActive(arg_5_0)
	return arg_5_0.vars and get_cocos_refid(arg_5_0.vars.dlg)
end

function LotaBossReadyUI.isWaitResponse(arg_6_0)
	return arg_6_0.vars and arg_6_0.vars.open_ready
end

function LotaBossReadyUI.openReady(arg_7_0, arg_7_1)
	arg_7_0.vars = {}
	arg_7_0.vars.ready_data = arg_7_1
	arg_7_0.vars.open_ready = true
	
	LotaNetworkSystem:sendQuery("lota_battle_sync", {
		tile_id = arg_7_1.tile_id,
		battle_id = LotaUtil:getBattleId(arg_7_1.tile_id)
	})
end

function LotaBossReadyUI.open(arg_8_0, arg_8_1)
	arg_8_0.vars = {}
	
	local var_8_0 = LotaSystem:getUIPopupLayer()
	
	arg_8_0.vars.dlg = LotaUtil:getUIDlg("clan_heritage_battle_ready_boss")
	arg_8_0.vars.data = arg_8_1
	arg_8_0.vars.open_ready = false
	arg_8_0.vars.object_id = arg_8_0.vars.data.object_id
	arg_8_0.vars.reward_id, arg_8_0.vars.enter_id = DB("clan_heritage_object_data", arg_8_0.vars.object_id, {
		"reward_id",
		"level_id"
	})
	
	var_8_0:addChild(arg_8_0.vars.dlg)
	arg_8_0:updateUI(arg_8_1)
	TopBarNew:createFromPopup(T("boss_battle_ready"), arg_8_0.vars.dlg, function()
		LotaBossReadyUI:onButtonClose()
	end)
	TopBarNew:setCurrencies({
		"clanheritage",
		"clanheritagecoin"
	})
	TopBarNew:checkhelpbuttonID("heritagequest_4")
end

function LotaBossReadyUI.onButtonClose(arg_10_0)
	arg_10_0.vars.dlg:removeFromParent()
	BackButtonManager:pop("boss_battle_ready")
	TopBarNew:pop()
end

function LotaBossReadyUI.createBG(arg_11_0)
	local var_11_0 = arg_11_0.vars.enter_id
	local var_11_1 = DB("level_enter", var_11_0, "info_id")
	local var_11_2 = DB("level_stage_1_info", var_11_1, "image")
	local var_11_3 = arg_11_0.vars.dlg:findChildByName("n_bg")
	local var_11_4, var_11_5 = FIELD_NEW:create(var_11_2, DESIGN_WIDTH * 2)
	
	var_11_4:setAnchorPoint(0.5, 0.5)
	var_11_4:setPosition(0, -(DESIGN_HEIGHT * 0.5))
	var_11_4:setScale(1)
	var_11_5:setViewPortPosition(DESIGN_WIDTH + VIEW_BASE_LEFT)
	var_11_5:updateViewport()
	var_11_3:addChild(var_11_4)
end

function LotaBossReadyUI.createBossPortrait(arg_12_0)
	local var_12_0 = arg_12_0.vars.dlg:findChildByName("n_boss_pos")
	local var_12_1 = LotaUtil:getCharacterId(arg_12_0.vars.object_id)
	local var_12_2, var_12_3, var_12_4, var_12_5 = DB("character", var_12_1, {
		"model_id",
		"skin",
		"atlas",
		"model_opt"
	})
	local var_12_6 = CACHE:getModel(var_12_2, var_12_3, nil, var_12_4, var_12_5)
	
	if var_12_6 then
		var_12_0:removeAllChildren()
		var_12_0:addChild(var_12_6)
		var_12_6:setScaleX(-1.8)
		var_12_6:setScaleY(1.8)
	end
end

function LotaBossReadyUI.createMembersInfo(arg_13_0, arg_13_1)
	arg_13_0.vars.list = LotaUtil:createMembersList(arg_13_0.vars.dlg, arg_13_1.res.expedition_users)
end

function LotaBossReadyUI.updateBossInfo(arg_14_0, arg_14_1)
	local var_14_0 = arg_14_1.res.expedition_info
	local var_14_1 = arg_14_0.vars.enter_id
	local var_14_2 = CoopUtil:getBossLevelFromLevelData({
		level_enter = var_14_1,
		character_id = var_14_0.boss_info.character_id
	})
	
	LotaUtil:updateBossInfoUI(arg_14_0.vars.dlg, var_14_0, arg_14_0.vars.hp_rate, {
		no_popup = false,
		lv = var_14_2
	})
	
	local var_14_3 = arg_14_1.res.expedition_info.boss_info
	local var_14_4 = CoopUtil:getBossHpRate(var_14_3.max_hp, var_14_3.last_hp)
	
	arg_14_0.vars.hp_rate = var_14_4
end

function LotaBossReadyUI.updateUI(arg_15_0, arg_15_1)
	arg_15_0:createBG()
	arg_15_0:createBossPortrait()
	arg_15_0:createMembersInfo(arg_15_1)
	arg_15_0:updateBossInfo(arg_15_1)
end
