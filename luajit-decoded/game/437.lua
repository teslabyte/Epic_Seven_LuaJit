PetAffectionPopup = {}

function HANDLER.pet_favorabililty_p(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_close" then
		PetAffectionPopup:close()
	elseif arg_1_1 == "btn_Help" then
		HelpGuide:open({
			contents_id_save = true,
			contents_id = "infopet_4"
		})
	end
end

function PetAffectionPopup.show(arg_2_0)
	if arg_2_0.vars and get_cocos_refid(arg_2_0.vars.dlg) then
		BackButtonManager:pop("pet_favorabililty_p")
		arg_2_0.vars.dlg:removeFromParent()
	end
	
	arg_2_0.vars = {}
	arg_2_0.vars.dlg = load_dlg("pet_favorabililty_p", nil, "wnd", function()
		PetAffectionPopup:close()
	end)
	
	local var_2_0 = SceneManager:getRunningNativeScene()
	local var_2_1 = arg_2_0.vars.dlg:getChildByName("n_pet_favorabililty")
	
	arg_2_0.vars.listView = ItemListView_v2:bindControl(var_2_1)
	
	local var_2_2 = load_control("wnd/pet_favorabililty_card.csb")
	local var_2_3 = {
		onUpdate = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
			arg_2_0:updateItem(arg_4_1, arg_4_3)
			
			return arg_4_3.id
		end
	}
	
	arg_2_0.vars.listView:setRenderer(var_2_2, var_2_3)
	arg_2_0.vars.listView:removeAllChildren()
	arg_2_0:setDataSource()
	var_2_0:addChild(arg_2_0.vars.dlg)
	
	local var_2_4 = arg_2_0.vars.dlg:getChildByName("n_help")
	local var_2_5 = arg_2_0.vars.dlg:getChildByName("txt_title")
	
	if get_cocos_refid(var_2_4) and get_cocos_refid(var_2_5) then
		local var_2_6 = 38
		
		var_2_4:setPositionX(var_2_6 + var_2_5:getContentSize().width * var_2_5:getScaleX() + var_2_5:getPositionX())
	end
end

function PetAffectionPopup.setDataSource(arg_5_0)
	arg_5_0.vars.data = {}
	
	local var_5_0 = 0
	
	for iter_5_0 = 1, 9999 do
		local var_5_1, var_5_2, var_5_3, var_5_4 = DBN("pet_affection", iter_5_0, {
			"id",
			"name",
			"exp",
			"grade"
		})
		
		if not var_5_1 then
			break
		end
		
		table.insert(arg_5_0.vars.data, {
			id = var_5_1,
			name = var_5_2,
			exp = var_5_3,
			need_grade = var_5_4,
			start_exp = var_5_0,
			lv = iter_5_0
		})
		
		var_5_0 = var_5_3
	end
	
	arg_5_0.vars.listView:setDataSource(arg_5_0.vars.data)
end

function PetAffectionPopup.updateItem(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_2.exp - 1
	local var_6_1 = arg_6_1:getChildByName("txt")
	
	if arg_6_2.lv < GAME_STATIC_VARIABLE.max_pet_favor then
		if_set(var_6_1, nil, arg_6_2.start_exp .. " - " .. var_6_0)
	else
		if_set(var_6_1, nil, arg_6_2.exp)
	end
	
	UIUserData:call(var_6_1, "SINGLE_WSCALE(100)", {
		origin_scale_x = 0.82
	})
	
	for iter_6_0 = 1, 6 do
		if_set_visible(arg_6_1, "star" .. iter_6_0, false)
	end
	
	for iter_6_1 = 1, arg_6_2.need_grade do
		if_set_visible(arg_6_1, "star" .. iter_6_1, true)
	end
	
	if_set(arg_6_1, "txt_generation", T(arg_6_2.name))
	if_set(arg_6_1, "txt_level", arg_6_2.lv)
	UIUtil:updatePetFavIcon(arg_6_1:getChildByName("icon"), nil, {
		fav_level = arg_6_2.lv
	})
	
	if arg_6_2.lv == 5 then
		if_set_visible(arg_6_1, "n_skill1", false)
		if_set_visible(arg_6_1, "n_skill2", true)
	else
		if_set_visible(arg_6_1, "n_skill1", true)
		if_set_visible(arg_6_1, "n_skill2", false)
	end
end

function PetAffectionPopup.close(arg_7_0)
	if not get_cocos_refid(arg_7_0.vars.dlg) then
		return 
	end
	
	BackButtonManager:pop("pet_favorabililty_p")
	arg_7_0.vars.dlg:removeFromParent()
	
	arg_7_0.vars = nil
end
