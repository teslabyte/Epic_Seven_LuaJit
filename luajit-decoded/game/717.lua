LotaCoopStatusUI = ClassDef()

function LotaCoopStatusUI.onHandler(arg_1_0, arg_1_1, arg_1_2)
	if not arg_1_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_1_0.vars.wnd) then
		return 
	end
	
	if arg_1_2 == "btn_confirm" then
		LotaReminderUI:closeDetail()
	end
end

function LotaCoopStatusUI.isValid(arg_2_0)
	return arg_2_0.vars and get_cocos_refid(arg_2_0.vars.wnd)
end

function LotaCoopStatusUI.constructor(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	arg_3_0.vars = {}
	arg_3_0.vars.battle_data = arg_3_1
	arg_3_0.vars.object_db_id = arg_3_3
	arg_3_0.vars.ranking_list = CoopUtil:getRankList(CoopUtil:makeCoopMemberArray(arg_3_2, false, "damage"), "damage")
	
	table.insert(CoopResultEventerList, arg_3_0)
end

function LotaCoopStatusUI.onShow(arg_4_0, arg_4_1)
	if not get_cocos_refid(arg_4_1) then
		return 
	end
	
	arg_4_0.vars.wnd = load_dlg("expedition_result", true, "wnd", function()
		arg_4_0:close()
	end)
	
	arg_4_1:addChild(arg_4_0.vars.wnd)
	arg_4_0:buildUI()
end

function LotaCoopStatusUI.settingOnBossDeadInformation(arg_6_0)
	local var_6_0 = arg_6_0.vars.wnd:findChildByName("n_fail_heritage")
	local var_6_1 = arg_6_0.vars.wnd:findChildByName("n_complete")
	
	if_set_visible(var_6_0, nil, false)
	if_set_visible(var_6_1, nil, true)
	arg_6_0:top3Setting(arg_6_0.vars.ranking_list)
end

function LotaCoopStatusUI.settingOnBossLiveInformation(arg_7_0)
	local var_7_0 = arg_7_0.vars.wnd:findChildByName("n_fail_heritage")
	local var_7_1 = arg_7_0.vars.wnd:findChildByName("n_complete")
	
	if_set_visible(var_7_0, nil, true)
	if_set_visible(var_7_1, nil, false)
	
	local var_7_2 = arg_7_0.vars.battle_data
	local var_7_3 = var_7_0:findChildByName("n_condition")
	
	LotaUtil:updateBossCondition(var_7_3, var_7_2)
	
	local var_7_4 = var_7_0:findChildByName("n_boss")
	
	if_set_visible(var_7_4, "lv", false)
	if_set_visible(var_7_4, "grade_icon", false)
	UIUtil:getRewardIcon(nil, arg_7_0.vars.object_db_id, {
		no_tooltip = true,
		show_name = true,
		is_tooltip_icon = true,
		no_resize_name = true,
		txt_name_width = 195,
		txt_scale = 0.91,
		scale = 1,
		detail = true,
		parent = var_7_4:getChildByName("mob_icon"),
		txt_name = var_7_4:getChildByName("t_name"),
		txt_type = var_7_4:getChildByName("t_type")
	})
	
	local var_7_5 = var_7_0:findChildByName("n_fu")
	local var_7_6 = LotaUtil:getCharacterId(arg_7_0.vars.object_db_id)
	local var_7_7 = UNIT:create({
		code = var_7_6
	})
	
	if var_7_7 and not var_7_5:findChildByName("model") then
		local var_7_8 = CACHE:getModel(var_7_7.db)
		local var_7_9, var_7_10 = var_7_8:getBonePosition("top")
		
		var_7_8:setPosition(0, -var_7_10)
		var_7_8:setAnchorPoint(0.5, 0.5)
		var_7_8:setColor(var_7_5:getColor())
		var_7_8:setName("model")
		var_7_5:addChild(var_7_8)
	end
end

LotaCoopStatusUI.top3Setting = CoopResult.top3Setting

function LotaCoopStatusUI.buildUI(arg_8_0)
	if_set_visible(arg_8_0.vars.wnd, "n_fail", false)
	if_set_visible(arg_8_0.vars.wnd, "bg", false)
	if_set_visible(arg_8_0.vars.wnd, "bg_heritage", true)
	
	local var_8_0 = arg_8_0.vars.battle_data:isBossDead()
	
	if_set_visible(arg_8_0.vars.wnd, "n_fail_heritage", not var_8_0)
	
	arg_8_0.vars.listView = CoopUtil:makeRankingListView(arg_8_0.vars.wnd:findChildByName("ScrollView"), arg_8_0.vars.ranking_list or {}, {
		ignore_max_count = true
	})
	
	for iter_8_0, iter_8_1 in pairs(arg_8_0.vars.ranking_list) do
		if tostring(iter_8_1.uid) == tostring(AccountData.id) then
			arg_8_0.vars.my_info = iter_8_1
			
			break
		end
	end
	
	if var_8_0 then
		arg_8_0:settingOnBossDeadInformation()
	else
		arg_8_0:settingOnBossLiveInformation()
	end
	
	local var_8_1 = arg_8_0.vars.my_info or {}
	
	CoopUtil:setRankText(arg_8_0.vars.wnd:findChildByName("n_my"), var_8_1.rank, var_8_1.count, var_8_1.total_score, true)
	
	local var_8_2 = arg_8_0.vars.wnd:findChildByName("btn_confirm")
	
	if_set(var_8_2, "label", T("ui_msgbox_ok"))
end

function LotaCoopStatusUI.close(arg_9_0)
	if get_cocos_refid(arg_9_0.vars.wnd) then
		arg_9_0.vars.wnd:removeFromParent()
		BackButtonManager:pop()
		
		arg_9_0.vars = nil
	end
end
