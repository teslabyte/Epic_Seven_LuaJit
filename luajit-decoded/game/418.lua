EquipCraftEvent = EquipCraftEvent or {}
EquipCraftEvent.Main = {}
EquipCraftEvent.Main.Data = {}
EquipCraftEvent.Main.UI = {}

function HANDLER.equip_craft_event_main(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_point_info" then
	end
	
	if arg_1_1 == "btn_start" then
		EquipCraftEvent.Main:start()
	end
end

function EquipCraftEvent.Main.onEnter(arg_2_0, arg_2_1)
	arg_2_0.vars = {}
	
	EquipCraftEvent.Ring:setMode("Main")
	arg_2_0.Data:onEnter()
	arg_2_0.UI:onEnter(arg_2_1, EquipCraftEvent.Data:getEquipCraftEventInfo())
	
	arg_2_0.vars.layer = arg_2_1
end

function EquipCraftEvent.Main.onLeave(arg_3_0)
	if not arg_3_0.vars then
		return 
	end
	
	arg_3_0.UI:onLeave()
	arg_3_0.Data:onLeave()
	
	arg_3_0.vars = nil
end

function EquipCraftEvent.Main.showPointInfo(arg_4_0)
	arg_4_0.UI:showPointInfo()
end

function EquipCraftEvent.Main.start(arg_5_0)
	if EquipCraftEvent.Data:isGenerated() then
		balloon_message_with_sound("[WIP TEXT] 이미 만들었어요~")
		
		return 
	end
	
	EquipCraftEvent:jumpToLastProgress()
end

local var_0_0 = EquipCraftEvent.Main.UI

function var_0_0.onEnter(arg_6_0, arg_6_1, arg_6_2)
	arg_6_0.vars = {}
	arg_6_0.vars.dlg = load_dlg("equip_craft_event_main", true, EquipCraftEvent:getUIFolder())
	
	arg_6_0:updateStatus(arg_6_0.vars.dlg, arg_6_2)
	arg_6_0:portraitInit()
	
	local var_6_0 = EquipCraftEvent.Data:isEventGraceTime()
	
	if_set_visible(arg_6_0.vars.dlg, "close_info", var_6_0)
	
	if var_6_0 then
		if_set(arg_6_0.vars.dlg, "t_event_close_time", T("equip_craft_event_main_close_time", {
			remain_time = EquipCraftEvent.Data:getRemainDateByString()
		}))
	end
	
	arg_6_1:addChild(arg_6_0.vars.dlg)
end

function var_0_0.onLeave(arg_7_0)
	if not arg_7_0.vars then
		return 
	end
	
	arg_7_0.vars.dlg:removeFromParent()
	
	arg_7_0.vars = nil
end

function var_0_0.portraitInit(arg_8_0)
	local var_8_0 = EquipCraftEvent.Data:getEventId()
	local var_8_1 = DB("event_equip_craft", var_8_0, "npc_portrait")
	local var_8_2, var_8_3 = UIUtil:getPortraitAni(var_8_1, {})
	
	if not var_8_3 then
		var_8_2 = UIUtil:getPortraitAni("c1049", {})
		
		var_8_2:setScale(0.5)
		var_8_2:setPosition(45, 170)
	end
	
	if var_8_2 then
		arg_8_0.vars.dlg:findChildByName("n_portrait"):addChild(var_8_2)
		var_8_2:setName("@portrait")
		
		arg_8_0.vars.portrait = var_8_2
	end
	
	arg_8_0.vars.dlg:getChildByName("n_balloon"):setScale(0)
	UIUtil:playNPCSoundAndTextRandomly("equip_craft.idle", arg_8_0.vars.dlg, "txt_balloon", nil, "equip_craft.idle")
end

function var_0_0.updateStatus(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = EquipCraftEvent.Data:isGenerated()
	
	if_set_visible(arg_9_1, "n_craft_before", not var_9_0)
	if_set_visible(arg_9_1, "n_craft_complete", var_9_0)
	
	local var_9_1 = "bg_effect"
	
	if var_9_0 then
		var_9_1 = "bg_effect_complete_move"
	end
	
	EquipCraftEvent.UI:updateRing(arg_9_1, arg_9_2)
	
	if not var_9_0 then
		arg_9_0:updateStatusForCraftBefore(arg_9_1:findChildByName("n_craft_before"), arg_9_2)
	else
		arg_9_0:updateStatusForCraftAfter(arg_9_1:findChildByName("n_craft_after"), arg_9_2)
	end
	
	EffectManager:Play({
		z = 99999,
		fn = "ui_town_smith_bg_effect.cfx",
		layer = arg_9_0.vars.dlg:getChildByName(var_9_1)
	})
	if_set(arg_9_1, "t_event_time", arg_9_2.event_range_text)
end

function var_0_0.updateStatusForCraftBefore(arg_10_0, arg_10_1, arg_10_2)
end

function var_0_0.updateStatusForCraftAfter(arg_11_0, arg_11_1, arg_11_2)
end

local var_0_1 = EquipCraftEvent.Main.Data

function var_0_1.onEnter(arg_12_0)
	arg_12_0.vars = {}
end

function var_0_1.onLeave(arg_13_0)
	arg_13_0.vars = nil
end
