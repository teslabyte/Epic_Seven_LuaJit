LotaBlessingUI = {}

function HANDLER.clan_heritage_blessing(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_blessing" then
		LotaBlessingUI:request()
	end
	
	if arg_1_1 == "btn_close" then
		LotaBlessingUI:close()
	end
	
	if arg_1_1 == "btn_remove" then
		local var_1_0 = arg_1_0:getParent()
		
		LotaBlessingUI:remove(var_1_0.idx)
	end
end

function LotaBlessingUI.init(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0.vars = {}
	arg_2_0.vars.max_bless_unit_cnt = DB("clan_heritage_config", "max_goddess_hero", "client_value") or 1
	arg_2_0.vars.dlg = LotaUtil:getUIDlg("clan_heritage_blessing")
	arg_2_0.vars.object = arg_2_2
	arg_2_0.vars.selected_units = {}
	
	BackButtonManager:push({
		check_id = "clan_heritage_blessing",
		back_func = function()
			arg_2_0:close()
		end
	})
	arg_2_1:addChild(arg_2_0.vars.dlg)
	
	arg_2_0.vars.parent_layer = arg_2_1
	
	arg_2_0:setupUI()
	arg_2_0:setupHeroBelt()
end

function LotaBlessingUI.isActive(arg_4_0)
	return arg_4_0.vars and get_cocos_refid(arg_4_0.vars.dlg)
end

function LotaBlessingUI.getTileId(arg_5_0)
	return arg_5_0.vars.object:getTileId()
end

function LotaBlessingUI.makeBlessingConfirmUI(arg_6_0)
	local var_6_0 = load_dlg("clan_heritage_blessing_confirm", true, "wnd")
	
	var_6_0:findChildByName("n_hero_odd"):setName("n_slot_odd")
	var_6_0:findChildByName("n_hero_even"):setName("n_slot_even")
	var_6_0:findChildByName("n_eff"):removeFromParent()
	var_6_0:findChildByName("btn_ok"):setName("btn_yes")
	
	local var_6_1 = {
		"n_face_icon3",
		"n_face_icon1",
		"n_face_icon2",
		"n_face_icon4"
	}
	local var_6_2, var_6_3, var_6_4 = arg_6_0:getNodeOrder(var_6_0, table.count(arg_6_0.vars.selected_units), var_6_1)
	local var_6_5 = 1
	
	for iter_6_0, iter_6_1 in pairs(var_6_3) do
		local var_6_6 = var_6_2:findChildByName(iter_6_1)
		
		if var_6_6 then
			local var_6_7 = table.find(var_6_4, iter_6_1)
			
			if_set_visible(var_6_6, iter_6_1, var_6_7)
			
			if var_6_7 then
				local var_6_8 = arg_6_0.vars.selected_units[var_6_5]
				local var_6_9 = UIUtil:getRewardIcon(nil, var_6_8.db.code, {
					no_popup = true,
					role = true,
					no_db_grade = true,
					lv = var_6_8:getLv(),
					grade = var_6_8:getGrade(),
					zodiac = var_6_8:getZodiacGrade() or 0
				})
				
				var_6_6:addChild(var_6_9)
				
				var_6_5 = var_6_5 + 1
			end
		end
	end
	
	if_set_visible(var_6_2, nil, true)
	
	return var_6_0
end

function LotaBlessingUI.request(arg_7_0)
	if table.empty(arg_7_0.vars.selected_units) then
		balloon_message_with_sound("msg_clan_heritage_goddess_no_hero")
		
		return 
	end
	
	local var_7_0 = {}
	
	for iter_7_0, iter_7_1 in pairs(arg_7_0.vars.selected_units) do
		table.insert(var_7_0, iter_7_1:getUID())
	end
	
	local var_7_1 = arg_7_0:makeBlessingConfirmUI()
	
	Dialog:msgBox(nil, {
		yesno = true,
		dlg = var_7_1,
		handler = function()
			LotaNetworkSystem:sendQuery("lota_interaction_object", {
				tile_id = arg_7_0.vars.object:getTileId(),
				uid_list = json.encode(var_7_0)
			})
		end
	})
end

function LotaBlessingUI.close(arg_9_0)
	if arg_9_0.vars and get_cocos_refid(arg_9_0.vars.dlg) then
		BackButtonManager:pop("clan_heritage_blessing")
		
		local var_9_0 = arg_9_0.vars.parent_layer:findChildByName("npc_priest_bg_pati")
		
		if var_9_0 then
			var_9_0:removeFromParent()
		end
		
		arg_9_0.vars.dlg:removeFromParent()
		
		arg_9_0.vars.dlg = nil
		arg_9_0.vars = nil
	end
end

function LotaBlessingUI.onHeroListEvent(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	if arg_10_1 == "add" then
		arg_10_0:onSelect(arg_10_2)
	else
		arg_10_0:setUnitBar(arg_10_1, arg_10_2, arg_10_3)
	end
end

function LotaBlessingUI.onSelect(arg_11_0, arg_11_1)
	if table.count(arg_11_0.vars.selected_units) >= arg_11_0.vars.max_bless_unit_cnt then
		balloon_message_with_sound("msg_clan_heritage_goddess_max")
		
		return 
	end
	
	if LotaUserData:isUsableUnit(arg_11_1) then
		balloon_message_with_sound("msg_clan_heritage_goddess_normal")
		
		return 
	end
	
	table.insert(arg_11_0.vars.selected_units, arg_11_1)
	HeroBelt:popItem(arg_11_1)
	arg_11_0:setupInformations()
end

function LotaBlessingUI.getNodeOrder(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	local var_12_0
	local var_12_1 = arg_12_3 or {
		"slot3",
		"slot1",
		"slot2",
		"slot4"
	}
	local var_12_2 = {}
	
	if arg_12_2 % 2 == 0 then
		var_12_0 = arg_12_1:findChildByName("n_slot_even")
		
		if arg_12_2 == 4 then
			var_12_2 = {
				var_12_1[1],
				var_12_1[2],
				var_12_1[3],
				var_12_1[4]
			}
		elseif arg_12_2 == 2 then
			var_12_2 = {
				var_12_1[2],
				var_12_1[3]
			}
		end
	else
		var_12_0 = arg_12_1:findChildByName("n_slot_odd")
		
		if arg_12_2 == 3 then
			var_12_2 = {
				arg_12_3[3],
				arg_12_3[2],
				arg_12_3[1]
			}
		elseif arg_12_2 == 1 then
			var_12_2 = {
				arg_12_3[2]
			}
		end
	end
	
	return var_12_0, var_12_1, var_12_2
end

function LotaBlessingUI.setupUI(arg_13_0)
	arg_13_0.vars.n_slot, arg_13_0.vars.full_node, arg_13_0.vars.node_order = arg_13_0:getNodeOrder(arg_13_0.vars.dlg, arg_13_0.vars.max_bless_unit_cnt)
	
	for iter_13_0, iter_13_1 in pairs(arg_13_0.vars.full_node) do
		if arg_13_0.vars.n_slot:findChildByName(iter_13_1) then
			if_set_visible(arg_13_0.vars.n_slot, iter_13_1, table.find(arg_13_0.vars.node_order, iter_13_1))
		end
	end
	
	if_set_visible(arg_13_0.vars.n_slot, nil, true)
	if_set(arg_13_0.vars.dlg, "txt_disc", T("ui_clan_heritage_goddess_desc"))
end

function LotaBlessingUI.setUnitBar(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	if arg_14_1 == "change" then
		local var_14_0 = HeroBelt:getControl(arg_14_2)
		
		if var_14_0 then
			if_set_visible(var_14_0, "add", false)
		end
		
		local var_14_1 = LotaUserData:isUsableUnit(arg_14_3)
		local var_14_2 = HeroBelt:getControl(arg_14_3)
		
		if var_14_2 then
			if_set_visible(var_14_2, "add", not var_14_1)
		end
	end
end

function LotaBlessingUI.setupLeftPortrait(arg_15_0)
	local var_15_0 = arg_15_0.vars.dlg:findChildByName("Panel_godness")
	local var_15_1 = UIUtil:getPortraitAni("npc1035")
	
	if var_15_1 then
		var_15_0:addChild(var_15_1)
		var_15_1:setPositionX(150)
		var_15_1:setPositionY(-60)
		var_15_1:setScale(0.6)
	end
	
	UIUtil:playNPCSoundAndTextRandomly("heal.enter", arg_15_0.vars.dlg, "txt_balloon", nil, "heal.idle")
end

function LotaBlessingUI.remove(arg_16_0, arg_16_1)
	local var_16_0 = table.remove(arg_16_0.vars.selected_units, arg_16_1)
	
	if not var_16_0 then
		return 
	end
	
	HeroBelt:revertPoppedItem(var_16_0)
	arg_16_0:setupInformations()
end

function LotaBlessingUI.setupInformations(arg_17_0)
	local var_17_0 = arg_17_0.vars.n_slot
	
	for iter_17_0 = 1, arg_17_0.vars.max_bless_unit_cnt do
		local var_17_1 = arg_17_0.vars.node_order[iter_17_0]
		local var_17_2 = var_17_0:findChildByName(var_17_1)
		local var_17_3 = arg_17_0.vars.selected_units[iter_17_0]
		
		var_17_2.idx = iter_17_0
		
		local var_17_4 = var_17_2:findChildByName("made_unit_bar")
		
		if var_17_3 then
			print("unit???", var_17_3.db.name)
			if_set_visible(var_17_4, nil, true)
			
			if var_17_4 then
				UIUtil:updateUnitBar("LotaBlessing", var_17_3, {
					force_update = true,
					wnd = var_17_4
				})
			else
				local var_17_5 = UIUtil:updateUnitBar("LotaBlessing", var_17_3)
				
				var_17_5:setName("made_unit_bar")
				var_17_2:findChildByName("n_unit_bar"):addChild(var_17_5)
			end
		else
			if_set_visible(var_17_4, nil, false)
		end
	end
end

function LotaBlessingUI.setupHeroBelt(arg_18_0)
	arg_18_0.vars.unit_dock = HeroBelt:create()
	
	arg_18_0.vars.dlg:findChildByName("n_herolist"):addChild(arg_18_0.vars.unit_dock:getWindow())
	arg_18_0.vars.unit_dock:setEventHandler(arg_18_0.onHeroListEvent, arg_18_0)
	
	local var_18_0 = LotaUtil:getLotaUnits()
	
	HeroBelt:resetData(var_18_0, "LotaBlessing", nil, true)
	HeroBelt:showSortButton(false)
	HeroBelt:showAddInvenButton(false)
	arg_18_0.vars.unit_dock:getWindow():setPosition(VIEW_BASE_LEFT, 0)
end
