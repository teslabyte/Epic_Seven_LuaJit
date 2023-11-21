CollectionPetDetail = {}

function HANDLER.dict_pet_item(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_item_select" then
		if not arg_1_0.is_selectable then
			return 
		end
		
		CollectionPetDetail:onSelectItem(arg_1_0.index, arg_1_0)
	end
end

function HANDLER.dict_pet_detail(arg_2_0, arg_2_1)
	if arg_2_1 == "btn_voice" then
		CollectionPetDetail:playPetSound()
	end
end

function CollectionPetDetail.playPetSound(arg_3_0)
	local var_3_0 = DB("pet_character", arg_3_0.vars.info.id, {
		"race"
	})
	
	SoundEngine:play("event:/ui/pet/" .. var_3_0)
end

function CollectionPetDetail.onSelectItem(arg_4_0, arg_4_1, arg_4_2)
	if arg_4_0.vars.prv_index == arg_4_1 then
		return 
	end
	
	arg_4_0:updateRight(arg_4_1)
	arg_4_0:updateCenter(arg_4_1)
	
	if arg_4_0.vars.prv_cont then
		if_set_visible(arg_4_0.vars.prv_cont.parent, "_select", false)
	end
	
	if arg_4_2 then
		if_set_visible(arg_4_2.parent, "_select", true)
	end
	
	arg_4_0.vars.prv_index = arg_4_1
	arg_4_0.vars.prv_cont = arg_4_2
end

function CollectionPetDetail.setupCharacteristic(arg_5_0)
	local var_5_0 = arg_5_0.vars.wnd:findChildByName("RIGHT")
	local var_5_1 = string.sub(arg_5_0.vars.info.id, 0, -2)
	
	if arg_5_0.vars.is_feature then
		var_5_1 = var_5_1 .. "1"
	else
		var_5_1 = var_5_1 .. "u"
	end
	
	local var_5_2, var_5_3, var_5_4, var_5_5 = DB("pet_character", var_5_1, {
		"type",
		"model_1",
		"model_3",
		"model_5"
	})
	
	if arg_5_0.vars.is_feature then
		if_set(var_5_0, "txt", T("ui_pet_dic_normal"))
		if_set_sprite(var_5_0, "role", UIUtil:getTypeIconPath(var_5_2, nil))
	else
		if_set(var_5_0, "txt", T("ui_pet_dic_special"))
		if_set_sprite(var_5_0, "role", UIUtil:getTypeIconPath(var_5_2, "y"))
	end
	
	var_5_0:findChildByName("role"):setScale(0.8)
	
	arg_5_0.vars.model_data_u = {
		var_5_3,
		var_5_4,
		var_5_5
	}
end

function CollectionPetDetail.updateRight(arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0.vars.wnd:findChildByName("RIGHT"):getChildByName("n_pet_item")
	local var_6_1 = {
		1,
		3,
		5
	}
	
	arg_6_0:setModelToSlot(var_6_0, arg_6_0.vars.model_data_u[arg_6_1], var_6_1[arg_6_1], arg_6_1)
end

function CollectionPetDetail.updateCenter(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0.vars.wnd:findChildByName("CENTER"):findChildByName("n_pos")
	
	var_7_0:removeAllChildren()
	var_7_0:addChild(CACHE:getModel(arg_7_0.vars.model_data[arg_7_1]))
end

function CollectionPetDetail.setupCenter(arg_8_0)
	local var_8_0 = arg_8_0.vars.wnd:findChildByName("LEFT")
	local var_8_1 = {
		lobby = "pet_type_lobby",
		battle = "pet_type_battle"
	}
	local var_8_2, var_8_3, var_8_4, var_8_5, var_8_6 = DB("pet_character", arg_8_0.vars.info.id, {
		"name",
		"desc",
		"race",
		"type",
		"feature"
	})
	
	if_set(var_8_0, "txt_name", T(var_8_2))
	if_set(var_8_0, "txt_role", T(var_8_1[var_8_5]))
	
	local var_8_7 = UIUtil:getTypeIconPath(var_8_5, var_8_6)
	
	if_set_sprite(var_8_0, "role", var_8_7)
	
	local var_8_8 = T("pet_info_race", {
		race = T(var_8_4)
	}) .. "\n" .. T(var_8_3)
	
	if_set(var_8_0, "txt_story", var_8_8)
	if_set_visible(var_8_0, "star1", false)
	
	arg_8_0.vars.is_feature = var_8_6 == "y"
end

function CollectionPetDetail.setModelToSlot(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	local var_9_0
	local var_9_1 = arg_9_1:findChildByName("dict_pet_item")
	
	if var_9_1 then
		var_9_1:removeFromParent()
	end
	
	local var_9_2 = load_control("wnd/dict_pet_item.csb")
	local var_9_3 = var_9_2:getChildByName("pet_footboard"):getPositionX() - var_9_2:getChildByName("n_stars"):getPositionX()
	local var_9_4 = 30.509999999999998
	
	for iter_9_0 = 1, 6 do
		local var_9_5 = "star" .. iter_9_0
		
		if_set_visible(var_9_2, var_9_5, iter_9_0 <= arg_9_3)
		var_9_2:getChildByName(var_9_5):setPositionX(var_9_3 + var_9_4 / 2 * (iter_9_0 - arg_9_4))
	end
	
	if_set_visible(var_9_2, "n_pos", arg_9_2 ~= nil)
	
	if arg_9_2 then
		local var_9_6 = CACHE:getModel(arg_9_2)
		local var_9_7 = var_9_2:findChildByName("n_pos")
		
		var_9_7:removeAllChildren()
		var_9_7:addChild(var_9_6)
	end
	
	arg_9_1:addChild(var_9_2)
	
	return var_9_2
end

function CollectionPetDetail.setupGradeDiffModels(arg_10_0)
	local var_10_0 = arg_10_0.vars.wnd:findChildByName("panel_pet")
	local var_10_1, var_10_2, var_10_3 = DB("pet_character", arg_10_0.vars.info.id, {
		"model_1",
		"model_3",
		"model_5"
	})
	
	arg_10_0.vars.model_data = {
		var_10_1,
		var_10_2,
		var_10_3
	}
	
	local var_10_4 = {
		1,
		3,
		5
	}
	
	for iter_10_0 = 1, 3 do
		local var_10_5 = var_10_0:findChildByName("n_pet_item" .. iter_10_0)
		local var_10_6 = arg_10_0:setModelToSlot(var_10_5, arg_10_0.vars.model_data[iter_10_0], var_10_4[iter_10_0], iter_10_0):findChildByName("btn_item_select")
		
		var_10_6.is_selectable = true
		var_10_6.index = iter_10_0
		var_10_6.parent = var_10_5
	end
end

function CollectionPetDetail.open(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	arg_11_0.vars = {}
	arg_11_0.vars.parent = arg_11_1
	arg_11_0.vars.info = arg_11_2
	arg_11_0.vars.wnd = load_dlg("dict_pet_detail", true, "wnd")
	
	arg_11_0.vars.parent:addChild(arg_11_0.vars.wnd)
	TopBarNew:createFromPopup(T("system_051_title"), arg_11_0.vars.parent, function()
		arg_11_3()
	end)
	arg_11_0:setupGradeDiffModels()
	arg_11_0:setupCenter()
	arg_11_0:setupCharacteristic()
	
	local var_11_0 = arg_11_0.vars.wnd:findChildByName("n_pet_item1"):findChildByName("btn_item_select")
	
	arg_11_0:onSelectItem(1, var_11_0)
end
