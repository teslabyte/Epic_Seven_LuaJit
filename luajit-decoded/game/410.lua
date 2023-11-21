EquipCraftEvent = {}
EquipCraftEvent.Main = {}

local var_0_0 = {
	MainStat = "MainStat",
	Part = "Part",
	SetFx = "SetFx",
	Main = "Main",
	SubStat = "SubStat"
}
local var_0_1 = {
	[0] = "Main",
	"SetFx",
	"Part",
	"MainStat",
	"SubStat",
	"Make"
}

local function var_0_2(arg_1_0, arg_1_1)
	if not arg_1_0 then
		Log.e("NOT EXISTS TABLE : ", arg_1_1)
		
		return true
	end
	
	return false
end

local var_0_3 = {
	onEnter = function(arg_2_0, arg_2_1)
		local var_2_0 = EquipCraftEvent[arg_2_0]
		
		if var_0_2(var_2_0, arg_2_0) then
			return 
		end
		
		var_2_0:onEnter(arg_2_1)
	end,
	onLeave = function(arg_3_0)
		local var_3_0 = EquipCraftEvent[arg_3_0]
		
		if var_0_2(var_3_0, arg_3_0) then
			return 
		end
		
		var_3_0:onLeave()
	end,
	onHandler = function(arg_4_0, arg_4_1, arg_4_2)
		local var_4_0 = EquipCraftEvent[arg_4_0]
		
		if var_0_2(var_4_0, arg_4_0) then
			return 
		end
		
		var_4_0:onHandler(arg_4_1, arg_4_2)
	end,
	getButtonStatus = function(arg_5_0)
		local var_5_0 = EquipCraftEvent[arg_5_0]
		
		if var_0_2(var_5_0, arg_5_0) then
			return 
		end
		
		return var_5_0:getButtonStatus()
	end
}

function MsgHandler.get_equip_craft_info(arg_6_0)
	EquipCraftEvent:onResponseCraftInfo(arg_6_0)
end

EquipCraftEvent.MODE_INTERFACES = var_0_3

function EquipCraftEvent.onResponseCraftInfo(arg_7_0, arg_7_1)
	local var_7_0 = SceneManager:getRunningNativeScene()
	
	if SceneManager:getCurrentSceneName() == "sanctuary" then
		var_7_0 = SanctuaryCraftMain:getParentLayer()
	end
	
	if not arg_7_0:init(var_7_0, arg_7_1) then
		balloon_message_with_sound("equip_craft_event_msg_time_over")
		
		return false
	end
	
	if SceneManager:getCurrentSceneName() == "sanctuary" then
		SanctuaryCraftMain:onHide()
		SanctuaryMain:showUpgradeBar(false)
	end
	
	return true
end

function EquipCraftEvent.init(arg_8_0, arg_8_1, arg_8_2)
	arg_8_0.vars = {}
	arg_8_0.vars.parent_layer = arg_8_1
	arg_8_0.vars.last_mode = nil
	
	if not arg_8_0.Data:create(arg_8_2) then
		arg_8_0.vars = nil
		
		return 
	end
	
	arg_8_0:updateByResponse(arg_8_2)
	arg_8_0.Ring:create()
	arg_8_0:enterMode("Main", arg_8_0.vars.parent_layer)
	
	return true
end

function EquipCraftEvent.remove(arg_9_0)
	for iter_9_0, iter_9_1 in pairs(var_0_0) do
		local var_9_0 = arg_9_0[iter_9_1]
		
		if var_9_0 and var_9_0.vars and var_9_0.onLeave then
			var_9_0:onLeave()
		end
	end
	
	arg_9_0.Base:remove()
	arg_9_0.Main:onLeave()
end

function EquipCraftEvent.enterMode(arg_10_0, arg_10_1, arg_10_2)
	if arg_10_0.vars.last_mode then
		var_0_3.onLeave(var_0_0[arg_10_0.vars.last_mode])
	end
	
	if arg_10_1 ~= "Main" then
		if not arg_10_0.Base:isExist() then
			arg_10_0.Base:create(arg_10_2)
		end
		
		arg_10_0.Base:setMode(arg_10_1)
		
		arg_10_2 = arg_10_0.Base:getLayerForMode(arg_10_1)
		
		EquipCraftEvent.Base:updateRing(arg_10_1)
	elseif arg_10_1 == "Main" and arg_10_0.Base:isExist() then
		arg_10_0.Base:remove()
	end
	
	var_0_3.onEnter(var_0_0[arg_10_1], arg_10_2)
	
	if arg_10_1 ~= "Main" then
		local var_10_0 = EquipCraftEvent[var_0_0[arg_10_1]]
		local var_10_1 = var_0_3.getButtonStatus(var_0_0[arg_10_1], arg_10_2)
		
		EquipCraftEvent.Base:setRequirePoint(var_10_0.Data:getRequirePoint())
		EquipCraftEvent.Base:updateButtonStatus(var_10_1, var_10_0.Data:getRequirePoint())
	end
	
	arg_10_0.vars.last_mode = arg_10_1
end

function EquipCraftEvent.isAvailableMode(arg_11_0, arg_11_1)
	if arg_11_1 == "SubStat" then
		return not EquipCraftEventUtil:isDataEmpty(arg_11_0.Data:getMainStat())
	elseif arg_11_1 == "MainStat" then
		return DB("equip_item", arg_11_0.Data:getEquipCode(), "id") ~= nil
	elseif arg_11_1 == "Part" then
		return not EquipCraftEventUtil:isDataEmpty(arg_11_0.Data:getSetFx())
	elseif arg_11_1 == "SetFx" then
		return true
	end
	
	return false
end

function EquipCraftEvent.getMode(arg_12_0)
	return arg_12_0.vars.last_mode
end

function EquipCraftEvent.jumpToLastProgress(arg_13_0)
	local var_13_0 = arg_13_0.Data:getEquipCraftProgress()
	local var_13_1 = var_0_1[var_13_0]
	
	if not var_13_1 then
		Log.e("PROGRESS_TO_MODE, INVALID PROGRESS.")
		
		return 
	end
	
	arg_13_0:enterMode(var_13_1, arg_13_0.vars.parent_layer)
end

function EquipCraftEvent.jumpToMode(arg_14_0, arg_14_1)
	arg_14_0:enterMode(arg_14_1, arg_14_0.vars.parent_layer)
end

function EquipCraftEvent.nextProgress(arg_15_0)
	local var_15_0 = arg_15_0.Data:getEquipCraftProgress()
	
	if not var_0_1[var_15_0] then
		Log.e("NOT IMPLED")
		
		return 
	end
	
	local var_15_1 = var_0_1[var_15_0]
	
	arg_15_0:enterMode(var_15_1, arg_15_0.vars.parent_layer)
end

function EquipCraftEvent.query(arg_16_0, arg_16_1, arg_16_2)
	if arg_16_0.Data:isOverTime() then
		balloon_message_with_sound("equip_craft_event_msg_time_over")
		
		return 
	end
	
	arg_16_2 = arg_16_2 or {}
	arg_16_2.event_id = arg_16_0.Data:getEventId()
	
	query(arg_16_1, arg_16_2)
end

function EquipCraftEvent.dlgHandler(arg_17_0, arg_17_1, arg_17_2)
	if arg_17_2 == "btn_bg" then
		EquipCraftEvent:closeResultDlg()
	elseif arg_17_2 == "btn_lock" or arg_17_2 == "btn_lock_done" then
		EquipCraftEvent:toggleLockResultItem(arg_17_2)
	end
end

function EquipCraftEvent.toggleLockResultItem(arg_18_0, arg_18_1)
	if not arg_18_0.vars or not arg_18_0.vars.made_equip then
		return 
	end
	
	if arg_18_1 == "btn_lock" then
		query("lock_equip", {
			equip = arg_18_0.vars.made_equip.id
		})
	elseif arg_18_1 == "btn_lock_done" then
		query("unlock_equip", {
			equip = arg_18_0.vars.made_equip.id
		})
	end
end

function EquipCraftEvent.updateEquipLock(arg_19_0, arg_19_1)
	if not arg_19_0.vars or not arg_19_0.vars.modal_dlg or not get_cocos_refid(arg_19_0.vars.modal_dlg) or not arg_19_0.vars.made_equip then
		return 
	end
	
	local var_19_0 = arg_19_0.vars.modal_dlg
	
	if_set_visible(var_19_0, "btn_lock", not arg_19_1)
	if_set_visible(var_19_0, "btn_lock_done", arg_19_1)
	if_set_visible(var_19_0, "locked", arg_19_1)
end

function EquipCraftEvent.isActiveDlg(arg_20_0)
	return arg_20_0.vars and get_cocos_refid(arg_20_0.vars.modal_dlg)
end

function EquipCraftEvent.closeResultDlg(arg_21_0)
	BackButtonManager:pop("equip_craft_result")
	UIAction:Add(SEQ(FADE_OUT(150), REMOVE()), arg_21_0.vars.modal_dlg, "block")
	
	arg_21_0.vars.modal_dlg = nil
	
	EquipCraftEvent:jumpToMode("Main")
end

function EquipCraftEvent.playResultStatEffect(arg_22_0)
	UIUtil:playResultStatEffect(arg_22_0.vars.sub_wnd)
end

function EquipCraftEvent.onEquipCraftResult(arg_23_0, arg_23_1)
	local var_23_0
	
	if arg_23_1 and arg_23_1.rewards then
		for iter_23_0, iter_23_1 in pairs(arg_23_1.rewards.new_equips or {}) do
			var_23_0 = iter_23_1
			
			break
		end
		
		var_23_0 = Account:getEquip(var_23_0.id)
	end
	
	if not var_23_0 then
		return 
	end
	
	arg_23_0.vars.made_equip = var_23_0
	arg_23_0.vars.modal_dlg = load_dlg("equip_craft_result", true, "wnd", function()
		EquipCraftEvent:closeResultDlg()
	end)
	arg_23_0.vars.sub_wnd = load_dlg("item_detail_sub", true, "wnd")
	
	SceneManager:getRunningNativeScene():addChild(arg_23_0.vars.modal_dlg)
	UIUtil:setUpEquipCraftResultDlg(arg_23_0.vars.modal_dlg, arg_23_0.vars.sub_wnd, var_23_0)
	UIUtil:playEquipCraftEffect(arg_23_0.vars.modal_dlg, arg_23_0.vars.sub_wnd, function()
		arg_23_0:playResultStatEffect()
	end, arg_23_0)
	if_set_visible(arg_23_0.vars.modal_dlg, "btn_extract", Account:isUnlockExtract())
	
	if not Account:isUnlockExtract() then
		local var_23_1 = arg_23_0.vars.modal_dlg:getChildByName("n_btn")
		
		if not var_23_1.originPosY then
			var_23_1.originPosY = var_23_1:getPositionY()
		end
		
		var_23_1:setPositionY(var_23_1.originPosY - 57)
	else
		if_set_opacity(arg_23_0.vars.modal_dlg, "btn_extract", var_23_0:isExtractable() and 255 or 76.5)
	end
	
	if_set_visible(arg_23_0.vars.modal_dlg, "btn_sell", false)
	if_set_visible(arg_23_0.vars.modal_dlg, "btn_extract", false)
	LuaEventDispatcher:addIfNotEventListener("update.equip.lock", LISTENER(EquipCraftEvent.updateEquipLock, arg_23_0), "craft_event.equip.result.popup")
end

function EquipCraftEvent.updateByResponse(arg_26_0, arg_26_1)
	if arg_26_1.ticket_info then
		arg_26_0.Data:updateTicketInfo(arg_26_1.ticket_info)
	end
	
	if arg_26_1.craft_info then
		arg_26_0.Data:updateCraftInfo(arg_26_1.craft_info)
	end
	
	if arg_26_1.preview_item then
		arg_26_0.Data:updateEventPreviewEquip(arg_26_1.preview_item)
	end
	
	if arg_26_1.optional_item then
		arg_26_0.Data:updateEventOptionalEquip(arg_26_1.optional_item)
	end
end

function EquipCraftEvent.getUIFolder(arg_27_0)
	return "wnd"
end

EquipCraftEvent.Data = {}

local var_0_4 = EquipCraftEvent.Data

function var_0_4.findActiveCraftEventSchedule(arg_28_0)
	local var_28_0 = arg_28_0.vars.event_info.equip_craft_event_schedules
	
	return EquipCraftEventUtil:findActiveCraftEventSchedule(var_28_0)
end

function var_0_4.findCollectCraftLimits(arg_29_0, arg_29_1)
	local var_29_0 = "ec:" .. arg_29_1
	local var_29_1 = arg_29_0.vars.event_info.limits
	local var_29_2
	
	for iter_29_0, iter_29_1 in pairs(var_29_1) do
		if var_29_0 == iter_29_0 then
			var_29_2 = iter_29_1
			
			break
		end
	end
	
	return var_29_2
end

function var_0_4.create(arg_30_0, arg_30_1)
	arg_30_0.vars = {}
	arg_30_0.vars.event_info = arg_30_1
	
	local var_30_0, var_30_1 = arg_30_0:findActiveCraftEventSchedule()
	
	if not var_30_0 then
		return 
	end
	
	arg_30_0.vars.event_id = var_30_0
	arg_30_0.vars.event_schedule = var_30_1
	
	local var_30_2 = arg_30_0:findCollectCraftLimits(arg_30_0.vars.event_id)
	
	arg_30_0.vars.limit_info = var_30_2 or {}
	arg_30_0.vars.info = arg_30_0.vars.event_info.craft_info
	arg_30_0.vars.db = {}
	
	arg_30_0:initDB()
	
	return true
end

function var_0_4.updateInfo(arg_31_0, arg_31_1)
	arg_31_0.vars.info = arg_31_1
end

function var_0_4.initDB(arg_32_0)
	for iter_32_0 = 1, 999 do
		local var_32_0, var_32_1, var_32_2, var_32_3 = DBN("event_equip_craft_data", iter_32_0, {
			"id",
			"set_id",
			"part",
			"equip_id"
		})
		
		if not var_32_0 then
			break
		end
		
		if not arg_32_0.vars.db[var_32_1] then
			arg_32_0.vars.db[var_32_1] = {}
		end
		
		if arg_32_0.vars.db[var_32_1][var_32_2] then
			Log.e("DATA / EVENT INVALID : ALREADY EXISTS")
		end
		
		arg_32_0.vars.db[var_32_1][var_32_2] = {
			set_id = var_32_1,
			part = var_32_2,
			equip_id = var_32_3
		}
	end
end

function var_0_4.getEquipCraftProgress(arg_33_0)
	local var_33_0 = arg_33_0.vars.info
	local var_33_1 = DB("equip_item", var_33_0.code, "id")
	
	if EquipCraftEventUtil:isDataEmpty(var_33_0.set_fx) then
		return 1
	elseif not var_33_1 then
		return 2
	elseif var_33_0.main_stat == nil or var_33_0.main_stat[1] == nil then
		return 3
	elseif var_33_0.sub_stat == nil or table.count(var_33_0.sub_stat) == 0 then
		return 4
	end
	
	return 4
end

function var_0_4.isEquipCraftComplete(arg_34_0)
	return arg_34_0.vars.info.is_complete
end

function var_0_4.getMakeEquipLevel(arg_35_0)
	return 85
end

function var_0_4.getEquipGrade(arg_36_0)
	return 5
end

function var_0_4.getMainStat(arg_37_0)
	return arg_37_0.vars.info.main_stat[1]
end

function var_0_4.getEquipCode(arg_38_0)
	return arg_38_0.vars.info.code
end

function var_0_4.getSetFx(arg_39_0)
	return arg_39_0.vars.info.set_fx
end

function var_0_4.getCraftPoint(arg_40_0)
	local var_40_0 = arg_40_0.vars.limit_info
	local var_40_1 = arg_40_0:getEventTimeRange()
	
	if var_40_0.usable_tm ~= var_40_1.start_time then
		return 0
	end
	
	return arg_40_0.vars.limit_info.score1 or 0
end

function var_0_4.setCraftPoint(arg_41_0, arg_41_1)
	arg_41_0.vars.limit_info.score1 = arg_41_1
end

function var_0_4.getEventTimeRange(arg_42_0)
	return arg_42_0.vars.event_schedule
end

function var_0_4.getEventPreviewEquip(arg_43_0)
	return arg_43_0.vars.info.preview_item
end

function var_0_4.getEventOptionalEquip(arg_44_0)
	return arg_44_0.vars.info.optional_item
end

function var_0_4.updateEquipCraftProgress(arg_45_0, arg_45_1)
	arg_45_0.vars.info.progress = arg_45_1
end

function var_0_4.updateEquipCraftComplete(arg_46_0)
	arg_46_0.vars.info.is_complete = arg_46_0.vars.info.progress == 5
end

function var_0_4.updateMakeEquipPart(arg_47_0, arg_47_1)
	arg_47_0.vars.info.code = EquipCraftEventUtil:partToEquipId(arg_47_1)
end

function var_0_4.updateSetFx(arg_48_0, arg_48_1)
	arg_48_0.vars.info.set_fx = arg_48_1
end

function var_0_4.updateEventPreviewEquip(arg_49_0, arg_49_1)
	arg_49_0.vars.info.preview_item = arg_49_1
end

function var_0_4.updateEventOptionalEquip(arg_50_0, arg_50_1)
	arg_50_0.vars.info.optional_item = arg_50_1
end

function var_0_4.updateCraftInfo(arg_51_0, arg_51_1)
	arg_51_0.vars.info = arg_51_1
end

function var_0_4.updateTicketInfo(arg_52_0, arg_52_1)
	arg_52_0.vars.limit_info = arg_52_1
end

function var_0_4.isCanUseCraftPoint(arg_53_0, arg_53_1)
	return arg_53_0:getCraftPoint() - arg_53_1 >= 0
end

function var_0_4.isGenerated(arg_54_0)
	return arg_54_0.vars.info.generate
end

function var_0_4.isOverTime(arg_55_0)
	local var_55_0 = arg_55_0.vars.event_id
	local var_55_1 = arg_55_0.vars.event_schedule
	
	return EquipCraftEventUtil:getRemainTimeBase(var_55_0, var_55_1) <= 0
end

function var_0_4.isEventGraceTime(arg_56_0)
	local var_56_0 = arg_56_0.vars.event_id
	local var_56_1 = arg_56_0.vars.event_schedule
	local var_56_2 = EquipCraftEventUtil:getRemainTimeBase(var_56_0, var_56_1)
	
	return EquipCraftEventUtil:isEventGraceTimeBase(var_56_2)
end

function var_0_4.getRemainDateByString(arg_57_0)
	local var_57_0 = arg_57_0.vars.event_id
	local var_57_1 = arg_57_0.vars.event_schedule
	local var_57_2 = EquipCraftEventUtil:getRemainTimeBase(var_57_0, var_57_1)
	
	return EquipCraftEventUtil:getRemainDateByStringBase(var_57_2)
end

function var_0_4.useCraftPoint(arg_58_0, arg_58_1)
	if not arg_58_0:isCanUseCraftPoint(arg_58_1) then
		Log.e("ATTEMP TO A MINUS CARFT POINT. PLEASE CHECK BEFORE USE")
		
		return 
	end
	
	local var_58_0 = arg_58_0:getCraftPoint()
	
	arg_58_0:setCraftPoint(var_58_0 - arg_58_1)
end

function var_0_4.getEventId(arg_59_0)
	return arg_59_0.vars.event_id
end

local function var_0_5(arg_60_0)
	local var_60_0 = os.date("%Y", arg_60_0)
	local var_60_1 = os.date("%m", arg_60_0)
	local var_60_2 = os.date("%d", arg_60_0)
	local var_60_3 = os.date("%H", arg_60_0)
	local var_60_4 = os.date("%M", arg_60_0)
	
	return var_60_0, var_60_1, var_60_2, var_60_3, var_60_4
end

function var_0_4.getTimeText(arg_61_0)
	local var_61_0 = arg_61_0:getEventTimeRange()
	local var_61_1 = table.clone(var_61_0)
	
	var_61_1.end_time = var_61_1.end_time - 604800
	
	local var_61_2, var_61_3, var_61_4, var_61_5, var_61_6 = var_0_5(var_61_1.start_time)
	local var_61_7, var_61_8, var_61_9, var_61_10, var_61_11 = var_0_5(var_61_1.end_time)
	
	return T("ui_equip_craft_time", {
		start_year = var_61_2,
		start_month = var_61_3,
		start_day = var_61_4,
		start_hour = var_61_5,
		start_min = var_61_6,
		end_year = var_61_7,
		end_month = var_61_8,
		end_day = var_61_9,
		end_hour = var_61_10,
		end_min = var_61_11
	})
end

function var_0_4.getEquipParts(arg_62_0)
	return {
		"weapon",
		"helm",
		"armor",
		"boot",
		"neck",
		"ring"
	}
end

function var_0_4.getEquipDatas(arg_63_0, arg_63_1)
	local var_63_0 = arg_63_0:getEquipParts()
	local var_63_1 = {}
	
	for iter_63_0, iter_63_1 in pairs(var_63_0) do
		var_63_1[iter_63_1] = arg_63_0:getEquipId(arg_63_1, iter_63_1)
	end
	
	return var_63_1
end

function var_0_4.getEquipId(arg_64_0, arg_64_1, arg_64_2)
	if not arg_64_0.vars.db[arg_64_1] then
		Log.e("INVALID. NO DATA FROM DB : ", arg_64_1)
		
		return 
	end
	
	return arg_64_0.vars.db[arg_64_1][arg_64_2]
end

function var_0_4.getEquipCraftEventInfo(arg_65_0)
	return {
		lvl = arg_65_0:getMakeEquipLevel(),
		main_stat = arg_65_0:getMainStat(),
		code = arg_65_0:getEquipCode(),
		set_fx = arg_65_0:getSetFx(),
		is_complete = arg_65_0:isEquipCraftComplete(),
		equip_grade = arg_65_0:getEquipGrade(),
		progress = arg_65_0:getEquipCraftProgress(),
		event_range = arg_65_0:getEventTimeRange(),
		event_range_text = arg_65_0:getTimeText(),
		craft_point = arg_65_0:getCraftPoint(),
		event_id = arg_65_0:getEventId()
	}
end

EquipCraftEvent.UI = {}

function EquipCraftEvent.UI.updateRing(arg_66_0, arg_66_1, arg_66_2)
	EquipCraftEvent.Ring:updateRing(arg_66_1, arg_66_2)
end
